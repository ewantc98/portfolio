# Homelab Infrastructure Case Study

## Purpose

This environment is a practical infrastructure lab used to design, deploy, troubleshoot and document systems similar to those found in small businesses and managed-service environments.

The aim is not to collect applications for their own sake. Each component is used to practise a specific operational skill: virtualisation, segmentation, storage, DNS, remote access, monitoring, backup, publishing services and incident diagnosis.

## Environment summary

The platform uses enterprise server hardware with Proxmox VE as the main virtualisation layer. Workloads include Linux and Windows virtual machines, LXC containers and selected containerised services. Network storage is provided by dedicated NAS systems, while managed networking separates infrastructure from users and less-trusted devices.

Key design areas include:

- Proxmox virtualisation and workload placement
- Managed switching and VLAN segmentation
- Internal DNS and filtering
- Reverse proxying and TLS certificates
- WireGuard remote access
- SMB and iSCSI storage
- Local and off-site backups
- Monitoring and service-health checks
- Linux and Windows administration

## Design principles

### Keep management private

Hypervisor, NAS and management interfaces are not intended to be exposed directly to the public internet. Administrative access is provided from trusted networks or through a private VPN path.

### Separate workloads by trust and purpose

Servers, management devices, user endpoints, guest devices and internet-facing services do not all require the same access. Segmentation limits unnecessary communication and makes policy easier to understand.

### Prefer recoverable systems

A service is not considered properly operated simply because it is running. Configuration, application data, backup location and recovery steps must all be understood.

### Document decisions

Documentation records why a service exists, what it depends on and how it should be recovered. This is more useful than a list of commands without context.

## Representative operational tasks

- Creating and sizing virtual machines and LXC containers
- Mounting network storage for application data and backup targets
- Diagnosing failed VM starts and unavailable storage
- Configuring internal DNS records and conditional forwarding
- Publishing applications behind a reverse proxy
- Renewing and troubleshooting TLS certificates
- Restricting NAS shares to approved systems
- Testing service reachability across VLANs
- Reviewing logs and systemd service state
- Migrating applications between hosts
- Maintaining Ubuntu and Debian servers
- Supporting Windows Server workloads

## Skills evidenced

This case study demonstrates practical understanding of:

- Infrastructure architecture
- Layered troubleshooting
- Linux administration
- Network fundamentals
- Virtualisation
- Storage and backup
- Security-conscious configuration
- Change documentation
- Service ownership

## Documentation

- [Architecture](architecture.md)
- [Networking](networking.md)
- [Services](services.md)
- [Storage and backup](storage-backup.md)
- [Security](security.md)
