<div dir="ltr" align="left">

# Registration of event-oriented — Event Sourcing
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/08/architectural-patterns/topics/event-sourcing/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location in the roadmap:** [Architecture Patterns](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The current state is reconstructed from an immutable sequence of domain events.
Audit and projection reconstruction are advantages.
## Practical example

The credit account holds the events `Credited` and `Debited` and builds a balance from them.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its background are linked in the "Architectural Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Event versioning, snapshot, replay and external effects are complicated.
- **Review:** Don't thoughtlessly turn technical events into domain events.
Design to remove or modify history.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: the current state is reconstructed from an immutable sequence of domain events.
Audit and projection reconstruction are advantages.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The credit account keeps the events `Credited` and `Debited` and makes the balance from them.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: event versioning, snapshot, replay and external complications are complicated.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't mindlessly turn technical events into domain events.
Design to remove or modify history.
## In-depth lesson for this topic
### 8. Event Sourcing

In event sourcing, the state change is stored as a sequence of immutable domain events, and the current state is obtained from replay.
This audit method makes it possible to reconstruct the projection and query the history.
But it is not a constant need.
Remarks:
- event schema changes in time.
Upcasting or compatibility is required.
- Replay should be deterministic and not dependent on an external provider.
- Snapshot is useful to reduce long replay.
- Sensitive data, legal deletion and retention require special design.
- Correcting the wrong event is often done with the compensation event.
- Do not equate events with technical logs; event must be a meaningful domain fact.
## Architecture diagram and walkthrough

With Event Sourcing, immutable events are the source of truth and current state is rebuilt by replay or snapshots.
Auditability improves, but versioning, ordering, privacy, projections, and correction are harder.

**Common pitfall:** An event log is not a simple, cost-free backup.

**Exercise with answer:** An event schema changes; add a compatible version or upcaster and verify replay of historical events before release.
This is a simplified view; production design must also state ownership, failure, security, and operational constraints.

~~~text
[Command] ---> [Aggregate] ---> append [Event store]
                       |                     |
                       +---- event stream ----+
                                  |
                                  v
                             [Projection]
                                  |
                                  v
                              [Read view]
~~~


## Architecture diagram and walkthrough

In Event Sourcing, immutable events are the source of truth and state is rebuilt through replay or snapshots.
Auditability improves, but versioning, ordering, privacy, projections, and correction become harder.

**Common pitfall:** Do not treat the event log as a simple, cost-free backup.

**Exercise with answer:** An event version changes; add an upcaster or compatible schema and verify replay of historical events.
This simplified view should be supplemented with explicit ownership, failure, security, and operational decisions.

~~~text
[Command] ---> [Aggregate] ---> append [Event store]
                       |                     |
                       +---- event stream ----+
                                  |
                                  v
                             [Projection]
                                  |
                                  v
                              [Read view]
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

Apply event-driven logging to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-08)

</div>
