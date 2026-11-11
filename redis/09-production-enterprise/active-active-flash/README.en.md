<div dir="ltr" align="left">

# Active-Active, Geo-Replication, and Flash Tiering

> Path: Chapter 9 · Product/Enterprise features · Level: advanced · Time: 80–120 minutes
>
> These capabilities are not available in every Redis Open Source build or hosted service. Confirm edition, version, service plan, compatibility, and contract before designing around them.

> Persian edition: [Active-Active، geo-replication و Flash tiering](README.md)

## Learning objectives

- Distinguish Active-Active from Redis Cluster and primary/replica/Sentinel.
- Explain strong eventual consistency and CRDT conflict resolution in practical terms.
- Identify business invariants that concurrent writes cannot safely preserve by simple merging.
- Compare all-RAM Redis with Redis Flex and Auto Tiering.
- Evaluate multi-region and hot/warm storage against latency, cost, and recovery needs.

## 1. What Active-Active means

An Active-Active deployment keeps copies of a logical dataset in multiple regions, where each region can accept reads and writes. Users can be routed to a nearby copy, and changes are replicated across regions. Redis Enterprise and Redis Cloud offer product-specific Active-Active capabilities using multi-primary replication and conflict-free replicated data types (CRDTs).

This is not the same as Redis Cluster. Cluster distributes hash slots among primaries and replicas to shard one deployment. Active-Active is a geo-distributed, multi-primary design with conflict-resolution rules. Sentinel provides monitoring and failover for a primary/replica deployment; it does not create a global multi-writer dataset.

~~~text
Region A application <-> local copy A <---- replication ----> local copy B <-> Region B application
                              writes                         writes
~~~

### Strong eventual consistency in plain language

If updates eventually stop and replicas can exchange their changes, the replicas converge according to the merge rules of the supported data types and operations. This does **not** mean every region sees one globally ordered, linearizable sequence at every instant. During network delay or partition, a region can serve a view that has not received another region’s latest update.

CRDTs give supported operations deterministic merge behavior. They do not automatically encode every business rule. The exact commands, data types, expiration behavior, scripting, and transaction support are product/version specific; check the compatibility matrix.

## 2. Conflicts and invariants

Imagine the available stock is 1. Region A and Region B each read 1 while disconnected. Each accepts a sale and writes a decrement. A mergeable counter can converge to -1, even though the business rule says inventory must not go below zero. The replicas can converge correctly while the business result is unacceptable.

Active-Active is a better fit for merge-friendly state such as some user preferences, presence information, shopping-cart additions, and counters where approximate/convergent semantics are acceptable. It is not automatically appropriate for payment ledgers, limited inventory reservation, unique constraints, or globally ordered workflows.

For each field and operation, ask:

1. Can two regions update the same element concurrently?
2. Is the operation commutative and idempotent?
3. What should happen if an add and delete race?
4. Does the CRDT’s merge rule preserve the actual business invariant?
5. Which system is authoritative if the regions remain partitioned?
6. How are clients rerouted after a cluster-level failure?
7. Do residency or privacy rules allow the data to replicate across these regions?

Test representative operations, including SADD/SREM, counters, hash fields, expiration, JSON paths, scripts, and multi-key commands. Do not assume that two commands on different data types have identical conflict semantics.

## 3. Customer examples: context, not guarantee

