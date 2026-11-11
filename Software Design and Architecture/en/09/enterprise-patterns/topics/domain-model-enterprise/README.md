<div dir="ltr" align="left">

# Domain model — Domain Models
> **Language:** [Persian edition](../../../../../09/enterprise-patterns/topics/domain-model-enterprise/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

In organizational models, the domain model keeps the behavior and complex rules next to the domain concepts.
It is an option against transaction script.
## Practical example

The credit model controls withdrawal and transfer limits with invariants within the aggregate.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** The rich model needs scope discovery and testing.
- **Review:** For a simple domain, don't make a formal domain model.
Don't spread logic for complex rules in countless services.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: in organizational models, the domain model keeps complex behavior and rules next to domain concepts.
It is an option against transaction script.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The credit model controls the withdrawal and transfer limits with invariants within the aggregate.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: A rich model needs scope discovery and testing.
4. **Which common error do you check before merging the code?**   
- Suggested answer: for a simple domain, don't make a formal domain model.
Don't spread logic for complex rules in countless services.
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

A Domain Model groups business behavior, state, and invariants.
It fits complex rules and important transitions; persistence mapping and DTO conversion should not turn it into a database schema.

**Common pitfall:** Do not make every table column a public domain property.

**Exercise with answer:** Order accepts AddLine only while Draft; put that rule in the model so every caller preserves the invariant.
This C
# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
public sealed class Order
{
    private readonly List<OrderLine> _lines = [];
    public OrderStatus Status { get; private set; }

    public void AddLine(Product product, Quantity quantity)
    {
        if (Status != OrderStatus.Draft) throw new InvalidOperationException();
        _lines.Add(new OrderLine(product.Id, quantity, product.Price));
    }
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

Apply the domain model to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)

</div>
