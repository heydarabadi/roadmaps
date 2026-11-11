<div dir="ltr" align="left">

# Redis Sentinel: Monitoring and Failover for One Shard

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 6 · Level: intermediate · Time: 75–110 minutes
>
> Sentinel enables failover, but does not guarantee durability or zero data loss. Verify settings against your version and managed service.

## Learning objectives

- Distinguish the roles of three Redis nodes and multiple Sentinel processes.
- Explain the difference between quorum, majority, and authorization to fail over.
- Configure a client to discover a new primary.
- Understand `down-after-milliseconds`, `failover-timeout`, `parallel-syncs`, and `CKQUORUM`.
- Account for asynchronous replication, network partitions, and failure tests in production planning.

## What problem does Sentinel solve?

Replication sends data from a primary to replicas. Sentinel is a separate service that monitors instances, sends events/notifications, promotes a replica if the primary is down, and tells clients about the new primary. Sentinel does not partition or shard data; it manages one logical Redis primary/replica group.

```text
Sentinel S1 --\          /--> Redis primary
Sentinel S2 ---- quorum -+----> replica A
Sentinel S3 --/          \--> replica B
                  |
            client asks: current primary address?
```

For a resilient topology, run at least three Sentinels in independent failure domains. Three processes on one VM or in one zone can fail together and do not provide independence.

## 1. Detecting failure and starting failover

Each Sentinel first marks an instance as subjectively down (**SDOWN**) when it cannot reach it. If enough Sentinels agree according to quorum, the primary becomes objectively down (**ODOWN**). Then one Sentinel must be elected/authorized by a majority of known Sentinels to carry out failover. Quorum is for agreeing on the down state; majority authorization is a separate step.

Suppose there are five Sentinels and quorum is `2`. Two Sentinels can declare the primary down, but the failover leader still needs a majority—at least three of five—to proceed. A minority network partition should not perform failover on its own. This limits availability in some asymmetric partitions.

### Educational configuration example

```text
port 26379
sentinel monitor mymaster 10.0.0.10 6379 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 60000
sentinel parallel-syncs mymaster 1
```

These values are examples only. The Sentinel configuration file must be writable because Sentinel stores changed state/configuration. Network settings, ACL/TLS, and address announcement under containers/NAT must match the real topology.

## 2. Important parameters

- **quorum:** How many Sentinels must detect that the primary is unreachable.
- **majority:** A majority of Sentinels must be available to authorize failover.
- **`down-after-milliseconds`:** How long an instance must fail to respond before a Sentinel declares it down. Too short can cause false failovers during GC/network delays; too long extends outages.
- **`failover-timeout`:** A coordination/retry/failover-state parameter; it is not the exact end-to-end outage duration.
- **`parallel-syncs`:** Number of replicas that synchronize to the new primary simultaneously. More can speed recovery while consuming more sync resources.

## 3. Client discovery

A client should not keep a static primary IP forever. A Sentinel-aware client contacts one or more Sentinels, asks for a logical primary name such as `mymaster`, and reconnects to the new address after failover. The client needs retry/backoff, timeouts, command idempotency, and connection-pool refresh.

Use `redis-cli` to query an address and status:

```text
SENTINEL get-master-addr-by-name mymaster
SENTINEL CKQUORUM mymaster
SENTINEL replicas mymaster
SENTINEL sentinels mymaster
```

`CKQUORUM` reports whether the current Sentinel state is sufficient for the required quorum and majority; it can inform a health signal. A local `redis-cli -p 26379` example is not enough for production: addresses, auth/TLS, and client-library support must be correct.

## 4. What Sentinel does not guarantee

Sentinel is an eventually consistent distributed system. Because replication is asynchronous and failover may select a lagging replica, an acknowledged write can be lost. Sentinel does not create a separate cross-region disaster-recovery replica, a point-in-time backup, or a logical rollback.

For important writes:

1. Monitor replication lag.
2. Set persistence and backups for the required RPO.
3. Treat `WAIT` only as a way to reduce loss probability, and use it for the write on the same connection.
4. Run failure tests and measure lost/duplicated behavior in the application.
5. Make operations repeatable/idempotent and handle conflicts.

## 5. Published experience: Sentinel and the data path are not the product

