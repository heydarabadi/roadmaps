<div dir="ltr" align="left">

# Serverless Architecture
> **Language:** [Persian edition](../../../../../08/architectural-patterns/topics/serverless/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location in the roadmap:** [Architecture Patterns](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The code is executed as a function or managed service, and part of the provisioning and scaling is entrusted to the provider.
Operation ownership is not removed.
## Practical example

Image loading processing can be event-driven and short-lived.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its background are linked in the "Architectural Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** cold start, time/memory limit, invocation cost and provider dependency should be checked.
- **Review:** Don't consider serverless as serverless or cheap per workload.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: the code is executed as a function or managed service, and part of the provisioning and scalability is entrusted to the provider.
Operation ownership is not removed.
2. **What decision do you make in the example below and why?**   
- Suggested answer: Image loading processing can be event-driven and run short-term.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: cold start, time/memory limitation, invocation cost and provider dependency should be checked.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't consider serverless as serverless or cheap per workload.
## In-depth lesson for this topic
### 6. Serverless

Serverless means that parts of provisioning, runtime or scaling are managed by the provider.
The server is not actually deleted.
Function/event-driven execution is useful for bursty, short-term and standalone workloads.
You should measure: cold start, maximum execution time, memory, concurrency limit, provider lock-in, data between invocations, observability and cost per invocation.
A persistent workload or high volume processing may require a cheaper and more predictable container/VM.
## Architecture diagram and walkthrough

Serverless delegates server management to a provider and runs functions in response to events or requests.
Usage-based cost and scaling may help, while cold starts, quotas, observability, local testing, and lock-in need review.

**Common pitfall:** Stateless functions do not mean the system has no state; persist it in an external service.

**Exercise with answer:** A function may run twice; design an idempotency key and durable result storage.
This is a simplified view; production design must also state ownership, failure, security, and operational constraints.

~~~text
[HTTP / queue / timer event]
              |
              v
         [Function]
          /      \
 [Managed DB] [Object store]
              |
       provider runs/scales
~~~


## Architecture diagram and walkthrough

Serverless runs functions for requests or events and delegates server management to a provider.
Usage-based cost and scaling may help; assess cold starts, quotas, observability, local testing, and lock-in.

**Common pitfall:** Stateless functions do not remove the need to persist application state.

**Exercise with answer:** A function runs twice; design an idempotency key and durable result storage.
This simplified view should be supplemented with explicit ownership, failure, security, and operational decisions.

~~~text
[HTTP / queue / timer event]
              |
              v
         [Function]
          /      \
 [Managed DB] [Object store]
              |
       provider runs/scales
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

Apply a serverless architecture to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-08)

</div>
