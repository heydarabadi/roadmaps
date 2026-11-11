<div dir="ltr" align="left">

# Redis Streams: Events, Consumer Groups, and Recovery

> Persian edition: [Read this lesson in Persian](../../../../fa/redis/04-advanced-features/streams/README.md)

> Path: Chapter 4, advanced features · Level: intermediate · Lesson and lab: 90–150 minutes
>
> Run every data-changing command only against a disposable Redis instance. The outputs below are illustrative; no live execution is claimed.

## Prerequisites and learning objectives

You should already understand keys, Hashes, TTL, `redis-cli`, and the difference between Redis and a relational database. After this lesson, you should be able to:

- Explain a Stream as an ordered event log and compare it with Lists and Pub/Sub.
- Distinguish producers, consumers, consumer groups, entry IDs, pending entries, and acknowledgments.
- Read an entry, acknowledge it after work succeeds, and recover work assigned to a failed consumer.
- Account for retries, duplicates, idempotency, trimming, capacity, and failover in a design.

## The central idea

A Stream is an append-oriented data structure inside Redis. Each entry has an ordered ID and one or more field/value pairs. A consumer group lets multiple workers share work while Redis records delivery and acknowledgment state. This is more recoverable than Pub/Sub, but it does not by itself provide exactly-once effects, a distributed transaction, a backup, or a no-loss guarantee across every failover.

```text
Producer --XADD--> Stream (ordered entries)
                         |
                   Consumer Group
                    /           \
              worker-A         worker-B
                 |                 |
       message enters PEL   message enters PEL
                 |                 |
        side effect succeeds       crash / timeout
                 |                 |
              XACK       XPENDING -> XAUTOCLAIM -> retry
```

`PEL` means **Pending Entries List**. It records which entries were delivered to a group but have not yet been acknowledged. A PEL is a delivery record; it cannot prove that an external side effect in a database, payment API, or another system completed.

## 1. A Stream and its entry IDs

The key name, such as `orders:events`, is the Stream. `XADD` appends an entry. After the key, `*` asks Redis to generate an ID; the remaining arguments must form complete field/value pairs.

```text
XADD orders:events * order_id 501 event created
"1731234567890-0"
XLEN orders:events
(integer) 1
XRANGE orders:events - +
1) 1) "1731234567890-0"
   2) 1) "order_id"
      2) "501"
      3) "event"
      4) "created"
```

An automatically generated ID has the form `<milliseconds>-<sequence-within-that-millisecond>`. Its time component is not an authoritative business clock, a trusted event timestamp, or a global ordering across several Streams. A manually supplied ID must follow the increasing-ID rule for that Stream. `XRANGE` reads a range; `XREVRANGE` reads from the end.

Field and value names are byte strings. Define the event contract yourself: versioned event name, unique event ID, event time, schema version, and the information consumers need. Avoid placing sensitive data or enormous payloads in every entry. Keep events small and define how long they need to be retained.

## 2. Consumer groups and message delivery

Create a group at ID `0` to read from the beginning. `MKSTREAM` creates the Stream if it does not exist yet.

```text
XGROUP CREATE orders:events billing 0 MKSTREAM
OK
XADD orders:events * order_id 501 event created
"1731234567890-0"
XREADGROUP GROUP billing worker-1 COUNT 10 STREAMS orders:events >
```

The worker receives the entry, and Redis records it in the group's PEL. `>` means entries that have not yet been delivered to any consumer in this group. To read pending entries assigned to the current consumer again, use `0` or another ID obtained from the PEL; `>` does not fetch pending work.

Several workers with distinct names can call `XREADGROUP`; Redis distributes new entries among them. That distribution is **not** the same as “processed exactly once.” A worker may finish an external action, disconnect before `XACK`, and cause the entry to be delivered to another worker.

### Acknowledge only after successful work

A typical order for an independent side effect is:

1. Read the entry.
2. Validate it. Send invalid events to a dead-letter or quarantine path, or mark them with a specific reason according to an explicit policy.
3. Apply the business effect in an idempotent way.
4. Run `XACK` only after that effect succeeds.

```text
XACK orders:events billing 1731234567890-0
(integer) 1
XPENDING orders:events billing
```

If the application writes an order to a database and crashes before `XACK`, the entry can be delivered again. Use a unique `event_id`; for example, store it in the database with a unique constraint or make the operation conditional on the event not having been applied before.

If you acknowledge first and update the database second, a crash between those two actions can make the group consider the event complete while the business state is still stale. Redis and an external database do not automatically share a transaction.

## 3. Finding and recovering pending entries

`XPENDING` summarizes entries that have not been acknowledged. The exact output depends on the command form and Redis version; the important facts are which group and consumer received the entry and how long it has been pending.

```text
XPENDING orders:events billing
XINFO GROUPS orders:events
XINFO CONSUMERS orders:events billing
```

