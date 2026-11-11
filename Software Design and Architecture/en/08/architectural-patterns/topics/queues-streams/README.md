<div dir="ltr" align="left">

# Message Queues and Streams
> **Language:** [Persian edition](../../../../../08/architectural-patterns/topics/queues-streams/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location in the roadmap:** [Architecture Patterns](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

A queue buffers work for consumers to process, while a stream retains an ordered log that multiple consumers can read using offsets.
Retention, acknowledgement, and replay semantics depend on the broker and the use case.
## Practical example

PDF creation of the invoice goes to the job queue.
Order events are consumed in the stream for analysis and projection.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its background are linked in the "Architectural Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Ordering, duplicates, backpressure, and consumer lag need explicit policies and monitoring.
- **Review:** Don't think of queue as a permanent event database or stream as just a work queue.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: A queue buffers work for processing, while a stream retains an ordered log for consumers to read.
Retention, acknowledgement, and replay semantics depend on the broker and the use case.
2. **What decision do you make in the example below and why?**   
- Suggested answer: PDF creation of the invoice goes to the job queue.
Order events are consumed in the stream for analysis and projection.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: sequence, duplicate, backpressure and lag should be monitored.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't think of queue as a permanent event database or stream as just a work queue.
## In-depth lesson for this topic
### 7. Queue and Stream

A queue buffers work for consumers to pick up later.
Temporary push and background work are separated from the request.
A stream provides an ordered history with retention and offsets, allowing independent consumers to read from separate positions.
Some brokers combine both behaviors.
Read the semantics from the tool.
Define the message schema and owner, partitioning key, retry policy, dead-letter handling, and idempotency behavior.
Make consumers safe under duplicate or out-of-order delivery when the broker can produce it.
Queue does not hide lost work; lag and failure should be alerted.
## Architecture diagram and walkthrough

A queue retains work for a competing consumer until processing is acknowledged; a stream is an ordered durable log that multiple consumers can read with independent offsets.
Choose based on replay, fan-out, ordering, and retention.

**Common pitfall:** Do not assume exactly-once behavior without checking semantics and idempotency.

**Exercise with answer:** Two independent groups must read every message; give them separate subscriptions or consumer groups, not one competing queue.
This is a simplified view; production design must also state ownership, failure, security, and operational constraints.

~~~text
Queue:                         Stream:
[Message] -> [Worker A/B]      [log: 1 2 3 4 5 ...]
                                 |              |
                           [Consumer A]   [Consumer B]
                            offset 4        offset 2
~~~


## Architecture diagram and walkthrough

A queue retains work until acknowledged and commonly distributes messages among competing workers; a stream is an ordered durable log with independent offsets.
Replay, fan-out, ordering, and retention needs determine the choice.

**Common pitfall:** Do not assume exactly-once behavior without checking semantics and idempotency.

**Exercise with answer:** Two independent groups must see every message; create separate consumer groups or subscriptions.
This simplified view should be supplemented with explicit ownership, failure, security, and operational decisions.

~~~text
Queue:                         Stream:
[Message] -> [Worker A/B]      [log: 1 2 3 4 5 ...]
                                 |              |
                           [Consumer A]   [Consumer B]
                            offset 4        offset 2
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

Apply message queuing and event flow to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-08)

</div>
