<div dir="ltr" align="left">

# Event-Driven Architecture
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/07/architectural-styles/topics/event-driven/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location on the road map:** [Architecture styles](../../README.md) · [Total course list](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The producer releases an event after the fact occurs, and consumers react independently.
Message from "What happened?" It says, not "do this".
## Practical example

After `OrderPaid` the receipt system, warehouse and analysis consume each event.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Architectural Styles" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Ordering, repetition, final consistency and observability become more complex.
- **Revision:** Don't turn the domain event into a hidden command message and don't forget about reliable sending.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested response: the producer publishes an event after the fact occurs and consumers react independently.
Message from "What happened?" It says, not "do this".
2. **What decision do you make in the example below and why?**   
- Suggested answer: After `OrderPaid` the receipt system, warehouse and analysis consume each event.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: order, repetition, final consistency and observability become more complex.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't turn the domain event into a hidden command message and don't forget about reliable sending.
## In-depth lesson for this topic
### 8. Event-Driven

The producer publishes an event that records a fact, and interested consumers react independently.
An event says what has happened; a command asks for something to happen.
Do not use an event as a disguised command to one consumer.
Event-driven is useful when the producer should not know about subscribers, fan-out is required, or async processing is valuable.
But it also adds order, duplicate, replay, schema evolution and eventual consistency.
An event bus hides control flow from the call stack.
Observability is essential.
## Architecture diagram and walkthrough

A producer publishes a fact as an event and consumers react independently.
Asynchronous delivery reduces temporal coupling but introduces ordering, duplicates, schema evolution, and eventual consistency.

**Common pitfall:** An event states a fact that happened; do not use it as a disguised command to one consumer.

**Exercise with answer:** OrderPlaced arrives twice; use an event ID or business key so the consumer handles the side effect idempotently.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
[Order service] -- OrderPlaced --> [Event broker]
                                      /       \
                              [Analytics]   [Fulfillment]
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

Apply an event-driven architecture to solve a specific problem, document the trade-offs, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-07)

</div>
