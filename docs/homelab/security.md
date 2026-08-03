# Security Principles

## Scope

This portfolio describes security decisions without exposing the live environment. It is not a complete security baseline, but it shows the controls considered during design and operation.

## Principles

- Keep management interfaces private
- Use VPN access for remote administration
- Segment systems according to trust and purpose
- Grant only the access a service requires
- Store secrets outside source control
- Patch operating systems and applications deliberately
- Maintain recoverable backups
- Log and monitor important service failures

## Secrets management

Credentials, API tokens, private keys and live environment files are excluded from this repository. Public examples use placeholders such as:

```text
${DB_PASSWORD}
${API_TOKEN}
example.com
10.10.20.0/24
```

## Exposure management

Only selected application endpoints should be reachable from the internet. Hypervisor, firewall, NAS and other management interfaces remain on trusted networks.

When a service is published, the review includes:

- Whether public access is actually necessary
- Which ports are required
- TLS and certificate renewal
- Authentication controls
- Reverse-proxy configuration
- Upstream network access
- Logging and update ownership

## Operational security

Changes are made with a rollback path where possible. Temporary firewall rules, test accounts and remote-access peers should be removed after use.

## Public disclosure

Issues involving a genuine security concern should not include credentials or exploit details in a public issue. See the repository-level [security policy](../../SECURITY.md).
