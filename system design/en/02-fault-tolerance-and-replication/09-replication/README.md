# Replication

[فارسی](../../../02-fault-tolerance-and-replication/09-replication/README.md)

## Learning goals

- Explain what replication provides and why it is not a backup.
- Compare primary-replica, synchronous, asynchronous, and multi-primary patterns.
- Reason about replication lag and read-after-write behavior.
- Identify the conditions required for safe failover.

## Central idea

Replication keeps copies of data for durability, read capacity, or recovery. Its costs include lag, coordination, conflict handling, and choosing which replica may lead.

## Concept map

Write at primary → durable log → transfer and apply → replica reads or promotion → lag and consistency checks.

## Detailed lesson

### What replication does and does not solve

Replication sends data changes to one or more other copies so reads can be distributed or another copy may be promoted after a failure. It differs from backup: replication is usually online and current, but it also copies accidental deletion, malicious updates, and logical corruption. Keep backups with independent retention and test restoring them separately.

### Primary-replica and the change log

A database commonly records changes in a durable log such as a write-ahead log. A replica receives and applies those changes. In a primary-replica model, writes pass through one leader. This simplifies ordering, but the leader can be a throughput limit and a failure point.

A read replica can take read traffic, but it may be behind the writer. If the user writes and immediately reads from a lagging replica, they can see the old value. To provide read-after-write, route that session to the primary for a limited period, or pass a version/LSN token and wait until the replica has applied it. Limit fallback reads to the primary so the extra traffic does not overload it.

### Synchronous and asynchronous replication

With synchronous replication, a commit may wait for an acknowledgement from one or more replicas or a quorum. This can reduce the chance that a confirmed write disappears after a primary failure, but it adds network latency and makes writes sensitive to replica availability.

With asynchronous replication, the primary can respond sooner, but a failure before the latest log entries reach the replica may lose those tail writes during promotion.

Define precisely what a successful API response means: persisted on the primary’s storage, acknowledged by one replica, or acknowledged by a quorum. The answer determines durability and failover guarantees.

### Multi-primary and conflict resolution

Writing to several primaries can improve geographic write latency, but two concurrent edits may both appear valid. Last-write-wins is easy to implement but can depend on clock assumptions and discard a useful update. A conflict-free merge works only for data with operations that can be combined safely. Adding stock counts or account balances blindly is not a safe general merge.

Often, assigning one owner per key or region is simpler. Other options include version checks, domain-specific conflict resolution, and user-visible conflicts. Choose based on the meaning of the data, not only replication speed.

### Measure replica lag and eligibility

The number of log bytes behind may not express what a user experiences. Track time lag and whether a replica can serve the freshness needed for the operation. A replica can be alive but read-only, under disk pressure, or slowly applying a large transaction.

A lagging replica may be ineligible for promotion if it would violate the RPO. Automatic failover needs a policy for choosing a safe candidate and communicating possible data loss.

### Failover and split brain

When a primary becomes unreachable, a standby should not become a writer solely because a timeout expired; the primary may still be serving clients on another network path. Quorum, leases, and fencing tokens can help ensure only one active writer is authorized.

After promotion, stale endpoints and old leaders must be rejected. Record replication lag and any uncertain or lost writes during each failover so the recovery process can be improved.

## Worked example

A product catalog may use nearby replicas for reads. A financial ledger needs an authoritative write path and an explicit consistency protocol. One service can use different read behavior for different data, but the ownership and freshness contract must be clear.

## Example read-after-write policy

~~~text
1. Write the order and receive a commit version.
2. Return the version token to the client/session.
3. For subsequent reads, use the primary or wait until a replica reaches that version.
4. Stop using the primary fallback when the session no longer needs read-after-write.
~~~

## Public engineering case study

[Uber Herb: data-center replication](https://www.uber.com/us/en/blog/herb-datacenter-replication/) describes a multi-data-center replication system. Read it for the context and constraints behind the design.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Read replicas | Read traffic dominates and some lag can be managed | Stale reads and primary fallback overload |
| Synchronous replication | Confirmed writes must survive a defined failure | Higher write latency and sensitivity to network health |
| Asynchronous replication | Lower write latency matters and bounded data loss is acceptable | Tail writes may be missing after promotion |
| Multi-primary | Local writes and multi-region progress are required | Conflicts, clock assumptions, and split-brain behavior |

## Common pitfalls

- Treating a replica as a backup.
- Assuming a successful primary write is visible on every replica immediately.
- Promoting a lagging replica without checking the RPO.
- Allowing two writers after a network split.
- Using time-based last-write-wins without analyzing clock skew and business meaning.
- Opening an unlimited primary fallback for all stale reads.

## Short quiz

1. Why is replication not a substitute for backup?
2. What can be lost after a primary fails with asynchronous replication?
3. How can read-after-write be preserved?
4. What is split brain, and what can prevent it?

### Answer key

1. Replication also copies destructive or corrupt changes; a retained backup enables recovery to an earlier clean state.
2. Writes acknowledged by the primary but not yet applied by the promoted replica.
3. Route the session to the primary temporarily or wait for a replica to reach the write’s version.
4. Two nodes both believe they are the active writer; quorum, leases, and fencing can constrain write authority.

## Exercise

Choose a replication strategy for a catalog, inventory, and payment ledger. For each, define the write acknowledgement, allowed lag, read-after-write behavior, promotion eligibility, backup method, and conflict policy. Include how an operator verifies that a promoted copy meets the RPO.

## Summary

Replication adds live copies, not automatic correctness. Choose where writes are accepted, what acknowledgements promise, how lag affects reads, how recovery selects a leader, and how clean backups remain available.

## Further reading

- [PostgreSQL: Warm standby and streaming replication](https://www.postgresql.org/docs/current/warm-standby.html) — practical replication behavior and standby roles.
- [Amazon Dynamo paper](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf) — replication, availability, versioning, and conflicts.
- [Google Spanner paper](https://research.google/pubs/spanner-googles-globally-distributed-database-2/) — synchronous replication and external consistency.
- [AWS multi-Region fundamentals](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-multi-region-fundamentals/) — multi-region replication and recovery considerations.
- [Uber Herb: data-center replication](https://www.uber.com/us/en/blog/herb-datacenter-replication/) — public engineering case study.
