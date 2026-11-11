# Time and Space Complexity

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../README.md) · Prerequisite: Big-O and operation counting  
> Language: English · [Read this lesson in Persian](../../../../fa/data-structures-and-algorithms/01-foundations/time-space/README.md)

## Prerequisites and mental model

Time complexity describes how an operation count grows with input size. Space complexity describes how much memory is required at once. Separate memory used by the input/output from auxiliary memory, and state whether the cost is best, average, or worst case.

## The idea from first principles

Time analysis usually counts primitive operations in a chosen computational model. Auxiliary space means peak extra memory; some conventions include recursion-stack space and others report it separately. Producing an output of `n` elements requires `Ω(n)` output storage if the whole output must exist, though an auxiliary-space claim may exclude that output.

An invariant is a statement that remains true during each algorithm step. It helps prove correctness and exposes boundary conditions.

## Step-by-step accounting

For one pass over `n` elements, `T(n) = Θ(n)`. If the algorithm keeps only a few counters, its auxiliary space is `Θ(1)`. Copying an array of `n` elements requires `Θ(n)` extra space. Recursion with depth `h` uses `Θ(h)` stack space even if each call stores only a few local values.

Define input sizes and count all simultaneously live data structures. Do not count every allocation over the entire run as if it were alive at once; account for peak live memory and whether the runtime retains freed objects.

## Worked comparison

Merge sort takes `Θ(n log n)` time, uses a `Θ(n)` merge buffer, and has a `Θ(log n)` recursion stack. Heap sort takes `Θ(n log n)` time and `Θ(1)` auxiliary space in its array implementation; the sorted output is the modified input array. The better choice depends on RAM limits, stability needs, and latency requirements.

For manual traces, record the step, index or pointer, active region, state change, and reason. This is useful for distinguishing input storage, output storage, and extra workspace.

## Correctness of the accounting

Count all structures and variables alive at the same time, not the total number of allocations during execution. Released memory does not increase peak live space unless the runtime keeps it reserved. Count the recursion stack according to the stated convention.

A correctness proof usually establishes initialization, maintenance, and termination of an invariant. Complexity is a separate claim and needs its own cost count.

## Time/space trade-offs

Memoization can turn repeated exponential work into polynomial work while requiring a cache. An in-place algorithm can reduce workspace but make code or access patterns more complex. Parallel algorithms may need additional per-thread stacks and buffers. Report time and space separately so these trade-offs are visible.

## Practical use

Choose a sort under a strict memory limit, process data larger than RAM, or evaluate a latency-constrained service by counting both time and peak space. Real memory includes object overhead, allocator metadata, stacks, and cache effects.

## Common mistakes and edge cases

- `O(1)` auxiliary space means constant extra memory, not zero total memory.
- Do not forget recursive stack space.
- State whether output storage is included.
- Asymptotic space is not the same as a runtime's observed peak heap or garbage-collected heap.
- Include empty and singleton inputs, large depth, and memory limits when evaluating the algorithm.

## Step-by-step exercises

1. Analyze time and space for BFS, merge sort, and iterative binary search separately.
2. How much recursion-stack space can recursive DFS use on a path graph with `n` vertices?
3. What time/space trade-off does memoized Fibonacci make?

For each exercise, write a correct baseline, analyze the costs, and add an edge case. Trace a small input and compare it with an independently derived result.

## Comprehensive quiz with explained answers

1. **What does space complexity usually measure?** Auxiliary/live memory as a function of input size; state whether output is excluded.
2. **How much stack space does recursion of depth `h` use?** `O(h)`, because up to `h` calls can be live at once.
3. **What is merge sort's usual auxiliary space?** `O(n)` for the array-based implementation because merge needs a buffer.
4. **Does `O(1)` auxiliary space mean no memory is used?** No. The input, output, and a constant amount of workspace still use memory.
5. **How does a time/space trade-off arise?** A stored table or cache consumes memory to avoid recomputing subproblems.

## Recall checklist

Explain the assumptions, invariant, trace, time, auxiliary space, one edge case, and a real use from memory. If you only remember the Big-O expression but not which memory is counted, revisit the definitions.

## Further reading and references

- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — algorithm analysis and data-structure costs.
- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — cost models and empirical growth comparisons.
- [OpenDSA — Algorithm Analysis Chapter](https://opendsa-server.cs.vt.edu/ODSA/Books/pubbook/odsa-all-0013bb43-a12f-4ab3-9b86-73b317f1e37e/fall-2017/Public_1092017/html/AnalChap.html) — asymptotic analysis methodology.
- [Princeton Algorithms — Mergesort](https://algs4.cs.princeton.edu/22mergesort/) — concrete runtime, space, and stability discussion.
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can explain the idea and assumptions without memorizing the wording.
- [ ] I can trace an example and identify an edge case.
- [ ] I can state time and auxiliary space separately.
- [ ] I have solved the exercises without looking at the answers and reviewed my work.
