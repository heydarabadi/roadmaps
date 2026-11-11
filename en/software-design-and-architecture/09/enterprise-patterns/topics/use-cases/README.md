<div dir="ltr" align="left">

# Use cases
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/09/enterprise-patterns/topics/use-cases/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

A use case coordinates an observable user or system goal.
Maintains orchestration and transaction boundary but does not inherit domain rules.
## Practical example

`PlaceOrder` coordinates cart credit, balance reservation and payment request with error policies.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Too many use case classes may create boilerplate repetition.
- **Revision:** Do not make the use case the database controller or the location of all business rules.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: use case coordinates an observable goal of the user or system.
Maintains orchestration and transaction boundary but does not inherit domain rules.
2. **What decision do you make in the example below and why?**   
- Suggested answer: `PlaceOrder` synchronizes cart credit, balance reservation and payment request with error policies.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Too many use case classes may create boilerplate repetition.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Do not make the use case the database controller or the location of all business rules.
## In-depth lesson for this topic
### 3. Use Case

A use case coordinates a visible user/system goal: placing an order, canceling a reservation, refunding.
It defines the input and output of the application and manages the transaction boundary, authorization check or workflow.
Domain rules should be assigned to the domain object/policy so that the use case does not turn into an incoherent script.
A use case can coordinate the steps of validation, loading aggregate, invoking behavior, storing and publishing the message.
Don't hide the network and database dependency directly in it; failure and retry are effective.
## Worked code example

A use case coordinates one user or system goal from input to outcome.
It makes input validation, policy calls, transaction boundaries, and failures visible.
Keep it separate from controllers and framework details.

**Common pitfall:** Do not turn it into a general service containing unrelated operations.

**Exercise with answer:** For placing an order, identify input, authorization, rules, persistence, events, and failure results in sequence; delegate each responsibility to the appropriate collaborator.
This C
# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
public sealed class PlaceOrder(
    ICustomerAccess customers,
    IOrderRepository orders,
    IUnitOfWork unitOfWork)
{
    public async Task<PlaceOrderResult> Execute(PlaceOrderInput input, CancellationToken ct)
    {
        // authorize, create valid order, persist, commit, return outcome
    }
}
~~~


## Resources
### Persian

- [Persian guide to domain-oriented design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — vocabulary of domain, model, entity and object value.
- [Persian Design Patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian description of DTO, CQRS and related patterns along with GoF.
### English

- [Martin Fowler; Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/index.html) — Reference catalog of Repository, Identity Map, Mapper and other patterns.
- [Microsoft Learn; Applying CQRS and DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — tutorial example of order and command/query separation.
## Summary

Apply the use cases to solve the specific problem, document the trade-off and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)

</div>
