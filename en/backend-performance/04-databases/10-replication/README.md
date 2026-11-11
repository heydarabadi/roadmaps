<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/04-databases/10-replication/README.md) · English

# Replication — Copying Data with a Consistency Contract

**Learning goal:** Distinguish a read replica from backup and sharding, include lag and read-after-write in design, and explain the cost of synchronous replication. Sources were checked on 2026-11-10; PostgreSQL SQL example was completed and link-checked on 2026-11-11. It was not executed.

## Mental model

Replication keeps data or its changes on another node. In a single-primary design, writes go to the primary and some reads may go to replicas. Read capacity may grow; primary write capacity does not automatically increase because changes still have to be produced and applied. Replication can be synchronous or asynchronous, physical or logical, with different capabilities.

| Choice | Benefit | Cost or risk |
| --- | --- | --- |
| Async replica | offloads reads; primary commit need not wait | lag and possible loss of acknowledged writes on failover |
| Sync replica | stronger acknowledgment guarantee under configured mode | network latency and dependence on quorum/configuration |
| Read from primary | fresher view after commit | uses primary capacity |

In PostgreSQL, the synchronous-commit level matters. Receiving or flushing data on a standby differs from replaying it and making it visible to queries. The remote_apply setting waits for a stronger stage.

## Prerequisites and read-consistency path

The primary accepts writes in this model; a replica receives and applies the changes. With asynchronous replication, commit can return before replay on the replica. Receive position means WAL has arrived; replay position means it has been applied and can be visible to queries. A backup is a separate recovery copy; a replica also receives logical mistakes such as accidental deletion.

## Use and trade-offs

A replica can suit reports or catalogs with a stated staleness budget. For immediately showing an order just written, options include reading the primary, waiting for a known replication position, or routing a session accordingly. “Wait a few seconds” is not a guarantee because lag changes during incidents. Replicas also cost CPU, disk, network, monitoring, and failover effort.

## Worked example

Assume an order commits on the primary at t=0 and is replayed by the replica at t=2 seconds. A list read from the replica at t=0.2s may not show it. For a read-after-write contract:

~~~text
write_result = primary.commit_order(command)
return write_result.order

on subsequent order detail read:
    if consistency requires read_after_write:
        read primary
    else:
        read eligible replica within freshness budget
~~~

On a PostgreSQL standby, receive and replay positions can help distinguish stages:

~~~sql
SELECT pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn();
~~~

A NULL or stalled value needs context about recovery state. LSN difference is a byte position, not a guarantee of staleness in seconds. Interpret it with connection state, write rate, and replay progress.

In this example, a read at 0.2 seconds can be stale, and another read at 1 second is not guaranteed to become fresh. For “show my new order,” return the write result or temporarily route to the primary. Yesterday’s report may read from a replica if lag stays within its freshness budget.

## Worked exercise

Draw a timeline with commit at second 0, a network cut until second 10, and reads at seconds 1 and 5. Choose separate paths for “show this user their order” and “show yesterday’s statistics.”

The first read is not guaranteed without the primary or waiting for a stated replication position. The second can tolerate a stated freshness delay. If failover occurs during the cut, asynchronous changes that never reached the replica may be absent. The recovery-point objective must accept that risk or use a suitable acknowledgment configuration.

## Evidence and limits

PostgreSQL’s hot-standby documentation describes conflicts between long reads and replay; depending on configuration, a query may be canceled or replay delayed. This is operational documentation, not a production case for the timeline above. Feedback settings can also cause old versions to be retained on the primary.

## Troubleshooting and checklist

A replica is not a backup: a bad delete is replicated too. Failover without fencing can leave two active primaries. Monitor hidden lag, WAL retained by slots, and canceled standby queries. NULL lag does not necessarily mean zero.

- [ ] Classify reads by freshness and read-after-write need.
- [ ] Define commit-acknowledgment mode and behavior without a standby.
- [ ] Monitor lag, replay progress, conflicts, and WAL retention.
- [ ] Define replica eligibility, fallback, and protection for the primary.
- [ ] Exercise failover, fencing, reconnect, RPO, and RTO.
- [ ] Maintain a separate backup and test restoration.

If a user cannot see a write, inspect routing, receive/replay positions, WAL rate, and replica connection; then check the freshness budget and fallback for that read. If a standby query is canceled, inspect conflicts and query duration against replay. A lag number alone is not a failover test.

## Self-check

1. How does a replica differ from a shard?
2. Why does an async commit not ensure the replica can show it immediately?
3. Does every synchronous commit make the change immediately query-visible on the standby?
4. Why is a replica not a backup?
5. What can a long hot-standby query cause?

### Answers with reasoning

1. A replica copies the same dataset; a shard owns a different subset.
2. Transfer and replay are separate stages and may lag after primary commit.
3. No. Acknowledgment of receipt/flush differs from replay; configuration determines the guarantee.
4. Logical mistakes such as deletion are also replicated; recovery needs a separate path.
5. It can conflict with replay; depending on settings, the query may be canceled or replay delayed.

## Optional further reading

This page teaches the consistency model and the example. These links are optional; exact guarantees depend on database version and configuration.

- Persian: [Introductory NoSQL concepts](https://dntips.ir/www.dntips.ir-posts-1472.html) introduces replication versus partitioning; it is an older primer, not current PostgreSQL configuration guidance.
- English, official: [PostgreSQL warm standby and replication](https://www.postgresql.org/docs/current/warm-standby.html) documents replication modes.
- English, official: [PostgreSQL hot standby](https://www.postgresql.org/docs/current/hot-standby.html) covers query conflicts during replay.
- English, official: [PostgreSQL recovery functions](https://www.postgresql.org/docs/current/functions-admin.html) defines WAL-position functions.
- English, official: [Synchronous replication](https://www.postgresql.org/docs/current/warm-standby.html#SYNCHRONOUS-REPLICATION) explains standby acknowledgments.
- English, official: [synchronous_commit setting](https://www.postgresql.org/docs/current/runtime-config-wal.html#GUC-SYNCHRONOUS-COMMIT) documents commit wait stages.
- English, official: [PostgreSQL monitoring statistics](https://www.postgresql.org/docs/current/monitoring-stats.html) describes replication monitoring views.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Slow-query logs](../09-slow-query-logging/README.en.md) · [Next: Sharding](../11-sharding/README.en.md) · [Cache freshness](../../01-caching/04-invalidation-and-freshness/README.en.md)

</div>
