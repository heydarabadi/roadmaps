<div dir="ltr" align="left">

# Encapsulate What Varies
> **Language:** [Persian edition](../../../../../04/design-principles/topics/encapsulate-what-varies/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

isolate the point of possible change and put a contract around it.
Isolation should be based on observed or probable change.
## Practical example

Country-specific tax rules are placed in separate policies, while order orchestration remains the same.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Design" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Every possible difference does not require an extension point.
- **Review:** Don't predict the future too much.
Track real-time change.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: isolate the point of possible change and put a contract around it.
Isolation should be based on observed or probable change.
2. **What decision do you make in the example below and why?**   
- Suggested answer: Country-specific tax rules are placed in separate policies, while order orchestration remains the same.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Any possible difference does not require an extension point.
4. **Which common error do you check before merging the code?**   
- Suggested answer: don't predict the future too much.
Track real-time change.
## In-depth lesson for this topic
### 8. Encapsulate What Varies

Isolate the part that is likely to change differently from the other parts.
Find this possibility from recent changes, domain rules, multiple client requirements or vendor dependency.
Abstraction based solely on "maybe one day" is usually speculative.
Example: the tax rate for countries changes independently.
Calculation of subtotal may be fixed.
We separate the rate policy but do not divide the invoice orchestration into ten interfaces.
## Worked code example

Hide the dimension that truly varies behind a contract; keep stable policy independent of volatile details.
This adds types and indirection, so justify the boundary with observed or credible change.

**Exercise with answer:** Shipping methods have changed repeatedly, so isolate them.
If one method is fixed and unlikely to change, keep a simple function until evidence supports extraction.
This C
# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public interface IShippingFee
{
    Money Calculate(Parcel parcel, Destination destination);
}

public sealed class Checkout(IShippingFee fee)
{
    public Money DeliveryCost(Parcel parcel, Destination destination)
        => fee.Calculate(parcel, destination);
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

Apply encapsulation of what changes to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)

</div>
