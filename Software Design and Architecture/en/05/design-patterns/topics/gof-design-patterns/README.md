<div dir="ltr" align="left">

# GoF Design Patterns
> **Language:** [Persian edition](../../../../../05/design-patterns/topics/gof-design-patterns/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location in the roadmap:** [Design Patterns](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The GoF catalog contains 23 object-oriented patterns in three families: creation, structure, and behavior.
Each pattern gives a name to the problem and trade-off.
Modern implementations may be simplified with closures, generics, or combinations.
## Practical example

In a checkout module, Strategy can select a discount policy, Adapter can isolate a payment provider, and Builder can validate a complex report configuration.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Design Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Each pattern adds a level of abstraction, indirection, or comprehension cost.
- **Revision:** First write the problem and its forces, then choose the name of the model; "Using 23 patterns" is not the goal.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: The GoF catalog contains 23 object-oriented patterns in three families: creation, structure, and behavior.
Each pattern gives a name to the problem and trade-off.
Modern implementations may be simplified with closures, generics, or combinations.
2. **What decision do you make in the example below and why?**   
- Suggested answer: In a checkout module, Strategy can select a discount policy, Adapter can isolate a payment provider, and Builder can validate a complex report configuration.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Each pattern adds a level of abstraction, indirection, or comprehension cost.
4. **Which common error do you check before merging the code?**   
- Suggested answer: first write the problem and its forces, then choose the name of the model; "Using 23 patterns" is not the goal.
## Complete lesson: design patterns
### Pattern learning method

Pattern is the name of a recurring solution to a problem in a specific context.
No ready code and no requirement to build more classes.
For each pattern, learn four things: the problem/forces, the structure of the solution, the positive consequences, the cost, and the conditions in which it should not be used.
Before choosing, write the problem with its needs and limitations.
Then choose the smallest structure that limits change or risk and design the test.
If the pattern only adds names, has no real implementations, or hides flow, keep the simpler option.
### GoF family overview

The 23 GoF patterns are grouped by what they vary:
- **Creational:** [Abstract Factory](patterns/abstract-factory/README.md), [Builder](patterns/builder/README.md), [Factory Method](patterns/factory-method/README.md), [Prototype](patterns/prototype/README.md), and [Singleton](patterns/singleton/README.md).
- **Structural:** [Adapter](patterns/adapter/README.md), [Bridge](patterns/bridge/README.md), [Composite](patterns/composite/README.md), [Decorator](patterns/decorator/README.md), [Facade](patterns/facade/README.md), [Flyweight](patterns/flyweight/README.md), and [Proxy](patterns/proxy/README.md).
- **Behavioral:** [Chain of Responsibility](patterns/chain-of-responsibility/README.md), [Command](patterns/command/README.md), [Interpreter](patterns/interpreter/README.md), [Iterator](patterns/iterator/README.md), [Mediator](patterns/mediator/README.md), [Memento](patterns/memento/README.md), [Observer](patterns/observer/README.md), [State](patterns/state/README.md), [Strategy](patterns/strategy/README.md), [Template Method](patterns/template-method/README.md), and [Visitor](patterns/visitor/README.md).
Use a pattern when its problem and forces match the system.
The integrated lesson contains the full family tables and comparison; every pattern page also includes its intent, example, trade-off, quiz, and family context.
### 4. Checkout example

~~~text
Checkout use case
  -> DiscountPolicy: calculate the discount (Strategy)
  -> PaymentAuthorizer: domain payment contract
       <- VendorAdapter: translates to the vendor SDK (Adapter)
  -> PaymentRequested command: queued when needed (Command)
  -> PaymentCaptured event: receipt or analytics reaction (Observer)
~~~

This list does not mean to use all patterns.
First, a discount function and an adapter may be enough.
When algorithm selection, retry, fan-out, or external failure becomes a real issue, add structure incrementally.
In messaging, include duplicate delivery and final compatibility in the design.
### 5. POSA and architectural patterns

POSA stands for Pattern-Oriented Software Architecture.
Broadly speaking, GoF patterns focus on object and class collaborations, while POSA patterns can describe subsystem structure, concurrency, network communication, and runtime flow.
When studying an architectural pattern, ask:
- What type of component and connector does it have?
- How does control and data flow?
- Which quality attribute does the pattern support, such as concurrency, fault isolation, or variability?
- What is the assumption about process, network, failure and deployment?
- What operational cost does it create and is there a simpler option?
POSA is a collection of pattern volumes rather than one fixed catalog with a universal taxonomy.
Compare each pattern with the system's actual constraints.
See the [POSA topic notes](../posa-patterns/README.md) for the related architecture-level patterns.
### 6. Implement patterns idiomatically in modern languages

Learn the concept of pattern and match the implementation with the idiom of the language.
Function type can be Strategy; middleware to build the wrapper chain.
Generics shorten some Visitor structures.
Dependency injection solves the need for Singleton.
Copying the syntax of 1994 classes is not always the best way today.
### 7. Pitfalls and review criteria
- Do not choose the template before writing the problem.
- Do not use the number of patterns as a quality criterion.
- Don't assume every if or switch is a smell.
- Calculate the cost of abstraction, wiring, retry, trace and versioning.
- Don't create a pattern for an unproven need.
- If the behavior and failure cannot be traced from the call site, add visibility or simplify the structure.
For an important decision, record four lines: problem; selected pattern; simpler alternative.
Consequence and test.
Example: "Two discount algorithms are active.
Strategy makes checkout not dependent on rate details.
The cost is implementation and wiring; "Contract test checks both."
### 8. Comprehensive practice

Design a checkout that has two types of discounts, two portals and issuing receipts.
For each candidate pattern step, write the reason, simpler option, failure case, and test.
In the first version, only implement patterns that solve these known needs.
### 9. Answered quiz
1. What is a design pattern?  
- Answer: A named solution to the recurring problem and forces along with consequences and trade-offs.
2. What is the difference between Adapter and Decorator?   
- Answer: Adapter converts the contract.
Decorator usually keeps the same convention and adds behavior.
3. What is the difference between Strategy and Template Method?   
- Answer: Strategy replaces the algorithm with composition.
Template Method uses inheritance for fixed algorithm steps.
4. Why is singleton usually risky?   
- **Answer:** Global access and shared state hide dependencies, making tests, concurrency, and lifecycle control harder.
5. Which kind of change does Visitor make easier, and which kind does it make harder?   
- **Answer:** Adding an operation over a stable set of element types is easier; adding a new element type requires changes to the visitors.
6. Why can Observer make debugging harder?   
- **Answer:** The publisher does not reveal the full downstream work.
Subscriber order, failures, and retries need separate tracing.
7. What level of problem does POSA typically see?   
- **Answer:** POSA focuses on architecture and subsystem structures, including collaboration, concurrency, and communication.
The catalog varies by volume.
8. When do you remove the pattern?   
- **Answer:** When the variation the pattern was meant to isolate no longer exists, or its learning and maintenance costs exceed its benefit.
## Resources
### Persian

- [Persian Design Patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian summaries of GoF patterns and several architectural patterns.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian textbook resource for GoF, GRASP and architectural patterns.
### English

- [Refactoring.Guru; Design Patterns](https://refactoring.guru/design-patterns) — List of GoF patterns and multilingual examples.
- [Patterns.Guru; GoF catalog](https://patterns.guru/) — A catalog and discussion of pattern intent and selection costs.
- [Wiley; POSA Volume 3 excerpt](https://catalogimages.wiley.com/images/db/pdf/9780470845257.excerpt.pdf) — An example of architecture and concurrency patterns in the POSA suite.
## Complete catalog of 23 GoF patterns

In each file, the intention of the pattern, examples, limitations and tests are given.
Choose patterns based on problem strength.
The list below is a study guide.
- [Abstract Factory](patterns/abstract-factory/README.md) (creational) — Creates a family of related objects without consumer dependencies on specified classes.
- [Builder](patterns/builder/README.md) (creational) — separates the step-by-step construction of a complex object from the final representation.
- [Factory Method](patterns/factory-method/README.md) (creational) — leaves the creation of the product to the constructor operation or subtype so that the caller is not tied to the concrete type.
- [Prototype](patterns/prototype/README.md) (creational) — Copies the configured object so that it is not necessary to recreate or know the concrete type.
- [Singleton](patterns/singleton/README.md) (creational) — ensures the existence of a shared instance and usually provides global access.
- [Adapter](patterns/adapter/README.md) (structural) — Converts an incompatible interface to the convention expected by the consumer.
- [Bridge](patterns/bridge/README.md) (structural) — separates abstraction from implementation so that two independent dimensions can be changed.
- [Composite](patterns/composite/README.md) (structural) — Processes single objects and returned sets through the same joint convention.
- [Decorator](patterns/decorator/README.md) (structural) — Adds behavior to an object with composable wrappers without overloading subclasses.
- [Facade](patterns/facade/README.md) (structural) — provides a simple interface in front of a complex subsystem.
- [Flyweight](patterns/flyweight/README.md) (structural) — shares common and immutable data between many instances to reduce memory consumption.
- [Proxy](patterns/proxy/README.md) (structural) — Provides a controlled proxy in front of the object to handle access, lazy loading, or remote communication.
- [Chain of Responsibility](patterns/chain-of-responsibility/README.md) (behavioral) — the request passes through a chain of handlers so that one processes it or hands it over to the next.
- [Command](patterns/command/README.md) (behavioral) — Converts the request to an object/message to enable queuing, scheduling, retry or undo.
- [Interpreter](patterns/interpreter/README.md) (behavioral) — Converts simple domain grammar into structure and evaluation rules.
- [Iterator](patterns/iterator/README.md) (behavioral) — Traversal separates elements from the collection's internal structure.
- [Mediator](patterns/mediator/README.md) (behavioral) — Centralizes multiple interactions in a coordinator so that components do not refer directly to each other.
- [Memento](patterns/memento/README.md) (behavioral) — Saves a snapshot of the state for restoration, without revealing its internal structure.
- [Observer](patterns/observer/README.md) (behavioral) — informs multiple subscribers about the topic change; Fan-out is separated from direct dependency.
- [State](patterns/state/README.md) (behavioral) — leaves the behavior to the internal state so that allowed transitions and behavioral differences are focused.
- [Strategy](patterns/strategy/README.md) (behavioral) — isolates the replaceable algorithm behind the contract and leaves its selection to composition/configuration.
- [Template Method](patterns/template-method/README.md) (behavioral) — Keeps the skeleton of the algorithm in the base and leaves some steps to the subclass.
- [Visitor](patterns/visitor/README.md) (behavioral) — separates operations from element structures when element types are stable and new operations are frequent.
## Summary

Apply GoF design patterns to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-05)

</div>
