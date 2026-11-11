<div dir="ltr" align="left">

# Blackboard Pattern
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/08/architectural-patterns/topics/blackboard/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location in the roadmap:** [Architecture Patterns](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Multiple knowledge sources work on a shared data space and the controller decides which component to make progress on next.
It is suitable for incremental solution problems.
## Practical example

The fault detection system first records sensor data, and independent analyzers add clues to the blackboard.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its background are linked in the "Architectural Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Scheduling and competition between analysts and data consistency is hard.
- **Review:** For deterministic and linear pipeline, blackboard is usually too complex.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: several knowledge sources work on a common data space and the controller decides which component to make progress on next step.
It is suitable for incremental solution problems.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The fault detection system first records the sensor data and the independent analyzers add the clues to the blackboard.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Scheduling and competition between analysts and data consistency is hard.
4. **Which common error do you check before merging the code?**   
- Suggested answer: For deterministic and linear pipeline, blackboard is usually too complex.
## In-depth lesson for this topic
### 4. Blackboard

Blackboard pattern is suitable for a problem where the solution is made from several sources of knowledge and gradual steps.
The shared data space holds the state/cue.
Knowledge sources are activated when they can advance it.
The control component coordinates the progress.
Tutorial example: Fault detection system puts sensor data on board and independent analyzers add mechanical/thermal clues.
Possible applications in complex recognition are.
For a linear pipeline, ordinary queues or combinatorial functions are simpler.
Costs: shared state, step interference, timing, and identifying which parser changed the result.
## Architecture diagram and walkthrough

Blackboard suits problems without one clear linear algorithm.
Knowledge sources add candidate results to shared state, while a control component chooses what runs next.
Coordination and shared-state quality are the main complexity.

**Common pitfall:** Do not leave shared state ownerless or without a contract.

**Exercise with answer:** If two knowledge sources produce conflicting results, define versioning, priority, or an arbitration policy.
This is a simplified view; production design must also state ownership, failure, security, and operational constraints.

~~~text
+----------------------+
| Shared blackboard    |
+----------------------+
    ^       ^       |
    |       |       v
[Knowledge A] [Knowledge B] [Controller]
                       |
                       +--- selects next source
~~~


## Architecture diagram and walkthrough

Blackboard fits problems without a clear linear algorithm.
Knowledge sources add results to shared state, and a control component chooses what runs next.
Coordination and inconsistent shared state are its main costs.

**Common pitfall:** Do not leave shared state without ownership, versioning, or priority rules.

**Exercise with answer:** Two sources produce conflicting results; define documented arbitration or priority and record why a result was selected.
This simplified view should be supplemented with explicit ownership, failure, security, and operational decisions.

~~~text
+----------------------+
| Shared blackboard    |
+----------------------+
    ^       ^       |
    |       |       v
[Knowledge A] [Knowledge B] [Controller]
                       |
                       +--- selects next source
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

Apply the blackboard pattern to a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-08)

</div>
