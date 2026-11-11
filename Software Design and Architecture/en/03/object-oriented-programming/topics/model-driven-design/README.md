<div dir="ltr" align="left">

# Model-Driven Design
> **Language:** [Persian edition](../../../../../03/object-oriented-programming/topics/model-driven-design/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Model-driven design reflects the domain's key vocabulary and rules in the implementation model and connects the domain expert and developer dialogue to the code.
## Practical example

The ordering, refunding and delivery cycles are expressed in the same terms in the dialog, test and domain model.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** The domain model costs discovery and maintenance.
For simple CRUD it may be of little benefit.
- **Review:** Creating many classes with domain names, without rules and invariants, is not considered DDD.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: The model-oriented design reflects the domain's key vocabulary and rules in the implementation model and connects the domain expert and developer's dialogue to the code.
2. **What decision do you make in the example below and why?**   
- Suggested answer: Order, refund and delivery cycles are expressed with the same words in dialogue, test and domain model.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: the domain model has discovery and maintenance costs.
For simple CRUD it may be of little benefit.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Creating many classes with domain names, without rules and invariants, is not considered DDD.
## In-depth lesson for this topic
### 4. Model-oriented design and common language

Domain model is not a storage schema.
It expresses the concepts, behaviors, relationships and rules of the problem world in software language.
To figure it out, talk to your domain expert about actual workflows, exceptions, human decisions, and consequences instead of starting with classes.
#### common language (Ubiquitous Language)

A common term should have a consistent meaning in conversation, code, API, testing, and documentation. "Cancelling the order", "Refunding money" and "Returning goods" are three different actions.
If we call all cancel, the system cannot properly manage the shipping status, money and balance.
Create a short glossary, but don't turn it into a dead document.
Add example and counterexample.
If two business parts use the same word with different meanings, check the bounded context separately and make the translation between the contexts explicit.
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

Model-driven design turns the domain model into an executable expression of rules and interactions.
A diagram is a tool for conversation and reasoning, not the goal.
Validate concepts with domain experts and keep the model tied to observable behavior through examples and tests.

**Exercise with answer:** For reservation cancellation, identify the actor, deadline, payment state, and refund effect; then implement an operation that enforces them together.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public sealed class Reservation
{
    public ReservationState State { get; private set; }
    public DateTimeOffset ExpiresAt { get; }

    public CancellationResult Cancel(DateTimeOffset now)
    {
        if (State != ReservationState.Active || now >= ExpiresAt)
            return CancellationResult.NotAllowed;
        State = ReservationState.Cancelled;
        return CancellationResult.Success;
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

Apply model-driven design to solve a specific problem, document the trade-offs, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
