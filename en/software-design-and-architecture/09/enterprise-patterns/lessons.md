<div dir="ltr" align="left">

# Full lesson: Enterprise application and data-access patterns
> **Language:** [Persian edition](../../../../fa/software-design-and-architecture/09/enterprise-patterns/lessons.md)
## Why these patterns matter

Enterprise applications often need to coordinate business rules, transactions, data storage, and communication with clients or other systems.
The patterns in this lesson help assign those responsibilities.
They are design options, not a checklist: applying every pattern to every feature adds indirection without necessarily improving the system.
Keep three models distinct when they serve different purposes:
- **Domain model:** business meaning, behavior, and invariants.
- **Persistence model:** the shape and constraints of stored data.
- **Transport or view model:** the data exposed by an API, user interface, or message.
A small, read-only feature may safely use one simple type for more than one role.
Separate models when the boundary protects a rule, security concern, independent change, or compatibility contract.
## 1. Data Transfer Object (DTO)

A DTO carries data across a boundary.
It is shaped for an API, UI, message, or remote call; it does not automatically represent a domain entity.
A DTO should expose only the fields a consumer needs, validate untrusted input at the boundary, and account for API versioning.

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class OrderSummaryDto:
    order_id: str
    total_cents: int
    currency: str
```

Returning an ORM entity or an entire object graph from an API can expose internal relationships, sensitive fields, or lazy-loading behavior.
DTOs also cost mapping code and can drift from the domain model.
Use separate types when that isolation has a clear benefit; do not duplicate every class automatically.
## 2. Identity Map

An Identity Map ensures that one persistent identity corresponds to one in-memory object within a defined unit of work or session.
If the same `CustomerId` is loaded twice during a transaction, the application sees the same tracked instance rather than two conflicting mutable copies.
Many ORMs provide identity tracking within a context or session.
This is not a general-purpose shared cache.
Keep its lifetime bounded, and understand how refresh, concurrency, and transaction boundaries work.
A global cache has separate invalidation, stale-data, and race problems.
## 3. Use Case (Application Service)

A use case coordinates one visible application goal, such as placing an order, refunding a payment, or cancelling a reservation.
It defines an input and outcome and may coordinate authorization, transaction boundaries, domain behavior, persistence, and messaging.
The use case should not become an unstructured script that owns every business rule.
Let domain objects or policies protect invariants, while the use case coordinates the steps.
Keep infrastructure dependencies behind explicit interfaces so failures and retries can be handled deliberately.
## 4. Repository

A repository presents a collection-like interface for retrieving and storing domain objects, often aggregates.
It hides the details of persistence from the application or domain consumer.

```text
OrderRepository:
  get(order_id)
  save(order)
```

The point is to express the operations the use case needs, not to create generic CRUD methods for every database table.
A repository does not automatically replace transaction management, an ORM, or a query model.
Make the unit-of-work and commit boundary explicit.
## 5. Data Mapper

A Data Mapper translates between domain objects and storage structures while keeping the two models from depending on each other's details.
An ORM may implement this pattern.
The domain model should not have to mirror the database schema merely because the persistence technology uses tables and columns.
Mapping can lose meaning or introduce errors around null values, relationships, time precision, money, and identity.
Test important mappings and inspect the queries they cause.
Automated mapping tools reduce repetitive code but do not replace an understanding of the contract.
## 6. Transaction Script

A Transaction Script organizes the logic for a use case in a procedure that controls one transaction.
It is straightforward for simple CRUD or a small number of rules, such as recording a payment and updating a status atomically.
When several scripts copy the same rules or enforce invariants differently, consider moving behavior into a domain model or policy.
The reverse also matters: a simple form with few rules does not need a complex aggregate just because a pattern book contains one.
Let the number and rate of change of the rules guide the design.
## 7. Command-Query Separation

Command-Query Separation (CQS) is the principle that an operation should either change state or return information, not do both in a surprising way.
A command requests a state change and may return an identifier or outcome.
A query returns information without changing domain state.
CQS is not the same as CQRS.
CQS can be a local design rule in one class or API.
CQRS deliberately separates the models used to write and read.
A query should not hide a business mutation under the name of a read.
Technical effects such as request logging do not turn every query into a domain command.
## 8. Value Object

A value object is defined by its value and meaning rather than an independent identity.
Money is not just a decimal amount: amount and currency jointly define its meaning.
Value objects are commonly immutable so equality and hashing do not change unexpectedly.

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class Money:
    amount_cents: int
    currency: str

    def add(self, other: "Money") -> "Money":
        if self.currency != other.currency:
            raise ValueError("Currencies must match")
        return Money(
            self.amount_cents + other.amount_cents,
            self.currency,
        )
```

Domain-specific types add mapping and serialization work.
Create one when it protects meaning, validation, operations, or an invariant; a type for every ordinary string may make the model harder to use.
## 9. Domain Model and Entity

A domain model keeps important business behavior and rules close to the concepts that own them.
An entity has a stable identity and lifecycle.
Its identity remains the same when changeable attributes change: a customer who changes an email address is still the same customer.
An aggregate root protects consistency inside an aggregate and provides the controlled entry point for changes.
A read model does not have to be the same shape as the write-side entity.
A domain event such as `OrderPaid` records a business fact; it is not merely a log line that says a function ran.
A behavior-light model may be appropriate for simple CRUD.
When rules such as withdrawal limits, discount eligibility, or cancellation policy change frequently, keeping behavior with the domain owner helps different callers enforce the same invariant.
## 10. Object-Relational Mapper (ORM)

