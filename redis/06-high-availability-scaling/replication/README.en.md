<div dir="ltr" align="left">

# Replication: Primary and Replica

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 6, availability and scaling · Level: intermediate · Time: 70–100 minutes
>
> Change roles or replication only in a lab. Misidentifying the primary can send writes to an unintended destination.

## Learning objectives

- Explain the roles of primary and replica and the data-copy path.
- Distinguish full synchronization from partial resynchronization.
- Analyze lag, stale reads, asynchronous write loss, and initial-sync cost.
- Keep replication separate from backup and automatic failover.
- Read `INFO replication`, `ROLE`, `WAIT`, and connection status.

## Mental model

In ordinary Redis replication, one primary performs dataset writes and replicas receive the change stream. The default is asynchronous to favor write latency and throughput: the primary does not need to wait for disk fsync or acknowledgment from every replica before replying to a client.

```text
client write -> primary -> replication stream -> replica(s)
                         (may lag / disconnect)
```

A replica can serve some reads, but its answer may be stale. Primary failover does not guarantee that the newest copy is always selected; the best available replica is chosen.

## 1. Full and partial synchronization

When a replica connects for the first time, or when the change gap is larger than the replication backlog, a full synchronization may be needed. The primary creates a snapshot, transfers the data, then continues sending new changes. This uses network bandwidth, disk/CPU, RAM, and child-process resources; it can take a while for a large dataset.

If a short disconnection occurs and the needed offsets remain in the backlog, PSYNC can send only the missing changes. The backlog is a bounded buffer. Size it using write rate and expected disconnection duration. If the backlog is too small for the gap, Redis must do a more expensive full resynchronization.

## 2. Observe replication state

On each lab node:

```text
INFO replication
ROLE
```

In `INFO replication`, observe the role, primary address, link status, replication offsets, and lag/replica state. Field names vary by version; confirm their meaning in the documentation for the version you run. `ROLE` is a direct way to inspect a node's role.

Operational signals include:

- `master_link_status` and disconnection duration.
- Replication-offset difference between primary and replica.
- Time and duration of the last full synchronization.
- Send throughput and replication backlog usage.
- Changes in latency and write response while sync is happening.

## 3. Read scaling and staleness

Reading from a replica can reduce primary load, but it does not guarantee a linearizable/latest read. If the application needs read-after-write consistency immediately, read from the primary or design a version check. A replica may be appropriate for a leaderboard or dashboard where a few seconds of staleness is acceptable.

`replica-read-only` is normally enabled to prevent accidental writes. In a managed service, the provider may manage read/write endpoints; configure the client to match that behavior.

## 4. `WAIT` and the guarantee boundary

`WAIT numreplicas timeout` on the same connection waits for prior writes from that connection to reach the requested number of replicas, or for the timeout to expire:

```text
SET lab:replication:value v1
WAIT 1 100
```

The return value is the number of replicas that acknowledged the write. If fewer than requested respond, the application must choose a timeout/retry outcome. `WAIT` does not turn a write into a disk transaction. Redis documentation says it lowers the probability of losing a write during failover, but failover remains best-effort and may promote an older replica. Run `WAIT` on the same connection that issued the write.

If policy allows writes only while a minimum number of replicas are available, evaluate `min-replicas-to-write` and `min-replicas-max-lag`. They can reduce availability during a partition and do not replace durability or backup.

## 5. What replication is not

- **Not backup:** `DEL`, an accident, or logical corruption can replicate.
- **Not persistence:** If both nodes are memory-only and restart or disappear, they do not have RDB/AOF copies.
- **Not a failover coordinator:** Replication alone does not manage role changes as an HA policy; Sentinel or Cluster adds that layer.
- **Not a zero-data-loss guarantee:** Replication is asynchronous by default.

## Published experience: why GitLab did not replicate Redis across regions

