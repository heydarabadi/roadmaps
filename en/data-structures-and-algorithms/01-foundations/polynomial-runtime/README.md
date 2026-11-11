# Polynomial Time — O(nᵏ)

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../README.md) · Prerequisite: nested loops and exponentiation  
> Language: English · [Read this lesson in Persian](../../../../fa/data-structures-and-algorithms/01-foundations/polynomial-runtime/README.md)

## Prerequisites and mental model

Polynomial time is a fixed power of `n`, or a sum of such terms. Examples include `n`, `n²`, `n³`, and generally `nᵏ` for constant `k`. Polynomial-time algorithms are often more scalable than exponential-time algorithms, but degree and constants still matter.

## The idea from first principles

Two independent loops that each range over `n` inputs give `Θ(n²)` work; three such loops often give `Θ(n³)`. If the exponent `k` is fixed, `nᵏ` is polynomial. If `k` is part of the input, the behavior may instead be exponential. `n¹⁰⁰` is polynomial by definition, but not practically fast.

An invariant tracks what a loop or dynamic-programming state represents. It helps distinguish the algorithm's correctness from the cost of its nested computations.

## Step-by-step counting

Count the number of candidate pairs for a two-loop search (`O(n²)`), triples for a three-loop search (`O(n³)`), or states times transitions for dynamic programming. For example, `n` states with `O(n)` work per state give `O(n²)` total work.

Define the input/output contract and range limits before choosing a polynomial algorithm; a high degree can exceed the budget even when the input is valid.

## Worked scale comparison

At `n = 100`, `n² = 10,000` and `n³ = 1,000,000`. At `n = 10,000`, `n²` is already 100 million. Polynomial growth can still be too large, especially for a high degree.

For a manual trace, count iterations at each loop level or list the dynamic-programming states and transition work.

## Why the bound holds

Do not convert a loop's nesting directly into a power unless its bounds really scale as assumed. Dependent bounds may require a sum, such as `1 + 2 + … + n`, which simplifies to `Θ(n²)`. Prove the loop invariant separately from the iteration count.

## Time and space analysis

For fixed `a < b`, `nᵃ` grows more slowly than `nᵇ`. For every fixed `ε > 0`, `n log n` eventually grows more slowly than `n^(1+ε)`. Keep multiple input parameters separate rather than silently treating `n` and `m` as equal.

Knapsack's `O(nW)` dynamic program is pseudo-polynomial: it is polynomial in numeric capacity `W`, but `W` may require only `log W` bits to encode.

## Practical use

Many exact algorithms are polynomial, including sorting, shortest-path algorithms, and dynamic programs. Whether they fit depends on input sizes, degree, constants, memory, and operation cost.

## Common mistakes and edge cases

- “Polynomial” does not automatically mean fast; `n¹⁰` can be unusable.
- A pseudo-polynomial algorithm may be exponential in the number of bits used to encode a numeric value.
- Sequential loops add; nested loops multiply only when their iteration counts justify it.
- Check input limits, integer overflow, and the number of states as well as time.

## Step-by-step exercises

1. Estimate `n²` and `n³` at `n = 500`.
2. Count the iterations for `i = 1..n` and `j = 1..i`.
3. Explain the difference between polynomial and pseudo-polynomial knapsack time.

For each exercise, establish a simple correct count, analyze it, and check edge cases. Trace a small input before generalizing.

## Comprehensive quiz with explained answers

1. **When is `nᵏ` polynomial?** When `k` is a fixed constant independent of the input.
2. **Which grows faster, `n³` or `n²`?** `n³`, because its degree is higher.
3. **Is every polynomial algorithm practical?** No; a high degree or large constant can make it infeasible.
4. **What is a pseudo-polynomial example?** The `O(nW)` 0/1-knapsack dynamic program.
5. **What do several consecutive `n`-length loops cost?** `Θ(n)` when they are sequential, because the work adds rather than multiplies.

## Recall checklist

Explain what makes an exponent fixed, trace a nested loop, compare degrees, and identify pseudo-polynomial dependence. If you infer a bound only from the number of loops, check each loop's actual range.

## Further reading and references

- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — growth classes and cost models.
- [OpenDSA — Asymptotic Analysis](https://opendsa-server.cs.vt.edu/ODSA/Books/vt/cs3114/spring-2021/CSCI271/html/AnalAsymptotic.html) — asymptotic notation and examples.
- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — analyzing loops, recurrences, and algorithms.
- [CP-Algorithms — Introduction to Dynamic Programming](https://cp-algorithms.com/dynamic_programming/intro-to-dp.html) — states, transitions, and complexity counting.
- [Persian supplementary course — Data Structures and Algorithms](https://cs-um.github.io/docs/mandatory/Data-Structures/).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can determine whether an exponent is fixed.
- [ ] I can count dependent and independent loops correctly.
- [ ] I can explain pseudo-polynomial growth.
- [ ] I have completed and reviewed the exercises independently.
