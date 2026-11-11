# Island Traversal and Flood Fill

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Matrices, BFS/DFS, and a visited set or in-place marking. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

Treat each land cell as a vertex in an implicit graph. Adjacent land cells are connected by edges; an island is one connected component. A grid’s coordinates and neighbor offsets are enough to traverse the graph without explicitly building every vertex and edge.

## Model, contract, and invariant

Specify 4-way adjacency (up, down, left, right) or 8-way adjacency (including diagonals). Validate row and column bounds before reading a cell. Mark a cell visited when it is pushed/enqueued so several neighbors cannot add it repeatedly.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

For every cell: if it is land and unseen, increment the island count and run BFS/DFS from it. Visit each in-bounds land neighbor once. Count visited cells for area. For perimeter, count each side that borders water or the outside of the grid.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

Grid rows: `1100 / 0101 / 0011`. With 4-way adjacency, the upper-left three cells form one component. The lower-right cluster also has three cells. The diagonal contact between (row 1,col 3) and (row 2,col 2) does not connect them, so there are two islands.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

A flood fill visits exactly the land cells reachable from its starting seed: every discovered neighbor is connected by an allowed edge, and every reachable cell is eventually examined. Each unseen seed therefore starts a distinct component.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

For an R×C grid, time is O(RC), since every cell and its constant number of neighbors are checked. Visited storage is O(RC); recursive DFS may also reach O(RC) call depth, so an explicit stack/queue is safer on large grids.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Map analysis, image segmentation, paint-bucket fill, connected regions in spatial data, and connected copper regions on a board.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Changing 4-way to 8-way adjacency changes the answer. Ragged rows need row-specific bounds. If the grid is modified to mark visited, document that side effect. A huge recursive flood fill can overflow the call stack.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Count islands, area of each, and maximum area for a small grid. 2. Compare 4-way and 8-way connectivity on a diagonal pattern. 3. Compute the perimeter of an L-shaped island by counting exposed sides.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What is an island in this model?
   **Answer:** A connected component of land cells under the chosen adjacency rule.
2. **Question:** When should the island count increase?
   **Answer:** When an unseen land cell starts a new flood fill.
3. **Question:** What is the runtime?
   **Answer:** O(RC) for an R-by-C grid.
4. **Question:** Why mark a cell when enqueueing it?
   **Answer:** To prevent multiple neighboring cells from adding it repeatedly.
5. **Question:** What must be specified about neighbors?
   **Answer:** Whether diagonal connectivity is allowed.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [LeetCode — Number of Islands](https://leetcode.com/problems/number-of-islands/)
- [LeetCode — Max Area of Island](https://leetcode.com/problems/max-area-of-island/)
- [LeetCode — Flood Fill](https://leetcode.com/problems/flood-fill/)
- [CP-Algorithms — Connected components](https://cp-algorithms.com/graph/search-for-connected-components.html)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
