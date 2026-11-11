<div dir="ltr" align="left">

# Hollywood Principle

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/04/design-principles/topics/hollywood-principle/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

The downstream component does not control the flow. The framework or coordinator calls the component via a hook/contract (“we call you”).


## Practical example

The web framework calls the request to the injected handler, and the framework handler does not inject the framework into the domain logic.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Principles of Design" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Control is taken out of the consumer's hands and the flow becomes harder to follow.
- **Review:** Do not equate this principle with any dependency injection or callback. The call path must remain traceable.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: The downstream component does not control the flow. The framework or coordinator calls the component via a hook/contract (“we call you”).
2. **What decision do you make in the example below and why?**
   - Suggested answer: The web framework calls the request to the injected handler, and the framework handler does not inject the framework into the domain logic.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: control is taken out of the consumer's hands and it becomes more difficult to follow the flow.
4. **Which common error do you check before merging the code?**
   - Suggested answer: Do not equate this principle with any dependency injection or callback. The call path must remain traceable.

## In-depth lesson for this topic

### 6. Hollywood Principle - Give control to the frame

The "we call you" rule says that the framework or coordinator is in control of the flow of control, and the component is called via a hook or contract. Example: the framework hands over the request to the injected handler. The handler should not control the server cycle itself.

This method makes extension point and inversion of control possible, but makes the execution flow less obvious. Clear trace, log and naming are required. Dependency Injection alone is not the complete Hollywood Principle. The main focus is on call control.
## Worked code example

The Hollywood Principle says a framework controls the overall flow and calls application code at defined hooks. This inversion can make lifecycle consistent, but unclear hooks make control flow difficult to follow.


**Exercise with answer:** The application should not manage the host's main loop; implement Start and Stop callbacks and let the host call them at the right time.

This C# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public interface IApplicationLifecycle
{
    Task OnStart(CancellationToken ct);
    Task OnStop(CancellationToken ct);
}

public sealed class Host(IApplicationLifecycle app)
{
    public async Task Run(CancellationToken ct)
    {
        await app.OnStart(ct);
        await WaitForShutdown(ct);
        await app.OnStop(ct);
    }
}
~~~


## Resources

### Persian

- [GoFarsi; SOLID in Go](https://book.gofarsi.ir/chapter-9/solid-principle-in-golang/) — Persian explanation of SOLID with the Go language angle.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — tutorial description of SOLID, GRASP, design and refactoring smells.
- [Persian design patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian list of patterns and a summary of each problem.

### English

- [Refactoring.Guru; SOLID principles](https://refactoring.guru/design-patterns/solid-principles) — definition and example of each SOLID principle.
- [Martin Fowler; Is Design Dead?](https://martinfowler.com/articles/designDead.html) — Evolutionary Design and the Cost of Early Decisions.

## Summary

Apply the Hollywood principle to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)
</div>
