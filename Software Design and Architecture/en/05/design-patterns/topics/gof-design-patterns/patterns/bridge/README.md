<div dir="ltr" align="left">

# Bridge

> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/bridge/README.md)

> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Family:** structural · 

**Chapter:** [Design Patterns](../../../../README.md)

## Pattern intent

It separates the abstraction from the implementation so that the two dimensions change independently.

## Practical example

Independent reporting and storage destinations are combined.

## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.



**Important limitation:** The structure of two hierarchies for two dimensions makes it difficult to understand change.

## Test questions with answers

1. **Which problem does it solve?**
   - Suggested answer: It separates the abstraction from the implementation so that the two dimensions change independently.
2. **What does it structure in this example?**
   - Suggested answer: Reporting and independent storage destination are combined.
3. **When is it better to go for the simpler option?**
   - Suggested answer: The structure of two hierarchies for two dimensions makes it difficult to change understanding.

## Pattern family context

This is one of the GoF structural patterns. The [integrated chapter lesson](../../../../lessons.md#2-gof-structural-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

Report type and rendering format are independent change axes. Bridge separates them with composition, avoiding a subclass for every combination. It adds abstraction and delegation; keep the design simpler if a second axis is unlikely.


**Exercise with answer:** Add text rendering without changing invoice rules. If every format changes the report hierarchy, the axes are not separated.

The C# block is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public interface IReportRenderer
{
    string Render(string title, IReadOnlyList<string> rows);
}

public abstract class Report
{
    protected readonly IReportRenderer Renderer;
    protected Report(IReportRenderer renderer) => Renderer = renderer;
    public abstract string Print();
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
