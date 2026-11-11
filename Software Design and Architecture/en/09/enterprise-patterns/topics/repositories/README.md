<div dir="ltr" align="left">

# Repositories

> **Language:** [Persian edition](../../../../../09/enterprise-patterns/topics/repositories/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

A repository provides a set of domain aggregates such as a queryable/storable collection and hides the persistence details.


## Practical example

`OrderRepository` loads the order with ID and saves the aggregate change.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** General abstraction for all queries may stifle the database capabilities.
- **Revision:** Do not create a CRUD repository for each table if there is no domain boundary or separation value.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: Repository provides a set of domain aggregates like a queryable/storable collection and hides the persistence details.
2. **What decision do you make in the example below and why?**
   - Suggested answer: `OrderRepository` loads the order with ID and saves the aggregate change.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: general abstraction for all queries may stifle database capabilities.
4. **Which common error do you check before merging the code?**
   - Suggested answer: Do not create a CRUD repository for each table if there is no domain boundary or separation value.

## In-depth lesson for this topic

### 4. Repository

Repository retrieves and stores a collection of domain aggregates or objects from the consumer's point of view. The goal is to separate the query/persistence detail from the use case, not to create a CRUD class for each table.
~~~text
OrderRepository:
  get(order_id)
  save(order)
~~~
If the interface forces all SQL and ad-hoc queries into a generic abstraction, consumers need real storage capabilities. Repository does not replace transaction manager or ORM. The lifetime of unit of work and transaction should be clear.
## Worked code example

A repository offers a collection-like contract for aggregate roots and keeps use cases independent of persistence. Specialized reads may use projections; generic CRUD for every table can obscure domain rules.


**Common pitfall:** Do not turn a repository into a thin DbSet wrapper or one generic repository for every need.


**Exercise with answer:** PlaceOrder saves an Order through its repository; that repository does not own multi-aggregate orchestration or distributed transactions.

This C# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
public interface IOrderRepository
{
    Task<Order?> Find(OrderId id, CancellationToken ct);
    Task Add(Order order, CancellationToken ct);
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

Use repositories to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures if the design boundary has really improved.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)
</div>
