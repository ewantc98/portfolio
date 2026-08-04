# Network and DNS

My main home network uses private RFC1918 addressing and is larger than a normal single /24 because I have servers, test devices, VPN clients and several service groups.

The exact firewall export is not public. The useful parts are the layout and the decisions behind it.

## Main components

- UniFi Cloud Gateway Max
- MikroTik L009UiGS-RM
- managed switching
- VLANs for separating different types of device
- AdGuard Home for DNS
- WireGuard for remote access
- internal DNS forwarding for lab zones

## How I split the network

I separate devices by what they are allowed to do, not just by what room they are in.

Typical groups are:

- infrastructure management
- hypervisors and servers
- trusted client devices
- hosted services
- guest and less-trusted devices
- VPN clients

I do not allow guest or IoT-style devices to start connections to server management interfaces.

## DNS

AdGuard Home handles normal client DNS and filtering. I also use internal DNS for services that should only exist inside the network.

One setup forwards requests for an internal zone to another resolver:

```text
*.tcad.home -> 10.25.240.99
```

The important part is not the domain itself. It is making sure clients are actually using the resolver that knows where to send those requests.

Useful checks:

```bash
resolvectl status
getent hosts service.tcad.home
dig service.tcad.home
dig @10.25.240.99 service.tcad.home
```

When one machine resolves a name and another does not, I check the DNS server each one received before touching the application.

## WireGuard

I use WireGuard for remote access to private services.

Things I check when a tunnel is connected but traffic does not work:

```bash
wg show
ip route
ip rule
ping -c 3 <remote-private-ip>
traceroute <remote-private-ip>
```

I also check the AllowedIPs on both ends. A healthy handshake only proves the peers can talk to each other. It does not prove the required routes and firewall rules are correct.

## Policy routing

I have used policy routes where one host or service needs to leave through a VPN rather than the normal WAN path.

My checks are:

1. confirm the source address
2. confirm the routing rule matches it
3. inspect the selected routing table
4. check NAT on the chosen egress
5. test the public address from that host
6. make sure return traffic follows a valid path

## Quick fault-finding order

For a service that cannot be reached:

```bash
ip address
ip route
ping -c 3 <gateway>
ping -c 3 <server-ip>
getent hosts <server-name>
nc -vz <server-ip> <port>
```

Then I check:

- VLAN membership
- firewall rules
- whether the service is listening
- reverse proxy logs
- application logs

I try not to change DNS, firewall rules and the application at the same time. That usually makes the original fault harder to find.
