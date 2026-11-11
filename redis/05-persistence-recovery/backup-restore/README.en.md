<div dir="ltr" align="left">

# Backup, Restore, and Disaster-Recovery Practice

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 5 · Level: intermediate to advanced · Lesson and tabletop exercise: 90–150 minutes
>
> Restore only into an isolated instance. Never copy a backup file onto a live service volume.

## Learning objectives

- Distinguish backup from RDB, AOF, replicas, and disk snapshots.
- Write an auditable procedure to create, move outside the failure domain, validate, and retain backups.
- Practice restore on a separate Redis instance and measure actual RPO/RTO.
- Include data correctness, version/configuration, ACLs/secrets, networking, and application recovery in disaster recovery.

## Key concepts

A backup is an independent, recoverable copy of data. Replicas support availability and read capacity; accidental deletion or logical corruption can replicate. RDB/AOF are server persistence mechanisms, but a trustworthy backup must be separate from the original host/volume/zone, and its copy and restore process must be tested with compatible tools and versions.

- **RPO:** Maximum data loss the business accepts.
- **RTO:** Maximum time to restore an acceptable service.
- **Integrity:** Is the file complete, does its checksum match, and can the format be read?
- **Recoverability:** After load, are data and application behavior correct?

A successful Redis `PING` does not prove restore success. Check schema/keys, pending work, expirations, permissions, consumers, and application side effects too.

## A backup workflow

1. Choose a data artifact and record the policy: RDB, AOF, managed snapshot, or a combination.
2. Take the snapshot using the method documented for that deployment. In OSS, you can start `BGSAVE` and verify it succeeded.
3. Wait for save completion; inspect `INFO persistence` and logs. Do not treat a partial file as a valid backup.
4. Transfer a copy to storage outside the host/zone. Apply encryption, ACLs, audit, and retention.
5. Store checksum, timestamp, Redis version, configuration, keyspace details, persistence policy, and source endpoint metadata with the artifact.
6. Alert on failures and assign an owner. An unobserved job can remain broken for a long time.
7. Restore in an isolated environment. Run data checks and an application smoke flow.
8. Record restore cost and duration and include them in RPO/RTO planning.

If you only save RDB, you need a complete finalized file. If you back up multipart AOF, capture the base, incremental files, and manifest consistently. Do not copy individual files at arbitrary times. For a managed service, use the provider's workflow and consistency guarantees.

## Safe RDB lab on Windows and Docker

This lab uses a disposable Redis on port 6379 and a separate restore instance on 6380. It has not been run here; check the container names, ports, and target folders against your machine before running. The ports bind to loopback.

### A. Create sample data

```powershell
docker run -d --name redis-backup-source -p 127.0.0.1:6379:6379 -v ${PWD}/source-data:/data redis:8 redis-server --dir /data --dbfilename dump.rdb --appendonly no --save 60 1
docker exec redis-backup-source redis-cli SET lab:backup:marker "checkpoint-001"
docker exec redis-backup-source redis-cli HSET lab:backup:profile user_id 42 tier learner
docker exec redis-backup-source redis-cli BGSAVE
docker exec redis-backup-source redis-cli INFO persistence
```

Inspect `INFO persistence` and wait until `BGSAVE` completes successfully. In a real environment, verify logs and status; do not copy a temporary file immediately.

### B. Copy the artifact and calculate its checksum

```powershell
New-Item -ItemType Directory -Force .\backup-artifacts | Out-Null
docker cp redis-backup-source:/data/dump.rdb .\backup-artifacts\dump.rdb
Get-FileHash .\backup-artifacts\dump.rdb -Algorithm SHA256
```

This is only a local example, not an offsite backup. Encrypt the artifact in production and move it to separate storage.

### C. Restore into an isolated instance

```powershell
New-Item -ItemType Directory -Force .\restore-data | Out-Null
Copy-Item .\backup-artifacts\dump.rdb .\restore-data\dump.rdb
docker run -d --name redis-restore-lab -p 127.0.0.1:6380:6379 -v ${PWD}/restore-data:/data redis:8 redis-server --dir /data --dbfilename dump.rdb --appendonly no
docker exec redis-restore-lab redis-cli GET lab:backup:marker
docker exec redis-restore-lab redis-cli HGETALL lab:backup:profile
```

The marker should return `checkpoint-001`; the Hash should have two fields. To connect from a local host `redis-cli` on port 6380, run `redis-cli -p 6380`. Restore never runs on the source instance.

### D. Measure recovery

Record separately the time until restore starts responding to `PING`, the time until all data checks pass, and the time until the application is ready. Production RTO includes restart, loading, validation, secrets/network recovery, and cutover—not just RDB load speed.

## AOF, managed backups, and the restore window

For AOF, the backup must include all files required by that version. Capture the manifest and base/incremental files consistently. Cloud or managed snapshots may have retention, encryption, region, consistency, and plan limitations. Read the provider documentation as a recovery contract and test restore in a separate account or region.

