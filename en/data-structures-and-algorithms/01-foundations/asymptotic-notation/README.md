# Asymptotic Notation

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../README.md) · Prerequisite: functions, growth rates, and sums/products of expressions  
> Language: English · [Read this lesson in Persian](../../../../fa/data-structures-and-algorithms/01-foundations/asymptotic-notation/README.md)

## Prerequisites and mental model

Asymptotic notation summarizes how a cost function grows for large inputs. It describes a growth rate, not seconds or the speed of a particular computer. First express the cost in terms of an input size such as `n`, then select the bound you need.

## The idea from first principles

`f ∈ O(g)` says that `f` is eventually bounded above by a constant multiple of `g`; `f ∈ Ω(g)` gives a lower bound; and `f ∈ Θ(g)` gives both. For nonnegative cost functions, `f ∈ Θ(g)` means there are positive constants `c₁` and `c₂` such that `c₁g(n) ≤ f(n) ≤ c₂g(n)` for all sufficiently large `n`. The definitions of `O` and `Ω` also use positive constants and a threshold `n₀`.

An invariant is a statement that must remain true throughout an algorithm. Writing it before implementation helps with correctness proofs and exposes boundary mistakes.

## Step-by-step analysis

For a polynomial, keep the dominant term: `3n² + 5n + 8 ∈ Θ(n²)`. For nested loops, count the actual iterations before simplifying. Logarithms with constant bases differ by a constant factor, so `log₂ n` and `log₁₀ n` have the same Θ growth. Keep independent input sizes separate: `O(n + m)` must not be collapsed to `O(n)` unless a relationship between `n` and `m` is known.

Define the input/output contract precisely in an implementation: specify empty input, duplicates, missing values, and exhausted capacity.

## Worked comparison

Suppose algorithm A costs `100n` and algorithm B costs `n²`. For `n = 10`, B could still be faster because its constant factor is smaller. For sufficiently large inputs, however, the quadratic term outgrows the linear one. Asymptotic analysis describes long-run growth; benchmarking is needed to find a practical crossover point.

For manual traces, make a table with columns for step, index/pointer, active region, state change, and reason. This prevents skipped reasoning in in-place and divide-and-conquer algorithms.

## Why the analysis is valid

When simplifying a function, constants and lower-order terms are discarded only for growth-rate purposes. The replacement function must still be a valid bound for sufficiently large `n`. For negative or oscillating functions, state the generalized definition and whether absolute values are used.

A correctness proof usually has three parts: initialization (the invariant is true before the first step), maintenance (each step preserves it), and termination (the stop condition plus the invariant implies the desired result). If one part is unclear, the algorithm is not fully understood yet.

## Time and space growth

A common order from slower to faster growth is:

`1 ≺ log n ≺ n ≺ n log n ≺ n² ≺ n³ ≺ cⁿ (c > 1) ≺ n!`.

Compare two functions using their ratio or logarithms. For fixed `a` and `c > 1`, `nᵃ` eventually grows more slowly than `cⁿ`, though constants still affect practical input sizes.

When stating Big-O, define the input variable, name the case being analyzed (best, average, or worst), and separate auxiliary space from the input itself. A growth class is not a time in seconds; cache behavior, allocation, and implementation constants also matter.

## Practical use and trade-offs

Asymptotic analysis helps compare scalability, estimate capacity, and reason about query counts. In distributed systems, network latency, contention, and cache behavior may dominate computation, so complete the model with a representative workload.

Before choosing a structure, ask which operations are frequent, whether order matters, how large the input is, and whether memory, worst-case latency, or thread safety is constrained. A good structure can still be a poor fit for the wrong workload.

## Common mistakes and edge cases

- Big-O does not automatically mean worst case; state the case explicitly.
- Θ is a tight bound, not another spelling of a loose O bound.
- The base of a logarithm is usually irrelevant to Θ, but the number of logarithmic factors is not.
- Time and space complexity are independent measures.
- Check empty input, one element, all-equal values, a missing target, minimum/maximum values, and large input. Integer overflow in indices or capacity calculations is language-dependent.

## Step-by-step exercises

1. Classify `8n³ + 2n log n + 100`.
2. Compare `n log n` with `n^1.1` using a limit or ratio.
3. Give an example where `O(n²)` is correct for a Θ(n) algorithm but provides little information.

For every exercise, first write a simple correct answer, then analyze its complexity and add an edge case. Trace at least one small input by hand and compare it with an independently derived expected result.

## Comprehensive quiz with explained answers

Try each question before reading its explanation.

1. **What kind of bound does O provide?** An asymptotic upper bound, up to a constant factor, for sufficiently large inputs.
2. **What does Ω express?** An asymptotic lower bound.
3. **What makes a Θ bound tight?** The function has both an O upper bound and an Ω lower bound of the same growth order.
4. **Why are constant factors omitted?** To summarize asymptotic growth, not to claim exact running time.
5. **What changes when the logarithm base changes?** Only a constant factor changes, so its Θ class stays the same.

## Recall checklist

Without looking back, explain the idea, assumptions, invariant, one trace, complexity, an edge case, and a real use in a few minutes. If you can reproduce only notation but not correctness or limitations, revisit the invariant and pitfalls.

## Further reading and references

- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — growth models, input-sensitive costs, and examples.
- [NIST Dictionary — Big-O notation](https://xlinux.nist.gov/dads/HTML/bigOnotation.html) — formal upper-bound definition.
- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — algorithmic thinking and computational complexity.
- [OpenDSA — Asymptotic Analysis and Upper Bounds](https://opendsa-server.cs.vt.edu/ODSA/Books/vt/cs3114/spring-2021/CSCI271/html/AnalAsymptotic.html) — definitions with examples.
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can state the assumptions without memorizing the wording.
- [ ] I can trace a small example and construct an edge case.
- [ ] I can explain complexity and the trade-off.
- [ ] I have solved the exercises without looking at the answers and reviewed my result.
