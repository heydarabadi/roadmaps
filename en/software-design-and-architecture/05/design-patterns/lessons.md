<div dir="ltr" align="left">

# Complete lesson: design patterns
> **Language:** [Persian edition](../../../../fa/software-design-and-architecture/05/design-patterns/lessons.md)
## Pattern learning method

Design patterns name recurring solutions to problems in a particular context.
They are not ready-made code, and they do not require adding classes for their own sake.
For each pattern, study the problem and its forces, the solution structure, the benefits, the costs, and the conditions in which the pattern should not be used.
Before choosing a pattern, write down the problem, requirements, and constraints.
Then select the smallest structure that reduces a real change or risk, and decide how to verify the boundary.
If the pattern only adds names, has no meaningful variation, or hides control flow, keep the simpler design.
## 1. GoF creational patterns

Creational patterns control how clients obtain objects. Use them when construction varies, needs validation, or must produce compatible families; a direct constructor is clearer for a simple value.

| Pattern | Useful fit | Cost or warning |
| --- | --- | --- |
| Abstract Factory | Create compatible families of related products, such as controls for different operating systems. | Adding a product may require changes across every factory. |
| Builder | Construct a complex object step by step when options, validation, or construction order matter. | Adds ceremony for simple objects; do not expose an invalid partial result. |
| Factory Method | Let a creator or subtype choose which product implementation to instantiate. | Can create parallel class hierarchies; a factory function may be simpler. |
| Prototype | Clone a configured object when recreating it is expensive or the concrete type should remain hidden. | Shallow versus deep copying and shared references require care. |
| Singleton | Enforce one shared instance within a defined scope. | Often creates global state, hidden coupling, and lifecycle or test problems. |

## 2. GoF structural patterns

Structural patterns organize objects and classes into larger structures. Choose one only when the relationship or boundary it describes makes a real change easier to control.

| Pattern | Useful fit | Cost or warning |
| --- | --- | --- |
| Adapter | Translate an incompatible interface into the contract a consumer expects. | Preserve error meaning and behavior; a wrapper that only renames methods may add no value. |
| Bridge | Separate an abstraction from an implementation when both dimensions must vary independently. | Adds indirection and two structures to understand. |
| Composite | Treat leaves and trees uniformly through a shared contract. | Appropriate when recursive structure and shared operations are real domain concepts. |
| Decorator | Add behavior by wrapping an object while preserving its contract. | Wrapper ordering, debugging, and dependency construction can become difficult. |
| Facade | Offer a small, task-oriented API over a complex subsystem. | Can become a central object if unrelated workflows accumulate. |
| Flyweight | Share immutable intrinsic state among many objects to reduce memory use. | Separate shared state from per-instance state and measure before adding complexity. |
| Proxy | Control access, lazy loading, caching, or remote access behind a compatible interface. | Do not hide network latency, failure, or security behavior behind a misleadingly local API. |

## 3. GoF behavioral patterns

Behavioral patterns organize collaboration, responsibility, and control flow. Decide who owns the decision, how work moves, and how failures or repeated delivery are handled.

| Pattern | Useful fit | Cost or warning |
| --- | --- | --- |
| Chain of Responsibility | Pass a request through handlers until one accepts it. | Define ordering, termination, and what happens when no handler accepts it. |
| Command | Represent an operation as data so it can be queued, retried, logged, scheduled, or undone. | Idempotency, ordering, serialization, and boilerplate need explicit treatment. |
| Interpreter | Evaluate a small, well-defined domain grammar. | For a substantial language, use a real parser; never evaluate arbitrary user input. |
| Iterator | Traverse a collection without exposing its representation. | Clarify termination, mutation, and concurrency semantics. |
| Mediator | Coordinate several colleagues through one explicit interaction point. | A mediator can become a central object that is hard to change. |
| Memento | Capture and restore an object's state without exposing its internals. | Snapshot size, retention, and compatibility across versions matter. |
| Observer | Notify independent subscribers when a subject changes. | Hidden control flow, ordering, retries, delivery guarantees, and unsubscription need design. |
| State | Give state-dependent behavior and valid transitions explicit owners. | Avoid a class per state when an enum and a small decision are sufficient. |
| Strategy | Select among interchangeable algorithms through composition and a shared contract. | If there is no real variation, the extra abstraction is waste. |
| Template Method | Keep an algorithm's sequence stable while allowing selected steps to vary in subclasses. | Inheritance is fragile when the sequence or variation axes change. |
| Visitor | Add operations over a stable set of element types without changing those elements. | Adding an element type requires updates across visitors. |

