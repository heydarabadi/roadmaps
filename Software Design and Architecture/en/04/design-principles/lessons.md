<div dir="ltr" align="left">

# Full lesson: Principles of software design
> **Language:** [Persian edition](../../../04/design-principles/lessons.md)
## Purpose and method of use

A design principle is not a universal answer; it is a way to reason about trade-offs.
For each principle, ask: What is likely to change?
What problem exists today?
What boundary does the principle suggest?
What new complexity would that boundary add?
The examples of this lesson are around the ordering system.
The goal is to understand the use and discard of each principle, not to memorize acronyms.
## 1. SOLID as five related guides

SOLID summarizes the five principles of object-oriented design.
Together, they improve coherence, controlled extension, and contract dependency, but their mechanical implementation increases the number of interfaces and classes.
### S — Single Responsibility

A module should have one cohesive responsibility or serve one actor that requests changes.
This does not mean every class should contain one method or perform one tiny task.
If tax rules and invoice formatting are changed by different stakeholders, the module probably has two responsibilities.
How to apply it: inspect recent changes and identify independent requirements that affect the module.
Separate responsibilities when real coupling or testing difficulty justifies it.
Tiny modules with generic names can reduce cohesion.
### O — Open-Closed

Code should be open to changing behavior by adding appropriate extensions, while not tampering with stable parts unnecessarily.
The goal is not to prevent any edit.
The goal is to reduce the risk of changing sensitive and tested logic.
If discount method is added regularly, strategy or rule registry may help.
If there are only two constant types and the change is once a year, a readable and simple switch might be better.
OCP is more appropriate for a change axis where we have real evidence of growth.
### L — Liskov Substitution

A subtype must be usable wherever the base type is expected while preserving the base behavioral contract.
If the subtype throws a new exception, prohibits the base operation, or weakens the postcondition, the subtype relationship is probably false.
Write contract test: Check for valid input, output, error, and common invariant for all implementations.
Simply having methods with the same signature is not enough.
### I — Interface Segregation

A consumer should not depend on an operation that it does not need.
Divide the large interface with unrelated methods according to the user's capability.
But building countless single-method interfaces also makes it difficult to understand the architecture.
First, see the real role of callers.
### D — Dependency Inversion

High-level policy and low-level adapters both depend on stable abstractions; the adapter implements the contract.
At runtime, a use case may call an adapter through that contract.
Runtime call direction and source dependency direction are different.

~~~text
Application policy -> PaymentAuthorizer contract <- Vendor adapter
~~~

This principle does not mean an interface for every class.
Use it where there is a change of vendor, testing requirement or ownership boundary.
## 2. DRY — Don't Repeat Yourself

DRY says not to maintain multiple independent versions of the same rule or piece of knowledge.
The goal is not to remove any textual similarity.
Two similar validations may be different rules from two actors.
Connecting them creates an unjustified dependency.
Conversely, the same tax rule replicated in a separate API and batch job will sooner or later become inconsistent.
Before extracting the common function, ask: Do the two versions express the same rule?
Do they change at the same time?
Should the output/error be the same?
If only the syntax structure is similar, keep the duplication until common knowledge is clear.
## 3. YAGNI — You Aren't Gonna Need It

Don't build a feature for a possible but unproven need.
Prospective functionality has costs to build, test, secure, document, and support, and may never be used.
Make the design evolvable, but don't impose plugin framework and multi-layer abstraction for vague assumption.
YAGNI is not an excuse to deny security, audit, privacy, data compliance or legal requirements.
These are real current needs.
Irreversible decisions and data migration may also require early anticipation.
## 4. Law of Demeter

A unit must communicate with its close associates, not know the deep chain of internal structure.
If the term customer.address.city is repeated in several places in the domain, the structure of the objects is leaked to the caller.
A domain API like shipping_destination() can hold meaning.
Demeter's law is not "any point of access is prohibited".
Many interface methods can also create boilerplate.
The problem is that the caller is dependent on details that he does not have the right to own.
## 5. Tell, Don't Ask — Tell, don't ask

When an object owns state and its invariants, ask it to perform the operation instead of reading its state, making the decision elsewhere, and calling a setter.

~~~python
# Better: the owner validates the transition
order.cancel(reason, now)

# Fragile: the caller reads the state and makes the decision
if order.state != "shipped":
    order.state = \"cancelled\"
~~~

This principle does not prohibit all queries. report and view can read data.
The problem is when several callers implement the state change rule separately.
## 6. Hollywood Principle — Let the framework call you

The "we call you" rule says that the framework or coordinator is in control of the flow of control, and the component is called via a hook or contract.
Example: the framework hands over the request to the injected handler.
The handler should not control the server cycle itself.
This method makes extension point and inversion of control possible, but makes the execution flow less obvious.
Clear trace, log and naming are required.
Dependency Injection alone is not the complete Hollywood Principle.
The main focus is on call control.
## 7. Composition over Inheritance

