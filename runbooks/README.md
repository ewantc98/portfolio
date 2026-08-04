# Operational Runbooks

These runbooks turn troubleshooting experience into repeatable operational procedures. They are written for a small infrastructure or support environment and must be adapted to local change, access and escalation policies before use.

The runbooks deliberately prioritise evidence collection, low-risk restoration and user validation over repeated restarts or unrelated configuration changes.

## Runbook structure

Each runbook covers:

- Trigger and impact
- Safety checks
- Initial evidence
- Layered diagnosis
- Restoration options
- Validation
- Escalation
- Documentation and prevention

## Available runbooks

- [Linux service outage](linux-service-outage.md)
- [Storage unavailable](storage-unavailable.md)
- [Certificate renewal](certificate-renewal.md)
- [Virtual machine will not start](vm-will-not-start.md)

## Incident priority guide

| Priority | Example impact | Response approach |
|---|---|---|
| P1 | Critical service unavailable to all users; safety or major business impact | Immediate ownership, frequent communication, restore first, investigate in parallel |
| P2 | Important service degraded or unavailable to a significant group | Prompt response, workaround where possible, structured diagnosis |
| P3 | Limited user or non-critical service issue | Normal queue, evidence-led resolution and documentation |
| P4 | Request, improvement or low-impact defect | Planned work with normal change controls |

A homelab does not have formal business SLAs, but using an impact model develops the same prioritisation discipline.

## Universal first-response checklist

1. Confirm the service and affected users.
2. Record the start time and current symptoms.
3. Establish whether any recent change occurred.
4. Check monitoring and known dependencies.
5. Preserve relevant logs before restarting services.
6. Avoid changing multiple layers at once.
7. Define a safe restoration action and rollback.
8. Validate from the user perspective.
9. Record cause, resolution and follow-up work.

## Escalation information pack

When escalating, include:

- Service and business impact
- Start time and timeline
- Systems and users affected
- Recent changes
- Tests performed and results
- Relevant error messages
- Logs or event IDs
- Workarounds attempted
- Current service state
- Specific assistance required

“Still broken” is not a useful escalation. The objective is to reduce duplicated diagnosis and help the next engineer act quickly.
