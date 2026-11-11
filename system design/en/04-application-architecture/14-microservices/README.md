# Application Architecture and Microservices

[فارسی](../../../04-application-architecture/14-microservices/README.md)

## Learning goals

- Compare a monolith, modular monolith, and microservices using more than deployment count.
- Identify service boundaries from business capabilities and ownership.
- Explain how a service split changes data and transaction behavior.
- Recognize the operational capabilities required to run services independently.

## Central idea

The application layer coordinates use cases. Microservices create independently owned and deployed boundaries, but add network and operational cost. Decomposition should solve a measured problem.

## Concept map

Business capability → bounded context and ownership → service API and data → synchronous/asynchronous interaction → partial failure and operation.

## Detailed lesson

### Monolith, modular monolith, and microservices

A monolith is usually built and released as one application artifact. It can still be modular, with explicit internal interfaces, ownership rules, and controlled dependencies.

A microservice implements a domain capability in a separately running unit and is typically deployed or scaled independently. The important distinction is not simply the number of processes; it is ownership, deployment, data boundaries, and failure boundaries.

A separate service can use its own technology and scaling profile and allow a team to release without coordinating every change. It also makes the network part of every interaction: latency, timeout, authentication, retry, version skew, tracing, deployment, and incident response all become design concerns.

A transaction across several local database tables may turn into a saga, outbox, compensating action, or eventual-consistency workflow. Microservices are an organizational and system-boundary tool, not merely a way to make code execute faster.

### Find boundaries from the domain

Look at business capabilities and the changes that belong together. Catalog, orders, payments, and shipping may be separate boundaries in a store, but they are not automatically separate services.

If two areas always need to change atomically and one small team owns them, splitting them early may add more cost than value. Bounded contexts help clarify terms such as customer, price, and order when different teams use similar words with different meanings.

A useful boundary lets a team own a coherent data model and a business capability without coordinating every internal change with another team.

### Service-owned data and contracts

Each service should own the write model for its facts. If every service can directly update the same database schema, coupling is hidden: a column change may require several coordinated deployments.

A service can expose an API or publish events for other consumers. Define freshness and consistency for any derived data. Contracts should be versioned, observable, and protected. Consumers need to tolerate additive fields and gradual changes without every producer and consumer deploying simultaneously.

### Synchronous and asynchronous communication

A synchronous call is straightforward when the caller needs an immediate answer, but it creates a dependency chain. If a request calls three services that take 100, 150, and 200 ms, the response takes at least the sum of those durations plus network and queue time. A failure in any required dependency can fail the whole request.

Asynchronous messages reduce temporal coupling and can absorb bursts. They also mean the result arrives later, and duplicate delivery, ordering, retries, and correlation IDs become important for debugging and correctness.

### Transactions across service boundaries

One database can commit several local updates atomically. A distributed transaction across multiple services adds coordination and strong coupling.

A saga performs a sequence of durable steps and runs compensating actions when a later step fails. Compensation does not necessarily erase an external side effect: a refund is a new financial operation, not a time machine. A transactional outbox helps keep a local database update and event publication from becoming inconsistent.

### When is a split worth it?

Useful evidence includes teams blocked on each other’s releases, a capability with a distinct scaling or SLO profile, independently meaningful data ownership, or a need to isolate its failures.

Warning signs include a small team, a changing domain, weak deployment and observability, or multiple services with unrestricted access to the same database. A lower-risk path is often to build a modular monolith, test its boundaries, and split incrementally with a strangler approach when a real need appears.

### Minimum operational requirements

Each service needs health and readiness signals, metrics, logs, traces, service identity, timeouts and deadlines, connection limits, and a runbook. Contract and deployment changes must tolerate a period when old and new versions run together.

Treat a service failure as a partial failure. Do not assume all services start and stop at the same time.

## Worked example

Splitting order processing from payments may turn a simple transaction into a saga. That is justified when independent ownership, release, scaling, or failure isolation is valuable enough to support the added consistency and recovery work.

## Public engineering case study

[Uber: Technology stack foundations](https://www.uber.com/us/en/blog/tech-stack-part-one-foundation/) describes how a large service ecosystem makes service discovery, routing, and telemetry central concerns. The scale and internal tooling are specific to Uber; the general lesson is to account for the platform cost of many services.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Modular monolith | The domain or team boundaries are still being learned | Modules can become tightly coupled if boundaries are not enforced |
| Microservices | Independent ownership, release, scaling, or failure isolation is required | Network, data coordination, and operations may outweigh the benefits |
| Synchronous API calls | The caller needs an immediate result | Dependency chains amplify latency and failures |
| Asynchronous events | Work can complete later and temporal decoupling helps | Delayed results and duplicate or out-of-order events need handling |

## Common pitfalls

- Splitting by code size rather than business ownership.
- Keeping a shared database with unrestricted cross-service writes.
- Creating tiny services with no independent ownership.
- Starting with complex orchestration before requirements justify it.
- Forgetting distributed tracing and identity between services.
- Treating a saga compensation as guaranteed rollback of an external effect.

## Short quiz

1. What matters beyond the number of running processes when distinguishing microservices?
2. Why is a modular monolith a reasonable starting point?
3. What evidence might justify splitting one capability?
4. What changes when a transaction crosses service boundaries?

### Answer key

1. Ownership, deployment independence, data boundary, and failure boundary.
2. It enables clear internal boundaries without immediately paying for network and distributed-operation complexity.
3. Independent team ownership, a different scaling or SLO profile, release coupling, or a requirement to isolate failures.
4. Atomic local transactions may become a saga/outbox workflow with retries, compensation, and eventual consistency.

## Exercise

Model catalog, order, payment, and shipping for a store as a modular monolith and as services. Draw the ownership boundaries, APIs/events, data stores, and failure cases. Name the business or operational evidence that would make you choose the split design.

## Summary

Microservices create independent ownership and deployment boundaries, but every boundary adds network, data, and operational concerns. Start from domain and team needs, then split only where the benefit is concrete and observable.

## Further reading

- [Microsoft: Microservices architecture style](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) — benefits, design principles, and trade-offs.
- [Martin Fowler: Microservices](https://martinfowler.com/articles/microservices.html) — characteristics and operational implications.
- [Martin Fowler: Monolith First](https://martinfowler.com/bliki/MonolithFirst.html) — domain discovery and timing of decomposition.
- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) — operational, reliability, security, and cost considerations.
- [Uber: Technology stack foundations](https://www.uber.com/us/en/blog/tech-stack-part-one-foundation/) — public architecture and platform case study.
