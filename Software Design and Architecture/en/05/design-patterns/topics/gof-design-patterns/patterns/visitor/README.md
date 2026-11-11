<div dir="ltr" align="left">

# Visitor
> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/visitor/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

It separates the operation from the element structure when the element type is stable and the new operation is frequent.
## Practical example

Multiple outputters generate reports, code, and documentation on a persistent AST.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** Adding element type will change all visitors; double dispatch is also verbose.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: It separates operations from the structure of elements when the type of elements is stable and the new operation is frequent.
2. **What does it structure in this example?**   
- Suggested answer: Multiple outputters generate reports, code, and documentation on a persistent AST.
3. **When is it better to go for the simpler option?**   
- Suggested answer: adding element type changes all visitors; double dispatch is also verbose.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

When document node types are stable but operations grow, Visitor keeps operations outside the nodes.
Adding a node requires changing every visitor, so this is a poor fit for frequently changing node types.

**Exercise with answer:** Add a WordCountVisitor with behavior for every node.
If new nodes are missed, add compiler-visible coverage or choose simpler dispatch.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public interface IDocumentVisitor
{
    void Visit(Paragraph paragraph);
    void Visit(Image image);
}

public interface IDocumentNode
{
    void Accept(IDocumentVisitor visitor);
}

public sealed record Paragraph(string Text) : IDocumentNode
{
    public void Accept(IDocumentVisitor visitor) => visitor.Visit(this);
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
