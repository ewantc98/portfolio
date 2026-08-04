#!/usr/bin/env bash
# Collect a read-only Linux health snapshot for support and troubleshooting.
# Review output before sharing because it may contain host and network details.

set -uo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly TIMESTAMP="$(date -u +'%Y%m%dT%H%M%SZ')"
readonly OUTPUT_FILE="${1:-./system-health-${TIMESTAMP}.txt}"

section() {
    printf '\n============================================================\n'
    printf '%s\n' "$1"
    printf '============================================================\n'
}

run() {
    local description="$1"
    shift

    printf '\n--- %s ---\n' "$description"
    if command -v "$1" >/dev/null 2>&1; then
        "$@" 2>&1 || printf '[WARN] Command exited with status %s\n' "$?"
    else
        printf '[SKIP] Command not available: %s\n' "$1"
    fi
}

collect() {
    section "Collection metadata"
    printf 'Script: %s\n' "$SCRIPT_NAME"
    printf 'Collected (UTC): %s\n' "$TIMESTAMP"
    printf 'Collector user: %s\n' "$(id -un 2>/dev/null || printf unknown)"

    section "System identity"
    run "Hostname" hostnamectl
    run "Kernel" uname -a
    run "Operating system release" cat /etc/os-release
    run "Uptime and load" uptime

    section "CPU and memory"
    run "CPU summary" lscpu
    run "Memory usage" free -h
    run "Virtual memory activity" vmstat 1 5

    section "Storage"
    run "Filesystem usage" df -hT
    run "Inode usage" df -hi
    run "Block devices" lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL
    run "Mounted filesystems" findmnt

    section "Network"
    run "Addresses" ip -brief address
    run "Routes" ip route
    run "Neighbours" ip neigh
    run "Resolver state" resolvectl status
    run "Listening sockets" ss -lntup

    section "systemd"
    run "Failed units" systemctl --failed --no-pager
    run "Running services" systemctl list-units --type=service --state=running --no-pager
    run "Recent warning/error journal" journalctl -p warning..alert --since "60 minutes ago" --no-pager

    section "Processes"
    run "Top CPU consumers" ps -eo pid,ppid,user,%cpu,%mem,stat,lstart,cmd --sort=-%cpu
    run "Top memory consumers" ps -eo pid,ppid,user,%cpu,%mem,stat,lstart,cmd --sort=-%mem

    section "Containers"
    if command -v docker >/dev/null 2>&1; then
        run "Docker version" docker version
        run "Docker containers" docker ps -a
        run "Docker disk usage" docker system df
    else
        printf '\n[SKIP] Docker is not installed or not in PATH.\n'
    fi

    if command -v pct >/dev/null 2>&1; then
        run "Proxmox LXC list" pct list
    fi

    if command -v qm >/dev/null 2>&1; then
        run "Proxmox VM list" qm list
    fi

    section "Package and reboot state"
    if command -v apt >/dev/null 2>&1; then
        run "Upgradeable APT packages" apt list --upgradable
    fi

    if [[ -f /var/run/reboot-required ]]; then
        printf '\nReboot required: YES\n'
        cat /var/run/reboot-required.pkgs 2>/dev/null || true
    else
        printf '\nReboot required: NO or not reported by this distribution\n'
    fi

    section "Collection complete"
    printf 'Review this file for sensitive information before sharing.\n'
}

if ! collect >"$OUTPUT_FILE" 2>&1; then
    printf 'Health collection completed with an unexpected error. Review: %s\n' "$OUTPUT_FILE" >&2
    exit 1
fi

printf 'Health snapshot written to: %s\n' "$OUTPUT_FILE"
exit 0
