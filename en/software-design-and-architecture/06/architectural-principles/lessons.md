<div dir="ltr" align="left">

# Full lesson: Architectural principles
> **Language:** [Persian edition](../../../../fa/software-design-and-architecture/06/architectural-principles/lessons.md)
## What does architecture decide?
Software architecture captures the important decisions about boundaries, dependencies, state, communication, and deployment.
Those decisions influence system qualities and the cost of future change.
Calling “everything” architecture is not useful.
Focus on a decision when getting it wrong would be expensive to reverse or would unexpectedly affect several components, teams, or customers.
Begin with the pressures the product must satisfy: latency, availability, security, auditability, team ownership, delivery speed, implementation cost, and the ability to change.
These qualities can conflict.
Architecture is the act of choosing among options and making their consequences visible.
## 1. Components and their boundaries

A component is a cohesive unit with a responsibility and a contract.
A folder, package, or assembly is not automatically a useful component.
The boundary should control access, make dependencies visible, and give the team a clear place to own changes.
A strong component boundary usually has:
1. A coherent capability or area of responsibility.
2. A clear owner for its data and invariants.
3. A small, intentional public API.
4. Explicit allowed dependencies, with cycles prevented or justified.
5. Tests and ownership practices that enforce the contract.
Three classic component principles offer useful questions:
- **Reuse/Release Equivalence:** are components that are reused together released and versioned together?
- **Common Closure:** do components that change for the same reason stay together?
- **Common Reuse:** can consumers depend on a focused component without importing unrelated functionality?
These principles are design prompts, not a formula for creating the smallest possible packages.
Use actual change history and ownership to discover boundaries.
Put code that changes together near one another; let independently changing capabilities collaborate through controlled contracts.
### Shopify's documented experience

