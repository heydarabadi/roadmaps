# Consistency Patterns

[فارسی](../../../01-foundations/05-consistency-patterns/README.md)

## Learning goals

- Explain consistency as a contract about histories clients may observe.
- Compare strong, eventual, and weak consistency at a practical level.
- Use session guarantees to provide useful behavior without global coordination.
- Understand what quorum arithmetic does and does not guarantee.

## Central idea

A consistency model defines how writes become visible to readers. Strong, eventual, and weak models offer different combinations of coordination, latency, availability, and conflict-handling work.

## Concept map

Write acceptance → replication and ordering → read visibility → client/session guarantees → conflict policy → recovery.

## Detailed lesson

### Model the observation, not a vague label

A consistency model describes which histories a process may observe when it reads data. It is different from durability: a write can be safely stored on one node while a read replica has not received it yet. With multiple clients and replicas, even the word “latest” needs a rule. Wall-clock time on separate machines does not automatically provide a reliable total order.

### Strong consistency and linearizability

Under linearizability, each operation appears to take effect at one instant between its start and completion, and real-time order between non-overlapping operations is preserved. If write A returns success, a subsequent read should return A or a newer value.

Achieving this across nodes can require coordination. That adds latency and can stop some reads or writes during a network partition. Strong consistency is useful for operations where stale observations can cause incorrect business outcomes, but it is not free and should not be assumed for every cache or read path.

### Eventual consistency and convergence

Eventual consistency says that if writes stop and communication is restored, replicas will eventually converge. It does not, by itself, say how long convergence takes, which value wins, or how a user sees a conflict.

Concurrent edits need an explicit policy: last-write-wins based on a version or timestamp, a domain-specific merge, optimistic version checks, or a visible conflict for the user to resolve. Feeds and counters often tolerate some delay. Payments and inventory need more careful control.

### Weak consistency and suitable data

Weak consistency may allow readers to see old or incomplete values and may not promise a particular convergence time. Telemetry, a temporary display value, or reconstructible state may tolerate that contract. Do not use weakly consistent data for financial or authorization decisions unless the error mode is intentionally controlled.

### Session guarantees between the extremes

Read-your-writes means a user who just wrote a value can see that value on a later read. Monotonic reads mean a session does not move backward to a version older than one it already observed.

Possible techniques include a session token carrying a version, routing a session to the primary until replicas catch up, or reading from a quorum. These can be cheaper than strong global coordination, but they add session state and failover complexity.

### Quorums in plain language

For N replicas, a system may require acknowledgements from W replicas for a write and read results from R replicas. If R + W > N, the read set and write set overlap by at least one node. This arithmetic alone does not guarantee linearizability, a total order across concurrent writes, or conflict resolution. You must also understand the database protocol, versioning rules, and behavior when a node is slow or unavailable.

## Worked example

After a user changes a shipping address, the same session should see the new value. A public profile read from a replica may lag briefly. One possible policy is to return a version token from the write and use it to ensure later reads in that session do not return an older version.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Linearizable reads/writes | Stale reads would cause unacceptable business harm | Cross-node coordination can raise latency or reduce progress during partitions |
| Eventual consistency | Temporary divergence is acceptable and conflicts can be handled | “Eventually” may be too slow or ambiguous for user expectations |
| Read-your-writes | A session must immediately observe its own update | Sticky routing can complicate failover and load balancing |
| Quorum reads/writes | A database protocol supports the required overlap and recovery behavior | The arithmetic does not replace understanding ordering and conflict rules |

## Common pitfalls

- Treating eventual consistency as a promise of “a few seconds.”
- Assuming converged replicas automatically resolve conflicts correctly.
- Using wall-clock timestamps as an unquestioned ordering authority.
- Confusing write durability with visibility on every read path.
- Assuming R + W > N proves linearizability.

## Short quiz

1. What does eventual consistency guarantee, and what does it leave unspecified?
2. How can read-your-writes be provided without globally strong reads?
3. Two clients edit the same field concurrently. What policy must the design define?
4. Why is R + W > N not a complete consistency proof?

### Answer key

1. After writes stop and communication returns, replicas converge; the convergence bound and winner of concurrent writes are not defined by the phrase alone.
2. Route the session to a primary until it catches up, or use a version token/read policy that waits for the written version.
3. A conflict policy such as version rejection, domain merge, deterministic winner, or user resolution.
4. It only reasons about set intersection; the protocol must still define ordering, versions, failures, and conflict resolution.

## Exercise

For a store, choose consistency expectations for a product description, shopping cart, inventory reservation, and payment ledger. For each operation, specify what “latest” means, how concurrent updates are handled, and what the user sees during a partition.

## Summary

Consistency is the contract for how writes become visible and how concurrent changes are ordered. Pick the weakest contract that preserves correct business behavior, then make freshness, conflict resolution, and failure handling explicit.

## Further reading

- [Amazon Dynamo paper](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf) — eventual consistency, vector clocks, and conflict handling.
- [Gilbert and Lynch: CAP theorem formal result](https://doi.org/10.1145/564585.564601) — consistency and availability under partitions.
- [Google Spanner paper](https://research.google/pubs/spanner-googles-globally-distributed-database-2/) — externally consistent distributed transactions.
- [Jepsen analyses](https://jepsen.io/analyses) — tests and reports on real storage-system guarantees.
- [PostgreSQL: Warm standby and streaming replication](https://www.postgresql.org/docs/current/warm-standby.html) — practical primary/standby replication behavior.
