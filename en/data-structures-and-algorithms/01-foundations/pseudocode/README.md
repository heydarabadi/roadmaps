# Pseudocode

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../README.md) · Prerequisite: inputs/outputs, conditions, loops, and functions  
> Language: English · [Read this lesson in Persian](../../../../fa/data-structures-and-algorithms/01-foundations/pseudocode/README.md)

## Prerequisites and mental model

Pseudocode expresses an algorithm's logic without depending on a programming language's syntax. Good pseudocode is precise, finite, traceable, and detailed enough to implement. It should not hide ambiguity such as “sort the array” unless the sorting operation is part of the stated problem.

## The idea from first principles

Use meaningful names, explicit assignment, `if/else`, bounded loops, and returns. State index ranges, empty-input behavior, duplicate policy, and failure results. Add complexity notes beside the relevant operations. A pseudocode representation is still an algorithm and needs a correctness argument.

An invariant is a statement that remains true throughout the algorithm. Write it before coding so you can reason about boundary cases and termination.

## Step-by-step example: lower bound

~~~text
lo ← 0
hi ← n
while lo < hi:
    mid ← lo + floor((hi − lo) / 2)
    if A[mid] < x:
        lo ← mid + 1
    else:
        hi ← mid
return lo
~~~

This returns `lower_bound`, the first position whose value is at least `x`; check `lo < n` and `A[lo] = x` separately to test whether `x` exists.

## Worked trace

For `[1,3,3,7]` and `x = 3`, begin with `[0,4)`. `mid=2` and `A[2]=3`, so set `hi=2`. On `[0,2)`, `mid=1` and the value is equal, so set `hi=1`. On `[0,1)`, `mid=0` and `A[0]<3`, so set `lo=1`. The result is index 1, the first occurrence.

For a manual trace, record each bound, active interval, state change, and reason.

## Why the algorithm is correct

Before each iteration, the required boundary remains in `[lo, hi]`, and all removed positions on the left contain values below `x`. Each step strictly shrinks the interval. At termination, `lo` is the first index with `A[lo] ≥ x`, or `n` if no such index exists.

## Time and space analysis

Pseudocode does not establish complexity automatically. Count iterations and work per line. Every library operation needs a defined cost and behavior. The notation should translate consistently into the selected language. This binary search takes `O(log n)` time and `O(1)` auxiliary space.

## Practical use

Pseudocode is useful in design reviews, interviews, teaching, and collaboration across teams that use different programming languages. It lets reviewers discuss the algorithm before syntax choices.

## Common mistakes and edge cases

- Ambiguous names such as `i` and `j` can obscure their roles.
- State whether intervals are inclusive or half-open.
- Avoid prose so vague that it cannot be implemented.
- Include a termination condition and define division/comparison semantics.
- Specify behavior for empty arrays and duplicate keys.

## Step-by-step exercises

1. Write insertion sort in pseudocode and state its invariant.
2. Add the empty-array case to the binary-search contract.
3. Translate a pseudocode algorithm into your language and list semantic differences.

First write a correct baseline, analyze it, and add an edge case. Trace a small input and compare the result with an independently derived expectation.

## Comprehensive quiz with explained answers

1. **What is the purpose of pseudocode?** It keeps attention on algorithm logic independently of a language's syntax.
2. **What must be unambiguous?** Loop bounds, indices, input/output behavior, and edge cases.
3. **What does the binary-search example return?** `lower_bound`, the first index with `A[i] ≥ x`.
4. **Does pseudocode determine complexity automatically?** No; count loops, calls, and operation costs.
5. **Name a dangerous ambiguity.** Undefined interval convention or duplicate-key policy.

## Recall checklist

Explain the contract, write bounded pseudocode, state an invariant, trace an example, and count its work. If two programmers could implement different behaviors from your pseudocode, make the contract more precise.

## Further reading and references

- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — algorithm design and reasoning.
- [OpenDSA — Algorithm Analysis Chapter](https://opendsa-server.cs.vt.edu/ODSA/Books/pubbook/odsa-all-0013bb43-a12f-4ab3-9b86-73b317f1e37e/fall-2017/Public_1092017/html/AnalChap.html) — algorithm-analysis methods.
- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — expressing and analyzing operations.
- [CP-Algorithms — Binary Search](https://cp-algorithms.com/num_methods/binary_search.html) — precise interval variants and invariants.
- [Persian supplementary course — Data Structures and Algorithms](https://cs-um.github.io/docs/mandatory/Data-Structures/).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can write pseudocode with explicit loop and interval boundaries.
- [ ] I can state an invariant and termination condition.
- [ ] I can translate the logic while preserving semantics.
- [ ] I have completed the exercises and reviewed the edge cases.
