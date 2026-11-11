<div dir="ltr" align="left">

# Microservices

> **Language:** [Persian edition](../../../../../08/architectural-patterns/topics/microservices/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Location in the roadmap:** [Architecture Patterns](../../README.md) · [Course Index](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

The system is made of independent deployable services around business capabilities. The data and changes of each service are somewhat autonomous.


## Practical example

Catalog and order can be published separately if their ownership, scale requirements and change cycle are truly independent.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its background are linked in the "Architectural Patterns" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Networking, observability, data coordination and operations have significant fixed costs.
- **Review:** Do not divide the new system or small team into multiple services without a clear need.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: The system is made of independent services that can be deployed around business capabilities. The data and changes of each service are somewhat autonomous.
2. **What decision do you make in the example below and why?**
   - Suggested answer: Catalog and order can be published separately if their ownership, scale requirement and change cycle are truly independent.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: network, observability, data coordination and operation have significant fixed cost.
4. **Which common error do you check before merging the code?**
   - Suggested answer: Do not divide the new system or small team into multiple services without a clear need.

## In-depth lesson for this topic

### 3. Microservices

Microservices breaks the system into small, independent services around business capability, which are usually deployed separately and own their own data. Team independence and release is an advantage; network, consistency, observability, deployment and security bring complexity.
Find the bound from the bounded context and change/property, not from the table or class. If two services call consecutively for each request, have a common transaction and are deployed together, the boundary may be bad. Stage the extraction. Service boundary is harder to refactor than library boundary.
## Architecture diagram and walkthrough

Microservices define independent services that own capabilities and data. Deployment independence trades for network, observability, consistency, security, and operational coordination costs; choose boundaries from domain ownership.


**Common pitfall:** Do not split a monolith into services before understanding its boundaries.


**Exercise with answer:** If two services must release together for every change, they may not be independent or their contracts are too coupled.

This is a simplified view; production design must also state ownership, failure, security, and operational constraints.

~~~text
[API gateway]
   |             \
   v              v
[Order service] [Catalog service]
   | owns DB         | owns DB
   +------ events ---+
~~~

## Architecture diagram and walkthrough

Microservices assign capabilities and data to independent services. Deployment independence costs network reliability, observability, consistency, security, and operational coordination; choose boundaries from domain ownership.


**Common pitfall:** Do not split a monolith into services before understanding its boundaries.


**Exercise with answer:** If two services must release together for every change, their independence boundary is weak or their contracts are too coupled.

This simplified view should be supplemented with explicit ownership, failure, security, and operational decisions.

~~~text
[API gateway]
   |             \
   v              v
[Order service] [Catalog service]
   | owns DB         | owns DB
   +------ events ---+
~~~


## Resources

### Persian

- [Persian Guide to Domain-Oriented Design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — Structured Persian guide to DDD, Common Language and Modeling.
- [DNTips; Software layering architecture](https://www.dntips.ir/post/1264/معماری-لایه-بندی-نرم-افزار-3) — Persian examples in application and data layer.

### English

- [Microsoft Learn; DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice) — domain boundary, layers and domain model.
- [Martin Fowler; CQRS](https://martinfowler.com/bliki/CQRS.html) — CQRS definition and warning about additional complexity.
- [Martin Fowler. Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) — Logging changes as events and replay considerations.

## Summary

Apply microservices to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-08)
</div>