The GitLab Geo article explains that cross-region replication of session/cache data in an early design created latency and primary dependencies; the team chose not to replicate Redis cross-site for that path. This is not a report of a Sentinel defect. The point is that Sentinel for one deployment and cross-region replication do not automatically solve geographic disaster recovery or application consistency. [GitLab Geo architecture](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

## Failure-test plan

Build a disposable environment with a primary, a replica, and three Sentinels. Run these scenarios one at a time:

1. Stop the primary. Record time to `ODOWN`, promotion, client reconnect, and error recovery.
2. Create a network partition. Confirm that the minority Sentinel side does not perform failover.
3. Isolate a lagging replica. Record promotion choice and possible data loss.
4. Bring back the old primary. Check that it becomes a replica of the new primary and that divergent data does not remain.
5. Issue a write at the failover boundary. Repeat and inspect duplicate/lost behavior from the client's perspective.

Do not run a manual chaos test in production. Establish ownership and rollback in a test environment first.

## Troubleshooting and common pitfalls

- **Only two Sentinels:** Majority/partition behavior is fragile; three independent failure domains are a common minimum.
- **Quorum and majority are treated as the same:** Down detection and failover authorization are separate conditions.
- **Client keeps using the old primary:** Sentinel-aware discovery or connection-pool refresh is missing.
- **False failover:** Check timeout settings, scheduling pauses, and network jitter.
- **A write is missing after failover:** Analyze asynchronous replication and replica selection; Sentinel is not lossless.
- **Sentinel config is not writable:** Sentinel may not persist state or start; inspect path and permissions.
- **All Sentinels share one zone:** A zone failure removes all voters.
- **A Sentinel notification is treated as application recovery:** Measure client reconnect, retries, and end-to-end health separately.

## Exercises with answer guide

1. There are three Sentinels, quorum `2`. What if only two see the primary down, but one cannot reach the other Sentinels?
2. Why are replicas commonly read-only, and when can a replica read be stale?
3. What must a client do after failover?
4. Does Sentinel replace Cluster when one primary lacks enough RAM?

<details><summary>Answer guide</summary>

1. Quorum may allow an ODOWN decision, but failover authorization requires majority and an election; a partition may prevent it.
2. Writes normally go to the primary; replication lag can make a replica read stale.
3. Rediscover the primary through Sentinel, refresh the connection pool, and retry only safe/idempotent commands.
4. No. Sentinel provides HA for one primary/replica group and does not shard; horizontal capacity needs Cluster or another design.

</details>

## Quiz with answers

### 1. Does Sentinel shard data?

<details><summary>Answer</summary>

No. It monitors and fails over a non-Cluster Redis deployment.

</details>

### 2. How do quorum and majority differ?

<details><summary>Answer</summary>

Quorum is for reaching agreement that the primary is down; majority authorizes a leader to execute failover.

</details>

### 3. What is a common minimum number of independent Sentinels for a resilient deployment?

<details><summary>Answer</summary>

Three or more, on independent failure domains.

</details>

### 4. Does failover preserve every write?

<details><summary>Answer</summary>

No. Asynchronous replication creates a possible loss window.

</details>

### 5. Where does a client discover the primary address?

<details><summary>Answer</summary>

From Sentinel-aware discovery using the logical primary name.

</details>

### 6. What does `CKQUORUM` check?

<details><summary>Answer</summary>

Whether reachable Sentinels can satisfy quorum and the majority needed for failover.

</details>

## References and further reading

### English: official documentation and engineering article

- [Redis Sentinel documentation](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/) — monitoring, quorum, and failover.
- [Sentinel client specification](https://redis.io/docs/latest/develop/reference/sentinel-clients/) — primary discovery and client behavior.
- [SENTINEL CKQUORUM reference](https://redis.io/docs/latest/commands/sentinel-ckquorum/) — check quorum/majority availability.
- [Redis replication guide](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/) — asynchronous replication safety.
- [Redis high-availability guide](https://redis.io/tutorials/operate/redis-at-scale/high-availability/) — practical replication and failover setup.
- [GitLab Geo architecture](https://about.gitlab.com/blog/how-we-built-gitlab-geo/) — cross-region latency and session/cache decisions.

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی تکمیلی Sentinel به فارسی](https://www.google.com/search?q=آموزش+فارسی+Redis+Sentinel+quorum)

Detailed Persian Sentinel material is limited. The core concepts and failure-test plan are included here. Verify syntax and client discovery against the Redis version and service you use.

</div>

