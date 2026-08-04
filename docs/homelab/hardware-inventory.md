# Homelab Hardware Inventory

This inventory records representative hardware I have personally installed, configured, upgraded, troubleshot or used as part of my homelab and technical projects.

Serial numbers, management addresses, asset tags and exact physical locations are intentionally excluded. Roles can change over time, and not every system is powered on simultaneously.

---

## Compute platforms

### HPE ProLiant DL20 Gen9

**Representative configuration**

- 64 GB memory
- Two 300 GB 15K SAS drives
- Four-bay 2.5-inch chassis
- HPE iLO remote management
- Used as a compact virtualisation and infrastructure host

**Work performed**

- Memory and storage planning
- Hypervisor installation and configuration
- Virtual machine and LXC deployment
- Remote management through iLO
- RAID and disk-health checks
- Linux service hosting
- Storage integration with NAS-hosted resources

**Skills evidenced**

- Enterprise server administration
- Remote console and out-of-band management
- Capacity planning
- SAS storage and RAID awareness
- Virtualisation host maintenance

### HPE ProLiant DL360 Gen9

**Representative configuration**

- Six 600 GB SAS drives
- Mixed memory configuration during evaluation and upgrade work
- HPE iLO remote management
- Rack-mounted enterprise compute platform

**Work performed**

- RAID-capacity calculations
- Memory population and compatibility checks
- Hypervisor planning
- Firmware and management review
- Investigation of hardware configuration and boot issues

A six-disk RAID 10 layout using 600 GB drives provides approximately 1.8 TB decimal raw usable capacity before filesystem and platform overhead, or roughly 1.64 TiB. In practice, controller metadata, filesystem formatting and platform presentation affect the final figure.

### Dell PowerEdge R430 systems

**Inventory**

- Two Dell PowerEdge R430 servers
- iDRAC remote management
- Enterprise rack-server platform suitable for virtualisation and infrastructure workloads

**Work performed**

- ESXi and Proxmox evaluation
- Remote management and console access
- Datastore and network planning
- Hardware-role comparison with HPE platforms
- Service migration and lab-capacity planning

### Dell PowerEdge R320

**Role**

Used as an additional enterprise server platform for storage, virtualisation and infrastructure testing.

**Skills evidenced**

- Working across different server vendors
- Understanding iDRAC-based administration
- Comparing power, memory and storage constraints
- Reusing older enterprise hardware safely for lab purposes

### Supermicro X10SDV-TLN4F platform

**Role**

A lower-power server platform suitable for continuously running infrastructure services where a full rack server would be unnecessarily power hungry.

**Relevant characteristics**

- Integrated server-class processor platform
- Multiple network interfaces
- IPMI-style remote management
- Useful for lightweight virtualisation, routing, monitoring or storage-adjacent services

**Skills evidenced**

- Matching workload needs to power and hardware constraints
- Small-form-factor server design
- Remote-management familiarity beyond HPE and Dell

---

## Storage platforms

### Synology RackStation

**Use cases**

- SMB file services
- Backup repository
- Restricted service-to-service storage
- Off-site or remote backup workflow
- WireGuard-assisted private access

**Work performed**

- Share creation and access control
- Restricting SMB access to approved systems
- Backup planning
- VPN connectivity
- Troubleshooting permissions and network reachability
- Separating application data from compute hosts

### TrueNAS

**Use cases**

- NAS design and evaluation
- Dataset and share planning
- SMB storage
- iSCSI presentation
- Media and backup workloads

**Work performed**

- Storage layout planning
- Dataset and permission design
- SMB and iSCSI concepts
- Integration with virtualisation hosts
- Consideration of backup vs primary-storage roles

### Local SAS storage

Enterprise servers in the lab have used SAS disks and hardware RAID controllers.

Operational considerations include:

- Controller-supported RAID levels
- Rebuild duration and risk
- Disk-failure visibility
- Hot-spare strategy
- Usable capacity vs raw capacity
- The fact that RAID improves availability but is not a backup

---

## Network platforms

### MikroTik L009UiGS-RM

**Use cases**

- Routing and switching
- VLAN design
- Policy-based routing
- VPN-related configuration
- Network troubleshooting

**Work performed**

- Route and gateway planning
- Segmentation concepts
- Policy route design for selected hosts
- Reachability and firewall diagnosis
- Integration with other network platforms

### UniFi Cloud Gateway Max

**Use cases**

- Gateway and firewall
- VLAN and client-network management
- Centralised visibility
- Remote administration
- Integration with managed UniFi switching and wireless infrastructure

**Work performed**

- Network segmentation
- Traffic-policy planning
- Client and service visibility
- Gateway migration considerations
- Private-service access design

### Managed switching

The lab uses managed networking to separate systems by trust and purpose. Relevant work includes:

- Access vs tagged/trunk ports
- VLAN membership
- Management-network isolation
- Server and storage connectivity
- Diagnosing incorrect VLAN assignment
- Understanding the relationship between switch configuration, gateway policy and host addressing

---

## Power and resilience

### APC UPS

**Purpose**

- Protect infrastructure from short power interruptions
- Reduce the risk of abrupt filesystem and application shutdown
- Provide time for controlled shutdown

**Operational considerations**

- Runtime depends on actual load, not nameplate capacity alone
- UPS batteries require periodic replacement
- A UPS is not a generator or a substitute for backups
- Shutdown signalling and recovery behaviour should be tested

---

## End-user and specialist hardware

### Camera and media workflows

A Canon EOS 2000D and associated photo workflows have contributed to practical experience with:

- Large media libraries
- Storage consumption
- Backup requirements
- Immich and photo-management platforms
- File organisation and long-term retention

### GPU and workstation hardware

The wider lab inventory has included a Quadro M2000 4 GB and general desktop/workstation systems used for:

- Media workloads
- Remote administration
- Local AI evaluation
- Windows and Linux endpoint testing

---

## Hardware administration skills

Across the inventory, practical work has included:

- Rack-server installation and role planning
- Out-of-band management using iLO, iDRAC and IPMI-style interfaces
- Disk and RAID-capacity calculations
- Memory population and compatibility checks
- Firmware and hypervisor compatibility
- SAS and SATA storage considerations
- Virtualisation host deployment
- Network-interface and VLAN planning
- Diagnosing boot, disk and VM-start issues
- Balancing performance, noise, power consumption and availability

---

## Capacity planning method

Before assigning a role to a host, I consider:

1. **CPU demand** — sustained load, burst load and virtual CPU contention.
2. **Memory demand** — operating-system baseline, application working set and growth.
3. **Storage performance** — random vs sequential I/O, latency and write endurance.
4. **Storage capacity** — current use, retention, snapshots and expected growth.
5. **Network demand** — client traffic, backups, storage protocols and uplink constraints.
6. **Availability** — acceptable downtime and recovery options.
7. **Power/noise** — whether the workload justifies enterprise rack hardware.
8. **Management** — remote-console access, monitoring and replacement options.

This prevents the common homelab mistake of selecting hardware only because it is available rather than because it suits the workload.

---

## Limitations and honesty statement

The environment is a privately funded lab, not a datacentre. It provides strong hands-on evidence, but it does not claim enterprise-scale redundancy, formal 24/7 staffing or guaranteed service-level agreements.

Its value is the opportunity to perform real installation, migration, failure diagnosis, security and recovery work on hardware and software that closely resembles business infrastructure.