In a GitLab Geo architecture article, the team considered replicating Redis for cache/session data between sites. Inter-region latency could mean a session was not immediately available at the remote site, and the remote site remained dependent on the primary. GitLab chose another approach for that use case. This shows that a replica is not free locality or disaster recovery: application latency and consistency requirements must be tested. [GitLab Geo architecture](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

## Design lab

Observing full/partial sync requires two lab nodes and network configuration; this lesson does not start live servers. Work through these design questions:

1. Define a primary and replica for a sample dataset.
2. If the replica is two seconds behind, which endpoint serves read-after-write requests?
3. If the backlog fills before reconnect, what sync is required, and how much peak RAM/CPU headroom is needed?
4. What metric and alert should fire when lag crosses a threshold?
5. If `WAIT` times out, does the API return success or a retryable error?

## Troubleshooting

- **Replica link is down:** Check DNS/network/firewall, authentication/ACL/TLS, and connection logs.
- **Lag keeps growing:** Measure write rate, network bandwidth, slow disk, full sync, CPU, and command load.
- **Frequent full sync:** Inspect backlog size, timeouts, deployment restarts, network churn, and concurrent BGSAVE.
- **Read is stale:** Compare the replica value/offset with the primary and revisit consistency needs.
- **Replica returns a write error:** Check role and `replica-read-only`; verify primary discovery.
- **Failover is missing an acknowledged write:** Revisit async-replication assumptions and replica selection. Persistence/`WAIT` can reduce risk, not eliminate it.

## Exercises with answer guide

1. A cache reads from a replica, and a user sees the old value after an update. Give two fixes and their trade-offs.
2. A replica was offline for 30 seconds but the backlog retains only five seconds. What happens?
3. Why does issuing `WAIT` from a different connection not confirm the earlier write?
4. Why is replication to a second region alone insufficient for disaster recovery?

**Answer guide:** Read from the primary or use a consistency window/version check for question 1. A full resync is needed for question 2. `WAIT` checks prior writes on the same connection. Geographic DR also needs independent point-in-time backup, data validation, DNS/cutover, lag planning, and regional dependencies.

## Quiz with answers

### 1. Is Redis replication synchronous or asynchronous by default?

<details><summary>Answer</summary>

Asynchronous.

</details>

### 2. When can full sync occur?

<details><summary>Answer</summary>

When an initial sync is needed or the replica cannot obtain the missing offset from the backlog; the primary sends a snapshot and then new changes.

</details>

### 3. Does a read from a replica always see the latest write?

<details><summary>Answer</summary>

No. Replication lag can produce stale data.

</details>

### 4. What does `WAIT` do?

<details><summary>Answer</summary>

On the same connection, it waits for replication acknowledgment of prior writes from that connection.

</details>

### 5. Does `WAIT` reduce data loss to zero?

<details><summary>Answer</summary>

No. It lowers risk, but failover remains best-effort.

</details>

### 6. Is a replica a backup?

<details><summary>Answer</summary>

No. Bad changes are replicated too.

</details>

## References and further reading

### English: official documentation and architecture experience

- [Redis replication guide](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/) — replication setup and behavior.
- [PSYNC command reference](https://redis.io/docs/latest/commands/psync/) — partial resynchronization.
- [WAIT command reference](https://redis.io/docs/latest/commands/wait/) — replication acknowledgment and its limits.
- [INFO command reference](https://redis.io/docs/latest/commands/info/) and [ROLE command reference](https://redis.io/docs/latest/commands/role/) — inspect state.
- [Sentinel guide](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/) — the non-Cluster failover coordinator.
- [Redis high-availability guide](https://redis.io/tutorials/operate/redis-at-scale/high-availability/) — replication and failover together.
- [GitLab Geo architecture](https://about.gitlab.com/blog/how-we-built-gitlab-geo/) — cross-region session/cache trade-offs.

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی کاربردها و داده‌ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی فارسی Redis replication](https://www.google.com/search?q=آموزش+فارسی+Redis+replication+replica)

Detailed Persian replication coverage is limited. This lesson covers the core model and decisions. Verify parameters against your Redis edition, version, and managed-service behavior.

</div>

