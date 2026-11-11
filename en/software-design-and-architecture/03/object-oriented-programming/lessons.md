<div dir="ltr" align="left">

# In-depth lesson: Object-oriented programming and modeling

> **Language:** [Persian edition](../../../../fa/software-design-and-architecture/03/object-oriented-programming/lessons.md)

This guide connects the topics in the object-oriented programming chapter: the OOP paradigm, its core ideas, language features, domain modeling, class variants, and layering. Individual topic notes are also available in the `topics` folder; this lesson provides one integrated, self-contained path.

## Prerequisites and goals

You should be familiar with variables, functions, conditions, data structures, and function calls. The goal is not to turn every concept into a class. It is to decide where state and rules belong, how contracts should be designed, and which mechanism best expresses the variation a system needs.

After studying this lesson, you should be able to:

- Distinguish a class, object, value, and entity with examples.
- Apply the four core OOP ideas where they solve a real problem.
- Choose among interfaces, abstract classes, and concrete classes.
- Separate a domain model from a database schema.
- Choose between a rich domain model and a behavior-light model based on the rules involved.
- Describe the dependency direction among domain, application, presentation, and infrastructure code.

## 1. What is a paradigm, and what does OOP help organize?

A programming paradigm is a way to organize computation, state, and control flow. Procedural code emphasizes sequences of operations and functions. Functional code emphasizes value transformations and controlled effects. Object-oriented code groups related state and behavior behind objects. Declarative code describes the result wanted and leaves more of the execution strategy to an engine or framework.

These styles are not rigid walls. A system can use a pure function to calculate a price, an object to protect an order's lifecycle, and a use case to coordinate the workflow. Use the style that makes each responsibility easiest to understand.

A **class** defines a type and its possible operations. An **object** is a runtime instance of that type. Depending on the domain, an object may have:

- **State:** values that can vary during its lifetime.
- **Behavior:** operations it can perform on its state or inputs.
- **Identity:** a way to recognize that it is the same business object even when some attributes change.
- **A contract:** behavior that consumers are entitled to rely on.

An object is not merely a bag of data. If every caller can change any field, business rules spread across the application. But an object is not always needed: a read-only record or a simple calculation may be better represented by a data value or function.

## 2. Four core OOP ideas

### Encapsulation

Encapsulation controls direct access to state so that **invariants** remain true. An invariant is a condition that must hold before and after every valid operation. For a bank account, the balance after a withdrawal must not fall below the permitted credit limit.

Write down the invariant, restrict unrestricted setters, provide domain operations, and make those operations the only way to perform state transitions. When practical, make invalid states impossible to construct.

```python
class Account:
    def __init__(self, balance_cents, credit_limit_cents=0):
        self._balance = balance_cents
        self._credit_limit = credit_limit_cents

    def withdraw(self, amount_cents):
        if amount_cents <= 0:
            raise ValueError("Amount must be positive")
        if self._balance - amount_cents < -self._credit_limit:
            raise InsufficientFunds()
        self._balance -= amount_cents
```

A private field is not enough if another method changes the value without checking the invariant. For mutable collections, also avoid exposing an internal collection reference that callers can mutate.

### Abstraction

Abstraction presents the contract a consumer needs and hides irrelevant detail. An order use case may need to reserve a product; it does not need to know how a database connection or SQL query works.

Derive the abstraction from the consumer's needs: what operation is required, what results and failures can occur, and what details should remain hidden? If an API still exposes an ORM entity or a vendor's raw exception, the boundary may be leaking implementation details.

Not every interface is valuable. With one implementation, no testing seam, and no expected change boundary, an interface may add indirection without protecting anything. A useful abstraction limits a real change; a speculative abstraction guesses about the future.

### Inheritance

Inheritance can express a type relationship, reuse behavior, and enable subtype polymorphism. “I want to reuse some code” is not by itself a sound reason to create a subtype. From a consumer's perspective, the subtype must preserve the behavioral contract of the base type.

If a subtype disables a base operation, requires stronger preconditions, or changes the meaning of a result, it may not be a valid substitute. Subclasses also depend on base-class implementation details, hook order, and protected APIs; a base-class change can break subclasses owned by another team.

Consider the rectangle/square example. A square is mathematically a kind of rectangle, but if a `Rectangle` contract promises that width and height can change independently, a square cannot preserve that behavior. A shared concept does not automatically make a correct subtype relationship.

When behavior varies along several independent dimensions, composition is often clearer. An order can receive a `DiscountPolicy`; there is no need for a subclass for every combination of customer and campaign.

### Polymorphism

Polymorphism lets a consumer work with a shared contract while the concrete implementation supplies the behavior. Subtype polymorphism uses interfaces or base types; parametric polymorphism uses generics; some languages also dispatch through overloads or pattern matching.

