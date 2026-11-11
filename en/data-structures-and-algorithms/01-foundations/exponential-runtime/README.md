# Exponential Time — O(cⁿ)

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../README.md) · Prerequisite: powers, recursion trees, and combinations  
> Language: English · [Read this lesson in Persian](../../../../fa/data-structures-and-algorithms/01-foundations/exponential-runtime/README.md)

## Prerequisites and mental model

In exponential time, adding one unit to `n` multiplies the amount of work by a constant `c > 1`. Brute-force enumeration of all subsets has `2ⁿ` states, so a small increase in input size can cause a large increase in work.

## The idea from first principles

If every search state creates `c` branches and the search depth is `n`, the number of leaves is approximately `cⁿ`. For `T(n) = 2T(n−1) + O(1)`, the solution is `Θ(2ⁿ)`. But `2T(n/2)` is not exponential: the subproblem size is halved at every level.

An invariant says what a partial state represents. Memoization can merge states that represent the same subproblem, reducing repeated work when overlap exists.

## Step-by-step examples

A simple recursive Fibonacci implementation makes overlapping calls and has exponential running time. Subset enumeration makes an include/exclude choice for every item, giving `2ⁿ` subsets. Memoizing Fibonacci values reduces repeated computation to `O(n)` time and `O(n)` storage.

Specify the problem's output contract: enumerating every subset is inherently expensive if every result must be returned.

## Worked growth estimate

There are `1,024` subsets when `n = 10`, about `1,048,576` when `n = 20`, and about `1.07 billion` when `n = 30`. Even a small constant factor becomes prohibitive quickly.

For a trace, draw the first few levels of the search tree and mark when two branches reach the same subproblem.

## Why the bound holds

Count the states at each level of the search tree. If branching repeats and no pruning or memoization eliminates states, a geometric sum gives exponential work. When states overlap, caching can combine repeated computations; correctness requires the cache key to contain all state information relevant to the result.

## Time and space analysis

Any fixed polynomial eventually grows more slowly than `cⁿ`. Dynamic programming may reduce an exponential recursive tree when it has repeated subproblems, but the number of distinct states can itself still be exponential.

## Practical use

Exact solutions to NP-hard problems such as subset sum, SAT, and scheduling can have exponential worst cases. Practical solvers use approximation, heuristics, pruning, or problem-specific structure. A hard worst case does not mean every real input takes equally long.

## Common mistakes and edge cases

- Solve the recurrence instead of guessing from the visible recursion depth.
- Pruning may speed up typical inputs without improving the worst-case bound.
- Memoization helps only when subproblems repeat and the state space is manageable.
- Check `n = 0`, `n = 1`, and the largest allowed input before enumerating states.

## Step-by-step exercises

1. Count the subsets of a 15-element set.
2. Draw the recursive-call tree for naive Fibonacci at `n = 5`.
3. Which repeated calls does memoization eliminate?

For each exercise, build a baseline, count states and add an edge case. Trace a small input and check the result independently.

## Comprehensive quiz with explained answers

1. **How many subsets does an `n`-element set have?** `2ⁿ`, because every element can be either included or excluded.
2. **Why is the growth dangerous?** A small increase in input size multiplies the number of states.
3. **What is the growth of naive recursive Fibonacci?** Exponential, commonly bounded by roughly `φⁿ` (and by `O(2ⁿ)`).
4. **Does dynamic programming always eliminate exponential growth?** No. It removes repeated work, but the number of distinct states may still be exponential.
5. **Does pruning change the worst-case bound?** Not necessarily; it can improve many runs while leaving an exponential worst case.

## Recall checklist

Explain the branching factor, trace a small search tree, name a repeated subproblem, and state what memoization changes. If the recurrence is unclear, write the number and size of recursive calls explicitly.

## Further reading and references

- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — recursion, dynamic programming, and computational complexity.
- [CP-Algorithms — Introduction to Dynamic Programming](https://cp-algorithms.com/dynamic_programming/intro-to-dp.html) — state spaces and memoization.
- [OpenDSA — Algorithm Analysis Chapter](https://opendsa-server.cs.vt.edu/ODSA/Books/pubbook/odsa-all-0013bb43-a12f-4ab3-9b86-73b317f1e37e/fall-2017/Public_1092017/html/AnalChap.html) — asymptotic analysis methods.
- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — growth-rate categories and cost models.
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can derive the number of states from the branching choices.
- [ ] I can distinguish recursive depth from total calls.
- [ ] I can explain when memoization helps.
- [ ] I have completed the exercises and reviewed my results.
