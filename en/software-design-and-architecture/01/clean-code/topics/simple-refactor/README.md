<div dir="ltr" align="left">

# Simplicity and Continuous Refactoring

> **Language:** [Read the Persian edition](../../../../../../fa/software-design-and-architecture/01/clean-code/topics/simple-refactor/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Explain how refactoring changes structure while preserving behavior, choose a safe sequence of small improvements, and distinguish useful simplicity from speculative design.

## Simplicity is contextual

A simple design makes the current behavior and its rules easy to understand. It is not necessarily the design with the fewest lines or classes. Avoid complexity for requirements that have not been validated, but do not omit a real security, audit, reliability, or product requirement in the name of simplicity.

Refactoring is a structural change that preserves externally observable behavior. A safe workflow is:

1. Identify the behavior and the change pressure.
2. Add or confirm tests for the relevant contract and boundaries.
3. Make one structural change at a time.
4. Run the focused tests and review the diff.
5. Add the feature separately when a new behavior is required.

For example, if two endpoints implement the same discount rule, first compare the rule, rounding, and owner. If they represent the same policy, centralizing the calculation can prevent drift. If the offers have different owners and change for different reasons, a shared function may couple them unnecessarily.

Before refactoring, two call sites might repeat this calculation:

```python
def checkout_total(subtotal_cents: int, discount_percent: int) -> int:
    discount = subtotal_cents * discount_percent // 100
    return subtotal_cents - discount

def refund_quote(subtotal_cents: int, discount_percent: int) -> int:
    discount = subtotal_cents * discount_percent // 100
    return subtotal_cents - discount
```

If both operations truly use the same rule and rounding, extract the calculation without changing its behavior:

```python
def discounted_total(subtotal_cents: int, discount_percent: int) -> int:
    discount = subtotal_cents * discount_percent // 100
    return subtotal_cents - discount

def checkout_total(subtotal_cents: int, discount_percent: int) -> int:
    return discounted_total(subtotal_cents, discount_percent)

def refund_quote(subtotal_cents: int, discount_percent: int) -> int:
    return discounted_total(subtotal_cents, discount_percent)
```

Tests for zero percent, full discount, representative amounts, and rounding boundaries help confirm that this structural change preserves the old contract. If refunds follow a different policy, keep the rules separate even if their current code looks similar.

## Costs and practice

Refactoring takes time and tests can miss behavior. Keep changes focused, use characterization tests when legacy behavior is unclear, and avoid a cleanup that does not reduce a real cost. “Refactor often” is not a requirement that every commit include unrelated cleanup.

Choose one code smell. Record its behavior and a test that protects it. Make three small, behavior-preserving steps, then compare how easy it is to find and change the rule.

## Quiz with answers

1. **What is the difference between refactoring and adding a feature?**
   **Answer:** Refactoring changes internal structure while preserving behavior. A feature changes externally visible behavior and needs its own requirements and tests.

2. **Should similar-looking code always be merged?**
   **Answer:** No. Verify that both copies represent the same rule, owner, and change path before sharing an abstraction.

3. **How can you reduce refactoring risk?**
   **Answer:** Protect observable behavior with tests, make small changes, and review structural changes separately from feature work.

4. **Does simplicity justify omitting a required audit trail?**
   **Answer:** No. Simplicity is judged against validated requirements, including security and operational needs.

## Further reading

- [Martin Fowler: Refactoring](https://martinfowler.com/books/refactoring.html)
- [Martin Fowler: Code Smell](https://martinfowler.com/bliki/CodeSmell.html)
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
