# Constant Time — O(1)

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../README.md) · Prerequisite: loops, indexed access, and function growth  
> Language: English · [Read this lesson in Persian](../../../../fa/data-structures-and-algorithms/01-foundations/constant-runtime/README.md)

## Prerequisites and mental model

`O(1)` says that the operation count being analyzed stays bounded by a constant as `n` grows. The constant could be 1 or 1,000; Big-O omits the factor, but it still matters to practical latency.

## The idea from first principles

An operation is constant-time only under a stated model and when its work truly does not grow with `n`. Array access by a known index is usually `O(1)` because the address can be calculated. Hash-table lookup is usually average/expected `O(1)`, but collisions can make a worst-case search `O(n)`.

An invariant is a statement that remains true throughout an algorithm. Use it to distinguish an operation that is genuinely constant from one that first searches for its target.

## Step-by-step analysis

Reading `A[k]`, incrementing a counter, or swapping two fixed-size values takes a constant number of primitive operations in the usual RAM model. If the index must first be found by scanning, analyze that setup separately. A constant number of statements can still contain a loop or a call whose cost depends on `n`.

Define the input/output contract, including behavior for an empty structure, missing values, duplicates, and capacity limits.

## Worked comparison

Reading the last array element as `A[n−1]` is `O(1)` once its index is known. Scanning from the beginning until the last element is reached takes `O(n)`. Both might be described informally as “getting the last item,” but they use different operations.

For manual traces, note each index or pointer, the active region, each state change, and its reason.

## Why the bound holds

To claim constant time, show that the number of operations is independent of `n`. A loop through a collision chain or a dynamic-array copy proportional to `n` is not worst-case `O(1)`. An individual dynamic-array append can take `O(n)` during a resize, even though a sequence of appends is amortized `O(1)` per append.

The algorithm's correctness and its cost claim are separate: prove the operation returns the right value, then show how many steps it uses.

## Time and space analysis

Constant time does not imply constant space, and constant space does not imply constant time. State whether a hash-table result is average/expected or worst case. The amortized bound for append applies over a sequence of operations; it is not a claim that every individual append has the same cost.

## Practical use

Typical `O(1)` operations include indexed array lookup, stack top, queue endpoints, and heap peek. Real-time systems may care more about a worst-case guarantee than an average constant-time result.

## Common mistakes and edge cases

- Do not equate constant time with “instantaneous” or one instruction.
- `contains(x)` on an unsorted list is not constant-time.
- Do not report hash lookup as worst-case `O(1)` without a guarantee.
- Dynamic-array append is amortized `O(1)`, with occasional `O(n)` resize.
- Distinguish a known index from the work required to discover it.

## Step-by-step exercises

1. Compare indexed access with searching for the same value.
2. Which dynamic-array operations are amortized `O(1)`?
3. Why can two `O(1)` operations have very different wall-clock times?

For each exercise, write the simplest correct answer, analyze the operation, and add an edge case. Trace a small input and check the result independently.

## Comprehensive quiz with explained answers

1. **What does `O(1)` mean?** The operation count is bounded independently of input size, up to a constant.
2. **Does it mean one operation?** No. It may be any fixed number of operations.
3. **Does a hash table guarantee worst-case `O(1)` lookup?** Usually not; the common claim is average or expected time under suitable assumptions.
4. **Is every append individually `O(1)`?** No. Resizing may take `O(n)`; amortized append cost is `O(1)` over a sequence.
5. **What is the usual cost of array access by index?** `O(1)` in the standard random-access model.

## Recall checklist

Explain the model, assumptions, trace, cost, edge cases, and a practical operation without looking. If your argument relies only on “the code is short,” count the actual work instead.

## Further reading and references

- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — cost models and growth-rate examples.
- [Princeton Algorithms — Elementary Data Structures](https://algs4.cs.princeton.edu/13stacks/) — constant-time stack operations and their implementations.
- [NIST Dictionary — Big-O notation](https://xlinux.nist.gov/dads/HTML/bigOnotation.html) — formal growth-bound definition.
- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — algorithm analysis foundations.
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can explain the operation and its assumptions.
- [ ] I can trace it and identify an edge case.
- [ ] I can distinguish average, worst-case, and amortized costs.
- [ ] I have solved and reviewed the exercises independently.
