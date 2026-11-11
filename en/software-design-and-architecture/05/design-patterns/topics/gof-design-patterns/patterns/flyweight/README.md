<div dir="ltr" align="left">

# Flyweight
> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/flyweight/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** structural · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

It shares common and immutable data among many instances to reduce memory consumption.
## Practical example

Common glyph characters in a large document do not maintain duplicate font data.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** Do not mix intrinsic and extrinsic mode.
Measure the savings.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: It shares common and immutable data between many instances to reduce memory consumption.
2. **What does it structure in this example?**   
- Suggested answer: Common glyph characters in a large document do not maintain duplicate font data.
3. **When is it better to go for the simpler option?**   
- Suggested answer: don't mix intrinsic and extrinsic state.
Measure the savings.
## Pattern family context

This is one of the GoF structural patterns. The [integrated chapter lesson](../../../../lessons.md#2-gof-structural-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

Share large repeated intrinsic data such as a tree's species and texture; each tree's position is extrinsic.
Measure memory savings and keep shared state immutable so one mutation cannot affect all users.

**Exercise with answer:** Coordinates do not belong in TreeStyle.
Each tree owns its position while repeated style data is shared.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public sealed record TreeStyle(string Species, string Color, string Texture);
public sealed record Tree(int X, int Y, TreeStyle SharedStyle);

var oak = new TreeStyle("Oak", "Green", "bark-1");
var forest = new[] { new Tree(10, 20, oak), new Tree(30, 45, oak) };
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
