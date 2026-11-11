<div dir="ltr" align="left">

# Liskov Substitution Principle (LSP) — Liskov Substitution Principle

> **Language:** [Persian edition](../../../../../04/design-principles/topics/liskov-substitution/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

The subtype must preserve the preconditions, postconditions, and expected behavior of the base type so that the consumer is not surprised by the actual type.


## Practical example

If `ReadOnlyAccount` inherits from an account that `withdraw` has but gives an error, the base contract is not designed correctly.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Principles of Design" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Sometimes the inheritance relationship should be replaced by two independent abstractions.
- **Review:** Just the similarity of methods does not mean behavioral compatibility.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: The subtype should preserve the preconditions, postconditions, and expected behavior of the base type so that the consumer is not surprised by the actual type.
2. **What decision do you make in the example below and why?**
   - Suggested answer: If `ReadOnlyAccount` inherits from an account that `withdraw` has but gives an error, the base contract is not designed correctly.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: sometimes the inheritance relationship should be replaced by two independent abstractions.
4. **Which common error do you check before merging the code?**
   - Suggested answer: just the similarity of the methods does not mean behavioral compatibility.

## In-depth lesson for this topic

#### L — Liskov Substitution

The subtype must sit in place of the base type and maintain the behavioral convention. If the subtype throws a new exception, prohibits the base operation, or weakens the postcondition, the subtype relationship is probably false.

Write contract test: Check for valid input, output, error, and common invariant for all implementations. Simply having methods with the same signature is not enough.
## Worked code example

A subtype must preserve the base behavioral contract: it must not strengthen preconditions, weaken postconditions or invariants, or introduce incompatible failures. Matching method signatures is not enough; test every implementation against shared contract cases.


**Exercise with answer:** If an implementation adds a failure for valid input, the contract or subtype is wrong. Model that failure in the common contract or separate the type.

This C# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public interface ITransferAccount
{
    TransferResult TransferTo(ITransferAccount target, Money amount);
}

// Contract tests run the same valid, insufficient-funds,
// and self-transfer cases against every implementation.
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

Apply Liskov's Substitution Principle (LSP) to solve a given problem, record the trade-off, and check with an observable tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)
</div>
