<div dir="ltr" align="left">

# Singleton

> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/singleton/README.md)

> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Family:** creational · 

**Chapter:** [Design patterns](../../../../README.md)

## Pattern intent

It guarantees the existence of a shared instance and usually provides global access.

## Practical example

A process-local cache might actually want a single instance per process.

## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.



**Important limitation:** global access makes testing and concurrency difficult. For shared service, DI is usually better.

## Test questions with answers

1. **Which problem does it solve?**
   - Suggested answer: It guarantees the existence of a shared instance and usually provides global access.
2. **What does it structure in this example?**
   - Suggested answer: A process-local cache might really want a single instance per process.
3. **When is it better to go for the simpler option?**
   - Suggested answer: global access makes testing and concurrency difficult. For shared service, DI is usually better.

## Pattern family context

This is one of the GoF creational patterns. The [integrated chapter lesson](../../../../lessons.md#1-gof-creational-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

A Singleton gives one instance per process, not one across a cluster. Global access creates hidden dependencies and makes testing harder. A DI-managed singleton lifetime is usually easier to control for application services.


**Exercise with answer:** Is Singleton memory shared across containers? No; each process has its own instance. Use shared storage or a coordination service.

The C# block is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public sealed class MetricsRegistry
{
    private static readonly Lazy<MetricsRegistry> Holder =
        new(() => new MetricsRegistry());

    public static MetricsRegistry Instance => Holder.Value;
    private MetricsRegistry() { }
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
