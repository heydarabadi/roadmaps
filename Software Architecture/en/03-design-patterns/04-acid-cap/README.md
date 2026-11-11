# ACID and the CAP Theorem

## Learning goals

- Explain transaction guarantees and isolation behavior.
- Apply the CAP trade-off to a network-partition scenario.
- Connect data consistency choices to user-visible behavior.

## Core idea

ACID describes transaction properties in one database. CAP describes a trade-off for a distributed data system when a network partition occurs. They answer different questions. “CAP says every NoSQL database gets two out of three” is misleading: during a partition, the system must choose between consistent responses and availability for affected operations.

## ACID

- **Atomicity:** a transaction’s work is fully applied or not applied.
- **Consistency:** declared invariants hold after commit; the database does not infer missing business logic.
- **Isolation:** concurrent transactions follow defined visibility and conflict rules.
- **Durability:** after a successful commit, data remains according to the database’s durability guarantees.

Isolation levels and locking affect dirty reads, non-repeatable reads, phantoms, and serialization failures. Review the documentation for the actual database engine.

## Transaction anomalies

- **Dirty read:** a transaction sees another transaction’s uncommitted value.
- **Non-repeatable read:** a later read of the same row sees a newly committed value.
- **Phantom:** a repeated query sees additional rows that now match the predicate.
- **Lost update:** concurrent writes cause one change to overwrite another.
- **Deadlock:** transactions form a cycle while waiting for locks; the database usually aborts one, and the application must handle it.

Serializable isolation can produce a result equivalent to a serial execution, but may cause contention or aborts. Lower levels may perform better for some workloads; verify domain invariants with concurrency tests. ACID does not guarantee that application code runs only once or that a transaction across two services is atomic.

## Three different meanings of consistency

**Database constraints** mean that rules such as unique and foreign-key constraints hold in the data store. **ACID consistency** means a transaction moves valid state to valid state according to the constraints we declared. **CAP consistency** concerns whether replicas present a linearizable, up-to-date view of operations. Use distinct language for each.

## CAP in practice

During a network partition, the system cannot guarantee both that every request receives a response (**availability**) and that all clients see one linearizable view (**consistency**). Network partitions cannot be designed away, so product behavior when replicas cannot communicate matters.

CAP is about that partition window; it does not mean a single database is permanently “CP” or “AP.” Partition tolerance means continuing behavior despite communication failure between nodes. CAP consistency is not the same as relational constraints or “healthy data.”

To analyze an operation, ask:

1. Is the same data replicated across nodes or regions?
2. What communication failure counts as a partition, and how quickly is it detected?
3. During a partition, should this operation succeed, be rejected, or wait?
4. If both sides accept a change, what rule resolves the conflict?
5. What status does the user see, and how is convergence measured?

CAP does not cover every distributed trade-off. Latency, consistency models, durability, recovery, and real availability matter too. Make a decision per operation: a view counter may prioritize availability while a financial debit needs stronger coordination.

## Worked example: reserving the last item

Two regions receive a purchase request for the final warehouse item. If both confirm immediately, the store may oversell. Rejecting or queuing requests during a regional partition reduces availability but protects the invariant. For a wish list, temporary duplicate entries may be acceptable.

| Data or operation | Likely priority | Behavior during a partition |
| --- | --- | --- |
| Account balance/debit | Invariant and no double spending | Reject or suspend until coordinated |
| View counter | Availability and later convergence | Count locally, then merge |
| Last ticket reservation | Never exceed capacity | Central coordination, lock, or wait |

## Common pitfalls

- Treating CAP as a permanent database label.
- Confusing CAP consistency with relational integrity.
- Assuming more replicas solve every availability problem.
- Applying one consistency policy to every operation.

## Self-check quiz

1. **When does CAP inform a decision?** When data is distributed across nodes and a partition occurs; choose required behavior for that situation.
2. **Does ACID guarantee correct business logic?** No. It applies transactions under the declared rules and constraints.
3. **Does CAP availability mean 100% uptime?** No. It means non-failing nodes respond under the partition model, not an absolute operational guarantee.
4. **What are options for the last unit of inventory?** Strong coordination, queuing, or constrained reservation; choose based on sales value, latency, and oversell risk.
5. **Why can Serializable still fail a transaction?** Concurrent transactions may be aborted to preserve serializable behavior; callers need bounded, safe retry.

## Exercise

For likes, inventory, and account balances, decide what delay is acceptable, what a partition means, and which invariant must never break.

### Sample answer

Like counts can be a briefly stale projection; eventual consistency is usually acceptable unless abuse or another security constraint applies. The final inventory unit must not be oversold, so reservation may be rejected or suspended during a partition. Financial balances need a ledger and unique posting; do not accept inconsistent concurrent updates merely to preserve availability. State the decision per operation rather than labeling the whole database.

## Further reading

- Persian: [Persian DDD guide](https://github.com/hheydarian/Understanding-Domain-Driven-Design), [Data and databases in Persian architecture notes](https://www.alirostami.com/software-architecture/)
- English: [Martin Kleppmann: Please stop calling databases CP or AP](https://martin.kleppmann.com/2015/05/11/please-stop-calling-databases-cp-or-ap.html), [AWS: Data consistency](https://docs.aws.amazon.com/whitepapers/latest/understanding-the-aws-well-architected-framework/data-consistency.html), [PostgreSQL transaction isolation](https://www.postgresql.org/docs/current/transaction-iso.html), [Jepsen analyses](https://jepsen.io/analyses)
