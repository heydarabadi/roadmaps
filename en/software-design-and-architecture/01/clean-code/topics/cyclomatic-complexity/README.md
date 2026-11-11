<div dir="ltr" align="left">

# Cyclomatic Complexity

> **Language:** [Read the Persian edition](../../../../../../fa/software-design-and-architecture/01/clean-code/topics/cyclomatic-complexity/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Explain what cyclomatic complexity estimates, use it as a signal to inspect branching and test cases, and avoid treating a numeric score as a design goal by itself.

## What the metric estimates

Cyclomatic complexity estimates the number of linearly independent paths through a function’s control-flow graph. A straight-line function starts at one path; conditional branches and some compound conditions add paths. One common graph formula is `M = E - N + 2P`, where `E` is edges, `N` is nodes, and `P` is connected components.

More paths can mean more behavior to understand and test. The metric does not tell you whether the branches represent clear domain rules, whether each path is reachable, or whether the function should be split. Use it to find code worth reviewing, not as an architecture target.

## Example: order cancellation

An order-cancellation policy may depend on payment state, shipment state, and a deadline. First name those domain conditions and decide where each rule belongs. A guard clause can clarify an early rejection; a policy object or decision table can help when the rules vary independently. Creating a class for each boolean condition can lower a score without reducing the real complexity.

```python
def can_cancel(status: str, now: int, deadline: int) -> bool:
    if status == "shipped":
        return False
    if status != "pending":
        return False
    if now > deadline:
        return False
    return True
```

This function has a straight-through success path and three decision points, so the basic cyclomatic estimate is `1 + 3 = 4`. That estimate suggests cases to inspect: shipped, another non-pending state, expired deadline, and a valid pending order. It does not decide whether the policy should be extracted or whether these are all the business cases.

## Practice

Choose a function with several branches. Draw or list the paths in domain language, identify which combinations are valid, and write tests for meaningful boundaries. Then decide whether a guard clause, a table, or a separate policy makes the behavior easier to review. Compare the design, not only the metric.

## Quiz with answers

1. **What does cyclomatic complexity estimate?**
   **Answer:** The number of linearly independent paths through a function’s control-flow graph.

2. **Does a low score prove that a function is easy to understand?**
   **Answer:** No. A short or low-branching function can still use unclear names, hidden state, or a confusing contract.

3. **Should every decision branch become a separate class?**
   **Answer:** No. Extract a policy when it is cohesive or changes independently. Do not add types just to reduce the metric.

4. **How can the metric guide testing?**
   **Answer:** It can point to a function with many paths that may need clearer rules and tests for meaningful branches and boundaries.

## Further reading

- [McCabe: A Complexity Measure](https://doi.org/10.1109/TSE.1976.233837) — The original paper introducing cyclomatic complexity.
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
