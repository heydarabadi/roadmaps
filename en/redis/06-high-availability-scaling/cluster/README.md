<div dir="ltr" align="left">

# Redis Cluster: Keyspace Sharding and Availability

> Persian edition: [Read this lesson in Persian](../../../../fa/redis/06-high-availability-scaling/cluster/README.md)

> Path: Chapter 6 · Level: intermediate to advanced · Time: 90–140 minutes
>
> Cluster is a distributed database deployment. Do not change a production topology without a compatible client, a topology plan, and a rehearsed migration.

## Learning objectives

- Distinguish why Cluster is used from Sentinel and a single replica group.
- Explain the 16,384 hash slots, key distribution, `MOVED`, and `ASK`.
- Design key names and hash tags for multi-key commands.
- Understand availability limits, asynchronous replication, hot keys, and client routing.
- Decide when vertical scaling or managed Redis is simpler than Cluster.

## Mental model

Redis Cluster divides the keyspace across multiple primaries. Every key belongs to one of 16,384 hash slots. Each primary owns a subset of slots, and replicas back up each primary's shard for failover. A cluster-aware client maps a key to its slot and sends the request to the owning node. Nodes generally redirect clients instead of proxying requests.

```text
key -> CRC16(key) % 16384 -> hash slot -> primary for that slot
                                               |
                                          replica(s)
```

Cluster provides three main capabilities: distributing memory/write load across multiple primaries, moving slots through resharding, and replica failover. It also increases client, network, multi-key, capacity-balancing, and operational complexity.

## 1. Hash slots and redirects

Inspect a slot in a lab:

```text
CLUSTER KEYSLOT customer:42
CLUSTER KEYSLOT cart:{customer-42}
```

The slot is calculated with CRC16 modulo 16,384. If a client sends a key to the wrong node, Redis returns `MOVED <slot> <host:port>`. The client updates its slot map and sends the request to the current owner. `ASK` is generally used temporarily while a slot is migrating: the client sends the request to the destination and must send `ASKING` before the command. A Cluster-aware library handles these redirects and slot-map refresh.

## 2. Hash tags and multi-key commands

If a key contains a valid `{...}` hash tag, only the substring inside the first valid braces is used to calculate the slot. Thus:

```text
cart:{customer-42}
cart-items:{customer-42}
cart-lock:{customer-42}
```

These keys share a slot and can be used together by supported multi-key operations, transactions, or scripts. Without hash tags, `MGET key1 key2` or a multi-key transaction may fail with `CROSSSLOT`.

Choose tags from the invariant's scope: keys that need to participate together must share a slot. But a universal tag such as `{all-users}` puts every key on one slot and creates a primary hotspot, defeating horizontal distribution.

Cluster supports only database 0. Do not treat numbered standalone databases as a namespace or Cluster routing mechanism. Design key prefixes for environment, tenant, and domain explicitly.

## 3. Resharding and failover

Moving slots lets you balance the keyspace across primaries. During migration, some keys may be in transit, and clients must handle `MOVED` and `ASK` correctly. Before changing node capacity, calculate free disk/RAM, replica capacity, network, and migration throughput.

Replica failover improves availability, but replication is asynchronous by default. If a primary fails before sending a write to its replica, the latest acknowledged write may not be on the replica. Cluster is not strongly consistent: the most recent failover wins, and divergent state may need application-level reconciliation.

If a required node or slot is unavailable, Cluster can reject some or all requests depending on slot coverage and configuration. Include `CLUSTER INFO`, `CLUSTER NODES`, and cluster-bus logs in the runbook. Each primary serving slots is a failure domain; place primaries and replicas appropriately across zones.

## 4. Client routing and latency

The client must support Cluster mode, cache/refresh a topology map, connect to multiple nodes, and parse redirects. One fixed connection to the first node is not enough. The client must handle reconnect/backoff, timeout, command retry semantics, TLS/authentication, and per-node metrics.

In Cluster, pipelining commands whose keys live on different nodes may cause the library to fan requests out. Latency and partial-failure behavior differ from standalone. A hot key still belongs to one slot/node; Cluster does not split that key automatically.

## 5. Cluster, Sentinel, or scale up?

| Option | Good fit | Trade-off |
| --- | --- | --- |
| A larger single node | Current capacity is small enough and the scale/downtime plan is acceptable | Node size and vertical cost ceiling |
| Primary + replica + Sentinel | One shard/keyspace with automatic failover | Data stays on one primary; no sharding |
| Redis Cluster | RAM/throughput for one keyspace must be divided across multiple primaries | Client routing, multi-key constraints, resharding, and more complex operations |
| Managed Redis | The team does not want to operate the base topology | Verify provider features, price, and limits against the contract |

