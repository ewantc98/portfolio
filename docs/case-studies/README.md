# Technical Case Studies

These case studies document practical infrastructure work using a consistent structure:

1. **Context** — what the system was intended to do.
2. **Problem or requirement** — the issue to solve.
3. **Constraints** — security, hardware, time, cost or platform limitations.
4. **Investigation/design** — evidence gathered and options considered.
5. **Implementation** — controlled technical changes.
6. **Validation** — how success was confirmed.
7. **Recovery/rollback** — what would happen if the change failed.
8. **Lessons learned** — improvements for the next iteration.

Live addresses, credentials, customer data and identifying third-party information are excluded.

---

## Published case studies

### [Proxmox and SMB storage integration](proxmox-smb-storage.md)

Mounting NAS-hosted application data on a Proxmox host and making it safely available to a Linux workload. Covers CIFS, credentials, permissions, LXC bind mounts, startup dependencies and fault diagnosis.

### [Internal DNS and conditional forwarding](internal-dns.md)

Providing stable internal names through AdGuard Home and a private resolver. Covers query flow, forwarding, client policy, split-horizon concepts and layered validation.

### [Immich deployment in a virtualised environment](immich-lxc.md)

Designing an Immich deployment with defined compute, storage, backup and recovery boundaries. Covers VM/LXC selection, external data, updates and service validation.

### [Nextcloud Snap domain configuration](nextcloud-snap-domain.md)

Configuring Nextcloud Snap to accept a domain and operate correctly with HTTPS or a reverse proxy. Covers trusted domains, overwrite settings, certificate choices and validation.

### [SIP endpoint registration troubleshooting](sip-registration.md)

Separating SIP server, registrar, outbound proxy, authentication ID and extension details. Covers DNS, transport, NAT, response codes and safe troubleshooting.

---

## Existing troubleshooting collection

The earlier [troubleshooting examples](troubleshooting.md) remain as shorter examples. The new case studies expand selected topics into full problem-to-resolution records.

---

## Planned case studies

- Windows Server update-policy investigation
- Proxmox VM start failure caused by unavailable storage
- Certificate-renewal failure behind a reverse proxy
- Mail flow and SPF/DMARC troubleshooting
- WireGuard-restricted NAS access
- Monitoring-agent deployment and reference-target selection
- Plesk website migration and TLS validation
- PBX trunk registration and NAT diagnosis

Each planned study will be published only when it can be described accurately without exposing former employer, customer or live security information.
