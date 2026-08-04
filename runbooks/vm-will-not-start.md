# Runbook: Virtual Machine Will Not Start

## Trigger

Use when a VM or LXC workload fails to start under Proxmox VE, VMware ESXi or Hyper-V.

Common causes include:

- Missing storage
- Locked workload
- Insufficient memory
- Invalid configuration
- Failed passthrough device
- Corrupt disk
- Snapshot or backup task conflict
- Cluster/quorum issue
- Host hardware problem

---

## 1. Record the exact error

Do not paraphrase the message before capturing it.

For Proxmox:

```bash
qm start <vmid>
pct start <ctid>
```

Then inspect task output through the UI or logs.

Useful commands:

```bash
qm status <vmid>
qm config <vmid>
pct status <ctid>
pct config <ctid>
pvesm status
pveversion -v
```

---

## 2. Confirm host health

```bash
uptime
free -h
df -h
df -i
pvesm status
journalctl -p warning..alert --since '60 minutes ago'
```

Check:

- Memory availability
- Root filesystem capacity
- Storage status
- Cluster/quorum state
- Hardware alerts
- Recent host reboot/update

---

## 3. Check storage dependencies

A VM cannot start if its disk, ISO, EFI disk, TPM state or attached mount is unavailable.

```bash
qm config <vmid> | grep -E '^(scsi|sata|ide|virtio|efidisk|tpmstate)'
pvesm status
```

For LXC:

```bash
pct config <ctid> | grep '^mp'
findmnt
```

Validate each referenced storage and path.

Do not delete a missing disk reference until confirming whether it represents important data.

---

## 4. Check locks and active tasks

```bash
qm config <vmid> | grep '^lock:'
pct config <ctid> | grep '^lock:'
ps aux | grep -E 'vzdump|qm|pct'
```

A backup, snapshot, migration or interrupted task may leave a lock.

Only unlock after confirming no active task is using the workload:

```bash
qm unlock <vmid>
pct unlock <ctid>
```

Unlocking is not a generic first fix; an active job must not be bypassed.

---

## 5. Check resource allocation

### Memory

- Host has sufficient free/available memory.
- Ballooning/minimum values are sensible.
- Hugepages are available if configured.
- NUMA or memory hotplug settings are valid.

### CPU

- CPU type is supported by the host.
- Migration did not move the VM to an incompatible processor feature set.

### Devices

- Passed-through PCI/USB device exists.
- IOMMU is enabled if required.
- Device is not already owned by another workload.

---

## 6. Review logs

Proxmox examples:

```bash
journalctl -u pvedaemon --since '30 minutes ago'
journalctl -u pveproxy --since '30 minutes ago'
journalctl -k --since '30 minutes ago'
```

Search by VM ID:

```bash
journalctl --since '30 minutes ago' | grep '<vmid>'
```

ESXi/Hyper-V use their platform event and task logs; the same principle applies: identify the failing dependency before changing the workload definition.

---

## 7. Low-risk restoration options

In order of preference:

1. Restore unavailable storage/network path.
2. Allow the existing backup/snapshot task to complete.
3. Correct a clearly invalid path or device reference.
4. Free sufficient host resources.
5. Remove an optional unavailable ISO or USB device.
6. Restore the last known-good configuration.
7. Recover the VM from backup only when disk/configuration damage is confirmed.

Avoid recreating a VM with the same ID or writing to its disks before preserving the existing state.

---

## 8. Validation

After start:

```bash
qm status <vmid>
qm guest cmd <vmid> ping 2>/dev/null || true
```

Or for LXC:

```bash
pct status <ctid>
pct exec <ctid> -- systemctl --failed
```

Then validate:

- Guest operating system boots
- Network and DNS work
- Required storage is present
- Application service runs
- Monitoring is healthy
- No repeated disk/kernel errors appear

A running hypervisor process does not prove the guest application is healthy.

---

## 9. Escalate when

- Disk corruption is suspected
- RAID/storage pool is degraded
- Cluster filesystem or quorum is unhealthy
- Host kernel reports hardware errors
- Backup restore is required
- Passthrough/IOMMU change affects other workloads
- Configuration was altered by an unknown actor

Provide the exact task error, configuration, storage state, host logs and recent-change timeline.

---

## 10. Prevention

- Monitor storage and capacity
- Avoid optional ISO/device dependencies at boot
- Document passthrough requirements
- Verify backups and restoration
- Maintain configuration backups
- Review locks after interrupted maintenance
- Use compatible CPU models for planned migration
- Keep host firmware and hypervisor compatibility documented
