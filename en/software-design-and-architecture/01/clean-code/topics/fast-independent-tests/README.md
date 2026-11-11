<div dir="ltr" align="left">

# Fast, Independent Tests

> **Language:** [Read the Persian edition](../../../../../../fa/software-design-and-architecture/01/clean-code/topics/fast-independent-tests/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Explain why tests should be deterministic and independent of execution order, choose appropriate test boundaries, and keep feedback fast without relying on mocks for every dependency.

## Independence and speed

An independent test gives the same result regardless of which other tests ran before it. It should not depend on leftover database rows, shared mutable state, a real clock, random values, test order, or an unstable network.

Fast feedback makes it practical to run focused tests during development. Different test levels answer different questions:

- A unit test checks a small piece of behavior with controlled inputs.
- An integration test checks a real boundary, such as a database query or transaction.
- An end-to-end test checks a user-visible path through multiple components and is usually slower.

Use enough of each level to cover the system’s risks. A unit test does not prove that a database schema or provider contract works. An end-to-end test does not explain which small rule failed as quickly as a focused test.

## Example: cancellation deadline

Pass the current time into the policy instead of reading the system clock inside it:

```python
def is_expired(expires_at, now):
    return now >= expires_at
```

Test a timestamp before, exactly at, and after the deadline. No sleep is needed. For persistence, an integration test against a temporary database can check that the actual query and transaction behave as intended; a mock cannot establish that contract.

## Trade-offs and practice

Too many end-to-end tests can make feedback slow and fragile. Too many unit tests can encode private implementation details and break during safe refactoring. Build a layered test portfolio and adjust it based on the risks and feedback time that matter to the project.

Find a flaky test. Check shared state, ordering, time, randomness, concurrency, network use, and cleanup. Remove the dependency and run the test both alone and with its suite.

## Quiz with answers

1. **Why should a test be independent?**
   **Answer:** Its result should not depend on test order or residual state, which makes failures repeatable and easier to diagnose.

2. **What does a unit test establish?**
   **Answer:** It provides evidence about the isolated behavior it covers. It does not establish the compatibility of the whole infrastructure.

3. **Why can an integration test still be necessary?**
   **Answer:** It can check the real query, schema, transaction, or provider contract that a unit test using a fake or mock does not exercise.

4. **How should a deadline test handle time?**
   **Answer:** Pass fixed timestamps and test the boundary values. Do not sleep or read the system clock in the policy function.

## Further reading

- [Google Testing Blog: Test Sizes](https://testing.googleblog.com/2010/12/test-sizes.html) — Test categories based on resource use and execution properties.
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
