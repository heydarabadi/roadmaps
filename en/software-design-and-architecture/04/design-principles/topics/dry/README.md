<div dir="ltr" align="left">

# Principle of DRY — DRY
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/04/design-principles/topics/dry/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Every knowledge or business rule must have an authoritative source.
The goal is to remove two independent representations of the same rule, not to remove all textual similarities.
## Practical example

The maximum discount is calculated in two endpoints with a domain policy.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Design" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Excessive reuse ties two independent concepts together.
- **Review:** Two similar pieces of code do not necessarily share the same rule.
Check for upcoming changes.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: Every knowledge or business rule must have a valid source.
The goal is to remove two independent representations of the same rule, not to remove all textual similarities.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The maximum discount is calculated in two endpoints with a domain policy.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: excessive reuse connects two independent concepts.
4. **Which common error do you check before merging the code?**   
- Suggested answer: two similar pieces of code do not necessarily have a common rule.
Check for upcoming changes.
## In-depth lesson for this topic
### 2. DRY — Don't Repeat Yourself

DRY says don't turn a single knowledge and rule into multiple independent sources.
The goal is not to remove any textual similarity.
Two similar validations may be different rules from two actors.
Connecting them creates an unjustified dependency.
Conversely, the same tax rule replicated in a separate API and batch job will sooner or later become inconsistent.
Before extracting the common function, ask: Do the two versions express the same rule?
Do they change at the same time?
Should the output/error be the same?
If only the syntax structure is similar, keep the duplication until common knowledge is clear.
## Worked code example

DRY prevents duplication of the same knowledge or rule, not every visual similarity in code.
Similar processes may change for different reasons; merging them too early creates coupling.
Identify the source of truth for each business rule.

**Exercise with answer:** Invoice and report use the same tax rule; centralize that calculation, but do not force their different presentation formats to share code.
This C
# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public static Money CalculateTax(Money subtotal, TaxRate rate)
{
    return (subtotal * rate).RoundToCurrencyUnit();
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

Apply the DRY principle to a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)

</div>
