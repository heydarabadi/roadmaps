<div dir="ltr" align="left">

# Monolithic Architecture (Monolith).
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/07/architectural-styles/topics/monolithic/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location on the road map:** [Architecture styles](../../README.md) · [Total course list](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The system is deployed as a single unit.
Its interior can be modular and well-built or highly intricate.
## Practical example

The store has a web service, a release, and built-in module boundaries.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Architectural Styles" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Deployment and transaction are simpler, but publishing and scaling parts are tied together.
- **Revision:** Do not confuse monolith with modular monolith or boundless monolith.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: the system is deployed as a single unit.
Its interior can be modular and well-built or highly intricate.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The store has a web service, a release, and internal module boundaries.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Deployment and transaction are simpler, but the distribution and scaling parts are tied together.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't confuse monolith with modular monolith or boundless monolith.
## In-depth lesson for this topic
### 2. Monolithic and Modular Monolith

Monolith is a deploy unit.
This definition does not say whether the code inside is clean or messy.
Modular monolith has a deployment with controlled in-process boundaries: components have limited API, read data from behind contracts, and change ownership is clear.
The advantage of monolith: simpler deployment and debug, fast local call, easier global transaction, low operating cost.
Risk: deploy all parts are tied together, scale is single and boundaries may wear out.
Shopify has reported that it has modularized its Rails core with components and isolated only functions such as storefront rendering or sensitive checkout for a more independent reason. [Shopify Report](https://shopify.engineering/shopify-monolith).
## Architecture diagram and walkthrough

A monolith is one deployable unit and can still contain well-structured modules.
Local calls and deployment are simple, while coupling and team coordination can grow.
Establish module boundaries in-process before extracting services.

**Common pitfall:** A monolith is not synonymous with messy code; microservices are not an automatic cure.

**Exercise with answer:** Orders and payments share a table; first clarify ownership and contracts and measure coupling, then decide about deployment.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
One deployment:
+---------------------------------------+
| [Orders] <contract> [Payments]        |
| [Catalog] <contract> [Inventory]      |
| Shared process; modules own decisions |
+---------------------------------------+
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

Apply a monolith to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-07)

</div>
