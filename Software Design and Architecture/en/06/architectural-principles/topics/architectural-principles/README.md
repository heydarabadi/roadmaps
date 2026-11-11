<div dir="ltr" align="left">

# Architectural Principles
> **Language:** [Persian edition](../../../../../06/architectural-principles/topics/architectural-principles/README.md)
> [Continue with the full chapter lesson](../../lessons.md) for more examples and a worked boundary exercise.

**Roadmap location:** [Architectural Principles](../../README.md) · [Full course index](../../../../00-index.md)
## Learning goals

After this topic, you should be able to:
- Explain how architecture decisions affect quality attributes and the cost of change.
- Separate business policy from implementation detail.
- Find coupling and boundary problems by following a real change.
- Choose a component, service, or team boundary using evidence.
- Record an important decision and the conditions that would make you revisit it.
## Core idea

: architecture is a set of consequential decisionsArchitecture concerns decisions about responsibility, ownership, dependencies, state, communication, and deployment.
A choice is architectural when getting it wrong would be expensive to reverse or would affect several parts of the system, teams, or users.
Start with the qualities the product needs. “Fast” and “secure” are not measurable requirements by themselves.
Write a scenario:> When checkout receives a normal order, the API should return within the stated latency target.
If the payment provider is slow, the system must stop waiting by a defined deadline, avoid charging twice, and show a recoverable status.
Latency, availability, security, auditability, operability, delivery speed, and cost can conflict.
The architecture decision is a trade-off among these pressures, not a search for one universal best structure.
## 1. Policy and implementation detail

Policy expresses a business or application decision.
Detail describes one mechanism used to implement it. “A refund is allowed only while the order is eligible” is policy.
SQL Server, PostgreSQL, ASP.
NET, and a provider SDK are implementation choices.
Source dependencies should point toward policy.
The use case owns the payment capability it needs; an adapter translates that contract to a vendor SDK.
The runtime call can reach outward to the adapter while the source-code dependency points inward to the application-owned contract.

```text
Source dependency:
[Order policy] ---> [Payment contract] <--- [Vendor adapter] ---> [Provider SDK]

Runtime call:
[Order policy] ---> [Payment contract] ---> [Vendor adapter] ---> [Provider SDK]
```

An abstraction is useful when it protects a stable rule, a real testing boundary, or an independently changing vendor integration.
It is not necessary to wrap every framework type.
Consider the portability, testability, and coupling you gain against the mapping and maintenance cost.
## 2. Cohesion and coupling**Cohesion** describes whether a component's responsibilities belong together. **Coupling** describes how much one component knows about or depends on another.
A system needs collaboration; the goal is to limit unnecessary knowledge and avoid letting unrelated changes spread.
Warning signs include:
- A private schema change breaks many callers.
- A component reads another component's internal table or field.
- Two services make repeated synchronous calls to complete one user action.
- Several event messages must arrive in an undocumented order for the result to be correct.
- A component has no clear owner because multiple teams change its behavior for different reasons.
Follow a concrete change instead of assigning a vague label such as “too coupled.” If shipping rules change, list the files, teams, tests, APIs, and deployments that must change.
Count unintended changes and identify which boundary or contract failed.
Splitting a component does not automatically remove coupling.
It can replace a local call with API compatibility, network latency, retries, distributed tracing, and consistency work.
A well-enforced in-process boundary is often the least expensive way to control source-code dependencies.
## 3. Component and service boundaries

A boundary determines who owns the data and invariants, which contracts consumers may use, and where dependencies cross.
Boundaries may be inside a package, between services, across a security trust zone, between teams, or between bounded contexts.
To evaluate a proposed boundary:
1. Identify the business rules and changes that belong together.
2. Name the owner of each source-of-truth data set and invariant.
3. List how often the parts must collaborate and whether they need one transaction.
4. Define the contract, authorization rules, timeout behavior, and observability.
5. Start with the least costly boundary that meets the need; add a network boundary only when independent deployment, scaling, security, or ownership justifies it.
If splitting the boundary divides one transaction across services, design for eventual consistency, retries, duplicate messages, reconciliation, and support procedures.
If the boundary remains too broad, ownership and independent changes may stay tangled.
Evaluate both failure modes.
## 4. Testing at a boundary

Different tests establish different evidence:
- A **domain or policy test** checks business rules without a live database or provider.
- An **adapter test** checks how an implementation translates the contract to I/O.
- An **integration test** checks the real connection among the application and its dependencies in a specific environment.
If the refund rule needs a cloud deployment to run, the policy may depend too heavily on infrastructure.
If the provider adapter has only been tested with a mock, its real contract remains unverified.
Keep the evidence boundary clear.
## 5. Case studies and what they teach
### Shopify: modularity inside a monolith

