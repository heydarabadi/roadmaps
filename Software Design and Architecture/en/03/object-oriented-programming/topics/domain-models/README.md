<div dir="ltr" align="left">

# Domain model — Domain Models
> **Language:** [Persian edition](../../../../../03/object-oriented-programming/topics/domain-models/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The domain model represents the concepts, behavior, relationships and constraints of the problem in software language.
It should stay in tune with the actual business rules.
## Practical example

`Order` handles sum total, allowed status and cancel condition, not just fields.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Don't force the software to model all the details of the company.
Use case scope is important.
- **Review:** Don't mindlessly accept the database data model as the domain model.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: the domain model represents the concepts, behavior, relationships and constraints of the problem in the software language.
It should stay in tune with the actual business rules.
2. **What decision do you make in the example below and why?**   
- Suggested answer: `Order` handles sum total, allowed status and cancellation condition, not just fields.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Don't force the software to model all the details of the company.
Use case scope is important.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't mindlessly accept the database data model as the domain model.
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

A domain model captures the state and invariants of the problem's concepts; a database schema is only one persistence representation.
Derive valid values and transitions from domain conversations, then review the model against real examples.

**Exercise with answer:** Are two orders with the same identity but different totals the same entity?
Identity determines continuity, but a total change must still follow a valid domain rule.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public sealed class Order
{
    public OrderId Id { get; }
    public Money Total { get; private set; }
    public OrderStatus Status { get; private set; }

    public void AddLine(Product product, Quantity quantity)
    {
        if (Status != OrderStatus.Draft) throw new InvalidOperationException();
        Total += product.Price * quantity.Value;
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

Apply the domain model to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
