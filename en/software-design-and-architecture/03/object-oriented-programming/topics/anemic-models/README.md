<div dir="ltr" align="left">

# Anemic model — Anemic Models
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/03/object-oriented-programming/topics/anemic-models/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

An anemic model holds mostly data while business logic lives in external services.
That can be reasonable for simple CRUD, but scattered services become difficult to maintain when complex rules are repeated across workflows.
## Practical example

A simple data record is sufficient for listing settings.
For placing an order, keep important invariants in the domain model or in a clearly owned domain policy so every workflow applies them consistently.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **when to keep it simple:** A rich domain model adds modeling and testing work.
Do not burden simplicity unnecessarily.
- **Review:** Don't apply the anti-pattern tag to any DTO without measuring the complexity of the domain.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: an anemic model holds mostly data while business logic lives in external services.
That can be reasonable for simple CRUD, but scattered services become difficult to maintain when complex rules are repeated across workflows.
2. **What decision do you make in the example below and why?**   
- Suggested answer: a simple data record is enough for listing settings.
For placing an order, keep important invariants in the domain model or in a clearly owned domain policy so every workflow applies them consistently.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: A rich domain model adds modeling and testing work.
Do not burden simplicity unnecessarily.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't apply the anti-pattern tag to any DTO without measuring the complexity of the domain.
## In-depth lesson for this topic
#### Rich domain model and behaviorless model

The rich model keeps state and rules close together.
It is useful when we have important or variable invariants.
The behaviorless model is mainly data and operations are placed in services.
For simple CRUD, reporting or data transfer may be inexpensive and correct.
An anemic model becomes a problem when:
- A rule is repeated in several handlers;
- read the caller state, make a decision and call the setter;
- Invalid transition from several possible paths;
- Multiple services for the same concept produce different results.
In such a situation, find the owner of the invariant and transfer the behavior to it.
Don't blindly put the anti-pattern tag on every data record.
Measure the actual complexity.
## Worked code example

An anemic model stores data and leaves rules to scattered services.
That can be fine for a DTO or simple CRUD, but invariants should not be repeated across callers.
Place domain behavior with the owner of the state.

**Exercise with answer:** What prevents a paid order from being cancelled?
The Order itself checks the transition; hiding a setter alone is not enough.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public sealed class Order
{
    public OrderStatus Status { get; private set; }

    public void Cancel()
    {
        if (Status == OrderStatus.Paid)
            throw new InvalidOperationException("Refund first.");
        Status = OrderStatus.Cancelled;
    }
}
~~~


## Resources
### Persian

- [Book of object-oriented programming; Programmer's House](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — An introductory Persian reference for object-oriented concepts.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian academic course about object-oriented design and patterns.
### English

- [Microsoft Learn.Object-oriented programming](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — Object-oriented concepts with C# examples.
- [Oracle Java Tutorials; Classes and Objects](https://docs.oracle.com/javase/tutorial/java/concepts/) — class model, object, inheritance and interfaces.
## Summary

Apply the anemic model to the specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
