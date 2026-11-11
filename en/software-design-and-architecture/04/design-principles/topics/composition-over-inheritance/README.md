<div dir="ltr" align="left">

# Composition instead of inheritance — Composition over Inheritance

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/04/design-principles/topics/composition-over-inheritance/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

Build interchangeable behaviors in collaboration with small components so that feature combinations are done without fragile hierarchies.


## Practical example

The shipping calculation method and payment method are injected into the order, rather than making each combination a new subclass.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Principles of Design" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Increases the wiring combination and the number of objects.
- **Revision:** Do not convert composition to unnamed and boundaryless layers.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: Build interchangeable behaviors in collaboration with small components to combine features without fragile hierarchies.
2. **What decision do you make in the example below and why?**
   - Suggested answer: The shipping calculation method and the payment method are injected into the order, rather than turning each combination into a new subclass.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: The combination of wiring and the number of objects increases.
4. **Which common error do you check before merging the code?**
   - Suggested answer: Don't convert the composition to unnamed and boundaryless layers.

## In-depth lesson for this topic

### 7. Composition over Inheritance

Combining behavior from small components instead of building deep hierarchies facilitates independent change and collaboration of multiple capabilities. The order can have a shipping policy and a discount policy. Do not create multiple classes to combine customer, campaign and destination types.

Inheritance is appropriate when the subtype actually preserves the base convention. Composition is not free either: wiring, collaborators and cooperation arrangements must be maintained. If a behavior is simple and stable, no additional interface and strategy are needed.
## Worked code example

With composition, obtain behaviors from independent collaborators instead of creating a subclass for every combination. This enables runtime flexibility but adds delegation. Inheritance remains valid when the relationship is genuinely “is-a.”


**Exercise with answer:** Combine VIP pricing with expedited shipping using two injected policies; four combinations should not require four subclasses.

This C# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public sealed class Checkout(
    IPricingPolicy pricing,
    IShippingPolicy shipping)
{
    public Quote Quote(Order order) =>
        new(pricing.Calculate(order), shipping.Calculate(order));
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

Use composition instead of inheritance to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)
</div>
