# Troubleshooting Case Studies

These examples show the process used to diagnose infrastructure faults. Details are sanitised and focus on method rather than exposing live systems.

## Case 1: Linux service unavailable after a storage change

### Symptoms

A hosted application stopped responding after its storage path was changed. The VM was running and the reverse proxy remained online, but the application returned errors.

### Investigation

1. Confirmed that DNS and the proxy were working
2. Tested the private application endpoint directly
3. Checked the application service and logs
4. Confirmed the expected storage mount was missing
5. Reviewed the mount configuration and permissions

### Resolution

The storage mount was corrected, permissions were validated and the application was restarted. The service was then tested directly and through the public proxy path.

### Prevention

- Add a mount dependency to the application service
- Monitor the required path rather than only the VM
- Document the storage dependency and recovery order

---

## Case 2: Internal hostname resolves incorrectly

### Symptoms

A private service worked by IP address but failed when accessed by hostname from selected clients.

### Investigation

1. Compared resolver configuration between working and failing clients
2. Queried the internal resolver directly with `dig`
3. Checked the conditional-forwarding rule
4. Cleared stale client-side DNS state
5. Confirmed the correct record from more than one network segment

### Resolution

The affected clients were directed to the approved internal resolver and the forwarding configuration was corrected.

### Prevention

- Keep DNS ownership clear
- Avoid multiple conflicting sources of DHCP-provided DNS
- Test records from each relevant VLAN

---

## Case 3: Virtual machine fails to start

### Symptoms

A virtual machine failed during startup after a storage or configuration change.

### Investigation

1. Read the hypervisor task output rather than repeatedly retrying
2. Checked that referenced storage was online
3. Validated the VM configuration and disk references
4. Confirmed host capacity and permissions
5. Identified whether the fault was compute, storage or configuration related

### Resolution

The invalid or unavailable dependency was corrected and the VM was started successfully.

### Prevention

- Confirm storage health before maintenance
- Record changes to VM disk configuration
- Keep current backups before migrations
- Review task logs before making additional changes

---

## Case 4: TLS renewal failure

### Symptoms

A website remained reachable but presented an expiring or invalid certificate.

### Investigation

1. Checked the active certificate and expiry date
2. Reviewed Certbot or proxy renewal logs
3. Verified public DNS
4. Confirmed port 80 or the required validation path was reachable
5. Checked for conflicting virtual-host configuration

### Resolution

The validation path and web-server configuration were corrected, renewal was completed and the loaded certificate was verified externally.

### Prevention

- Alert before certificate expiry
- Test automated renewal after changes
- Keep DNS and virtual-host ownership documented

## General lesson

The common pattern is to isolate layers, collect evidence and change one variable at a time. This reduces unnecessary disruption and produces a useful root-cause record.
