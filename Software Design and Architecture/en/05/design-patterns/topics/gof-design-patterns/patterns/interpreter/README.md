<div dir="ltr" align="left">

# Interpreter
> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/interpreter/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

A simple grammar transforms the domain into structure and evaluation rules.
## Practical example

The filter rules of the report are converted to safe and restricted expressions.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** Real parser and tooling are required for complex language.
Arbitrary eval is unsafe.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: Simple grammar transforms domain into structure and evaluation rules.
2. **What does it structure in this example?**   
- Suggested answer: The filter rules of the report are converted to limited and safe expressions.
3. **When is it better to go for the simpler option?**   
- Suggested answer: For complex language parser and real tooling are required.
Arbitrary eval is unsafe.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

Turn a bounded filter such as “price below X and in stock” into an expression tree and evaluate it.
Keep the language small, errors clear, and inputs safe; use a parser for larger grammars and avoid eval or raw SQL.

**Exercise with answer:** Add a price-above condition with a node and evaluator branch; reject unknown operators.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public abstract record Filter;
public sealed record And(Filter Left, Filter Right) : Filter;
public sealed record PriceBelow(decimal Limit) : Filter;

static bool Matches(Filter f, Product p) => f switch
{
    And(var l, var r) => Matches(l, p) && Matches(r, p),
    PriceBelow(var limit) => p.Price < limit,
    _ => false
};
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
