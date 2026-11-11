# Merge Intervals

> Chapter: [08 Problem Solving Techniques](../README.md) · [Persian version](../../../../fa/data-structures-and-algorithms/08-problem-solving-techniques/merge-intervals/README.md)

## Learning goals and prerequisites

Prerequisites: Sorting, ranges, and endpoint conventions. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

To combine overlapping intervals, sort them by start and scan from left to right. After sorting, any interval that overlaps the current output interval can be merged into it; otherwise it begins a separate output interval.

## Model, contract, and invariant

First decide whether intervals are closed `[a,b]` or half-open `[a,b)`. For closed intervals, touching at a point overlaps when `next.start <= current.end`. For half-open intervals, a common rule is `next.start < current.end`. Decide whether adjacent-but-nonoverlapping intervals should also be coalesced.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

Sort intervals by start. For each interval [s,e]: if output is empty or s is beyond the last output end, append it; otherwise replace the last end with `max(last.end,e)`. Validate reversed and empty intervals according to the input contract.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

For closed intervals [1,3], [2,6], [8,10], [10,12], the first two merge to [1,6]. The last two meet at 10, so they merge to [8,12]. The result is [1,6], [8,12]. Under a half-open contract, the boundary rule may produce a different result.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

After processing a sorted prefix, the output intervals are sorted and pairwise disjoint, and their union equals the union of all processed intervals. The next interval can overlap only the last output interval; if it begins after that interval ends, it cannot overlap any earlier output interval.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

Sorting costs O(n log n); the scan costs O(n); output space is O(n) in the worst case. If the input is already sorted by start, the scan alone is linear.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Calendar availability, IP or time ranges, coverage segments, event logs, and interval union computations use this pattern. Timestamp precision, time zones, and endpoint inclusivity must be explicit in production systems.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Endpoint conventions change answers at boundaries. Define handling for empty intervals, duplicate intervals, and malformed ranges. Merging touching intervals is a product choice, not an implementation detail.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Merge the same list under both closed and half-open conventions. 2. Define and test behavior for empty and reversed intervals. 3. Prove why only the most recently merged output interval needs comparison.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** Why sort by start first?
   **Answer:** It orders candidates so only the current last output interval can overlap the next interval.
2. **Question:** What is the total complexity?
   **Answer:** O(n log n), dominated by sorting.
3. **Question:** What is the overlap condition for closed intervals?
   **Answer:** The next start is less than or equal to the current end.
4. **Question:** Why does endpoint convention matter?
   **Answer:** A shared endpoint may overlap in a closed interval but not in a half-open interval.
5. **Question:** What invariant does the output maintain?
   **Answer:** Sorted, nonoverlapping intervals whose union equals the processed input union.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [LeetCode — Merge Intervals](https://leetcode.com/problems/merge-intervals/)
- [LeetCode — Interval List Intersections](https://leetcode.com/problems/interval-list-intersections/)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)
- [Persian supplementary course](https://www.konkurcomputer.ir/dade-videos.html)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
