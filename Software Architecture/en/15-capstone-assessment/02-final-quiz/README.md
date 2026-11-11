# Comprehensive Software Architect Final Quiz

Answer questions before opening the key. Each question is worth one point. For short-answer questions, award the point only when the reasoning is present; terminology without a reason is not enough.

## Part A — Questions

1. What should an architect clarify before selecting technologies?
2. Why is “the system must scale” not a complete quality requirement?
3. What audience question does a C4 context view answer?
4. How does an Entity differ from a Value Object?
5. Does Domain-Driven Design require microservices?
6. What responsibility does a bounded context make explicit?
7. What does CQRS separate, and what complexity can it add?
8. Name two long-term costs of Event Sourcing.
9. What does ACID atomicity promise?
10. Under what condition does the CAP trade-off become relevant?
11. What makes a monolith modular?
12. Name three responsibilities introduced when a service becomes independently deployable.
13. Why can a timeout leave a payment result ambiguous?
14. Why should an event consumer be idempotent?
15. What is the difference between OAuth 2.0 and OpenID Connect?
16. Why is client-side authorization insufficient?
17. Why is plain SHA-256 unsuitable for password storage?
18. How should an architect choose among relational and NoSQL databases?
19. Why should an analytics pipeline preserve lineage and freshness?
20. When might GraphQL be useful, and what risk must be bounded?
21. Why do RPC clients need deadlines?
22. What is the transactional outbox intended to prevent?
23. When is static site generation a good fit?
24. How does a container differ from a virtual machine?
25. What is the difference between readiness and liveness?
26. Distinguish an SLI from an SLO.
27. What does an error budget help an organization decide?
28. What belongs in an Architecture Decision Record?
29. How do UML and C4 complement one another?
30. What are the main flow mechanisms in Kanban?
31. What is the central purpose of a Scrum Sprint?
32. Why is comparing team velocity usually misleading?
33. What is the role of an ERP system compared with a BI platform?
34. Why can enterprise content metadata matter as much as the file?
35. What evidence would justify extracting a module into a microservice?

## Part B — Applied scenario

A checkout API is expected to respond quickly, but the payment provider sometimes takes eight seconds and occasionally sends duplicate callbacks. Propose a design. Cover order state, HTTP response, idempotency, callback validation, reconciliation, inventory, user messaging, SLI/SLO, and recovery.

## Part C — Answer key with reasoning

1. Business outcome, stakeholders, constraints, and assumptions; technology selection follows the problem.
2. It needs a workload, population, time window, latency/error target, and failure condition to be testable.
3. What is inside the system boundary, who uses it, and which external systems interact with it?
4. An Entity has identity that persists through change; a Value Object is defined by its values and is normally immutable.
5. No. DDD models domain complexity; a bounded context can be implemented as a module, monolith, or service.
6. A clear language/model boundary, responsibility, ownership, and integration contract for a domain area.
7. CQRS separates read and write models or paths; it can add synchronization, stale reads, duplicate models, and operations work.
8. Schema/event evolution and projections/replay are examples; privacy erasure, tooling, and debugging can also be costly.
9. A transaction either commits all its intended changes or none of them.
10. When a distributed system experiences a network partition and must trade off strong consistency against availability of responses.
11. Enforced module interfaces and dependency rules, cohesive ownership, and controlled access—not folder names alone.
12. Independent deployment, service discovery/network policy, telemetry, security identity, on-call, versioning, and distributed failure handling.
13. The remote operation may have completed while its response was lost or delayed.
14. Brokers and retries can redeliver; idempotency avoids repeating a business effect.
15. OAuth handles delegated authorization; OIDC adds an identity layer and standardized authentication claims.
16. Clients can be modified or bypassed; the server must authorize each resource and action.
17. It is too fast for password guessing and lacks password-specific work factors; use a current password hashing function with unique salt and appropriate parameters.
18. From access patterns, invariants, transactions, query needs, consistency, scale evidence, team skills, and operational cost.
19. To trust results, trace sources and transformations, identify stale data, debug errors, and reproduce/backfill outputs.
20. It can serve flexible graph-shaped client reads; query depth/complexity and resolver fan-out must be controlled.
21. To bound resource use and propagate cancellation instead of letting slow calls consume capacity indefinitely.
22. The gap where a database commit succeeds but message publication fails (or vice versa).
23. When content is public and known at build time or can meet freshness needs through revalidation.
24. A container isolates a process while sharing the host kernel; a VM runs a guest operating system on virtualized hardware.
25. Readiness controls whether traffic should be sent; liveness indicates whether restart is appropriate.
26. An SLI measures an outcome; an SLO sets a target over a defined window for that indicator.
27. It makes tolerated unreliability visible and guides release risk, reliability work, and prioritization.
28. Context, decision, considered options, consequences, owner, and revisit trigger.
29. C4 supplies a simple zoomed set of system structure views; UML offers standardized structural and behavioral notation for detailed questions.
30. Visualize workflow, limit work in progress, manage flow, and improve using measures.
31. Create a usable Increment toward the Product Goal while inspecting and adapting.
32. Estimation conventions differ and comparison incentivizes gaming; it is not a standardized measure of value or productivity.
33. ERP supports operational transactions and business processes; BI analyzes governed data for reporting and decisions.
34. Metadata enables retrieval, access/retention policy, lifecycle, audit, and connection to business processes.
35. Evidence of independent scaling/release/security/reliability need, stable boundaries, a real owning team, and ability to operate the service.

## Applied scenario: evaluation guide

A strong answer creates an order in PENDING_PAYMENT and returns a tracking identifier quickly without claiming final payment success. The provider request uses an idempotency key and a bounded deadline. A timeout becomes UNKNOWN/PENDING until a signed, fresh, correctly addressed callback or a reconciliation query resolves it. Duplicate provider event IDs are deduplicated and state transitions are constrained. Inventory is reserved with an invariant and explicit expiry/commit policy. The customer sees a clear pending state and is not urged to submit another charge. Define separate measures for fast API acknowledgment and eventual successful checkout completion; monitor unknown outcomes, callback failures, queue age, and inventory conflicts. Provide an operator runbook and safe manual correction path.

## Scoring

- **30–35 points:** strong conceptual foundation; complete the capstone and defend trade-offs.
- **23–29 points:** good working vocabulary; revisit weak domains and practice failure scenarios.
- **15–22 points:** partial foundation; repeat Chapters 1–10 and complete the capstone with a mentor or peer.
- **Below 15:** start with fundamentals, requirements, data, security, and delivery before choosing specialized frameworks.

For the scenario, use a separate 10-point rubric: state model (2), ambiguity/idempotency (2), security/reconciliation (2), reliability measures (2), inventory and customer experience (2). A technically named pattern without showing its failure behavior earns no credit.

## Final review reading

- [Software Architect roadmap](https://roadmap.sh/software-architect)
- [C4 Model](https://c4model.com/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [Google SRE Book](https://sre.google/books/)
- [Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)
- [AWS Builders' Library](https://aws.amazon.com/builders-library/)
- Persian: [Ali Rostami software architecture resources](https://www.alirostami.com/software-architecture/), [Persian DDD repository](https://github.com/hheydarian/Understanding-Domain-Driven-Design), [Persian event-driven architecture notes](https://github.com/gloonch/eventdrivenfarsi)
