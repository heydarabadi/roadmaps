<div dir="ltr" align="left">

# Interface Segregation Principle (ISP) — Interface Segregation Principle
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/04/design-principles/topics/interface-segregation/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

A consumer should not depend on methods it does not use.
Client role-centric interfaces limit change.
## Practical example

Instead of one big portal including refund, capture and payout for everyone, separate the payment functions you really need.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Design" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** The number of small interfaces can reduce readability.
- **Review:** Don't shred the interface just because of the file size.
See the dependence and need of the consumer.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: the consumer should not depend on methods that he does not use.
Client role-centric interfaces limit change.
2. **What decision do you make in the example below and why?**   
- Suggested answer: instead of one big portal including refund, capture and payout for everyone, separate the payment functions that are really needed.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: The number of small interfaces can reduce readability.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't shred the interface just because of the file size.
See the dependence and need of the consumer.
## In-depth lesson for this topic
#### I — Interface Segregation

A consumer should not depend on an operation that it does not need.
Divide the large interface with unrelated methods according to the user's capability.
But building countless single-method interfaces also makes it difficult to understand the architecture.
First, see the real role of callers.
## Worked code example

A client should not depend on operations it does not use.
Split interfaces around consumer roles, but avoid pointless one-method interfaces.
Base the boundary on real consumer dependencies and independently changing capabilities.

**Exercise with answer:** A basic device only prints; do not force it to implement Scan.
Keep printer and scanner contracts separate.
This C
# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public interface IPrinter
{
    Task Print(Document document, CancellationToken ct);
}

public interface IScanner
{
    Task<Scan> Scan(CancellationToken ct);
}

public sealed class BasicPrinter : IPrinter { /* print only */ }
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

Apply the Interface Isolation Principle (ISP) to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)

</div>
