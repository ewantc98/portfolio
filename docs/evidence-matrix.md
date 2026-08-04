# Technical Evidence Matrix

This document maps common infrastructure, support and technical operations requirements to specific evidence in this portfolio.

The aim is to make the repository useful to a recruiter or hiring manager who wants to understand what I have actually done rather than read a simple list of technologies.

## Evidence labels

| Label | Meaning |
|---|---|
| **Professional** | Work completed in paid IT support, managed-service or technical operations roles |
| **Homelab** | Real systems personally designed, deployed and operated in a private environment |
| **Project** | Independent infrastructure, hosting, web or communications work |
| **Exploratory** | Technology installed or evaluated for learning without claiming long-term production ownership |

---

## 2nd and 3rd line support

| Requirement | Evidence | Context |
|---|---|---|
| Own incidents beyond first-line scripts | Diagnose faults across endpoint, identity, DNS, network, server, storage and application layers | Professional / Homelab |
| Gather evidence before changing systems | Use service state, logs, event records, routing tables, DNS queries, open ports and application logs | Professional / Homelab |
| Communicate with non-technical users | Explain impact, set expectations, confirm restoration from the user perspective and document outcomes | Professional |
| Escalate appropriately | Separate faults that can be resolved locally from vendor, carrier, development or infrastructure escalation | Professional |
| Document recurring faults | Convert troubleshooting into runbooks and case studies | Professional / Homelab |

Evidence:

- [Troubleshooting method](case-studies/README.md)
- [Linux service outage runbook](../runbooks/linux-service-outage.md)
- [Storage unavailable runbook](../runbooks/storage-unavailable.md)
- [VM will not start runbook](../runbooks/vm-will-not-start.md)

---

## Microsoft environments

| Area | Practical evidence | Context |
|---|---|---|
| Windows client support | Operating-system, driver, software, profile, connectivity and update troubleshooting | Professional |
| Windows Server | Installation, administration, service troubleshooting, update policy and virtualised server workloads | Professional / Homelab |
| Microsoft 365 | User support, licensing concepts, desktop applications, sign-in and service diagnosis | Professional |
| Active Directory-related support | User and group administration, account access, domain-related diagnosis and Group Policy awareness | Professional |
| Exchange concepts | Mailbox, mail-flow, authentication and client troubleshooting | Professional / Project |
| PowerShell | Evidence collection and repeatable administration examples | Professional / Homelab |

Evidence:

- [PowerShell support bundle](../scripts/powershell/Collect-SupportBundle.ps1)
- [Service catalogue](homelab/service-catalogue.md)
- [Project summaries](projects.md)

Current development priority: add more sanitised Windows Server, Microsoft 365 and PowerShell case studies without exposing former employer or customer information.

---

## Virtualisation

| Technology | Practical evidence | Context |
|---|---|---|
| Proxmox VE | VM/LXC deployment, resource sizing, storage integration, failed-start diagnosis and service migration | Homelab |
| VMware ESXi | Installation, datastore work, hardware compatibility, iSCSI and host troubleshooting | Homelab / Professional familiarity |
| Hyper-V | Windows virtualisation concepts and VM administration | Homelab / Professional familiarity |
| LXC | Lightweight Linux services, bind mounts, permissions and backup planning | Homelab |
| VM design | Choosing VM vs container according to kernel, isolation, workload and recovery requirements | Homelab |

Evidence:

- [Homelab architecture](homelab/architecture.md)
- [Hardware inventory](homelab/hardware-inventory.md)
- [Proxmox SMB storage case study](case-studies/proxmox-smb-storage.md)
- [Immich LXC case study](case-studies/immich-lxc.md)

---

## Networking

| Area | Practical evidence | Context |
|---|---|---|
| VLANs and segmentation | Separate management, compute, services, trusted client and untrusted zones | Homelab |
| Routing and firewall policy | Permit traffic according to service need rather than flat-LAN trust | Homelab / Project |
| DNS and DHCP | Internal resolution, conditional forwarding, filtering and client diagnosis | Homelab |
| VPN | WireGuard access with narrow allowed-address scope and peer lifecycle awareness | Homelab / Project |
| MikroTik | Routing, policy routes, VPN and network diagnosis | Homelab / Project |
| UniFi | Gateway, switching, segmentation and client visibility | Homelab |
| Connectivity diagnosis | Link → VLAN → address → route → DNS → port → service → application | Professional / Homelab |

Evidence:

- [Detailed network topology](homelab/network-topology.md)
- [Networking design](homelab/networking.md)
- [Internal DNS case study](case-studies/internal-dns.md)
- [SIP registration case study](case-studies/sip-registration.md)

---

## Linux administration

