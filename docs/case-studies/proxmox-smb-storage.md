# Case Study: Proxmox and SMB Storage Integration

## Context

A Linux-hosted application needed access to a large data set held on network-attached storage. The application compute layer was virtualised under Proxmox VE, while the valuable data needed to remain on dedicated storage so it could be backed up and managed independently.

The public example below uses generic names and paths.

---

## Requirement

- Keep the application VM/LXC replaceable.
- Store large user data on a NAS share.
- Prevent credentials from being written directly into `/etc/fstab`.
- Ensure the mount returns after reboot.
- Make the data available inside an LXC container.
- Avoid giving unrelated workloads access to the share.
- Document how to diagnose the service when the NAS is unavailable.

---

## Constraints

- SMB availability depends on network, DNS, NAS health and authentication.
- Unprivileged LXC containers use UID/GID mapping that can make host-mounted permissions confusing.
- Starting an application before the storage mount is ready may cause it to create empty local directories or fail unpredictably.
- A Proxmox snapshot of the container does not automatically protect data stored on the NAS.

---

## Design options considered

### Option 1: Mount SMB directly inside the container

**Advantages**

- Storage configuration remains close to the application.
- The container can be moved with fewer Proxmox-specific mount settings.

**Disadvantages**

- Requires CIFS support and credentials inside the container.
- Privileged operations may be harder in an unprivileged LXC.
- Multiple containers may each need separate mount configuration.

### Option 2: Mount SMB on the Proxmox host and bind-mount it into the container

**Advantages**

- NAS credentials remain on the host.
- The host can validate storage independently of the application.
- Proxmox mount points clearly define which container receives access.

**Disadvantages**

- UID/GID mapping must be understood.
- Container mobility requires the destination host to provide the same path.
- The application depends on both the host mount and the LXC mount point.

### Selected approach

For this workload, the share was mounted on the Proxmox host and passed into the container. This kept NAS authentication outside the application container and made host-level diagnosis straightforward.

---

## Implementation

### 1. Install CIFS support on the Proxmox host

```bash
apt update
apt install --yes cifs-utils
```

### 2. Create a dedicated mount path

```bash
mkdir -p /mnt/nas/appdata
```

The path name identifies the storage purpose rather than using a vague folder such as `/mnt/share`.

### 3. Create a root-only credentials file

```bash
install -m 600 /dev/null /root/.smb-appdata
nano /root/.smb-appdata
```

Example structure:

```ini
username=svc_appdata
password=REDACTED
# domain=LAB
```

The credentials file is excluded from version control and readable only by root.

### 4. Test a manual mount before editing `fstab`

```bash
mount -t cifs //nas.lab.example/appdata /mnt/nas/appdata \
  -o credentials=/root/.smb-appdata,vers=3.0,iocharset=utf8
```

Validation:

```bash
findmnt /mnt/nas/appdata
df -h /mnt/nas/appdata
ls -la /mnt/nas/appdata
```

Testing manually separates authentication/protocol issues from boot-time configuration issues.

### 5. Add a persistent mount

Example `/etc/fstab` entry:

```fstab
//nas.lab.example/appdata /mnt/nas/appdata cifs credentials=/root/.smb-appdata,vers=3.0,iocharset=utf8,_netdev,x-systemd.automount,nofail 0 0
```

Important options:

| Option | Reason |
|---|---|
| `credentials=` | Keeps username/password out of `fstab` |
| `vers=3.0` | Uses a modern SMB dialect when supported |
| `_netdev` | Marks the mount as network-dependent |
| `x-systemd.automount` | Mounts on access and reduces boot blocking |
| `nofail` | Allows the host to boot if the NAS is temporarily unavailable |

`nofail` is appropriate only when the operational impact is understood. It prevents a storage outage from stopping the host boot, but the application still needs monitoring so it does not run against an empty path unnoticed.

Test the entry:

```bash
umount /mnt/nas/appdata
systemctl daemon-reload
mount -a
findmnt /mnt/nas/appdata
```

### 6. Present the host path to the LXC container

Example container ID: `120`.

```bash
pct set 120 -mp0 /mnt/nas/appdata,mp=/srv/appdata
pct config 120
```

After starting or restarting the container:

```bash
pct exec 120 -- findmnt /srv/appdata
pct exec 120 -- ls -la /srv/appdata
```

### 7. Resolve ownership and identity mapping

An unprivileged LXC maps container identities to a host UID/GID range. Therefore, `root` inside the container is not host UID 0.

Checks:

```bash
pct config 120 | grep unprivileged
cat /etc/subuid
cat /etc/subgid
stat -c '%u:%g %n' /mnt/nas/appdata
pct exec 120 -- id
pct exec 120 -- stat -c '%u:%g %n' /srv/appdata
```

