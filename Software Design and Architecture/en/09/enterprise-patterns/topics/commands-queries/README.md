<div dir="ltr" align="left">

# Commands and Queries
> **Language:** [Persian edition](../../../../../09/enterprise-patterns/topics/commands-queries/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

command is a request for change and query reads the answer without changing the state.
Their contract makes side effect, validation and response clear.
## Practical example

`ApproveRefund` is the command; `GetRefundStatus` is a query and does not change the data.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simpler:** Separation of handlers brings boilerplate and coordination.
- **Review:** A hidden query that changes state or a command that gives inconsistent output breaks the contract.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: command is a request for change and query reads the answer without changing the state.
Their contract makes side effect, validation and response clear.
2. **What decision do you make in the example below and why?**   
- Suggested answer: `ApproveRefund` is the command; `GetRefundStatus` is a query and does not change the data.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: separation of handlers brings boilerplate and coordination.
4. **Which common error do you check before merging the code?**   
- Suggested answer: A hidden query that changes state or a command that gives inconsistent output breaks the contract.
## In-depth lesson for this topic
### 7. Command and Query

Command is a state change request and usually returns an outcome or ID; query gives information and state does not change the domain.
This also clears up the CQS separation in the API.
Command must have permission, validation, idempotency and clear failure.
Query can give concise and cacheable projection.
Query should not execute a hidden command under the name of read.
Separate technical side effects such as logging from domain mutation.
If the read and write model diverges significantly, check CQRS.
Simply separating the handlers does not make CQRS complete or require two databases.
## Worked code example

A command requests a change or side effect; a query reads data and should not mutate state.
Separating them clarifies outcomes, but separate projections or CQRS are not required without a real need.

**Common pitfall:** Do not give a mutating operation a query name or hide writes in a query.

**Exercise with answer:** GetOrderStatus is read-only.
CancelOrder is a command and should return the transition result.
This C
# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
public sealed record GetOrderStatus(OrderId Id);
public sealed record CancelOrder(OrderId Id, CancellationReason Reason);

Task<OrderStatusView> Handle(GetOrderStatus query, CancellationToken ct);
Task<CancelResult> Handle(CancelOrder command, CancellationToken ct);
~~~


## Resources
### Persian

- [Persian guide to domain-oriented design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — vocabulary of domain, model, entity and object value.
- [Persian Design Patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian description of DTO, CQRS and related patterns along with GoF.
### English

- [Martin Fowler; Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/index.html) — Reference catalog of Repository, Identity Map, Mapper and other patterns.
- [Microsoft Learn; Applying CQRS and DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — tutorial example of order and command/query separation.
## Summary

Apply commands and queries to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)

</div>
