<div dir="ltr" align="left">

# Policy vs Detail
> **Language:** [Persian edition](../../../../../06/architectural-principles/topics/policy-vs-detail/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Position in the road map:** [Principles of Architecture](../../README.md) · [List of the whole course](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

High-level policy is business rules.
Details such as the web framework, file and database should depend on the policy in the outer layer, not the other way around.
## Practical example

The rule for allowing refunds remains separate from EF Core and HTTP.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Architecture" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Too much boundary can make a simple project needlessly layered.
- **Revision:** If the ORM change forces the domain logic to change, the dependency direction is leaky.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: high-level policy is business rules.
Details such as the web framework, file and database should depend on the policy in the outer layer, not the other way around.
2. **What decision do you make in the example below and why?**   
- Suggested answer: Allowing refund rules remains separate from EF Core and HTTP.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: too much boundary can make a simple project needlessly layered.
4. **Which common error do you check before merging the code?**   
- Suggested answer: If the ORM change forces the domain logic to change, the dependency direction is leaky.
## In-depth lesson for this topic
### 2. Policy vs.
DetailPolicy is a decision that determines business behavior; detail is the technical way of execution.
The rule that refunds are allowed after a few days is policy.
Using PostgreSQL, ASP.
NET or a payment SDK is a detail.
Source dependency should go from detail to policy: domain or application defines the contract; implement database adapter and SDK.
The runtime call may come from the policy to the adapter, but the policy code should not know the type and the external API directly.

~~~text
Payment use case -> PaymentAuthorizer port <- Vendor adapter -> provider SDK
~~~

Hiding all technologies is not the goal.
If the ORM has the necessary functionality or mapping costs, use it.
But know where you sacrifice portability and testability.
The boundary is valuable when the policy is changed or tested independently.
## Architecture diagram and walkthrough

Policy expresses the decisions the system makes; details describe which library, network, or database executes them.
Details can depend on ports while policy remains independently testable.

**Common pitfall:** Runtime control flow is not the same as source dependency direction.

**Exercise with answer:** Inject a fake gateway through the contract for payment tests; policy should not depend on a real SDK or network.
This simplified diagram shows one view; real systems need explicit failure, security, and ownership decisions.

~~~text
Source dependency points inward:
[Web / database / SDK] ---> [Ports] <--- [Business policy]

Runtime control may point outward:
[Business policy] ---> [Port] ---> [Web / database / SDK]
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

Apply the policy against details to solve the specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-06)

</div>
