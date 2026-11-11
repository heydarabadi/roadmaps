# Software Architecture Glossary

This glossary supports the lessons; it is not a substitute for a formal standard. A term may have a more specific meaning in a particular organization, product, or protocol. Record the definition used for an important decision.

## Architecture, modeling, and quality

| Term | Meaning |
| --- | --- |
| **Architecture** | Important system structures, relationships, and decisions that shape quality, operation, and evolution. |
| **Architectural decision** | A choice with significant consequences for system structure, quality, or cost; record its context, alternatives, rationale, and consequences. |
| **ADR** | Architecture Decision Record: a concise record of a decision, context, options, outcome, and consequences. |
| **Stakeholder** | A person or group affected by, influencing, or making decisions about a system. |
| **Quality attribute** | A measurable property such as latency, security, availability, changeability, or recoverability. |
| **Quality scenario** | Stimulus, environment, affected component, response, and a measurable response criterion. |
| **Trade-off** | A choice that improves one quality while potentially increasing cost or complexity elsewhere. |
| **C4 model** | A way to describe context, containers, components, and code at different levels for different audiences. |
| **UML** | A standardized modeling language for structural and behavioral diagrams; it does not guarantee code correctness. |
| **Layer** | A logical separation of responsibility and dependency within code. |
| **Tier** | An execution boundary such as process, machine, or network; it introduces additional cost and failure modes. |
| **Boundary** | A point where ownership, contract, data, trust, or change is separated. |
| **Coupling** | How strongly a change or failure in one part affects other parts. |
| **Cohesion** | How closely a component’s responsibilities and concepts belong together. |
| **Modularity** | Separation into parts with controlled responsibility, contracts, and dependencies. |
| **Monolith** | An application built or deployed as one main unit; it may be modular or entangled internally. |
| **Modular monolith** | One deployment with modules that have enforceable ownership, contracts, and dependency rules. |
| **Microservice** | An independently operated service around a business capability, with clear data and operational ownership. |
| **Microkernel** | A relatively stable core extended through plugins or extension points. |
| **Bounded context** | A DDD boundary within which a model and language have consistent meaning and ownership. |
| **Ubiquitous language** | Shared vocabulary between domain experts and engineers within a bounded context. |
| **Entity** | A domain concept with persistent identity that changes over time. |
| **Value Object** | A concept defined by its values and properties, usually without independent identity. |
| **Aggregate** | A group of domain objects with a root that protects invariants and transaction boundaries. |
| **Invariant** | A rule that must hold for every valid system state, such as non-negative inventory. |
| **CQRS** | Separation of the model or path for changing data from the one for reading it. |
| **Event Sourcing** | Storing changes as events that form the source of truth and can reconstruct state or views. |
| **Projection** | A derived model optimized for a read or report; it needs a rebuild or synchronization strategy. |

## Data and transactions

| Term | Meaning |
| --- | --- |
| **ACID** | Atomicity, Consistency, Isolation, and Durability: common properties of database transactions. |
| **Atomicity** | A transaction’s local changes are applied as a whole or not applied. |
| **Consistency (ACID)** | A transaction preserves declared model constraints; this differs from CAP consistency. |
| **Isolation** | Defines which effects concurrent transactions can observe. |
| **Durability** | A committed change remains recoverable according to the database’s guarantees. |
| **CAP theorem** | During a network partition, distributed systems face a choice between consistent responses and availability for affected requests. |
| **Partitioning** | Dividing data or workload across nodes; a skewed key can create a hotspot. |
| **Replication** | Keeping data copies across nodes for reads or availability; replication alone is not backup. |
| **Eventual consistency** | Replicas may temporarily differ and converge if updates stop and propagation continues. |
| **Index** | A structure that accelerates particular queries at the cost of storage and write maintenance. |
| **N+1 query** | One query fetches a set, then one additional query runs for every row in that set. |
| **Schema migration** | Changing data structure or content; it must account for concurrent versions, rollback, and production volume. |
| **Expand/contract** | Add compatible structure, migrate gradually, switch consumers, and remove the old structure later. |
| **RPO** | Recovery Point Objective: acceptable data loss measured as a time window. |
| **RTO** | Recovery Time Objective: target time to restore service after an incident. |
| **ETL / ELT** | Extract, Transform, Load; the distinction is when and where transformation occurs relative to the analytical destination. |
| **Fact / dimension** | In a warehouse, a fact records measures at a defined grain; dimensions provide analysis context such as time or product. |
| **Grain** | Precisely what one row of a fact table represents. |
| **Data lineage** | The source, transformations, and consumers of data, used to explain metrics and change impact. |
| **Watermark** | A time boundary that represents processing progress or accepted late data in a stream. |
| **Backfill** | Reprocessing a defined historical range to rebuild or correct data. |

