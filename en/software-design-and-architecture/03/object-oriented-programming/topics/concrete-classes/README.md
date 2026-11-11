<div dir="ltr" align="left">

# Concrete Classes
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/03/object-oriented-programming/topics/concrete-classes/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

An concrete class implements the necessary contract and can be instantiated.
It should have complete and valid behavior for the intended application.
## Practical example

`StripeGateway` is an object adapter that implements the payment contract for a specified port.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Making the concrete class directly in all consumers makes it hard to modify and test.
- **Revision:** Separate dependency construction and injection from use case logic.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: the concrete class implements the necessary contract and can be instantiated.
It should have complete and valid behavior for the intended application.
2. **What decision do you make in the example below and why?**   
- Suggested answer: `StripeGateway` is an objective adapter that implements the payment contract for a specific port.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Making the object class directly in all consumers makes it hard to modify and test.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Separate dependency construction and injection from use case logic.
## In-depth lesson for this topic
#### Concrete class

The object class fully implements the contract and is constructible.
StripeGateway is an example of a concrete adapter. composition root or factory must configure sensitive dependencies.
Multiple callers should not update the real port by themselves.
Don't make the interface just for "maybe someday".
## Worked code example

A concrete class supplies implementation details and can be instantiated directly.
Keep its construction in the composition root so business rules do not depend on SQL, an SDK, or the network.
Do not create an interface for every class; use a boundary when variation, ownership, or testing justifies it.

**Exercise with answer:** Where should the real repository be connected?
In the composition root; the use case sees only the storage contract.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public interface IOrderRepository
{
    Task<Order?> Find(OrderId id, CancellationToken ct);
}

services.AddScoped<IOrderRepository, SqlOrderRepository>();
~~~


## Resources
### Persian

- [Book of object-oriented programming; Programmer's House](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — An introductory Persian reference for object-oriented concepts.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian academic course about object-oriented design and patterns.
### English

- [Microsoft Learn.Object-oriented programming](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — Object-oriented concepts with C# examples.
- [Oracle Java Tutorials; Classes and Objects](https://docs.oracle.com/javase/tutorial/java/concepts/) — class model, object, inheritance and interfaces.
## Summary

Apply the concrete class to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
