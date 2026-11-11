# Big-Omega — An Asymptotic Lower Bound

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../readme.en.md) · Prerequisite: Big-O and cost functions  
> Language: English · [Read this lesson in Persian](readme.md)

## Prerequisites and mental model

`Ω(g(n))` says that a cost cannot asymptotically be smaller than a positive constant multiple of `g(n)`. The claim may concern one algorithm's cost or a lower bound that applies to every algorithm solving a problem; state which claim you mean.

## The idea from first principles

`f(n) ∈ Ω(g(n))` if a positive constant `c` and threshold `n₀` exist such that `f(n) ≥ c·g(n)` for all `n ≥ n₀`. A lower bound is not synonymous with an algorithm's best case. It is a mathematical bound on a specified function under specified assumptions.

An invariant helps prove the algorithm's correctness, while a lower-bound argument must show why the required work cannot be avoided under the chosen computation model.

## Step-by-step lower-bound reasoning

To sum `n` arbitrary input values exactly, an algorithm must inspect every value in the general model; therefore the problem requires `Ω(n)` work. A one-pass sum uses `O(n)` time, so the bound is tight: `Θ(n)`. Comparison-based sorting has a decision-tree lower bound of `Ω(n log n)`.

For binary search on a sorted array, finding one of `n+1` insertion positions requires enough comparisons to distinguish among those positions, which needs logarithmically many comparison outcomes.

## Worked example

Suppose a task requires returning an exact aggregate over every input element. If an algorithm skips an arbitrary element, two inputs that differ only at that unseen position can require different outputs. The algorithm cannot distinguish them, so it must inspect all `n` values in the general case.

For a manual proof trace, write what information each operation reveals and what alternatives remain afterward.

## Why the bound applies

A lower bound for a problem must apply to every algorithm in the stated model; a slow example algorithm does not prove the problem itself is hard. State assumptions such as comparison-based operations or random-access input. A non-comparison method such as counting sort does not contradict a comparison-sorting lower bound because it uses additional assumptions about keys.

## Time and space analysis

If an algorithm's upper bound matches a problem's lower bound asymptotically, it is asymptotically optimal in that model. This says nothing about whether constants or memory use can be improved, and a different model may admit another result.

## Practical use

Lower bounds help show that more asymptotic optimization is impossible without changing the model or assumptions. They inform whether engineering effort should target constants, cache behavior, or a different input representation.

## Common mistakes and edge cases

- Do not confuse Ω with best-case complexity; Ω is notation for a lower bound.
- A lower bound on one algorithm is not automatically a lower bound on the problem.
- State the computational model, such as comparison-based sorting.
- Explain why information must be read; do not infer a lower bound from one slow implementation.

## Step-by-step exercises

1. Why does summing `n` arbitrary values require `Ω(n)` input inspections?
2. Is `Ω(n)` a valid best-case bound for linear search? Explain the relevant cost function.
3. Distinguish a problem lower bound from the worst-case cost of one algorithm.

First write a simple argument, then state its model and edge case. Trace two inputs that differ at one uninspected position to test the claim.

## Comprehensive quiz with explained answers

1. **What is the definition of Ω?** A lower bound up to a positive constant factor for sufficiently large inputs.
2. **Is a best case always the same as Ω?** No. Ω is mathematical notation; first specify which cost function is being bounded.
3. **What is the comparison-sorting lower bound?** `Ω(n log n)` comparisons for sorting arbitrary distinct keys in the comparison model.
4. **Why can counting sort be faster?** It uses assumptions about a bounded key domain and is not limited to the comparison model.
5. **What does asymptotic optimality mean?** An algorithm's upper bound matches the problem's lower bound in the same model.

## Recall checklist

Explain what is being bounded, state the model, and show why an algorithm cannot avoid the work. If you only show one slow algorithm, you have not proved a problem lower bound.

## Further reading and references

- [NIST Dictionary — Big-O notation](https://xlinux.nist.gov/dads/HTML/bigOnotation.html) — formal notation context for asymptotic bounds.
- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — cost models and comparisons of algorithm growth.
- [OpenDSA — Asymptotic Analysis Modules](https://opendsa-server.cs.vt.edu/ODSA/StandaloneModules/20260527013510/html/index.html) — upper, lower, and Θ bounds.
- [MIT 6.006 — Recitation 1: Asymptotic Complexity](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/ce8348ec64dce3841ced6a9d0c9e48f2_MIT6_006F11_rec01.pdf) — worked asymptotic analysis.
- [Persian supplementary course — Data Structures and Algorithms](https://cs-um.github.io/docs/mandatory/Data-Structures/).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can state the object and model for a lower-bound proof.
- [ ] I can distinguish a problem bound from one algorithm's cost.
- [ ] I can explain the comparison-sorting assumption.
- [ ] I have completed and reviewed the exercises independently.
