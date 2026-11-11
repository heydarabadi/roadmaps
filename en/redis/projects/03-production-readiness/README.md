<div dir="ltr" align="left">

# Project 3 — Redis Production Readiness Design

> Level: intermediate to advanced · Time: 3–5 hours · This is a design and tabletop project; do not run it against production or a real cloud service.

> Persian edition: [پروژهٔ ۳ — طرح آمادگی Redis برای Production](../../../../fa/redis/projects/03-production-readiness/README.md)

## Scenario

A product/order API uses Redis for a hot cache and sessions. Traffic grows eightfold during a promotion. Redis must be private and use TLS/ACLs. A node may fail. The cache can be rebuilt, but session downtime affects users. The team must rehearse upgrades and recovery.

Create a design pack that decides whether Redis Open Source single-primary, Sentinel, Cluster, or a managed/Enterprise service fits the stated workload. Do not invent throughput numbers; list assumptions and the inputs required for a benchmark.

## Step 1 — Workload and data classification

| Data | Criticality | Source of truth | What happens if Redis is lost? |
| --- | --- | --- | --- |
| Product-page cache | Low; rebuildable | Catalog database | Database fallback and higher load |
| Session/login state | Medium/high, policy-dependent | Auth service or Redis by design | Logout, fail-closed, or session recovery |
| Rate-limit counter | Workload-dependent | Application event/database? | Limit may be exceeded or users may be blocked |
| Order event | High | Database outbox/broker | Loss or duplicates; assess whether Redis alone is enough |

For each dataset, define retention, PII, TTL, eviction eligibility, persistence, replication, backup, ACL, and privacy deletion. Treating everything as “just cache” creates operational mistakes.

## Step 2 — Capacity planning instead of guessing

Collect:

- Number of keys and payload-size distribution, type, TTL, and field/member counts.
- Baseline and peak operations per second, command mix, pipeline/batch size, and concurrency.
- Dataset growth and retention, cache hit/miss ratio, and stampede behavior.
- Memory overhead, allocator fragmentation, copy-on-write during RDB/AOF rewrite, replica memory, and host headroom.
- Client connection pools, network RTT, TLS cost, and node/region placement.
- Replication lag, failover duration, snapshot and restore time, and backup bandwidth.

Build a representative benchmark dataset without personal data. Measure end-to-end p50/p95/p99, throughput, hit ratio, evictions, CPU, RSS, replication lag, load duration, and restore duration. Record a baseline before scaling.

## Step 3 — Choose a topology to evaluate

| Need | Architecture to evaluate |
| --- | --- |
| Small cache, tolerable failure window, simple operations | Primary with backups; possibly a replica for reads/recovery |
| Automated failover for one primary | Sentinel with monitors in separate failure domains and compatible clients |
| Dataset or throughput must be sharded | Redis Cluster or a service with sharding; account for key and multi-key constraints |
| Contracted support, service-level target, DR, or less infrastructure ownership | Compare managed/Enterprise options, costs, and feature matrix |
| Writes in multiple regions | Active-Active only after consistency, conflict, and command compatibility review |

HA, replication, and Cluster are not backups. A bad delete or corruption can be copied to every replica. DR still needs an independent backup and restore exercise.

## Step 4 — Security that can be reviewed

Create a dedicated application user, for example catalog-api, with only the needed commands and key prefixes. Keep passwords out of configuration files and command history. Define secret-manager storage, rotation, and emergency revocation.

Use a private network; do not expose Redis publicly. Enable TLS between clients and service and, where required, between nodes. Test ACL rules for cache and order key patterns with ACL DRYRUN or a staging integration test.

Checklist:

- [ ] Public inbound access is blocked; allowed source networks are explicit.
- [ ] Each service has a least-privilege ACL for commands and key patterns.
- [ ] Certificate expiry and renewal are monitored.
- [ ] Secret rotation and revocation have been rehearsed.
- [ ] Backups are encrypted, access-logged, and retained only as long as required.
- [ ] Logs and metrics do not expose credentials or sensitive payloads.
- [ ] A named owner tracks patches, advisories, and rollout policy.

## Step 5 — Durability and recovery design

