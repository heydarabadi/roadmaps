<div dir="ltr" align="left">

# Transaction Script

> **Language:** [Persian edition](../../../../../09/enterprise-patterns/topics/transaction-script/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

Transaction Script organizes the logic of a business operation into a procedure. It is low-cost for simple and transaction-oriented operations.


## Practical example

The bill payment use case performs several updates in one transaction and records the result.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** As the rules grow, the procedures become repetitive and conditional.
- **Review:** Do not make a complex aggregate for any simple CRUD. But don't leave repetitive rules in scattered scripts.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: Transaction Script organizes the logic of a business operation into a procedure. It is low-cost for simple and transaction-oriented operations.
2. **What decision do you make in the example below and why?**
   - Suggested answer: the bill payment use case performs several updates in one transaction and records the result.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: As the rules grow, the procedures become repetitive and conditional.
4. **Which common error do you check before merging the code?**
   - Suggested answer: don't make complex aggregate for every simple CRUD. But don't leave repetitive rules in scattered scripts.

## In-depth lesson for this topic

### 6. Transaction Script

Transaction Script leaves the logic of a use case to a procedure that controls a transaction. It is simple and effective for CRUD and limited rules: record payment, update status and write audit inside a unit.

When rules are copied across multiple scripts or each script executes the invariant differently, check the rich domain model or domain service. Conversely, don't make complex aggregate settings for a simple form. The criterion is the change and complexity of the rules.
## Worked code example

A Transaction Script organizes one use case's logic in a procedure or service function and works well for simple, data-centric workflows. As conditions and invariants grow, logic can repeat; then consider a richer domain model.


**Common pitfall:** Do not create one giant script for every operation.


**Exercise with answer:** Three independent conditions repeat in order placement; centralize the rule or enrich the domain model instead of expanding the whole workflow into one block.

This C# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
public async Task<Result> PlaceOrder(PlaceOrderRequest request, CancellationToken ct)
{
    var customer = await customers.Find(request.CustomerId, ct);
    if (customer is null) return Result.CustomerNotFound();

    var order = Order.From(request);
    await orders.Add(order, ct);
    return Result.Success(order.Id);
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

Apply the transaction script to solve the specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)
</div>
