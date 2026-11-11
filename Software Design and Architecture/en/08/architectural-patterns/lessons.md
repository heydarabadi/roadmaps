<div dir="ltr" align="left">

# Full lesson: Architectural patterns

> **Language:** [Persian edition](../../../08/architectural-patterns/lessons.md)

## Style, pattern, and implementation

Architecture vocabulary is not perfectly consistent across books and teams. In this course, a **style** describes broad constraints on a system's components and connections. A **pattern** is a reusable structure for a recurring problem in a stated context. A pattern may shape one component, one service, or the whole system. A **technology** is a concrete implementation choice.

One application can use several patterns at once. A simple bounded context may use CRUD and a transaction script; a context with difficult rules may need a richer domain model. CQRS can be implemented within one service and does not require microservices or two physical databases. Choose each pattern because it addresses a real pressure, then account for the new concepts and failure modes it introduces.

## 1. Domain-Driven Design (DDD)

Domain-Driven Design is an approach to understanding a complex business domain and reflecting that understanding in software boundaries and models. It is useful when rules, language, and interactions are complex enough that a generic CRUD model hides important meaning. DDD starts with collaboration between domain experts and developers; it is not a requirement to create many classes.

### Strategic design: boundaries and relationships

A **bounded context** is a boundary inside which a model and its language have a consistent meaning. A `Customer` in a catalog, billing, or shipping context may represent different data and responsibilities. A **context map** describes how contexts relate, integrate, or depend on one another. These tools help teams avoid forcing every part of a company into one shared model.

### Tactical design: modeling rules

- **Entity:** an object with identity and a lifecycle.
- **Value object:** an immutable value whose meaning comes from its attributes, such as money plus currency.
- **Aggregate:** a consistency boundary that protects a set of related domain objects through an aggregate root.
- **Domain event:** a meaningful business fact that has already occurred.
- **Repository:** a domain-facing contract for retrieving and storing aggregates.
- **Domain service:** domain behavior that does not naturally belong to one entity or value object.

Start with the language, events, invariants, and places where change is difficult. For straightforward CRUD with few rules, the discovery and modeling overhead may exceed the benefit.

## 2. Model-View-Controller (MVC)

MVC separates the handling of user input, the presentation of a response, and the application's model. A controller receives an interaction and coordinates the response; a view presents information; the model represents data and behavior. Frameworks use the word *model* differently, so the MVC label alone does not tell you where domain rules live.

A common failure is a **fat controller** that performs request parsing, authorization, business decisions, transaction control, and SQL all in one place. Keep controllers focused on adapting the UI or HTTP boundary. Put important rules in an application use case or domain model where they can be tested and reused. MVC can organize the presentation layer while the rest of the application uses a different architecture.

## 3. Microservices

Microservices organize a system as independently deployable services around business capabilities. A service should have a clear responsibility and own its data. Teams may release and scale services separately, but communication now crosses network boundaries and changes that were once local can become distributed workflows.

The costs include network latency and failure, data consistency, contract evolution, service discovery, deployment automation, security, observability, on-call work, and end-to-end testing. Define boundaries from business capabilities and change patterns, not from database tables or class names. If services must share one transaction, call one another on every request, and always deploy together, the decomposition may be creating costs without real independence.

Extract gradually. A service boundary is more expensive to change than a library boundary, so first identify ownership and contracts and test whether they hold inside a modular monolith.

## 4. Blackboard

The blackboard pattern fits problems where several knowledge sources contribute partial results toward a solution. A shared blackboard holds the current facts or candidate results. Knowledge sources observe it and add information when they can make progress; a control mechanism chooses what runs next.

For example, a diagnostic system might place sensor readings on a shared workspace while independent analyzers add thermal, electrical, or mechanical evidence. The pattern is useful when the order of reasoning is not a simple fixed pipeline. It adds shared mutable state, coordination, and difficult debugging. A straightforward transformation pipeline or job queue is usually simpler when the steps are already known.

## 5. Microkernel

A microkernel keeps a small, stable core and places variable capabilities in plugins or extensions. It is useful for a product that supports a real extension ecosystem, optional modules, or edition-specific behavior.

Define the plugin contract, compatibility rules, permissions, lifecycle, resource limits, and failure isolation. A plugin architecture creates security and support responsibilities. If every extension is built and released with the application and there is no real need for independent installation or ownership, a set of ordinary modules may be easier to maintain.

