<div dir="ltr" align="left">

# Abstraction
> **Language:** [Persian edition](../../../../../03/object-oriented-programming/topics/abstraction/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Abstraction keeps the details behind the concept that the consumer needs for their work.
A good boundary comes from the language and rules of the problem.
## Practical example

The storage API provides the `save` operation order, keeping the SQL details out of the use case.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Too much abstraction creates a false model or worthless layer.
- **Review:** An interface that leaks all implementation details is not an effective abstraction.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: Abstraction keeps the details behind the concept that the consumer needs for their work.
A good boundary comes from the language and rules of the problem.
2. **What decision do you make in the example below and why?**   
- Suggested answer: API provides `save` order storage operation and keeps the SQL details out of the use case.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Too much abstraction creates a false model or a worthless layer.
4. **Which common error do you check before merging the code?**   
- Suggested answer: An interface that leaks all implementation details is not an effective abstraction.
## In-depth lesson for this topic
#### Abstraction

Abstraction keeps the contract necessary for the consumer and hides irrelevant details.
The order use case needs to know how to reserve the item, not how each database connection and SQL query works.
Abstract from consumer needs: What is needed?
What results and failures are possible?
What details should not reach the caller?
If the API still gives an ORM entity or raw vendor error, the abstraction is not complete.
Not every interface is valuable.
If there is only one implementation, no test seam, and no reason to change, the contract can be just an extra layer.
Premature abstraction guesses the future.
Adequate abstraction limits real change.
## Worked code example

A use case needs only the operations required for its job; database and vendor details stay behind the boundary.
Derive the contract from the consumer's needs and model observable failures.
An interface that merely mirrors implementation details is not a useful abstraction.

**Exercise with answer:** What changes when the payment provider changes?
Add an adapter for the same contract; the use case stays stable.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public interface IPaymentGateway
{
    Task<PaymentResult> Capture(Money amount, CancellationToken ct);
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

Apply abstraction to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