Shopify described using components, tooling, and ownership to improve boundaries in a large Rails codebase.
The case emphasizes that architecture changes need ongoing team habits as well as automated checks.
It shows that a monolith can have deliberate modules; it is not a universal rule that every product should use the same approach. [Shopify Engineering — Under Deconstruction](https://shopify.engineering/shopify-monolith)
### Prime Video: measure the workload

Prime Video's Video Quality Analysis team reported redesigning one audio/video monitoring service after orchestration and data-transfer costs constrained its workload.
The team moved related components into one process and reported lower infrastructure cost for that service.
The finding is specific to that workload, not the whole Prime Video platform.
The [saved engineering report](https://www.wudsn.com/productions/www/site/news/2023/2023-05-08-microservices-01.pdf) describes the system and its trade-offs.
These cases support measurement and explicit boundaries.
They do not prove that one deployment style is best for every system.
## 6. Make decisions reviewable

For a consequential choice, record an architecture decision in a short ADR:
1. **Context:** What problem, constraints, and quality targets matter?
2. **Decision:** Which option did the team choose?
3. **Alternatives:** What simpler or competing options were considered?
4. **Consequences:** What benefits, costs, risks, and operational duties follow?
5. **Revisit conditions:** What evidence would make the team reconsider?
An ADR is useful when the choice has meaningful future impact.
It should explain why the current option fits the known context, not claim that the option is universally correct.
## Common mistakes
- Choosing a fashionable style before defining the quality attributes.
- Treating a directory name as proof of modularity.
- Calling an abstraction “decoupling” without identifying what change it isolates.
- Assuming fewer dependencies is always better, even when a stable contract adds more cost than value.
- Extracting a service to fix code organization without accounting for network failure and operations.
- Treating one company's case study as a universal benchmark.
## Practice with answer

A store has one team and one shared release.
Ordering directly reads catalog tables.
A proposed rewrite would split every domain into a microservice.
First, map the ownership of order, product, and price rules.
Follow a typical catalog change and a typical order change.
Then compare an in-process API boundary with a service boundary.

**Suggested answer:** Give catalog ownership of product and availability data, and ordering ownership of order lifecycle and invariants.
Prevent ordering from writing catalog tables directly; expose only the product information needed through a module contract.
Keep the modules in process while one team shares deployment.
Measure whether the change boundary holds and whether independent scaling, security, or release is needed.
If there is no such pressure, microservices would add network and operating work without solving a current problem.
## Answered quiz

1. **What makes a decision architectural?**
   **Answer:** Reversing it is costly, or an incorrect choice can affect multiple components, teams, users, or important quality attributes.
2. **Give an example of policy and implementation detail.**
   **Answer:** Refund eligibility is policy; the database and payment-provider SDK are implementation details.
3. **How can a team assess coupling objectively?**
   **Answer:** Follow a real change scenario and record affected files, teams, tests, APIs, and deployments, including unintended changes.
4. **Is zero coupling the goal?**
   **Answer:** No.
Components need to collaborate.
The goal is to control dependencies and limit unnecessary knowledge.
5. **When should a component become a service?**
   **Answer:** When independent deployment, scaling, security, or team ownership has enough value to justify network and operational costs.
6. **What does a unit test of policy prove about a payment provider?**
   **Answer:** It proves the tested policy behavior, not the provider's real contract or production integration.
7. **Why should a Prime Video result not be generalized to every system?**
   **Answer:** Workload shape, costs, team, limits, and goals vary.
The report concerns one monitoring service.
## Further reading
### English

- [Shopify Engineering — Under Deconstruction](https://shopify.engineering/shopify-monolith) — Components and ownership inside a large Rails monolith.
- [Shopify Engineering — Enforcing Modularity with Packwerk](https://shopify.engineering/enforcing-modularity-rails-apps-packwerk) — Tooling for package boundaries.
- [Microsoft Azure Architecture Center — Architecture styles](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/) — Constraints, trade-offs, and common architecture shapes.
- [Martin Fowler — Microservices](https://martinfowler.com/articles/microservices.html) — Service autonomy, boundaries, and operational costs.
- [Prime Video Tech — Monitoring service report (saved copy)](https://www.wudsn.com/productions/www/site/news/2023/2023-05-08-microservices-01.pdf) — A workload-specific engineering report.
### Persian

- [DNTips — Layered Architecture, Part 2](https://www.dntips.ir/post/1261) — A Persian explanation of layer responsibilities.
- [DNTips — Software architecture article archive](https://www.dntips.ir/exports/tag/www.dntips.ir-tag-698.pdf) — Persian articles on software architecture, modularity, and boundaries.
For additional sources, see the [course reference library](../../../../references.md#chapter-06).

</div>
