#!/usr/bin/env bash
# Quick Linux health report. I use this before making changes to a server.

set -u

output="${1:-system-health-$(date +%Y%m%d-%H%M%S).txt}"

{
    echo "Linux health check"
    echo "Generated: $(date --iso-8601=seconds)"
    echo

    echo "== Host =="
    hostnamectl 2>/dev/null || hostname
    echo

    echo "== Uptime and load =="
    uptime
    echo

    echo "== Memory =="
    free -h
    echo

    echo "== Filesystems =="
    df -hT
    echo

    echo "== Failed systemd units =="
    if command -v systemctl >/dev/null 2>&1; then
        systemctl --failed --no-pager || true
    else
        echo "systemd not found"
    fi
    echo

    echo "== Listening TCP/UDP ports =="
    if command -v ss >/dev/null 2>&1; then
        ss -lntup
    else
        echo "ss not found"
    fi
    echo

    echo "== Recent high-priority journal entries =="
    if command -v journalctl >/dev/null 2>&1; then
        journalctl -p err -n 50 --no-pager || true
    else
        echo "journalctl not found"
    fi
} > "$output" 2>&1

echo "Report written to $output"
echo "Check it before sharing; it may contain hostnames, addresses and service names."
