# Runbook: Network Storage Unavailable

## Trigger

Use when a NAS share, SMB/CIFS mount, NFS export, iSCSI target or application data path becomes unavailable.

Potential impact includes:

- Applications showing empty libraries
- Backups failing
- VM/LXC workloads unable to start
- Permission errors
- Files unavailable to users
- Services writing to an unintended local directory

---

## 1. Protect data first

If an application expects a mounted path but the mount is absent:

- Stop the application if it may write into the empty local directory.
- Do not recreate, import or delete data until the real storage state is confirmed.
- Do not run filesystem repair against the wrong device.
- Preserve logs and mount output.

Check:

```bash
mountpoint -q /srv/appdata
echo $?
findmnt /srv/appdata
ls -la /srv/appdata
```

A directory existing does not prove the expected filesystem is mounted.

---

## 2. Confirm scope

Determine:

- One client or all clients?
- One share or the entire NAS?
- Authentication failure or network timeout?
- Read-only, slow or completely unavailable?
- Did the issue follow a reboot, password change, network change or NAS update?

---

## 3. Check network and DNS

```bash
getent hosts nas.lab.example
ping -c 4 nas.lab.example
ip route
nc -vz nas.lab.example 445
```

For NFS, test the required service ports or use platform-specific tools. For iSCSI, confirm target reachability and session state.

---

## 4. Check mount and kernel evidence

```bash
findmnt
mount | grep -E 'cifs|nfs'
systemctl status remote-fs.target --no-pager
journalctl -b | grep -Ei 'cifs|nfs|mount|iscsi'
dmesg | tail -100
```

For a named mount unit:

```bash
systemctl status mnt-nas-appdata.mount --no-pager
```

---

## 5. Check authentication and permissions

For SMB:

```bash
smbclient -L //nas.lab.example -U <service-account>
```

Review:

- Credential file exists and is root-only
- Password/account has not expired
- Share permission
- Dataset/filesystem ACL
- Source-address restrictions
- SMB dialect
- Domain/workgroup requirement

Do not paste credentials directly into shell history or tickets.

---

## 6. Test manual mount

After recording current state:

```bash
sudo mount -v /srv/appdata
findmnt /srv/appdata
```

Or test an isolated temporary path:

```bash
sudo mkdir -p /mnt/test-share
sudo mount -t cifs //nas.lab.example/appdata /mnt/test-share \
  -o credentials=/root/.smb-appdata,vers=3.0
```

Testing an isolated path avoids hiding local files beneath the normal mount point.

---

## 7. Check dependent workloads

For Proxmox:

```bash
pvesm status
pct config <ctid>
qm config <vmid>
```

For an LXC bind mount:

```bash
pct exec <ctid> -- findmnt /srv/appdata
```

For Docker:

```bash
docker compose ps
docker compose logs --tail=100
```

Confirm the application sees the mounted filesystem and correct ownership before restart.

---

## 8. Restoration

Possible actions, from lowest to higher risk:

1. Correct DNS or route.
2. Restore NAS service/network interface.
3. Unlock or correct the service account.
4. Correct share or filesystem permission.
5. Remount the share.
6. Restore the dependent VM/container mount.
7. Start the application only after storage validation.

Avoid rebooting every component at once; this removes evidence and obscures the root cause.

---

## 9. Validation

```bash
findmnt /srv/appdata
df -h /srv/appdata
stat /srv/appdata/.storage-present
```

Then validate:

- Expected files are present
- Application account can read/write as required
- No data was written to the hidden local directory
- Backup job can reach the target
- Monitoring is healthy
- Application displays existing data

---

## 10. Escalation

Escalate immediately when:

- Multiple disks or a storage pool are degraded
- Filesystem corruption is suspected
- Data has been overwritten or deleted
- RAID rebuild is failing
- NAS hardware is unstable
- Recovery requires snapshot rollback or backup restoration
- Credentials or access may be compromised

Provide storage logs, pool/array state, affected paths, timeline and actions taken.

---

## Prevention

- Monitor mount state and sentinel file
- Alert on backup age and failed jobs
- Restrict share access to required systems
- Use service accounts rather than personal credentials
- Document mount options and identity mapping
- Test NAS and application recovery separately
- Maintain capacity alerts
- Avoid storing the only credentials/configuration on the failed host
