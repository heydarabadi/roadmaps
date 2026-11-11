# Cloud Messaging Patterns

[فارسی](../../../../fa/system-design/09-cloud-design-patterns/27-cloud-messaging-patterns/README.md)

## Learning goals

- Match common cloud messaging patterns to throughput, ordering, and workflow needs.
- Define the delivery and recovery boundary for each pattern.
- Design a message contract that supports tracing, deduplication, and replay.

## Central idea

Messaging patterns control work pressure, ordering, and workflow behavior. Make delivery and compensation boundaries explicit.

## Topic coverage

This chapter groups Sequential Convoy, Scheduler-Agent-Supervisor, Queue-Based Load Leveling, Publisher/Subscriber, Priority Queue, Pipes and Filters, Competing Consumers, Choreography, Claim Check, and Asynchronous Request-Reply.

### Choose from workload behavior

Before choosing a broker, decide whether a message represents a task or a fact, how many consumers need it, whether replay is required, where ordering matters, payload size, and completion deadline.

Then inspect the broker semantics: durability, retention, acknowledgement, redelivery, partitioning, order, dead-letter handling, transactions, and security.

### Patterns in combination

- **Queue-Based Load Leveling** absorbs a burst up to an explicit limit; monitor backlog age.
- **Publisher/Subscriber** distributes one event to independent subscriptions; schema and replay matter.
- **Competing Consumers** process queue work in parallel; global order is usually lost.
- **Priority Queue** schedules urgent work first; aging or quotas can reduce starvation.
- **Pipes and Filters** divides processing into stages; each stage needs a versioned contract and retry rules.
- **Sequential Convoy** preserves per-key order; monitor hot partitions and poison messages.
- **Claim Check** stores large payloads outside the broker and sends a secure, versioned reference.
- **Asynchronous Request-Reply** links a delayed response to its original request with a correlation ID.
- **Choreography** coordinates services through events; tracing and compensation need separate design.
- **Scheduler-Agent-Supervisor** manages long-running work through scheduling, execution, and recovery; use checkpoints and leases.

### Delivery, acknowledgement, and real guarantees

At-least-once delivery means a message may arrive again. The consumer should persist the effect before acknowledging and be idempotent if it crashes between commit and acknowledgement.

At-most-once may lose a message during failure. Claim exactly-once only within a defined boundary: a broker transaction does not make an external database or provider atomic. An outbox on the producer and an inbox/deduplication mechanism on the consumer make local boundaries more reliable.

### Ordering and concurrency

Ordering per partition or key is usually achievable; global ordering is often a throughput limit. If every order shares one key, parallelism disappears. If every message has a unique key, ordering for one order disappears. Choose a key that preserves domain correctness and distributes load.

A slow consumer can block its partition. Batching and parallelism must not silently reorder effects that need ordering.

### Retry and poison-message handling

Retries need a delay and maximum count. Transient failures can retry; permanent or malformed messages should move to a dead-letter queue (DLQ).

The DLQ needs an owner, alert, retention, inspection process, and replay/skip decision. Replaying a message with a new consumer version may produce a different result than before; make replay controlled and idempotent.

### Order-workflow example

OrderCreated may use pub/sub; shipping tasks may use competing consumers; invoice bytes can use claim check; per-order status changes can use an order ID partition key; sale bursts can use queue leveling; a long-running confirmation can use asynchronous request-reply.

Each message should carry event ID, correlation ID, schema version, and only the minimum required data. Do not put secrets, full card numbers, or unnecessary personal information into a broadly accessible broker.

For pattern-by-pattern explanations and quizzes, see [Messaging Patterns](../../06-async-and-messaging/21-messaging-patterns/README.md).

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Per-key ordering | Events for one entity must be processed sequentially | Hot key and poison-message blocking |
| Queue leveling | Producers have bursts and consumers work at a controlled pace | Queue age can exceed business deadlines |
| Choreography | Reactions are independent and event-driven | Workflow state and compensation are hard to see |
| Orchestration | A multi-step workflow needs central progress and recovery | Coordinator state and availability need design |

## Common pitfalls

- Acknowledging work before its effect is durable.
- A DLQ without an owner or replay plan.
- Oversized payloads and unnecessary personal data.
- Expecting order across partitions.
- Retrying forever without delay or limit.
- Claiming broker-level exactly-once as end-to-end business correctness.

## Short quiz

1. What changes when competing consumers are added?
2. When does a DLQ help?
3. What does a correlation ID connect?
4. Why is ordering often scoped to a partition key?

### Answer key

1. Parallelism rises, but global order is not preserved automatically.
2. It isolates repeatedly failing poison messages after bounded attempts so they can be investigated.
3. The asynchronous request and its later response or related events.
4. A global order serializes all work; per-key order preserves entity semantics while other keys run in parallel.

## Exercise

Design an asynchronous refund workflow. Choose patterns for dispatch, ordering, payload size, workflow tracking, retries, compensation, and notification. Identify how an operator sees a refund stuck halfway through.

## Summary

Messaging patterns define how systems handle pressure, ordering, and long-running workflows. Scope guarantees carefully and build recovery, replay, and observability into the message path.

## Further reading

- [Azure Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/) — pattern catalog.
- [Azure Sequential Convoy](https://learn.microsoft.com/en-us/azure/architecture/patterns/sequential-convoy) — per-key ordered processing.
- [Azure Claim Check](https://learn.microsoft.com/en-us/azure/architecture/patterns/claim-check) — large payload references.
- [Azure Scheduler-Agent-Supervisor](https://learn.microsoft.com/en-us/azure/architecture/patterns/scheduler-agent-supervisor) — scheduling and long-running work.
- [Apache Kafka Design](https://kafka.apache.org/40/design/design/) — partitions, replication, and consumer behavior.
- [Amazon SQS best practices](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-best-practices.html) — queue usage and consumer design.
