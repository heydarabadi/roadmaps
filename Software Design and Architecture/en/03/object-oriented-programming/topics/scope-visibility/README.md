<div dir="ltr" align="left">

# Scope and Visibility
> **Language:** [Persian edition](../../../../../03/object-oriented-programming/topics/scope-visibility/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

scope determines the place of validity of the name in the code and visibility determines which external code has access to the member.
The access level is part of the API and the change boundary.
## Practical example

Order status conversion rules remain private and only valid domain operations are public.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Extreme closure can block reusability.
Extreme openness creates coupling.
- **Revision:** Making everything public for today's speed closes future design options.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: scope determines the place of validity of the name in the code and visibility determines which external code has access to the member.
The access level is part of the API and the change boundary.
2. **What decision do you make in the example below and why?**   
- Suggested answer: the order status conversion rules remain private and only valid domain operations are public.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: extreme closure can block reusability.
Extreme openness creates coupling.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Generalizing everything for today's speed closes off future design options.
## In-depth lesson for this topic
#### Scope and visibility

Scope is the range of validity of the name in the language: block, function, module or global.
Visibility is the external access level: private, protected, internal/package or public.
The two are related but not the same.
Start with the lowest required visibility. public member creates an external supported contract, and changing it requires compatibility. protected is also a type of API for inheritors. global mutable state makes it hard to track the change.
Immutable constant is less risky.
## Worked code example

Scope determines where a name is valid; visibility determines which outside code can access a member.
Access level is part of the API and affects change cost.
Choose the narrowest sufficient visibility instead of exposing internals for convenience.

**Exercise with answer:** A helper is used only inside one class, so private is enough.
Use protected only when subclasses genuinely need a documented extension point.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public class Account
{
    private Money _balance;
    protected virtual void OnBalanceChanged() { }
    public Money Balance => _balance;
    internal void Reconcile(Money value) => _balance = value;
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

Apply the scope and access level to solve the specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
