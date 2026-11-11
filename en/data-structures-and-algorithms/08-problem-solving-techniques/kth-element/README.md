# Selecting the k-th Element

> Chapter: [08 Problem Solving Techniques](../README.md) · [Persian version](../../../../fa/data-structures-and-algorithms/08-problem-solving-techniques/kth-element/README.md)

## Learning goals and prerequisites

Prerequisites: Heaps, sorting, and partitioning. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

Selection finds the element at a requested rank without necessarily sorting every element. First define whether k is one-based or zero-based, whether the rank is smallest or largest, and how duplicates count. Quickselect and heaps solve different workload versions of this task.

## Model, contract, and invariant

For zero-based target index t, partition places a pivot at its final sorted index p. All elements on one side compare no greater than the pivot and all elements on the other side no smaller, according to the partition contract. If t differs from p, only the side containing t can still contain the answer.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

Quickselect: partition around a pivot; if pivot index equals target, return it; otherwise repeat only on the target side. For k-th largest using a heap, keep a min-heap of at most k elements; discard the smallest whenever its size exceeds k. The heap root is then the k-th largest seen.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

For [7,2,1,6,8,5,3,4], find the 3rd smallest (target index 2). Partition around 4 may place it at index 3. Since the target is to its left, ignore the right partition and continue in the left portion; the answer is 3. The remaining array need not be fully sorted.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

Partition establishes the pivot’s exact rank. If the target rank lies left, every item right of the pivot is too large; if it lies right, every item left is too small. Repeating preserves the target rank until it becomes the pivot. For the heap variant, after each input prefix the heap contains the k largest values in that prefix.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

Random-pivot Quickselect is expected O(n), worst O(n²), and can be in-place. A size-k heap takes O(n log k) time and O(k) space. Full sorting costs O(n log n) and is preferable when many ranks or the complete order are needed.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Top-k results, percentiles, median selection, and ranking telemetry. For a stream, a fixed-size heap is convenient; for a static array and one rank, Quickselect often reduces expected work.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Validate 1≤k≤n and map k to the correct index. Duplicates affect rank definitions. A poor pivot can make Quickselect quadratic. Copying an immutable input costs O(n).

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Convert k-th smallest and k-th largest to zero-based indices for n=8. 2. Trace a size-2 min-heap for the 2nd largest. 3. Decide when a full sort is simpler than Quickselect.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What does Quickselect do after partition?
   **Answer:** It continues only in the partition that contains the requested rank.
2. **Question:** What is expected Quickselect time with randomized pivots?
   **Answer:** O(n), though its worst case remains O(n²).
3. **Question:** How does a heap find the k-th largest?
   **Answer:** Maintain a min-heap of the k largest values; its root is the smallest among them.
4. **Question:** How much space does a size-k heap use?
   **Answer:** O(k).
5. **Question:** What rank convention must be stated?
   **Answer:** Whether k is one-based or zero-based and how duplicates are counted.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [CP-Algorithms — K-th order statistic in O(N)](https://cp-algorithms.com/sequences/k-th.html)
- [Princeton Algorithms — Quicksort and Quickselect](https://algs4.cs.princeton.edu/23quicksort/)
- [LeetCode — Kth Largest Element in an Array](https://leetcode.com/problems/kth-largest-element-in-an-array/)
- [LeetCode — K Closest Points to Origin](https://leetcode.com/problems/k-closest-points-to-origin/)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
