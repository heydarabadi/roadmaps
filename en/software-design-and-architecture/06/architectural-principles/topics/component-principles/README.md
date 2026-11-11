<div dir="ltr" align="left">

# Component Principles
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/06/architectural-principles/topics/component-principles/README.md)
> [Continue with the architectural-principles chapter lesson](../../lessons.md) for more on boundaries, policy, dependency direction, and trade-offs.

**Roadmap location:** [Architectural Principles](../../README.md) · [Full course index](../../../../00-index.md)
## Learning goals

After this topic, you should be able to:
- Decide which code belongs in the same component based on change, reuse, and release needs.
- Recognize a cyclic dependency and describe ways to remove it.
- Evaluate whether a component is stable enough to be depended on.
- Apply component principles inside a monolith before deciding whether a service boundary is needed.
## What is a component?
A component is a cohesive part of a system with a defined responsibility and contract.
It may be a module, package, library, or service.
A directory is not a meaningful boundary by itself: consumers must have a constrained way to use the component, its data needs an owner, and changes should follow an understood contract.
Component principles help answer two questions: **what belongs together?** and **which direction should dependencies point?** They do not dictate the number of packages or services.
Use them to reduce costly changes and clarify ownership.
## 1. Cohesion principles: what belongs together?
Three related principles help decide which classes or modules should be grouped:
### Reuse/Release Equivalence Principle (REP)

The unit that consumers reuse should be a meaningful unit that can be versioned and released.
Consumers should not have to take unrelated functionality every time they use one small feature.
In a monolith, the idea can guide package boundaries even when the entire application is deployed together.
### Common Closure Principle (CCP)

Group code that changes for the same reason.
If a new tax rule repeatedly forces coordinated changes across invoice formatting, customer management, and payment transport, the responsibilities or boundaries may be misplaced.
The aim is for a typical change to affect a focused component.
### Common Reuse Principle (CRP)

Do not make consumers depend on a component that contains functionality they do not use.
Unrelated code in the same package can create unnecessary dependencies, release pressure, and review work.
These principles can conflict.
A component should not be split into tiny packages merely to minimize imports; the extra contracts, versions, and coordination also have a cost.
Use change history and consumer needs to find a practical balance.
## 2. Dependency principles: which direction is healthy?
### Acyclic Dependencies Principle (ADP)

The component dependency graph should not contain cycles.
A cycle makes it hard to build, test, change, or release one component without understanding the others.

```text
Cycle:
[Catalog] ---> [Ordering] ---> [Pricing]
    ^                              |
    +------------------------------+

One possible redesign:
[Catalog] ---> [Ordering] ---> [Pricing]
                 \________ shared contract ______/
```

Ways to break a cycle include moving a stable contract to a small shared component, changing which component owns the behavior, or combining components that always change together.
Creating an interface is useful only if it makes ownership and dependency clearer; an interface that merely hides the cycle does not remove it.
### Stable Dependencies Principle (SDP)

Dependencies should point toward components that are more stable than the dependent component.
A component that changes frequently should not force a stable policy component to change whenever its implementation details move.“Stable” does not mean “never change.” Consider who owns the component, how many other parts rely on it, how costly its changes are, and whether its public contract changes independently.
### Stable Abstractions Principle (SAP)

Components that need to be stable should expose abstractions at the right boundary.
Stable policy can depend on a focused interface while replaceable infrastructure implements it.
This reduces source-code coupling, but adds indirection and contract maintenance.
Abstract only the stable decision or capability the consumer needs.
## 3. A worked ordering example

Suppose `Ordering` calls `Catalog` for product information, while `Catalog` calls `Ordering` to check order activity.
Their dependency cycle makes testing and independent changes difficult.
First ask who owns each rule.
Product descriptions and availability likely belong to the catalog capability.
Order status belongs to ordering.
If catalog only needs to receive a fact that an order was placed, ordering can publish an `OrderPlaced` event and catalog can update its own view.
If the interaction must be synchronous, define a small contract at the correct ownership boundary.
In both designs, state who owns the source-of-truth data and how failures are handled.
Keep the components in one process if the main need is code-level modularity.
A service extraction adds network latency, partial failure, deployment, security, and consistency concerns; do it only when independent deployment, scaling, security, or team ownership has measurable value.
## 4. Shopify's documented experience

