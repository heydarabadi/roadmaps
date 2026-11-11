<div dir="ltr" align="left">

# Memento
> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/memento/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

Saves a snapshot of the state for restoration, without exposing its internal structure.
## Practical example

The configuration editor allows to undo a step.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** snapshot size and version compatibility are important.
A stable history requires a long-term format.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: Saves a snapshot of the state for restoration, without revealing its internal structure.
2. **What does it structure in this example?**   
- Suggested answer: The configuration editor allows to undo one step.
3. **When is it better to go for the simpler option?**   
- Suggested answer: snapshot volume and version compatibility are important.
A stable history requires a long-term format.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

The editor creates the snapshot needed for restoration, keeping its private state hidden from a history manager.
Full copies cost memory for large documents; consider deltas, bounded history, and versioning.

**Exercise with answer:** The history manager stores snapshots; creation and restoration rules stay with the editor.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public sealed record EditorSnapshot(string Text, int Cursor);

public sealed class Editor
{
    private string _text = "";
    private int _cursor;
    public EditorSnapshot Save() => new(_text, _cursor);
    public void Restore(EditorSnapshot state)
    {
        _text = state.Text;
        _cursor = state.Cursor;
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
