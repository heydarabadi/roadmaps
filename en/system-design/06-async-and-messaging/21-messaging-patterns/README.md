# Messaging Patterns

[فارسی](../../../../fa/system-design/06-async-and-messaging/21-messaging-patterns/README.md)

## Learning goals

- Match common messaging patterns to ordering, throughput, and workflow needs.
- Explain their operational failure modes.
- Keep messages small, versioned, and traceable.
- Choose between choreography and explicit orchestration.

## Central idea

A messaging pattern must define ordering, flow control, durability, and workflow ownership. Keep payloads small and carry correlation information.

## Concept map

Pattern need → message contract → routing/partition → processing and acknowledgement → error, replay, and recovery.

## Detailed lesson: patterns and when to use them

### Publisher/subscriber

A publisher emits an event once; independent subscriptions can react to it. OrderPaid might trigger invoice creation, loyalty points, and a notification. The producer need not know where each subscriber runs, but event schema and meaning must remain stable.

A new subscriber may need historical events. Retention and backfill should be designed rather than assumed.

### Competing consumers

Several workers receive work from a shared queue to process in parallel. Keep workers stateless or store their state externally, and make effects safe under duplicate delivery. Global ordering is usually lost. If each order must remain ordered, partition by order key. Unlimited workers can overload a downstream dependency.

### Queue-based load leveling and priority queues

Load leveling buffers bursts between producers and consumers. Set a backlog limit and deadline; rejecting work early can be better than accepting work that can never finish in time.

A priority queue handles urgent work first. If high-priority work arrives continuously, low-priority messages may starve. Aging, quotas, and separate workload classes can reduce starvation.

### Pipes and filters

A larger job becomes stages such as parse, validate, enrich, and persist. Each filter has a defined input, output, and error contract and can sometimes scale independently.

The trade-offs include serialization, multiple queues, tracing, and possible duplicate effects between stages. Version each message and carry a correlation ID through the pipeline.

### Sequential convoy

When order matters for one entity, process messages for that key sequentially while different keys run in parallel. For example, an order should be created before later status changes are applied.

Avoid imposing global ordering if per-key ordering is sufficient. A poison message at the front of a convoy can block later messages in that group; define dead-letter and repair behavior.

### Claim check

For a large file, store the payload in object storage and put a small reference in the message. The object must be available before publishing the reference. Define lifecycle, authorization, and object versioning.

A signed URL should not leak into broadly accessible logs or queues. Consumers need sufficient retention to retrieve the object, and cleanup must account for delayed messages.

### Asynchronous request-reply

A client submits a request with a correlation ID and gets a tracking identifier quickly. The later response may arrive on a reply queue, callback, or status store.

A client timeout does not cancel the job. Define deduplication, expiry, ownership, and response retention. This works for longer tasks; a simple synchronous REST call is easier when the result is immediate.

### Choreography

Services react to events and publish subsequent events. This reduces direct coupling and makes it easy to add independent consumers. But the full workflow becomes distributed across services. Correlation, audit, timeout, compensation, and event-loop detection become harder.

For long-running workflows with many conditions and compensations, an orchestrator or saga coordinator may make state and progress clearer.

### Scheduler-agent-supervisor

A scheduler selects time-based work, an agent executes it, and a supervisor tracks status, timeout, retries, and results. Use leases, checkpoints, and idempotency so a replacement worker can resume after failure.

A scheduler trigger alone does not guarantee successful completion; observe the execution and outcome.

## Worked example

A refund message carries an order ID and version, not a full customer record. The worker is idempotent, and the refund result is emitted as a separate event.

## Public engineering case study

[Uber Cherami](https://www.uber.com/us/en/blog/cherami-message-queue-system/) can be read for queue and consumer behavior at scale. The lesson is to identify the delivery and ordering needs before selecting a broker.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Choreography | Events trigger independent reactions with little central coordination | The end-to-end workflow is harder to inspect |
| Orchestration | A workflow has explicit steps, deadlines, and compensations | Coordinator availability and workflow state need design |
| Per-key sequential processing | One entity’s changes must be ordered | A hot key or poison message blocks that group |
| Claim check | Payload exceeds broker size or should be stored separately | Reference and object have separate availability lifecycles |

## Common pitfalls

- Acknowledging before the business effect is durable.
- Forgetting dead-letter ownership and replay.
- Putting large or sensitive data in broadly readable messages.
- Allowing starvation in a priority queue.
- Losing correlation IDs across the workflow.
- Assuming choreography is observable without an event map.

## Short quiz

1. What does claim check move out of the broker?
2. How can an order’s events retain ordering while other orders run in parallel?
3. What makes choreography difficult to debug?
4. Why does a scheduler need a supervisor?

### Answer key

1. The large payload; the message carries a reference to an external object.
2. Use a per-order partition or session and process that group sequentially while other keys run concurrently.
3. Workflow state and causality are distributed across services and events.
4. A trigger does not show whether work started, timed out, retried, or completed.

## Exercise

Design the messaging workflow for a store refund. Choose the pattern for dispatch, ordering, payload size, workflow tracking, retries, compensation, and result notification. Identify which dashboard can show a refund stuck halfway through.

## Summary

Messaging patterns encode how work is distributed and coordinated. Select only the ordering, priority, and workflow guarantees the business needs, and make failure, replay, and observability explicit.

## Further reading

- [Azure Publisher-Subscriber pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/publisher-subscriber) — event fan-out and subscription behavior.
- [Azure Sequential Convoy pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/sequential-convoy) — ordering within groups while scaling across groups.
- [Azure Claim-Check pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/claim-check) — large payload references.
- [Azure Scheduler-Agent-Supervisor pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/scheduler-agent-supervisor) — monitoring and managing long-running actions.
- [Azure Cloud Design Patterns catalog](https://learn.microsoft.com/en-us/azure/architecture/patterns/) — additional messaging patterns.
- [Uber Cherami](https://www.uber.com/us/en/blog/cherami-message-queue-system/) — published queue-engineering experience.
