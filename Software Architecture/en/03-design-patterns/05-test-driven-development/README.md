# Test-Driven Development (TDD)

## Learning goals

- Practice the Red-Green-Refactor feedback loop.
- Choose test boundaries and doubles that preserve confidence.
- Relate architecture seams to testability and deployment risk.

## Core idea

TDD uses a short cycle: a failing test for required behavior, the minimum code to make it pass, and refactoring while preserving behavior. TDD shapes design through fast feedback; it does not replace integration, contract, security, performance, or user testing.

## Red–Green–Refactor

1. Choose a small, observable behavior.
2. Write a test that fails for a clear reason.
3. Add the smallest implementation that makes it pass.
4. Refactor duplication and naming after the test is green.
5. Keep the fast test suite independent and reliable.

Test the behavior visible from the capability’s boundary, not private class structure. Tests that mock implementation details can break during a harmless refactor.

## From unit to production: test layers

- **Unit:** quickly tests a small rule or component, generally without external dependencies.
- **Integration:** tests a real connection between components, such as repository/database or adapter/provider sandbox.
- **Contract:** verifies schema and behavior between producer and consumer without running the entire system.
- **End-to-end:** exercises a valuable user journey through external boundaries; keep the set small enough to maintain.
- **Performance, resilience, and security:** test properties that unit tests cannot establish.

TDD does not mean “unit tests only.” A discount calculation suits unit tests; payment-callback idempotency needs database integration and duplicate-message tests; checkout latency needs load tests.

## One complete Red–Green–Refactor cycle

**Behavior:** a customer may receive up to a 20% coupon discount, but the amount cannot fall below the minimum permitted price.

- **Red:** write a test for a 30% discount and observe the expected failure.
- **Green:** implement only the discount cap.
- **Refactor:** improve names and the policy boundary, then rerun tests.
- **Expand behavior:** define expired coupons, invalid currency, and mutually exclusive coupons separately.

Treat tests as readable business examples. Inputs, conditions, and results should be clear in the test name or arrange/act/assert structure. If the test requires private implementation details to make sense, review the boundary.

## Worked example: shipping-cost calculation

Specify three cases: free shipping, an order below the threshold, and an out-of-area destination. Implement the pure rule first, then test the rate-service connection with a contract or integration test.

~~~text
test: amount >= threshold -> shipping cost is zero
test: amount below threshold -> cost is calculated by region
test: unknown region -> understandable domain error
~~~

## TDD and architecture

Fast domain tests make internal change cheaper. Contract tests detect consumer breakage from an API change. Architecture tests can check forbidden dependencies. But tests cannot magically repair a bad boundary; architecture still needs observation and redesign.

## Common pitfalls

- Testing every getter and setter without behavioral value.
- Adding abstractions only to make mocking easier.
- Accepting tests that pass only with one implementation detail.
- Having only unit tests and assuming real integration works.
- Allowing slow, flaky tests that teams learn to ignore.

## Self-check quiz

1. **What is the purpose of Red?** Show that the new test actually captures the behavior and fails before implementation.
2. **Why implement the minimum first?** It avoids speculative capability and keeps feedback short.
3. **How do unit and contract tests differ?** Unit tests check limited logic; contract tests check agreement between provider and consumer.
4. **Is TDD appropriate for every part of a system?** It often helps with rule-based logic; UI discovery and unfamiliar technology also benefit from prototypes and experiments.
5. **What makes a test resilient to refactoring?** It focuses on externally observable behavior rather than private implementation.

## Exercise

Write five behavioral tests for a coupon validator. Convert one to a property-based or table-driven test and explain why boundaries matter.

### Sample answer

Test that the coupon is rejected before its start and after expiry; accepted at its valid start; accepted at the exact minimum amount but rejected one unit below; not usable by another tenant; and not applied beyond its concurrent usage limit. A property: the final price is never greater than the pre-discount price and never negative. Boundary tests make inclusivity and amount/time cutoffs explicit.

## Further reading

- Persian: [Software Design & Architecture roadmap](https://roadmap.sh/pdfs/roadmaps/software-design-architecture.pdf), [Agile software engineering notes](https://mehrdadghobadi.com/lessons/agile-software-engineering)
- English: [Martin Fowler: Test-Driven Development](https://martinfowler.com/bliki/TestDrivenDevelopment.html), [Google Testing Blog](https://testing.googleblog.com/), [Google Testing: Test Sizes](https://testing.googleblog.com/2010/12/test-sizes.html), [Microsoft testing guidance](https://learn.microsoft.com/en-us/dotnet/core/testing/)
