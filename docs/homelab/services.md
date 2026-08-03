# Hosted Services

## Overview

The homelab hosts a mixture of core infrastructure, management and application services. Each service is treated as an operational component with dependencies, data locations and recovery requirements.

## Core services

| Service type | Purpose | Operational focus |
|---|---|---|
| Internal DNS / filtering | Name resolution and policy-based filtering | Resolver health, forwarding, records and client configuration |
| Reverse proxy | Controlled web-service publishing | TLS, upstream health, headers and access policy |
| Monitoring | Availability and service-health checks | Useful alerts, dependency awareness and false-positive reduction |
| Photo platform | Self-hosted photo management | Storage mounts, database health, updates and backup |
| File collaboration | Private cloud and document access | Permissions, storage, proxying and application maintenance |
| Web hosting | Websites and customer-facing services | DNS, PHP, certificates, mail and web-server configuration |
| PBX services | SIP communication and call routing | Registration, trunks, routing, firewall and security |

## Linux service operations

Typical checks used when diagnosing a hosted service include:

```bash
systemctl status <service>
journalctl -u <service> --since "30 minutes ago"
ss -lntup
df -h
free -m
```

For containerised services:

```bash
docker ps
docker compose ps
docker compose logs --tail=100
```

## Reverse proxy and TLS

Selected web services are published through Nginx or a reverse-proxy platform. The proxy terminates TLS and forwards requests to a private upstream.

Common failure areas include:

- Incorrect DNS records
- Expired or failed certificate renewal
- An unavailable upstream service
- Incorrect proxy headers
- Firewall or VLAN policy
- Application-generated redirect loops

## Application data

Application configuration and user data are kept separate where practical. This makes it easier to replace a failed application host without treating the whole VM as the only copy of the service.

For each important service, documentation should identify:

- Host platform
- Network dependencies
- Storage paths
- Database dependency
- Proxy or DNS records
- Backup method
- Restore sequence

## Change management

Before an update or migration:

1. Review application release notes
2. Confirm current backup state
3. Record the existing version and configuration
4. Define a rollback path
5. Apply one controlled change
6. Validate from the user perspective
7. Update documentation

## Planned additions

Future public examples may include sanitised Docker Compose files, systemd unit examples and deployment scripts. Live secrets and environment files will remain excluded.
