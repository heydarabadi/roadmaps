<div dir="ltr" align="left">

# Service-Oriented Architecture (SOA)
> **Language:** [Persian edition](../../../../../08/architectural-patterns/topics/soa/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location in the roadmap:** [Architecture Patterns](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

SOA offers enterprise capabilities in interoperable and contracted services.
Usually with a focus on enterprise systems integration and reusability.
## Practical example

Human resource system and salary payment are exchanged from identity service and organizational contracts.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its background are linked in the "Architectural Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** ESB or heavy governance can slow down and centralize change.
- **Review:** Do not use SOA and microservices as complete synonyms.
Their scope and authority are different.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: SOA provides organization capabilities in interoperable and contracted services.
Usually with a focus on enterprise systems integration and reusability.
2. **What decision do you make in the example below and why?**   
- Suggested answer: Human resource system and salary payment are exchange from identity service and organizational contracts.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: ESB or heavy governance can slow down and centralize the change.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Do not use SOA and microservices as complete synonyms.
Their scope and authority are different.
## In-depth lesson for this topic
### 9. SOAService-Oriented Architecture offers the capabilities of the organization in contracted services for integration.
It may have central governance and enterprise bus.
SOA is a broader family of microservices and is not always equivalent to the style of small and decentralized services.
The centrality of ESB can gather translation and policy together, but also create an organizational bottleneck and central coupling.
Clarify the goal of integration, ownership, reuse and changeability.
Then measure governance.
## Architecture diagram and walkthrough

SOA coordinates enterprise services through explicit contracts and integration policies.
An ESB can centralize routing and transformation, but governance and contract changes cost effort, and a central bus can become a bottleneck.

**Common pitfall:** Do not turn the ESB into the home for every service's business logic.

**Exercise with answer:** Give cross-team contracts explicit owners and versions; evolve schemas compatibly and track actual consumers.
This is a simplified view; production design must also state ownership, failure, security, and operational constraints.

~~~text
[Consumer A] ---> [Integration bus / contracts] ---> [Service B]
                          |          \
                          v           v
                    [Transform]   [Routing policy]
~~~


## Architecture diagram and walkthrough

SOA coordinates enterprise services through contracts and integration policies.
An ESB can centralize routing and transformation, but requires governance and may become a central bottleneck or logic hub.

**Common pitfall:** Do not put every service's business logic in the ESB.

**Exercise with answer:** Version cross-team contracts with clear owners, evolve schemas compatibly, and identify actual consumers.
This simplified view should be supplemented with explicit ownership, failure, security, and operational decisions.

~~~text
[Consumer A] ---> [Integration bus / contracts] ---> [Service B]
                          |          \
                          v           v
                    [Transform]   [Routing policy]
~~~


## Resources
### Persian

- [Persian Guide to Domain-Oriented Design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — Structured Persian guide to DDD, Common Language and Modeling.
- [DNTips; Software layering architecture](https://www.dntips.ir/post/1264/معماری-لایه-بندی-نرم-افزار-3) — Persian examples in application and data layer.
### English

- [Microsoft Learn; DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice) — domain boundary, layers and domain model.
- [Martin Fowler; CQRS](https://martinfowler.com/bliki/CQRS.html) — CQRS definition and warning about additional complexity.
- [Martin Fowler.Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) — Logging changes as events and replay considerations.
## Summary

Apply Service-Oriented Architecture (SOA) to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-08)

</div>
