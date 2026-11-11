<div dir="ltr" align="left">

# Choosing Redis Persistence Modes

> Persian edition: [Read this lesson in Persian](../../../../fa/redis/05-persistence-recovery/persistence-modes/README.md)

> Path: Chapter 5 · Level: intermediate · Time: 60–90 minutes
>
> Persistence, replication, and backup are separate concepts. This is a decision guide, not a ready-made production configuration.

## Learning objectives

- Compare no persistence, RDB, AOF, and combined RDB+AOF.
- Define RPO and RTO in business terms for a workload.
- Decide when Redis can be the primary data source and when it is a cache or projection.
- Evaluate failure domains, backup, and restore alongside durability.

## The central idea

Redis usually keeps state in RAM first, but it can also write state to disk. Durability answers: “After a restart, how much of the data can I reconstruct?” Replication asks: “If one node fails, can a replica take over?” Backup asks: “After accidental deletion, corruption, or a regional failure, do I have an independent recoverable copy?” None of these replaces the others.

## Decision vocabulary

- **RPO (Recovery Point Objective):** How much data, or what time window of accepted writes, can the business afford to lose?
- **RTO (Recovery Time Objective):** How long may it take before the service is usable again? Copying, loading, validation, and cutover count too.
- **Failure domain:** A server, disk, zone, credential, or system whose failure can destroy multiple copies at once.
- **Source of truth:** The system that stores the final business record. A cache may be rebuilt from it.

## Compare the modes

| Mode | Operational cost | Main risk | Common fit |
| --- | --- | --- | --- |
| No persistence | Low; no persistence write I/O | Restart or host loss removes in-memory data | Fully rebuildable, low-impact cache |
| RDB | Periodic snapshots and background work | Writes after the latest snapshot may not be present after restart | Snapshots/backups, caches for which a recovery point is enough |
| AOF | Append log, fsync, and rewrite | Disk use, log size, and longer recovery; durability depends on policy and storage | State where replaying recent writes matters more than snapshot alone |
| RDB + AOF | More resource use and operations | Two mechanisms add complexity and still do not guarantee zero loss | Workloads that benefit from both snapshots and AOF recovery |

For data you cannot afford to lose, keep a **backup outside the host** regardless of the persistence mode. When both are enabled, Redis generally uses AOF to rebuild on startup because it is usually more current.

## Decisions for four workloads

### 1. Product-page cache

If PostgreSQL is the source of truth and a job can rebuild the cache, no persistence may avoid disk persistence overhead. But a restart can create a cold-cache stampede against the database. Plan cache warming, TTL jitter, concurrency limits, and database protection. “Rebuildable” does not mean “free to lose.”

### 2. User sessions

Losing a session may log a user out. Analyze session lifetime, failover behavior, and user experience. If that loss is unacceptable, choose RPO, AOF/RDB or managed persistence, replication, and backup together. Protect session secrets with ACL/TLS and encryption at rest in backup storage.

### 3. Approximate analytics counter

If raw source events exist and can rebuild the counter, a larger RPO may be acceptable. If they do not, the counter may need more durable storage or a stricter persistence policy. Define whether losing one time window matters.

### 4. Order state or a ledger

An ephemeral Redis cache is usually not a suitable source of truth for a financial ledger. If Redis is the primary store for any workload, persistence, replication, backups, restore, fsync policy, capacity, durability semantics, audit, and recovery design must meet the product SLA. Do not move financial data to Redis just because it is fast.

## Published experience: GitLab's statistics decision