Possible approaches include:

- Set SMB mount ownership using `uid=`, `gid=`, `file_mode=` and `dir_mode=`.
- Create a dedicated application user and map the required identity carefully.
- Use NAS-side permissions that match the service account.
- Avoid changing the container to privileged solely to bypass a permissions problem.

A generic example with explicit ownership might look like:

```fstab
//nas.lab.example/appdata /mnt/nas/appdata cifs credentials=/root/.smb-appdata,vers=3.0,_netdev,x-systemd.automount,nofail,uid=<host-mapped-uid>,gid=<host-mapped-gid>,file_mode=0660,dir_mode=0770 0 0
```

The correct IDs must be derived from the actual container mapping; they should not be copied blindly.

---

## Application dependency handling

The application should not be considered healthy merely because the container is running.

Validation sequence:

1. NAS responds on the network.
2. Host resolves the NAS name.
3. SMB mount is active.
4. Expected data is visible at the host path.
5. Bind mount is visible inside the container.
6. Application service can read/write the required path.
7. User-facing application displays existing data.

Example checks:

```bash
getent hosts nas.lab.example
nc -vz nas.lab.example 445
findmnt /mnt/nas/appdata
mountpoint -q /mnt/nas/appdata
pct exec 120 -- mountpoint -q /srv/appdata
pct exec 120 -- systemctl status example-app
```

A sentinel file or directory can help distinguish a real mounted share from an empty local directory:

```bash
test -e /mnt/nas/appdata/.storage-present
```

The application should not start destructive or import operations if the expected sentinel is missing.

---

## Fault scenarios and diagnosis

### `mount error(13): Permission denied`

Check:

- Username/password
- Account lockout or expiry
- Share-level permission
- Filesystem/dataset permission
- Required domain/workgroup
- SMB version
- Whether the NAS restricts access by source address

Useful evidence:

```bash
dmesg | tail -50
journalctl -b | grep -i cifs
smbclient -L //nas.lab.example -U svc_appdata
```

### `mount error(113): No route to host`

Check:

- DNS result
- VLAN and gateway
- Firewall rules
- NAS interface status
- TCP 445 reachability

```bash
getent hosts nas.lab.example
ip route
ping -c 4 nas.lab.example
nc -vz nas.lab.example 445
```

### Mount exists but application sees permission denied

Check:

- Host ownership
- LXC UID/GID mapping
- Application service account
- Mount `file_mode`/`dir_mode`
- NAS ACLs

```bash
namei -l /mnt/nas/appdata
pct exec 120 -- namei -l /srv/appdata
pct exec 120 -- systemctl show example-app -p User -p Group
```

### Container starts while NAS is offline

Risk:

The application may write to the empty local mount-point directory. When the NAS later mounts, those files become hidden beneath the mount.

Prevention:

- Monitor `mountpoint` state.
- Use sentinel-file checks.
- Add service dependencies or pre-start validation.
- Alert on storage absence.
- Avoid automatic application startup where missing storage could cause corruption.

---

## Backup implications

The container backup protects:

- Operating system
- Application packages
- Local configuration
- Local database only if it is stored inside the container and captured consistently

It does **not** automatically protect:

- NAS-hosted user data
- NAS snapshots
- Remote backup copies
- Credentials stored only on the Proxmox host

The recovery plan therefore includes:

1. Restore or rebuild the Proxmox/LXC compute layer.
2. Restore NAS availability and share permissions.
3. Recreate the host mount and credentials file.
4. Reapply the LXC mount point.
5. Restore application database/configuration if necessary.
6. Validate data and application consistency.

---

## Rollback plan

If the bind-mounted design caused unexpected issues:

1. Stop the application cleanly.
2. Remove or disable the LXC `mp0` mount point.
3. Confirm no data was written to the local hidden mount directory.
4. Restore the previous application data path/configuration.
5. Start and validate the application.
6. Preserve logs and configuration for review.

---

## Outcome

The final design separated application compute from bulk data, kept NAS credentials on the host, and made storage availability independently testable. It also made the dependency chain explicit: network → DNS → SMB → host mount → LXC mount → application.

---

## Lessons learned

- A successful `mount` is only the first validation step; application identity must also be tested.
- Unprivileged LXC identity mapping should be understood rather than bypassed.
- `nofail` improves host resilience but can hide an application-impacting storage outage.
- A sentinel check reduces the risk of applications writing into an unmounted local directory.
- Container backups and NAS backups protect different parts of the service.
- Documentation must include recovery order, not only installation commands.
