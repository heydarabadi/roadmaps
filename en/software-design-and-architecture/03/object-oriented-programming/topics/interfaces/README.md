<div dir="ltr" align="left">

# Interfaces

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/03/object-oriented-programming/topics/interfaces/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

interface is a behavioral contract between the consumer and the implementation. The stable interface allows adapter replacement and boundary testing.


## Practical example

The use case depends on `Clock` to fix the time in test and read from the actual clock in production.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** The interface has additional maintenance cost. Do not hide any internal details behind abstraction.
- **Review:** interface should not be tied to specific implementation or CRUD of a table.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: interface is a behavioral contract between the consumer and the implementation. The stable interface allows adapter replacement and boundary testing.
2. **What decision do you make in the example below and why?**
   - Suggested answer: use case depends on `Clock` to fix time in test and read from actual clock in production.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: the interface has additional maintenance costs. Do not hide any internal details behind abstraction.
4. **Which common error do you check before merging the code?**
   - Suggested answer: interface should not be tied to specific implementation or CRUD of a table.

## In-depth lesson for this topic

#### Interface

Interface is a capability contract. For example, the PaymentAuthorizer tells what to do with the consumer. Design the interface from the consumer's needs, not from the vendor's entire SDK. If a large interface provides all payment, refund, reporting, and configuration operations, consumers become dependent on irrelevant operations. A smaller contract based on roles may be appropriate.
## Worked code example

An interface separates contract from implementation and helps with multiple implementations, a test seam, or independent ownership. Define it from the consumer's needs and include failure behavior; an oversized or unused interface only relocates coupling.


**Exercise with answer:** If a use case needs only Capture, keep that operation in its contract; place search, refund, and reporting in separate interfaces.

This C# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public interface IPaymentCapture
{
    Task<PaymentResult> Capture(Money amount, CancellationToken ct);
}

public sealed class Checkout(IPaymentCapture payments)
{
    public Task<PaymentResult> Pay(Money amount, CancellationToken ct)
        => payments.Capture(amount, ct);
}
~~~


## Resources

### Persian

- [Book of object-oriented programming; Programmer's House](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — An introductory Persian reference for object-oriented concepts.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian academic course about object-oriented design and patterns.

### English

- [Microsoft Learn. Object-oriented programming](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — Object-oriented concepts with C# examples.
- [Oracle Java Tutorials; Classes and Objects](https://docs.oracle.com/javase/tutorial/java/concepts/) — class model, object, inheritance and interfaces.

## Summary

Apply interfaces to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)
</div>
