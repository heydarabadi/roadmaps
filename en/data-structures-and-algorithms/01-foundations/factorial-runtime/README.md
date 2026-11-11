# Factorial Time — O(n!)

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../README.md) · Prerequisite: permutations, multiplication, and backtracking  
> Language: English · [Read this lesson in Persian](../../../../fa/data-structures-and-algorithms/01-foundations/factorial-runtime/README.md)

## Prerequisites and mental model

When an algorithm considers every ordering of `n` items, it may examine `n!` possibilities: `n` choices for the first position, `n−1` for the second, and so on down to one. Factorial growth is faster than `cⁿ` for any fixed `c` once `n` is large enough.

## The idea from first principles

`n! = n(n−1)…1`. Stirling's approximation is `n! ≈ √(2πn)(n/e)ⁿ`. If the algorithm must output every permutation of length `n`, it needs at least `Ω(n·n!)` time simply to write the output.

An invariant for permutation backtracking can state that at depth `i`, exactly `i` distinct elements have been selected and form a valid prefix.

## Step-by-step pattern

At depth `i`, choose an unused element, mark it used, recurse, then unmark it on return. Each leaf of the recursion tree is one complete ordering. If values contain duplicates, skip equivalent choices or use multiplicities to avoid emitting the same permutation repeatedly.

State whether the task asks for every permutation or only the best one; the output requirement changes the lower bound.

## Worked growth estimate

There are `24` permutations of four distinct elements. `10!` is `3,628,800`; writing ten positions for each output requires over 36 million output positions. Brute-force traveling-salesperson search considers permutations, although symmetry and bounds can reduce practical work.

For a manual trace, write the chosen prefix, the unused set, and the state to undo after each branch.

## Why the bound holds

At depth `i`, precisely `i` distinct choices have been made. Undoing the used marker after a leaf restores all valid choices for the next branch. The product of the branch counts is `n!`. Any symmetry reduction must be proved safe so that no required optimum is removed.

## Time and space analysis

Generating all permutations requires `Ω(n·n!)` time if all `n` values in each output are written. Held–Karp's exact dynamic program for traveling salesperson takes `O(n²2ⁿ)` time—better than enumerating `n!` tours, but still exponential.

## Practical use

Full permutation enumeration is useful only for small input, tests, or a brute-force baseline. For larger exact problems, consider subset dynamic programming, branch-and-bound, or approximation when allowed.

## Common mistakes and edge cases

- Separate the cost of exploring a candidate from the cost of writing the required output.
- Duplicate values can create equivalent branches and duplicate outputs.
- Do not use symmetry breaking without proof.
- Check the empty permutation and singleton input, and ensure every recursive choice is undone.

## Step-by-step exercises

1. Compute `6!`.
2. Write a permutation generator for three values and show each undo step.
3. Why is Held–Karp better than `n!` but not polynomial-time?

First build a correct baseline, then count possibilities and add an edge case. Trace a small example and independently verify the output set.

## Comprehensive quiz with explained answers

1. **How many permutations are there for `n` distinct items?** `n!`, the product of decreasing choice counts.
2. **Why does factorial eventually outgrow every fixed-base exponential?** Its factors keep increasing, so its growth eventually exceeds `cⁿ` for any constant `c`.
3. **What is the output cost of listing all permutations?** At least `Ω(n·n!)` when each length-`n` permutation is written.
4. **What is a smaller exact method for TSP?** Held–Karp uses `O(n²2ⁿ)` time, still exponential but asymptotically better than `n!` enumeration.
5. **What must backtracking undo?** The selected choice and its used marker so the next branch starts from the correct state.

## Recall checklist

Explain the decreasing number of choices, trace a branch and undo, and distinguish output cost from search cost. If duplicate values exist, explain how equivalent branches are handled.

## Further reading and references

- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — growth classes and counting candidate operations.
- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — recursion, dynamic programming, and computational complexity.
- [CP-Algorithms — Introduction to Dynamic Programming](https://cp-algorithms.com/dynamic_programming/intro-to-dp.html) — state compression and overlapping subproblems.
- [OpenDSA — Algorithm Analysis Chapter](https://opendsa-server.cs.vt.edu/ODSA/Books/pubbook/odsa-all-0013bb43-a12f-4ab3-9b86-73b317f1e37e/fall-2017/Public_1092017/html/AnalChap.html) — recurrence and growth analysis.
- [Persian supplementary course — Data Structures and Algorithms](https://cs-um.github.io/docs/mandatory/Data-Structures/).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can derive `n!` from the number of choices.
- [ ] I can trace a generator and its undo operations.
- [ ] I can account for the cost of writing all outputs.
- [ ] I have completed and reviewed the exercises independently.
