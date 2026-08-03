# Storage and Backup Strategy

## Storage platforms

The lab has used Synology and TrueNAS systems alongside local server storage. Work has included SMB shares, iSCSI, virtualisation storage, application-data mounts and restricted backup access.

## Design goals

- Keep important data separate from disposable compute where practical
- Restrict storage access to systems and users that require it
- Avoid treating RAID as a backup
- Maintain more than one copy of important data
- Document restore dependencies and order

## Storage use cases

| Use case | Typical protocol | Key concern |
|---|---|---|
| Shared files | SMB | Permissions and access scope |
| Application media | SMB or mounted dataset | Availability and ownership |
| Virtualisation datastore | iSCSI or supported network storage | Latency, integrity and host access |
| Backup repository | Restricted SMB or dedicated target | Isolation from the source system |

## Backup model

A useful backup strategy considers:

1. What data must be protected
2. How frequently it changes
3. How long recovery can take
4. Whether the backup is isolated from the source
5. How restoration will be tested

Representative layers include local application or VM backups, NAS-based copies and an off-site copy for selected important data.

## Recovery thinking

Restoration is planned in dependency order:

1. Network and storage availability
2. Hypervisor or operating-system platform
3. Database and persistent data
4. Application service
5. DNS, proxy and certificate path
6. User validation

## Operational checks

```bash
df -h
lsblk
mount
findmnt
smbclient -L //server.example -U user
```

Checks also include permissions, backup-job history, repository capacity and whether a recent restore test has succeeded.

## Security

- Backup credentials are not committed to source control
- Backup destinations use restricted accounts
- Storage administration is limited to trusted networks
- Public documentation omits live share names and addresses
