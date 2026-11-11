<div dir="ltr" align="left">

# Decorator

> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/decorator/README.md)

> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Family:** structural · 

**Chapter:** [Design Patterns](../../../../README.md)

## Pattern intent

Adds behavior to the object with composable wrappers without increasing the number of subclasses.

## Practical example

We cover the calculation of sending cost with limited logging and retry.

## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.



**Important limitation:** Chaining of wrappers makes debugging difficult and ordering important.

## Test questions with answers

1. **Which problem does it solve?**
   - Suggested answer: Adds behavior with composable wrappers to the object without increasing the number of subclasses.
2. **What does it structure in this example?**
   - Suggested answer: We cover the calculation of sending cost with limited logging and retry.
3. **When is it better to go for the simpler option?**
   - Suggested answer: A chain of wrappers makes debugging difficult and ordering important.

## Pattern family context

This is one of the GoF structural patterns. The [integrated chapter lesson](../../../../lessons.md#2-gof-structural-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

A same-contract wrapper can add tax or logging around a calculator. Wrapper order affects behavior; make the chain visible and test each composition. Too many wrappers make tracing difficult.


**Exercise with answer:** Does discount apply before or after tax? Define the business rule and lock the order in composition and tests.

The C# block is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public sealed class TaxCalculator(IPriceCalculator inner) : IPriceCalculator
{
    public Money Calculate(Order order)
    {
        var subtotal = inner.Calculate(order);
        return subtotal + TaxFor(order, subtotal);
    }
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