Use the extended form `XPENDING key group start end count [consumer]` to inspect individual pending entries. If the consumer that received an entry has died, claim it after an operational idle-time threshold. Since Redis 6.2, `XAUTOCLAIM` can scan for and claim entries idle for the specified period; `XCLAIM` is the more explicit alternative.

```text
XAUTOCLAIM orders:events billing recovery-1 60000 0-0 COUNT 20
```

The 60,000 millisecond value is an example, not a general recommendation. Set the threshold above normal processing time and heartbeat gaps. If it is too short, another worker may claim an entry while the original worker is merely slow, so both may perform the side effect. If it is too long, real recovery is delayed. A production recovery loop must continue from the returned `XAUTOCLAIM` cursor and safely handle duplicate processing.

## 4. Size, retention, and trimming

A Stream can grow indefinitely without a retention policy. Two common approaches are:

- Approximately cap the number of entries as you write: `XADD orders:events MAXLEN ~ 100000 * ...`.
- Trim manually with `XTRIM`, by length (`MAXLEN`) or by ID (`MINID`).

The `~` option makes trimming approximate and is often cheaper. The value `100000` is only for the lab. Calculate real capacity from event rate, payload size, replay window, RAM, and recovery SLA. Deleting entries may remove data needed by a lagging consumer. Do not trim a message merely because it is old; first inspect consumer lag, PELs, backup state, legal retention needs, and replay options.

When a Stream falls behind its retention target, decide whether to pause slow consumers, archive data elsewhere, add capacity, or regenerate events from a source of truth. `XDEL` can delete a specific entry; privacy and audit requirements need an explicit deletion policy for Stream data too.

## 5. Streams compared with other tools

| Need | Starting option | Limitation or decision |
| --- | --- | --- |
| Live notification where missed messages are acceptable | Pub/Sub | No replay, acknowledgment, or PEL. |
| Simple FIFO work with one consumer | List | You must build visibility timeout and acknowledgment behavior. |
| Small-to-medium event log beside a Redis-backed service | Streams | Design retention, PEL handling, retries, and failover. |
| Long replay window, many independent consumers, and large retained logs | Evaluate Kafka or a similar log system | More operating cost and complexity; Redis Streams and Kafka do not have identical guarantees. |

### Published engineering experience

Netflix's engineering article about its write-ahead log describes Kafka in the messaging and cross-region replication path and EVCache in the key-value cache layer. It also illustrates that a cache and a durable event log have different roles. This article does **not** show Netflix using Redis Streams. Its value here is the architectural separation of cache and durable event paths, and the need to design for slow consumers and backpressure. [Netflix TechBlog: Building a Resilient Data Platform with Write-Ahead Log](https://netflixtechblog.com/building-a-resilient-data-platform-with-write-ahead-log-at-netflix-127b6712359a)

Redis's official documentation explains that Stream entries and consumer-group state are persisted in RDB/AOF and propagated to replicas, but replication is asynchronous by default. During some failovers, the promoted replica may not contain the most recent change. `WAIT` can reduce the chance of losing a write, but it is not an absolute failover guarantee. For important events, evaluate AOF/fsync policy, replication, `WAIT`, backups, and rebuild options together. [Redis Streams: message safety and replication](https://redis.io/docs/latest/develop/data-types/streams/)

## Guided lab

In two terminals connected to the same disposable Redis instance:

**Terminal A — produce entries and create the group:**

```text
DEL lab:orders
XGROUP CREATE lab:orders workers 0 MKSTREAM
XADD lab:orders * event_id e-1 order_id 501 status created
XADD lab:orders * event_id e-2 order_id 502 status created
```

**Terminal B — read, inspect, and acknowledge:**

```text
XREADGROUP GROUP workers worker-a COUNT 10 BLOCK 1000 STREAMS lab:orders >
XPENDING lab:orders workers
XACK lab:orders workers <FIRST-MESSAGE-ID>
XPENDING lab:orders workers
```

Replace `<FIRST-MESSAGE-ID>` with the actual ID from your output; do not type the angle brackets literally. Leave the second entry pending and inspect `XPENDING` again. If you know its ID, inspect its details, then try `XCLAIM` or `XAUTOCLAIM`. This lab deletes any previous data under `lab:orders`.

## Troubleshooting and common pitfalls

- `NOGROUP`: Run `XGROUP CREATE` with the exact Stream and group names.
- `>` returns no entry: All new entries may already have been delivered to this group. Inspect pending entries with `XPENDING`.
- Duplicate work: Inspect the crash window between the external side effect and `XACK`; idempotency is required.
- PEL keeps growing: Workers may not acknowledge, may be failing, or may be stuck. Monitor oldest idle time, pending count, and consumer health.
- Memory rises: Review `XLEN`, `XADD` rate, retention, payload size, and replica/AOF buffers together.
- A live worker's entry was claimed: The idle threshold may be shorter than actual processing time, or the heartbeat model may be missing.
- An entry disappeared: Check whether `XTRIM` or `XDEL` ran, which ID the group started at, and whether the latest write survived failover.

