# Internal DNS and conditional forwarding

## What happened

Some devices could resolve internal names and others could not. The service itself was working by IP.

## Cause

The devices were not all using the same DNS path.

One resolver knew that queries for the internal zone should go to `10.25.240.99`. Other devices were using a different resolver and getting no answer.

## Checks

On Linux:

```bash
resolvectl status
cat /etc/resolv.conf
dig service.tcad.home
dig @10.25.240.99 service.tcad.home
```

On Windows:

```powershell
Get-DnsClientServerAddress
Resolve-DnsName service.tcad.home
Resolve-DnsName service.tcad.home -Server 10.25.240.99
```

## Fix

I made the internal forwarding rule consistent and checked the DHCP-provided DNS settings.

The forwarding rule is conceptually:

```text
queries for tcad.home -> 10.25.240.99
```

Then I renewed the client lease or cleared the local cache where needed.

Windows:

```powershell
ipconfig /flushdns
ipconfig /renew
```

Linux with systemd-resolved:

```bash
sudo resolvectl flush-caches
```

## Validation

I checked:

- name resolves
- returned address is correct
- service port is reachable
- browser/application uses the same name
- no public DNS server receives the private query

The last check matters because internal names should not be leaking into public DNS logs.
