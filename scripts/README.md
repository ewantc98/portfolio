# Scripts and Configuration Examples

These files are sanitised examples that demonstrate how I approach repeatable support and infrastructure tasks.

They are not intended to be run blindly in a production environment. Paths, service names, permissions, retention requirements and organisational controls must be reviewed first.

## Bash

- [`system-health-check.sh`](bash/system-health-check.sh) — collects a concise Linux health and support snapshot without changing the system.
- [`certbot-renew-check.sh`](bash/certbot-renew-check.sh) — validates Certbot state, runs a dry-run renewal and records the result.

## PowerShell

- [`Collect-SupportBundle.ps1`](powershell/Collect-SupportBundle.ps1) — gathers Windows system, network, service and event-log evidence into a timestamped folder.

## Configuration examples

- [Nginx reverse-proxy baseline](../examples/nginx/reverse-proxy.conf)
- [Uptime Kuma Docker Compose example](../examples/docker/uptime-kuma-compose.yml)

## Safety principles

- No credentials, tokens or private keys are embedded.
- Evidence-collection scripts avoid making configuration changes.
- Output may contain sensitive host, user or network information and must be handled securely.
- Scripts use clear exit codes where practical.
- Destructive operations are excluded.
- Commands are written for review and adaptation, not one-click production deployment.

## Validation standard

Before a script is used operationally:

1. Read every command.
2. Test in a disposable or non-critical environment.
3. Confirm required permissions.
4. Review output for sensitive information.
5. Define how failures are reported.
6. Confirm the script does not hide command errors.
7. Record version and changes.
