<div dir="ltr" align="left">

# Builder
> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/builder/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** creational · 

**Chapter:** [Design patterns](../../../../README.md)
## Pattern intent

It separates the step-by-step construction of the complex object from the final representation.
## Practical example

Report configuration is built with optional fields, validation and PDF/HTML outputs.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** For a simple three-field object, the builder has overhead.
Don't publish a half-baked object.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: It separates the construction of the complex object step by step from the final representation.
2. **What does it structure in this example?**   
- Suggested answer: The report configuration is built with optional fields, validation and PDF/HTML outputs.
3. **When is it better to go for the simpler option?**   
- Suggested answer: for a simple three-field object, the builder has overhead.
Don't publish a half-baked object.
## Pattern family context

This is one of the GoF creational patterns. The [integrated chapter lesson](../../../../lessons.md#1-gof-creational-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

Build an order with many options through readable steps, then validate it once.
Build must enforce invariants and expose no partial object.
For a simple object, a normal constructor is clearer.

**Exercise with answer:** Quantity is zero.
Build must return a validation error and create no invalid order.
A builder does not replace domain rules.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
var order = new OrderBuilder()
    .ForCustomer(customerId)
    .AddLine(productId, quantity: 2)
    .WithDeliveryAddress(address)
    .Build();
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
