<div dir="ltr" align="left">

# Domain-Driven Design (DDD)

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/08/architectural-patterns/topics/domain-driven-design/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Location in the roadmap:** [Architecture Patterns](../../README.md) · [Course Index](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

DDD is a process and patterns for understanding complex domain: common language, bounded context, context map and domain model with rules.


## Practical example

We divide sales, refunds and customer credit into clear contexts, because the terms and ownership of the rules are different.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its background are linked in the "Architectural Patterns" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** It requires the cooperation of a domain expert and has modeling costs.
- **Review:** Don't reduce DDD to more entities/repositories or guarantee microservices.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: DDD is a process and patterns for understanding complex domain: common language, bounded context, context map and domain model with rules.
2. **What decision do you make in the example below and why?**
   - Suggested answer: We divide sales, refund and customer credit into clear contexts, because the terms and ownership of the rules are different.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: It requires the cooperation of a domain expert and has modeling costs.
4. **Which common error do you check before merging the code?**
   - Suggested answer: Don't reduce DDD to more entities/repositories or guarantee microservices.

## In-depth lesson for this topic

### 1. Domain-Driven Design

DDD is a way to understand the complex domain and transform its understanding into boundaries and models. The strategic part explores the bounded context and the relationship between contexts. The tactical part uses entity, value object, aggregate, repository and domain service.

#### Strategic boundaries

Bounded Context is a boundary inside which language and model have consistent meaning. "Customer" in catalog, billing and shipping can have different models. Context Map specifies the relationship and cooperation direction of contexts. This helps us not to create a global common model.

#### Tactical model

- **Entity:** has identity and lifecycle.
- **Value object:** is defined based on the value and it is better to be immutable.
- **Aggregate:** Specifies the consistency and transaction range of a domain. The outside gets root access.
- **Domain event:** A fact about the domain that happened.
- **Repository:** collection-like contract for retrieving/storing aggregate.
- **Domain service:** domain logic that is not natural to be placed inside a single entity.

DDD is not more class writing. Start with dialogue, events, invariants, vocabulary and change difficulty. For simple CRUD the cost of all these concepts may not be justified.
## Architecture diagram and walkthrough

DDD develops the model and language with domain experts for complex problems. A bounded context defines where terms and invariants apply; contracts or an anti-corruption layer translate between contexts. Discovery and coordination take effort.


**Common pitfall:** Do not turn every entity into an aggregate root or every team into a bounded context.


**Exercise with answer:** Customer means different things in sales and support; define separate context ownership and contracts instead of forcing one global model.

This is a simplified view; production design must also state ownership, failure, security, and operational constraints.

~~~text
[Sales context] -- CustomerRegistered --> [Support context]
     |                                      |
 Sales customer model                 Support customer model
     +---------- translation contract / ACL --------+
~~~

## Architecture diagram and walkthrough

DDD develops a model and shared language with domain experts for complex problems. A bounded context defines where terms and invariants apply; contracts or an ACL translate between contexts. Discovery and team coordination take effort.


**Common pitfall:** Do not make every entity an aggregate root or every team a bounded context.


**Exercise with answer:** Customer behaves differently in sales and support; define separate models and owners, then make the translation boundary explicit.

This simplified view should be supplemented with explicit ownership, failure, security, and operational decisions.

~~~text
[Sales context] -- CustomerRegistered --> [Support context]
     |                                      |
 Sales customer model                 Support customer model
     +---------- translation contract / ACL --------+
~~~


## Resources

### Persian

- [Persian Guide to Domain-Oriented Design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — Structured Persian guide to DDD, Common Language and Modeling.
- [DNTips; Software layering architecture](https://www.dntips.ir/post/1264/معماری-لایه-بندی-نرم-افزار-3) — Persian examples in application and data layer.

### English

- [Microsoft Learn; DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice) — domain boundary, layers and domain model.
- [Martin Fowler; CQRS](https://martinfowler.com/bliki/CQRS.html) — CQRS definition and warning about additional complexity.
- [Martin Fowler. Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) — Logging changes as events and replay considerations.

## Summary

Apply domain-driven design to solve a specific problem, document the trade-offs, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-08)
</div>
