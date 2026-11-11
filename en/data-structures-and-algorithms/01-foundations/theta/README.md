# Big-Theta — A Tight Asymptotic Bound

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../README.md) · Prerequisite: Big-O, Big-Omega, and cost functions  
> Language: English · [Read this lesson in Persian](../../../../fa/data-structures-and-algorithms/01-foundations/theta/README.md)

## Prerequisites and mental model

`Θ(g(n))` is a tight asymptotic growth bound: the cost is bounded above and below by constant multiples of `g(n)` for sufficiently large `n`. If `T(n) = Θ(n log n)`, its growth is of that order; this does not mean it is exactly equal to `n log n`.

## The idea from first principles

There are positive constants `c₁`, `c₂`, and `n₀` such that for every `n ≥ n₀`:

`c₁g(n) ≤ T(n) ≤ c₂g(n)`.

Equivalently, for nonnegative functions, `Θ(g) = O(g) ∩ Ω(g)`. An invariant is a separate correctness tool: it records what must stay true through the algorithm's steps.

## How to establish a Θ bound

For `T(n) = 4n² + 10n + 3`, choose an upper constant large enough that `T(n) ≤ Cn²` for sufficiently large `n`; the quadratic term also supplies a lower bound. Thus `T(n) = Θ(n²)`. For linear search, specify the case: worst-case cost is `Θ(n)`, while best-case cost is `Θ(1)`.

Define the input and case explicitly; one sample input cannot prove a tight bound for all sufficiently large input sizes.

## Worked comparison

For `T(n) = n log n + 7n`, divide by `n log n`:

`T(n)/(n log n) = 1 + 7/log n`,

which approaches 1 as `n` grows. The function is therefore `Θ(n log n)`.

For a manual trace, record the step, active input region, and cost being counted. Keep correctness state and cost accounting conceptually separate.

## Why the bound is tight

Both inequalities must hold for all sufficiently large `n`, with the correct quantifiers. A single example does not establish Θ. When analyzing an algorithm, name the cost function and whether it is best, average, or worst case.

## Time and space analysis

Θ is useful when a tight bound is known. It does not say the cost equals `g` exactly: `2n` and `1000n` can both be in `Θ(n)`. Those constants still matter in benchmarks.

## Practical use

Tight bounds are useful for merge sort (`Θ(n log n)`), a full traversal (`Θ(n)`), and tree operations stated in terms of height. In interviews, “O(n)” often informally means a worst-case upper bound; use Θ only when you can justify both sides.

## Common mistakes and edge cases

- Worst-case `O(n)` does not imply `Θ(n)` without a lower bound.
- `Θ(n²)` and `O(n²)` make different claims.
- Check zero/small input separately when the asymptotic definition starts only after `n₀`.
- Do not confuse a tight asymptotic bound with a precise runtime in seconds.

## Step-by-step exercises

1. Prove a Θ bound for `3n³ − 8n` for sufficiently large positive `n`.
2. Give tight best- and worst-case bounds for linear search.
3. Is `T(n) = n²` in `Θ(n³)` for positive `n`? Check both inequalities.

First derive a simple count, then prove the upper and lower bounds and add an edge case. Trace a small example to make the function concrete.

## Comprehensive quiz with explained answers

1. **What does Θ combine?** An O upper bound and an Ω lower bound of the same asymptotic order.
2. **Why is one sample not enough?** The definition must hold for every sufficiently large input size, not just one input.
3. **What is `4n² + 10n + 3` in Θ notation?** `Θ(n²)`; the quadratic term dominates above and below for large `n`.
4. **Does `O(n)` necessarily mean `Θ(n)`?** No. O alone supplies only an upper bound.
5. **Are the constants exact?** No. Any suitable positive constants that make both inequalities hold beyond `n₀` are sufficient.

## Recall checklist

Explain both inequalities, identify the analyzed case, and show why a sample is not a proof. If you only establish an upper bound, do not claim Θ.

## Further reading and references

- [NIST Dictionary — Big-O notation](https://xlinux.nist.gov/dads/HTML/bigOnotation.html) — formal asymptotic upper-bound definition.
- [OpenDSA — Asymptotic Analysis and Upper Bounds](https://opendsa-server.cs.vt.edu/ODSA/Books/vt/cs3114/spring-2021/CSCI271/html/AnalAsymptotic.html) — upper bounds and analysis examples.
- [OpenDSA — Asymptotic Analysis Modules](https://opendsa-server.cs.vt.edu/ODSA/StandaloneModules/20260527013510/html/index.html) — upper, lower, and Θ notation.
- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — growth models and cost functions.
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can prove both sides of a tight bound.
- [ ] I can state the input case being analyzed.
- [ ] I can distinguish Θ from an upper bound alone.
- [ ] I have completed the exercises and reviewed the proof.