## APIs, messaging, and distributed systems

| Term | Meaning |
| --- | --- |
| **API contract** | Stable definition of inputs, outputs, errors, security, versions, and expected behavior. |
| **REST** | An architectural style based on resources and protocol semantics; not every JSON endpoint is RESTful. |
| **SOAP** | An XML messaging protocol with associated formal contracts and enterprise standards. |
| **GraphQL** | A schema-based query language and runtime where clients select response fields. |
| **gRPC** | Remote procedure call framework using Protocol Buffers, code generation, and streaming support. |
| **Idempotency** | Repeating the same request does not add a second logical effect; key scope and retention must be defined. |
| **Timeout** | Maximum time a caller waits; it does not prove the server did not complete the operation. |
| **Retry** | Reattempt after a possible failure; bound it and make the business effect safe. |
| **Backoff and jitter** | Increasing retry intervals with random spread to prevent synchronized retry spikes. |
| **Circuit breaker** | Temporarily stops calls after defined failures and supports recovery behavior. |
| **Bulkhead** | Separates resources or concurrency to keep one dependency’s failure from exhausting the whole application. |
| **Queue** | Holds work for consumers; often distributes each job to one consumer in a group. |
| **Pub/sub** | Fan-out of an event to multiple independent subscriptions. |
| **Event stream** | Durable ordered log within a partition, with consumer offsets and replay according to retention. |
| **Command** | A request asking a recipient to perform an action. |
| **Event** | A statement that something happened; consumers may react independently. |
| **Outbox pattern** | Persist a local change and outgoing event in one transaction, then publish asynchronously. |
| **Dead-letter queue (DLQ)** | Holds messages that failed a retry policy for investigation and controlled recovery. |
| **Backpressure** | Limits production or consumption to prevent work from exceeding system capacity. |
| **Saga** | A multi-step workflow across independent boundaries with explicit state, retries, and compensations. |
| **Compensation** | A business operation that addresses an earlier effect; it is not necessarily an atomic rollback. |
| **Reconciliation** | Comparing systems or external status to detect differences and reach an agreed result. |

## Security and identity

| Term | Meaning |
| --- | --- |
| **Authentication** | Verifying the identity of a user, actor, or system. |
| **Authorization** | Deciding whether an identity may perform an action on a resource in the current context. |
| **RBAC** | Role-Based Access Control: access policy based on roles. |
| **ABAC** | Attribute-Based Access Control: policy based on subject, resource, action, and context attributes. |
| **IDOR** | Insecure Direct Object Reference: unauthorized object access because ownership or tenant checks are missing on the server. |
| **OAuth 2.0** | An authorization framework for delegated API access; not, by itself, user authentication. |
| **OpenID Connect (OIDC)** | An identity layer on OAuth 2.0 for login and identity claims. |
| **Session** | Login state associated with an identifier the server can manage and revoke. |
| **JWT** | A claim format that may be signed or encrypted; a signature does not provide confidentiality. |
| **Hash** | One-way digest for fingerprinting or integrity; a fast general hash is unsuitable for password storage. |
| **Salt** | Unique, non-secret value used per password hash to make precomputed attacks harder. |
| **Encryption** | A keyed transformation that protects confidentiality and can be reversed by an authorized key holder. |
| **Digital signature** | Public-key mechanism for authenticity and integrity; it does not itself provide confidentiality. |
| **PKI** | Certificate and trust infrastructure linking public keys with identities. |
| **TLS** | Protocol protecting a communication channel; it does not enforce API authorization or correct business rules. |
| **STRIDE** | Threat prompts for spoofing, tampering, repudiation, information disclosure, denial of service, and elevation of privilege. |
| **Least privilege** | Granting only the minimum access needed, for the shortest useful time and scope. |
| **Threat model** | Record of assets, trust boundaries, actors, abuse cases, controls, tests, and remaining risk. |

