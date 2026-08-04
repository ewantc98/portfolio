# Infrastructure and Service Catalogue

This catalogue records platforms I have installed, configured, evaluated, migrated, troubleshot or supported across professional work, homelab systems and independent projects.

It is not intended to imply that every service is currently active or that every item was operated in a production business environment. Context is stated for each category.

---

## Catalogue status labels

| Status | Meaning |
|---|---|
| **Operated** | Used as a functioning service over a sustained period |
| **Deployed** | Installed and configured for a defined purpose |
| **Migrated** | Moved between platforms or redesigned |
| **Supported** | Diagnosed and maintained as part of support work |
| **Evaluated** | Installed or compared to develop understanding or choose a platform |

---

## Core infrastructure

### Proxmox VE

**Context:** Homelab

**Status:** Operated / Deployed / Supported

**Uses**

- Linux and Windows virtual machines
- LXC containers
- Storage integration
- Application hosting
- Test environments
- Service migration

**Operational work**

- Host installation and network configuration
- VM and LXC resource sizing
- Storage mounts and bind mounts
- Diagnosing failed starts
- Backup and snapshot decisions
- Separating application data from compute
- Reviewing service dependencies

### VMware ESXi

**Context:** Homelab and infrastructure experience

**Status:** Deployed / Evaluated / Supported

**Operational work**

- ESXi 6.5, 6.7 and 7.0-era environments
- Datastore and iSCSI work
- Hardware compatibility and VIB considerations
- VM administration
- Host troubleshooting

### Hyper-V

**Context:** Windows infrastructure experience

**Status:** Deployed / Evaluated / Supported

**Operational work**

- Windows-hosted virtual machines
- Virtual networking concepts
- VM lifecycle administration
- Integration with Windows Server environments

---

## DNS, filtering and network services

### AdGuard Home

**Context:** Homelab

**Status:** Operated

**Purpose**

- Internal DNS resolution
- Client filtering
- Query visibility
- Forwarding for private zones

**Operational work**

- Resolver deployment
- Client DNS configuration
- Conditional forwarding
- Local record management
- Query-log diagnosis
- Upstream resolver testing

### MikroTik RouterOS

**Context:** Homelab / Project

**Status:** Operated / Configured

**Operational work**

- Routing
- Policy routing
- VPN-related paths
- Firewall concepts
- Addressing and reachability diagnosis

### UniFi

**Context:** Homelab

**Status:** Operated

**Operational work**

- Gateway and client visibility
- VLAN configuration
- Segmentation
- Firewall policy
- Managed network administration

### WireGuard

**Context:** Homelab / Project

**Status:** Operated / Deployed

**Uses**

- Remote administration
- Restricted access to private services
- Backup connectivity
- Site or host access without public management exposure

---

## Storage and backup services

### Synology DSM / RackStation

**Context:** Homelab / Project

**Status:** Operated

**Uses**

- SMB shares
- Backup targets
- Restricted application storage
- Remote backup

**Operational work**

- Share and user permissions
- Restricting access by source system
- WireGuard-assisted access
- Capacity and recovery planning
- Troubleshooting SMB reachability and authentication

### TrueNAS SCALE

**Context:** Homelab

**Status:** Deployed / Evaluated / Operated

**Uses**

- SMB storage
- iSCSI concepts
- Media and backup storage
- Dataset and permission design

### SMB and CIFS mounts

**Context:** Homelab / Project

**Status:** Operated

**Operational work**

- Host-level mounts
- Credentials files
- Ownership and permissions
- `fstab` persistence
- LXC bind mounts
- Diagnosing unavailable storage

### iSCSI

**Context:** Homelab

**Status:** Deployed / Evaluated

**Operational work**

- LUN presentation
- ESXi datastore concepts
- Network and storage dependency awareness

---

## Web, proxy and certificate services

### Nginx

**Context:** Project / Homelab

**Status:** Operated

**Uses**

- Web hosting
- Reverse proxying
- TLS termination
- Application publishing

**Operational work**

- Server blocks
- Upstream configuration
- Proxy headers
- Redirect and certificate diagnosis
- Log review

### Nginx Proxy Manager

**Context:** Homelab / Project

**Status:** Deployed / Operated

**Operational work**

- Proxy hosts
- Certificate requests
- Private upstreams
- Troubleshooting 502 errors and DNS issues

### Certbot / Let's Encrypt

**Context:** Project / Homelab

**Status:** Operated

**Operational work**

- Issuing certificates
- Renewal testing
- Diagnosing failed renewals
- Nginx integration
- Reviewing expiry and deployment state

### Plesk

**Context:** Independent hosting projects

**Status:** Operated

**Operational work**

- Ubuntu-based hosting
- Domains and websites
- PHP configuration
- TLS certificates
- DNS and mail-related administration
- Customer hosting workflows

### WordPress and PHP applications

**Context:** Project

**Status:** Operated / Supported / Migrated

**Operational work**

- Site deployment and maintenance
- Themes and customisation
- Database/application troubleshooting
- Domain and SSL setup
- Migration between hosting platforms

---

## Collaboration and business platforms

### Nextcloud

**Context:** Homelab / Project

**Status:** Deployed / Operated

**Deployment methods encountered**

- Snap installation
- Docker-based evaluation
- Reverse-proxy publishing

**Operational work**