## Published experience: cross-region sessions and latency

In the initial GitLab Geo design, the team found that cross-region Redis replication could leave a session unavailable immediately at the secondary site and affect redirect/login latency; dependency on the primary also remained. This is not a Cluster case study. It illustrates that Cluster shards and replicas do not automatically solve geographic latency or application consistency. [GitLab Geo architecture](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

## Design and troubleshooting lab

Choose keys and inspect their slots on a test Cluster:

```text
CLUSTER KEYSLOT inventory:{sku-7}
CLUSTER KEYSLOT reservation:{sku-7}:order-501
CLUSTER KEYSLOT customer:42
```

The first two should be in one slot; the third need not be. Decide whether placing inventory and reservation for one SKU together could itself create a hotspot.

Troubleshooting:

- `MOVED`: The slot map is stale; the client refreshes its topology.
- `ASK`: A slot is migrating; expect a temporary redirect and `ASKING` from a Cluster-aware client.
- `CROSSSLOT`: Command/transaction keys do not share a slot; revisit hash tags and invariants.
- `CLUSTERDOWN`: Slot coverage, primary/majority availability, or topology health may be broken; inspect `CLUSTER INFO`.
- Keys cluster on one primary: Check hash distribution, overly broad tags, hot keys, real workload, and slot allocation.
- Failover causes a data discrepancy: Analyze async replication, acknowledged-write timing, and the recovery/source-of-truth plan.

## Exercises with answer guide

1. How does Cluster differ from Sentinel for memory scaling?
2. Name cart, items, and lock keys so a multi-key transaction can work.
3. Distinguish `MOVED` from `ASK`.
4. A hot `user_id` drives a quarter of traffic. Does Cluster solve it alone?
5. What does Cluster failover cover, and what does backup cover?

<details><summary>Answer guide</summary>

1. Sentinel monitors/fails over one primary shard. Cluster divides the keyspace across multiple primary shards.
2. For example, `cart:{u-42}`, `items:{u-42}`, and `lock:{u-42}`.
3. `MOVED` identifies the current owner and prompts a topology update; `ASK` is a temporary redirect during migration.
4. No. One hot key maps to one slot. Split the application-level model, shard the workload deliberately, or redesign caching/aggregation.
5. Cluster failover helps with node failure. Independent point-in-time backup helps recover from deletion or logical corruption.

</details>

## Quiz with answers

### 1. How many hash slots does Redis Cluster use?

<details><summary>Answer</summary>

16,384.

</details>

### 2. What does `MOVED` mean?

<details><summary>Answer</summary>

The key belongs to another node; the client should update its slot map and follow the current redirect.

</details>

### 3. What does a hash tag do?

<details><summary>Answer</summary>

It maps keys with the same tag to one slot so compatible multi-key operations can work.

</details>

### 4. Why is `{all}` dangerous for every key?

<details><summary>Answer</summary>

It concentrates every key on one slot/node and creates a hotspot.

</details>

### 5. Does Cluster guarantee acknowledged writes survive without loss?

<details><summary>Answer</summary>

No. Asynchronous replication can still lose a recent write during failover.

</details>

### 6. Does Cluster replace backup?

<details><summary>Answer</summary>

No. Independent backup and recovery are still required.

</details>

## References and further reading

### English: official documentation and architecture article

- [Redis Cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/) — slots, hash tags, redirects, and failure behavior.
- [Scale with Redis Cluster](https://redis.io/docs/latest/management/scaling/) — create and reshard a cluster.
- [Redis multi-key operation guide](https://redis.io/docs/latest/develop/using-commands/multi-key-operations/) — same-slot requirements and routing.
- [CLUSTER KEYSLOT command reference](https://redis.io/docs/latest/commands/cluster-keyslot/) — inspect slot calculations.
- [MOVED error reference](https://redis.io/docs/latest/develop/reference/errors/common/moved/) and [ASK handling in the Cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/) — redirects.
- [Redis scalability guide](https://redis.io/tutorials/operate/redis-at-scale/scalability/) — sharding, resharding, and read replicas.
- [Sentinel guide](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/) — high availability without sharding.
- [GitLab Geo architecture](https://about.gitlab.com/blog/how-we-built-gitlab-geo/) — cross-region latency and session trade-offs; not a Cluster incident.

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی فارسی Redis Cluster و hash slot](https://www.google.com/search?q=آموزش+فارسی+Redis+Cluster+hash+slot)
- [مرور فارسی ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

Detailed Persian Cluster references are fewer than the official English documentation. This lesson teaches key design and constraints directly. Check client/version behavior, redirects, and upgrade plans against the target version.

</div>

