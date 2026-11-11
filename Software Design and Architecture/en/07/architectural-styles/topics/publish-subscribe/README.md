<div dir="ltr" align="left">

# Publication and subscription — Publish-Subscribe
> **Language:** [Persian edition](../../../../../07/architectural-styles/topics/publish-subscribe/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location on the road map:** [Architecture styles](../../README.md) · [Total course list](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Publisher publishes topic/event and independent subscribers receive.
Enables fan-out without direct dependencies between the publisher and all consumers.
## Practical example

The price change event is sent to cache, search and analytics.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Architectural Styles" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** The publisher does not know what consumer was executed.
Trace and subscriber management is required.
- **Review:** Do not use Pub/Sub for two modules that require an immediate and definitive response, unless you have solved the debugging and ordering.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: the publisher publishes the topic/event and they receive independent subscribers.
Enables fan-out without direct dependencies between the publisher and all consumers.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The price change event is sent to cache, search and analytics.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: the publisher does not know what consumer was executed.
Trace and subscriber management is required.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Do not use Pub/Sub for two modules that require an immediate and definitive answer, unless you have solved the error detection and ordering.
## In-depth lesson for this topic
### 9. Publish-Subscribe and Messaging

Publish-subscribe attaches multiple consumers to the topic/event and separates the producer from their list.
Message contract is the data and semantics of the exchange.
Queue usually gives the work to a consumer/group and is acked after processing; stream returns sorted history with offset/retention for multiple consumers.
The technologies may have hybrid capability, so check the semantics of the tool.

~~~json
{
  "event": "OrderPaid",
  "orderId": "ord-1042",
  "occurredAt": "2026-11-10T09:00:00+03:30",
  "schemaVersion": 1
}
~~~

Production message needs owner, version policy, key for partitioning, retry/DLQ, idempotency and data classification.
The implementation of reliable event publishing sometimes requires a transactional outbox so that database changes and messages do not get separated.
## Architecture diagram and walkthrough

A publisher sends to a topic and a broker fans out to independent subscribers.
The publisher need not know every destination, but schema contracts, retention, ordering, duplicates, and subscription lifecycle still matter.

**Common pitfall:** Do not assume event delivery is guaranteed exactly once.

**Exercise with answer:** A consumer is offline; if it must not miss messages, use retention and offsets or a durable subscription.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
[Publisher] ---> [Topic: order-events]
                       |        \
                       v         v
                 [Billing]   [Analytics]
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

Apply publish-subscribe to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-07)

</div>
