<div dir="ltr" align="left">

# Facade

> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/facade/README.md)

> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Family:** structural · 

**Chapter:** [Design Patterns](../../../../README.md)

## Pattern intent

It provides a simple interface in front of a complex subsystem.

## Practical example

The use case wraps invoicing behind an API and coordinates multiple internal services.

## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.



**Important limitation:** Facade should not become god object or point of all changes.

## Test questions with answers

1. **Which problem does it solve?**
   - Suggested answer: It provides a simple interface in front of a complex subsystem.
2. **What does it structure in this example?**
   - Suggested answer: The use case wraps the invoicing behind an API and coordinates several internal services.
3. **When is it better to go for the simpler option?**
   - Suggested answer: Facade should not become a god object or the point of all changes.

## Pattern family context

This is one of the GoF structural patterns. The [integrated chapter lesson](../../../../lessons.md#2-gof-structural-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

A facade places several subsystems behind one simple caller operation, but it does not create a distributed transaction. Failure between stock reservation and payment needs compensation or a durable workflow. Split a facade that accumulates every rule into focused use cases.


**Exercise with answer:** Payment fails after reservation; release stock or compensate in a workflow. Do not assume atomicity.

The C# block is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public async Task<Receipt> PlaceOrder(Order order, CancellationToken ct)
{
    await inventory.Reserve(order, ct);
    var payment = await payments.Capture(order.Total, ct);
    return await receipts.Create(order, payment, ct);
}
~~~

## Resources

### Persian

- [Persian design patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian summaries of GoF patterns and several architecture patterns.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian textbook resource for GoF, GRASP and architectural patterns.

### English

- [Refactoring.Guru; Design Patterns](https://refactoring.guru/design-patterns) — List of GoF patterns and multilingual examples.
- [Patterns.Guru; GoF catalog](https://patterns.guru/) — A catalog and discussion of pattern intent and selection costs.
- [Wiley; POSA Volume 3 excerpt](https://catalogimages.wiley.com/images/db/pdf/9780470845257.excerpt.pdf) — An example of architecture and concurrency patterns in the POSA suite.


## Further reading

[Curated references for this chapter](../../../../../../references.md#chapter-05)
</div>
