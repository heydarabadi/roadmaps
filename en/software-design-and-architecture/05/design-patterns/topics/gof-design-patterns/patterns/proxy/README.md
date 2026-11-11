<div dir="ltr" align="left">

# Mediator — Proxy

> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/proxy/README.md)

> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Family:** structural · 

**Chapter:** [Design Patterns](../../../../README.md)

## Pattern intent

Provides a controlled alternative in front of the object to handle access, lazy loading, or remote communication.

## Practical example

The proxy performs authentication or cache before contacting the external service.

## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.



**Important limitation:** Don't put the hidden cost of latency and failure behind the same interface.

## Test questions with answers

1. **Which problem does it solve?**
   - Suggested answer: Put a controlled alternative in front of the object to handle access, lazy loading, or remote communication.
2. **What does it structure in this example?**
   - Suggested answer: proxy performs authentication or cache before contacting the external service.
3. **When is it better to go for the simpler option?**
   - Suggested answer: Do not put the hidden cost of latency and failure behind the same interface.

## Pattern family context

This is one of the GoF structural patterns. The [integrated chapter lesson](../../../../lessons.md#2-gof-structural-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

A proxy presents the real object's contract while controlling creation, authorization, or remote access. Do not hide latency or failures, and handle concurrent lazy initialization.


**Exercise with answer:** Image loading fails; return a clear error and define whether a later call retries or the failure is cached.

The C# block is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public sealed class LazyImage(string path, IImageLoader loader) : IImage
{
    private IImage? _real;
    public void Draw(Canvas canvas)
    {
        _real ??= loader.Load(path);
        _real.Draw(canvas);
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
