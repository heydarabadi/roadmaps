# Dynamic Programming

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Recursion, arrays, and a basic understanding of graphs and state. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

Dynamic programming (DP) stores answers to subproblems so each state is solved once instead of being recomputed. It is especially useful when an optimal answer is composed from smaller optimal answers and the same subproblems recur.

## Model, contract, and invariant

A state must contain exactly enough information to define a smaller problem. A recurrence relates its answer to smaller states; base cases anchor it; an evaluation order must respect dependencies. Top-down memoization follows recursive calls and caches them. Bottom-up tabulation computes states in dependency order.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

1) Define the state in a sentence. 2) Write the recurrence and explain each transition. 3) Set base cases. 4) Identify a valid topological/evaluation order. 5) Compute the original answer and, if needed, retain parent choices to reconstruct a solution. Example: `ways[i]=ways[i−1]+ways[i−2]` for steps of size 1 or 2.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

For stair climbing with n=4, set ways[0]=1 and ways[1]=1. Then ways[2]=2, ways[3]=3, ways[4]=5. The five paths correspond to all ordered sequences of 1- and 2-step moves totaling four.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

Prove the meaning of the state first. Each valid solution to a state must end in one of the recurrence’s cases, and every recurrence case must construct a valid solution. If smaller states are correct by induction and the cases are exhaustive and non-overlapping (or counted without duplication), the computed value is correct.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

Usually, runtime equals number of reachable states times transition work per state. Fibonacci is Θ(n) time and O(n) table space, reducible to O(1). 0/1 knapsack is O(nW) time and O(W) space after optimization; this is pseudo-polynomial because it depends on numeric W, not only the number of bits used to encode W.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Sequence alignment, route planning, scheduling, resource allocation, and computational biology use dynamic programming. Large state spaces may still require approximation, state compression, or problem-specific pruning.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Incomplete state definitions merge distinct subproblems. Incorrect base cases and loop directions are frequent bugs; for 0/1 knapsack, capacity usually iterates downward to avoid reusing an item. Memoization does not help if almost every state is unique.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Define state, recurrence, and base cases for minimum coin change. 2. Implement Fibonacci with memoization and with a bottom-up table; compare time and memory. 3. Explain why O(nW) knapsack time is pseudo-polynomial.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What is a DP state?
   **Answer:** A precise description of a subproblem and all information needed to solve it.
2. **Question:** How is DP runtime estimated?
   **Answer:** Count reachable states and multiply by the work for each state’s transitions.
3. **Question:** What is memoization?
   **Answer:** Top-down recursion with a cache for solved states.
4. **Question:** Why does evaluation order matter?
   **Answer:** Every dependency must be computed before the state that uses it.
5. **Question:** Why is O(nW) pseudo-polynomial?
   **Answer:** W is a numeric value; its magnitude can be exponential in the number of bits encoding W.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [MIT 6.006 — Dynamic Programming lecture videos](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)
- [MIT 6.006 Recitation 15 — Dynamic Programming (PDF)](https://live.ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/6022dc36557c5e5df2ad0a77e9463855_MIT6_006S20_r15.pdf)
- [MIT 6.006 Lecture 16 — Dynamic Programming Subproblems](https://live.ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/28461a74f81101874a13d9679a40584d_MIT6_006S20_lec16.pdf)
- [CP-Algorithms — Dynamic Programming introduction](https://cp-algorithms.com/dynamic_programming/intro-to-dp.html)
- [Persian supplementary course](https://cs-um.github.io/docs/mandatory/Data-Structures/)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