```python
from typing import Protocol

class DiscountPolicy(Protocol):
    def apply(self, subtotal_cents: int) -> int: ...

def checkout(subtotal_cents, policy: DiscountPolicy):
    return policy.apply(subtotal_cents)
```

This can reduce scattered branches when discount algorithms are genuinely replaceable. If only one policy exists and no independent change is expected, a direct function may be simpler. When several implementations share a contract, use contract tests to verify their common behavior.

## 3. Language features: interfaces, abstract classes, concrete classes, and visibility

### Interfaces

An interface describes a capability. For example, `PaymentAuthorizer` states what the consumer needs from a payment integration. Design it around the consumer's job, not the entire vendor SDK. A large interface containing payment, refund, reporting, and configuration operations can force consumers to depend on methods they do not use; smaller role-based contracts may be clearer.

### Abstract classes

An abstract class cannot be instantiated directly. It may provide shared implementation or define a template algorithm. Template Method can fit when the sequence is stable and one step varies. If subclasses need to change the sequence or behavior varies on several independent axes, composition usually creates less coupling.

### Concrete classes

A concrete class fully implements a contract and can be instantiated. A `StripeGateway` may be a concrete adapter for a payment contract. Configure critical dependencies in a composition root or factory instead of making many callers construct a real provider directly. Do not create an interface solely because there might someday be another implementation.

### Scope and visibility

**Scope** determines where a name is valid in a language: a block, function, module, or global scope. **Visibility** determines who can access a member: private, protected, package/internal, or public. They are related but not identical concepts.

Start with the least visibility required. A public member becomes a supported external contract and may constrain future changes. Protected members are also APIs for subclasses. Mutable global state makes changes hard to trace; immutable constants are less risky.

## 4. Domain modeling and shared language

A domain model is not a storage schema. It represents the concepts, behavior, relationships, and rules of the problem space in software. Discover it by discussing real workflows, exceptions, human decisions, and consequences with domain experts rather than starting from a list of database tables.

### Ubiquitous Language

Terms should have consistent meaning in conversation, code, APIs, tests, and documentation. “Cancel an order,” “refund a payment,” and “return an item” are different operations. Calling all three `cancel` makes it difficult to manage shipping, money, and inventory correctly.

Keep a short glossary, but do not let it become a dead document. Include examples and counterexamples. If two parts of a business use the same word with different meanings, consider separate bounded contexts and make the translation between them explicit.

### Rich domain model and behavior-light model

A rich model keeps state and rules close together. It is useful when important invariants are complex or change often. A behavior-light model represents mostly data while services contain operations; for simple CRUD, reporting, or data transfer, that can be cheaper and correct.

A behavior-light model becomes a problem when:

- The same rule is repeated in several handlers.
- Callers read state, decide what is allowed, and then call setters.
- Invalid transitions are possible through some code paths.
- Different services produce different outcomes for the same concept.

In those cases, identify who owns the invariant and move behavior to that owner. Do not label every data record an anti-pattern; evaluate the actual complexity.

### Entity, value object, and class variants

An entity is recognized by a stable identity and lifecycle. A customer who changes their email still has the same `CustomerId`. A value object is defined by its value: `Money(100, USD)` equals another `Money(100, USD)`, but not `Money(100, EUR)`. Value objects are often immutable and validate their invariants when constructed.

Model variants so invalid combinations are hard to represent. Two Boolean flags produce four combinations, even if only one is valid. Choose an enum, tagged union, subclass, or composition based on the number of states, their independent behavior, and the likely direction of change. More classes do not automatically make a better model.

## 5. Layering and dependency direction

A common logical arrangement is:

1. **Presentation:** adapts HTTP, UI, or message input and output.
2. **Application:** coordinates use cases and manages transaction boundaries.
3. **Domain:** owns business concepts and invariants.
4. **Infrastructure:** connects databases, brokers, and external providers.

These layers do not need separate processes or deployments. The key is to control dependencies: the domain should not depend on a web framework or ORM; external adapters implement contracts needed by application or domain code. Runtime calls may flow outward, while source-code dependencies point inward toward stable policy.

```text
HTTP controller -> application use case -> domain model
Infrastructure adapter implements a domain/application port
```

A small CRUD application may not need every layer. Compare the mapping and boilerplate cost with the benefits of testability, rule independence, and easier change. A useful boundary protects a real change; folders alone do not create architecture.

## 6. Integrated example: place an order

1. A controller parses the JSON and rejects malformed transport input.
2. `PlaceOrder` is an application use case that coordinates inventory, payment, and persistence.
3. `Order` owns its line items and status; operations such as `mark_paid` and `cancel` enforce valid transitions.
4. `Money` represents an amount and currency and rejects invalid arithmetic across currencies.
5. `PaymentAuthorizer` expresses the capability the use case needs; a vendor adapter translates provider responses and errors into application outcomes.
6. `OrderRepository` defines the persistence contract; an infrastructure adapter stores the order in the selected database.
7. Unit tests check `Order` and `Money` rules without a database; integration tests check the transaction and persistence contract.

