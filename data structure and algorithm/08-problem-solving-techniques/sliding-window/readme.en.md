# Sliding Window

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Arrays/strings, two pointers, and a running aggregate. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

A sliding window maintains information about a contiguous range while its endpoints move. A fixed-size window advances by adding the new item and removing the departing one. A variable-size window expands and contracts while a predicate remains monotone.

## Model, contract, and invariant

For nonnegative values, increasing the right endpoint cannot decrease a sum; moving the left endpoint forward cannot increase it. This monotonicity makes certain sum-bounded windows correct. Negative values break that argument. Window boundaries must consistently be inclusive `[left,right]` or half-open `[left,right)`.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

For the longest subarray with sum at most S and nonnegative values:
left=0; sum=0; best=0
for right in 0..n-1:
    sum += A[right]
    while sum > S:
        sum -= A[left]; left += 1
    best=max(best, right-left+1)

Each pointer only moves forward.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

A=[2,1,3,2], S=5. Add 2, 1, 3: sum becomes 6, so remove the leading 2; [1,3] has sum 4. Add 2: sum 6, remove 1; [3,2] has sum 5. The best valid length is 2.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

After shrinking, the current window satisfies the condition. With nonnegative values, any earlier left endpoint would have a sum at least as large and is invalid for this right endpoint. Since each endpoint advances at most n times, the scan is linear.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

O(n) time and O(1) extra state for a running sum; a character-frequency window may use O(alphabet size). Recomputing each window from scratch can cost O(nk) for fixed width k.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Substring constraints, rolling statistics, rate windows, fixed-duration event analysis, and contiguous range problems. Real-time windows may use timestamps and eviction rules rather than a fixed number of records.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

The standard sum-window proof fails with negative values. Define the empty-window behavior and threshold edge cases. Do not confuse an arbitrary subsequence with a contiguous subarray. Duplicate characters and Unicode units may require careful counts.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Maintain a fixed-size window of length three and report each sum. 2. Find the shortest positive-number subarray with sum at least S. 3. Construct a negative-number counterexample to the longest-sum-at-most-S method.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What work does a window avoid?
   **Answer:** Recomputing a property from scratch for overlapping contiguous ranges.
2. **Question:** Why can a variable window be O(n)?
   **Answer:** Both endpoints move forward at most n times.
3. **Question:** Why are nonnegative values needed in the sum example?
   **Answer:** They make validity monotone as the window expands or contracts.
4. **Question:** How is a fixed-width window updated?
   **Answer:** Add the entering element and remove the departing one.
5. **Question:** What changes with negative numbers?
   **Answer:** The monotonicity proof can fail, so a different technique may be needed.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [USACO Guide — Two Pointers and Sliding Window](https://usaco.guide/silver/two-pointers)
- [LeetCode — Minimum Window Substring](https://leetcode.com/problems/minimum-window-substring/)
- [LeetCode — Minimum Size Subarray Sum](https://leetcode.com/problems/minimum-size-subarray-sum/)
- [LeetCode — Sliding Window Maximum](https://leetcode.com/problems/sliding-window-maximum/)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