## 6. Serverless

Serverless describes a model in which a provider manages some or much of the server provisioning, runtime, and scaling. Servers still exist; their management and billing are abstracted. Function or event-triggered execution can work well for bursty, independent tasks and managed workflows.

Evaluate startup latency, execution limits, concurrency quotas, state between invocations, observability, provider-specific dependencies, and cost under real traffic. Long-running or steady high-volume workloads may be cheaper or more predictable on containers or virtual machines. Serverless changes who operates the runtime; it does not remove the need to design security, reliability, and failure handling.

## 7. Queues and streams

A **queue** buffers work so a producer can continue while a consumer processes the job later. It is useful for background work, smoothing bursts, or isolating a slow dependency. A **retained stream or log** stores ordered records for a period and lets independent consumer groups read from their own positions. Some brokers provide both models, so reason from actual delivery, retention, ordering, replay, and partition semantics rather than product labels.

For either model, define message ownership and schema, retry limits, dead-letter handling, idempotency, backpressure, access control, and lag alerts. A queue does not guarantee that work is completed, and a stream does not make consumers automatically consistent.

## 8. Event sourcing

Event sourcing stores domain changes as an ordered sequence of events and derives current state by replaying those events. The event history is the source of truth, not just an audit log or a way to notify other services. A projection can be rebuilt by replaying the relevant history.

This can help when the business needs a complete history, temporal reasoning, or multiple projections derived from the same facts. It introduces event-schema evolution, deterministic replay, snapshots, projection rebuilding, correction events, retention, and sensitive-data deletion questions. Replaying events should not call external providers or depend on today's version of an unrelated service. Do not adopt event sourcing merely because the system publishes messages; ordinary state storage plus domain events may be simpler.

## 9. Service-Oriented Architecture (SOA)

SOA exposes business capabilities as services with contracts for integration, often across multiple enterprise systems. SOA is a broad family of approaches. Microservices usually emphasize smaller autonomous services and decentralized ownership, while an SOA environment may use more shared governance or an enterprise service bus.

A central bus can consolidate protocol translation and policy, but it can also create a bottleneck and central coupling. Define the integration problem, ownership, reuse needs, and change process before selecting a bus or service platform. Avoid creating a central system that every team must change for routine service evolution.

## 10. Command Query Responsibility Segregation (CQRS)

CQRS separates the model used to change state from the model used to read it. A simple CQRS implementation can use separate command and query handlers and different logical models inside one process and one database.

```python
def place_order(command, order_repository):
    order = Order.from_command(command)
    order_repository.save(order)
    return order.id

def get_order_summary(query, read_store):
    return read_store.find_summary(query.order_id)
```

