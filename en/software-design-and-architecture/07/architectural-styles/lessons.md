<div dir="ltr" align="left">

# Full lesson: Architectural styles

> **Language:** [Persian edition](../../../../fa/software-design-and-architecture/07/architectural-styles/lessons.md)

## Learning goals

By the end of this lesson, you should be able to:

- Explain how an architectural style constrains components, connectors, and their permitted relationships.
- Distinguish a logical layer from a deployment tier, and a monolith from a modular monolith.
- Compare in-process collaboration, client-server calls, peer-to-peer communication, queues, streams, and publish-subscribe.
- Identify the failure modes that appear when components communicate over a network or through asynchronous messages.
- Choose a style from product, team, quality-attribute, and operational evidence instead of fashion.
- Read a company case study without treating a result from one workload as a universal rule.

## 1. What is an architectural style?

An architectural style is a family of designs that share constraints on the kinds of elements a system contains and on the relationships allowed between those elements. A style narrows the design space. The constraints can make some qualities easier to achieve while making others more expensive.

For example, a layered design constrains which parts may depend on which other parts. A client-server design assigns requests and resource ownership to different roles. An event-driven design lets producers publish facts that consumers can process independently. None of these names, by itself, tells you which programming language, cloud provider, database, or framework to choose.

Keep these terms separate:

| Term | What it describes | Example |
| --- | --- | --- |
| Style | A broad set of structural constraints | Layered, client-server, event-driven |
| Pattern | A reusable response to a recurring problem | Circuit breaker, outbox, strangler fig |
| Technology | A concrete implementation choice | PostgreSQL, Kafka, Kubernetes |
| Deployment topology | Where processes and infrastructure run | One process, several containers, multiple regions |

A single system can combine styles. For instance, an online store might be a modular monolith internally, expose a client-server HTTP API, and use a queue for long-running reports. Describe the combination precisely instead of treating one label as the whole architecture.

## 2. Component-based design

Component-based architecture organizes related responsibilities behind explicit interfaces. A component may be a package, module, library, or independently deployed service. The word *component* does not imply a separate process or deployment.

Good component boundaries are visible in the rules of the codebase, not just in folder names. Look for restricted dependencies, public APIs, tests at the boundary, clear ownership, and a rule for who may change the component's data. If every module can reach into every other module's tables and implementation classes, the system is not meaningfully modular even if its directory tree looks tidy.

A useful progression is to establish boundaries inside one process first. Extract a component into a service only when a demonstrated need—such as independent release, scaling, security isolation, or team ownership—outweighs the new network and operating costs.

## 3. Monoliths and modular monoliths

A monolith is one deployable application unit. The term says nothing about whether its source code is well structured. A monolith may contain clear modules, or it may be a tightly coupled codebase that is difficult to change.

A **modular monolith** keeps one deployment boundary while enforcing internal boundaries. Modules expose deliberate APIs, keep implementation details private, and have clear responsibility for their data and changes. It preserves fast in-process calls and often permits simpler local development, transactions, debugging, and deployment than a distributed service landscape.

The trade-offs are real. The whole application may need to be built and released together; one busy module can influence the resources available to others; and a weak boundary can erode over time. These are reasons to measure and improve the design, not proof that every module should immediately become a service.

