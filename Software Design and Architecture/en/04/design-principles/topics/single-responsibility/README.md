<div dir="ltr" align="left">

# Single Responsibility Principle (SRP) — Single Responsibility Principle
> **Language:** [Persian edition](../../../../../04/design-principles/topics/single-responsibility/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

A module should be organized around an actor or a coherent reason for change; "Just one job" is not meant in a limited sense.
## Practical example

Separate sales manager reporting rules from PDF formatting if the two are changed by different needs.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Design" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Very fine division increases dependency and coordination.
- **Review:** Do not change the number of class methods or its name instead of actor analysis.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: A module should be organized around an actor or a coherent reason for change; "Just one job" is not meant in a limited sense.
2. **What decision do you make in the example below and why?**   
- Suggested response: Separate Sales Manager reporting rules from PDF formatting if the two are changed by different needs.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Very fine division increases dependence and coordination.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Do not change the number of class methods or its name instead of actor analysis.
## In-depth lesson for this topic
#### S — Single Responsibility

A module should be grouped around a cohesive responsibility or a group that changes a requirement.
It doesn't mean "each class is just a method" or "a small task".
If tax change and invoice printing format change are usually requested by two independent actors, we probably have two responsibilities.
Method: check recent changes.
Find independent requirements that affect a module.
Separate the boundary only when there is real coupling or test difficulty.
Tiny modules with generic names can make cohesiveness worse.
## Worked code example

Single Responsibility means a module has one cohesive actor or reason to change, not merely one small task.
Inspect real changes and judge the boundary by cohesion and decision ownership; excessive splitting also has a cost.

**Exercise with answer:** Separate amount calculation and PDF rendering when different groups change their rules.
If they always change together, the split may not help.
This C
# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public sealed class InvoiceCalculator
{
    public Money Calculate(Invoice invoice) => /* business rule */ invoice.Subtotal;
}

public sealed class InvoicePdfRenderer
{
    public byte[] Render(Invoice invoice) => /* presentation */ RenderPdf(invoice);
}
~~~


## Resources
### Persian

- [GoFarsi; SOLID in Go](https://book.gofarsi.ir/chapter-9/solid-principle-in-golang/) — Persian explanation of SOLID with the Go language angle.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — tutorial description of SOLID, GRASP, design and refactoring smells.
- [Persian design patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian list of patterns and a summary of each problem.
### English

- [Refactoring.Guru; SOLID principles](https://refactoring.guru/design-patterns/solid-principles) — definition and example of each SOLID principle.
- [Martin Fowler; Is Design Dead?](https://martinfowler.com/articles/designDead.html) — Evolutionary Design and the Cost of Early Decisions.
## Summary

Apply the Single Responsibility Principle (SRP) to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)

</div>
