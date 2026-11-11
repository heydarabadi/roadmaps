<div dir="ltr" align="left">

# Component-Based Architecture

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/07/architectural-styles/topics/component-based/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location on the road map:** [Architecture styles](../../README.md) · [Total course list](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

The system consists of clearly interfaced units, each unit providing a coherent functionality. The component can be within a process and does not have to be a network service.


## Practical example

The order, invoice and warehouse modules are maintained in one application with independent internal contracts.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its context are linked in the "Architectural Styles" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Defining contracts and managing their versions require ongoing work.
- **Review:** Each build folder or project is not an independent architectural component.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: The system consists of units with a clear interface, each unit providing a coherent functionality. The component can be within a process and does not have to be a network service.
2. **What decision do you make in the example below and why?**
   - Suggested answer: Order module, invoice and warehouse are maintained in one program with independent internal contracts.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: contract definition and version management costs money.
4. **Which common error do you check before merging the code?**
   - Suggested answer: Each build folder or project is not an independent architectural component.

## In-depth lesson for this topic

### 1. Component-based

In component-oriented architecture, coherent capabilities are collected in components with a clear interface. A component can be inside a process and not have a separate release. Boundary tooling, limited API, testing and data ownership are more important than simple foldering.

This style is usually a good step for modularization: turn on internal dependencies first. Then, if independent deployment or scale is required, evaluate service extraction.

## Architecture diagram and walkthrough

A system is composed of components with clear responsibilities and contracts. Real independence requires stable interfaces, controlled dependencies, and separate verification; splitting files alone does not create architectural components.


**Common pitfall:** Do not add a wrapper and registry around every component unless it simplifies a consumer boundary.


**Exercise with answer:** Separate payment and shipping when they change and are verified independently; expose only the needed capability in each contract.

This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
[Checkout] ---> [Payment component]
      |
      +--------> [Shipping component]

Each component exposes a contract and hides its internal implementation.
~~~


## Resources

### Persian

- [DNTips; Layered software architecture, part 2](https://www.dntips.ir/post/1261) — Persian example of layers and access boundaries.
- [DNTips; Software Layering Architecture, Part 3](https://www.dntips.ir/post/1264/معماری-لایه-بندی-نرم-افزار-3) — Persian service layer example and request/response message.
- [DNTips; Review of software architecture and microservices](https://www.dntips.ir/news/details/18872) — Persian educational experience about communication, data and transaction in services.

### English

- [Microsoft Azure Architecture Center. Architecture styles](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/) — Constraints, selection and exchange of architecture styles.
- [Martin Fowler; Microservices](https://martinfowler.com/articles/microservices.html) — Definition, benefits, costs and caveats of the microservices style.

## Summary

Apply a component-oriented architecture to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-07)
</div>