Shopify described modularizing its large Rails codebase with components, package boundary tooling, tests, and explicit ownership.
The company emphasized that architecture change at this scale also requires changing developer habits.
The account demonstrates that modular boundaries can exist inside a monolith; it does not mean the same design fits every organization.
See [Deconstructing the Monolith](https://shopify.engineering/deconstructing-monolith-designing-software-maximizes-developer-productivity) and the follow-up on [enforcing modularity with Packwerk](https://shopify.engineering/enforcing-modularity-rails-apps-packwerk).
## 2. Policy and implementation detail**Policy** expresses what the application or business decides. **Detail** is one way to carry out that decision. “Allow a refund within the permitted period” is policy.
PostgreSQL, ASP.
NET, and a payment provider's SDK are implementation details.
Source-code dependencies should point toward stable policy.
For example, an application use case defines the payment capability it needs, and a vendor adapter implements that contract.
At runtime the use case calls the adapter, but the policy source code does not depend on the vendor's concrete types.

```text
Order use case -> PaymentAuthorizer contract <- Vendor adapter -> Provider SDK
```

The goal is not to hide every technology.
An ORM or provider SDK may be a sound choice.
Make the trade-off explicit: what becomes harder to replace, test, or change independently?
A boundary is useful when the policy needs to remain understandable without knowing the details.
## 3. Cohesion and coupling**Cohesion** describes how closely a component's responsibilities fit together. **Coupling** describes how much one component knows about or relies on another.
A system with no dependencies would not do useful work; the aim is to control dependencies and remove knowledge that is not needed.
Warning signs of costly coupling include:
- A change to one module's private schema breaks many callers.
- Callers read another component's internal tables or fields directly.
- Two services make repeated synchronous calls just to finish one user request.
- A feature works only when several independently delivered events happen in an undocumented order.
Healthy cohesion is more likely when operations share one capability and language, related changes stay within the same boundary, and consumers can be tested against a stable contract.
Assess coupling through a real change scenario.
If the shipping calculation changes, which files, teams, tests, APIs, and deployments must change?
Record accidental propagation and contract violations.
Do not assume that splitting a component into services removes coupling: it can move coupling from in-process calls to APIs, data mapping, network failure, and coordinated releases.
## 4. Choosing a boundary

A boundary defines ownership, the contracts available to consumers, and where a dependency crosses.
It may be inside a package or process, between services, at a security trust zone, between teams, or between bounded contexts.
Use this sequence to evaluate a candidate boundary:
1. Identify the actors and business rules that change together.
2. Assign ownership of the source-of-truth data and its invariants.
3. Count required collaborations and include network latency and failure if the boundary is remote.
4. Define a contract, its security rules, and how to observe the result.
5. Start with an in-process boundary when it provides enough isolation; introduce a network boundary when independent deployment, scaling, security, or ownership justifies it.
Splitting one transaction across services creates new consistency work: retries, duplicate handling, reconciliation, and operational procedures.
Keeping everything in one component can also leave ownership unclear and changes entangled.
Compare both costs against the product's actual needs.
## 5. Testing at the policy/detail boundary

Test business policy without a live provider or production database when practical.
Test an adapter against its I/O contract.
Use an integration test to verify that the application, adapter, and real dependency work together in the intended environment.
If the refund rule requires a cloud provider to run, policy is entangled with implementation detail.
If an adapter test uses only mocks, the provider's real contract is still unverified.
Different tests answer different questions; neither unit tests nor mocks prove the behavior of an external provider.
## 6. Case study: Prime Video's monitoring service

In a 2023 report, Prime Video's Video Quality Analysis team described one audio/video monitoring service.
Its initial distributed serverless design incurred orchestration and data-transfer costs that constrained the workload.
The team moved the related components into one process deployed on EC2/ECS, then replicated the application with different detector subsets as capacity needs grew.
It reported more than 90% lower infrastructure cost for that service.
This is evidence that the cost of a boundary should be measured for its workload.
It is not a report that Prime Video replaced its entire platform or a general rejection of microservices.
The original Prime Video Tech page currently redirects; a saved copy of the [team's report is available as a PDF](https://www.wudsn.com/productions/www/site/news/2023/2023-05-08-microservices-01.pdf).
## 7. Answered quiz

1. **Is a folder automatically a component boundary?**
   **Answer:** No.
It must control dependencies or access and give consumers a meaningful contract and ownership boundary.
2. **Give one example of policy and one of implementation detail.**
   **Answer:** Refund eligibility is policy; a SQL database or a payment SDK is an implementation choice.
3. **How can a team assess whether coupling is too costly?**
   **Answer:** Follow a real change and record which files, teams, tests, APIs, and deployments must change, including changes that were not intended.
4. **Is zero coupling the objective?**
   **Answer:** No.
Components must collaborate.
The objective is to limit unnecessary knowledge and keep dependencies controlled.
5. **When should an in-process component become a service?**
   **Answer:** When independent ownership, deployment, scaling, or security isolation provides enough value to justify network, consistency, observability, and operational costs.
6. **What does the Prime Video case study demonstrate, and what does it not demonstrate?**
   **Answer:** It demonstrates that redesigning a particular monitoring workload around measured costs can improve that service.
It does not establish that every Prime Video workload—or every system—should use a monolith.
7. **Why are different test levels needed at an adapter boundary?**
   **Answer:** A unit test can check policy, an adapter test can check I/O behavior, and an integration test can check the real connection.
One does not prove the others.
## 8. Comprehensive exercise: map a component boundary

Choose an existing application, or use an online store.
Draw its modules, data owners, key business policies, public APIs, dependency cycles, and the changes that happen most often.
Pick one candidate boundary and compare keeping it inside the process with deploying it independently.

**Worked answer:** Suppose catalog and checkout code share one database and are changed by the same small team.
First add explicit module APIs and prevent direct writes to another module's tables.
Track whether checkout changes force catalog releases and whether catalog has an independent scaling or security need.
If the boundaries hold and deployments are not a bottleneck, keep the modules in process.
Consider service extraction only when measured independent release, scaling, security, or team ownership is more valuable than extra network and data-consistency work.
## Optional further reading
### English

- [Shopify Engineering — Under Deconstruction](https://shopify.engineering/shopify-monolith) — Lessons from modularizing a large Rails monolith.
- [Shopify Engineering — Enforcing Modularity with Packwerk](https://shopify.engineering/enforcing-modularity-rails-apps-packwerk) — Tooling for controlling internal package dependencies.
- [Microsoft Azure Architecture Center — Architecture styles](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/) — Styles, constraints, and common trade-offs.
- [Microsoft — Clean Architecture for .NET applications](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures) — Common application structures and dependency direction.
- [Martin Fowler — Microservices](https://martinfowler.com/articles/microservices.html) — Service boundaries, independent deployment, and operational prerequisites.
- [Prime Video Tech — Monitoring service report (saved copy)](https://www.wudsn.com/productions/www/site/news/2023/2023-05-08-microservices-01.pdf) — A workload-specific architecture report; do not generalize its result to the entire platform.
### Persian

- [DNTips — Software Architecture article archive](https://www.dntips.ir/exports/tag/www.dntips.ir-tag-698.pdf) — Persian architecture articles, including modular and hexagonal discussions.
- [DNTips — Layered Architecture, Part 2](https://www.dntips.ir/post/1261) — A Persian walkthrough of the domain-model layer.
- [Intelligent Software Engineering Lab — Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian course material on design principles and architecture.
For the complete chapter bibliography, see the [course reference library](../../references.md#chapter-06).

</div>
