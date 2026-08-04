# Services

This is a mixture of things I currently run, things I have run before and systems I have built for testing.

I have left out one-off experiments that taught me nothing useful.

| Service / platform | What I used it for | Notes |
|---|---|---|
| AdGuard Home | DNS and filtering | Also used for forwarding internal zones. |
| Immich | Self-hosted photo library | Runs in the Proxmox environment with NAS-backed storage. |
| Nextcloud | File sync and private cloud testing | I have used the Snap package and worked through domain and proxy configuration. |
| Nginx | Web server and reverse proxy | Used for PHP sites, static sites and proxying internal applications. |
| Nginx Proxy Manager | Easier reverse proxy management | Useful for services where a full hand-written Nginx config is unnecessary. |
| Plesk | Hosting control panel | Used on Ubuntu for websites, databases, certificates and mail-related tasks. |
| Certbot | Let’s Encrypt certificates | I check renewal with a dry run rather than assuming the timer works. |
| Proxmox Mail Gateway | Mail filtering | Used while testing inbound mail protection and policy. |
| Mailu | Self-hosted mail testing | Worked with DNS, SPF, DKIM and DMARC. |
| 3CX v20 | PBX and SIP | Extensions, trunks, routing and endpoint work. |
| FreePBX | PBX testing and community platform work | Included public extensions and emergency call restrictions. |
| Grandstream UCM | Hardware PBX testing | SIP endpoint and routing experience. |
| Odoo | CRM and business process testing | Used for a security services project. |
| Mattermost | Internal team chat | Deployed through a container stack. |
| Akaunting / Invoice Ninja / InvoicePlane | Finance platform testing | Compared deployment and maintenance requirements. |
| Ollama and Open WebUI | Local AI testing | Run on local hardware rather than cloud APIs. |
| Webmin | Server administration | Useful, but I still check the underlying Linux configuration. |
| WordPress | Business and project websites | Themes, plugins, DNS, hosting and troubleshooting. |

## How I look after a Linux service

Before restarting anything, I normally collect:

```bash
systemctl status <service> --no-pager
journalctl -u <service> --since "30 minutes ago"
ss -lntup
df -h
free -h
```

For Docker:

```bash
docker ps
docker compose ps
docker compose logs --tail=100
```

For a web service I also test the layers separately:

```bash
curl -I http://127.0.0.1:<port>
curl -Ik https://public-name.example
```

That tells me whether the application itself is down or the problem is further out at DNS, TLS or the proxy.

## Updates

I do not update every service blindly.

For anything with important data I check:

1. current version
2. release notes
3. database or format changes
4. available backup
5. rollback option
6. free disk space
7. whether I can tolerate downtime

Then I update one layer at a time.