Shopify's engineering team described modularizing its large Rails codebase with components, explicit ownership, and boundary tooling.
The team reported benefits from narrower tests and clearer ownership while acknowledging the time and behavior changes needed to sustain the work.
This case shows that component principles can improve a monolith without converting each component into a network service. [Shopify's modularity follow-up](https://shopify.engineering/shopify-monolith) and [Packwerk article](https://shopify.engineering/enforcing-modularity-rails-apps-packwerk)
## 5. A practical component review

For a proposed component, write down:
1. Its responsibility and the domain language it owns.
2. Its source-of-truth data and invariants.
3. The public operations consumers need.
4. Which code usually changes with it and which consumers reuse it.
5. Its direct and indirect dependencies, including cycles.
6. Its tests, owner, and release boundary.
7. Whether an in-process boundary is sufficient or a deployment boundary is required.
Then follow one recent change through the graph.
How many components changed?
Which changes were necessary?
Which consumers were affected unexpectedly?
The answer is more useful than a slogan such as “the modules are too coupled.”
## Trade-offs and common mistakes
- **A directory is treated as a boundary.** Callers can still access private implementation and data.
- **Every class gets a package or interface.** The code gains indirection without gaining a useful contract.
- **A shared component becomes a dependency sink.** Every team adds unrelated code, making it unstable and difficult to version.
- **A cycle is hidden behind an interface.** The dependency graph and ownership remain cyclic.
- **A service is extracted to solve a source-code problem.** The team inherits network and operational costs without needing independent deployment.
- **Reuse is optimized in isolation.** A general-purpose library may become difficult to change because unrelated consumers depend on every behavior.
## Practice with answer

Three modules depend on one another: `Orders` imports `Pricing`; `Pricing` reads private tables owned by `Catalog`; `Catalog` queries `Orders` to show recent purchases.
The same team releases all three every week.
1. Draw the dependency graph.
2. Assign ownership of price, product, and order data.
3. Find which changes really need to happen together.
4. Propose the simplest change that removes unnecessary dependency.
5. Decide whether any part needs a separate deployment.

**Suggested answer:** Make `Catalog` the owner of product and availability data, `Pricing` the owner of price rules, and `Orders` the owner of order state.
Replace direct reads of private catalog tables with a focused contract or a catalog-owned view.
Remove the catalog-to-orders query if it only needs to react to order changes; publish an `OrderPlaced` fact and let catalog maintain a read view when asynchronous freshness is acceptable.
Keep the modules in process initially because one team releases them together.
Reconsider service extraction only if ownership, scale, security, or release constraints change.
## Answered quiz

1. **What makes a component more than a folder?**
   **Answer:** A defined responsibility, a controlled contract, visible dependencies, and clear ownership of its data or changes.
2. **What does Common Closure suggest?**
   **Answer:** Keep code that changes for the same reason together so a typical change remains focused.
3. **How do REP and CRP differ?**
   **Answer:** REP treats reuse as a release/versioning unit.
CRP cautions consumers against depending on unrelated functionality they do not use.
4. **Why are dependency cycles costly?**
   **Answer:** A change in one part can force changes across the cycle, making testing, building, ownership, and release harder to isolate.
5. **Does adding an interface always break a cycle?**
   **Answer:** No.
The contract must be owned in a way that changes the dependency direction.
A decorative interface can leave the cycle intact.
6. **What is a stable component?**
   **Answer:** A component whose contract and ownership make it less likely to change in response to its dependencies; stability is relative, not permanent.
7. **When should a component become a service?**
   **Answer:** When independent deployment, scaling, security isolation, or team ownership is valuable enough to justify network and operational costs.
## Further reading
### English

- [Shopify Engineering — Under Deconstruction](https://shopify.engineering/shopify-monolith) — Sustaining component boundaries inside a large Rails monolith.
- [Shopify Engineering — Enforcing Modularity with Packwerk](https://shopify.engineering/enforcing-modularity-rails-apps-packwerk) — Tooling that checks package boundaries.
- [Martin Fowler — Microservices](https://martinfowler.com/articles/microservices.html) — Service boundaries, deployment autonomy, and operational trade-offs.
- [Microsoft Azure Architecture Center — Architecture styles](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/) — Constraints and trade-offs between common system shapes.
### Persian

- [DNTips — Software architecture article archive](https://www.dntips.ir/exports/tag/www.dntips.ir-tag-698.pdf) — Persian architecture articles, including modular and hexagonal design.
- [DNTips — Layered Architecture, Part 2](https://www.dntips.ir/post/1261) — A Persian example of domain responsibilities and boundaries.
For additional sources, see the [course reference library](../../../../references.md#chapter-06).

</div>
