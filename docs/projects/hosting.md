# Web hosting, reverse proxies and certificates

I have run and supported websites on shared hosting, reseller platforms and my own Ubuntu servers.

The work has included:

- Plesk
- Nginx
- PHP
- WordPress
- MySQL/MariaDB-backed sites
- DNS records
- Let’s Encrypt
- reverse proxying
- mail delivery troubleshooting
- SPF, DKIM and DMARC

## A normal website fault

When a site is down I split the checks up.

### DNS

```bash
dig example.com
dig www.example.com
```

### Network and TLS

```bash
curl -Iv https://example.com
openssl s_client -connect example.com:443 -servername example.com
```

### Web server

```bash
nginx -t
systemctl status nginx --no-pager
journalctl -u nginx --since "30 minutes ago"
```

### Application

For PHP or WordPress I then check:

- PHP-FPM
- database connectivity
- file ownership
- disk space
- plugin/theme errors
- application logs

That order stops me spending an hour inside WordPress when the domain is pointing at the wrong server.

## Reverse proxies

I use reverse proxies to publish selected services without exposing every backend directly.

A simple Nginx example:

```nginx
server {
    listen 443 ssl http2;
    server_name app.example.com;

    location / {
        proxy_pass http://10.25.240.50:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

The addresses and names in this repo are examples.

## Certificates

I use Certbot and control-panel certificate tools. I do not consider renewal configured until this passes:

```bash
certbot renew --dry-run
```

I also check the active certificate from outside the application, because a successful renewal is no use if Nginx is still serving an old file.

## Mail

I have worked with self-hosted and filtered mail systems, including Mailu and Proxmox Mail Gateway.

The common checks are:

- MX records
- SPF
- DKIM
- DMARC
- reverse DNS
- SMTP logs
- queue state
- whether the sending IP is blocked

Mail problems are often DNS problems with a delay attached.