Physical databases or services need to be separate only when read and write traffic, scaling, schema, or ownership require it. Once read projections are updated asynchronously, consumers must understand projection delay, stale results, and recovery after failed updates. CQRS is not an automatic fit for every form or table. [Martin Fowler's CQRS discussion](https://martinfowler.com/bliki/CQRS.html) warns that it adds complexity when ordinary CRUD is sufficient.

## 11. Learning examples and production systems

Microsoft's eShopOnContainers material demonstrates DDD and CQRS patterns for learning and discussion. It is a reference sample, not a rule that every production service must reproduce. The Microsoft guide itself notes that different services can use different internal architectures and that no one pattern or technology fits all situations. [Applying simplified DDD and CQRS patterns](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns)

When reviewing any sample, identify its intended lesson, assumptions, simplified infrastructure, and production gaps. Then decide which part addresses a real requirement in your own system.

## 12. Pattern selection table

| Pattern | Useful when | Costs and questions to accept |
| --- | --- | --- |
| DDD | The domain language and rules are complex and change often. | Domain discovery and model maintenance; is the complexity real? |
| MVC | Input handling and presentation need a clear structure. | Do controllers accumulate domain and persistence logic? |
| Microservices | Independent deployment, ownership, or scaling has measurable value. | Can the organization operate networked services and distributed data? |
| Blackboard | Independent knowledge sources contribute to a solution over time. | How will shared state and coordination be observed and controlled? |
| Microkernel | A genuine plugin or extension ecosystem is required. | How are plugin permissions, compatibility, and failures managed? |
| Serverless | Bursty or event-triggered work benefits from managed scaling. | What are the limits, startup behavior, provider coupling, and steady-state cost? |
| Queue or stream | Work needs buffering or independent consumers need replay. | How are ordering, retries, lag, duplicates, and schema changes handled? |
| Event sourcing | The event history is part of the authoritative domain model. | Can the team manage replay, projections, retention, and corrections? |
| SOA | Multiple systems need governed integration contracts. | Does governance solve a real coordination issue or create a central bottleneck? |
| CQRS | Read and write workloads or models have materially different needs. | Is the projection and consistency complexity justified? |

## 13. Answered quiz

1. **Is CQRS the same thing as microservices?**
   **Answer:** No. CQRS separates read and write models and can live inside one service and database.

2. **What should DDD help a team discover before extracting a service?**
   **Answer:** Consistent domain language, bounded contexts, ownership, invariants, and how those boundaries interact.

3. **How does a queue commonly differ from a retained stream?**
   **Answer:** A queue typically distributes work among competing consumers. A retained stream preserves records and consumer positions so independent groups can read or replay them. Check the broker's actual guarantees.

4. **Why is event sourcing more than an audit log?**
   **Answer:** Its events are the source of truth for state. Replay, event compatibility, determinism, snapshots, corrections, and projections are therefore part of the design.

5. **What does serverless not remove?**
   **Answer:** The system still needs security, observability, capacity planning, failure handling, and cost control; the provider only manages some infrastructure responsibilities.

6. **When is a microkernel justified?**
   **Answer:** When independent extensions or plugins are a real product requirement and the system can define and support their contract and lifecycle.

7. **Why should a team avoid using full DDD for every CRUD feature?**
   **Answer:** A complex model costs time and maintenance. If there are few domain rules, a simpler model may communicate the system more accurately.

8. **Why can an asynchronous CQRS read model be stale?**
   **Answer:** Its projection is updated after the write transaction. The product must define acceptable delay and how to recover from a failed projection update.

## Comprehensive exercise: place an order

An online store has complex discount and authorization rules. Two independent consumers need to react to `OrderPlaced`. A dashboard can be a few seconds behind, but the final amount and tax must be exact when the order is accepted.

1. Define the write-side model and the transaction boundary.
2. Choose how to deliver `OrderPlaced` to both consumers.
3. Choose how the dashboard reads recent orders.
4. Decide whether CQRS or event sourcing is justified.

**Worked answer:** Keep price, discount, authorization, and order-state invariants in the write-side domain model. An application use case coordinates validation and persistence. Save the order and an outbox record in the same database transaction; a publisher sends the event and safely retries. Consumers process messages idempotently. The dashboard can use an asynchronously updated read projection and display its freshness or delay. This is a simple form of CQRS, but does not require two services or databases. Use event sourcing only if the business needs the event history itself as the authoritative state and accepts replay, versioning, retention, and correction responsibilities.

## Optional further reading

### English

- [Microsoft Learn — DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice) — Domain boundaries and layered responsibilities.
- [Microsoft Learn — Applying simplified DDD and CQRS](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — A practical example with caveats about complexity.
- [Microsoft Azure — Event-driven architecture style](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) — Topologies, delivery, schema changes, and observability.
- [Martin Fowler — CQRS](https://martinfowler.com/bliki/CQRS.html) — When separating reads and writes may add more complexity than value.
- [Martin Fowler — Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) — Event-sourced models and their trade-offs.
- [AWS Prescriptive Guidance — Cloud design patterns](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/) — Outbox, saga, anti-corruption layer, event sourcing, and other implementation patterns.
- [Azure Architecture Center — Competing Consumers](https://learn.microsoft.com/en-us/azure/architecture/patterns/competing-consumers) — Scaling asynchronous work with competing consumers.

### Persian

- [Persian DDD guide](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — Domain modeling concepts in Persian.
- [DNTips — CQRS articles](https://www.dntips.ir/exports/tag/www.dntips.ir-tag-922.pdf) — Persian discussions of CQRS and its relationship to DDD.
- [EventDrivenFarsi](https://github.com/gloonch/eventdrivenfarsi) — Persian material on event-driven design, Kafka, event sourcing, and CQRS.

For more references grouped by chapter, see the [course reference library](../../references.md#chapter-08).

</div>
