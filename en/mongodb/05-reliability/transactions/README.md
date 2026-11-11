# Multi-Document Transactions

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/05-reliability/transactions/README.md).

> **Learning goal:** Use a transaction when a business invariant spans documents and partial completion is unacceptable.

## Start from the invariant

A single-document write is atomic. If an order's status and update time live in one document, they can usually be changed together without a multi-document transaction. Consider a transaction only when one business operation changes several documents and a partially applied state would violate a defined invariant.

For example, a transfer may require the source debit and destination credit to commit together. A transaction groups database operations into a commit or abort boundary. It adds coordination, latency, and resource use, so first ask whether the data model can preserve the invariant in one document.

## Transfer example with a Node.js driver

For a readable example, store a single-currency balance as integer minor units and ensure every balance plus update stays inside JavaScript's safe-integer range. The application must validate both the debit and the recipient's resulting balance, and the data model must prevent overflow. If those limits do not fit, use a precise BSON numeric representation and a decimal-aware library; do not convert money to approximate floating-point arithmetic.

~~~javascript
if (!Number.isSafeInteger(amountMinor) || amountMinor <= 0) {
  throw new Error("amount must be a positive safe integer")
}

const session = client.startSession()
try {
  await session.withTransaction(async () => {
    const debit = await accounts.updateOne(
      { _id: fromId, balanceMinor: { $gte: amountMinor } },
      { $inc: { balanceMinor: -amountMinor } },
      { session }
    )
    if (debit.matchedCount !== 1) {
      throw new Error("source account missing or balance too low")
    }

    const credit = await accounts.updateOne(
      { _id: toId },
      { $inc: { balanceMinor: amountMinor } },
      { session }
    )
    if (credit.matchedCount !== 1) throw new Error("destination account missing")
  })
} finally {
  await session.endSession()
}
~~~

Assume `client` and `accounts` were created earlier. If either update does not match exactly one account, throwing an error aborts the transaction. The driver callback API handles some transient transaction and unknown-commit retry cases, so its callback may run again. Keep database work idempotent and use a unique transfer/request ID to protect the business operation from duplicate client requests.

## External calls are outside the transaction

A MongoDB transaction cannot roll back a payment gateway, email, or another HTTP service. Do not call these systems inside a retryable transaction callback. An **outbox** records the event in the same database boundary as the state change; a worker publishes it afterward. Use an idempotency key and reconciliation for external payment results.

## Keep transactions short

Long transactions retain resources, can increase contention, and may fail due to time or cache limits. Include only the writes needed for the invariant. Avoid user interaction, file transfer, network calls, and long computations inside the transaction.

## When not to use one

If a slightly delayed, eventually consistent update is acceptable, a state machine, reservation, outbox, or compensating workflow may be simpler. Define its failure states explicitly. Transactions should not be used to hide an unclear data model.

## Exercises

1. Identify which database writes during checkout must commit together.
2. Separate payment API calls and email from those writes.
3. Define what should happen if the client times out after an unknown commit result.
4. Propose a unique idempotency key for a transfer.

## Common mistakes

- Making a transaction long-running.
- Putting an HTTP call or external side effect inside the callback.
- Assuming an external service participates in MongoDB rollback.
- Ignoring a zero `matchedCount` and committing the other half of a transfer.
- Using a transaction instead of designing idempotency and recovery.

## Quiz and answer key

1. **What does a transaction provide?** An all-or-nothing boundary for grouped database operations.
2. **When is one a candidate?** When an invariant spans multiple writes and partial completion is unacceptable.
3. **Can the callback run more than once?** Yes, driver retry behavior can rerun it for certain errors.
4. **Why avoid long transactions?** They hold resources, increase contention, and can hit time or cache limits.
5. **Applied task: separate checkout effects.** Keep required database writes together; call payment externally with an idempotency key and publish events through an outbox worker.
6. **What is the atomic baseline in MongoDB?** A single-document write.
7. **What must happen if the source account update matches zero documents?** Throw an error so the transaction aborts.
8. **Does database rollback cancel an email or gateway call?** No. It is outside the database transaction.
9. **What does an outbox do?** It commits an event record with state changes, then allows a worker to publish it reliably afterward.
10. **Why use a transfer ID?** It lets the system detect a repeated request and avoid duplicate business effects.

## Further reading

- [Transactions](https://www.mongodb.com/docs/manual/core/transactions/)
- [Transactions in Applications](https://www.mongodb.com/docs/manual/core/transactions-in-applications/)
- [Transaction Production Considerations](https://www.mongodb.com/docs/manual/core/transactions-production-consideration/)
- [Transaction Operations](https://www.mongodb.com/docs/manual/core/transactions-operations/)
- [Retryable Writes](https://www.mongodb.com/docs/manual/core/retryable-writes/)
- [Persian ACID transaction lesson — Urhoba](https://www.urhoba.net/fa/post/mongodb-acid)
- [Curated reference library: transactions](../../reference-library.md#reliability-transactions)

---
Sources reviewed: 2026-11-11. Driver callback behavior and transaction limits vary by version.
