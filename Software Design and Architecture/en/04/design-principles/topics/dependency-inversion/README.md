<div dir="ltr" align="left">

# Dependency Inversion Principle (DIP) — Dependency Inversion Principle

> **Language:** [Persian edition](../../../../../04/design-principles/topics/dependency-inversion/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

High-level policy should not depend on infrastructure details. Both commit to a stable contract and implement the details of the contract.


## Practical example

The payment processing use case depends on the gateway contract, and the adapter connects that contract to the vendor's SDK.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Principles of Design" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** The additional contract should separate the actual boundary of the change or test.
- **Review:** Do not confuse this principle with adding an interface for each class.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: high-level policy should not depend on infrastructure details. Both commit to a stable contract and implement the details of the contract.
2. **What decision do you make in the example below and why?**
   - Suggested answer: The payment processing use case depends on the gateway contract, and the adapter connects that contract to the vendor's SDK.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: The additional contract should separate the actual boundary of the change or test.
4. **Which common error do you check before merging the code?**
   - Suggested answer: Do not confuse this principle with adding an interface for each class.

## In-depth lesson for this topic

#### D — Dependency Inversion

High-level logic does not depend on low-level details. Both rely on the stable contract and implement its details. Source dependency code is directed from the controller/SDK to the application or domain contract. In runtime, the call may come from the use case to the adapter. The call execution direction is not the same as the code dependency direction.
~~~text
Application policy -> PaymentAuthorizer contract <- Vendor adapter
~~~
~

This principle does not mean an interface for every class. Use it where there is a change of vendor, testing requirement or ownership boundary.
## Worked code example

High-level policy depends on a stable contract, and a low-level adapter implements it. This is source dependency direction; runtime calls may still flow from a use case to the database. Do not make an interface for every class; a boundary should localize change or enable testing.


**Exercise with answer:** Replacing an ORM should not change domain rules; keep the repository contract with policy and let the database adapter implement it.

This C# sketch abbreviates supporting types and focuses on the design choice.

~~~csharp
public interface IOrderStore
{
    Task Save(Order order, CancellationToken ct);
}

public sealed class PlaceOrder(IOrderStore store)
{
    public Task Execute(Order order, CancellationToken ct)
    {
        order.ValidateForPlacement();
        return store.Save(order, ct);
    }
}
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

Apply the Dependency Inversion Principle (DIP) to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)
</div>