Set an RPO and RTO for each dataset and explain the reason. A rebuildable cache might not need persistence. Sessions or order state may need RDB/AOF, managed durability, and separate backup. Decide from durability needs, latency, restore duration, data volume, and cost.

A restore runbook should include:

1. Incident commander confirms scope and the last trusted recovery point.
2. Restore Redis in an isolated network; do not connect application traffic immediately.
3. Check checksum, format/version, ACLs, and configuration.
4. Sample key counts/types, known records, TTLs, Stream groups/pending entries, and data consistency.
5. Check personal-data policy and schema compatibility.
6. Run application smoke checks and control load.
7. Ramp traffic gradually and record stop/rollback conditions.
8. Record actual RTO and estimated data loss/RPO.

## Step 6 — Observability and alerts

Organize dashboards around health (availability/connections), performance (latency/operations), capacity (memory/eviction/CPU/disk), and correctness/recovery (replication lag, pending entries, backup age, restore drill).

For each alert, specify its condition, duration, severity, first action, owner, and runbook:

| Alert | Operator’s first question |
| --- | --- |
| Memory headroom below limit | More data, fragmentation, replicas, or wrong eviction policy? |
| Evicted key count rises quickly | Did hit/miss, key churn, or working set change? |
| Redis/client p99 rises | Server command, network RTT, or client pool bottleneck? |
| Replica lag rises | Replication buffer, network, or heavy command? |
| Backup age exceeds RPO | Job, off-site copy, or permission failure? |
| Oldest Stream pending grows | Worker failure, poison event, or slow dependency? |

Do not use MONITOR as continuous production monitoring; it can add substantial overhead.

## Step 7 — Rollout and upgrade

Before upgrading, review release notes and command/encoding compatibility. Verify a backup and rollback or forward-recovery plan. Load-test, canary, check client compatibility and persistence formats, and plan module and replica sequencing.

Define stop conditions such as rising error rate, latency, or replica lag. Name the decision-maker. A binary rollback may not reverse a changed data format; verify file and restore compatibility first.

## Step 8 — Failure tabletop

Assign an incident commander, database owner, Redis operator, and application owner. Record actions and elapsed time:

1. Primary node stops while a replica is several seconds behind.
2. Redis is available, but memory reaches its limit and cache keys are evicted.
3. Last night’s backup is incomplete or corrupt.
4. A new ACL blocks a worker with NOPERM.
5. A TLS certificate expires.
6. Someone accidentally runs FLUSHDB in production.
7. A new deployment doubles average key size and makes restore slower.

For each, write impact, detection, containment, recovery source, data-loss estimate, communication, and follow-up. Do not create these failures on a real service for practice.

## Final deliverable: design pack

1. Component diagram and data flow.
2. Key/type/TTL schema and ownership.
3. Topology decision and rejected alternatives with trade-offs.
4. RPO/RTO, persistence, backup, and restore plan.
5. Network, ACL, TLS, and secret model.
6. Capacity assumptions and benchmark plan.
7. Metrics, alerts, and actionable runbooks.
8. Upgrade/failback plan and tabletop results.
9. Open questions with an owner and target date.

### Rubric (20 points)

- Workload and source of truth for each dataset: 3
- Topology and failure trade-offs: 3
- RPO/RTO, backup, and restore: 3
- ACL/TLS/network/secrets: 3
- Capacity, latency, and eviction: 3
- Monitoring and actionable runbook: 3
- Rollout, upgrade, DR, and open-question register: 2

A design justified only with “Redis is fast” or “we have a replica” does not earn full credit.

## References and further reading

- [Redis security](https://redis.io/docs/latest/operate/oss_and_stack/management/security/)
- [Redis persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/)
- [Replication](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/), [Sentinel](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/), and [Cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/)
- [Redis optimization, latency, and memory](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/)
- [GitLab Redis latency investigation](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/) — published engineering investigation.
- [GitLab’s namespace-statistics database case study](https://about.gitlab.com/blog/database-case-study-store-and-update-namespace-statistics/) — architecture decision example, not a Redis outage.
- [Redis replication and Cluster guide in Persian](https://azarsys.com/blog/setup-redis-replication-cluster/)
- [Redis guide in Persian — SalamLang](https://www.salamlang.ir/std/db/redis/)

</div>

