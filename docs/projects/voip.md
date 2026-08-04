# 3CX, FreePBX and SIP

I have worked with 3CX v20, FreePBX and Grandstream UCM systems.

My lab and project work has covered:

- extensions
- SIP registration
- trunks
- inbound and outbound routes
- ring groups
- endpoint provisioning
- NAT and firewall issues
- codecs
- emergency call restrictions

## SIP registration

For an endpoint to register, I need:

- registrar or PBX address
- extension/authentication ID
- password
- transport and port
- network path to the PBX

The “endpoint” field on a provider portal is not always the SIP registrar. I check the provider documentation and, where possible, compare it with a known working device.

## Fault-finding

A registration failure can come from several places:

- wrong username or auth ID
- wrong password
- wrong registrar
- NAT rewriting
- blocked SIP or RTP traffic
- certificate/transport mismatch
- account already registered elsewhere
- provider IP restrictions

On a Linux PBX I use packet capture when the logs are not enough:

```bash
tcpdump -ni any port 5060
```

For TLS:

```bash
tcpdump -ni any port 5061
```

I am looking for whether the request leaves, whether a response comes back, and the SIP response code.

## One-way audio

One-way audio is usually an RTP path problem rather than a registration problem.

I check:

- advertised media address
- NAT
- RTP port range
- firewall state
- whether the endpoint is behind another router
- whether a SIP ALG is interfering

## Community PBX work

For a public/community PBX project I made sure emergency calls were blocked. A test platform should not accidentally route 999/112 or make users think it is a replacement for a normal telephone service.

That kind of restriction needs to exist in the dial plan, not just in a disclaimer on a website.
