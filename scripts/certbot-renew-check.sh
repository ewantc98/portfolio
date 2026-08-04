#!/usr/bin/env bash
# Lists Certbot certificates and runs a renewal dry run.

set -u

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    echo "Run this as root so Certbot can read its configuration." >&2
    exit 1
fi

if ! command -v certbot >/dev/null 2>&1; then
    echo "Certbot is not installed." >&2
    exit 1
fi

echo "== Certbot version =="
certbot --version
echo

echo "== Managed certificates =="
certbot certificates
echo

echo "== Renewal timer =="
if command -v systemctl >/dev/null 2>&1; then
    systemctl status certbot.timer --no-pager || true
    systemctl list-timers --all | grep -i certbot || true
else
    echo "systemd not found"
fi
echo

echo "== Renewal dry run =="
certbot renew --dry-run