Shopify's engineering team described modularizing its large Rails monolith with components, ownership, and tooling. The account also emphasizes that this work changes developer habits and takes time. It is evidence that a large monolith can be managed through deliberate boundaries; it is not evidence that every product should use Rails or remain a monolith forever. [Shopify's account](https://shopify.engineering/shopify-monolith)

## 4. Layered architecture and N-tier deployment

A **layer** groups responsibilities logically. A common arrangement has presentation, application, domain, and infrastructure responsibilities. The exact names vary. What matters is that each layer has a defined job and the dependency direction is intentional. If business rules must remain independent of a web framework or database, those details should not become the rules' owners.

A **tier** is a physical or deployment boundary: separate processes, machines, containers, or network zones. A system can have several logical layers in one process, or put some layers on separate tiers. Therefore *layer* and *tier* are not synonyms.

Layering can clarify change and keep technical details away from domain rules. It can also add pass-through classes, mapping code, network hops, and latency. A middle layer that merely forwards CRUD calls may add cost without protecting a meaningful boundary. Use the lightest layering that makes dependencies, security, testing, or ownership clearer.

When layers are separated into tiers, each extra network hop introduces latency and another possible failure. A tier may be scaled or secured independently, but the team must then operate its deployment, network policy, health checks, and failure behavior. Microsoft's N-tier guide distinguishes logical layers from physical tiers and explains closed versus open layer calls. [N-tier architecture style](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/n-tier)

## 5. Structural styles: pipes, filters, and connected components

Structural styles explain how components are connected and how control or data moves through them. In a **pipe-and-filter** arrangement, each filter transforms an input and passes an output through a connector (the pipe) to the next step. A media-processing pipeline might decode a file, normalize audio, detect defects, and store a report.

This is useful when stages have clear input/output contracts and can be tested or scaled independently. It becomes harder when stages share mutable state, require tightly coordinated transactions, or must frequently jump backward and branch through a complex workflow. Specify message shape, ordering, error handling, buffering, and the owner of each stage; drawing boxes and arrows alone does not define those contracts.

## 6. Client-server

In a client-server design, a client requests a capability or resource from a server that owns it. A browser calling a web API is a common example. An HTTP request may be stateless—each request carries the information needed to interpret it—while the server still stores durable business data and may manage session state elsewhere.

The boundary is also a security boundary. A client is controlled by the caller, so the server must authenticate the identity, authorize the requested action, validate input, and enforce business rules. Hiding a button in the user interface does not prevent a direct API call.

Network calls can be slow, duplicated, interrupted, or completed even when the response never reaches the client. Give calls deadlines, set bounded retry policies, and make repeatable commands idempotent. For a payment request, an idempotency key lets the server recognize that a retry is the same logical operation rather than a second charge. Reconciliation is still needed when the outcome remains uncertain.

## 7. Peer-to-peer

In a peer-to-peer (P2P) design, a node can both consume and provide resources. Peers may discover one another and exchange data without routing every interaction through a single central server. This can distribute storage or bandwidth and may remove a central bottleneck.

It also moves difficult responsibilities to the peers and protocol: discovery, changing membership (churn), NAT traversal, conflicting updates, trust, malicious participants, abuse controls, and version compatibility. P2P does not automatically mean more available or more secure. Use it only when decentralized exchange is a product or system requirement, and write down which peers are trusted and how the system behaves when they disappear or lie.

## 8. Distributed systems: the costs of crossing a network

A distributed system has multiple processes communicating over a network. The network can delay, reorder, duplicate, or lose messages; clocks are not perfectly aligned; and one process can fail while another continues. A timeout tells a caller that it stopped waiting. It does **not** prove that the remote operation did not happen.

Design practical safeguards around those facts:

1. Set a deadline for every remote operation and propagate the remaining time budget.
2. Retry only failures that may recover, cap the attempts, and use exponential backoff with jitter.
3. Make commands idempotent or provide a way to reconcile an uncertain result.
4. Apply circuit breakers and bulkheads where they isolate a real dependency or resource pool; avoid adding them mechanically to every call.
5. Define what consistency users need, how stale views are shown, and how discrepancies are repaired.
6. Carry a correlation or trace identifier across messages and record useful metrics, logs, and traces.

Retries can amplify overload: slow responses keep work in flight, then retries add still more work to an unhealthy dependency. Google SRE describes how this feedback loop can become a cascading failure and why load shedding, deadlines, and backoff matter. [Addressing Cascading Failures](https://sre.google/sre-book/addressing-cascading-failures/)

## 9. Event-driven architecture

An event is a statement about something that **has happened**, such as `OrderPaid`. A command asks someone to do something, such as `CapturePayment`. Naming and treating these messages differently prevents a hidden request from masquerading as an immutable fact.

In an event-driven design, producers publish events to a channel or broker and consumers react. The producer need not know every consumer. This can support fan-out, asynchronous work, and independent evolution. It also hides control flow from a normal call stack and makes ordering, duplicate delivery, replay, schema changes, and eventual consistency part of the design.

Two common topologies are:

- **Broker topology:** producers publish and interested consumers react. It is highly decoupled, but no central coordinator owns the progress of a multi-step business transaction.
- **Mediator topology:** a mediator directs the workflow and tracks progress. It makes a multi-step process easier to observe and recover, but centralizes logic and can become a coupling point or bottleneck.

Use correlation IDs, define event ownership and schema compatibility rules, and decide how poison messages are quarantined and retried. Avoid putting secrets or unnecessary personal data in a broadly distributed event. If updating a database and publishing an event must not get out of sync, the transactional outbox pattern is one common option. It stores the event to be published in the same database transaction as the business change; a separate publisher delivers it later, so consumers still need idempotency.

Microsoft's event-driven architecture guide covers broker and mediator topologies, delivery, schema evolution, observability, and security concerns. [Event-driven architecture style](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven)

## 10. Publish-subscribe, queues, and streams

**Publish-subscribe** describes a communication model: publishers send to a topic or channel, and subscribers receive the events they are interested in. It reduces direct knowledge between producers and consumers, but it does not remove the need to define message ownership, security, retention, and delivery guarantees.

A **work queue** usually distributes each job to one worker in a consumer group; acknowledgement and redelivery behavior depend on the broker. A **retained stream or log** preserves ordered records for a period and lets multiple consumer groups keep independent offsets. Products can combine features, so compare their actual delivery, ordering, replay, retention, and partitioning semantics instead of assuming that every queue or stream behaves the same way.

Do not promise "exactly once" end-to-end just because a broker offers a feature with that name. A message might be delivered more than once, or a consumer might commit its database change and fail before acknowledging the message. Idempotent processing and a clear transaction boundary remain important.

Example event envelope:

```json
{
  "type": "OrderPaid",
  "orderId": "ord-1042",
  "occurredAt": "2026-11-10T09:00:00+03:30",
  "schemaVersion": 1,
  "correlationId": "checkout-7d91"
}
```

Before shipping an event contract, identify its business owner, versioning policy, partition key, retry and dead-letter path, idempotency strategy, retention period, and data classification. A queue can also decouple a web request from a slow job. This Web-Queue-Worker arrangement improves responsiveness only if queue lag, capacity, retries, and user-visible job status are handled.

## 11. Real-world evidence: two different workloads

### Prime Video's monitoring service

In a 2023 engineering report, Prime Video's Video Quality Analysis team described a **specific audio/video monitoring service**. Its first design used distributed serverless components, including orchestration and data passing between components. The team reported that orchestration and transfers became costly and constrained the service's target scale. It moved those components into a process deployed on EC2/ECS, then replicated the application with different detector subsets as capacity needs grew. The team reported infrastructure cost falling by more than 90% for this service.

The transferable lesson is to measure the work and the cost of its boundaries. The report does not show that Prime Video replaced its whole platform, or that monoliths always outperform microservices. It describes one tightly related workload where in-process data transfer and simpler orchestration fit the measured bottleneck. The original Prime Video Tech page now redirects; a saved copy of the report is available [here](https://www.wudsn.com/productions/www/site/news/2023/2023-05-08-microservices-01.pdf).

### Shopify's modular Rails monolith

Shopify's 2020 engineering follow-up describes a different challenge: sustaining modular boundaries inside a very large, continuously changing Rails codebase. The team discusses components, tooling, developer ownership, and the human effort required to change everyday design habits. This case shows that a monolith can have intentional internal architecture and can require long-term governance. It is not a benchmark comparing Shopify's full platform against every microservice system. [Under Deconstruction: The State of Shopify's Monolith](https://shopify.engineering/shopify-monolith)

Together, these reports support a useful practice: select and revise boundaries using workload measurements, delivery needs, team ownership, and operating cost. Do not infer the architecture of an entire company from the account of one subsystem.

## 12. A practical selection method

Start from the pressure the system actually has. Write down:

1. **Domain and change:** Which capabilities and rules change together? Which changes need separate ownership?
2. **Quality attributes:** What are the required latency, availability, throughput, security isolation, and recovery behavior?
3. **Workload shape:** Is work interactive, batch, streaming, compute-heavy, or a mix?
4. **Team and operations:** Can the organization build, deploy, observe, secure, and support multiple services reliably?
5. **Failure and data:** Which operations must be atomic? Where is stale data acceptable? How will failed work be retried or repaired?
6. **Smallest adequate structure:** Could modules, a worker queue, or a separate deployment solve the observed problem before introducing more boundaries?
7. **Evidence for change:** What metric, ownership conflict, deployment constraint, or failure mode would justify a future extraction?

| Current pressure | Candidate to evaluate | Evidence and costs to examine |
| --- | --- | --- |
| Small product, one team, simple domain | Simple monolith | Release simplicity, code ownership, and whether modular boundaries are already useful |
| Growing codebase with one release cadence | Modular monolith or component-based design | Dependency rules, team ownership, test scope, and whether the boundaries hold |
| Independent capabilities and teams with proven need | Services or microservices | Separate release/scale value versus network, data, security, debugging, and on-call cost |
| Long-running or resource-heavy background work | Web-Queue-Worker | Queue lag, retry policy, idempotency, backpressure, and status reporting |
| One event must trigger several independent reactions | Event-driven publish-subscribe | Delivery, ordering, schema evolution, privacy, traceability, and repair workflow |
| Nodes must exchange resources without a central coordinator | Peer-to-peer | Discovery, trust, membership changes, abuse, and consistency |

Record the choice and its consequences in an architecture decision record (ADR). A good ADR says what problem is being solved, which alternatives were considered, why the selected option fits the constraints, and what evidence would cause the team to revisit it.

## 13. Worked exercise: an online store

**Scenario:** One team operates an online store with a few thousand orders per day. Pricing rules are simple. A nightly report occasionally takes ten minutes. The team proposes migrating to microservices because it expects future growth.

**Reason through the decision:**

- Current scale alone does not reveal a need for independently deployed services. First ask whether the application is slow, unavailable, difficult to change, or blocked by team ownership.
- The ten-minute report is long-running background work. It is a separate workload from the interactive checkout request.
- If the codebase is becoming hard to change, establish modules for capabilities such as catalog, ordering, and payment, with explicit contracts and data ownership.
- A queue and worker can execute the report outside the HTTP request. Show the requester that the job is queued, expose its status, and make repeated jobs safe.
- Keep an audit of latency, error rate, queue lag, report runtime, deployment coupling, and module dependencies. Review these measures as traffic and team structure evolve.

**Suggested initial design:** A modular monolith for the transactional store plus a worker queue for the report. Extract a capability only when evidence shows that independent scaling, release, security isolation, or ownership is worth the extra operational and distributed-systems complexity. If a module later becomes a service, define its API, data ownership, timeout/retry behavior, observability, and migration plan before moving production traffic.

## 14. Answered quiz

1. **Does “monolith” mean the source code has no modules?**
   **Answer:** No. It describes a deployable application unit. A modular monolith intentionally enforces boundaries inside that unit.

2. **What is the difference between a layer and a tier?**
   **Answer:** A layer groups logical responsibility; a tier is a physical or deployment boundary. Several layers may run in one tier, and one layer may be deployed across several instances.

3. **When can a component have a strong boundary without being a service?**
   **Answer:** When it has a restricted API, controlled dependencies, tests, and ownership inside one process. A separate deployment is only one possible kind of boundary.

4. **Why can a successful timeout still leave an uncertain business outcome?**
   **Answer:** The server may have completed the operation but its response may have been lost. The caller should use an idempotency key or reconciliation rather than blindly repeating a non-idempotent command.

5. **How does an event differ from a command?**
   **Answer:** An event records a past fact; a command asks for an action. `OrderPaid` reports a completed fact, while `CapturePayment` requests work.

6. **What distinguishes a queue from a retained stream in the common case?**
   **Answer:** A queue commonly assigns work among competing consumers; a retained stream preserves records and positions so independent consumer groups can read or replay them. Product-specific semantics must be checked.

7. **Does “at-least-once delivery” mean the consumer will see each message only once?**
   **Answer:** No. Redelivery is possible. Consumers should make side effects idempotent or otherwise control the transaction and deduplication boundary.

8. **What extra problem does a mediator solve, and what does it cost?**
   **Answer:** It can coordinate a multi-step workflow and track recovery, but it centralizes control and can become a coupling point or bottleneck.

9. **What did the Prime Video report establish?**
   **Answer:** The team reported a large cost reduction after redesigning one audio/video monitoring service for its workload. It did not establish that the whole Prime Video platform became a monolith or that the same choice is best for other workloads.

10. **Name three kinds of evidence that could justify extracting a module into a service.**
   **Answer:** Examples include a proven independent scaling bottleneck, frequent release conflicts between teams, a security or availability boundary, or an ownership boundary that cannot be maintained inside the monolith. The team must compare the benefit with network and operating costs.

## Optional further reading

### English

- [Microsoft Azure Architecture Center — Architecture styles](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/) — Style constraints, common workloads, benefits, and challenges.
- [Microsoft Azure — N-tier architecture style](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/n-tier) — Logical layers, physical tiers, deployment, and trade-offs.
- [Microsoft Azure — Event-driven architecture style](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) — Broker and mediator topologies, delivery risks, and observability.
- [AWS Well-Architected — Choose how to segment your workload](https://docs.aws.amazon.com/wellarchitected/latest/framework/rel_service_architecture_monolith_soa_microservice.html) — Segmentation decisions and their resilience and operating costs.
- [AWS Prescriptive Guidance — Cloud design patterns](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/) — Outbox, saga, circuit breaker, retry, strangler, and other distributed-system patterns.
- [AWS Prescriptive Guidance — Choosing a coordination approach](https://docs.aws.amazon.com/prescriptive-guidance/latest/modernization-integrating-microservices/choosing-approach.html) — Choreography, orchestration, and saga coordination.
- [Martin Fowler and James Lewis — Microservices](https://martinfowler.com/articles/microservices.html) — Characteristics, prerequisites, and trade-offs of service decomposition.
- [Google SRE Book — Addressing Cascading Failures](https://sre.google/sre-book/addressing-cascading-failures/) — Overload, retries, resource exhaustion, and failure propagation.
- [Shopify Engineering — Under Deconstruction](https://shopify.engineering/shopify-monolith) — A company's account of evolving boundaries in a large Rails monolith.
- [Prime Video Tech — Monitoring service case study (saved copy)](https://www.wudsn.com/productions/www/site/news/2023/2023-05-08-microservices-01.pdf) — The original engineering report is mirrored as a PDF because its canonical page now redirects.

### Persian

- [DNTips — Layered Architecture, Part 2](https://www.dntips.ir/post/1261) — A Persian walkthrough of a domain-model layer.
- [DNTips — Software architecture article archive](https://www.dntips.ir/exports/tag/www.dntips.ir-tag-698.pdf) — A collection of Persian architecture articles, including modular and hexagonal discussions.
- [DNTips — Microservices discussion](https://www.dntips.ir/exports/news/www.dntips.ir-news-18871.pdf) — A Persian talk/article about microservice history and boundaries.
- [EventDrivenFarsi](https://github.com/gloonch/eventdrivenfarsi) — Persian introductions to events, Pub/Sub, Kafka, event sourcing, and CQRS.
- [Ali Rostami — Event-driven architecture style](https://www.alirostami.com/software-architecture/15-event-driven-architecture-style) — Persian chapter on broker and mediator event-driven architectures.
- [Virgool — When to use microservices (Persian translation/summary)](https://virgool.io/%40m_98739531/%D8%B3%D8%AE%D9%86%D8%B1%D8%A7%D9%86%DB%8C-when-to-use-microservices-and-when-not-to-sam-newman-martin-fowler-goto-2020-x8ctvunktqls) — A translated discussion of when microservices are and are not useful; compare it with the original talk.

For more references grouped by chapter, see the [course reference library](../../references.md#chapter-07).

</div>
