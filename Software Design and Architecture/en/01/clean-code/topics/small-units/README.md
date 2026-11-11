<div dir="ltr" align="left">

# Keep Functions, Classes, and Files Cohesive

> **Language:** [Read the Persian edition](../../../../../01/clean-code/topics/small-units/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Identify when a function, class, or file has too many unrelated responsibilities; split behavior around a meaningful boundary; and avoid treating a fixed line count as a measure of quality.

## Size is not the goal

“Small” does not mean a fixed number of lines. A useful unit has a clear purpose, keeps related behavior together, and hides details its callers do not need. A function that validates input, calculates a price, writes to a database, sends email, and generates a PDF may be doing several jobs. A long function that tells one coherent story may still be easy to follow.

For each proposed split, ask:

- Does the extracted behavior have a clear name and contract?
- Does it have a reason to change or test independently?
- Does the split hide irrelevant details from its caller?
- Does it preserve ownership of state and side effects?
- Will the wiring and navigation cost more than the clarity it adds?

```python
def create_invoice(order, tax_policy, repository):
    invoice = calculate_invoice(order, tax_policy)
    repository.save(invoice)
    return invoice
```

This example is useful only if calculation and persistence are meaningful responsibilities with clear contracts. Do not move hidden global state into another function and call the result a separation.

## Practice

Pick a large function. List its decisions, side effects, and reasons for change. Draw a boundary around one cohesive operation, then write a direct test for it. If the extracted unit only passes data through, reconsider whether the split helps.

## Quiz with answers

1. **Must every function be shorter than a fixed number of lines?**
   **Answer:** No. Evaluate purpose, cohesion, abstraction level, side effects, branching, and testability.

2. **When is an extraction useful?**
   **Answer:** When it gives a coherent operation a clear name or makes an independent behavior easier to test or change.

3. **What can go wrong when code is split too aggressively?**
   **Answer:** More wiring and indirection can make the full behavior harder to follow, and state ownership may become less clear.

## Further reading

- [Martin Fowler: Refactoring](https://martinfowler.com/books/refactoring.html)
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
