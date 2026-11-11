# Two Pointers

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Arrays/strings, loops, and sometimes sorted order. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

Two indices move through data according to a proof-backed rule, reducing repeated work. Common forms start at opposite ends, move in the same direction, or track different speeds. A sorted input often enables safe elimination of many candidate pairs.

## Model, contract, and invariant

For sorted two-sum, keep `left` and `right`. If their sum is too small, the current left value cannot pair with any remaining right-side value to reach the target, so increment left. If the sum is too large, decrement right. This argument depends on sorted order.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

left=0; right=n−1
while left<right:
    total=A[left]+A[right]
    if total==target: return pair
    if total<target: left+=1
    else: right-=1
return not-found

For same-direction compaction, a read pointer scans and a write pointer tracks the next output position.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

On [1,2,4,6,9], target 8: 1+9 is too large, so move right to 6; 1+6 is too small, so move left to 2; 2+6 is 8. Each step removes at least one candidate boundary without discarding a possible answer.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

The invariant is that any discarded pair is already known not to be a solution. For sorted two-sum, when the sum is below target, pairing the left value with anything no larger than the current right still cannot reach target, so no solution uses that left value. The symmetric argument applies when the sum is too large.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

A monotone pass takes O(n) time and O(1) extra space. If sorting is needed first, include its O(n log n) cost and preserve original indices if required.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Sorted pair search, merging sorted sequences, in-place deduplication, palindrome checks, partitioning, and the container-with-most-water problem use pointer movement.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Do not use opposite-end movement on unsorted input without another proof. `left<right` prevents reusing one element. Duplicate handling depends on whether the problem asks for one pair, distinct values, or all unique pairs.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Trace target values below, equal to, and above the first possible pair. 2. Deduplicate a sorted array in place with read/write pointers. 3. Prove why a pointer move is safe in sorted two-sum.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What justifies moving a pointer?
   **Answer:** An invariant and proof that the removed candidates cannot contain a needed answer.
2. **Question:** What key condition enables the usual opposite-end two-sum?
   **Answer:** The array is sorted under the same order used for comparison.
3. **Question:** What is the typical cost?
   **Answer:** O(n) time and O(1) extra space.
4. **Question:** What extra cost may sorting add?
   **Answer:** O(n log n), and it can change original index positions.
5. **Question:** Why use `left < right`?
   **Answer:** To ensure the two pointers refer to distinct elements.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [USACO Guide — Two Pointers and Sliding Window](https://usaco.guide/silver/two-pointers)
- [LeetCode — Two Sum II: Input Array Is Sorted](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/)
- [LeetCode — Valid Palindrome](https://leetcode.com/problems/valid-palindrome/)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
