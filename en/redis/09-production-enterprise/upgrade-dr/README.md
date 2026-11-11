<div dir="ltr" align="left">

# Redis Upgrades, Failover, and Disaster Recovery

> Path: Chapter 9 · Level: advanced · Lesson and tabletop: 90–140 minutes
>
> This is an operational design lesson. Match every command and sequence to the exact Redis version, topology, provider, and runbook before an incident.

> Persian edition: [ارتقا، failover و Disaster Recovery برای Redis](../../../../fa/redis/09-production-enterprise/upgrade-dr/README.md)

## Learning objectives

- Distinguish a software upgrade, failover, and disaster recovery by purpose and data outcome.
- Build an upgrade preflight around compatibility, persistence, capacity, replication, and rollback.
- Define measurable recovery point objective (RPO) and recovery time objective (RTO).
- Run a staged upgrade and a restore drill that validates application data, not just process health.
- Reason about lag, retry storms, stale state, logical deletion, corruption, and regional failure.

## Three operations with different jobs

| Operation | Goal | Typical data question |
| --- | --- | --- |
| Upgrade | Move binaries, protocol, modules, or configuration to a supported target | Can the new and old nodes read the data and communicate during the transition? |
| Failover | Keep serving after a primary, process, node, or zone fails | How much acknowledged or recent data might be missing on the promoted replica? |
| Disaster recovery (DR) | Rebuild after loss, corruption, accidental deletion, or a broad regional outage | Which independent backup or replica is trustworthy, and how do we validate and cut over? |

A failover usually restores service quickly from an existing replica. It does not repair a corrupted keyspace or undo a delete that already replicated. DR requires a known recovery point, a separate restore location, validation, and a controlled traffic change.

Before choosing any procedure, draw the real topology: standalone, primary/replica, Sentinel, Cluster, Redis Software, Redis Cloud, or another managed service. Their upgrade controls and failure modes are different.

## 1. Upgrade preflight

Record a change plan before touching production:

1. **Versions and path:** current and target Redis versions, release notes, supported intermediate steps, security advisories, modules, clients, and management software.
2. **Topology and ownership:** primary/replicas, shard and Sentinel layout, managed-service boundaries, traffic-routing owner, and people authorized to stop or roll back.
3. **Compatibility:** commands, data types, persistence formats, client library, TLS/ACL behavior, proxy, monitoring exporter, scripts/functions, and automation.
4. **Capacity:** free RAM and disk, fork copy-on-write headroom, full-sync duration, replication backlog, expected reconnects, and restore capacity.
5. **Recovery proof:** a recent independent backup, checksum/manifest, a destination that has enough space, and a completed restore test using the target version.
6. **Baseline and stop conditions:** latency and errors by percentile, memory, evictions, persistence status, replica lag, connection count, and explicit abort thresholds.
7. **Application readiness:** retry/backoff behavior, idempotency, cache warmup, data migration compatibility, and a way to compare business-level results after the change.

Redis 8 brings several formerly separate Stack capabilities into Redis Open Source, but that does not erase differences in database version, provider, modules, client support, or data-format compatibility. Test the exact endpoint and command surface you intend to operate.

## 2. A staged rollout pattern

Use the official procedure for the topology. For a replicated deployment, a common conceptual sequence is to upgrade a replica first, observe it, move leadership only under the approved procedure, then upgrade the former primary and remaining nodes. The exact order and availability guarantees vary.

### Before the change

- Freeze unrelated risky changes and announce the maintenance window.
- Confirm backups and the tested restore point.
- Capture health, latency, replication lag, persistence, and client connection baselines.
- Confirm a known-good package or image and the rollback trigger.

### During the change

1. Upgrade one canary or replica.
2. Verify process health, expected version, client commands, memory, persistence, replica link, and application latency.
3. Continue one node or shard at a time while preserving enough healthy capacity.
4. Perform a controlled failover only if the documented sequence requires it.
5. Upgrade remaining nodes and confirm the intended primary/shard roles.
6. Drain or reconnect clients according to the runbook; avoid a synchronized connection storm.

### After the change

