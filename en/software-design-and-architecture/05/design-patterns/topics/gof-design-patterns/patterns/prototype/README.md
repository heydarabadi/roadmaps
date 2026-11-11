<div dir="ltr" align="left">

# Prototype

> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/prototype/README.md)

> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Family:** creational · 

**Chapter:** [Design patterns](../../../../README.md)

## Pattern intent

Copies the configured object so that no rebuilding or concrete type recognition is required.

## Practical example

The document editor takes a deep copy from a ready-made template.

## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**IMPORTANT LIMITATION:** The difference between shallow/deep copy and shared references is the source of the bug.

## Test questions with answers

1. **Which problem does it solve?**
   - Suggested answer: Copies the configured object so that it is not necessary to rebuild or know the concrete type.
2. **What does it structure in this example?**
   - Suggested answer: The document editor takes a deep copy from a ready-made template.
3. **When is it better to go for the simpler option?**
   - Suggested answer: The difference between shallow/deep copy and shared references is the source of the bug.

## Pattern family context

This is one of the GoF creational patterns. The [integrated chapter lesson](../../../../lessons.md#1-gof-creational-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

Copy a prepared report template when rebuilding it is expensive or difficult. Define shallow versus deep copy; shared mutable references leak state. If creation is cheap, create a fresh object.


**Exercise with answer:** Changing the copied column list must not alter the original template; make it immutable or copy it separately.

The C# block is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public sealed record ReportTemplate(
    string Header, string Footer, IReadOnlyList<string> Columns);

var monthly = invoiceTemplate with { Header = "Monthly report" };
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