An ORM maps objects and relationships to relational rows and often provides query construction, identity tracking, unit-of-work behavior, and transaction integration.
It can reduce repetitive persistence code, but it does not erase the differences between an object graph and a relational database.
Common risks include:
- **N+1 queries:** one query loads a list, followed by a separate query for each item.
- Lazy loading that happens after the intended transaction or request boundary.
- Stale tracked state or unexpected identity-map behavior.
- Long transactions, locks, or concurrency surprises.
- Domain code becoming coupled to ORM base classes, attributes, or lifecycle hooks.
- An entity graph that is a poor fit for a large report or read-heavy projection.
Inspect generated SQL, query plans, transaction isolation, and indexes.
A projection or direct SQL can be clearer for a report.
Treat the ORM as a persistence tool, not as the architecture of the whole application.
## 11. End-to-end order placement

Consider an order endpoint:
1. The HTTP request is parsed into a request DTO or `PlaceOrder` command.
2. A use case checks the caller's authorization and coordinates the operation.
3. A repository loads or creates the `Order` aggregate.
4. The domain model enforces item, amount, and status invariants.
5. A `Money` value object enforces currency and arithmetic rules.
6. A mapper or ORM persists the model inside the transaction.
7. The API returns an `OrderReceipt` DTO with only the public order number and final total.
8. A query projection can provide a separate summary for dashboards.
If every step merely forwards data without enforcing a contract or isolating a change, reduce the number of abstractions.
Keep a boundary when it has a clear responsibility and a meaningful contract.
## 12. Answered quiz

1. **How does a DTO differ from an entity?**
   **Answer:** A DTO carries data across a boundary.
An entity has identity and lifecycle and may enforce domain behavior.
2. **How long should an Identity Map usually live?**
   **Answer:** Within a bounded session or unit of work.
It should not be confused with an unlimited shared cache.
3. **What does a Repository help with, and what does it not guarantee?**
   **Answer:** It gives consumers a persistence-facing contract for domain objects.
It does not automatically define transactions or make every table need a repository.
4. **When can a Transaction Script be a good choice?**
   **Answer:** When a use case has a small set of clear rules and a transaction boundary, without complex invariants shared across many workflows.
5. **Why is `Money` a useful value object?**
   **Answer:** Its meaning depends on both amount and currency, so it can enforce valid arithmetic and equality rules.
6. **Why is an entity not identified by all of its fields?**
   **Answer:** Many fields change during its lifecycle; stable identity is represented by its identifier.
7. **What does an ORM not remove?**
   **Answer:** The need to understand query plans, transactions, relational behavior, N+1 queries, and mapping costs.
8. **When might a separate DTO not be worth its cost?**
   **Answer:** When a model is simple, read-only, and has no meaningful security, compatibility, or independent-change risk.
Reassess as those risks grow.
## Comprehensive exercise: design order placement

Design the boundary and model for an order-placement endpoint.
The HTTP request contains a customer identifier and line items.
The order must be stored in a valid state, and the response should expose only the order number and final total.
1. Distinguish the request DTO, command, entity, and value object.
2. Assign responsibilities to the use case, repository, and transaction.
3. Decide where authorization, validation, and mapping occur.

**Worked answer:** The request DTO represents untrusted transport input.
Boundary validation checks its shape and converts it to a `PlaceOrder` command.
The use case authorizes the caller, loads the required products, and coordinates the transaction.
The `Order` entity enforces status and quantity rules; `Money` protects amount and currency behavior.
The repository persists the aggregate through an ORM or mapper, and the unit of work commits the change.
Return an `OrderReceipt` DTO rather than serializing the entity.
If the rules are only a few simple steps with no meaningful invariants, a transaction script may be sufficient; move behavior into a richer domain model as the rules require it.
## Optional further reading
### English

- [Martin Fowler — Catalog of Enterprise Application Patterns](https://martinfowler.com/eaaCatalog/index.html) — Pattern definitions and related discussions.
- [Martin Fowler — Data Transfer Object](https://martinfowler.com/eaaCatalog/dataTransferObject.html) — The role of DTOs across process boundaries.
- [Martin Fowler — Identity Map](https://martinfowler.com/eaaCatalog/identityMap.html) — Maintaining object identity within a business transaction.
- [Martin Fowler — Repository](https://martinfowler.com/eaaCatalog/repository.html) — A collection-like persistence boundary.
- [Microsoft Learn — DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice) — Domain model, application layer, and persistence responsibilities.
- [Microsoft Learn — Tactical Domain-Driven Design](https://learn.microsoft.com/en-us/azure/architecture/microservices/model/tactical-domain-driven-design) — Entities, value objects, aggregates, and repositories.
- [Microsoft Entity Framework Core — Efficient querying](https://learn.microsoft.com/en-us/ef/core/performance/efficient-querying) — Query shape, indexes, and common performance costs.
### Persian

- [Persian DDD guide](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — Domain modeling terminology and examples in Persian.
- [Intelligent Software Engineering Lab — Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian materials on design and enterprise patterns.
For additional references grouped by chapter, see the [course reference library](../../references.md#chapter-09).

</div>
