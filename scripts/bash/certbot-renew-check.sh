#!/usr/bin/env bash
# Validate Certbot-managed certificates and perform a renewal dry run.
# This script does not force live certificate issuance.

set -uo pipefail

readonly TIMESTAMP="$(date -u +'%Y%m%dT%H%M%SZ')"
readonly OUTPUT_FILE="${1:-./certbot-renew-check-${TIMESTAMP}.log}"

log() {
    printf '[%s] %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" "$*"
}

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    printf 'Run as root so Certbot can read its configuration and logs.\n' >&2
    exit 2
fi

if ! command -v certbot >/dev/null 2>&1; then
    printf 'Certbot is not installed or not in PATH.\n' >&2
    exit 3
fi

{
    log "Starting Certbot renewal validation"
    log "Host: $(hostname -f 2>/dev/null || hostname)"
    log "Certbot version: $(certbot --version 2>&1)"

    printf '\n=== Managed certificates ===\n'
    certbot certificates

    printf '\n=== Timer status ===\n'
    if command -v systemctl >/dev/null 2>&1; then
        systemctl status certbot.timer --no-pager 2>&1 || true
        systemctl list-timers --all 2>&1 | grep -i certbot || true
    else
        printf 'systemctl not available; timer status skipped.\n'
    fi

    printf '\n=== Renewal dry run ===\n'
    if certbot renew --dry-run; then
        dry_run_status=0
        log "Renewal dry run succeeded"
    else
        dry_run_status=$?
        log "Renewal dry run failed with status ${dry_run_status}"
    fi

    printf '\n=== Recent Certbot journal ===\n'
    if command -v journalctl >/dev/null 2>&1; then
        journalctl -u certbot --since '24 hours ago' --no-pager 2>&1 || true
    fi

    printf '\n=== Validation summary ===\n'
    if [[ $dry_run_status -eq 0 ]]; then
        printf 'Result: PASS\n'
        printf 'No live renewal was forced. Automated renewal should still be monitored.\n'
    else
        printf 'Result: FAIL\n'
        printf 'Review DNS, challenge reachability, authenticator configuration and logs.\n'
    fi
} >"$OUTPUT_FILE" 2>&1

printf 'Certbot validation report written to: %s\n' "$OUTPUT_FILE"
printf 'Review the report before sharing; domain names and server details may be sensitive.\n'

exit "$dry_run_status"
