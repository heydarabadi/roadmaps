# SOA and Microservices

## Learning goals

- Compare service-oriented architecture with microservice approaches.
- Identify bounded contexts, integration style, and operational ownership.
- Evaluate service extraction against its distributed-systems costs.

SOA and microservices expose capabilities through service contracts. SOA often focuses on shared capabilities and enterprise integration; microservices emphasize independent services with separate data ownership and release. Find boundaries from business capability.

Every network call can fail. Tracing, discovery, versioning, secrets, incident response, and data coordination have real cost. Teams are not independent without real data and operational ownership. An API gateway can route and handle shared concerns, but should not accumulate domain logic.

Netflix has published its service architecture and rebuilt its video-processing pipeline with microservices. That experience reflects its scale and operational maturity; it is not a recipe to copy in every organization.

| Choice | Fits when | Cost |
| --- | --- | --- |
| Modular monolith | Small team and evolving domain | Shared release and scaling |
| SOA | Shared capabilities across an organization | Governance and coordination |
| Microservices | Clear service boundary and ownership | Distributed complexity and on-call |

## Step-by-step: should a capability become a service?

Name a service for a **business capability and ownership**, not a table or technical verb. Consider extracting payments:

1. **Domain boundary:** payment has its own lifecycle: initiation, authorization, decline, and refund.
2. **Data ownership:** payment owns intent, transaction, and reconciliation state; orders retain the identifiers and commercial status they need. Other services must not write payment tables with SQL.
3. **Contract:** CreatePayment takes an order ID and idempotency key; its first response may be Pending. A callback or event carries the later outcome.
4. **Consistency:** order and payment are not one ACID transaction. Define a state machine and Saga: order enters PendingPayment, success confirms it, and timeout triggers reconciliation.
5. **Failure:** after a payment timeout, do not charge again blindly. Query the provider or repeat an idempotent operation. Deduplicate repeated messages and validate state transitions.
6. **Real independence:** a team owns build, deployment, monitoring, incidents, schema, and support. If every release still needs coordinated deployment, independence is mostly nominal.

## Synchronous calls, asynchronous messaging, and API gateways

A synchronous call is simple, but transfers latency and availability dependencies to the caller. Asynchronous messages separate bursts and consumers, but introduce delay, duplication, ordering, dead letters, and eventual consistency. An edge gateway can provide shared authentication, routing, rate limiting, and telemetry; keep domain policies and workflows out of it.

Evolve a contract compatibly: consumers first accept the new shape, then deploy the new producer, migrate data or messages, and remove the old field only after old consumers are gone. Define a retirement date for every version.

## Signs that the architecture needs review

- Many tiny services with expensive deployments and on-call may indicate boundaries are too fine.
- Shared table ownership or coordinated schema changes indicate incomplete independence.
- Cascading latency and simultaneous retries need deadlines, bulkheads, load limits, and valid fallbacks.
- A distributed transaction cannot be fixed by retry alone; define states, delivery, idempotency, compensation, and reconciliation.

Industry stories help identify trade-offs. Outcomes depend on team structure, traffic, on-call culture, tools, and economics. Company size alone is not a reason to copy a design.

## Self-check quiz

1. **What does a separate process not guarantee?** Independent data, teams, releases, or operations.
2. **When might a modular monolith be preferable?** When domain and team are small or the organization cannot operate many services.
3. **What should an API gateway not become?** The central location for domain logic and orchestration.
4. **How should a Netflix case study be used?** To understand trade-offs in its context, not as a guaranteed template.
5. **What is a practical prerequisite for microservices?** Clear boundaries, data ownership, independent delivery, automation, and operational readiness.

## Exercise

Compare separating order from payment by ownership, consistency, fault isolation, latency, and team cost.

### Sample answer

For a small team exploring the domain, payment can remain an in-process module: lower latency and simpler operations, but shared release and scale. Service extraction becomes worthwhile when data and team ownership, independent release, distinct load, or fault isolation are evidenced. In return, the team accepts timeouts, idempotency, eventual consistency, tracing, and on-call cost. State the context and measures behind the choice.

## Further reading

- Persian: [Microservices in Persian software architecture](https://www.alirostami.com/software-architecture/18-microservices-architecture), [Monolith and microservices comparison](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3390.pdf)
- English: [Martin Fowler: Microservices](https://martinfowler.com/articles/microservices.html), [Microservice Prerequisites](https://martinfowler.com/bliki/MicroservicePrerequisites.html), [Netflix: Rebuilding the video processing pipeline](https://netflixtechblog.com/rebuilding-netflix-video-processing-pipeline-with-microservices-4e5e6310e359), [Uber Engineering](https://www.uber.com/blog/engineering/), [Microsoft microservices architecture](https://learn.microsoft.com/en-us/azure/architecture/microservices/)
