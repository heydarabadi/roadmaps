# Backtracking

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Recursion, depth-first search, and constraints. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

Backtracking constructs a candidate incrementally. When the current partial choice violates a constraint or cannot lead to an acceptable answer, it undoes the choice and tries another branch. It is depth-first search over a decision tree, with pruning that must be logically safe.

## Model, contract, and invariant

Define the state, legal next choices, completion condition, and constraints. Before each recursive call, the state must remain a valid prefix of some solution. If the state is mutated in place, every mutation must have a matching undo operation.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

search(state):
    if state is complete: record/return answer
    for choice in legal choices:
        apply(choice)
        if state can still lead to an answer:
            search(state)
        undo(choice)

For N-Queens, place one queen per row; sets track occupied columns and diagonals.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

For four queens, after placing a queen in row 0, reject columns and diagonals attacked in row 1. Continue only with safe columns. If a later row has no safe column, remove the most recent queen and try the next candidate. At a full four-row placement, all constraints have been preserved.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

At each level, enumerate every legal extension of the current prefix. The invariant says the prefix satisfies all constraints. If pruning rejects a state, prove that no completion of that state can be valid (or improve the incumbent for optimization). Exhausting all branches then finds every solution or proves none exists.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

Worst-case time is often exponential or factorial; pruning can make practical instances much smaller without changing the worst-case bound. Auxiliary space is typically recursion depth plus the constraint state. Producing all answers can itself require exponential output space.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Puzzle solvers, constraint scheduling, combination generation, small configuration search, and exact search with branch-and-bound use backtracking. Larger constraint problems may be better handled by SAT/CP solvers or domain-specific algorithms.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Incomplete undo contaminates later branches. Unsound pruning silently loses valid answers. Decide whether to stop after one solution or enumerate all. Avoid copying the entire state at every node unless the simpler implementation justifies the memory cost.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Generate all subsets of [1,2,3] using include/exclude choices. 2. Trace the two solutions for N=4 Queens. 3. Write the state mutation and undo as paired operations for subset sum.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What is backtracking?
   **Answer:** Depth-first construction of partial solutions, undoing choices when a branch cannot work.
2. **Question:** What must be true before a recursive call?
   **Answer:** The partial state must satisfy the constraints and represent a valid prefix.
3. **Question:** When is pruning safe?
   **Answer:** When it proves that the branch cannot contain a valid or better answer.
4. **Question:** What is a common worst-case cost?
   **Answer:** Exponential or factorial, depending on the search space.
5. **Question:** Why is an undo step needed?
   **Answer:** It restores shared state so the next branch starts from the correct parent state.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [Stanford CS106B — Backtracking pseudocode and N-Queens](https://see.stanford.edu/Course/CS106B/149)
- [Stanford CS106B — Recursive backtracking lecture](https://web.stanford.edu/class/archive/cs/cs106b/cs106b.1134/)
- [Stanford CS106B Handout — Exhaustive recursion and backtracking (PDF)](https://see.stanford.edu/materials/icspacs106b/H19-RecBacktrackExamples.pdf)
- [LeetCode — N-Queens](https://leetcode.com/problems/n-queens/)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
