<div dir="ltr" align="left">

# Open-Closed Principle (OCP) — Open-Closed Principle
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/04/design-principles/topics/open-closed/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Behavior should be open to expansion as needed, but adding new variants should not continuously change stable and tested code.
## Practical example

The new type of discount comes from the policy contract when the discount rules change really regularly.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Design" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Early extension point guesses a requirement and imposes complexity in advance.
- **Review:** Don't consider every switch bad.
Limited and stable branches are sometimes the easiest choice.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: The behavior should be open to expansion as needed, but adding new variants should not continuously change stable and tested code.
2. **What decision do you make in the example below and why?**   
- Suggested Answer: The new type of discount is implemented in the policy contract when the discount rules are really changing regularly.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: premature extension point guesses the requirement and imposes the complexity in advance.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't consider every switch bad.
Limited and stable branches are sometimes the easiest choice.
## In-depth lesson for this topic
#### O — Open-Closed

Code should be open to changing behavior by adding appropriate extensions, while not tampering with stable parts unnecessarily.
The goal is not to prevent any edit.
The goal is to reduce the risk of changing sensitive and tested logic.
If discount method is added regularly, strategy or rule registry may help.
If there are only two constant types and the change is once a year, a readable and simple switch might be better.
OCP is more appropriate for a change axis where we have real evidence of growth.
## Worked code example

Keep code open to extension along a change axis supported by evidence; the goal is not to prevent every edit.
Premature abstraction freezes imaginary options, while a volatile and sensitive rule may be safer behind a replaceable policy.

**Exercise with answer:** A new discount method arrives every month; add a separate policy with explicit registration.
For two stable cases, a clear switch may be better.
This C
# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public interface IDiscountPolicy
{
    Money Calculate(Order order);
}

public sealed class Checkout(IDiscountPolicy discount)
{
    public Money Total(Order order) => order.Subtotal - discount.Calculate(order);
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

Apply the Open-Close Principle (OCP) to a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)

</div>