- Verify version and topology on every node.
- Check replication, persistence state, cluster health, and provider metrics where supported.
- Exercise representative reads, writes, TTLs, streams/consumer groups, ACLs, and application transactions.
- Compare business invariants and data counts; a successful PING is only a process-level check.
- Keep a rollback or forward-fix decision window. Writes made after a schema or format change can make binary rollback unsafe.

For managed Redis, the provider may perform node work. The application team still owns compatibility, retry behavior, data validation, backup policy, and proof that recovery meets its SLO.

## 3. Triage and choose a recovery path

Start with read-only diagnosis: process/node health, DNS and network, TLS/credentials, CPU, memory and eviction, disk/persistence logs, replication lag, and recent configuration or deploy changes.

| Finding | Possible response |
| --- | --- |
| One primary failed and a healthy replica is available | Follow the Sentinel, Cluster, or provider failover runbook; measure any loss window. |
| Process stopped but persistence files are intact | Preserve the artifact, restart/load in an isolated or controlled target, then validate before serving. |
| Data was deleted or corrupted and the deletion replicated | Restore an earlier point in an isolated destination; reconcile before cutover. |
| Node, disk, or region is lost | Restore an independently retained backup or use the documented regional DR design. |
| Clients are retrying aggressively | Add bounded exponential backoff with jitter, concurrency limits, and circuit breaking; protect the origin database too. |

Do not overwrite the only surviving copy while investigating. Record incident timestamps, last known good write, backup age, replica lag, and operator actions.

## 4. Make RPO and RTO measurable

- **RPO** is the maximum acceptable amount of data loss, commonly expressed as elapsed time or acknowledged writes.
- **RTO** is elapsed time from the agreed incident start until the user-facing service is healthy and validated.

An RTO target must include detection, decision, provisioning, artifact transfer, load/replay time, validation, client reconnect or DNS propagation, cache warming, and traffic ramp. “Restore takes ten minutes” is not a service RTO if validation and cutover take another hour.

During a drill, record:

- The last acknowledged write and whether it exists after recovery.
- Backup creation time, artifact integrity, restore duration, and data gap.
- Duplicate or missing events and the reconciliation source.
- Time to detection, decision, restore, validation, and full traffic.
- Error rate, p95/p99 latency, origin load, and the person who approved each step.

## 5. Published incident lesson: backup jobs must be observed

GitLab’s January 2017 database outage postmortem describes failed PostgreSQL backup attempts and a recovery from an older snapshot. This was a PostgreSQL incident, not a Redis incident. The useful Redis lesson is general: a configured backup job is not proof of a usable backup. Alert on actual artifact creation, inspect logs and checksums, retain copies outside the failure domain, and rehearse loading them. [GitLab database outage postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

## 6. Regional-outage tabletop

Assume the active region is unreachable. Clients reconnect at once. A second-region copy was three seconds behind, and the last independent backup is two hours old.

1. Who selects the recovery region, and what evidence authorizes the decision?
2. What acknowledged writes could be missing? Can the source system or event log reconcile them?
3. How do clients receive the new endpoint and credentials without exposing secrets?
4. What traffic percentage returns first, and how do you prevent an origin-database stampede?
5. Is the cache rebuilt empty, restored, or warmed gradually? Which option preserves correctness?
6. What is required before failback? Who reconciles writes made in both regions?

Run the exercise with a clock and a scribe. A tabletop tests decision-making; a real restore drill is still needed to measure the storage and data path.

## Runbook template

~~~text
Service / cluster:
Current and target version:
Topology / provider / region:
Incident commander / operator / application owner:
RPO / RTO:
Last validated backup, checksum, and restore location:
Read-only diagnostics:
Stop conditions / rollback trigger:
Failover or isolated restore sequence:
ACL, TLS, DNS, client configuration, and secret owner:
Data checks / source-of-truth reconciliation:
Traffic ramp / rollback:
Incident timestamps, metrics, and follow-up owner:
~~~

## Common failure patterns

- **Upgrading every node together:** removes the canary and may remove healthy capacity.
- **Assuming replica equals backup:** a bad write or deletion can replicate.
- **Testing only PING:** misses stale, incomplete, or semantically invalid application data.
- **Restoring over the only copy:** destroys evidence and can remove the last recovery option.
- **Using unbounded retries:** converts a small failure into a connection and database surge.
- **Treating rollback as binary-only:** new writes or persistence formats may make rollback unsafe.
- **Failing back automatically:** two writable regions can create a second reconciliation problem.

## Exercises

1. Write an upgrade checklist for a three-primary Cluster with replicas. Include one stop condition and one application-level validation.
2. A replica is 2.5 seconds behind at promotion. Describe what can be lost and how the application might detect or reconcile it.
3. A backup job reports success, but the file is one byte. Which monitoring and restore gates would have caught this before an incident?
4. A cache restore takes 20 minutes, warmup takes 35 minutes, and traffic ramp takes 10 minutes. What is the minimum demonstrated RTO, excluding detection and decision time?

**Answer guide:** 1) Follow the Cluster upgrade guide, preserve capacity, check client routing/slot health and exercise representative reads and writes. 2) Writes not yet replicated may be absent; use an authoritative log or database to reconcile, and do not promise zero loss. 3) Artifact size/checksum, retention, load test, data checks, and an alert on the complete pipeline. 4) At least 65 minutes after recovery work begins, plus detection and decision.

