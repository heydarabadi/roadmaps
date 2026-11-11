<div dir="ltr" align="left">

# Factory Method

> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/factory-method/README.md)

> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Family:** creational · 

**Chapter:** [Design patterns](../../../../README.md)

## Pattern intent

Delegates the creation of the product to the constructor operation or subtype so that the caller is not tied to the concrete type.

## Practical example

The import framework constructs the file format from the selected implementation.

## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.



**Important limitation:** If a simple map or dependency injection is enough, don't create an inheritance hierarchy.

## Test questions with answers

1. **Which problem does it solve?**
   - Suggested answer: leaves the creation of the product to the operation or subtype of the constructor so that the caller is not tied to the concrete type.
2. **What does it structure in this example?**
   - Suggested answer: The import framework builds the file format from the selected implementation.
3. **When is it better to go for the simpler option?**
   - Suggested answer: If a simple map or dependency injection is enough, don't create an inheritance hierarchy.

## Pattern family context

This is one of the GoF creational patterns. The [integrated chapter lesson](../../../../lessons.md#1-gof-creational-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

The report export workflow stays stable while the writer varies by format. The creator owns the workflow and a subclass selects the product. Use it when the algorithm is real and stable; a factory function or DI may cost less.


**Exercise with answer:** If CSV and PDF also need different steps, do not force one shared hook. Extract only steps that truly match.

The C# block is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public abstract class ReportExporter
{
    public void Export(Report report)
    {
        var writer = CreateWriter();
        writer.WriteHeader(report.Title);
        writer.WriteRows(report.Rows);
        writer.Complete();
    }

    protected abstract IReportWriter CreateWriter();
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
