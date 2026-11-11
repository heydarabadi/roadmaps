# How to Estimate Algorithm Complexity

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../readme.en.md) · Prerequisite: loops, functions, recursion, and asymptotic notation  
> Language: English · [Read this lesson in Persian](readme.md)

## Prerequisites and mental model

Before coding, estimate how an algorithm's work grows and whether it can fit the problem's limits. Define the input sizes and count iterations and calls; then simplify the dominant term.

## The idea from first principles

A single loop over `n` items is `Θ(n)`. Two independent loops over sizes `n` and `m` cost `Θ(nm)`. Repeatedly doubling or halving a value takes `Θ(log n)` iterations. A dependent nested loop can perform `n + (n−1) + … + 1 = Θ(n²)` iterations. Sequential sections add their costs; nested work generally multiplies them.

An invariant is a statement that remains true at each algorithm step. Writing it down supports the correctness proof and helps expose edge cases.

## A repeatable estimation procedure

1. Define the input variables, such as `n` elements and `m` edges.
2. Count primitive operations or write a recurrence.
3. Analyze branches for the required best, average, or worst case.
4. Solve the sums or recurrence.
5. Keep the dominant growth term.
6. Include library costs, slicing/copying, sorting, and hash-table assumptions.

Specify input/output behavior too: empty input, duplicates, missing elements, and full-capacity cases should not be left to guesswork.

## Worked examples

In `for i = 1; i < n; i *= 2`, `i` doubles each time. We need `k` iterations until `2ᵏ ≥ n`, so `k = Θ(log n)`. If an inner loop runs `i` times for each outer-loop value `i`, the total is `1 + 2 + … + n = n(n+1)/2 = Θ(n²)`.

For a manual trace, record the step, index or pointer, active range, state change, and reason. This makes nested loops and library calls easier to count.

## Why the estimate matches the code

Count the number of iterations and the cost of each iteration separately. A call such as `sort()` is not constant-time; include the sorting routine's full cost. The bound must represent the actual implementation, including hidden copying or resizing.

A correctness proof normally establishes initialization, maintenance, and termination of an invariant. Do not use a cost count as a substitute for proving the result.

## Time and space analysis

With adjacency lists, a graph traversal costs `O(V + E)`; with an adjacency matrix it costs `O(V²)`. Preserve independent parameters such as `n` and `m` in bounds like `O(n + m)` or `O(nm)`. Report space separately using the relevant input sizes.

The rough “about 10⁸ operations” rule is only an environment-dependent heuristic, not a time guarantee. Language, hardware, memory access, and operation costs matter.

## Practical use

Use estimation to check feasibility before implementation, choose an algorithm, and explain trade-offs to a team. Validate critical performance assumptions with representative measurements after identifying the bottleneck.

## Common mistakes and edge cases

- A nested loop is not always `n²`; the inner loop may be constant or logarithmic.
- Two consecutive `n`-length loops cost `O(n)`, not `O(n²)`.
- Do not treat average hash-table assumptions as worst-case guarantees.
- Account for the cost of called library operations.
- Check empty inputs, maximum constraints, and integer overflow.

## Step-by-step exercises

1. Count the exact executions of `j = i..n` for each `i`.
2. Simplify three consecutive sections with costs `n`, `n log n`, and `m`.
3. What does repeatedly calling `list.pop(0)` inside a loop cost?

For each exercise, write a simple correct baseline, derive its cost, and add an edge case. Trace a small input and compare the result with an independent expectation.

## Comprehensive quiz with explained answers

1. **Two consecutive `n`-iteration loops?** `Θ(n+n) = Θ(n)`; sequential costs add.
2. **Two nested loops that each iterate `n` times?** Usually `Θ(n²)`, when both bounds are indeed `n`.
3. **How many iterations when `i` doubles?** `Θ(log n)`, because the value grows geometrically.
4. **Why count library operations?** A library call can cost `O(n)`, `O(log n)`, or more; it is not automatically constant-time.
5. **What is graph traversal with adjacency lists?** `Θ(V + E)`, since vertices and their edges are processed.

## Recall checklist

Explain how you define input size, count iterations, account for called methods, state the case, and separate time from space. If you guessed from the number of lines instead of the executed work, redo the count.

## Further reading and references

- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — cost models, loop analysis, and growth comparisons.
- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — algorithmic thinking and complexity.
- [OpenDSA — Asymptotic Analysis and Upper Bounds](https://opendsa-server.cs.vt.edu/ODSA/Books/vt/cs3114/spring-2021/CSCI271/html/AnalAsymptotic.html) — formal bounds and examples.
- [NIST Dictionary — Big-O notation](https://xlinux.nist.gov/dads/HTML/bigOnotation.html) — precise upper-bound definition.
- [Persian supplementary course — Data Structures and Algorithms](https://cs-um.github.io/docs/mandatory/Data-Structures/).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can define the inputs and derive a count without memorizing the answer.
- [ ] I can trace a small example and create an edge case.
- [ ] I can state the algorithm's time and space costs.
- [ ] I have solved the exercises independently and reviewed my work.
