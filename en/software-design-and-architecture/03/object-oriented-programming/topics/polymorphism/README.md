<div dir="ltr" align="left">

# Polymorphism
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/03/object-oriented-programming/topics/polymorphism/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Polymorphism allows the same contract to be invoked by different implementations, reducing type-specific requirements.
## Practical example

The `Exporter` output service calls a `export` operation for CSV and PDF.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Adding abstraction for a static state can create complexity.
- **Revision:** Don't replace polymorphism with any `if`.
Real and sustainable diversity is needed.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: Polymorphism allows calling a common contract with different implementations and reduces type-specific requirements.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The `Exporter` output service calls a `export` operation for CSV and PDF.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Adding abstraction for a fixed state can create complexity.
4. **Which common error do you check before merging the code?**   
- Suggested answer: don't replace polymorphism with any `if`.
Real and sustainable diversity is needed.
## In-depth lesson for this topic
#### Polymorphism

Polymorphism means that the consumer works with a common contract and the behavior is selected based on the actual implementation. subtype polymorphism uses interface/base type; parametric polymorphism from generic.
Some languages ​​have dispatch according to overload or pattern matching.

~~~python
class DiscountPolicy(Protocol):
    def apply(self, subtotal_cents: int) -> int: ...

def checkout(subtotal_cents, policy: DiscountPolicy):
    return policy.apply(subtotal_cents)
~~~

This reduces sparse branches if the discounting algorithms are truly different and interchangeable.
If we have only one policy and no specific change driver, the direct function is simpler.
For the common contract, have a test contract so that the implementations follow a minimal behavior.
## Worked code example

Polymorphism lets a client use one stable contract while each implementation supplies its behavior.
It can replace type-based switches, but selection and shared contract must be explicit; incorrect behavioral inheritance breaks substitutability.

**Exercise with answer:** Add a delivery method through IDeliveryMethod.
If the use case fills with new type checks, the abstraction is misplaced.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public interface IDeliveryMethod
{
    DeliveryQuote Quote(Parcel parcel);
}

var quote = deliveryMethod.Quote(parcel);
~~~


## Resources
### Persian

- [Book of object-oriented programming; Programmer's House](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — An introductory Persian reference for object-oriented concepts.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian academic course about object-oriented design and patterns.
### English

- [Microsoft Learn.Object-oriented programming](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — Concepts of object-oriented programming with C# examples.
- [Oracle Java Tutorials; Classes and Objects](https://docs.oracle.com/javase/tutorial/java/concepts/) — class model, object, inheritance and interfaces.
## Summary

Apply polymorphism to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
