<div dir="ltr" align="left">

# Layered Architectures in Model Design
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/03/object-oriented-programming/topics/layered-architectures-oop/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Layers separate responsibility for UI, application coordination, domain, and infrastructure.
The domain model should not unintentionally depend on the database and the controller.
## Practical example

The order use case calls the domain model and the repository stores it in the infrastructure layer.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Layering adds navigation and mapping.
Start with a small, low-level project.
- **Review:** If each layer only transmits the same data without boundary protection, there is a net cost.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: Layers separate responsibility for UI, application coordination, domain and infrastructure.
The domain model should not unintentionally depend on the database and the controller.
2. **What decision do you make in the example below and why?**   
- Suggested answer: the order use case calls the domain model and the repository stores it in the infrastructure layer.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: layering adds round trip and mapping.
Start with a small, low-level project.
4. **Which common error do you check before merging the code?**   
- Suggested answer: If each layer only transmits the same data without boundary protection, there is a net cost.
## In-depth lesson for this topic
### 5. Layering and direction of dependence

Common logical layers:
1. **Presentation:** Converts HTTP input/output, UI or message.
2. **Application:** coordinates the use case and manages the transaction.
3. **Domain:** Holds business concepts and invariants.
4. **Infrastructure:** connects the database, broker and external providers.
These layers are not necessarily separate process or deploy.
The main rule is dependency control: domain should not depend on web framework or ORM.
The external adapter implements the necessary contract for the use case.
The runtime call flow may be outward, but the dependency source in the domain layer should not point to external details.

~~~text
HTTP controller -> application use case -> domain model
infrastructure adapter implements a domain/application port
~~~

For small CRUD, all layers may not be needed.
Weigh mapping and boilerplate against testability, independence of rules and cost of change.
A good boundary protects a real change.
Mere foldering alone does not make an architecture.
## Worked code example

In a layered model, a controller calls a use case; the use case coordinates rules through a repository contract; an adapter implements SQL details.
Source dependencies point from policy to contracts, even if runtime calls travel outward.

**Exercise with answer:** If changing the ORM edits domain files, the dependency boundary is reversed or leaking; place the interface with the policy.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public interface IOrderStore
{
    Task Save(Order order, CancellationToken ct);
}

public sealed class PlaceOrder(IOrderStore store)
{
    public async Task Execute(Order order, CancellationToken ct)
    {
        order.ValidateForPlacement();
        await store.Save(order, ct);
    }
}
~~~


## Resources
### Persian

- [Book of object-oriented programming; Programmer's House](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — An introductory Persian reference for object-oriented concepts.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian academic course about object-oriented design and patterns.
### English

- [Microsoft Learn.Object-oriented programming](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — Object-oriented concepts with C# examples.
- [Oracle Java Tutorials; Classes and Objects](https://docs.oracle.com/javase/tutorial/java/concepts/) — class model, object, inheritance and interfaces.
## Summary

Apply a layered architecture in modeling to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
