<div dir="ltr" align="left">

# The principle of "not necessary at present" (YAGNI) — YAGNI

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/04/design-principles/topics/yagni/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

Don't implement complexity for a need that hasn't been validated yet. Keep the design flexible enough that an established need can be addressed later.


## Practical example

The current payment gateway supports only one payment method; start with a simple interface and test it, delay the plugin framework until the actual need.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Principles of Design" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Some high-cost or safety-critical decisions need early planning.
- **Review:** YAGNI is not an excuse to ignore security, data migration or legal requirements.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: Do not implement complexity for a requirement that has not yet been validated. Keep the design flexible enough that an established need can be addressed later.
2. **What decision do you make in the example below and why?**
   - Suggested answer: The current payment gateway supports only one payment method; start with a simple interface and test it, delay the plugin framework until the actual need.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: Some high-cost or safety-critical decisions need early planning.
4. **Which common error do you check before merging the code?**
   - Suggested Answer: YAGNI is not an excuse to ignore security, data migration or legal requirements.

## In-depth lesson for this topic

### 3. YAGNI — You Aren't Gonna Need It

Don't build a feature for a possible but unproven need. Prospective functionality has costs to build, test, secure, document, and support, and may never be used. Make the design evolvable, but don't impose plugin framework and multi-layer abstraction for vague assumption.

YAGNI is not an excuse to deny security, audit, privacy, data compliance or legal requirements. These are real current needs. Irreversible decisions and data migration may also require early anticipation.
## Worked code example

YAGNI says not to build for hypothetical future needs; include abstraction, maintenance, and wrong-decision costs in the calculation. It does not forbid necessary design or security boundaries. Refactor deliberately when a real need appears.


**Exercise with answer:** Two tax modes are fixed; use a simple function. Extract a policy later when variation becomes real, guided by tests and evidence.

This C# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
static Money CalculateTax(Money subtotal, TaxRate rate)
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

Apply the YAGNI principle to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)
</div>