## Quiz

### 1. Why is failover not a substitute for disaster recovery?

<details><summary>Answer</summary>

Failover uses another live copy. It may preserve an unwanted deletion or corruption. DR needs an independent recovery point and validation.

</details>

### 2. What does RPO describe?

<details><summary>Answer</summary>

The amount of data or time of acknowledged writes the service can accept losing.

</details>

### 3. When should an upgrade stop?

<details><summary>Answer</summary>

At a predefined threshold such as rising application errors, unexpected data-format behavior, unhealthy replication, or insufficient capacity.

</details>

### 4. Does a successful backup process prove a successful recovery?

<details><summary>Answer</summary>

No. The artifact must be present, intact, loadable, and semantically valid, and the entire restore/cutover duration must be measured.

</details>

### 5. Why use bounded retries and jitter?

<details><summary>Answer</summary>

They reduce synchronized reconnect and retry spikes while the dependency is recovering.

</details>

### 6. What must be true before rollback?

<details><summary>Answer</summary>

The old version must be compatible with the data and writes produced since the upgrade, or a documented forward-recovery/reconciliation plan must exist.

</details>

## References and further reading

### English: official and engineering sources

- [Upgrade Redis Open Source](https://redis.io/docs/latest/operate/oss_and_stack/install/upgrade/) — supported upgrade paths and topology-specific procedures.
- [Upgrade a Redis Cluster](https://redis.io/docs/latest/operate/oss_and_stack/install/upgrade/cluster/) — Cluster-specific sequence.
- [Redis administration](https://redis.io/docs/latest/operate/oss_and_stack/management/admin/) — operational administration topics.
- [Redis persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/) — RDB/AOF and persistence behavior.
- [Redis persistence and backup](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/) — RDB/AOF persistence and backup guidance.
- [Recover a failed Redis Software database](https://redis.io/docs/latest/operate/rs/databases/recover/) — product-specific recovery procedure.
- [Redis replication](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/) — asynchronous replication and replica behavior.
- [Google SRE: Lessons Learned](https://sre.google/sre-book/lessons-learned/) — published experience that discusses disaster-recovery testing.
- [GitLab database outage postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/) — PostgreSQL incident; transferable backup-process lessons only.

### فارسی

- [آموزش فارسی Redis در SalamLang](https://www.salamlang.ir/std/db/redis/) — مفاهیم پایه؛ برای upgrade و recovery عملیاتی کافی نیست.
- [مرور فارسی persistence و ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf) — مرور کلی ساختارها و ماندگاری.
- [جست‌وجوی فارسی Redis Backup و Restore](https://www.google.com/search?q=آموزش+فارسی+Redis+backup+restore+RDB+AOF)
- [جست‌وجوی فارسی Redis Disaster Recovery و ارتقا](https://www.google.com/search?q=آموزش+فارسی+Redis+Disaster+Recovery+upgrade)

پوشش فارسیِ runbook برای Redis کم است؛ این درس مدل عملیاتی و tabletop را خودبسنده آموزش می‌دهد. فرمان‌های production را از مستند همان نسخه و سرویس تطبیق بده.

</div>

