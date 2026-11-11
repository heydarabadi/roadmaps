# Queues, Streams, and Backpressure

[فارسی](../../../../fa/system-design/06-async-and-messaging/20-queues-streams-backpressure/README.md)

## Learning goals

- Distinguish task queues, pub/sub, and log-based streams.
- Explain at-most-once and at-least-once delivery behavior.
- Understand partitioned ordering and consumer groups.
- Use backpressure and capacity limits to keep a backlog bounded.

## Central idea

Asynchronous messaging separates producers from consumers. Without backpressure, the queue becomes an unbounded store of delayed work.

## Concept map

Produce → durable broker → partition/queue → consumer and acknowledgement → lag, retry, and pressure control.

## Detailed lesson

### What separation does a queue provide?

A producer durably submits work; a consumer takes it when capacity is available. The producer need not know which worker instance will execute it. A queue absorbs short bursts and separates timing between producer and consumer, but does not make total work disappear.

If arrivals permanently exceed processing capacity, backlog grows until storage fills or the work expires. A queue smooths a burst; it cannot correct a permanent throughput deficit.

### Task queue, pub/sub, and stream

A task queue gives a unit of work to a worker and typically removes it after acknowledgement. In pub/sub, a message is delivered to multiple subscriptions; each subscription tracks its own progress. A log-based stream keeps append-only records for a retention period, and each consumer reads using its own offset, enabling replay or independent consumers.

Kafka is a log-based stream platform. SQS and RabbitMQ provide queue/messaging semantics with product-specific details. Product names alone do not define delivery; inspect retention, partitioning, acknowledgement, and ordering behavior.

### Delivery semantics

- **At-most-once:** a message is not processed twice by the broker, but it may be lost.
- **At-least-once:** redelivery reduces loss but duplicates are possible.
- **Exactly-once:** usually applies within a bounded broker or transaction boundary. It does not automatically guarantee exactly-once effects across a database, email provider, payment service, and other external systems.

A consumer should persist its effect before acknowledging the message. If it crashes after the commit but before the acknowledgement, redelivery is expected and the effect must be safe to repeat.

### Ordering and partitions

Ordering is commonly guaranteed within one queue or partition, not across an entire cluster. Putting every message into one partition simplifies order but limits throughput.

A key such as order_id can keep events for one order together. Hot keys can saturate one partition. In a consumer group, a partition is generally assigned to one consumer at a time; adding more consumers than useful partitions may not add parallel work.

### Backpressure and capacity

Backpressure aligns producer rate with consumer capacity. Options include a bounded queue with controlled rejection, credits/flow control, slowing producers, rate limiting, pausing partitions, or shedding low-priority work.

An in-memory queue needs a size limit and full-queue behavior. A durable broker still needs quotas, retention, disk headroom, and admission control.

### Retry, dead letter, and poison messages

Retry a transient failure with delay and a maximum count; immediate retry loops can amplify an outage.

A poison message repeatedly fails and may block other messages in its partition. After a defined limit, move it to a dead-letter queue (DLQ), preserve enough context, assign an owner, and define safe replay. A DLQ is not a trash bin; messages may contain sensitive or business-critical data.

### What to monitor

Queue depth is only a count. Oldest-message age describes how delayed work is. Track publish and consume rates, lag per consumer group, retry ratio, DLQ volume, processing time, and disk or memory headroom.

Set thresholds from the business deadline. An email queue may tolerate minutes; an inventory reservation may expire much sooner.

## Worked example

A sale absorbs a traffic burst in a queue. If backlog age exceeds the price or reservation validity window, the worker should revalidate the order before processing.

## Flow-control example

~~~text
If a bounded queue is full:
- reject new low-priority work with a clear retry signal, or
- shed noncritical work while preserving core order processing.
Never accept unbounded work that cannot meet its deadline.
~~~

## Public engineering case study

[Uber Cherami](https://www.uber.com/us/en/blog/cherami-message-queue-system/) describes a durable message queue and large-scale consumer patterns. Use it to study reliability and throughput decisions in the context of Uber’s workload.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Task queue | Work can be handed to one worker and removed after success | Redelivery and acknowledgement order matter |
| Pub/sub | Several independent systems react to one event | Each subscription needs retention and recovery |
| Log stream | Replay and independent consumer offsets are useful | Retention, partitioning, and lag become operational duties |
| Bounded queue with backpressure | Capacity must stay within a safe limit | Rejection must be visible and handled by producers |

## Common pitfalls

- Claiming system-wide exactly-once delivery.
- Allowing an unbounded queue.
- Assuming global ordering across partitions.
- Adding more consumers than available parallel partitions.
- Retrying poison messages forever.
- Scaling consumers beyond database or provider capacity.

## Short quiz

1. How does a queue differ from a retained stream?
2. Why does at-least-once delivery require idempotent consumers?
3. Which signal reveals how long users have waited for queued work?
4. What is a poison message?

### Answer key

1. A queue commonly removes acknowledged work; a stream retains records and consumers track offsets for replay.
2. Redelivery can repeat a message after a crash or lost acknowledgement.
3. Oldest-message age, alongside queue lag and completion rate.
4. A message that repeatedly fails processing and may block a queue or partition.

## Exercise

Design the message path for a sale order. Choose queue or stream, partition key, delivery guarantee, acknowledgement point, retry and DLQ policy, and backpressure behavior. Define how you monitor a backlog that threatens the reservation deadline.

## Summary

Queues and streams decouple timing and absorb bursts, but every delivery model has failure and retention rules. Bound the backlog, track its age, and make duplicate processing safe.

## Further reading

- [Apache Kafka Design](https://kafka.apache.org/40/design/design/) — delivery, ordering, replication, and consumer behavior.
- [RabbitMQ Reliability guide](https://www.rabbitmq.com/docs/reliability) — acknowledgements, publisher confirms, and recovery.
- [Amazon SQS best practices](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-best-practices.html) — queue and consumer patterns.
- [Reactive Streams specification](https://www.reactive-streams.org/) — asynchronous processing with non-blocking backpressure.
- [Azure Queue-Based Load Leveling](https://learn.microsoft.com/en-us/azure/architecture/patterns/queue-based-load-leveling) — producer/consumer rate separation.
- [Uber Cherami](https://www.uber.com/us/en/blog/cherami-message-queue-system/) — queue engineering case study.
