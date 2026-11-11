<div dir="ltr" align="left">

# Distributed Systems
> **Language:** [Persian edition](../../../../../07/architectural-styles/topics/distributed/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location on the road map:** [Architecture styles](../../README.md) · [Total course list](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Components run on processes/machines and a network with minimal latency and failure.
Synchronization, consistency, timing and observability must be designed.
## Practical example

The payment gateway may give a successful response, but its response is lost in the network.
Idempotency and reconciliation are required.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Architectural Styles" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Limits load sharing and failure, but multiplies failure modes.
- **Revise:** Don't model the network as an error-free local function.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: components run on processes/machines and a network with partial latency and failure.
Synchronization, consistency, timing and observability must be designed.
2. **What decision do you make in the example below and why?**   
- Suggested answer: the payment gateway may give a successful answer, but its answer is lost in the network.
Idempotency and reconciliation are required.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: It limits load sharing and failure, but multiplies failure modes.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't model the network as an error-free local function.
## In-depth lesson for this topic
### 7. Distributed systems

When multiple processes cooperate on the network, slow/unstable network, different clocks, duplicate messages and partial failures are a reality. distributed system is not a deploy style or technology.
A set of failure modes that must be managed in any distributed style.
Practical principles:
- have a timeout.
Don't wait forever.
- Limit retry, with backoff and jitter.
- Make the command idempotent so that retry does not create a duplicate effect.
- Use circuit breaker and bulkhead only for real dependency.
- Determine consistency model and reconciliation.
- Pass correlation ID, logs, metrics and traces across the boundary.
## Architecture diagram and walkthrough

Distributed components cooperate across processes or machines.
Calls may be slow, unavailable, or repeated, and partitions constrain availability and consistency.
Design timeouts, idempotency, observability, and data ownership from the start.

**Common pitfall:** Do not treat a network call like an in-process function call.

**Exercise with answer:** A downstream service is slow; set a bounded timeout, expose the unknown outcome, and choose whether retry, a provisional response, or compensation fits.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
[Service A] -- network / timeout --> [Service B]
     |                                   |
  own data                            own data
     +---- duplicate, delay, partition-+
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

Apply distributed systems to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-07)

</div>