| Area | Practical evidence | Context |
|---|---|---|
| Ubuntu and Debian | Service deployment, package management, permissions, storage, networking and upgrades | Homelab / Project |
| systemd and journald | Service status, startup dependencies and log-led diagnosis | Homelab / Project |
| Nginx and TLS | Reverse proxying, virtual hosts, Certbot and certificate diagnosis | Project / Homelab |
| Docker | Compose-based services, logs, volumes and application lifecycle | Homelab / Project |
| Storage mounts | SMB mounts, credentials files, ownership and LXC bind mounts | Homelab |
| Shell scripting | Evidence collection, health checks and repeatable operations | Homelab |

Evidence:

- [Hosted services](homelab/services.md)
- [Service catalogue](homelab/service-catalogue.md)
- [System health script](../scripts/bash/system-health-check.sh)
- [Certificate renewal runbook](../runbooks/certificate-renewal.md)

---

## Storage, backup and recovery

| Area | Practical evidence | Context |
|---|---|---|
| Synology | SMB shares, restricted access, backup targets and remote-access considerations | Homelab / Project |
| TrueNAS | NAS design, datasets, sharing and application/storage separation | Homelab |
| SMB | Host mounts, application data, permission troubleshooting and service dependencies | Homelab |
| iSCSI | LUN presentation and virtualisation datastore concepts | Homelab |
| RAID | Capacity planning, failure tolerance and controller constraints | Homelab |
| Backup | Local and off-site copies, configuration capture and restore sequencing | Homelab / Project |
| Recovery | Documenting DNS, proxy, certificate, database and storage dependencies | Homelab |

Evidence:

- [Storage and backup strategy](homelab/storage-backup.md)
- [Proxmox SMB storage case study](case-studies/proxmox-smb-storage.md)
- [Storage unavailable runbook](../runbooks/storage-unavailable.md)

---

## Hosting and web operations

| Area | Practical evidence | Context |
|---|---|---|
| Plesk | Linux hosting platform administration, domains, PHP, certificates and customer hosting | Project |
| Nginx | Reverse proxying, application publishing and TLS | Project / Homelab |
| DNS | Public records, internal records, mail authentication and troubleshooting | Project / Homelab |
| WordPress/PHP | Deployment, customisation, migrations and application diagnosis | Project |
| Nextcloud | Snap and container deployment, domains, trusted hosts and proxy awareness | Homelab / Project |
| Mail | SPF, DKIM, DMARC concepts, Mailu and Proxmox Mail Gateway work | Project / Homelab |

Evidence:

- [Nextcloud Snap domain case study](case-studies/nextcloud-snap-domain.md)
- [Service catalogue](homelab/service-catalogue.md)
- [Nginx reverse-proxy example](../examples/nginx/reverse-proxy.conf)

---

## VoIP and communications

| Area | Practical evidence | Context |
|---|---|---|
| 3CX | PBX administration, extensions, SIP trunks and troubleshooting | Project / Homelab |
| FreePBX | Community PBX deployment, call routing and endpoint configuration | Project / Homelab |
| SIP | Registrar, authentication identity, extension, proxy and transport separation | Project / Homelab |
| NAT and firewall | RTP/SIP reachability, stateful firewall awareness and remote endpoint diagnosis | Project / Homelab |
| Operational safety | Emergency-call restrictions and clear service limitations in community/lab platforms | Project |

Evidence:

- [SIP registration case study](case-studies/sip-registration.md)
- [Project summaries](projects.md)

---

## Security and operational discipline

| Area | Practical evidence | Context |
|---|---|---|
| Least privilege | Restrict management, storage and service access to required systems | Homelab / Project |
| Secret handling | Exclude credentials, tokens, keys and live security rules from version control | Homelab / Project |
| Segmentation | Separate workloads according to trust and operational purpose | Homelab |
| Remote administration | Prefer VPN access over exposed management interfaces | Homelab / Project |
| Change planning | Record purpose, dependencies, validation and rollback | Professional / Homelab |
| Incident response | Restore safely, validate, document cause and identify prevention | Professional / Homelab |
| Business continuity | Understand dependencies and restoration order rather than relying only on VM snapshots | Homelab / Project |

Evidence:

- [Security principles](homelab/security.md)
- [Operational runbooks](../runbooks/README.md)
- [Repository security policy](../SECURITY.md)

---

## Documentation and service ownership

This repository itself is evidence of:

- Turning informal technical work into structured documentation
- Explaining why a design was chosen
- Recording dependencies and failure modes
- Writing operational procedures for another engineer
- Distinguishing current capability from future development
- Presenting technical information to both technical and non-technical readers

The next phase is to add more screenshots, tested restore records, small automation projects and Microsoft-focused case studies while maintaining the same security and accuracy standards.
