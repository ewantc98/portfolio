# Checking Certbot renewals properly

Seeing a valid certificate in the browser only proves it is valid today.

## Basic checks

List Certbot-managed certificates:

```bash
sudo certbot certificates
```

Check the renewal timer:

```bash
systemctl status certbot.timer --no-pager
systemctl list-timers --all | grep -i certbot
```

Run the important test:

```bash
sudo certbot renew --dry-run
```

A dry run tests the renewal method without waiting until the certificate is close to expiry.

## If the dry run fails

I check:

- DNS points to the right public address
- port 80 or the chosen challenge path is reachable
- Nginx/Apache config is valid
- the authenticator method still exists
- old domains have not been left in the certificate
- rate limits have not been hit

Useful commands:

```bash
sudo nginx -t
sudo journalctl -u certbot --since "24 hours ago"
sudo less /var/log/letsencrypt/letsencrypt.log
```

## Check what the server is actually presenting

```bash
echo | openssl s_client \
  -connect example.com:443 \
  -servername example.com 2>/dev/null \
  | openssl x509 -noout -subject -issuer -dates
```

This catches situations where Certbot renewed one file but the web server is still serving another certificate or has not reloaded.

There is a small script for this in [`scripts/certbot-renew-check.sh`](../../scripts/certbot-renew-check.sh).
