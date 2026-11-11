<div dir="ltr" align="left">

# Template Method
> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/template-method/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

The skeleton keeps the algorithm in the base and leaves some steps to the subclass.
## Practical example

Pipeline import has a fixed order, but the parse step is different for formats.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** Inheritance and fragile base class have cost.
If the order changes, Strategy is more suitable.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: The skeleton keeps the algorithm in the base and leaves some steps to the subclass.
2. **What does it structure in this example?**   
- Suggested answer: Pipeline import has a fixed order, but the parse step is different for formats.
3. **When is it better to go for the simpler option?**   
- Suggested answer: Inheritance and fragile base class have a cost.
If the order changes, Strategy is more suitable.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

An import always reads, parses, validates, and persists; subclasses supply format-specific steps.
The template protects this invariant ordering.
If steps must vary at runtime, composition is a better fit.

**Exercise with answer:** A subclass must not persist before validation.
If that flexibility is needed, build the workflow from injected collaborators.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public async Task Import(CancellationToken ct)
{
    var raw = await Read(ct);
    var rows = Parse(raw);
    Validate(rows);
    await Persist(rows, ct);
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
