<div dir="ltr" align="left">

# Status — State
> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/state/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

Delegates behavior to internal state so that allowed transitions and behavioral differences are focused.
## Practical example

Ordering in `Draft`, `Paid`, `Shipped` mode allows different operations.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** Do not create many classes for a small condition.
Model the complete allowed transitions.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: leaves the behavior to the internal state so that the allowed transitions and the behavior difference are focused.
2. **What does it structure in this example?**   
- Suggested answer: Order in `Draft`, `Paid`, `Shipped` mode allows different operations.
3. **When is it better to go for the simpler option?**   
- Suggested answer: Don't make many classes for a small condition.
Model the complete allowed transitions.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

Define behavior and allowed transitions from the order's current state.
State objects help complex lifecycles; an enum and transition function suit a small set.
Persist the state change and side effect atomically.

**Exercise with answer:** A cancelled order cannot ship; reject that transition and test both allowed and forbidden paths.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public interface IOrderState
{
    IOrderState Pay(Order order);
    IOrderState Ship(Order order);
}

public sealed class DraftState : IOrderState
{
    public IOrderState Pay(Order order) => new PaidState();
    public IOrderState Ship(Order order) =>
        throw new InvalidOperationException("Draft cannot ship.");
}
~~~


## Resources
### Persian

- [Persian design patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian summaries of GoF patterns and several architecture patterns.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian textbook resource for GoF, GRASP and architectural patterns.
### English

- [Refactoring.Guru; Design Patterns](https://refactoring.guru/design-patterns) — List of GoF patterns and multilingual examples.
- [Patterns.Guru; GoF catalog](https://patterns.guru/) — A catalog and discussion of pattern intent and selection costs.
- [Wiley; POSA Volume 3 excerpt](https://catalogimages.wiley.com/images/db/pdf/9780470845257.excerpt.pdf) — An example of architecture and concurrency patterns in the POSA suite.
## Further reading

[Curated references for this chapter](../../../../../../references.md#chapter-05)

</div>
