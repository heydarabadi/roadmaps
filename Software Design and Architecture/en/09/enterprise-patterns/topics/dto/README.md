<div dir="ltr" align="left">

# Data Transfer Object (DTO)
> **Language:** [Persian edition](../../../../../09/enterprise-patterns/topics/dto/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

A DTO passes data across a boundary and its form is optimized for an API, view, or message.
It should be seen separately from the domain model and entity persistence.
## Practical example

The ordering API returns `OrderSummaryDto` with the required mobile fields, not the entire entity graph.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Field mapping and API versioning add implementation and maintenance work.
- **Revision:** Don't make database entity public directly to API.
Leaks internal information and lazy loading.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: DTO passes data across a boundary and its form is optimized for API, view or message.
It should be seen separately from the domain model and entity persistence.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The order API returns `OrderSummaryDto` with the required mobile fields, not the entire entity graph.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Field mapping and API versioning add implementation and maintenance work.
4. **Which common error do you check before merging the code?**   
- Suggested answer: don't make the database entity directly public to the API.
Leaks internal information and lazy loading.
## In-depth lesson for this topic
### 1. D.
T.
OData Transfer Object transfers data across a boundary.
Its purpose is surface API, serialization or data transfer.
The entity does not have to be a domain.
Design the DTO based on consumer and security: give only necessary fields, hide internal data, consider versioning and perform boundary validation.

~~~python
@dataclass(frozen=True)
class OrderSummaryDto:
    order_id: str
    total_cents: int
    currency: str
~~~

Returning an entity or ORM graph from an API can expose sensitive data, lazy-loading, and internal relationships.
DTO also brings a lot of mapping and version drift.
If the model is simple and read-only, measure isolation based on actual risk.
## Worked code example

A DTO carries data across an API or process boundary; it should not be an ORM or domain entity.
Validate incoming data at the boundary and shape responses for the consumer; a DTO does not authorize a domain change.

**Common pitfall:** Do not serialize an internal entity; it may expose private fields or navigation cycles.

**Exercise with answer:** If an API needs only product name and price, return a small DTO rather than the full entity graph.
This C
# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
public sealed record ProductResponse(
    string Name, decimal Price, string Currency);

public sealed record CreateOrderRequest(
    Guid CustomerId, IReadOnlyList<CreateOrderLine> Lines);
~~~


## Resources
### Persian

- [Persian guide to domain-oriented design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — vocabulary of domain, model, entity and object value.
- [Persian Design Patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian description of DTO, CQRS and related patterns along with GoF.
### English

- [Martin Fowler; Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/index.html) — Reference catalog of Repository, Identity Map, Mapper and other patterns.
- [Microsoft Learn; Applying CQRS and DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — tutorial example of order and command/query separation.
## Summary

Use a DTO to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)

</div>
