# Messaging, Queues, and Event Streams

## Learning goals

- Distinguish command queues, publish/subscribe messaging, and durable event logs.
- Design for acknowledgements, retries, ordering, duplicates, and dead-letter handling.
- Use asynchronous communication to reduce temporal coupling without hiding failure.

## Core idea

Messaging lets producers and consumers communicate without requiring both to be ready at the same instant. A work queue distributes tasks among workers; publish/subscribe sends an event to interested subscribers; a durable event log retains an ordered sequence for replay. Product names vary, so reason about delivery, ordering, persistence, retention, and consumer ownership.

## Delivery and processing semantics

At-most-once may lose work; at-least-once may deliver duplicates; “exactly once” needs a carefully bounded definition and cooperation from the source, processor, and destination. Most business handlers should be idempotent: record a stable message ID or business key and ensure repeated handling does not repeat the effect. Acknowledge only after durable success.

Retries help transient faults, but immediate retry loops amplify load. Use bounded attempts, exponential backoff with jitter, a dead-letter or quarantine path, and an operator-visible replay procedure. Poison messages should not block an entire partition indefinitely. Preserve ordering only where the business requires it; global ordering reduces parallelism and is rarely necessary.

An event states that something already happened, such as OrderPlaced. A command asks a specific owner to do something, such as ReserveInventory. Events should be facts, versioned and documented; commands should name intent and have one clear owner. Avoid publishing internal database rows as a public contract.

## Transactional outbox

If a database update and message publish must agree, writing the row and then publishing creates a dual-write gap. The process can crash between the two. The outbox pattern writes both the business change and an outbox record in one local database transaction; a relay publishes the record and marks it delivered. Consumers deduplicate because delivery can repeat.

## Worked example: order fulfillment

Checkout stores an order and OrderPlaced outbox event atomically. A relay publishes it. Inventory and fulfillment consumers handle it independently, save processed event IDs with their state changes, and emit outcomes. If fulfillment is unavailable, the queue retains work; an alert fires on age/lag, and operations can replay after fixing the cause.

## Self-check quiz

1. Why can at-least-once delivery be safer than at-most-once? Work is retried rather than silently lost, provided consumers tolerate duplicates.
2. Why use an outbox? It closes the database-to-broker dual-write gap for local state and publication intent.
3. What is a poison message? A message that repeatedly fails because of malformed content or a persistent processing problem.
4. Why is global ordering expensive? It constrains parallelism and can make one slow item block unrelated work.
5. What does consumer lag indicate? How far processing is behind the available stream or queue, though it does not alone explain the cause.

## Exercise

Design a message flow from order creation to inventory reservation. Cover transaction boundary, duplicate handling, retry schedule, dead-letter review, and customer-visible status.

### Sample answer

Commit the order and outbox event in one transaction. Publish with a stable event ID and order ID. Inventory handles each event idempotently, atomically recording its event ID and reservation result. Retry transient faults with capped exponential backoff; route persistent failures to a monitored quarantine queue. The order remains pending until a reservation result event arrives, and the customer sees that state rather than a false success.

## Further reading

- First-hand case: [LinkedIn's Kafka engineering at scale](https://www.linkedin.com/blog/engineering/open-source/apache-kafka-trillion-messages) details partitions, failure handling, and operations in a production event platform.
- English: [Apache Kafka documentation](https://kafka.apache.org/documentation/), [RabbitMQ acknowledgements and confirms](https://www.rabbitmq.com/docs/confirms), [CloudEvents specification](https://cloudevents.io/), [AWS transactional outbox pattern](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html), [Martin Fowler: Transactional Outbox](https://martinfowler.com/articles/patterns-of-distributed-systems/transactional-outbox.html), [Google SRE: Handling overload](https://sre.google/sre-book/handling-overload/)
- Persian: [Persian Event-Driven Architecture notes](https://github.com/gloonch/eventdrivenfarsi), [DNTips](https://www.dntips.ir/)
