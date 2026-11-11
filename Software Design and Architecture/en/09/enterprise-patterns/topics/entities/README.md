<div dir="ltr" align="left">

# Entities
> **Language:** [Persian edition](../../../../../09/enterprise-patterns/topics/entities/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

entity has a stable identity and its characteristics change over time.
Identity, lifecycle and allowed invariants are important.
## Practical example

A customer with the same `CustomerId` is still the same customer after changing the email.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** ID and lifecycle persistence are not always the same as domain identity.
- **Revision:** Don't test entity equality only with all mutable fields.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: entity has a stable identity and its characteristics change over time.
Identity, lifecycle and allowed invariants are important.
2. **What decision do you make in the example below and why?**   
- Suggested answer: A customer with the same `CustomerId` is still the same customer after changing the email.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: ID and lifecycle persistence are not always the same as domain identity.
4. **Which common error do you check before merging the code?**   
- Suggested answer: don't test entity equality only with all mutable fields.
## In-depth lesson for this topic
### 9. Domain Model and Entity

Domain model keeps behavior and rules together.
Entity has stable identity and lifecycle.
Its equality is not defined by the value of all mutable properties.
Customer changes his email but still has the same CustomerId.
Aggregate root controls the consistency boundary and the access of changes inside the aggregate.
Query model and entity do not need to be the same.
A domain event records a business fact such as OrderPaid, not merely a log that a function ran.
The behaviorless model is sufficient for simple CRUD.
For changing rules such as withdrawal limits or cancellation eligibility, keep behavior with the domain owner.
Decide based on invariants and where changes occur.
## Worked code example

An entity has persistent identity: two instances with equal data may be different entities, while changed data can still be the same entity.
Define equality by identity and keep state-transition rules with the entity.

**Common pitfall:** Do not use every property as entity identity by default.

**Exercise with answer:** Two loaded copies with the same OrderId represent one order; matching other values cannot make different IDs the same entity.
This C
# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
public sealed class Order : IEquatable<Order>
{
    public OrderId Id { get; }

    public bool Equals(Order? other) => other is not null && Id == other.Id;
    public override bool Equals(object? obj) => obj is Order other && Equals(other);
    public override int GetHashCode() => Id.GetHashCode();
}
~~~


## Resources
### Persian

- [Persian guide to domain-oriented design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — vocabulary of domain, model, entity and object value.
- [Persian Design Patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian description of DTO, CQRS and related patterns along with GoF.
### English

- [Martin Fowler; Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/index.html) — Reference catalog of Repository, Identity Map, Mapper and other patterns.
- [Microsoft Learn; Applying CQRS and DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — tutorial example of order and command/query separation.
## Summary

Apply Entities to solve a specific problem, record the trade-off and check with visible tests or relevant operational measures if the design boundary has really improved.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)

</div>
