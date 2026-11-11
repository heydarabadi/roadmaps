# Brute Force and Exhaustive Search

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Loops, collections, and basic counting. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

Brute force enumerates every candidate in a clearly defined solution space, checks which candidates are valid, and retains a valid or best answer. It is often the simplest correct baseline. A baseline matters: it gives you a reference implementation for testing an optimized algorithm, even when it is too slow for the largest input.

## Model, contract, and invariant

Define exactly what one candidate is. For pairs, is order relevant? Can an item be reused? For subsets, does each item have an include/exclude choice? State the completeness argument: every possible answer must appear in the enumeration, and the validity check must accept exactly the allowed answers.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

For each candidate c in the complete search space:
    if c is valid and improves best:
        best = c
return best

For all pairs with i < j, use two loops and evaluate A[i], A[j]. For subsets, make one binary choice for each input element.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

For A=[2,7,4,9], find a pair whose sum is closest to 10. The six pairs give sums 9, 6, 11, 11, 16, and 13. The minimum absolute error is 1, achieved by (2,7) and (2,9). Because all six pairs were considered, no better pair was skipped.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

After k candidates, `best` is the best valid answer among exactly those k candidates. The loop preserves that fact whenever it sees a better valid candidate. When enumeration ends, it has covered the entire solution space; therefore `best` is globally optimal, provided at least one valid candidate exists (otherwise return an explicit “no solution” result).

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

Checking all pairs takes Θ(n²); checking all subsets takes Θ(2ⁿ); checking all permutations takes Θ(n!). Include the cost of validating each candidate: Θ(n) work per subset may make total work Θ(n·2ⁿ). Space can be O(1) for nested loops or O(depth) for recursive generation, not counting stored outputs.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Exhaustive search is appropriate when n is provably small, when the full output itself must be produced, or when a simple oracle is needed to differential-test a faster implementation on random small cases. Cryptographic brute force is a separate threat model and should never be described as a practical general-purpose technique.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Do not silently omit candidates or check a weaker validity condition than the specification. Repeated generation can multiply work. A tiny example does not reveal exponential growth. If you prune, prove that no valid or better answer can exist in the removed branch. Decide what to return when no candidate works.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. List every subset of [1,2,3] and count them. 2. Write a triple-loop brute-force 3-sum checker and derive its time. 3. Use it as an oracle to compare a faster implementation on hundreds of small random arrays.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What makes exhaustive search a useful baseline?
   **Answer:** Its complete candidate space makes the correctness argument simple, and it can act as an oracle for small test cases.
2. **Question:** How many subsets does n elements have?
   **Answer:** 2ⁿ, because each element is independently included or excluded.
3. **Question:** What is the time to inspect every pair?
   **Answer:** Θ(n²), before including any nonconstant candidate-validation work.
4. **Question:** Is pruning automatically safe?
   **Answer:** No. A pruning rule must prove that a removed branch cannot contain a valid or better answer.
5. **Question:** When can brute force be the right production choice?
   **Answer:** When constraints keep the candidate space small, or when exhaustive output is required and no faster method can avoid producing it.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)
- [Stanford CS106B — Exhaustive Recursion and Backtracking](https://see.stanford.edu/Course/CS106B/149)
- [LeetCode Problem Set — enumeration and brute-force practice](https://leetcode.com/problemset/)
- [MIT 6.006 course materials](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
