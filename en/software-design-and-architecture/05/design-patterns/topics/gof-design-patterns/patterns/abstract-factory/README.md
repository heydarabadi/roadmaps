<div dir="ltr" align="left">

# Abstract Factory

> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/abstract-factory/README.md)

> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Family:** creational · 

**Chapter:** [Design patterns](../../../../README.md)

## Pattern intent

Creates a family of related objects without the consumer's dependency on the specified classes.

## Practical example

The user interface gets the same style buttons and windows for each platform.

## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important Limitation:** If only one type of product is variable, the large factory incurs unreasonable costs.

## Test questions with answers

1. **Which problem does it solve?**
   - Suggested answer: Creates a family of related objects without requiring the consumer to specify classes.
2. **What does it structure in this example?**
   - Suggested answer: The user interface gets the same style button and window for each platform.
3. **When is it better to go for the simpler option?**
   - Suggested answer: If only one type of product is variable, the large factory incurs unreasonable costs.

## Pattern family context

This is one of the GoF creational patterns. The [integrated chapter lesson](../../../../lessons.md#1-gof-creational-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

A UI editor supports multiple themes, and each theme must create compatible buttons and text fields. The client receives a family without knowing concrete types. This fits when products vary together; adding a product updates every factory.


**Exercise with answer:** Add a light theme without changing the screen. Add its factory and products. If the client changes too, it still depends on concrete types.

The C# block is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public interface IWidgetFactory
{
    IButton CreateButton();
    ITextField CreateTextField();
}

public sealed class DarkWidgetFactory : IWidgetFactory
{
    public IButton CreateButton() => new DarkButton();
    public ITextField CreateTextField() => new DarkTextField();
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
