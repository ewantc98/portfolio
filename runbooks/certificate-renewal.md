# Runbook: TLS Certificate Renewal

## Trigger

Use for:

- Certificate approaching expiry
- Browser certificate warning
- Failed automated renewal
- New or changed domain
- Reverse proxy serving the wrong certificate

---

## 1. Identify certificate ownership

Before changing anything, identify which component terminates TLS:

- Nginx with Certbot
- Apache with Certbot
- Nginx Proxy Manager
- Nextcloud Snap
- Plesk
- Cloud/CDN proxy
- Application itself

Do not renew a certificate on the back-end host when the public endpoint is served by a different proxy.

---

## 2. Inspect the certificate presented publicly

```bash
echo | openssl s_client \
  -connect service.example.com:443 \
  -servername service.example.com 2>/dev/null \
  | openssl x509 -noout -subject -issuer -serial -dates
```

Also check the full connection and chain:

```bash
curl -vkI https://service.example.com/
```

Record:

- Common name/SANs
- Issuer
- Expiry
- Endpoint address
- Whether the expected proxy answered

---

## 3. Inspect Certbot state

```bash
sudo certbot certificates
sudo systemctl status certbot.timer --no-pager
sudo systemctl list-timers | grep -i certbot
```

Run a renewal simulation:

```bash
sudo certbot renew --dry-run
```

A dry run is preferred before forcing a live renewal.

---

## 4. Validate web-server configuration

Nginx:

```bash
sudo nginx -t
```

Apache:

```bash
sudo apachectl configtest
```

A certificate may renew successfully but fail to deploy if the web-server configuration is invalid.

---

## 5. Diagnose validation failure

### HTTP-01 checks

- Public DNS points to the correct endpoint.
- TCP 80 is reachable.
- The challenge path is not redirected incorrectly.
- A firewall or CDN is not blocking validation.
- An AAAA record does not point to an unreachable IPv6 endpoint.

```bash
dig service.example.com A +short
dig service.example.com AAAA +short
curl -I http://service.example.com/.well-known/acme-challenge/test
```

### DNS-01 checks

- API credentials are valid.
- Correct DNS zone is being changed.
- TXT record has propagated.
- Old records are not confusing validation.

```bash
dig _acme-challenge.service.example.com TXT
```

---

## 6. Renew

For all due Certbot-managed certificates:

```bash
sudo certbot renew
```

Do not repeatedly use `--force-renewal` unless there is a clear need; unnecessary issuance can reach CA rate limits.

Reload the relevant service if Certbot did not do so automatically:

```bash
sudo systemctl reload nginx
```

---

## 7. Validate deployment

Re-run the public certificate check:

```bash
echo | openssl s_client \
  -connect service.example.com:443 \
  -servername service.example.com 2>/dev/null \
  | openssl x509 -noout -subject -issuer -dates
```

Confirm:

- New expiry date
- Correct hostname/SAN
- Complete certificate chain
- Application page works
- Monitoring sees the new date
- No other virtual host was affected

---

## 8. Rollback

If a new certificate or configuration breaks the site:

1. Restore the previous web-server configuration.
2. Point the virtual host to the previous known-good certificate files if retained.
3. Validate configuration.
4. Reload the web server.
5. Confirm public service.
6. Preserve Certbot and web-server logs.

Avoid deleting `/etc/letsencrypt` content manually without understanding Certbot's lineage structure.

---

## 9. Evidence and logs

```bash
sudo journalctl -u certbot --since '24 hours ago'
sudo less /var/log/letsencrypt/letsencrypt.log
sudo journalctl -u nginx --since '60 minutes ago'
```

---

## 10. Prevention

- Monitor expiry at 30, 14 and 7 days
- Test renewals after DNS, firewall or proxy changes
- Keep port/challenge ownership documented
- Avoid manual certificate copies where automatic deployment is expected
- Review failed timer jobs
- Use DNS-01 for services that cannot expose HTTP validation where appropriate
- Document whether the proxy or application owns TLS