## 7. Common decisions and mistakes

| Choice | Useful when | Risk or limitation |
| --- | --- | --- |
| Inheritance | A subtype preserves the base contract and the hierarchy is stable. | Tight coupling to the base type and fragile overrides. |
| Composition | Behaviors vary independently or must be selected at runtime. | More collaborators and wiring to understand. |
| Rich domain model | Rules and invariants are complex or change often. | Overengineering for simple CRUD. |
| Behavior-light model | Data is simple and operations are limited. | Complex rules become scattered among services. |
| Interface | A real change, testing, or multiple-implementation boundary exists. | Artificial or oversized contracts add indirection. |
| Layering | Dependency direction and responsibilities are unclear or risky. | Mapping and pass-through layers can add cost without value. |

Common mistakes include making a class for every noun, putting every behavior in a service, inheriting only to reuse a few lines, creating an interface for every concrete type, exposing public setters that bypass invariants, and forcing different bounded contexts to use one global `Customer` or `Order` model.

## 8. Comprehensive exercise

Choose an online store or a seat-reservation system:

1. Create a glossary of five domain terms and record ambiguous synonyms.
2. Identify its entities and value objects.
3. Write three invariants and the valid state transitions.
4. Separate use-case operations from queries.
5. Draw dependencies among the four logical layers.
6. Select one interface only where a meaningful boundary exists.
7. Design tests for a success case, invalid state, concurrent request, and provider failure.
8. Record in an ADR when you would choose a simpler model or a different architecture.

**Suggested answer:** For ordering, `Order` and `Customer` may be entities; `Money` and `OrderLine` may be value objects. A valid order might require at least one line, forbid changing a paid order, and allow cancellation only before shipment. A use case coordinates authorization, inventory, payment, and persistence. A query projection can serve order history without mutating the domain. Unit tests cover the invariants, a concurrency test checks duplicate placement or stock reservation, and adapter/integration tests check provider and database behavior. A simple transaction script remains an option if the real business rules are few and stable.

## 9. Comprehensive quiz with explanations

1. **Why can a public setter for an order's status be unsafe?**
   **Answer:** Any caller can create an invalid transition. The object that owns the state should provide domain operations that enforce its invariants.

2. **How do abstraction and encapsulation differ?**
   **Answer:** Abstraction selects the usable contract and hides irrelevant details. Encapsulation controls access to state so its invariants remain valid.

3. **When might a square not be a valid subtype of a rectangle?**
   **Answer:** When the rectangle contract allows width and height to change independently but a square must keep them equal. The square cannot preserve the base behavior expected by that consumer.

4. **Does every application need a rich domain model?**
   **Answer:** No. A simple CRUD feature may be clearer with records and a transaction script; complex stateful rules can justify a richer model.

5. **What makes an interface useful?**
   **Answer:** It expresses a real consumer need with a small, meaningful contract and clear outcomes, without leaking an SDK or ORM.

6. **When is composition preferable to inheritance?**
   **Answer:** When several independent behaviors must be combined or selected at runtime, especially when the subtype relationship does not preserve a base contract.

7. **Should an infrastructure adapter depend on a domain contract?**
   **Answer:** Yes. The adapter implements the stable contract used by application or domain policy; domain source code should not depend on framework details.

8. **How can a team recognize that a behavior-light model is causing problems?**
   **Answer:** Rules are duplicated, callers mutate state directly, and invariants are not guaranteed across all paths.

9. **Why is a glossary alone insufficient for shared language?**
   **Answer:** The language must appear consistently in operations, APIs, tests, conversations, and evolving documentation.

10. **What is the risk of using two Booleans for a class variant?**
   **Answer:** They create four combinations, some of which may be meaningless. An enum or tagged type can represent only valid combinations.

## Optional further reading

### English

- [Microsoft Learn — Object-oriented programming in C#](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — Classes, encapsulation, inheritance, and polymorphism.
- [Microsoft Learn — DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice) — Domain and application boundaries in a reference design.
- [Microsoft Azure — Tactical Domain-Driven Design](https://learn.microsoft.com/en-us/azure/architecture/microservices/model/tactical-domain-driven-design) — Entities, value objects, aggregates, and bounded contexts.
- [Oracle Java Tutorials — Object-oriented concepts](https://docs.oracle.com/javase/tutorial/java/concepts/) — Classes, objects, inheritance, interfaces, and packages.

### Persian

- [Object-Oriented Programming Handbook](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — Persian notes on OOP concepts.
- [Persian DDD guide](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — Domain modeling vocabulary and examples.
- [Intelligent Software Engineering Lab — Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian course material on object-oriented design.

For additional sources grouped by chapter, see the [course reference library](../../references.md#chapter-03).

</div>
