# Change Streams and Event-Driven Systems

> **Persian edition:** [Read this lesson in Persian](../../../07-ecosystem/change-streams/readme.md).

> **Learning goal:** Consume database changes with durable checkpoints, idempotent handlers, and a resynchronization plan.

## What a Change Stream provides

A Change Stream is a supported API for watching changes at collection, database, or deployment scope without directly tailing the oplog. It requires a supported replica-set or sharded deployment. Filter events and project only the fields needed by the consumer.

Events commonly include an operation type, document key, namespace, and—depending on the operation and options—updated fields or a full document. `fullDocument: "updateLookup"` looks up the current document after an update. It is not necessarily a historical snapshot of the exact document at the moment of the change.

## Resume tokens and checkpoints

Each event contains a resume token that can be used to continue a stream. Make the downstream effect durable, then persist the token. If the checkpoint is saved first and the side effect fails, the consumer may skip the event. If the side effect succeeds but the checkpoint save fails, the event may be delivered again. Therefore, make the handler idempotent.

~~~javascript
const stream = db.orders.watch(
  [{ $match: { operationType: { $in: ["insert", "update", "replace"] } }],
  { fullDocument: "updateLookup" }
)

for await (const change of stream) {
  // Persist an idempotent downstream update, then store change._id as the checkpoint.
}
~~~

The checkpoint must live in durable storage. Keep side effects replay-safe; use an event identity or document key to prevent duplicate notifications or data corruption.

## Recovery and oplog window

Resuming depends on the required oplog history still being available. If the consumer is offline longer than the retained window or the token is no longer valid, a resume attempt can fail. Run a snapshot/reconciliation rebuild and then reopen the stream from a valid point. Do not treat an old token as a complete backup.

## Design checklist

- Define event filtering and delete/update semantics.
- Choose a durable checkpoint location.
- Make the sink idempotent and tolerate duplicates.
- Monitor lag, reconnect loops, failures, and checkpoint age.
- Backpressure the consumer when the downstream system is overloaded.
- Document resync/rebuild steps for expired tokens or long outages.

## Published customer story: Ada

MongoDB's Ada story says the company adopted Change Streams to keep a data lake in sync and to support real-time processing for bots and analytics. The architectural lesson is to treat the stream as a change feed from the source of truth and design checkpoints, duplicate handling, and backfill. This is a MongoDB-published customer account, not an independent product comparison. [Ada story](https://www.mongodb.com/solutions/customer-case-studies/ada)

## Common mistakes

- Saving a checkpoint before the durable downstream effect.
- Assuming `updateLookup` gives a historical image.
- Having no recovery if the token falls outside the oplog window.
- Treating Change Streams as a complete audit system.
- Ignoring duplicate delivery and consumer backpressure.

## Exercises

1. Design an idempotent handler that refreshes a product cache.
2. Describe what to do after a one-day consumer outage.
3. Specify whether deletes remove the downstream record or create a tombstone.

## Quiz and answer key

1. **What is a Change Stream?** A supported API for observing database changes.
2. **What does it abstract away from the application?** Direct oplog tailing.
3. **When do you save the resume token?** After the downstream effect is durable.
4. **Why avoid saving the checkpoint before a successful side effect?** Failure afterward can skip the event; checkpoint after the durable write and make the handler idempotent.
5. **Applied task: refresh a cache safely.** Upsert or delete by document key, deduplicate event processing, save the token after success, and resync if the token expires.
6. **What does `updateLookup` provide?** The current full document when looked up, not necessarily a historical post-image.
7. **Why can duplicate events occur?** The downstream write and checkpoint update usually are not one atomic transaction.
8. **What limits resume?** The token must refer to oplog history that is still retained.
9. **What should happen after retention expires?** Reconcile or rebuild from a source snapshot and continue from a valid position.
10. **Is a Change Stream a full audit log?** No. Use a suitable audit/event record for complete historical requirements.

## Further reading

- [Change Streams](https://www.mongodb.com/docs/manual/changeStreams/)
- [Resume a Change Stream](https://www.mongodb.com/docs/manual/changeStreams/#resume-a-change-stream)
- [Change Stream Event Reference](https://www.mongodb.com/docs/manual/reference/change-events/)
- [Kafka Connector Change Stream Source](https://www.mongodb.com/docs/kafka-connector/current/source-connector/fundamentals/change-streams/)
- [Change Streams introduction — MongoDB](https://www.mongodb.com/company/blog/technical/an-introduction-to-change-streams)
- [Ada customer story](https://www.mongodb.com/solutions/customer-case-studies/ada)
- [Persian Change Streams lesson — Urhoba](https://www.urhoba.net/fa/post/change-streams-mongodb)
- [Curated reference library: streams and connectors](../../reference-library.md#ecosystem-streams)

---
Sources reviewed: 2026-11-11. Change Stream behavior and options are version-dependent.
