<div dir="ltr" align="left">

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/04/design-principles/topics/tell-dont-ask/README.md)Tell, Don't Ask — Tell, Don't Ask
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Tell the data object to perform an operation so that the conditional logic is not duplicated outside of the state owner.
## Practical example

Message `Order` to `cancel(reason)` to check the eligibility itself, instead of reading and setting the status from outside.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Design" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** The coordinator sometimes needs to read information to order the use case.
Not all queries are deleted.
- **Review:** Liability is not fixed just by moving the code to the model for no reason.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: tell the data object to perform an operation so that the conditional logic is not duplicated outside of the state owner.
2. **What decision do you make in the example below and why?**   
- Suggested answer: send `Order` a message to `cancel(reason)` to check the eligibility itself, instead of reading and setting the status from outside.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: the coordinator sometimes needs to read information to order the use case.
Not all queries are deleted.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Just by moving the code to the model for no reason, the responsibility will not be fixed.
## In-depth lesson for this topic
### 5. Tell, Don't Ask — Tell, don't ask

When object owns state and invariant, give it operation instead of reading state, decide outside and setter.

~~~csharp
public void Cancel(CancellationReason reason)
{
    if (Status != OrderStatus.Draft)
        throw new InvalidOperationException();
    Status = OrderStatus.Cancelled;
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

Apply Say, Don't Ask to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)

</div>
