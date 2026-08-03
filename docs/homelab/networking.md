# Networking Design

## Objectives

The network is designed to provide clear separation between management systems, servers, user devices, hosted services and untrusted endpoints.

The published documentation uses example addressing only.

## Example segmentation model

| Network | Example subnet | Purpose |
|---|---|---|
| Management | `10.10.10.0/24` | Hypervisors, switches, firewalls and NAS administration |
| Servers | `10.10.20.0/24` | General server workloads |
| Services | `10.10.30.0/24` | DNS, proxy, monitoring and shared applications |
| Clients | `10.10.40.0/24` | Trusted user endpoints |
| Guest / IoT | `10.10.50.0/24` | Devices requiring restricted access |

## Policy approach

Traffic is permitted according to need rather than assuming every internal device should communicate freely.

Examples include:

- Trusted administrators can reach management interfaces
- Client devices can use approved DNS and application services
- Guest and IoT devices cannot initiate connections to management systems
- Internet-facing services have narrowly defined paths to required back-end services
- Storage protocols are restricted to systems that need them

## DNS

Internal DNS provides memorable names for private services and avoids dependence on raw IP addresses. Conditional forwarding can direct queries for an internal zone to the appropriate resolver.

Typical troubleshooting checks include:

```bash
resolvectl status
dig service.lab.example
dig @10.10.30.10 service.lab.example
```

The real internal domain and addresses are not published.

## Remote access

WireGuard provides encrypted access to approved private resources. Management interfaces are not intentionally exposed directly to the internet.

Remote-access design considerations include:

- Unique peer keys
- Narrow allowed-address ranges
- Removal of unused peers
- Firewall rules that match the user's operational need
- Separate treatment of administrative and general access

## Platforms

The lab has used MikroTik and UniFi networking platforms. Practical tasks include VLAN configuration, routing, DNS forwarding, policy routes, VPN connectivity and diagnosis of reachability problems.

## Troubleshooting sequence

When a service cannot be reached, checks are performed in layers:

1. Confirm link and VLAN membership
2. Confirm address, gateway and route
3. Test connectivity by IP
4. Test DNS independently
5. Test the destination port
6. Check firewall policy
7. Check whether the service is listening
8. Review reverse-proxy or application logs

Example commands:

```bash
ip address
ip route
ping -c 4 10.10.30.10
getent hosts service.lab.example
nc -vz service.lab.example 443
ss -lntup
```

## Security considerations

- No credentials or private keys are stored in this repository
- Public diagrams do not expose the live addressing scheme
- Firewall rules are described conceptually rather than copied wholesale
- Administrative interfaces remain private
