# Hardware

This is the main hardware I own or have used in the lab. Not all of it is powered on at once.

## Servers

| Hardware | Specification / use |
|---|---|
| HPE ProLiant DL20 Gen9 | 64 GB RAM, two 300 GB 15K SAS disks, four 2.5-inch bays. Used as a compact Proxmox host. |
| HPE ProLiant DL360 Gen9 | Six 600 GB SAS disks and mixed memory configuration. Used for larger VM and storage tests. |
| Dell PowerEdge R430 (two units) | Used for VMware/Proxmox testing and learning Dell server management. |
| Dell PowerEdge R320 | Older lab host used for virtualisation and storage work. |
| Supermicro X10SDV-TLN4F | Low-power server platform with multiple network interfaces. Useful for firewall, storage and compact virtualisation tests. |
| Small Intel box | Core i5, 8 GB RAM and 256 GB storage. Used for lightweight services and AI experiments. |
| NVIDIA Quadro M2000 | 4 GB GPU used for testing hardware-accelerated workloads where supported. |

## Storage

I have used Synology RackStation and TrueNAS systems for:

- SMB shares
- Proxmox resources
- application data
- backup targets
- iSCSI testing
- media storage

One Synology setup is deliberately limited to SMB and is restricted so only the intended Proxmox host can connect. That is less convenient than opening the share to the whole network, but it is easier to reason about.

## Network kit

- MikroTik L009UiGS-RM
- UniFi Cloud Gateway Max
- managed switches
- WireGuard endpoints
- APC UPS equipment

I have used both MikroTik and UniFi because they approach the same jobs differently. MikroTik gives a lot of control and exposes more of the underlying networking. UniFi is quicker to manage and gives a cleaner overall view.

## What older enterprise hardware has taught me

Older rack servers are cheap to buy and expensive to run. They are also useful.

I have had to deal with:

- iLO and iDRAC
- firmware versions
- memory population rules
- SAS disks and RAID controllers
- failed or mismatched disks
- fan noise and power use
- hypervisor compatibility
- adding network cards
- remote console access
- storage presented to VMs

That is much closer to real infrastructure work than running five containers on a laptop, although I use both depending on the job.

## RAID note

I do not treat RAID as a backup. RAID helps keep a system running after a disk failure. It does not protect against deletion, corruption, ransomware, controller problems or losing the whole machine.
