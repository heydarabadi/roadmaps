# The CAP Theorem

[فارسی](../../../../fa/system-design/01-foundations/06-cap-theorem/README.md)

## Learning goals

- Describe the network condition CAP addresses.
- Use the formal meanings of consistency and availability in the theorem.
- Predict what a design does during a partition.
- Avoid treating a database as permanently “CP” or “AP” in every condition.

## Central idea

During a network partition, a distributed system cannot guarantee both a successful response to every request and linearizable consistency for every operation. CAP is about behavior when communication fails; it is not a permanent choice to disable consistency or availability.

## Concept map

Network partition → replicas cannot coordinate → reject/wait or accept independently → consistency, availability, and conflict trade-offs.

## Detailed lesson

### Draw the partition scenario

Imagine two nodes, N1 and N2, holding a record about the last item in stock. Their network link breaks, but clients can still reach each node locally. A client in one region asks N1 to buy the item; another client asks N2. The system cannot coordinate a single authoritative answer across the split.

The partition is not a feature an architect can remove from a distributed system. Links can be delayed, lost, or unavailable. The design chooses how to behave when that happens.

### Use CAP’s precise terms

- **Consistency (C)** in the formal CAP discussion is close to linearizability: operations should appear in one order that preserves real-time ordering, so a later read sees a completed write.
- **Availability (A)** means every request to a non-failing node receives a successful response. A failure response or indefinite wait does not satisfy this definition.
- **Partition tolerance (P)** means the model permits communication failures that split nodes into groups.

Because partitions can occur, during a partition the system must choose whether some requests stop progressing or whether it can return responses that may not fit one consistent history.

### Choose behavior during the partition

A CP-style behavior may reject or delay a write on N2 because it cannot safely coordinate with the leader or quorum. This avoids confirming two conflicting outcomes, but clients on the isolated side cannot complete that operation.

An AP-style behavior may accept a write locally on both sides. When communication recovers, the system must reconcile the concurrent values. Last-write-wins is simple, but it can discard a valid update. Domain-aware merging or explicit ownership can preserve meaning, at the cost of more design and operational work.

The exact behavior depends on the operation and database protocol. These labels are shorthand for a failure-mode choice, not a full description of every feature.

### What CAP does not say

CAP does not say that every database is always only one of three fixed product types: CA, CP, or AP. A system can behave differently for different operations and conditions. CAP also does not describe the normal-operation trade-off between coordination latency and consistency. PACELC extends the reminder: if there is a partition, consider availability versus consistency; else, consider latency versus consistency.

### Checkout example

For a shopping cart, accepting a local edit in each region and merging later may be reasonable. For a bank withdrawal, independently accepting both writes could spend the same funds twice. The service might require a leader or quorum and return a retryable error on an isolated side.

“CP is better” or “AP is better” is not a complete answer. Compare the business loss from stale data, a rejected request, a conflict, or a delayed result for the particular operation.

### Normal-operation latency also matters

Even without a partition, a fresh read from a distant node or a quorum wait adds latency. A local stale replica may be faster; a linearizable read may need coordination. Multi-region architecture must fit these normal-operation costs to the user journey’s latency objective.

## Worked example

Two regions try to sell the last unit of a rare product. Rather than promising simultaneous global acceptance and exact inventory during disconnection, the design might assign temporary ownership of a stock range to one region or use a lease. That reduces conflict but may make the other region unable to sell during a failure.

## Public case study

[Uber Herb: multi-data-center replication](https://www.uber.com/us/en/blog/herb-datacenter-replication/) is a published example of the engineering decisions involved in cross-data-center replication. Treat the article as a description of one system and period, not as a universal design.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Require coordination before accepting a write | Duplicate or conflicting writes are more costly than temporary rejection | The isolated region cannot make progress |
| Accept writes on both sides | Users need local progress and conflicts have a safe resolution | Merging can lose business meaning or require user action |
| Assign ownership or leases | A resource can have one temporary authoritative owner | Lease expiry, clock assumptions, and failover can be subtle |
| Allow bounded stale reads | Read latency matters and the data has a safe freshness window | Downstream decisions may act on old values |

## Common pitfalls

- Saying “pick any two” without explaining that the relevant condition is a partition.
- Calling any HTTP 200 response CAP availability, even if it is invalid or partial.
- Treating partition tolerance as an optional feature for a distributed networked system.
- Assuming AP means conflict resolution is automatic.
- Applying one consistency policy to every table and operation.

## Short quiz

1. What event does P refer to?
2. What may a CP-oriented service do when it loses a quorum?
3. What does an AP-oriented service need to do after both sides accept conflicting writes?
4. Why is CAP not a permanent instruction to turn off either C or A?

### Answer key

1. A network partition that prevents parts of the system from communicating.
2. Reject or delay operations that require coordination, rather than confirm a potentially inconsistent result.
3. Reconcile the conflict using an explicit policy such as version checks, merge logic, ownership, or user resolution.
4. The trade-off concerns behavior during a partition; behavior and guarantees may differ in normal conditions and across operations.

## Exercise

For a store, analyze a partition affecting (a) the cart, (b) inventory reservation, and (c) payment status. For each operation, state whether either side may accept updates, what the user sees, how conflicts are reconciled, and what happens after connectivity returns.

## Summary

CAP helps reason about how a distributed system behaves when its nodes cannot communicate. Choose which operations can pause and which can accept potentially conflicting work; then define recovery and reconciliation. The theorem is a tool for examining failure behavior, not a product label.

## Further reading

- [Gilbert and Lynch: Brewer’s conjecture and the feasibility of consistent, available, partition-tolerant web services](https://doi.org/10.1145/564585.564601) — formal CAP result.
- [Brewer: Perspectives on the CAP theorem](https://groups.csail.mit.edu/tds/papers/Gilbert/Brewer2.pdf) — clarification of the theorem and its context.
- [Amazon Dynamo paper](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf) — one availability-oriented design and its conflict mechanisms.
- [Google Spanner paper](https://research.google/pubs/spanner-googles-globally-distributed-database-2/) — global replication and external consistency.
- [Jepsen analyses](https://jepsen.io/analyses) — practical scrutiny of database consistency claims.