- Trusted domains
- HTTPS and proxy awareness
- Storage and permissions
- Application configuration
- Domain setup

### Mattermost

**Context:** Project / Homelab

**Status:** Deployed

**Operational work**

- Containerised deployment
- Reverse proxy and domain configuration
- Service dependencies
- User collaboration planning

### Odoo

**Context:** Business project

**Status:** Deployed / Evaluated

**Operational work**

- CRM and business workflow evaluation
- Domain and application publishing
- Container/service management

### Akaunting, Invoice Ninja and InvoicePlane

**Context:** Business and hosting projects

**Status:** Deployed / Evaluated

**Operational work**

- Comparing accounting and invoicing platforms
- Ubuntu deployment
- Database/application dependencies
- Web configuration and troubleshooting

---

## Media and personal data services

### Immich

**Context:** Homelab

**Status:** Operated / Deployed

**Representative deployment**

- Linux LXC or VM-based application host
- Approximately 8 GB memory allocated during one deployment
- External or NAS-backed data paths
- Private DNS and application access

**Operational work**

- Deployment and updates
- Storage integration
- Permissions
- Backup scope
- Application health
- DNS and reverse-proxy considerations

### Plex and Navidrome

**Context:** Homelab

**Status:** Deployed / Evaluated

**Operational work**

- Media-library planning
- NAS access
- Resource sizing
- Service publishing considerations

---

## Monitoring and management

### Uptime and reachability monitoring

**Context:** Homelab / Project

**Status:** Operated / Developed

**Work performed**

- Public and private reachability checks
- Selecting stable reference targets
- Service-health logic
- Distinguishing host availability from application availability
- Developing or testing a lightweight monitoring agent concept

### Webmin

**Context:** Homelab

**Status:** Deployed / Operated

**Operational work**

- Linux administration through a web interface
- Permissions and file-management support
- Service visibility

### Portainer

**Context:** Homelab / Project

**Status:** Operated

**Operational work**

- Docker stack management
- Container visibility
- Logs
- Volume and network review

### Action1

**Context:** Endpoint and management evaluation

**Status:** Evaluated / Deployed

**Operational work**

- Agent deployment
- Remote management and patching concepts

---

## Mail and security gateways

### Mailu

**Context:** Project / Homelab

**Status:** Deployed / Migrated

**Operational work**

- Mail platform deployment
- DNS records
- SPF and DMARC tuning
- Migration considerations

### Proxmox Mail Gateway

**Context:** Project / Homelab

**Status:** Deployed / Evaluated

**Operational work**

- Mail filtering concepts
- Gateway positioning
- Mail-flow and DNS considerations

### SMTP2GO and PHPMailer

**Context:** Web projects

**Status:** Evaluated / Used

**Operational work**

- Transactional email delivery
- Contact-form mail flow
- Comparing authenticated relay with direct application mail

---

## VoIP and PBX

### 3CX

**Context:** Project / Homelab

**Status:** Operated / Supported

**Operational work**

- 3CX v20 concepts
- Extensions and provisioning
- SIP trunks
- Endpoint registration
- Routing and troubleshooting

### FreePBX

**Context:** Project / Homelab

**Status:** Deployed / Operated

**Operational work**

- Debian-based PBX deployment
- Extensions
- Demo and community service concepts
- Emergency-call restrictions
- SIP endpoint troubleshooting

### Grandstream UCM

**Context:** VoIP evaluation

**Status:** Evaluated

**Operational work**

- PBX platform comparison
- Endpoint and trunk concepts

---

## Local AI and development services

### Ollama and Open WebUI

**Context:** Homelab

**Status:** Deployed / Operated

**Operational work**

- Local model hosting
- Web interface deployment
- Hardware/resource constraints
- Service publishing within a private environment

### FastAPI

**Context:** Application project

**Status:** Developed / Deployed

**Use case**

- Backend for an urban-exploration mapping application
- Ubuntu and Nginx deployment
- API architecture
- Android client integration concepts

### Android development stack

**Context:** Application project

**Status:** Developed / Evaluated

**Technologies**

- Jetpack Compose
- Retrofit
- Room offline storage

---

## Service dependency template

For every important service, the target documentation standard is:

| Field | Example |
|---|---|
| Service owner | Person/team responsible for operation |
| Purpose | Business or technical reason the service exists |
| Host platform | VM, LXC, Docker host, appliance or physical system |
| Network zone | Management, compute, services or published zone |
| DNS records | Internal and public names |
| Data path | Local disk, NAS share, database or object storage |
| Authentication | Local, directory, SSO or application credentials |
| Backup method | What is backed up, where and how often |
| Recovery order | Storage → database → application → proxy → validation |
| Monitoring | Host, port, HTTP, DNS, certificate and application checks |
| Update method | Package, container, appliance or manual upgrade process |
| Rollback | Snapshot, backup restore, previous image or configuration |

---

## Operational lessons

Across these platforms, the repeated themes are:

- DNS and certificates are common failure points for otherwise healthy applications.
- A container being “up” does not mean its dependencies or user-facing function are healthy.
- Storage permissions and identity mapping require deliberate design.
- Reverse proxies add security and flexibility but also create another diagnostic layer.
- Backups are valuable only when data scope and restoration order are understood.
- Documentation should describe purpose, dependencies and recovery—not just installation commands.
