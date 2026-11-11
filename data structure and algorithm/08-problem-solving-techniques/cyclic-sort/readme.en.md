# Cyclic Sort Pattern

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Arrays, indices, swaps, and a bounded integer range. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

When n values are drawn from a known index-aligned range such as 1..n, each value identifies its target position. Swapping misplaced values toward their target can place the entire permutation in linear time and constant extra space. This is a specialized pattern, not a general comparison sort.

## Model, contract, and invariant

For values 1..n, value x belongs at index x−1. At index i, either A[i]=i+1 and we advance, or we swap A[i] with its target position. With duplicates or missing values, a target slot may already contain the same value; detect this to prevent an endless swap loop.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

i=0
while i<n:
    if A[i]==i+1: i+=1
    else:
        j=A[i]-1
        if A[j]==A[i]: handle duplicate; i+=1
        else: swap(A[i],A[j])

Validate the input range before using a value as an index.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

For [3,1,5,4,2], value 3 moves to index 2: [5,1,3,4,2]. Then 5 moves to index 4: [2,1,3,4,5]. Finally 2 moves to index 1, yielding [1,2,3,4,5]. Each successful swap fixes at least one value.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

For a permutation containing each value exactly once, every swap places the value at the current index into its unique final slot; already fixed slots are not disturbed. Thus at most a linear number of useful swaps occurs. Duplicate-aware variants require a separate progress argument and a precise specification for missing/duplicate output.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

O(n) time and O(1) auxiliary space under the bounded-range assumptions. If values are out of range, the target-index rule is invalid.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Finding missing or duplicate values in arrays whose values are constrained to an index range, such as 1..n, is the main use. It is attractive when mutation is allowed and auxiliary-memory limits are tight.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Out-of-range values can cause invalid indexing. Duplicates can cause repeated swaps without a special guard. This pattern does not apply to arbitrary values such as −100 and 500. If the input must not be modified, copying costs O(n) extra space.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Place values from [4,3,2,7,8,2,3,1] using a duplicate-aware rule. 2. Show why the duplicate guard guarantees progress. 3. Explain why arbitrary real numbers cannot define array target indices.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** Where does x go in the 1..n variant?
   **Answer:** Index x−1.
2. **Question:** Why can the permutation case be linear?
   **Answer:** Each useful swap moves a value into its final index.
3. **Question:** What assumption makes the method possible?
   **Answer:** Values lie in a known range aligned with array indices.
4. **Question:** Why do duplicates need special handling?
   **Answer:** A value may already occupy its target, so swapping can otherwise repeat forever.
5. **Question:** Is cyclic sort a general-purpose sort?
   **Answer:** No. It relies on a bounded value-to-index mapping.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [LeetCode — First Missing Positive](https://leetcode.com/problems/first-missing-positive/)
- [LeetCode — Find All Numbers Disappeared in an Array](https://leetcode.com/problems/find-all-numbers-disappeared-in-an-array/)
- [LeetCode — Missing Number](https://leetcode.com/problems/missing-number/)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
