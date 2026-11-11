# Transactions, Atomicity, and Read/Write Concerns

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/05-reliability/transactions-concerns/README.md).

> **Learning goal:** Separate atomicity, read visibility, read routing, write acknowledgment, and retry behavior.

## Atomicity and transaction boundaries

Each single-document write is atomic. If an invariant spans several documents, a multi-document transaction can make those database operations commit or abort together. Keep that transaction short. Do not include a payment API, HTTP call, or email because MongoDB cannot roll back external services.

## Three concern/routing decisions

- **Write concern** asks how much acknowledgment is required before a write succeeds from the client's point of view. `w: 1` requests acknowledgment from the primary; `w: "majority"` requests majority acknowledgment according to the replica-set topology and configuration. Journaling and deployment settings also matter to durability.
- **Read concern** defines the visibility/consistency level for returned data. `local`, `majority`, and `snapshot` have different guarantees and use cases. A local read may observe data that can later be rolled back after failover.
- **Read preference** selects which member may serve a read, such as primary or secondary. Secondary reads can be stale because replication is asynchronous.

Do not assume these options are interchangeable. Read preference chooses a destination; read concern describes the accepted view of data; write concern controls acknowledgment of a write.

## Match settings to the business effect

- A product catalogue page may tolerate a slightly stale read.
- A checkout decision about inventory cannot rely on a stale read alone; use a conditional atomic write and the required durability behavior.
- A management report may allow lag if its freshness is visible and acceptable.
- A payment timeout creates an unknown outcome; query durable state with an idempotency key instead of blindly repeating the payment.

## Retryable reads, writes, and transactions

Drivers retry some eligible operations after transient errors. This does not cover every operation or guarantee exactly-once business behavior. A repeated request that creates an order, changes inventory, or charges a card needs application idempotency. Transaction callback APIs can retry a transaction for specific error labels; core APIs may require explicit retry handling. Know which API and driver version your service uses.

## A decision process

1. What failure or data loss must be tolerated?
2. What is the cost of stale data?
3. How much acknowledgment is required for writes?
4. Is an operation safe to repeat?
5. Do retry and timeout values fit the latency target?
6. How will failover and unknown outcomes be tested and observed?

## Example

For a transfer, keep the debit and credit in one short transaction and check that both updates matched. For a separately operated payment processor, use an idempotency key and reconciliation; it cannot join the database transaction.

## Exercises

1. Choose read preference and concern separately for a product list and a checkout confirmation.
2. Define the behavior when a write times out but may have succeeded.
3. Explain why retryable write support does not make a payment API exactly once.

## Common mistakes

- Treating read preference and read concern as the same setting.
- Assuming `w: "majority"` means every replica has persisted the data to disk.
- Blindly retrying after a timeout.
- Putting external calls inside a transaction callback.
- Choosing consistency settings without a business failure model.

## Quiz and answer key

1. **At what level is the base write atomic?** One document.
2. **When is a transaction appropriate?** When multiple database writes must commit or abort together to preserve an invariant.
3. **What does read concern control?** The visibility/consistency level of returned data.
4. **Why keep a transaction short?** To reduce resource retention, contention, and timeout/cache failure risk; keep external calls outside it.
5. **Applied task: define an order boundary.** Include only database writes that must preserve one invariant, verify each result, and handle payment separately with idempotency and reconciliation.
6. **What does write concern control?** The requested write acknowledgment level.
7. **What does read preference control?** Which topology member may serve a read.
8. **What can a secondary read risk?** Stale data due to replication lag.
9. **What does `w: "majority"` mean?** A request for majority acknowledgment under the replica-set topology/settings.
10. **How should an unknown payment outcome be handled?** Look up durable request state using its idempotency key and reconcile before deciding on another action.

## Further reading

- [Transactions](https://www.mongodb.com/docs/manual/core/transactions/)
- [Read Concern](https://www.mongodb.com/docs/manual/reference/read-concern/)
- [Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)
- [Read Preference](https://www.mongodb.com/docs/manual/core/read-preference/)
- [Retryable Reads](https://www.mongodb.com/docs/manual/core/retryable-reads/)
- [Retryable Writes](https://www.mongodb.com/docs/manual/core/retryable-writes/)
- [Persian transaction lesson — Urhoba](https://www.urhoba.net/fa/post/mongodb-acid)
- [Curated reference library: durability and concerns](../../reference-library.md#reliability-transactions)

---
Sources reviewed: 2026-11-11. Confirm topology and version-specific semantics in the official manual.
