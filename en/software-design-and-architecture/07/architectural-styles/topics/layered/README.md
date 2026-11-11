<div dir="ltr" align="left">

# Layered Architecture
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/07/architectural-styles/topics/layered/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location on the road map:** [Architecture styles](../../README.md) · [Total course list](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Responsibilities are divided into layers such as presentation, application, domain and infrastructure.
Dependency rules must be clear.
## Practical example

The HTTP controller passes the command to the use case, the use case executes the domain, and the adapter stores the data.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Architectural Styles" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Model mapping and layer traversal have overhead.
Sometimes it is more beneficial to simplify CRUD.
- **Revision:** The inner layer should not depend on the outer layer, unless this direction is intentionally part of the design.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: Responsibilities are divided into layers such as presentation, application, domain and infrastructure.
Dependency rules must be clear.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The HTTP controller gives the command to the use case, the use case executes the domain, and the adapter stores the data.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Mapping the model and passing through the layers has overhead.
Sometimes it is more beneficial to simplify CRUD.
4. **Which common error do you check before merging the code?**   
- Suggested answer: The inner layer should not depend on the outer layer, unless this direction is intentionally part of the design.
## In-depth lesson for this topic
### 3. Layered / N-tier

Layered architecture divides logical responsibility into presentation, application, domain and infrastructure.
N-tier usually turns those layers into deployment/network tier as well.
Do not confuse these two words.
Layering is useful for separation of concerns, but the call from the UI to the database can go through multiple mappings and classes.
Define dependency direction.
The domain should not know the web/database details if rule independence is important.
For small CRUD, heavy layering incurs additional cost.
## Architecture diagram and walkthrough

Layered style separates concerns such as presentation, application, domain, and infrastructure.
Runtime calls may reach outward, while source dependency direction must be deliberate.
A pass-through layer without policy or transformation adds mapping and indirection.

**Common pitfall:** Do not force simple CRUD through needless DTO and mapper layers.

**Exercise with answer:** An ORM change should not alter a domain rule; define the storage contract with the use case and implement it in an adapter.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
Runtime calls:
[Presentation] -> [Application] -> [Domain] -> [Persistence adapter]

Source dependencies:
[Presentation] -> [Application] -> [Domain contract] <- [Persistence adapter]
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

Apply a layered architecture to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-07)

</div>