Make the reconciliation plan clear for writes made after the backup: replay business events, accept loss up to RPO, take a newer snapshot, or investigate manually. A backup can return you to a point before deletion/corruption; it does not automatically contain later writes.

## Published experience: what an untested backup means

During GitLab.com's 2017 outage, PostgreSQL backups were failing because of a `pg_dump` version mismatch, and failure alerts were not properly seen. When the team needed to recover, the expected backup was unavailable. This was not a Redis incident, but the operational lesson applies directly to a Redis runbook: monitor backup jobs, test restores periodically, and include the full storage/transfer/restore path in RTO. [Official GitLab postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

GitLab Geo's early notification/retry design also showed that job persistence, event order, recovery, and resynchronization depend on queue and storage design. The article describes one product architecture, not a general Redis benchmark. [GitLab Geo architecture history](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

## Restore runbook checklist

- [ ] What incident triggers a restore, and who decides?
- [ ] Which is the last valid backup? What are its timestamp, checksum, and version?
- [ ] Which keys and namespaces matter? Will short TTLs expire before the restore is finished?
- [ ] Are RDB/AOF and modules/data types compatible with the target version?
- [ ] Is the destination isolated, with no workers that could trigger unintended side effects?
- [ ] Are ACLs, credentials, TLS, DNS, firewall, and client configuration ready for the destination?
- [ ] Have sample data, counts, Stream PEL/cursors, and business invariants been checked?
- [ ] How will write traffic be cut over or rolled back?
- [ ] What happens to writes after the snapshot? Is reconciliation/replay/accepted loss explicit?
- [ ] Have actual RPO/RTO and a follow-up owner been recorded?

## Common pitfalls

- **Backup on the same host:** It shares a failure domain; keep an independent copy.
- **Archiving a replica:** A logical mistake may have replicated; use a separate point-in-time backup.
- **Copying before snapshot completion:** The artifact may be incomplete.
- **Testing restore in production:** Creates overwrite/traffic risk; use a separate destination.
- **Checking only `PING`:** A file loading does not prove application health.
- **Restoring an old copy without catch-up:** Writes after the checkpoint are missing; plan replay/reconciliation.
- **Backup credentials are too broad:** Restrict access, encrypt at rest, and audit.
- **Job succeeded but artifact was not transferred:** The lifecycle includes generate, verify, upload, retention, and notification.

## Exercises

1. Run the local lab and read the marker and Hash from the restore instance.
2. Fill in an RPO/RTO table for a cache and a Stream.
3. Tabletop: the latest backup is six hours old and the primary is gone. Which teams, secrets, and decisions are needed?
4. Write restore-success criteria that go beyond `PING`.

**Answer criteria:** A valid independent artifact, measured timings, compatible version, data checks, application readiness, cutover/rollback plan, and an explicit decision about post-backup writes.

## Quiz with answers

### 1. Is a replica the same as a backup?

<details><summary>Answer</summary>

No. It may immediately receive an accidental or incorrect deletion.

</details>

### 2. What proves restore success?

<details><summary>Answer</summary>

Loading the artifact plus data checks, an application flow, dependency recovery, and cutover within the required time.

</details>

### 3. What does RTO include?

<details><summary>Answer</summary>

Artifact transfer, loading, validation, access/network configuration, and application/traffic recovery.

</details>

### 4. Why is a checksum useful?

<details><summary>Answer</summary>

It helps detect file changes or corruption in transfer/storage. By itself, it does not prove semantic data correctness.

</details>

### 5. How should you back up multipart AOF?

<details><summary>Answer</summary>

Capture a consistent set containing the manifest and all required files, following the official version-specific workflow.

</details>

### 6. What issue remains after restoring an old backup?

<details><summary>Answer</summary>

Writes after the backup must be replayed/reconciled, or the accepted loss must be explicitly declared.

</details>

## References and further reading

### English: official documentation and incident reports

- [Redis persistence and backup documentation](https://redis.io/docs/latest/management/persistence/) — RDB/AOF and persistence context.
- [BGSAVE command reference](https://redis.io/docs/latest/commands/bgsave/) — create and observe a background RDB snapshot.
- [Redis at Scale: persistence and durability](https://redis.io/tutorials/operate/redis-at-scale/persistence-and-durability/) — backup and recovery walkthrough.
- [Redis common errors: MISCONF](https://redis.io/docs/latest/develop/reference/errors/common/misconf/) — persistence failure conditions.
- [GitLab database outage postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/) — PostgreSQL backup failure and recovery lesson.
- [GitLab Geo architecture article](https://about.gitlab.com/blog/how-we-built-gitlab-geo/) — event queue and recovery design.
- [Redis replication documentation](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/) — replica behavior and its relationship to backup.

### فارسی

- [راهنمای فارسی persistence و backup در Urhoba](https://www.urhoba.net/fa/post/redis-persistence-snapshot)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

Persian material on restore drills is limited. This runbook and lab teach the core practices directly. Verify offsite and consistency behavior against your production version and provider.

</div>

