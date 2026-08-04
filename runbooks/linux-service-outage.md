# Runbook: Linux Service Outage

## Trigger

Use this runbook when a Linux-hosted service is unavailable, degraded, restarting repeatedly or returning an unexpected response.

Examples:

- Web application unavailable
- Reverse proxy returns 502/504
- systemd service failed
- Container repeatedly restarts
- Service works locally but not remotely

---

## 1. Confirm impact

Record:

- Service name and expected URL/port
- Who is affected
- When the issue began
- Whether all users or one network/device is affected
- Any recent deployment, update, reboot, certificate change or storage event

Test from more than one perspective where possible:

```bash
curl -vkI https://service.example.com/
nc -vz service.example.com 443
```

Do not assume a browser message identifies the failed layer.

---

## 2. Preserve evidence

Before restarting:

```bash
sudo systemctl status <service> --no-pager
sudo journalctl -u <service> --since '60 minutes ago' --no-pager
sudo ss -lntup
sudo df -h
sudo df -i
sudo free -h
sudo uptime
```

If containerised:

```bash
docker ps -a
docker compose ps
docker compose logs --tail=200
```

Record exact timestamps and errors.

---

## 3. Check dependencies

### DNS

```bash
getent hosts dependency.lab.example
dig dependency.lab.example
```

### Network and port

```bash
ip route
ping -c 4 <dependency>
nc -vz <dependency> <port>
```

### Storage

```bash
findmnt
mountpoint -q /required/path
df -h /required/path
```

### Database

Confirm the database process/container is healthy and reachable on the expected address and port.

### Certificate

```bash
echo | openssl s_client -connect service.example.com:443 \
  -servername service.example.com 2>/dev/null \
  | openssl x509 -noout -subject -issuer -dates
```

---

## 4. Identify failure type

| Symptom | Likely layer |
|---|---|
| Host unreachable | Network, host power or hypervisor |
| Port closed/refused | Service stopped or wrong bind address |
| Port times out | Firewall, routing or dead service path |
| 502/504 | Reverse proxy cannot reach upstream or upstream is slow |
| 500 | Application exception, database or permissions |
| TLS warning | Certificate, hostname, chain or client time |
| Service exits immediately | Configuration, permissions, missing dependency or port conflict |
| Disk full | Capacity, logs, database or temporary files |

---

## 5. Low-risk restoration

Only after evidence is captured:

```bash
sudo systemctl restart <service>
sudo systemctl status <service> --no-pager
```

For Docker Compose:

```bash
docker compose restart <service>
docker compose ps
docker compose logs --tail=100 <service>
```

Do not reboot the entire host unless the fault justifies it. A reboot destroys useful state and can affect unrelated services.

---

## 6. Configuration validation

Examples:

```bash
sudo nginx -t
sudo sshd -t
sudo named-checkconf
sudo systemd-analyze verify /etc/systemd/system/<unit>.service
```

Use the validation command appropriate to the service before applying a reload.

---

## 7. User-facing validation

Confirm:

- DNS resolves correctly
- TCP port is reachable
- Expected page/API response appears
- Authentication works
- A representative transaction works
- Monitoring returns to healthy
- No new errors appear in logs

A successful `systemctl status` is not enough.

---

## 8. Escalate when

- Data corruption is suspected
- Database recovery is required
- Security compromise is possible
- A vendor-specific defect is likely
- Repeated restarts do not reveal the cause
- The service depends on unavailable upstream infrastructure
- The change required exceeds authorised scope

Include logs, timestamps, versions, recent changes and tests already completed.

---

## 9. Close and prevent recurrence

Document:

- User impact
- Root cause or best-supported cause
- Restoration action
- Validation performed
- Whether monitoring detected the issue
- Preventive action
- Required follow-up change

Possible prevention:

- Disk-capacity alert
- Certificate-expiry alert
- Dependency monitoring
- Configuration validation in deployment
- Better service ordering
- Backup/restore test
- Updated runbook
