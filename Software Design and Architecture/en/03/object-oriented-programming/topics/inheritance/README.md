<div dir="ltr" align="left">

# Inheritance
> **Language:** [Persian edition](../../../../../03/object-oriented-programming/topics/inheritance/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Inheritance extends the behavior and type from the base type and expresses the "type of" relationship.
The subtype must behave correctly in place of the base.
## Practical example

`PremiumMember` inherits from `Member` only if it preserves all the operations expected of the normal member.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Inheritance brings coupling and base class fragility.
Composition and delegation are often more flexible.
- **Review:** Don't use inheritance only for code reuse.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: Inheritance extends the behavior and type from the base type and expresses the "type of" relationship.
The subtype must behave correctly in place of the base.
2. **What decision do you make in the example below and why?**   
- Suggested answer: `PremiumMember` inherits from `Member` only when it preserves all expected operations of the normal member.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Inheritance brings coupling and base class fragility.
Composition and delegation are often more flexible.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't use inheritance only for code reuse.
## In-depth lesson for this topic
#### Inheritance

Inheritance can give type relation, reuse behavior and polymorphism.
But "for reuse" is not enough reason.
The subtype relationship must be correct from the consumer's point of view: wherever the base type is used, the subtype must also maintain the behavioral convention.
If a subtype disables a basic operation, requires a stronger precondition, or changes the meaning of the result, that subtype is probably not a valid substitute.
The subclass depends on the base implementation, order of hooks and protected API.
Changing the base class can break inheritors that are owned by another team.
A classic example: a square is mathematically a kind of rectangle, but a rectangular object whose width and height change independently cannot be replaced with a square.
Conceptual sharing does not always make a subtype agreement.
For behaviors that change to multiple independent axes, composition is more appropriate: order takes a DiscountPolicy, rather than creating a new subclass for each customer type and campaign combination.
## Worked code example

Inheritance models an “is-a” relationship, not the default reuse mechanism.
A subtype must preserve its base contract wherever the base is accepted.
If a subclass disables operations or adds incompatible preconditions, prefer composition or separate types.

**Exercise with answer:** Should Square inherit from Rectangle?
Not if Rectangle's contract allows independent width and height; changing one side of a square must preserve a different invariant.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public abstract class Shape
{
    public abstract decimal Area();
}

public sealed class Circle(decimal radius) : Shape
{
    public override decimal Area() => Math.PI * radius * radius;
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

Apply inheritance to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
