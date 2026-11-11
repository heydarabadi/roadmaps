<div dir="ltr" align="left">

# Class Variants
> **Language:** [Persian edition](../../../../../03/object-oriented-programming/topics/class-variants/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Class types are methods for modeling states and behavior differences: subclass, composition, sum type or strategy.
The selection should turn off the invalid state.
## Practical example

The shipping method is modeled with `StandardDelivery` and `Pickup`, and only the allowed options are made in each order.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** A class makes an explosion of the number of types for every possible combination.
A simple enum is sometimes enough.
- **Revision:** Convert composable booleans to state model so that invalid combination is not possible.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: class types are methods for modeling states and behavior differences: subclass, composition, sum type or strategy.
The selection should turn off the invalid state.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The shipping method is modeled with `StandardDelivery` and `Pickup` and only the allowed options are made in each order.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: A class for each possible combination makes an explosion of the number of types.
A simple enum is sometimes enough.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Convert composable booleans to a state model so that invalid combinations are not possible.
## In-depth lesson for this topic
#### Entity, value and class variant

Entity is known by its stable identity and lifecycle.
Customer's email is changed, CustomerId is the same.
Value object has meaning based on value.
Money(100, USD) is equal to Money(100, USD), but 100 USD is not equal to 100 EUR.
The value object is usually immutable and takes the invariant when it is constructed.
Model states and variants in such a way that invalid combinations are minimized.
Two booleans can form four combinations, of which only one may be allowed.
Select enum, tagged union, subclass or composition based on number of states, independent behavior and change direction.
More class is not always a better model.
## Worked code example

Use subtypes when variants truly share a behavioral contract and can substitute for one another.
For several flags that allow invalid combinations, explicit state types or a discriminated union are clearer.
Adding a variant should keep client behavior predictable.

**Exercise with answer:** Replace three payment booleans with distinct Pending, Authorized, and Captured states, and reject illegal transitions in the model.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public abstract record PaymentState;
public sealed record Pending : PaymentState;
public sealed record Authorized(string Reference) : PaymentState;
public sealed record Captured(string Reference, Money Amount) : PaymentState;

public sealed record Payment(PaymentState State);
~~~


## Resources
### Persian

- [Book of object-oriented programming; Programmer's House](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — An introductory Persian reference for object-oriented concepts.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian academic course about object-oriented design and patterns.
### English

- [Microsoft Learn.Object-oriented programming](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — Object-oriented concepts with C# examples.
- [Oracle Java Tutorials; Classes and Objects](https://docs.oracle.com/javase/tutorial/java/concepts/) — class model, object, inheritance and interfaces.
## Summary

Apply class variants to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
