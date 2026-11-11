# The Two-Heaps Pattern

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Min-heaps, max-heaps, and ordering. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

Two heaps split a changing set into a lower half and an upper half. A max-heap exposes the largest value in the lower half; a min-heap exposes the smallest in the upper half. Their roots reveal the median without sorting all values after each insertion.

## Model, contract, and invariant

Maintain two separate invariants: every lower-half value is ≤ every upper-half value, and heap sizes differ by at most one. Choose which heap is allowed to hold the extra element. For an even number of values, the median is the average of the two roots; for odd size, it is the root of the larger heap.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

Insert x into lower if lower is empty or x≤max(lower); otherwise insert into upper. Rebalance by moving a root if one heap is more than one element larger. Keep the partition order valid. For median, inspect the root(s); do not pop them.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

Insert 5,2,8,3. Place 5 in lower; 2 in lower, then rebalance so lower={2}, upper={5}. Insert 8 in upper; insert 3 in lower. Now lower={2,3}, upper={5,8}; the median is (3+5)/2=4.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

The partition invariant places the lower half before the upper half in sorted order. The size invariant puts the median at the boundary between those halves. Since each heap root exposes that boundary value, the median can be read directly.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

Each insertion takes O(log n), median query O(1), and storage O(n). Supporting deletions—especially removal of an arbitrary old value—needs an indexed heap, lazy deletion with counts, or another structure.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Streaming medians for latency, prices, sensor values, and online dashboards. Approximate quantile sketches may be preferable when exact medians for huge streams use too much memory.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

The size and ordering invariants are separate; one can hold while the other fails. Avoid integer overflow when averaging two large integer roots. Decide how duplicates are distributed. A fixed-size sliding median requires deletion support.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Insert 1,5,2,10,−1 and write both heaps and the median after every step. 2. Design lazy deletion for a sliding median. 3. Compare the exact two-heap method with a quantile sketch for a large stream.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** Which heap stores the lower half?
   **Answer:** A max-heap, whose root is the largest lower-half value.
2. **Question:** Which heap stores the upper half?
   **Answer:** A min-heap, whose root is the smallest upper-half value.
3. **Question:** What size balance is required?
   **Answer:** The heap sizes differ by at most one.
4. **Question:** How is an even-length median computed?
   **Answer:** Average the maximum of the lower half and minimum of the upper half.
5. **Question:** What is insertion cost?
   **Answer:** O(log n); reading the median is O(1).

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [LeetCode — Find Median from Data Stream](https://leetcode.com/problems/find-median-from-data-stream/)
- [LeetCode — Sliding Window Median](https://leetcode.com/problems/sliding-window-median/)
- [Princeton Algorithms — Priority Queues](https://algs4.cs.princeton.edu/24pq/)
- [MIT 6.006 — Binary Heaps and algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
