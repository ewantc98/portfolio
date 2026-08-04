# Storage and backups

Storage has caused more homelab problems than CPU or memory. A service can survive a slow processor. It cannot do much when its data path disappears or becomes read-only.

## Systems I have used

- Synology RackStation
- TrueNAS Scale
- local HPE and Dell RAID storage
- SMB shares
- iSCSI LUNs
- Proxmox storage definitions
- Linux mounts used by VMs and containers

## Current pattern

I try to keep application compute separate from bulk data.

For example:

```text
Proxmox host
  └── Immich LXC
       ├── application and database
       └── mounted photo storage from NAS
```

That is not automatically “better”. It adds a network and permissions dependency. The advantage is that I can rebuild the application host without moving the entire photo library.

## SMB

I use SMB for general shared storage and backup targets.

A typical manual check is:

```bash
smbclient -L //<nas-address> -U <user>
mount -t cifs //<nas-address>/<share> /mnt/test \
  -o username=<user>,vers=3.0
```

For persistent Linux mounts I use a credentials file rather than putting a password directly in `/etc/fstab`.

Example:

```fstab
//10.25.240.10/proxmox-resources /mnt/proxmox-resources cifs credentials=/root/.smb-proxmox,vers=3.0,_netdev,nofail 0 0
```

The file path and account are examples. Credentials are not stored in this repository.

## Container permissions

A mounted share working on the Proxmox host does not guarantee an LXC can write to it.

I check:

```bash
ls -ln /mnt/immich
pct config <ctid>
pct enter <ctid>
id
touch /path/inside/container/test-file
```

The numeric UID/GID matters, especially with unprivileged containers.

## iSCSI

I have used iSCSI to present block storage to virtualisation hosts. It is useful, but it needs more care than a normal file share.

I pay attention to:

- initiator permissions
- target availability
- multipath where relevant
- filesystem ownership
- ensuring the same block device is not mounted unsafely by multiple systems

## Backups

My backup approach is still being improved. I use local NAS storage and off-site copies for selected data.

For an important service I want:

- the application configuration
- the database
- the user data
- a record of the version
- the restore order
- a copy outside the main host

I am adding restore tests because a backup job saying “successful” is not the same as a successful restore.

## What I do not call a backup

- a RAID array
- a snapshot on the same host
- a second copy on the same disk
- sync with no version history
- a backup I have never tried to read
