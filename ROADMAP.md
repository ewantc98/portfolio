# Portfolio Development Roadmap

This roadmap keeps the portfolio honest and useful. It records what has already been documented, what is being expanded and what evidence would add the most value for infrastructure, systems and 2nd/3rd line support roles.

---

## Completed foundation

- Professional front-page portfolio
- Experience-context labels: professional, homelab, project and exploratory
- Technical evidence matrix
- Detailed homelab architecture
- Enterprise hardware inventory
- Network topology and trust model
- Infrastructure service catalogue
- Storage, security and hosted-service documentation
- Proxmox/SMB storage case study
- Internal DNS case study
- Immich case study
- Nextcloud Snap domain case study
- SIP registration troubleshooting case study
- Repository security policy
- Case-study template

---

## Phase 1 — Operational evidence

### Runbooks

- [x] Linux service outage
- [x] Storage unavailable
- [x] Certificate renewal
- [x] Virtual machine will not start
- [ ] DNS outage
- [ ] Reverse proxy 502/504 response
- [ ] Backup failure
- [ ] VPN peer unable to connect
- [ ] SIP trunk unavailable

### Scripts

- [x] Linux health/evidence collection
- [x] Certbot renewal check
- [x] PowerShell support-bundle collection
- [ ] Disk-capacity alert script
- [ ] Backup-age validation script
- [ ] DNS dependency check
- [ ] Certificate-expiry report
- [ ] Windows event-log triage helper

---

## Phase 2 — Microsoft evidence

Priority because many target roles request Microsoft environments explicitly.

Planned documentation:

- Windows Server build and patching checklist
- Active Directory user/group administration case study
- Group Policy troubleshooting case study
- Microsoft 365 sign-in and licensing troubleshooting flow
- Exchange mail-flow troubleshooting flow
- PowerShell user and device reporting examples
- Windows Server 2025 update-policy investigation
- Endpoint deployment and equipment-lifecycle example

Security requirement: examples must not expose former employer domains, tenant IDs, user data or customer configuration.

---

## Phase 3 — Infrastructure as code and automation

- Ansible Linux baseline role
- Repeatable Docker-host deployment
- Configuration validation before service restart
- Automatic documentation generation from safe inventory data
- GitHub Actions linting for shell and PowerShell examples
- Automated link checking for portfolio documentation

The objective is not to add automation for appearance. Each item should remove a real manual step or reduce configuration drift.

---

## Phase 4 — Monitoring and recovery evidence

### Monitoring

- Service dependency map
- Host vs port vs application monitoring examples
- Certificate-expiry alert
- NAS mount/sentinel alert
- Backup-age alert
- Public reference-target selection methodology
- Alert severity and escalation matrix

### Recovery testing

For selected services, record:

- Recovery objective
- Backup source
- Restoration steps
- Measured recovery time
- Validation checks
- Problems discovered during the test
- Improvements made afterwards

Target services:

- Internal DNS
- Reverse proxy
- Immich
- Nextcloud
- One Windows Server workload
- One PBX service

---

## Phase 5 — Sanitised visual evidence

- Physical rack/server photographs with serials removed
- Proxmox cluster/host screenshots with names and addresses sanitised
- Network topology export
- AdGuard query-flow screenshot
- Synology/TrueNAS storage screenshots
- Monitoring dashboard
- Example incident timeline
- Before/after service migration diagram

Screenshots will be added only where they prove something not already clear from text.

---

## Planned case studies

1. Proxmox VM blocked by unavailable storage
2. Windows Server update-policy investigation
3. Nginx/Certbot renewal failure
4. WireGuard-restricted Synology backup path
5. Mail flow, SPF and DMARC troubleshooting
6. Plesk website migration
7. Reverse proxy 502 diagnosis
8. PBX trunk and NAT troubleshooting
9. Monitoring-agent deployment
10. Linux application migration between hosts

---

## Quality standard for new entries

A new project or case study should answer:

- What was the requirement?
- What was the context: professional, homelab, project or exploratory?
- What constraints affected the design?
- What options were considered?
- What evidence was gathered?
- What was implemented?
- How was it validated?
- What was the rollback or recovery path?
- What was learned?
- What information was sanitised?

Items that cannot yet answer these questions remain on the roadmap rather than being presented as completed evidence.

---

## Portfolio maintenance

- Review links after structural changes
- Remove obsolete claims when platforms are retired
- Mark historical systems accurately
- Keep scripts safe and free of secrets
- Test commands before labelling them as reusable
- Record major portfolio changes through clear Git commit messages
- Review the front page quarterly against target job descriptions
