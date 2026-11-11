<div dir="ltr" align="left">

# Object-Relational Mappers (ORMs)
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/09/enterprise-patterns/topics/orms/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

ORM hides/manages the difference between object and relational model and makes query, identity, transaction and mapping easy.
## Practical example

ORM loads invoices.
A high-traffic report query may require targeted SQL.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** lazy loading, N+1, tracking and coupling are common cost tools.
- **Review:** Don't consider ORM equivalent to database or performance guarantee.
Measure query plan and transaction.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: ORM hides/manages the difference between object and relationship model and makes query, identity, transaction and mapping easy.
2. **What decision do you make in the example below and why?**   
- Suggested answer: ORM loads invoices.
A high-traffic report query may require targeted SQL.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: lazy loading, N+1, tracking and coupling are common cost tools.
4. **Which common error do you check before merging the code?**   
- Suggested answer: don't consider ORM equivalent to database or performance guarantee.
Measure query plan and transaction.
## In-depth lesson for this topic
### 10. ORMObject-Relational Mapper maps objects to rows and relational relations and provides query, unit of work, identity tracking and transaction.
ORM speeds up development, but does not eliminate the difference between object graph and relation.
#### Common risks
- N+1: one query for the list and a separate query for each row.
- Unwanted lazy load after closing the transaction.
- Old tracking and state.
- Long transactions or unexpected locks.
- The domain model depends on the ORM attribute/base class.
- Heavy query whose desired output is not suitable with entity graph.
See the behavior of SQL generated, query plan and transaction.
For large read/report, projection or direct SQL may be clearer.
Take ORM as a tool, not as a contract for the architecture of the entire system.
## Worked code example

An ORM simplifies object-relational mapping and query execution, but it does not remove query-plan, transaction, lazy-loading, or concurrency concerns.
Design the domain around rules and verify mapping with integration checks.

**Common pitfall:** N+1 queries or hidden lazy loading can create unexpected latency.

**Exercise with answer:** A list of 100 orders triggers many queries; measure them and choose a targeted projection or eager load.
This C
# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
var orders = await db.Orders
    .Where(order => order.CustomerId == customerId)
    .Select(order => new OrderSummary(
        order.Id, order.Status, order.Lines.Count))
    .ToListAsync(ct);
~~~


## Resources
### Persian

- [Persian guide to domain-oriented design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — vocabulary of domain, model, entity and object value.
- [Persian Design Patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian description of DTO, CQRS and related patterns along with GoF.
### English

- [Martin Fowler; Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/index.html) — Reference catalog of Repository, Identity Map, Mapper and other patterns.
- [Microsoft Learn; Applying CQRS and DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — tutorial example of order and command/query separation.
## Summary

Apply an object-relational mapper (ORM) to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)

</div>
