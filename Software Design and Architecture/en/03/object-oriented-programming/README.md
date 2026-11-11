<div dir="ltr" align="left">

# Chapter 03: Object-Oriented Programming and Modeling

> **Language:** [Persian edition](../../../03/object-oriented-programming/README.md)

> [Read the full integrated lesson](lessons.md) for step-by-step explanations, an order example, practice, and a comprehensive quiz.

## Learning goals

After this chapter, you should be able to:

- Model meaningful state and behavior without turning every piece of data into a class.
- Use encapsulation, abstraction, inheritance, and polymorphism to solve specific design problems.
- Choose between interfaces, abstract classes, and concrete classes.
- Distinguish entities and value objects and model a domain with a shared vocabulary.
- Choose a rich domain model or a behavior-light model based on the complexity of the rules.
- Keep dependencies pointed toward stable application and domain policy.

## Central idea

Object-oriented design groups related state and behavior behind contracts. The strongest reason to create an object is that it owns a meaningful lifecycle, invariant, or capability. A passive record or simple calculation may be clearer as a value or function.

OOP is one way to organize a system, not a rule that everything must be a class. A use case can coordinate a workflow, a domain object can protect its transitions, a function can calculate a total, and infrastructure adapters can handle I/O.

## Concept map and topic lessons

- [Object-Oriented Programming](topics/object-oriented-programming/README.md) — Objects, classes, state, behavior, identity, and contracts.
- [Primary OOP Principles](topics/primary-principles/README.md) — Encapsulation, abstraction, inheritance, and polymorphism.
- [Inheritance](topics/inheritance/README.md) — Subtyping, behavioral contracts, and safe reuse.
- [Polymorphism](topics/polymorphism/README.md) — Working through a shared contract with multiple implementations.
- [Abstraction](topics/abstraction/README.md) — Exposing the capability a consumer needs while hiding irrelevant detail.
- [Encapsulation](topics/encapsulation/README.md) — Protecting state and invariants behind controlled operations.
- [OOP language features](topics/paradigm-features/README.md) — Interfaces, abstract and concrete classes, and access levels.
- [Abstract Classes](topics/abstract-classes/README.md) — Shared implementation and template methods.
- [Concrete Classes](topics/concrete-classes/README.md) — Instantiable implementations of a contract.
- [Scope and Visibility](topics/scope-visibility/README.md) — Where names exist and which code may access them.
- [Interfaces](topics/interfaces/README.md) — Capability contracts and consumer-focused APIs.
- [Model-Driven Design](topics/model-driven-design/README.md) — Connecting domain language and business rules to the software model.
- [Domain Models](topics/domain-models/README.md) — Concepts, behavior, relationships, and invariants.
- [Anemic Models](topics/anemic-models/README.md) — When behavior-light data models are appropriate and when rules become scattered.
- [Domain Language](topics/domain-language/README.md) — Shared terms for business experts and technical teams.
- [Class Variants](topics/class-variants/README.md) — Subclasses, composition, enums, and tagged types for representing variation.
- [Layered Architectures in OOP](topics/layered-architectures-oop/README.md) — Separating presentation, application, domain, and infrastructure concerns.

## Integrated example: place an order

An `Order` may own its line items and status. It can reject a transition from `Paid` to `Draft`, or refuse cancellation after shipment. A `Money` value can keep amount and currency together and reject invalid arithmetic. A `PlaceOrder` use case coordinates authorization, inventory reservation, payment, and persistence.

The use case can depend on a small `PaymentAuthorizer` contract. An infrastructure adapter implements that contract by calling a provider SDK and translating its errors into outcomes the application understands. A controller handles the HTTP boundary; it does not own the order's business rules.

```text
HTTP controller -> PlaceOrder use case -> Order model
                                      -> PaymentAuthorizer contract
Infrastructure adapter implements the payment contract
```

## Design choices and trade-offs

