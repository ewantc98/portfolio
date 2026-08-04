# Immich on Proxmox

I wanted a private photo platform that behaved more like Google Photos than a folder full of JPEGs.

Immich was the best fit, but it also gave me a useful project involving Proxmox, Linux, storage mounts, permissions, databases and backups.

## Setup

The service runs in my Proxmox environment with 8 GB RAM allocated.

The application runs separately from the main photo storage. The storage is mounted from a NAS path into the host and then made available to the workload.

The rough layout is:

```text
NAS
  └── photo data
       ↓ SMB / mounted storage
Proxmox host
  └── Immich workload
       ├── application
       ├── database
       └── photo path
```

## Why I separated the data

The photo library is much larger and more important than the application install.

If the application VM or container needs rebuilding, I want the photos to remain on the NAS. I can then restore the database and reconnect the data path.

The downside is that Immich now depends on:

- the NAS
- the network
- the SMB mount
- correct permissions
- the application database

That is why the dependency needs to be documented.

## Problems I hit

### The mount existed but the application could not write

The Proxmox host could see the folder, but the process inside the workload did not have matching ownership.

I checked numeric IDs rather than names:

```bash
ls -ln /mnt/immich
id
```

Then I tested with a simple file write from inside the workload before blaming Immich itself.

### Storage was available after boot, but not early enough

A network share can come up after the application tries to start.

For persistent mounts I use `_netdev` and make sure the service is not silently writing into an empty local directory when the NAS is missing.

### Photo processing used more resources than expected

Thumbnail generation and initial library work can be heavy. I increased the memory allocation and watched the workload rather than assuming the web interface was the only thing using resources.

## Backup

The minimum useful backup is:

- photo files
- database
- application configuration
- version information

Backing up only the photos would keep the originals but lose albums, users and application state. Backing up only the VM would be poor protection for a large external library.

## What I still need to improve

- automate database backup
- test a full restore into a clean instance
- add clearer monitoring for a missing storage mount
- document the exact upgrade and rollback steps