## Operations and delivery

| Term | Meaning |
| --- | --- |
| **Container** | A package of an application and dependencies that usually shares the host kernel. |
| **Virtual machine (VM)** | A virtualized machine with a guest operating system. |
| **Orchestration** | Scheduling workloads and maintaining desired state across nodes. |
| **Service mesh** | Infrastructure for service-to-service identity, traffic, and telemetry; it also adds proxy and control-plane cost. |
| **IaC** | Infrastructure as Code: versioned, reviewable definition of infrastructure. |
| **CI/CD** | Continuous integration and continuous delivery/deployment through an automated pipeline. |
| **Blue/green** | Two environments with traffic switched between them; rollback is easier but capacity cost is higher. |
| **Canary** | Expose a version to a small share of traffic and evaluate it against metrics and guardrails. |
| **Feature flag** | Separates feature activation from code release; each flag needs an owner and cleanup plan. |
| **Observability** | Ability to infer internal system state from metrics, logs, traces, and context. |
| **Metric** | Numeric measurement over time, such as latency, error rate, or resource use. |
| **Log** | A timestamped event with context; it can expose sensitive data. |
| **Trace** | The linked path of a request through spans across components and network boundaries. |
| **SLI** | Service Level Indicator: measured value of service experience. |
| **SLO** | Service Level Objective: target for one or more SLIs over a stated window. |
| **SLA** | Service Level Agreement: external or contractual commitment with consequences. |
| **Error budget** | Allowed unreliability implied by an SLO, used to balance change speed and reliability. |
| **Readiness probe** | Signal that an instance can accept new work. |
| **Liveness probe** | Signal that a process is alive and responsive; transient dependency errors should not create restart storms. |
| **Graceful shutdown** | Stop new work, drain active work, and exit before a deadline. |
| **Drift** | Difference between actual infrastructure and the declared IaC state. |
| **Rollback / forward fix** | Restore a previous version or correct the issue in a new version; schema changes may make rollback unsafe. |

## Management and organization

| Term | Meaning |
| --- | --- |
| **WIP limit** | Maximum work in progress to reduce context switching and reveal bottlenecks. |
| **Lead time** | Time from request or work start to delivery, using the organization’s explicit definition. |
| **Cycle time** | Time from active work start until completion. |
| **Backlog** | Prioritized work or need list; it does not guarantee value or quality. |
| **Business capability** | A durable organizational ability to deliver a business outcome, independent of current implementation. |
| **System of record** | Authoritative source for valid changes and current state of a data entity. |
| **Enterprise architecture** | Alignment of strategy, capabilities, data, applications, technology, and organizational transition. |
| **BPMN** | Business Process Model and Notation for activities, events, roles, and decisions in a process. |
| **Technical debt** | Future cost created by a shortcut or prior choice that now requires maintenance or correction. |
| **Runbook** | Operational guide for diagnosing and acting on an incident or repeatable task. |

## Further reading

- [OMG standards and specifications](https://www.omg.org/spec/)
- [Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)
- [Google SRE books](https://sre.google/books/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
