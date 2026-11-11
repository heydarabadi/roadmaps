<div dir="ltr" align="left">

# Principles of SOLID — SOLID
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/04/design-principles/topics/solid/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The five principles of object-oriented design recall single responsibility, extensibility with little change, correct subtype substitution, small interface, and dependency inversion.
## Practical example

In the invoice module, separate the calculation of the amount, saving and sending the email so that changing each one does not force the others to be rewritten.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Design" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** The mechanical application of each principle increases the number of types and abstractions.
- **Review:** SOLID is not a quality guarantee or architectural version.
Measure real changes and coupling.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: The five principles of object-oriented design recall single responsibility, extensibility with little change, correct subtype substitution, small interface, and dependency inversion.
2. **What decision do you make in the example below and why?**   
- Suggested answer: In the invoice module, separate the calculation of the amount, saving and sending the email so that the change of each does not force the others to be rewritten.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: The mechanical application of each principle increases the number of types and abstractions.
4. **Which common error do you check before merging the code?**   
- Suggested answer: SOLID is not a quality guarantee or architectural version.
Measure real changes and coupling.
## In-depth lesson for this topic
### 1. SOLID as five related guides

SOLID summarizes the five principles of object-oriented design.
Together, they improve coherence, controlled extension, and contract dependency, but their mechanical implementation increases the number of interfaces and classes.
#### S — Single Responsibility

A module should be grouped around a cohesive responsibility or a group that changes a requirement.
It doesn't mean "each class is just a method" or "a small task".
If tax change and invoice printing format change are usually requested by two independent actors, we probably have two responsibilities.
Method: check recent changes.
Find independent requirements that affect a module.
Separate the boundary only when there is real coupling or test difficulty.
Tiny modules with generic names can make cohesiveness worse.
#### O — Open-Closed

Code should be open to changing behavior by adding appropriate extensions, while not tampering with stable parts unnecessarily.
The goal is not to prevent any edit.
The goal is to reduce the risk of changing sensitive and tested logic.
If discount method is added regularly, strategy or rule registry may help.
If there are only two constant types and the change is once a year, a readable and simple switch might be better.
OCP is more appropriate for a change axis where we have real evidence of growth.
#### L — Liskov Substitution

The subtype must sit in place of the base type and maintain the behavioral convention.
If the subtype throws a new exception, prohibits the base operation, or weakens the postcondition, the subtype relationship is probably false.
Write contract test: Check for valid input, output, error, and common invariant for all implementations.
Simply having methods with the same signature is not enough.
#### I — Interface Segregation

A consumer should not depend on an operation that it does not need.
Divide the large interface with unrelated methods according to the user's capability.
But building countless single-method interfaces also makes it difficult to understand the architecture.
First, see the real role of callers.
#### D — Dependency Inversion

High-level logic does not depend on low-level details.
Both rely on the stable contract and implement its details.
Source dependency code is directed from the controller/SDK to the application or domain contract.
In runtime, the call may come from the use case to the adapter.
The call execution direction is not the same as the code dependency direction.

~~~text
Application policy -> PaymentAuthorizer contract <- Vendor adapter
~~~

~This principle does not mean an interface for every class.
Use it where there is a change of vendor, testing requirement or ownership boundary.
## Resources
### Persian

- [GoFarsi; SOLID in Go](https://book.gofarsi.ir/chapter-9/solid-principle-in-golang/) — Persian explanation of SOLID with the Go language angle.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — tutorial description of SOLID, GRASP, design and refactoring smells.
- [Persian design patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian list of patterns and a summary of each problem.
### English

- [Refactoring.Guru; SOLID principles](https://refactoring.guru/design-patterns/solid-principles) — definition and example of each SOLID principle.
- [Martin Fowler; Is Design Dead?](https://martinfowler.com/articles/designDead.html) — Evolutionary Design and the Cost of Early Decisions.
## Summary

Apply SOLID principles to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)

</div>
