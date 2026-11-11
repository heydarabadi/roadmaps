<div dir="ltr" align="left">

# Structural Styles
> **Language:** [Persian edition](../../../../../07/architectural-styles/topics/structural-style/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location on the road map:** [Architecture styles](../../README.md) · [Total course list](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The structural style describes the overall relationship of the components.
Layered, pipe-and-filter, and component-based are examples of spatial/control organization.
## Practical example

The input image processing passes several independent filters and each step has a clear input/output format.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Architectural Styles" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Adds asymmetric structure, data passing and mapping.
- **Review:** Don't just use the "structural" label to describe a specific pipeline.
Show components and connections.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: structural style describes the overall relationship of components.
Layered, pipe-and-filter, and component-based are examples of spatial/control organization.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The input image processing passes several independent filters and each step has a clear input/output format.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Asymmetric structure adds data passing and mapping.
4. **Which common error do you check before merging the code?**   
- Suggested answer: don't just use the "structural" label to describe a specific pipeline.
Show components and connections.
## In-depth lesson for this topic
### 4. Structural styles

Structural style describes how components are connected.
Pipe-and-filter, layered and component collaboration are examples.
A vague name like structural is not enough.
Specify the connector, data contract, sequence and control location.
For media processing, a staged pipeline can be understood.
It may not be suitable for interactive workflow with shared state.
## Architecture diagram and walkthrough

A structural style describes static organization and runtime collaboration: which modules exist, how connectors join them, and which dependencies are allowed.
A diagram should name its view; one picture cannot explain architecture and deployment at once.

**Common pitfall:** A style name without component boundaries or relationships is not an architecture description.

**Exercise with answer:** Draw separate code and runtime views: one for module dependencies and another for real calls or messages.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
Code view:                         Runtime view:
[Module A] ---> [Module B]         [Process A] -- message --> [Process B]

Deployment view is separate:
[Container A]       [Container B]
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

Apply structural styles to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-07)

</div>
