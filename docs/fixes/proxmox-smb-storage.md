# Proxmox could not use an SMB share

## What happened

I added an SMB share for Proxmox resources, but the storage either appeared offline or was visible on the host and unusable by the workload.

## What I checked

### 1. Can the host reach the NAS?

```bash
ping -c 3 10.25.240.10
nc -vz 10.25.240.10 445
```

### 2. Can the account see the share?

```bash
smbclient -L //10.25.240.10 -U <account>
```

### 3. Can Linux mount it outside Proxmox?

```bash
mkdir -p /mnt/test-smb

mount -t cifs //10.25.240.10/proxmox-resources /mnt/test-smb \
  -o username=<account>,vers=3.0
```

If this fails, there is no point changing the Proxmox storage definition yet.

### 4. What does Proxmox think?

```bash
pvesm status
cat /etc/pve/storage.cfg
journalctl --since "20 minutes ago" | grep -iE "cifs|smb|mount"
```

## Things that were easy to get wrong

- share name did not match exactly
- NAS account had read access but not write access
- SMB version mismatch
- NAS firewall allowed the wrong source
- credentials file permissions were too open
- an LXC UID/GID did not match the mounted folder

## Validation

I tested all three layers separately:

1. create a file from the Proxmox host
2. create a file through the Proxmox storage path
3. create a file from inside the VM/container that needed it

A green storage icon in the web interface is not enough if the application still cannot write.
