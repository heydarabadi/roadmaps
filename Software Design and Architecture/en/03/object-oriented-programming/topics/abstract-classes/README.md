<div dir="ltr" align="left">

# Abstract Classes

> **Language:** [Persian edition](../../../../../03/object-oriented-programming/topics/abstract-classes/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

An abstract class provides part of the contract or common implementation but is not directly instantiated. It has different restrictions in different languages.


## Practical example

In a multi-format parser framework, only the reliable common algorithm is taken from the abstract base.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** An abstract base type binds inheritors to implementation details.
- **Review:** Don't make an abstract class just to hold a few functions.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: An abstract class provides part of the contract or common implementation, but is not directly instantiated. It has different restrictions in different languages.
2. **What decision do you make in the example below and why?**
   - Suggested answer: In a multi-format parser framework, only the reliable common algorithm is taken from the abstract base.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: An abstract base type binds inheritors to implementation details.
4. **Which common error do you check before merging the code?**
   - Suggested answer: Don't make an abstract class just to hold a few functions.

## In-depth lesson for this topic

#### Abstract class

An abstract class is not directly instantiated and may have a shared implementation or template algorithm. Template Method is suitable when the sequence of steps is fixed and one step can be changed. If the subclasses change order or there are multiple independent axes of variation, composition usually has less coupling.
## Worked code example

An abstract class fits when implementations share a contract plus an invariant and part of an algorithm. Subclasses should supply only genuinely variable steps. If collaboration is contract-only or behavior varies at runtime, prefer an interface with composition.


**Exercise with answer:** Import must always validate before persisting; keep that order in the template method and make only format parsing abstract.

This C# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public abstract class Importer
{
    public async Task Import(CancellationToken ct)
    {
        var rows = Parse(await Read(ct));
        Validate(rows);
        await Persist(rows, ct);
    }

    protected abstract Task<string> Read(CancellationToken ct);
    protected abstract IReadOnlyList<Row> Parse(string input);
    protected abstract Task Persist(IReadOnlyList<Row> rows, CancellationToken ct);
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

Apply an abstract class to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)
</div>
