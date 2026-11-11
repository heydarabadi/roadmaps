<div dir="ltr" align="left">

# Law of Demeter

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/04/design-principles/topics/law-of-demeter/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

A unit must talk to its close colleagues and remain unaware of the chain of internal structure of things. This localizes the structure change.


## Practical example

Instead of `order.customer.address.city`, give the operation `shippingCity()` or a functional view.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Principles of Design" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Hiding each chain may create too many interface methods.
- **Review:** Don't count every dot access as a violation. The problem is the leakage of structure and coupling.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: a unit should talk to its close colleagues and remain unaware of the chain of internal structure of things. This localizes the structure change.
2. **What decision do you make in the example below and why?**
   - Suggested answer: instead of `order.customer.address.city`, give operation `shippingCity()` or a functional view.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: Hiding each chain may create too many interface methods.
4. **Which common error do you check before merging the code?**
   - Suggested answer: Don't count every dot access as a violation. The problem is the leakage of structure and coupling.

## In-depth lesson for this topic

### 4. Law of Demeter

A unit must communicate with its close associates, not know the deep chain of internal structure. If the term customer.address.city is repeated in several places in the domain, the structure of the objects is leaked to the caller. A domain API like shipping_destination() can hold meaning.

Demeter's law is not "any point of access is prohibited". Many interface methods can also create boilerplate. The problem is that the caller is dependent on details that he does not have the right to own.
## Worked code example

The Law of Demeter reduces chained access into collaborators' internals. Ask a nearby object to use the knowledge it owns. However, introducing a forwarding method for every trivial value can clutter the API.


**Exercise with answer:** Replace order.
Customer.
Address.
Zip with order.
ShippingDestination(); let the order own how its destination is determined.

This C# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public sealed class Order
{
    public Address ShippingAddress { get; private set; }
    public PostalCode ShippingDestination() => ShippingAddress.PostalCode;
}

var postalCode = order.ShippingDestination();
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

Apply Dimeter's law to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)
</div>
