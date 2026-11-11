# Divide and Conquer

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Recursion, arrays, and solving simple recurrences. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

Divide and conquer splits a problem into smaller instances, solves those instances recursively, and combines their answers. The subproblems should be small enough to make progress; the combine step must preserve the original problem’s contract.

## Model, contract, and invariant

A common recurrence is `T(n)=aT(n/b)+f(n)`: a subproblems of size n/b plus f(n) work for splitting and combining. Master theorem applies to particular recurrence forms; first derive the recurrence from the algorithm rather than guessing a familiar formula.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

Merge sort: split an interval in half; recursively sort each half; merge the two sorted results with two pointers. Binary search: keep only one half, with constant additional work. If subproblems overlap heavily, memoization or dynamic programming may avoid solving the same instance repeatedly.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

For [8,3,6,2], split into [8,3] and [6,2], then into singleton arrays. Merge [8] and [3] to [3,8], and [6] and [2] to [2,6]. The final merge compares the two heads in order and returns [2,3,6,8].

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

Assume each recursive call returns a correct solution for its smaller interval. The combine operation must use those solutions to produce a correct solution for the parent interval. Singleton intervals are correct by definition. Induction on interval length proves correctness; the length strictly decreases in each call.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

For merge sort, `T(n)=2T(n/2)+Θ(n)=Θ(n log n)`. Its array implementation needs Θ(n) auxiliary buffer and Θ(log n) recursion depth. For binary search, `T(n)=T(n/2)+Θ(1)=Θ(log n)`. Include copying and combine work, not just the recursive calls.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Sorting, parallel processing, geometric algorithms, and large numerical computations use independent subproblems. Parallel execution can help only when the saved computation exceeds scheduling, memory movement, and synchronization overhead.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Unbalanced splits can degrade performance; quicksort can become `T(n)=T(n−1)+Θ(n)=Θ(n²)`. Forgetting combine cost understates runtime. Divide-and-conquer differs from dynamic programming when subproblems substantially overlap.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Draw the complete recursion tree for merge sort on five values. 2. Solve `T(n)=2T(n/2)+n` by summing work per level. 3. Compare `T(n)=T(n/2)+1` with `T(n)=T(n−1)+1`.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What are the three stages?
   **Answer:** Divide the input, conquer smaller instances, and combine their results.
2. **Question:** What do a and b represent in the standard recurrence?
   **Answer:** a is the number of subproblems; b is the factor by which their size shrinks.
3. **Question:** Why does merge sort have Θ(log n) levels?
   **Answer:** Each level halves interval size until it reaches one element.
4. **Question:** When is dynamic programming often preferable?
   **Answer:** When divide-and-conquer calls repeatedly solve overlapping subproblems.
5. **Question:** What cost is often omitted by mistake?
   **Answer:** Splitting, copying, and combining the subproblem results.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [MIT 6.006 — Lecture videos and notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)
- [Princeton Algorithms — Mergesort](https://algs4.cs.princeton.edu/22mergesort/)
- [Princeton Algorithms — Quicksort](https://algs4.cs.princeton.edu/23quicksort/)
- [CP-Algorithms — Divide-and-conquer DP optimization](https://cp-algorithms.com/dynamic_programming/divide-and-conquer-dp.html)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
