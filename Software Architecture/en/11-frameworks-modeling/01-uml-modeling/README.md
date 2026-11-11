# UML and Architecture Modeling

## Learning goals

- Choose a diagram type that answers a specific stakeholder question.
- Model context, components, interactions, and deployment without false precision.
- Keep diagrams useful through ownership, versioning, and review.

## Modeling is a communication tool

Unified Modeling Language (UML) provides standard notations for structural and behavioral views. Class diagrams show static types and relationships; sequence diagrams show ordered interactions; state machines show lifecycle transitions; activity diagrams show flows; deployment diagrams show runtime nodes and connections. A diagram is useful when a reader can answer a question from it, not because it follows a notation perfectly.

For software architecture, a small set of complementary views is usually clearer than one giant diagram. A system context view identifies users and neighboring systems. A container or component view shows major runtime responsibilities. A sequence view explains one critical scenario. A deployment view shows placement and network boundaries. Add legends and state what is intentionally omitted.

Use consistent names and distinguish logical dependency from network connection. Label important protocols, data ownership, trust boundaries, and asynchronous paths. Avoid showing every class or cloud icon when the audience needs a boundary and responsibility overview.

## Keeping models accurate

Make diagrams part of design review and release changes. Store source in text-based diagram formats when practical so changes can be reviewed. Derive what can be automated from code or infrastructure, but preserve human-reviewed intent and constraints. A stale diagram is worse than an honest statement that the view is conceptual.

## Worked example: order placement sequence

Show Browser -> API -> Order service -> database/outbox, then a message relay to inventory and payment coordination. Mark which calls are synchronous, where the transaction commits, and what event signals completion. This makes the dual-write problem and customer-visible pending state apparent.

## Self-check quiz

1. Which diagram emphasizes ordered calls over time? A sequence diagram.
2. What does a deployment diagram answer? Where software units run and how they connect at runtime.
3. Why label trust boundaries? They reveal where authentication, validation, and controls must change.
4. Should a diagram include every code class? Only if that detail helps the question and audience.
5. What makes an architecture diagram trustworthy? Clear scope, current ownership, meaningful labels, and update/review practices.

## Exercise

Create four views for online checkout: context, components, successful sequence, and deployment. Identify one important omission in each view.

### Sample answer

Context shows customer, store, payment provider, and fulfillment. Components show web, order, inventory, and payment coordination. Sequence marks the database commit/outbox then asynchronous handling. Deployment marks public edge, private workloads, database, broker, and external provider. State that fraud scoring internals, implementation classes, and exact capacity sizing are outside the current scope.

## Further reading

- English: [OMG UML specification](https://www.omg.org/spec/UML/), [C4 model](https://c4model.com/), [PlantUML language reference](https://plantuml.com/), [Structurizr documentation](https://docs.structurizr.com/), [arc42 documentation](https://docs.arc42.org/), [Simon Brown: The lost art of software design](https://www.infoq.com/presentations/software-design/)
- Persian: [DNTips architecture and UML articles](https://www.dntips.ir/), [Ali Rostami software architecture](https://www.alirostami.com/software-architecture/)
