# MVC, MVP, MVVM, and Design Patterns

## Learning goals

- Explain how presentation patterns separate view, interaction, and domain behavior.
- Recognize GoF pattern families and their intended design pressures.
- Select a pattern from the problem and explain its costs.

## Core idea

A pattern is a named, reusable design response to a recurring problem. It does not prescribe the exact implementation; adapt it to the framework, data flow, team, and product. MVC, MVP, and MVVM separate presentation from logic and state. GoF catalogs object-oriented patterns; architectural pattern catalogs describe broader system structures.

## UI pattern families

- **MVC:** Model owns data and behavior, View renders, Controller receives input and coordinates a response. Its exact form differs between server-rendered applications and reactive client UIs.
- **MVP:** Presenter owns presentation logic and communicates with a usually simple View through a contract. It can help when the view must be easy to test or mock.
- **MVVM:** ViewModel exposes presentation state and commands. Data binding reduces wiring but can conceal state changes and complicate debugging.

GoF patterns are commonly grouped as creational, structural, and behavioral. Factory, Adapter, Decorator, Composite, Strategy, Observer, and Command are examples. Architectural patterns such as Layered, Hexagonal, Event-Driven, and Microkernel affect system boundaries. Describe the problem before reaching for a pattern name.

## Comparing presentation models

In server-side MVC, a controller may handle an HTTP request and produce HTML. In a client UI, data flow is often event-driven. “MVC” in two frameworks does not necessarily mean the same internal structure.

In MVP, a Presenter decides what should appear and talks to the View through an interface. It helps when the View should be simple and mockable, but the Presenter can become a giant object if it absorbs all domain rules. In MVVM, a ViewModel prepares state and commands; hidden two-way binding can make update flow difficult to follow.

| Need | Possible choice | Check |
| --- | --- | --- |
| HTTP request and response rendering | Server MVC | Keep controllers thin; separate use cases |
| Independent presentation-logic tests | MVP | Clarify interface and state ownership |
| Two-way binding and UI state | MVVM | Understand implicit updates and lifecycle |
| Several UIs independent of domain | Hexagonal / ports and adapters | Keep the domain independent of UI frameworks |

## GoF and architectural patterns

Learn each pattern through the problem it solves: Factory localizes conditional object creation; Adapter maps an incompatible contract; Decorator adds behavior around a contract; Composite treats tree parts and wholes uniformly; Strategy makes an algorithm replaceable; Observer notifies subscribers; Command turns a request into an independent operation or data item.

Patterns at architectural scale include Layered for dependency structure, Microkernel for extensions around a core, Event-Driven to decouple producers and consumers, and Client-Server for request-provider relationships. These can be combined: a layered modular monolith can use events within a boundary.

| Question | Design signal |
| --- | --- |
| What is expected to change? | Choose a pattern that localizes that change |
| Who owns the state? | Make data flow and mutations explicit |
| Which contract stays stable? | Depend on that contract |
| What cost is added? | Count abstraction, indirection, and debugging work |

## Worked example: multiple payment gateways

Adapters map each provider to the internal PaymentGateway contract. Strategy can encapsulate selection by country or card type. A Factory can isolate adapter construction. If there is only one provider and one use case, a factory plus registry may add cost without value.

~~~text
PaymentUseCase -> PaymentGateway
                     |-> GatewayAAdapter -> Provider A
                     |-> GatewayBAdapter -> Provider B
~~~

## Common pitfalls

- Choosing a pattern from a UML diagram before stating the problem.
- Treating MVC as identical across frameworks.
- Nesting Factory, Manager, and Provider abstractions around one implementation.
- Treating GoF patterns as a complete system architecture.
- Designing a generic public API for a hypothetical future.

## Self-check quiz

1. **What does Adapter solve?** It hides or maps an external or incompatible contract behind the interface the system expects.
2. **How do Strategy and Adapter differ?** Strategy selects among algorithms that share a contract; Adapter translates one side’s contract or shape to another.
3. **Why can MVVM help and hurt?** It organizes presentation state and testability, while hidden binding can obscure state flow.
4. **What should happen before introducing a pattern?** Describe the problem, expected change, current cost, and desired outcome; then select the simplest sufficient design.
5. **When is Factory unnecessary?** When construction has no meaningful variation and the abstraction adds no useful boundary.

## Exercise

Model two payment providers behind one contract. Show where adapters live, where provider selection occurs, and which provider errors map to internal errors.

### Sample answer

PaymentGateway defines internal operations such as authorize and refund. ProviderAAdapter and ProviderBAdapter map external models to internal types. Configuration or application policy selects a provider; domain code does not. Timeout, insufficient funds, declined, and unavailable become distinct internal outcomes. Do not leak raw provider exceptions or credentials. Contract tests verify that each adapter preserves the intended meaning.

## Further reading

- Persian: [Software Design & Architecture roadmap](https://roadmap.sh/pdfs/roadmaps/software-design-architecture.pdf), [Software architecture fundamentals](https://www.alirostami.com/software-architecture/)
- English: [Microsoft common web application architectures](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures), [Refactoring.Guru design patterns](https://refactoring.guru/design-patterns), [Martin Fowler: GUI Architectures](https://martinfowler.com/eaaDev/uiArchs.html), [Microsoft architecture patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
