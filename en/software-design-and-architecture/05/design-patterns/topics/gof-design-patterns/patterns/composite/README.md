<div dir="ltr" align="left">

# Composite
> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/composite/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** structural · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

Processes single objects and returned collections through the same shared contract.
## Practical example

Basket discounts and pen discounts are collected in the form of a tree.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important restriction:** The tree must have consistent rules.
Not every hierarchical structure requires a composite.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: It processes single objects and return sets through the same shared contract.
2. **What does it structure in this example?**   
- Suggested answer: basket discount and pen discount are collected in the form of a tree.
3. **When is it better to go for the simpler option?**   
- Suggested answer: the tree must have consistent rules.
Not every hierarchical structure requires a composite.
## Pattern family context

This is one of the GoF structural patterns. The [integrated chapter lesson](../../../../lessons.md#2-gof-structural-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

Files and folders share a size contract; a folder recursively totals its children.
This works when an operation means the same thing for leaves and groups.
Different behaviors or parent coordination may make it unsuitable.

**Exercise with answer:** An empty folder has size zero; define it so callers need no special case.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public interface IStorageNode { long SizeBytes(); }

public sealed record FileNode(long Bytes) : IStorageNode
{
    public long SizeBytes() => Bytes;
}

public sealed record FolderNode(IReadOnlyList<IStorageNode> Children) : IStorageNode
{
    public long SizeBytes() => Children.Sum(child => child.SizeBytes());
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
