# CQRS, Event Sourcing, and Eventual Consistency

## Learning goals

- Distinguish CQRS, Event Sourcing, and eventual consistency.
- Design safe publication, consumer idempotency, and projection rebuilds.
- Decide when their benefits justify operational and modeling costs.

## Core idea

CQRS separates the model or path that changes data from the one that reads it. Event Sourcing stores durable change events as the source of truth. Eventual consistency means two views or services may briefly disagree. These ideas can work together, but they do not have to.

## Three related concepts

- **CQS:** an operation either queries state or changes it.
- **CQRS:** separates read and write models or paths. They may still share an application and database; CQRS does not require microservices.
- **Event Sourcing:** domain events are the source of truth and current state is built by replaying them. This requires schema evolution, snapshots, privacy controls, and rebuild procedures.
- **Eventual consistency:** a consumer reaches a fresh view after an update within an acceptable time; this delay must be acceptable to users and operations.

## Design the write and read cycle step by step

1. **Define the command:** What is being requested, and which identity and data are required? Example: PlaceOrder.
2. **Check invariants at the write authority:** inventory, order ownership, and pricing rules must be enforced at the commit point.
3. **Persist the result:** if an event must be published, store it atomically with the local change. An outbox prevents a gap between commit and publish.
4. **Make consumers idempotent:** record message ID or version so redelivery has no second effect.
5. **Update the projection:** store only what the read query needs; ensure the projection can be rebuilt and its lag measured.
6. **Define the user experience:** What state and freshness timestamp appear before the view catches up? Does the user retry or refresh?

An Event Sourcing event is an immutable domain fact. A general messaging event may only notify one consumer. Name events in the past tense, such as OrderPlaced, rather than as commands like ProcessOrder. For stored event schema changes, use version-aware readers, upcasters, or a compatible migration.

## Where a Saga fits

When an operation is not one local transaction, a multi-step workflow may be a Saga. In orchestration, a coordinator chooses each next step; in choreography, services react to events. A successful payment and failed inventory reservation cannot be rolled back by one database transaction. A void or refund may compensate for an earlier step, but compensation does not necessarily erase its real-world effect and must be audited.

## Worked example: orders and sales reporting

Order creation needs a transactional write model to preserve order and inventory rules. Broad reporting reads are faster from a denormalized view, updated by an event handler. This view may lag by seconds, so the administration screen should show freshness. Using the report to decide whether payment succeeded would be dangerous if its lag is not acceptable.

~~~text
Command -> validate -> write model + outbox -> event
                                           -> projection -> read model
~~~

## Useful operational patterns

- **Transactional outbox:** store the local change and outgoing message in one transaction; a relay publishes it.
- **Idempotent consumer:** repeated delivery must not create a duplicate or corrupt result.
- **Projection rebuild:** recreate a read model from events or another authoritative source.
- **Saga:** manage a multi-service workflow with explicit steps and compensations; do not assume a distributed rollback.

| Choice | Benefit | Cost |
| --- | --- | --- |
| Limited CQRS | Optimizes reads for their access pattern | Two models and synchronization |
| Event Sourcing | History, replay, and audit of changes | Schema evolution, privacy, and harder queries |
| Eventual consistency | Fewer synchronous dependencies | Delay, duplicates, and more complex user experience |

## Common pitfalls

- Assuming CQRS requires separate databases or microservices.
- Adopting Event Sourcing without a domain need for replayable history.
- Assuming an outbox alone guarantees exactly-once delivery.
- Hiding projection lag from users and operators.

## Self-check quiz

1. **What does CQRS separate?** The command and query models or paths, not necessarily databases, services, or teams.
2. **When is Event Sourcing justified?** When domain history and state reconstruction have clear value and the team can operate versioning and replay.
3. **Why does an outbox not guarantee exactly-once delivery end to end?** Relay or consumer retries can still duplicate delivery; idempotency and deduplication are also needed.
4. **How can eventual consistency be understandable to users?** Show a pending state and freshness, allow refresh or status tracking, and define an acceptable convergence time.
5. **What is the role of a Saga compensation?** It addresses the business effect of a completed step when a later step fails; it is not necessarily a true rollback.

## Exercise

For order creation, identify the local commit, outbox message, invoice consumer, and duplicate-message behavior. Give one metric and recovery method for each.

### Sample answer

Commit the order and outbox row in one local transaction; measure commit errors and oldest outbox age. The relay publishes and measures lag and retries; recover with a checkpoint/lease and safe republishing. The invoice consumer records event ID and invoice status in one transaction, making duplicates harmless. A failed consumer uses bounded retries and then an owned DLQ with a replay policy. Preserve one correlation ID end to end.

## Further reading

- Persian: [Persian Event-Driven Architecture notes](https://github.com/gloonch/eventdrivenfarsi), [Persian DDD guide](https://github.com/hheydarian/Understanding-Domain-Driven-Design)
- English: [Martin Fowler: CQRS](https://martinfowler.com/bliki/CQRS.html), [Martin Fowler: Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html), [Microsoft CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs), [AWS transactional outbox](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html), [Microsoft DDD/CQRS microservices guide](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/)