### Recognition of similar patterns

Adapter modifies the interface so that two incompatible contracts work together.
Decorator usually preserves the contract and adds behavior.
Proxy controls access or destination.
Factory Method resolves the construction delegation of a type.
Abstract Factory is a family of several related products.
Strategy replaces algorithm with composition.
Template Method modifies the steps of the inherited algorithm.
## 4. Checkout example

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
## 5. POSA and architectural patterns

POSA stands for *Pattern-Oriented Software Architecture*.
GoF patterns mostly describe collaborations among objects and classes.
POSA patterns can describe subsystem structure, concurrency, network communication, and runtime behavior.
When studying an architectural pattern, ask:
- What type of component and connector does it have?
- How does control and data flow?
- Which quality attributes does it support, such as concurrency, fault isolation, or variability?
- What is the assumption about process, network, failure and deployment?
- What operational cost does it create and is there a simpler option?
POSA is a collection of pattern volumes, not one fixed catalog with a universal taxonomy.
Compare each pattern with the actual system constraints.
See the [POSA topic notes](topics/posa-patterns/README.md) for more detail and references.
## 6. Implement patterns idiomatically in modern languages

Learn the problem a pattern solves, then implement it using the language's idioms.
A function value can implement a Strategy; middleware can form a chain of wrappers; generics can simplify some Visitor designs; dependency injection can provide a controlled shared service without a global Singleton.
Copying class-heavy examples from older pattern books is not always the clearest modern implementation.
## 7. Pitfalls and review criteria
- Do not choose the template before writing the problem.
- Do not use the number of patterns as a quality criterion.
- Don't assume every if or switch is a smell.
- Calculate the cost of abstraction, wiring, retry, trace and versioning.
- Don't create a pattern for an unproven need.
- If the behavior and failure cannot be traced from the call site, add visibility or simplify the structure.
For an important design choice, record four items: the problem, the selected pattern, the simpler alternative, and the consequences plus verification.
For example: “Two discount algorithms are active.
Strategy keeps checkout independent of their details; the cost is extra implementation and wiring; a contract test checks both algorithms.”
## 8. Comprehensive practice

Design a checkout that has two types of discounts, two portals and issuing receipts.
For each candidate pattern step, write the reason, simpler option, failure case, and test.
In the first version, only implement patterns that solve these known needs.
## 9. Answered quiz
What is a pattern?   
- **Answer:** A named response to a recurring problem in a context, together with its forces, consequences, and trade-offs.
2. What is the difference between Adapter and Decorator?   
- **Answer:** An Adapter translates between incompatible contracts; a Decorator preserves the wrapped contract while adding behavior.
3. What is the difference between Strategy and Template Method?   
- **Answer:** Strategy selects an algorithm through composition.
Template Method keeps an algorithm's sequence in a base class and varies selected steps through inheritance.
4. Why can Singleton make a system harder to test and maintain?   
- **Answer:** Global access hides dependencies and shared state, making tests, concurrency, and lifecycle control harder.
5. Which kind of change does Visitor make easier, and which kind does it make harder?   
- **Answer:** Adding an operation over a stable set of element types is easier; adding a new element type requires changes to the visitors.
6. Why can Observer make debugging harder?   
- **Answer:** The publisher does not reveal the complete downstream work.
Subscriber order, failures, and retries need separate tracing.
7. What level of problem does POSA typically see?   
- **Answer:** POSA focuses on architecture and subsystem structures, including component collaboration, concurrency, and communication.
The exact catalog depends on the volume.
8. When do you remove the pattern?   
- **Answer:** When the variation the pattern was meant to isolate no longer exists, or the pattern's learning and maintenance costs exceed its benefit.
## Optional resources
- [Persian Design Patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/)
- [Refactoring.Guru — Design pattern catalog](https://refactoring.guru/design-patterns)
- [Patterns.Guru — GoF patterns in modern languages](https://patterns.guru/)
- [Wiley — POSA Volume 3 excerpt](https://catalogimages.wiley.com/images/db/pdf/9780470845257.excerpt.pdf)
## Further reading

[Curated references for this chapter](../../references.md#chapter-05)

</div>
