<div dir="ltr" align="left">

# Peer-to-Peer
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/07/architectural-styles/topics/peer-to-peer/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location on the road map:** [Architecture styles](../../README.md) · [Total course list](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

In P2P, each node can be both a consumer and a provider of resources.
Peer discovery, trust and resilience are among the issues.
## Practical example

File transfer nodes exchange chunks of data directly with each other, and the tracker only facilitates discovery.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Architectural Styles" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Uncertain nodes and unstable state are difficult to manage.
- **Review:** Don't choose P2P because of server removal without considering security, NAT and compatibility.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: in P2P, each node can be both a consumer and a provider of resources.
Peer discovery, trust and resilience are among the issues.
2. **What decision do you make in the example below and why?**   
- Suggested answer: File transfer nodes exchange data chunks directly with each other and the tracker only facilitates discovery.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Uncertain nodes and unstable state are difficult to manage.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Don't choose P2P because of server removal without considering security, NAT and compatibility.
## In-depth lesson for this topic
### 6. Peer-to-Peer

In P2P, a node can be both a consumer and a provider of data/resource.
This style can provide capacity distribution and resiliency, but makes discovery, NAT, trust, churn, consistency, and abuse difficult.
Removing the server is not the only reason for choosing P2P.
Design threat model and insecure nodes.
## Architecture diagram and walkthrough

In P2P, each node may both request and provide resources; removing a central point can improve resilience or resource distribution.
Peer discovery, trust, churn, abuse, and inconsistent state still need solutions.

**Common pitfall:** Removing a central server does not remove coordination or operational cost.

**Exercise with answer:** A malicious peer sends false data; validate signatures and reputation, and do not trust every response by default.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
       [Peer A] ----- [Peer B]
          |  \          /  |
          |   \        /   |
       [Peer C] ----- [Peer D]

Each node can initiate and serve requests.
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

Apply peer-to-peer to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-07)

</div>
