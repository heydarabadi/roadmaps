# Big-O: An Asymptotic Upper Bound

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../readme.en.md) · Prerequisite: cost functions, `n`, and asymptotic notation  
> Language: English · [Read this lesson in Persian](readme.md)

## Prerequisites and mental model

Big-O is an upper bound on growth, not an exact running time. It says that as input grows, the cost is eventually no more than a constant multiple of a comparison function `g`. In engineering conversations people often use Big-O for worst-case cost, but the notation itself does not specify worst case. State the case separately.

## The idea from first principles

`f(n) ∈ O(g(n))` if positive constants `c` and `n₀` exist such that, for every `n ≥ n₀`, `0 ≤ f(n) ≤ c·g(n)`. `O(n)` is a set of functions, not an exact equation with `n`. If `f(n) = Θ(n)`, then `f(n) ∈ O(n²)` is also true, but it is a looser, less useful bound.

An invariant is a statement that must stay true during an algorithm. Writing one before implementation supports the correctness proof and helps expose boundary bugs.

## How to derive a bound

Count the relevant operations and identify the dominant term. A loop with `n` iterations and constant work per iteration is `O(n)`; two nested `n`-iteration loops are `O(n²)`; merge sort is `Θ(n log n)`. Sequential sections add their costs, and the faster-growing term dominates: `O(n² + n) = O(n²)`.

Specify the input/output contract as well: define empty input, duplicate values, missing elements, and full-capacity behavior.

## Worked example

A linear search makes at most `n` comparisons, so its worst-case time is `O(n)`. Binary search takes `O(log n)` comparisons; because `log n ≤ n` for sufficiently large `n`, binary search is also in `O(n)`. But `Θ(log n)` is a much tighter and more informative statement.

For a manual trace, record the step, index or pointer, active range, state change, and reason. This is especially helpful for in-place and divide-and-conquer algorithms.

## Correctness of the claim

An upper bound must apply to the cost function for a clearly specified case. If the case or input parameters are omitted, the claim is ambiguous. For example, describe dynamic-array append as amortized `O(1)` and hash lookup as expected/average `O(1)` under stated assumptions.

A full algorithm proof commonly shows initialization, maintenance, and termination of an invariant. For a complexity claim, separately justify that the operation count stays below the chosen bound for all sufficiently large inputs in the specified case.

## Time and space analysis

Common growth classes include `O(1)`, `O(log n)`, `O(n)`, `O(n log n)`, `O(n²)`, and `O(2ⁿ)`. Report time and auxiliary space separately. Big-O is not seconds, a latency guarantee, or a benchmark result.

## Practical use and trade-offs

Use upper bounds for capacity planning and comparing how algorithms scale. An unpredictable worst-case input can cause a long latency tail in a service, so include the case and input distribution in the analysis. Ask which operations dominate, whether order matters, and what memory, worst-case latency, or thread-safety constraints apply.

## Common mistakes and edge cases

- Do not read O(g) as “exactly g operations.”
- Worst case is not part of the mathematical definition of O.
- Keep independent input sizes, such as `n` and `m`, in `O(n + m)`.
- Large constants can matter for small inputs.
- Check empty input, singleton input, duplicates, missing targets, value limits, and integer overflow in indexing/capacity.

## Step-by-step exercises

1. Give Big-O and Θ bounds for `3n² + 7n + 4`.
2. Explain why a Θ(n) function is also in O(n²).
3. State separate average-case and worst-case claims for a hash-table lookup.

First write a simple correct answer, then analyze the cost and add an edge case. Trace a small input and compare the result with an independently worked answer.

## Comprehensive quiz with explained answers

1. **What does Big-O mean?** An asymptotic upper bound up to a constant factor for all sufficiently large inputs.
2. **Is every O bound tight?** No. It may be loose; Θ expresses matching upper and lower growth bounds.
3. **Is `O(log n)` also `O(n)`?** Yes, for sufficiently large `n`, though the linear bound gives less information.
4. **Does O itself imply worst case?** No. The analyzed case must be stated separately.
5. **What is dynamic-array append's cost?** Amortized `O(1)` across a sequence of appends; an individual resize can take `O(n)`.

## Recall checklist

Explain the idea, assumptions, invariant, trace, complexity, an edge case, and a practical use without looking. If you can write notation but cannot explain why the bound holds or what it omits, revisit the analysis and pitfalls.

## Further reading and references

- [NIST Dictionary — Big-O notation](https://xlinux.nist.gov/dads/HTML/bigOnotation.html) — formal definition and motivation.
- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — cost models and input-dependent performance.
- [MIT 6.006 — Recitation 1: Asymptotic Complexity](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/ce8348ec64dce3841ced6a9d0c9e48f2_MIT6_006F11_rec01.pdf) — worked bounds and algorithm analysis.
- [OpenDSA — Asymptotic Analysis and Upper Bounds](https://opendsa-server.cs.vt.edu/ODSA/Books/vt/cs3114/spring-2021/CSCI271/html/AnalAsymptotic.html) — upper-bound notation and examples.
- [Persian supplementary course — Data Structures and Algorithms](https://cs-um.github.io/docs/mandatory/Data-Structures/).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can state the assumptions without memorizing the wording.
- [ ] I can trace a small example and construct an edge case.
- [ ] I can explain the complexity and trade-off.
- [ ] I have solved the exercises without looking at the answers and reviewed the result.
