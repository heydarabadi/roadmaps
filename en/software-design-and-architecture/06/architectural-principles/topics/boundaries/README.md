<div dir="ltr" align="left">

# Boundaries
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/06/architectural-principles/topics/boundaries/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Position in the road map:** [Principles of Architecture](../../README.md) · [List of the whole course](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

An architectural boundary is a surface that clarifies the contract, data ownership, and direction of dependency.
The boundary can be within the process, network, team or product.
## Practical example

Payment and catalog are internal components first.
Service boundaries are evaluated when separate ownership or scale is required.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Architecture" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Network boundary makes refactor and transaction more expensive.
The intra-process boundary is more flexible.
- **Revision:** Do not select the boundary from the database table or folder.
Check responsibility and concurrent changes.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: Architectural boundary is a surface that clarifies contract, data ownership and direction of dependence.
The boundary can be within the process, network, team or product.
2. **What decision do you make in the example below and why?**   
- Suggested answer: payment and catalog are internal components first.
Service boundaries are evaluated when separate ownership or scale is required.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: network boundary makes refactor and transaction more expensive.
The intra-process boundary is more flexible.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Do not select the boundary from the database table or folder.
Check responsibility and concurrent changes.
## In-depth lesson for this topic
### 4. Boundaries

The boundary defines who owns the state, what contracts can be used, and where the dependency passes.
The boundary can be:
- logic inside the package or process;
- API level between services;
- network or security trust boundary;
- team ownership;
- Or the boundary of the product and bounded context.
To decide the boundary:
1. Find the actor and the rules that change together.
2. Specify the truth source data and invariant responsibility.
3. Count the collaboration between the parties and include latency/failure.
4. Design the contract and method of observing the result.
5. Don't impose the network boundary as long as the intra-process boundary is sufficient.
There is also a high risk: splitting a transaction into several services requires eventual consistency, retry, reconciliation and operations.
A low boundary creates both ambiguous ownership and simultaneous changes.
## Architecture diagram and walkthrough

Find a boundary from decision and state ownership and from changes that occur together; a folder or database table name alone is not enough.
API, module, service, and bounded context are different kinds of boundaries, each with coordination costs.

**Common pitfall:** Do not turn every logical boundary into a separately deployed service.

**Exercise with answer:** Pricing and inventory have different owners, so define separate contracts; choose deployment boundaries from operational evidence.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
+---------------------+      contract      +----------------------+
| Pricing policy     | <----------------> | Inventory capability |
| owns price rules   |                     | owns stock state     |
+---------------------+                     +----------------------+
             \                                  /
              \------ composition / API -------/
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

Apply the boundary to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-06)

</div>
