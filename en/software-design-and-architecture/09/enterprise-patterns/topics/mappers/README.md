<div dir="ltr" align="left">

# Mappers
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/09/enterprise-patterns/topics/mappers/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

mapper performs the conversion between two independent models.
Models can be DTO, Domain, Persistence or Message.
## Practical example

`OrderEntity` is changed to `OrderResponse` to show the public contract API only.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **when to keep it simpler:** mappings cause synchronization and conversion errors.
- **Review:** Do not use an automatic and hidden mapper without controlling null, value object and invariant.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: mapper performs the conversion between two independent models.
Models can be DTO, Domain, Persistence or Message.
2. **What decision do you make in the example below and why?**   
- Suggested answer: `OrderEntity` is changed to `OrderResponse` so that the API only displays the public contract.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: mappings cause synchronization and conversion errors.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Do not use an automatic and hidden mapper without null, value object and invariant controls.
## In-depth lesson for this topic
### 5. Data Mapper

The Data Mapper translates between objects and the database, without the two models being dependent.
Mapper performs mapping and identity/relationships conversion.
The domain should not have to duplicate the schema table.
ORMs often implement Data Mapper, although the framework details vary.
Mapping may lose information, misinterpret null, or create N+1 queries.
Mapping test is required for invariants, money/time precision and relations.
AutoMapper does not replace contract understanding.
## Worked code example

A mapper transforms data between boundaries; it should not silently discard domain decisions or validation failures.
Map near the boundary and keep business rules in the domain or use case.

**Common pitfall:** Do not use automatic mapping to hide semantic changes or sensitive fields.

**Exercise with answer:** Money arrives without a currency; reject it or require a complete input type rather than guessing a default.
This C
# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
public static CreateOrderCommand ToCommand(CreateOrderRequest request)
{
    var lines = request.Lines
        .Select(line => new OrderLineInput(line.ProductId, line.Quantity))
        .ToArray();

    return new CreateOrderCommand(request.CustomerId, lines);
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

Use mappers to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)

</div>