## Exercises with explanations

1. Why can a Stream recover better than Pub/Sub after a consumer disconnects?
2. What happens if the database write succeeds but the application crashes before `XACK`?
3. Why can a short idle timeout cause duplicate work?
4. What should you check before running `XTRIM`?
5. Does `WAIT 1 100` guarantee that an entry exists after every failover?
6. For an order event, billing and analytics each need independent history. Is one shared consumer group enough?

<details><summary>Explanations</summary>

1. The Stream retains entries and the group records delivery and acknowledgment state; Pub/Sub does not save or replay messages for offline subscribers.
2. The entry remains pending and may be processed again after recovery. At the application level this is at-least-once behavior; make the event idempotent.
3. The original slow worker may still be processing when another worker claims the entry. Both workers can then apply the effect.
4. Consumer lag, pending entries, required retention, replay/restore options, and whether the event can be regenerated from another source.
5. No. `WAIT` strengthens replication acknowledgment, but the official documentation does not define it as an absolute guarantee for replica selection in every failover condition.
6. Usually, create a separate group for each logical consumer so each can keep an independent cursor and acknowledgment state. Account for the additional Stream/PEL storage and retention policy.

</details>

## Quiz with answers

### 1. When should a consumer run `XACK`?

<details><summary>Answer</summary>

After the external side effect succeeds, with the assumption that the effect is safe to repeat.

</details>

### 2. What does `>` mean in `XREADGROUP`?

<details><summary>Answer</summary>

Entries that have not yet been delivered to any consumer in that group.

</details>

### 3. How do you recover a pending entry?

<details><summary>Answer</summary>

Inspect it with `XPENDING`, choose an appropriate idle threshold, then use `XCLAIM` or `XAUTOCLAIM`.

</details>

### 4. Do Streams guarantee exactly-once external effects?

<details><summary>Answer</summary>

No. The external effect and acknowledgment do not share a transaction. Application coordination and idempotency are required.

</details>

### 5. Why can trimming be dangerous?

<details><summary>Answer</summary>

It can remove an event that a lagging consumer or recovery process still needs.

</details>

### 6. Does `WAIT` make failover completely lossless?

<details><summary>Answer</summary>

No. It lowers the probability of losing a write but does not provide an absolute guarantee.

</details>

## References and further reading

### English: official documentation and engineering articles

- [Redis Streams data type guide](https://redis.io/docs/latest/develop/data-types/streams/) — entries, groups, pending state, persistence, and replication considerations.
- [Redis streaming use-case guide](https://redis.io/docs/latest/develop/use-cases/streaming/) — choosing Streams and understanding their processing model.
- [XADD command reference](https://redis.io/docs/latest/commands/xadd/) — append, IDs, and trimming options.
- [XGROUP command reference](https://redis.io/docs/latest/commands/xgroup/) — creating and managing groups.
- [XREADGROUP command reference](https://redis.io/docs/latest/commands/xreadgroup/) — group reads and the `>` ID.
- [XACK command reference](https://redis.io/docs/latest/commands/xack/) — acknowledgment semantics.
- [XPENDING command reference](https://redis.io/docs/latest/commands/xpending/) — inspect unacknowledged entries.
- [XCLAIM command reference](https://redis.io/docs/latest/commands/xclaim/) and [XAUTOCLAIM command reference](https://redis.io/docs/latest/commands/xautoclaim/) — reclaim work from failed consumers.
- [XTRIM command reference](https://redis.io/docs/latest/commands/xtrim/) and [XINFO command reference](https://redis.io/docs/latest/commands/xinfo/) — retention and observability.
- [Redis's guide to streaming systems](https://redis.io/docs/latest/develop/use-cases/streaming/) — design considerations for event processing.
- [Netflix TechBlog: Building a Resilient Data Platform with Write-Ahead Log](https://netflixtechblog.com/building-a-resilient-data-platform-with-write-ahead-log-at-netflix-127b6712359a) — Kafka and EVCache roles; not a Redis Streams case study.
- [Redis's Streams and Kafka ebook](https://redis.io/resources/understanding-streams-in-redis-and-kafka-ebook.pdf) — a vendor-authored comparison; validate guarantees against each system's current documentation.

### فارسی

- [آموزش فارسی Redis در زبان سلام؛ آموزش مرحله‌ای و مرجع فرمان‌ها](https://www.salamlang.ir/std/db/redis/)
- [ویدئوی فارسی Redis Streams و consumer group](https://www.youtube.com/watch?v=_IcgS_NuV-k)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

Redis Streams material in Persian is limited, especially on PEL recovery and durability. This lesson covers the concepts directly; use the official documentation for the exact Redis version and deployment you run.

</div>

