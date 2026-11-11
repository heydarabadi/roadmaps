# Greedy Algorithms

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Sorting, optimization problems, and mathematical proof. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

A greedy algorithm commits to a locally attractive choice at each step and does not revise it. This can make an algorithm simple and fast, but local optimality alone does not prove global optimality. The essential work is establishing when each choice is safe.

## Model, contract, and invariant

A proof often uses an exchange argument: start with an optimal solution, replace its first differing choice with the greedy choice, and show the result remains feasible and no worse. The remaining problem should then have the same structure. Cut and cycle properties are other forms of safe-choice proof.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

Activity selection: sort activities by finish time; take the compatible activity that finishes earliest; repeat among the remaining activities. The earliest-starting activity or shortest-duration activity is not a generally valid substitute.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

For intervals [1,4], [3,5], [0,6], [5,7], [8,9], choose [1,4] first. Then [5,7], then [8,9]. The choices leave as much remaining time as possible and produce three compatible activities.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

Let an optimal schedule begin with activity a. The greedy activity g finishes no later than a. Replacing a with g preserves compatibility with every later activity in that schedule, because those activities started after a finished. Thus some optimal schedule contains g. Repeating the argument on the remaining suffix proves greedy optimal.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

Sorting n activities costs Θ(n log n); scanning them costs Θ(n), for a total of Θ(n log n). The proof determines correctness; runtime alone cannot make a greedy choice valid.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Interval scheduling, minimum spanning trees, prefix coding, and some resource allocation problems admit greedy solutions. Each problem requires its own proof and assumptions.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

A familiar phrase like “take the largest value first” is not a proof. Greedy by value/weight works for fractional knapsack because items can be split, but not for general 0/1 knapsack. Try to find a small counterexample before trusting a heuristic.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Find counterexamples to choosing the earliest-starting or shortest activity. 2. Write an exchange proof for earliest finish time. 3. Compare fractional and 0/1 knapsack and identify which assumption changes.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** Does a locally best choice always give a global optimum?
   **Answer:** No. A greedy-choice proof is required.
2. **Question:** What does an exchange argument show?
   **Answer:** That an optimal answer can be transformed to include the greedy choice without becoming worse.
3. **Question:** What is the activity-selection rule?
   **Answer:** Choose a compatible activity with the earliest finish time.
4. **Question:** Why does ratio-greedy work for fractional knapsack?
   **Answer:** An optimal solution may take a fraction, so value per unit weight supports exchange.
5. **Question:** How can a greedy idea be quickly challenged?
   **Answer:** Search for a small counterexample that breaks its claimed invariant or optimality.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)
- [Princeton Algorithms — Minimum Spanning Trees and cut property](https://algs4.cs.princeton.edu/43mst/)
- [CP-Algorithms — Greedy algorithms index](https://cp-algorithms.com/greedy/index.html)
- [USACO Guide — Greedy algorithms resources](https://usaco.guide/bronze/intro-greedy)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
