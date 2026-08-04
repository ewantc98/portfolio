# Nextcloud Snap with a proper domain

I originally treated this as a Docker problem and then realised the installation was the Snap package. That matters because the configuration paths and commands are completely different.

## The problem

Nextcloud worked locally, but using the intended domain produced a trusted-domain error or failed through the proxy.

## Checks

First I confirmed what was installed:

```bash
snap list | grep nextcloud
sudo nextcloud.occ status
```

Then I checked the trusted domains:

```bash
sudo nextcloud.occ config:system:get trusted_domains
```

I added the domain with the next available array index:

```bash
sudo nextcloud.occ config:system:set trusted_domains 1 \
  --value=cloud.example.com
```

## Reverse proxy

For a proxy in front of Nextcloud, the application also needs to understand that the original request was HTTPS.

Typical settings are:

```bash
sudo nextcloud.occ config:system:set overwriteprotocol \
  --value=https

sudo nextcloud.occ config:system:set overwritehost \
  --value=cloud.example.com
```

Depending on the layout, trusted proxies may also be required.

## DNS and certificate

I checked the public DNS record separately from Nextcloud, then checked that the certificate matched the same name.

```bash
dig cloud.example.com
curl -Ik https://cloud.example.com
```

This avoids changing the application when the real fault is a stale DNS record or a certificate issued for a different hostname.

## What I took from it

The main lesson was to identify the packaging method before following a guide.

A Docker Compose example, a Snap install and a normal Apache/Nginx package install can all run Nextcloud, but the commands and file locations are not interchangeable.
