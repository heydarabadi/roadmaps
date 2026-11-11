<div dir="ltr" align="left">

# Programming based on abstraction — Program Against Abstractions

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/04/design-principles/topics/program-to-abstractions/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

Consumer logic depends on a contract that expresses its needs, not on the details of an SDK or database.


## Practical example

The order service uses `InventoryReservation` and the adapter connects it to the warehouse API.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Principles of Design" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Poor abstraction doesn't hide details and changing it breaks everything.
- **Revision:** Make the abstraction just for mocking. The contract should reflect the language of the issue.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: Consumer logic depends on a contract that expresses its needs, not on the details of an SDK or database.
2. **What decision do you make in the example below and why?**
   - Suggested answer: The order service uses `InventoryReservation` and the adapter connects it to the warehouse API.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: Poor abstraction doesn't hide details and changing it breaks everything.
4. **Which common error do you check before merging the code?**
   - Suggested answer: make the abstraction just for mocking. The contract should reflect the language of the issue.

## In-depth lesson for this topic

### 9. Program to Abstractions

The consumer depends on a contract that expresses its needs, not a concrete class or an external SDK. This idea is close to DIP, but the emphasis is on selecting the point of use: the use case only requires the authorize capability, not all of the vendor's operations.

The abstraction should preserve the meaning and translate the failure mode. If the API still emits the vendor type and exception, the consumer is still bound to details. Do not create an interface for each concrete class. Keep it for the boundary of change, testing or a few real implementations.
## Worked code example

Consumer code should depend on the needed contract, not a particular concrete class; the composition root selects the implementation. An abstraction should describe the consumer's vocabulary rather than merely hide an SDK name.


**Exercise with answer:** A use case only needs to send a message; depend on IMessageSender so email or SMS can be selected without changing the use case.

This C# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public interface IMessageSender
{
    Task Send(Message message, CancellationToken ct);
}

public sealed class ReminderJob(IMessageSender sender)
{
    public Task Run(Message message, CancellationToken ct)
        => sender.Send(message, ct);
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

Apply abstraction-based programming to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)
</div>
