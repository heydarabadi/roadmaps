# Domain and Data-Access Patterns

## Learning goals

- Recognize patterns for persistence, transactions, requests, and session state.
- Understand how patterns such as Repository, Unit of Work, and DTOs shape boundaries.
- Avoid using patterns where simpler code better expresses the domain.

## Core idea

Enterprise patterns provide shared vocabulary for separating domain models, data transfer, persistence, and use cases. Each pattern has a responsibility and a contract. Adding them without a need creates boilerplate and layers that protect no decision.

## Patterns

- **Entity:** an object with identity and a lifecycle.
- **Value Object:** a descriptive value without independent identity, such as Money with amount and currency.
- **Domain Model:** behavior and invariants close to the domain model.
- **Transaction Script:** a procedure implements a business operation; useful for simple domains and limited use cases.
- **Repository:** a collection-like interface for storing and retrieving aggregates; not necessarily a one-to-one wrapper around every table.
- **Data Mapper / ORM:** maps the domain model to storage schema; complex mapping and lazy loading can cause problems.
- **DTO:** a transfer shape at an API or process boundary; it need not match an Entity.
- **Identity Map:** prevents multiple in-memory objects for the same record inside a unit of work.
- **Command / Query:** separates a request to change from a request to read.
- **Use Case / Application Service:** coordinates a business flow; it should not accumulate every domain rule.

## Choosing Transaction Script or Domain Model

If a use case is simple—such as adding a favorite without multi-step invariants—a Transaction Script may be clearer and cheaper. If many behaviors affect one concept and rules must always hold together, a Domain Model can keep invariants near the data. One product can use both patterns in different areas.

## Boundaries in a request

1. **Controller/endpoint:** translates HTTP to an internal request and builds an HTTP response.
2. **Application service/use case:** coordinates the workflow and transaction boundary.
3. **Domain model:** applies rules and invariants.
4. **Repository/adapter:** hides query or external-connection details behind a boundary.
5. **DTO:** carries only data required by the external contract.

If an endpoint calculates price, queries storage, and publishes a message, changes and tests become difficult. If every line gets its own interface and class, the flow becomes hard to read. The target is a meaningful boundary.

## ORM and Identity Map

An ORM maps objects to records; a Unit of Work may gather changes to several objects in one transaction. Lazy loading can create hidden queries and N+1 behavior. Eager loading can load more data than needed. A projection or controlled query can be better for a read endpoint; a full Entity is not always required.

A DTO belongs to an external contract and usually needs versioning. An Entity belongs to domain identity and behavior. A persistence model represents storage. A simple project may choose to make them similar, but that is a deliberate choice, not a universal rule.

## Worked example: invoices

Money should keep amount and currency together so that adding incompatible currencies is difficult. Invoice is an Entity with an ID and status; each InvoiceLine has a value. An API DTO exposes only the fields the customer needs. A repository can load and save the aggregate. For a simple system, an ORM and a Transaction Script may be sufficient.

~~~text
HTTP DTO -> UseCase -> Invoice Aggregate -> Repository -> Database
                              |
                           Money value
~~~

| Pattern | Use it when | Watch for |
| --- | --- | --- |
| DTO | External contract must stay independent of internal models | Meaningless copying and mapping |
| Repository | Domain behavior and aggregate boundary justify abstraction | A generic repository for every table |
| Transaction Script | Rules are simple and local | Rules spread across repeated scripts |
| Domain Model | Invariants and behavior are complex | Anemic models that only hold data |

## Common pitfalls

- Returning a persistence Entity directly from a public API.
- Using a repository as a facade for unrelated queries.
- Building a rich domain model for a problem that is simple.
- Loading entire aggregates for read-only projections.

## Self-check quiz

1. **Why not return an Entity directly from an API?** It exposes internal rules and persistence shape and couples the external contract to implementation.
2. **What does a Value Object provide?** It centralizes meaning and value rules, such as comparing and calculating amounts with currency.
3. **When is a Transaction Script appropriate?** When rules are simple and flows limited, and a richer domain model would not reduce complexity.
4. **What should a good Repository hide?** Domain-model persistence and retrieval details, not every query in the entire system.
5. **Why are DTOs useful?** They let the external contract evolve independently of internal and persistence models.

## Exercise

Define PaymentAttempt, Money, CreatePaymentCommand, PaymentResponse DTO, and repository boundary. Show which changes should not break the public API.

### Sample answer

PaymentAttempt has identity, provider reference, state, and version. Money is a value with amount and currency. CreatePaymentCommand carries order ID and idempotency key. PaymentResponse contains only fields required by the public contract. PaymentGateway and Repository are internal ports. A provider switch or internal repository schema change should not break the customer API; externally visible state transitions and error mapping need separate versioning.

## Further reading

- Persian: [Persian DDD guide](https://github.com/hheydarian/Understanding-Domain-Driven-Design), [DNTips: DDD in practice](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-1406.pdf)
- English: [Martin Fowler: Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/), [Microsoft DDD and CQRS patterns](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/), [Fowler: Data Mapper](https://martinfowler.com/eaaCatalog/dataMapper.html), [Fowler: Unit of Work](https://martinfowler.com/eaaCatalog/unitOfWork.html)
