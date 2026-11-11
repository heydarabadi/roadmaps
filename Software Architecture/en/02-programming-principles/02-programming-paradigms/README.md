# Object-Oriented, Functional, Reactive, and Actor Paradigms

## Learning goals

Recognize programming paradigms as ways to organize state, behavior, and concurrency, and choose them to fit a problem.

## Core concepts

- **Object-oriented programming (OOP):** groups data and behavior behind encapsulation and contracts. Inheritance is one tool, not the goal.
- **Functional programming:** favors pure functions, immutable data, composition, and controlled side effects. This simplifies reasoning and testing, while I/O and state still exist at boundaries.
- **Reactive programming:** responds to data or event streams while accounting for time, producer pressure, cancellation, and errors. A reactive UI does not make the whole system a reactive architecture.
- **Actor model:** each actor owns its state and communicates with other actors through messages. This reduces shared-lock coordination, but message loss, order, duplication, and recovery still need design.

Paradigms are not mutually exclusive. A web application can use objects in its domain, pure functions for business rules, a reactive UI, and message-oriented workers. Architecture should make state ownership and side-effect boundaries explicit.

## State, effects, and concurrency

**State** is information that changes between executions. When multiple parts of a program access shared mutable state, the system must control ordering and races. OOP encapsulates state in an object with invariants; functional programming favors immutable values and constructs a new result; the Actor model assigns state to a message-driven owner. These are different ways to control the same problem.

An **effect** depends on the outside world: querying a database, reading the clock, calling HTTP, writing a file, or publishing a message. If a pricing rule directly reads time, network, and database, its tests depend on all of them. Make the rule a function with explicit inputs, test it independently, and test the external adapter separately.

Reactive programming often handles streams that change over time, such as search suggestions while typing. If a user searches for “shoes” and then “men’s shoes,” the first response may arrive late and overwrite the newer result. Cancellation, sequence numbers, backpressure, and error channels belong in the design.

In an Actor system, messages need contracts: Are messages durable? Is order preserved for a key? Can a message arrive again after a crash? How is it deduplicated? Without those answers, adopting actors changes the program’s shape but does not solve distributed-systems failure.

## Worked example: order pricing

The discount rule can be a pure function: order and campaign rules in, discount amount out. Fetching a shipping rate is an effect and belongs behind an adapter. An “order priced” event can notify the invoice consumer. The separation allows the rule to be tested without network or database access.

~~~text
pure:
  discount = calculate_discount(order, campaign_rules)

effectful boundary:
  inventory = await inventory_client.get(order.items)
  await message_bus.publish(OrderPriced(order.id, discount))
~~~

## Choosing a model

| Approach | Main benefit | Cost or risk |
| --- | --- | --- |
| OOP | Encapsulates behavior with invariants and clear ownership | Fragile inheritance hierarchies |
| Functional | Makes side effects explicit and testing easier | Different concepts and libraries to learn |
| Reactive | Organizes asynchronous or pushed data streams | Debugging, backpressure, and error-flow complexity |
| Actor | State ownership and message-based isolation | Distribution and message-protocol complexity |

Examples: use a pure function for a discount rule; an object or aggregate for order state; a reactive stream for live price updates; an idempotent message consumer or Actor for independent telemetry events.

## Common pitfalls

- Equating OOP with extensive inheritance.
- Calling a system stateless when its state is merely hidden.
- Building a reactive chain for simple request-response work.
- Assuming one message is delivered exactly once without an end-to-end guarantee and idempotency.

## Self-check quiz

1. **Why is a pure function easy to test?** Its output depends only on inputs; the test does not need network, clock, or external state.
2. **Does functional programming mean no side effects?** No. It keeps effects at controlled boundaries so much of the logic can remain independent.
3. **How do actors reduce races?** Each actor owns its state and handles interactions through messages; delivery and distributed failures remain.
4. **What does reactive programming solve, and what does it not solve?** It organizes asynchronous flows and changing data; it does not determine product requirements, consistency, or data ownership.
5. **What must be designed when using actors across nodes?** Persistence, message delivery, ordering, duplication, supervision, and recovery.

## Exercise

Separate shipping-cost calculation from a REST service. Which part is pure? Which part is the adapter? What tests are needed when shipping rates change?

### Sample answer

The calculation takes weight, destination, and tariff as inputs and returns an amount without network calls or mutation. The REST adapter retrieves rates and maps timeout or provider errors to internal error types. Test zero and negative weight, tariff boundaries, expired tariffs, provider timeout, and malformed responses. Unit-test the pricing rule and use contract/integration tests for the adapter.

## Further reading

- Persian: [Software architecture fundamentals](https://www.alirostami.com/software-architecture/), [Persian Event-Driven Architecture notes](https://github.com/gloonch/eventdrivenfarsi)
- English: [Reactive Manifesto](https://www.reactivemanifesto.org/), [Akka typed actors](https://doc.akka.io/libraries/akka-core/current/typed/actors.html), [Microsoft .NET design guidelines](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/), [Martin Fowler: Event-Driven](https://martinfowler.com/articles/201701-event-driven.html), [Software Design & Architecture roadmap](https://roadmap.sh/pdfs/roadmaps/software-design-architecture.pdf)
