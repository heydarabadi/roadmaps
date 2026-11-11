# Design Principles and Clean Code

## Learning goals

- Apply cohesion, coupling, encapsulation, and separation of concerns.
- Use SOLID and related principles as diagnostic tools rather than slogans.
- Recognize when abstraction or indirection makes a design harder to change.

## Core idea

Design principles help reveal the cost of dependencies and change; they are not formulas to apply without context. They are useful when they make behavior clearer and change more predictable. Unnecessary abstraction can make a design harder to understand.

## Important principles

- **SOLID:** focused responsibilities, controlled extension, substitutable contracts, small interfaces, and dependency on abstractions. These ideas address object design; they do not replace system-boundary design.
- **DRY:** avoid repeating the same knowledge. Two similar code blocks may encode different business rules and should not be merged prematurely.
- **YAGNI:** do not build hypothetical features in advance; still account for confirmed requirements and costly architectural change.
- **Law of Demeter:** avoid depending on long chains of another object’s internals.
- **Tell, don’t ask:** place behavior with the owner of the data instead of extracting state and deciding elsewhere.
- **Composition over inheritance:** assemble small replaceable parts rather than relying on a deep class hierarchy.
- **Program to an interface:** consumers depend on a contract rather than infrastructure details.
- **High cohesion / low coupling:** keep related responsibilities together and avoid unnecessary effects from changes elsewhere.
- **Separate policy from detail:** business rules should not depend on a framework, database, or UI.

## SOLID through a checkout example

Suppose a Checkout class calculates amounts, validates coupons, calls a payment provider directly, saves orders, and sends email. Every business or technical change may force this class to change. SOLID provides five lenses:

- **Single Responsibility:** a module should have one coherent reason to change. Splitting every method into a class is an overcorrection; group related behavior.
- **Open/Closed:** a new payment provider should not spread provider-specific conditions throughout checkout. A small contract and adapter can localize change; do not build a generic abstraction for imaginary future providers.
- **Liskov Substitution:** a replacement implementation must honor the consumer’s contract. If Provider B always times out or has different validation semantics, substituting it without changing behavior is unsafe.
- **Interface Segregation:** clients should not depend on unused operations. Separate payment and refund contracts may be better than one large interface.
- **Dependency Inversion:** checkout policy should not depend on a concrete provider or database; adapters implement inward-facing contracts. This is about dependency direction, not a requirement to use a dependency-injection container.

## Cohesion and coupling in practice

High cohesion means a module’s parts serve closely related responsibilities. If changing refund policy also requires changes to a page renderer and a report, responsibilities or change boundaries may be mixed. Low coupling means a consumer does not need to know an unstable provider’s private details.

Reducing coupling does not remove all dependencies. APIs, data contracts, and shared domain language still connect systems. Ask which dependency exists, who owns it, and how its contract changes.

## Worked decision: when to add an abstraction

**Current state:** one payment provider is called directly by a use case.

**Confirmed need:** test without network access and track uncertain transaction results.

**Sufficient change:** a small PaymentGateway contract for authorize and status, one real adapter, and one test fake.

**Not needed yet:** general plugin discovery, runtime provider loading, or a multi-tenant registry.

**Review trigger:** a second provider with genuinely different contracts and failure behavior.

This applies “program to an abstraction” without building a framework prematurely.

## Worked example: notifications

Instead of having the order service construct email and SMS requests directly, depend on a NotificationPort. Email and SMS adapters contain provider details. If one business rule truly applies to every channel, sharing it is reasonable. If the policies differ by product, a common function created merely to remove a few similar lines may be worse.

~~~csharp
public interface INotifier
{
    Task SendAsync(Notification message, CancellationToken ct);
}
~~~

| Smell | Question to ask |
| --- | --- |
| A rule change breaks several modules | Is one piece of knowledge scattered? |
| Mocks copy implementation details | Is the contract boundary wrong? |
| An abstraction has one implementation and one consumer | Does it provide value now? |
| One class is responsible for everything | Are the responsibilities driven by different reasons to change? |

## Common pitfalls

- Turning SOLID into “one interface for every class.”
- Overusing DRY until different domain rules are hidden.
- Building an internal framework before a real use case exists.
- Adding an abstraction solely to make mocking possible.

## Self-check quiz

1. **When should similar code not be merged?** When it looks alike but represents different business knowledge or changes at a different rate.
2. **What is the difference between decoupling and eliminating every dependency?** Systems still need contracts and data; the goal is explicit, controllable dependence.
3. **Why can composition be safer than inheritance?** It combines independent behaviors and avoids deep dependence on base-class details.
4. **How can YAGNI coexist with future-aware design?** Plan for likely needs and expensive changes, but do not implement speculative features without evidence.

## Exercise

Split a hypothetical OrderService that handles payments, email, persistence, and discounts into clear responsibilities and contracts. Explain three principles and the cost of your abstractions.

### Sample answer

Separate a use-case coordinator, Order domain, DiscountPolicy, PaymentGateway port, OrderRepository, and email adapter. Keep discount rules in policy/domain code, SQL in a repository adapter, and send post-commit notifications through an outbox. SRP and dependency inversion localize changes; needless interfaces, mappings, and indirection still cost. Explain which independent reason to change and which simpler test each abstraction supports.

## Further reading

- Persian: [Persian SOLID design principles article](https://virgool.io/@m_15490185/آموزش-معماری-نرم-افزار-و-سیستم-دیزاین-solid-design-principle-اصول-solid-o5dj5m7usscd), [Software Design & Architecture roadmap](https://roadmap.sh/pdfs/roadmaps/software-design-architecture.pdf)
- English: [Microsoft: Common web application architectures](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures), [Microsoft design guidelines](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/), [Martin Fowler: Refactoring](https://refactoring.com/), [Robert C. Martin: The Dependency Rule](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