Redis’s published Flowdesk story describes a trading-services workload using Redis Enterprise on Google Cloud to maintain trading sessions and cache order, price, and market data across geographies. Redis says Active-Active is used to share data between locations. This is a vendor-published customer story, not an independently reproduced benchmark; do not infer that every trading ledger is safe for multi-writer merging. [Flowdesk customer story](https://redis.io/customers/flowdesk/)

Redis’s Mutualink story describes a CRDT-based Active-Active design for emergency communications. Again, it documents one customer’s context and design, not proof that the same consistency model fits every workflow. [Mutualink customer story](https://redis.io/customers/mutualink/)

When reading any case study, separate its stated workload, product configuration, measured outcome, and marketing language. Ask what the source of truth is and how conflicting writes are handled.

## 4. Redis Flex and Auto Tiering

An all-RAM dataset can become expensive. Redis Software’s flash-tiered products combine RAM and SSD/flash so that frequently accessed (“hot”) data stays in memory while less frequently accessed (“warm”) data can use lower-cost storage. This does not make flash equivalent to RAM. A warm read can have different latency and throughput, and storage media, value size, key shape, and workload locality matter.

Redis documentation describes Flex as the enhanced successor to Auto Tiering, generally available beginning with Redis Software 8.0.2. The documented database-version matrix currently distinguishes:

| Redis database version | Flex | Auto Tiering |
| --- | --- | --- |
| 8.0 and later | Supported | Not supported |
| 7.4 | Supported | Supported |
| 7.2 and earlier | Not supported | Supported |

The official compatibility page also lists data-type and topology constraints. At the time of this course review, it shows Active-Active unsupported with Flex and supported with Auto Tiering under stated conditions, and Time Series unsupported with Flex but supported with Auto Tiering. The product matrix may change; recheck it before an upgrade or purchase.

Flex is most promising when the working set is much smaller than the full dataset, average keys are smaller than values, and recent data is accessed more often. It may disappoint when most values are continuously hot. Benchmark with realistic key/value sizes, hot-set ratio, p95/p99 latency, throughput, IOPS, memory, and tier hit metrics. Also account for flash capacity and supported storage hardware; the current documentation excludes some network-attached and HDD configurations.

Do not confuse tiering with persistence, backup, or long-term archival. Tiering is an access/cost design within a running database; a backup is an independent recovery artifact.

## 5. Architecture comparison

| Pattern | Main purpose | Main cost or limitation |
| --- | --- | --- |
| Primary + replica + Sentinel | Failover for one primary/replica group | Replica lag and possible loss; not horizontal sharding |
| Redis Cluster | Sharding and failover across multiple primaries | Slot/client/multi-key complexity; not global multi-primary consistency |
| Active-Active Enterprise/Cloud | Local reads and writes across regions with merge rules | Eventual consistency, command limits, network replication, and product cost |
| Flex / Auto Tiering | Extend a dataset beyond DRAM using hot/warm tiers | Higher warm-read latency and edition/version constraints |

## Design lab

Model two regions on paper:

- Both regions update a user cart with item additions. Specify duplicate handling and acceptable staleness.
- Both regions attempt to decrement the last unit of an item. Explain why a merge alone may violate inventory rules.
- Define the authoritative system, client routing, partition response, reconciliation path, and monitoring.

No live deployment is required. The goal is to demonstrate whether the merge rule matches the business rule.

## Common traps

- Calling eventual convergence strong consistency: replicas can temporarily show different values.
- Calling Cluster Active-Active: sharding is not geo-distributed multi-primary writing.
- Assuming a CRDT counter protects a purchase invariant: convergence does not equal business validity.
- Treating flash as RAM or as a backup: warm data has different access behavior and tiering is not recovery.
- Using an old “Redis on Flash” name without checking the current Flex/Auto Tiering matrix.
- Treating customer stories as independent benchmarks or universal guarantees.

## Quiz

### 1. How does Active-Active differ from Redis Cluster?

<details><summary>Answer</summary>

Cluster shards key slots within a deployment. Active-Active is a product-specific geo-distributed multi-primary design with conflict-resolution semantics.

</details>

### 2. What does a CRDT provide?

<details><summary>Answer</summary>

For supported operations, it provides merge rules that let replicas converge after exchanging concurrent updates.

</details>

### 3. Does Active-Active guarantee every business invariant?

<details><summary>Answer</summary>

No. A merge can be deterministic and still violate rules such as “inventory never goes below zero.”

</details>

### 4. When is flash tiering a stronger candidate?

<details><summary>Answer</summary>

When the total dataset is much larger than the hot working set and warm-access latency remains acceptable.

</details>

### 5. Is Flex available in every Redis Open Source deployment?

<details><summary>Answer</summary>

No. Flex and Auto Tiering are product and version features with explicit compatibility requirements.

</details>

### 6. What does the Flowdesk story prove?

<details><summary>Answer</summary>

It documents a Redis-published customer use case. It is not an independent benchmark or guarantee for another application.

</details>

## References and further reading

### English: official and research sources

- [Active-Active in Redis Software](https://redis.io/docs/latest/operate/rs/databases/active-active/) — architecture and conflict-resolution overview.
- [Active-Active in Redis Cloud](https://redis.io/docs/latest/operate/rc/databases/active-active/) — service-specific regions, consistency, and failover responsibilities.
- [Plan an Active-Active database](https://redis.io/docs/latest/operate/rs/databases/active-active/planning/) — design considerations.
- [Active-Active command and data-type compatibility](https://redis.io/docs/latest/operate/rs/references/compatibility/commands/data-types/) — validate support by command and type.
- [Flex and Auto Tiering](https://redis.io/docs/latest/operate/rs/databases/flash/) — current version and feature matrix.
- [Flowdesk customer story](https://redis.io/customers/flowdesk/) — vendor-published customer example.
- [Mutualink customer story](https://redis.io/customers/mutualink/) — vendor-published customer example.
- [Conflict-free replicated data types: a comprehensive study](https://pages.lip6.fr/Marc.Shapiro/papers/Comprehensive-CRDTs-RR7506-2011-01.pdf) — foundational CRDT research by Shapiro et al.

### فارسی

- [آموزش فارسی Redis در SalamLang](https://www.salamlang.ir/std/db/redis/) — مبانی عمومی Redis.
- [مرور ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf) — ساختارها و کاربردها.
- [جست‌وجوی فارسی Redis Enterprise Active-Active](https://www.google.com/search?q=آموزش+فارسی+Redis+Enterprise+Active-Active)
- [جست‌وجوی فارسی CRDT و سازگاری نهایی](https://www.google.com/search?q=CRDT+سازگاری+نهایی+توضیح+فارسی)
- [جست‌وجوی فارسی Redis Flash و Auto Tiering](https://www.google.com/search?q=Redis+Flash+Auto+Tiering+آموزش+فارسی)

منابع عمیق فارسی دربارهٔ Active-Active، CRDTهای Redis و Flex کمیاب‌اند؛ این درس مفاهیم و trade-offها را توضیح می‌دهد و منابع رسمی بالا مرجع رفتار نسخه/محصول‌اند.

</div>