| Choice | Useful when | Cost or warning |
| --- | --- | --- |
| Inheritance | A subtype preserves the base behavior and the hierarchy is stable. | Subclasses depend on base implementation and may be hard to change safely. |
| Composition | Behaviors vary independently or must be selected at runtime. | More collaborators and wiring must be understood. |
| Rich domain model | Rules and invariants are complex or change frequently. | Can add unnecessary mapping and structure for simple CRUD. |
| Behavior-light model | Data is simple and operations are limited. | Rules may spread among services and callers as complexity grows. |
| Interface | A real testing, change, or multiple-implementation boundary exists. | Artificial interfaces add indirection without protecting a useful contract. |

## Common mistakes

- Creating a class for every noun and a service for every operation.
- Inheriting solely to reuse a few lines of code.
- Creating an interface for every concrete class “just in case.”
- Exposing public setters that let callers break an invariant.
- Using one global domain model for contexts where terms have different meanings.
- Splitting every layer into a separate project before the dependency boundary is clear.

## Comprehensive exercise

Choose an ordering or seat-reservation system:

1. List five domain terms and identify ambiguous synonyms.
2. Identify its entities and value objects.
3. Write three invariants and valid state transitions.
4. Separate use-case operations from read queries.
5. Draw the dependencies among presentation, application, domain, and infrastructure.
6. Choose one interface only where a useful contract exists.
7. Design tests for success, invalid state, concurrent requests, and provider failure.

**Suggested answer:** `Order` and `Customer` may be entities, while `Money` and `OrderLine` may be value objects. An order requires at least one line, cannot be edited after payment, and can be cancelled only before shipment. The use case coordinates the workflow; the `Order` enforces its state rules; a read projection serves order history. Unit tests check invariants, concurrency tests check duplicate placement or stock reservation, and adapter/integration tests check provider and database behavior. If the rules are simple and stable, a transaction script may be sufficient.

## Answered quiz

1. **Why can a public status setter be unsafe?**
   **Answer:** Any caller can create an invalid transition. The object that owns the state should expose operations that enforce its invariants.

2. **How do abstraction and encapsulation differ?**
   **Answer:** Abstraction selects the useful contract and hides irrelevant detail. Encapsulation controls access to state so its invariants remain valid.

3. **When might a square not be a valid rectangle subtype?**
   **Answer:** If the rectangle contract allows width and height to change independently but a square must keep them equal, the square cannot preserve the behavior expected by that consumer.

4. **Does every application need a rich domain model?**
   **Answer:** No. Simple CRUD may be clearer with records and a transaction script; complex stateful rules can justify a richer model.

5. **What makes an interface useful?**
   **Answer:** It expresses a real consumer need with a small contract and clear outcomes, without leaking framework or vendor details.

6. **When is composition preferable to inheritance?**
   **Answer:** When behaviors vary independently or must be combined at runtime, especially when there is no valid subtype relationship.

7. **Why should the domain not depend directly on a database framework?**
   **Answer:** Business policy can then be tested and understood without infrastructure details; an adapter implements the required contract.

8. **How can a behavior-light model become a problem?**
   **Answer:** Rules are duplicated, callers mutate state directly, and invariants are not guaranteed across all code paths.

## Further reading

### English

- [Microsoft Learn — Object-oriented programming in C#](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — Classes, encapsulation, inheritance, and polymorphism.
- [Microsoft Learn — DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice) — Domain and application boundaries.
- [Microsoft Azure — Tactical Domain-Driven Design](https://learn.microsoft.com/en-us/azure/architecture/microservices/model/tactical-domain-driven-design) — Entities, value objects, aggregates, and bounded contexts.
- [Oracle Java Tutorials — Object-oriented concepts](https://docs.oracle.com/javase/tutorial/java/concepts/) — Classes, objects, interfaces, and inheritance.

### Persian

- [Object-Oriented Programming Handbook](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — Persian notes on core OOP concepts.
- [Persian DDD guide](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — Domain modeling terminology and examples.
- [Intelligent Software Engineering Lab — Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian material on object-oriented design and modeling.

For more sources grouped by chapter, see the [course reference library](../../references.md#chapter-03).

</div>
