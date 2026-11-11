<div dir="ltr" align="left">

# Coupling and Cohesion
> **Language:** [Persian edition](../../../../../06/architectural-principles/topics/coupling-cohesion/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Position in the road map:** [Principles of Architecture](../../README.md) · [List of the whole course](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Coherence indicates that members change for a purpose.
Coupling shows that changing one part forces other parts to change.
The goal is not to eliminate all dependencies, but to limit unjustified dependencies.
## Practical example

The warehouse module has a small API and changing its storage method does not propagate to the discount code.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Architecture" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Adds excessive isolation of network calls and mapping.
- **Review:** Numerical reduction of dependence without examining the path of change is the wrong goal.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: Coherence shows that members change for a purpose.
Coupling shows that changing one part forces other parts to change.
The goal is not to eliminate all dependencies, but to limit unjustified dependencies.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The warehouse module has a small API and changing its storage method does not propagate to the discount code.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Adds too much isolation of network calls and mapping.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Numerical reduction of dependence without examining the path of change is the wrong goal.
## In-depth lesson for this topic
### 3. Coupling and Cohesion**Cohesion** is the degree of connection between parts within the component with a common responsibility. **Coupling** is the amount of knowledge that one component has about another and how much the change of one component depends on the change.
The goal is not to zero dependency.
The system does nothing without collaboration.
The goal of limiting dependency is unjustified and costly.
Coupling signs:
- Changing the schema of a module breaks multiple callers;
- component reads from private field or another internal table;
- Two services call each other continuously to complete a request;
- The arrangement of several events in a hidden form is necessary for it to work properly.
Signs of coherence:
- operations are based on a common capability and language;
- simultaneous changes occur in the same boundary;
- The component can be tested with the contract turned on.
#### Practical assessment

Instead of saying "coupling is too much", follow an actual change: "If the shipping calculation method changes, which file, team, test, service, and deploy will change?" Record how many boundaries are violated, which changes are unintentionally propagated, and how much the refactor costs.
Isolation moves too much coupling from call local to mapping, API and network.
It may become more difficult.
An in-process component boundary is often cheaper than a service boundary and preserves the opportunity for future change.
## Architecture diagram and walkthrough

Coupling measures how much one part needs another part's details to change; cohesion measures how closely the responsibilities inside a part belong together.
Low coupling without cohesion can create pointless fragmentation.
Aim for coherent ownership and small contracts.

**Common pitfall:** A lower import count alone does not prove better architecture.

**Exercise with answer:** If Invoice owns email, persistence, and tax calculation, separate responsibilities changed by different actors.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
Low cohesion / broad coupling:
[Invoice: tax + email + database + PDF] ---> [Many unrelated modules]

Higher cohesion / explicit contracts:
[Tax policy]   [Invoice storage]   [PDF renderer]
      \              |                 /
       +---------- [Invoice use case] -+
~~~


## Resources
### Persian

- [DNTips; Layered software architecture, part 2](https://www.dntips.ir/post/1261) — Persian example of layers and access boundaries.
- [DNTips; Software Layering Architecture, Part 3](https://www.dntips.ir/post/1264/معماری-لایه-بندی-نرم-افزار-3) — Persian service layer example and request/response message.
- [DNTips; Review of software architecture and microservices](https://www.dntips.ir/news/details/18872) — Persian educational experience about communication, data and transaction in services.
### English

- [Microsoft Azure Architecture Center.Architecture styles](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/) — Constraints, selection and exchange of architecture styles.
- [Martin Fowler; Microservices](https://martinfowler.com/articles/microservices.html) — Definition, benefits, costs and caveats of the microservices style.
## Summary

Apply coupling and cohesion to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-06)

</div>
