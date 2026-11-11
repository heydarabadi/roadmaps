<div dir="ltr" align="left">

# Client-Server
> **Language:** [Persian edition](../../../../../07/architectural-styles/topics/client-server/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location on the road map:** [Architecture styles](../../README.md) · [Total course list](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The client sends a request to a server that owns or provides a resource or capability.
Connection handling, authentication, protocol design, and versioning are part of the contract.
## Practical example

The mobile application registers an order from the REST API.
The server controls credit and balance.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Architectural Styles" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep the design simpler:** A central server can become an availability or capacity bottleneck when the system does not need this interaction model.
- **Review:** Do not trust the client.
Server-side authentication and authorization is essential.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Proposed answer: the client requests a resource or capability from the server.
Connection handling, authentication, protocol design, and versioning are part of the contract.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The mobile application registers an order from the REST API.
The server controls credit and balance.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: The centrality of the server makes it a point that requires availability and capacity.
4. **Which common error do you check before merging the code?**   
- Suggested answer: don't trust the client.
Server-side authentication and authorization is essential.
## In-depth lesson for this topic
### 5. Client-Server

The client requests and the server owns the resource or capability.
HTTP API usually has stateless request/response, but the server still keeps persistent state and session/domain data.
Do not assume that the client side is a reliable source of security: authentication, authorization and validation are required on the server side.
Costs: network latency, timeout, retry, contract versioning, server capacity and partial failure.
The request may have been executed by the server, but the response is lost in the network; command must have idempotency key or reconciliation.
## Architecture diagram and walkthrough

The client sends requests and the server owns response handling and often shared state.
The network adds latency, timeouts, authentication, and failure; retry without idempotency may repeat an operation.

**Common pitfall:** Do not assume a server is always available.

**Exercise with answer:** A payment request times out; use an idempotency key or status lookup before retrying to learn whether the first payment succeeded.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
[Client] -- request / response --> [Server] ---> [Database]
    ^                                  |
    +--------------- response --------+
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

Apply the client-server model to a concrete requirement, document the trade-offs, and check with tests or operational measures whether it improves the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-07)

</div>
