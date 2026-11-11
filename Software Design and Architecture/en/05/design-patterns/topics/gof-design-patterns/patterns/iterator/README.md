<div dir="ltr" align="left">

# Repeater — Iterator
> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/iterator/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

Traversal separates elements from the collection's internal structure.
## Practical example

The consumer of the orders uses the page or stream without knowing the storage.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** Define life cycle, stream end and mutation at the same time.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: Traversal separates the elements from the internal structure of the collection.
2. **What does it structure in this example?**   
- Suggested answer: the consumer of the orders uses the page or stream without knowing the storage.
3. **When is it better to go for the simpler option?**   
- Suggested answer: define life cycle, end of stream and mutation at the same time.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

An iterator hides traversal details from callers.
For remote data, define cancellation, page failures, and repeatability; yield supports lazy execution.
Do not expose storage structure or internal indexes.

**Exercise with answer:** The source is single-use; document the constraint or create a new iterator per traversal instead of promising re-enumeration.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
static IEnumerable<Order> ActiveOrders(IEnumerable<Order> orders)
{
    foreach (var order in orders)
        if (order.Status == OrderStatus.Active)
            yield return order;
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
