<div dir="ltr" align="left">

# Design Principles
> **Language:** [Persian edition](../../../../../04/design-principles/topics/design-principles/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Design Principles](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

A design principle is a general guideline for maintaining variability, comprehensibility, testability, or consistency.
Each application must be justified by the actual pressure of the project.
## Practical example

Before adding abstraction, name a change that would make it cheaper.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Principles of Design" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **when to keep it simple:** principles conflict with each other.
Freedom of change and simplicity are not always maximized at the same time.
- **Review:** Do not turn the principle into a rule without exception or a criterion for evaluating humans.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: A design principle is a general guideline for maintaining variability, comprehensibility, testability, or consistency.
Each application must be justified by the actual pressure of the project.
2. **What decision do you make in the example below and why?**   
- Suggested answer: Before adding abstraction, name a change that makes it cheaper.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: principles conflict with each other.
Freedom of change and simplicity are not always maximized at the same time.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Do not turn the principle into a rule without exception or a criterion for evaluating humans.
## In-depth lesson for this topic
## Full lesson: Principles of software design
### Purpose and method of use

The principle of design is not a definitive answer to every problem.
It is a guide to see the possible cost.
Apply each principle with these four questions: What change is likely?
What is causing the problem in the code now?
What boundary does this principle suggest?
What new complexity does it impose?
The examples of this lesson are around the ordering system.
The goal is to understand the use and discard of each principle, not to memorize acronyms.
### 1. SOLID as five related guides

SOLID summarizes the five principles of object-oriented design.
Together, they improve coherence, controlled extension, and contract dependency, but their mechanical implementation increases the number of interfaces and classes.
#### S — Single Responsibility

A module should be grouped around a cohesive responsibility or a group that changes a requirement.
It doesn't mean "each class is just a method" or "a small task".
If tax change and invoice printing format change are usually requested by two independent actors, we probably have two responsibilities.
Method: check recent changes.
Find independent requirements that affect a module.
Separate the boundary only when there is real coupling or test difficulty.
Tiny modules with generic names can make cohesiveness worse.
#### O — Open-Closed

Code should be open to changing behavior by adding appropriate extensions, while not tampering with stable parts unnecessarily.
The goal is not to prevent any edit.
The goal is to reduce the risk of changing sensitive and tested logic.
If discount method is added regularly, strategy or rule registry may help.
If there are only two constant types and the change is once a year, a readable and simple switch might be better.
OCP is more appropriate for a change axis where we have real evidence of growth.
#### L — Liskov Substitution

The subtype must sit in place of the base type and maintain the behavioral convention.
If the subtype throws a new exception, prohibits the base operation, or weakens the postcondition, the subtype relationship is probably false.
Write contract test: Check for valid input, output, error, and common invariant for all implementations.
Simply having methods with the same signature is not enough.
#### I — Interface Segregation

A consumer should not depend on an operation that it does not need.
Divide the large interface with unrelated methods according to the user's capability.
But building countless single-method interfaces also makes it difficult to understand the architecture.
First, see the real role of callers.
#### D — Dependency Inversion

High-level logic does not depend on low-level details.
Both rely on the stable contract and implement its details.
Source dependency code is directed from the controller/SDK to the application or domain contract.
In runtime, the call may come from the use case to the adapter.
The call execution direction is not the same as the code dependency direction.

~~~text
Application policy -> PaymentAuthorizer contract <- Vendor adapter
~~~

~This principle does not mean an interface for every class.
Use it where there is a change of vendor, testing requirement or ownership boundary.
### 2. DRY — Don't Repeat Yourself

DRY says don't turn a single knowledge and rule into multiple independent sources.
The goal is not to remove any textual similarity.
Two similar validations may be different rules from two actors.
Connecting them creates an unjustified dependency.
Conversely, the same tax rule replicated in a separate API and batch job will sooner or later become inconsistent.
Before extracting the common function, ask: Do the two versions express the same rule?
Do they change at the same time?
Should the output/error be the same?
If only the syntax structure is similar, keep the duplication until common knowledge is clear.
### 3. YAGNI — You Aren't Gonna Need It

Don't build a feature for a possible but unproven need.
Prospective functionality has costs to build, test, secure, document, and support, and may never be used.
Make the design evolvable, but don't impose plugin framework and multi-layer abstraction for vague assumption.
YAGNI is not an excuse to deny security, audit, privacy, data compliance or legal requirements.
These are real current needs.
Irreversible decisions and data migration may also require early anticipation.
### 4. Law of Demeter

A unit must communicate with its close associates, not know the deep chain of internal structure.
If the term customer.address.city is repeated in several places in the domain, the structure of the objects is leaked to the caller.
A domain API like shipping_destination() can hold meaning.
Demeter's law is not "any point of access is prohibited".
Many interface methods can also create boilerplate.
The problem is that the caller is dependent on details that he does not have the right to own.
### 5. Tell, Don't Ask — Tell, don't ask

When object owns state and invariant, give it operation instead of reading state, decide outside and setter.

~~~python
## Better: the owner validates the transition
order.cancel(reason, now)

## Fragile: the caller reads the state and makes the decision
if order.state != "shipped":
    order.state = \"cancelled\"
~~~

This principle does not prohibit all queries. report and view can read data.
The problem is when several callers implement the state change rule separately.
### 6. Hollywood Principle 
- Give control to the frameThe "we call you" rule says that the framework or coordinator is in control of the flow of control, and the component is called via a hook or contract.
Example: the framework hands over the request to the injected handler.
The handler should not control the server cycle itself.
This method makes extension point and inversion of control possible, but makes the execution flow less obvious.
Clear trace, log and naming are required.
Dependency Injection alone is not the complete Hollywood Principle.
The main focus is on call control.
### 7. Composition over Inheritance

Combining behavior from small components instead of building deep hierarchies facilitates independent change and collaboration of multiple capabilities.
The order can have a shipping policy and a discount policy.
Do not create multiple classes to combine customer, campaign and destination types.
Inheritance is appropriate when the subtype actually preserves the base convention.
Composition is not free either: wiring, collaborators and cooperation arrangements must be maintained.
If a behavior is simple and stable, no additional interface and strategy are needed.
### 8. Encapsulate What Varies

Isolate the part that is likely to change differently from the other parts.
Find this possibility from recent changes, domain rules, multiple client requirements or vendor dependency.
Abstraction based solely on "maybe one day" is usually speculative.
Example: the tax rate for countries changes independently.
Calculation of subtotal may be fixed.
We separate the rate policy but do not divide the invoice orchestration into ten interfaces.
### 9. Program to Abstractions

The consumer depends on a contract that expresses its needs, not a concrete class or an external SDK.
This idea is close to DIP, but the emphasis is on selecting the point of use: the use case only requires the authorize capability, not all of the vendor's operations.
The abstraction should preserve the meaning and translate the failure mode.
If the API still emits the vendor type and exception, the consumer is still bound to details.
Do not create an interface for each concrete class.
Keep it for the boundary of change, testing or a few real implementations.
### 10. How to weigh the principles together?
The principles are sometimes tense:
- DRY vs. coupling: Merging two similar concepts may impose any change on both.
- OCP against simplicity: extension point complicates the code more than necessary.
- Abstraction against direct call: replaceable contract has wiring cost.
- Composition versus inheritance: more flexibility can create many collaborators.
- SRP against fragmentation: independent boundary is useful, very small class may be just code transfer.
Decision order: Determine the pressure for change.
Make the smallest design.
Add boundary test.
Monitor the cost of the next change.
Form the abstraction when the evidence is sufficient.
Register short ADR for costly decisions.
### 11. Comprehensive practice

In a hypothetical checkout:
1. Find two duplicate rules and determine if they are the same knowledge (DRY).
2. Replace an ambiguous Boolean with a meaningful operation or type when the rule needs an explicit name.
3. Encapsulate the order transfer state (Tell, Don't Ask).
4. Decide whether discounts need a strategy or a switch is enough (OCP/YAGNI).
5. Separate the payment contract from the SDK (DIP/abstraction).
6. Record when you remove or extend this separation.
## 12. Quiz with explained answers

1. **Does DRY mean combining every pair of similar-looking code blocks?**
   **Answer:** No. Combine code when the blocks represent the same knowledge and are likely to change for the same reason. Similar syntax alone does not prove that they should share an abstraction.

2. **Which SOLID principle protects a consumer from methods it does not need?**
   **Answer:** The Interface Segregation Principle. Split a contract around coherent consumer roles when a broad interface forces clients to depend on unrelated operations.

3. **Should every `switch` be replaced to follow the Open-Closed Principle?**
   **Answer:** No. A stable, small decision may be simpler as a `switch`. Add an extension point when a real, recurring axis of change justifies its extra indirection and maintenance.

4. **What is wrong when a subtype throws `NotImplementedError` for a promised base operation?**
   **Answer:** It may violate the Liskov Substitution Principle because callers that rely on the base contract cannot safely use the subtype.

5. **How does Dependency Inversion isolate a use case from a payment SDK?**
   **Answer:** The use case depends on a small payment contract that expresses its own needs. An infrastructure adapter implements that contract and translates SDK requests, responses, and failures.

6. **What does Tell, Don't Ask recommend?**
   **Answer:** Prefer asking an object to perform an operation that owns a rule over reading its state and making the state-changing decision elsewhere. Queries are still valid when a caller genuinely needs information.

7. **Is one interface with 18 methods always worse than 18 one-method interfaces?**
   **Answer:** Neither count is the goal. Design a contract around real, coherent consumer roles; avoid both unrelated methods and needless fragmentation.

8. **Does YAGNI justify removing a current payment audit requirement?**
   **Answer:** No. YAGNI cautions against speculative features. Current business, security, or legal requirements still need to be met.

9. **Is the Law of Demeter measured by counting dots in a line of code?**
   **Answer:** No. It is a design prompt to limit unnecessary knowledge of internal collaborators. A numeric dot rule can flag code for review, but it does not prove that a design is wrong.

10. **When may composition be unnecessary?**
   **Answer:** When there is no real behavioral variation or boundary to protect and the extra objects and wiring cost more than the flexibility they provide.
## Resources
### Persian

- [GoFarsi; SOLID in Go](https://book.gofarsi.ir/chapter-9/solid-principle-in-golang/) — Persian explanation of SOLID with the Go language angle.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — tutorial description of SOLID, GRASP, design and refactoring smells.
- [Persian design patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian list of patterns and a summary of each problem.
### English

- [Refactoring.Guru; SOLID principles](https://refactoring.guru/design-patterns/solid-principles) — definition and example of each SOLID principle.
- [Martin Fowler; Is Design Dead?](https://martinfowler.com/articles/designDead.html) — Evolutionary Design and the Cost of Early Decisions.
## Summary

Apply design principles to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-04)

</div>