Combining behavior from small components instead of building deep hierarchies facilitates independent change and collaboration of multiple capabilities.
The order can have a shipping policy and a discount policy.
Do not create multiple classes to combine customer, campaign and destination types.
Inheritance is appropriate when the subtype actually preserves the base convention.
Composition is not free either: wiring, collaborators and cooperation arrangements must be maintained.
If a behavior is simple and stable, no additional interface and strategy are needed.
## 8. Encapsulate What Varies

Isolate the part that is likely to change differently from the other parts.
Find this possibility from recent changes, domain rules, multiple client requirements or vendor dependency.
Abstraction based solely on "maybe one day" is usually speculative.
Example: the tax rate for countries changes independently.
Calculation of subtotal may be fixed.
We separate the rate policy but do not divide the invoice orchestration into ten interfaces.
## 9. Program to Abstractions

The consumer depends on a contract that expresses its needs, not a concrete class or an external SDK.
This idea is close to DIP, but the emphasis is on selecting the point of use: the use case only requires the authorize capability, not all of the vendor's operations.
The abstraction should preserve the meaning and translate the failure mode.
If the API still emits the vendor type and exception, the consumer is still bound to details.
Do not create an interface for each concrete class.
Keep it for the boundary of change, testing or a few real implementations.
## 10. How to weigh the principles together?
The principles can pull in different directions:
- DRY versus coupling: merging two similar concepts can force them to change together.
- OCP versus simplicity: an extension point can add more complexity than the expected change would justify.
- Abstraction versus a direct call: a replaceable contract has construction and wiring costs.
- Composition versus inheritance: composition can improve flexibility but add collaborators to understand.
- SRP versus fragmentation: separate responsibilities when it protects an independent change; avoid classes that only pass data around.
Decision sequence: identify the pressure for change, choose the smallest design that addresses it, add a boundary test, and observe the cost of the next change.
Introduce an abstraction when the evidence supports it.
Record costly or hard-to-reverse decisions in a short ADR.
## 11. Comprehensive practice

In a hypothetical checkout:
1. Find two duplicate rules and determine if they are the same knowledge (DRY).
2. Replace an ambiguous Boolean with a meaningful operation or type when the rule needs a name.
3. Encapsulate the order transfer state (Tell, Don't Ask).
4. Decide whether discounts need a strategy or a switch is enough (OCP/YAGNI).
5. Separate the payment contract from the SDK (DIP/abstraction).
6. Record when you remove or extend this separation.
## 12. Answered quiz

1. **Does DRY require combining every pair of similar-looking code blocks?**
   - **Answer:** No. The code should represent the same knowledge and change for the same reason. Similar syntax alone is not enough.
2. **Which SOLID principle says that a consumer should not depend on methods it does not use?**
   - **Answer:** Interface Segregation Principle (ISP).
3. **Why should OCP not be applied mechanically to every switch statement?**
   - **Answer:** The set of cases may change rarely or predictably, while an extension point adds code and wiring to maintain.
4. **A subtype throws `NotImplementedError` for an operation promised by its base type. Which principle should you review?**
   - **Answer:** Liskov Substitution Principle (LSP). The subtype may not satisfy the behavior its consumers expect from the base type.
5. **A use case depends directly on a payment SDK. What change would apply DIP?**
   - **Answer:** Define a contract for the payment capability the use case needs, depend on that contract, and implement an adapter for the SDK.
6. **Does Tell, Don’t Ask mean that queries should be removed?**
   - **Answer:** No. Queries are useful. The principle warns against copying a state owner’s transition rule into multiple callers.
7. **Is one interface with 18 methods always better than 18 one-method interfaces?**
   - **Answer:** Neither number is a design goal. Shape interfaces around the coherent capabilities actual consumers need.
8. **Does YAGNI allow a team to remove payment auditing?**
   - **Answer:** No, if auditing is a current product, operational, or legal requirement. YAGNI applies to unvalidated future features.
9. **How can you review a chain of object access for Law of Demeter concerns?**
   - **Answer:** Ask whether the caller depends on internal structure that an owner could replace with a clearer domain operation.
10. **When might composition be the wrong choice?**
    - **Answer:** When there is no meaningful behavior variation, or when wiring and abstraction cost more than the flexibility they provide.
## Optional resources
### Persian

- [GoFarsi — SOLID principles in Go](https://book.gofarsi.ir/chapter-9/solid-principle-in-golang/)
- [Intelligent Software Engineering Lab — Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/)
### English

- [Refactoring.Guru — SOLID principles](https://refactoring.guru/design-patterns/solid-principles)
- [Martin Fowler — Is Design Dead?](https://martinfowler.com/articles/designDead.html)
- [Shopify Engineering — Enforcing Modularity with Packwerk](https://shopify.engineering/enforcing-modularity-rails-apps-packwerk)
## Further reading

[Curated references for this chapter](../../references.md#chapter-04)

</div>