When GitLab evaluated storing aggregated namespace statistics, it considered a Redis Set but wrote that PostgreSQL better fit information that could not be lost because of persistence/consistency needs and made the analytical query simpler. The case shows that write speed is not the only criterion; query shape and the cost of rebuilding or losing data also matter. It describes one GitLab design, not a universal rule. [GitLab database case study: storing and updating namespace statistics](https://about.gitlab.com/blog/database-case-study-store-and-update-namespace-statistics/)

## Four questions before configuration

1. When does Redis return “write accepted,” and exactly what has reached disk or a replica at that point?
2. How much loss is acceptable after a process crash, OS crash, disk loss, zone loss, or human error?
3. Who chooses which backup version to restore?
4. What happens to writes made after the backup: accept the loss, replay, reconcile, or rebuild?

If these answers are unclear, do not choose configuration numbers at random. Define ownership and the recovery contract first.

## Example selection matrix

| Data | Rebuildable? | Example RPO | Persistence to evaluate | Backup/restore |
| --- | --- | --- | --- | --- |
| Rebuildable cache | High | May be relatively large | Off, or light RDB/AOF depending on cold-start cost | Cache data may not need backup, but a rebuild runbook does |
| Session | Medium | User experience matters | RDB/AOF with explicit policy and HA | Independent export or managed backup as needed |
| Queue or Stream | Low to medium | Based on acceptable job loss | AOF/fsync, replica/`WAIT`, and replay semantics | Consistent backup and a redrive method |
| Financial counter | Low | Near-zero business loss | Reconsider the authoritative source first | Backup outside the failure domain and reconciliation |

These RPO examples are not configuration prescriptions. The product team must choose and test them.

## Lab: think before changing configuration

For each of three imaginary keys, fill in importance, source of truth, RPO, RTO, persistence, replica, backup, and restore check:

```text
catalog:product:501     cache        source=PostgreSQL       rebuild=yes
session:opaque-id       user session source=Redis?            rebuild=no
orders:stream           event log    source=?                 rebuild=?
```

Do not run `CONFIG SET` or restart a real Redis service before you understand its policy. In a lab, read `INFO persistence`, `CONFIG GET save`, and `CONFIG GET appendonly`, then record the difference between local settings and your managed service.

## Common pitfalls

- **“A replica is a backup”:** Accidental deletion or logical corruption may replicate immediately.
- **“AOF means zero loss”:** Fsync policy, kernel, disk, controller, replication, and failover still matter.
- **“RDB every X minutes means an exact X-minute RPO”:** A snapshot can fail or fall behind.
- **“A backup exists because the setting is enabled”:** The job may fail, the file may not be transferred, or restore may be incompatible.
- **“Everything can be rebuilt from a log”:** A reliable source event stream or sequence may not exist.
- **“RTO is just the time to PING”:** Include application reconnect, validation, repopulation, and cutover.

## Exercises with answer guide

1. Write separate persistence plans for a SQL-rebuildable cache, a session store, and a ledger.
2. Describe a case where replication is enabled but `FLUSHALL` deletes the data. Why is an independent backup still needed?
3. Break RTO down from the alert to confirmed usable data.
4. If AOF/RDB slows the service, which measurements should inform the decision?

**Answer criteria:** Identify the source of truth and business loss, state measurable RPO/RTO, separate failure domains, test recovery periodically, and monitor persistence status.

## Quiz with answers

### 1. How do persistence and replication differ?

<details><summary>Answer</summary>

Persistence records state in storage; replication sends it to another node.

</details>

### 2. Does a replica protect against a logical deletion?

<details><summary>Answer</summary>

No. The deletion may be replicated too.

</details>

### 3. What are RPO and RTO?

<details><summary>Answer</summary>

RPO is the data loss or time window the business can accept. RTO is the permitted time to restore service.

</details>

### 4. What might be sufficient for a cache?

<details><summary>Answer</summary>

No persistence may be sufficient if the data can truly be rebuilt and cold-start load is managed.

</details>

### 5. When should you evaluate AOF?

<details><summary>Answer</summary>

When fresher write replay and a smaller loss window are worth their I/O and disk costs compared with snapshot-only recovery.

</details>

### 6. Is a restore copy on the same backup volume enough?

<details><summary>Answer</summary>

No. The backup should be independent of that volume/host failure domain, and restore should be practiced.

</details>

## References and further reading

### English: official documentation and engineering case study

- [Redis persistence documentation](https://redis.io/docs/latest/management/persistence/) — RDB and AOF choices and behavior.
- [Redis replication documentation](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/) — asynchronous replication and failover context.
- [Redis at Scale: persistence and durability](https://redis.io/tutorials/operate/redis-at-scale/persistence-and-durability/) — RDB/AOF configuration and recovery lab.
- [Redis backup and restore documentation](https://redis.io/docs/latest/operate/oss_and_stack/management/backup/) — backup practices for self-managed deployments.
- [GitLab case study: storing and updating namespace statistics](https://about.gitlab.com/blog/database-case-study-store-and-update-namespace-statistics/) — an actual datastore design decision.
- [GitLab Geo architecture article](https://about.gitlab.com/blog/how-we-built-gitlab-geo/) — durable event and cursor design considerations.
- [Redis latency troubleshooting guide](https://redis.io/docs/latest/management/optimization/latency/) — persistence and I/O can be part of a latency investigation.

### فارسی

- [مرور فارسی persistence و ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [مقالهٔ فارسی دربارهٔ Redis و کاربردهای آن](https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)

Persian articles comparing RPO and durability in depth are limited. This file explains the decision model directly. Use the official Redis and managed-provider documentation for your version and service.

</div>

