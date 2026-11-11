<div dir="ltr" align="left">

# Mediator
> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/mediator/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

Centralizes multiple interactions in a coordinator so that components do not reference each other directly.
## Practical example

The reservation form coordinates the changes of several UI fields.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** Dependencies may only be passed to god mediator.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: Centralize multiple interactions in a coordinator so that components don't reference each other directly.
2. **What does it structure in this example?**   
- Suggested answer: The reservation form coordinates the changes of several UI fields.
3. **When is it better to go for the simpler option?**   
- Suggested answer: Dependency may be transferred only to god mediator.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

A coordinator manages one workflow so peers need fewer direct dependencies and cascading changes.
Keep the mediator focused; owning every rule and workflow turns it into a god object.

**Exercise with answer:** Does every service need one shared mediator?
No; add one where direct peer communication creates real coupling.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public async Task<Receipt> Place(Order order, CancellationToken ct)
{
    var quote = pricing.Quote(order);
    await inventory.Reserve(order, ct);
    var receipt = await SaveAndPay(order, quote, ct);
    await notifications.SendReceipt(receipt, ct);
    return receipt;
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
