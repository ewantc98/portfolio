# Virtualisation

Proxmox VE is my main homelab platform now. I have also used VMware ESXi 6.5, 6.7 and 7, plus Hyper-V.

I moved more of the lab to Proxmox because it handles Linux containers, VMs and storage in one place without needing extra licensing for the features I use at home.

## VMs or LXC

I use a VM when:

- I need Windows
- the workload needs its own kernel
- I want stronger separation
- the software expects a normal server install
- I am testing an operating system

I use LXC when:

- it is a small Linux service
- low overhead matters
- the application is easy to rebuild
- I want quick backup and restore

I do not put everything into LXC just because it uses less RAM. Bind mounts and permissions can be more awkward, especially with unprivileged containers.

## Proxmox work I have done

- installed and upgraded Proxmox hosts
- created Linux and Windows VMs
- built LXC containers
- attached local and network storage
- mounted SMB-backed data into services
- investigated VM start failures
- changed CPU, memory and disk allocations
- worked with snapshots and backups
- moved workloads between hosts during rebuilds
- used the shell and logs instead of relying only on the web interface

Useful commands:

```bash
pvesm status
qm list
pct list
qm config <vmid>
pct config <ctid>
journalctl -u pvedaemon --since "30 minutes ago"
```

## Resource sizing

I normally start smaller and increase resources after checking actual use.

For example, my Immich container was given 8 GB RAM because photo processing and database activity can be heavier than a simple web service. A DNS container does not need anything close to that.

I avoid giving every VM a large fixed allocation because unused memory and CPU still reduce what is available to the rest of the host.

## Storage dependencies

A VM can be perfectly healthy and still refuse to start if one of its disks is on unavailable storage.

Before changing the VM itself, I check:

```bash
pvesm status
mount
df -h
systemctl --failed
```

I also check whether the VM configuration references a storage ID that has been renamed or removed.

## VMware and Hyper-V

My earlier lab work used Dell and HPE servers with ESXi. That included datastore work, VM networking, virtual switches, guest tools and hardware compatibility.

I have used Hyper-V for Windows-focused testing and where tight Windows integration made more sense.

The concepts transfer between platforms:

- compute
- virtual networking
- storage
- snapshots/checkpoints
- guest drivers
- backup
- host failure

The buttons are different; the dependencies are mostly the same.
