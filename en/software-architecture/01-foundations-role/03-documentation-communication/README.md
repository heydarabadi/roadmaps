# Architecture Documentation and Decision Communication

## Learning goals

- Choose a view for a specific audience and question.
- Distinguish structural diagrams, behavioral flows, and deployment views.
- Record decisions without creating a large, stale documentation burden.

## Core idea

Architecture documentation is a tool for thinking and coordination. An unlabeled diagram can mislead; a detailed document that nobody uses has maintenance cost without value. Each view should answer a question, define its scope, and stay aligned with the system.

## Views and models

- **C4:** system context, deployable or executable containers, components, and optionally code. A C4 “container” is not necessarily a Docker container; it could be a web app, worker, database, or process.
- **UML:** conventional structural or behavioral models such as sequence, component, and deployment diagrams.
- **Flow diagram:** the path of an order, error handling, or a delivery process.
- **Deployment view:** runtime location, network, replication, external dependency, and failure domain.
- **ADR:** a decision record containing context, problem, options, decision, consequences, and status.

For each view, state its purpose, audience, scope, connector semantics, and owner. If the code and view change together, storing the view near the code and reviewing it with the pull request can help.

| View | Question answered | Typical audience |
| --- | --- | --- |
| C4 Context | Who uses the system and which external systems does it contact? | Product, architects, dependent teams |
| C4 Container | Which runtime applications and data stores exist, and how do they communicate? | Engineering, platform, operations |
| Component | Which responsibilities are inside one runtime application? | The owning team |
| Sequence | What happens on a successful or failed request? | Engineering, QA, on-call |
| Deployment | Where does each part run and where are network or failure boundaries? | Cloud, platform, security |

## Build a readable diagram

1. Write a purpose statement, such as “This diagram shows checkout through the payment callback.”
2. Define the system boundary and what stays outside it.
3. Name elements by role and responsibility, not only by vendor.
4. Label connectors with protocol, data, and direction.
5. Show important failure paths; success is not the only real path.
6. Add a legend, owner, and review date.
7. Ask a teammate to read it. If every arrow needs a verbal explanation, the diagram needs refinement.

## Architecture as concise text

A short description can sometimes be clearer than a diagram:

~~~text
System: Online store
Actors: Customer, support team, finance
Boundary: Order creation, payment attempt, order status; the bank network is outside
Data ownership: Checkout owns orders; PaymentAttempt owns payment attempts
Communication: HTTPS initiation; signed callback; outbox for internal notification
Failure rule: timeout does not mean payment rejection; status stays pending verification
~~~

This does not replace an API contract, security model, or runbook. It provides shared vocabulary and a starting point.

## Architecture Decision Records

An ADR documents one architecture decision. Context explains why the decision arose; options explain reasonable alternatives and their costs; the decision states what was selected; consequences state benefits, costs, and remaining risks. Status can be proposed, accepted, rejected, or superseded. Do not erase a superseded decision: update its status and link to the replacement so the history remains understandable.

Do not turn an ADR into a hundred-page design document. Split distinct choices into related records. For a temporary and easily reversible local decision, a code comment or pull-request rationale may be sufficient.

~~~markdown
# ADR-004: Durable queue for background invoice generation

Status: Accepted

## Context
Invoice generation must not block the order-creation response.

## Options
Run synchronously; use a durable queue; schedule a batch.

## Decision
Write an order-created event to an outbox, then publish it to a queue.

## Consequences
Faster request acceptance; eventual processing; deduplication and lag monitoring required.
~~~

## Worked example: an on-call guide

During a payment-provider outage, on-call staff need to know the request path, timeout point, service owner, degraded-mode behavior, and how to find orders with unknown payment status. A high-level C4 view, payment sequence, retry ADR, and runbook are more useful than one generic colorful diagram.

## Choose the right level of formality

| Context | Useful approach |
| --- | --- |
| Small, fast-moving team | Architecture README, C4 views, short ADRs |
| Several teams with shared contracts | Service catalog, schemas, SLOs, owners, ADRs |
| Regulated system | Approval trail, source requirement, control, and test evidence |

## Common pitfalls

- One diagram reused for executives, developers, and operations.
- Recording technology without recording why it was selected and its consequences.
- A document that is never updated after its first release.
- Showing every class while hiding important system boundaries.
- Using “real time” without defining latency and data freshness.

## Self-check quiz

1. **Why are C4 context and container views often enough to start?** They answer where the system sits and what its runtime parts and connections are; add detail when a real question requires it.
2. **What distinguishes an ADR from general technical documentation?** It records a particular choice and rationale, then tracks consequences and status.
3. **Which view helps investigate a payment timeout?** A sequence or flow showing external boundaries, timeout, retry, and failure paths, paired with a structural view.
4. **How can documentation become less stale?** Keep it near the code, assign an owner, review it with relevant changes, and use diagram-as-code where helpful.
5. **Why preserve rejected options?** They explain the trade-off and prevent the team from repeating the same analysis without new evidence.

## Exercise

For an order-registration application, create a context view, a payment sequence, and an ADR choosing synchronous API or queue communication. State the audience and question for each.

### Sample answer

The context view shows customer, store, payment provider, and carrier. The sequence includes order creation, authorization, callback, duplicate callback, and timeout with each actor’s state. An ADR may select a queue for notification and reporting because checkout should not wait on those side effects. Payment initiation may remain synchronous until the outcome becomes uncertain, after which a persistent state and reconciliation flow are required. Label owners and failure paths on every view.

## Further reading

- Persian: [Persian C4 guide](https://www.cybermedian.com/fa/the-c4-model-a-comprehensive-guide-to-visualizing-software-architecture/), [Software architecture fundamentals](https://www.alirostami.com/software-architecture/)
- English: [C4 diagrams](https://c4model.com/diagrams), [C4 introduction](https://c4model.com/introduction), [GOV.UK ADR Framework](https://www.gov.uk/government/publications/architectural-decision-record-framework), [ADR tooling](https://adr.github.io/adr-tooling/), [Structurizr documentation](https://docs.structurizr.com/), [arc42 documentation template](https://arc42.org/overview)

