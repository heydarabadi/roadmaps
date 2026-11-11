<div dir="ltr" align="left">

# Domain Language
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/03/object-oriented-programming/topics/domain-language/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Domain language is the shared and precise words between the business expert and the technical team.
Reduces ambiguity in names, APIs, and tests.
## Practical example

If "reservation" is different from "firm order", define two words and two transitions separately.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** The common language for each bounded context may be different.
- **Review:** Do not use a general word like `status` for several unrelated concepts.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: the domain language is the common and precise words between the business expert and the technical team.
Reduces ambiguity in names, APIs, and tests.
2. **What decision do you make in the example below and why?**   
- Suggested answer: If "reservation" is different from "firm order", define two words and two transitions separately.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: The common language for each bounded context may be different.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Do not use a general word like `status` for several unrelated concepts.
## In-depth lesson for this topic
#### common language (Ubiquitous Language)

A common term should have a consistent meaning in conversation, code, API, testing, and documentation. "Cancelling the order", "Refunding money" and "Returning goods" are three different actions.
If we call all cancel, the system cannot properly manage the shipping status, money and balance.
Create a short glossary, but don't turn it into a dead document.
Add example and counterexample.
If two business parts use the same word with different meanings, check the bounded context separately and make the translation between the contexts explicit.
## Worked code example

Align code vocabulary with the words domain experts use to make decisions.
Method names should express business intent, not merely a database mutation.
If teams use a term differently, record its definition and a boundary example.

**Exercise with answer:** ReserveSeat(capacity) communicates intent and required conditions better than DecreaseAvailableSeats(1), which describes only a numeric effect.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public ReservationResult ReserveSeat(
    CustomerId customerId, EventId eventId, SeatCount requested)
{
    // Apply eligibility, capacity, and duplicate-reservation rules here.
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

Apply the domain language to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
