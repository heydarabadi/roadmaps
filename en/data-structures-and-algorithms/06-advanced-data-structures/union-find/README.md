# Disjoint-Set Union (Union–Find)

> Path: [Chapter 6 — Advanced Data Structures](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/06-advanced-data-structures/union-find/README.md) · Suggested prerequisites: Arrays, parent pointers, trees, and connected components.

## Prerequisites and mental model

Arrays, parent pointers, trees, and connected components. Begin by identifying the operations and constraints the structure must support; advanced structures are useful only when their special operation matters to the workload.

## Core idea

DSU maintains a collection of pairwise-disjoint sets that are merged over time. `find(x)` returns the representative of x’s set; `union(a,b)` merges two sets. It is ideal for connectivity under insertions/unions, but does not support arbitrary edge deletion efficiently.

## Representation, contract, and invariant

Each root points to itself. Path compression rewrites nodes on a find path to point directly at the root. Union by size or rank attaches the smaller/shallow tree below the larger/taller one, preventing long chains.

An invariant is a property the representation must preserve after every update. State it before implementation so that the update rules and correctness argument can be checked against it.

## Step-by-step operations

`find(x)`: if parent[x]≠x, set parent[x]=find(parent[x]); return parent[x]. `union(a,b)`: compute roots ra, rb; if equal, return false; otherwise attach the lower-rank/smaller root below the other, update size/rank, and return true.

For production code, define empty input, duplicate keys, bounds, and update semantics explicitly. Keep the chosen indexing convention consistent throughout the implementation.

## Worked trace

Start with elements 0 through 4. After union(0,1), union(2,3), union(1,2), find(0)==find(3), while find(4) remains in a separate set. In Kruskal’s algorithm, the same comparison decides whether an edge joins components or would create a cycle.

Use a table with operation, affected node/index, state before, state after, and the invariant being restored. The trace should include at least one boundary or duplicate case.

## Why it works

Each root represents exactly one disjoint set. A union between two distinct roots replaces two sets with their union without changing membership elsewhere. Path compression changes only parent pointers within one set, so it changes the representation but not the partition.

Check that initialization establishes the invariant, every operation preserves it, and the final query combines exactly the state required by its contract.

## Time and space analysis

With path compression and union by rank/size, a sequence of operations takes O(α(n)) amortized time per operation, where α is the inverse Ackermann function and grows extremely slowly. Initialization and space are O(n).

Separate construction cost, per-operation cost, and auxiliary space. Expected/amortized bounds are not worst-case bounds; include the required assumptions.

## Real-world applications and trade-offs

Kruskal’s MST algorithm, incremental network connectivity, percolation simulations, and grouping elements under repeated merges. If edge deletions or splitting sets are required, ordinary DSU is the wrong abstraction.

Compare this structure with a simpler alternative before adopting it. Memory locality, implementation complexity, update pattern, and query mix may outweigh an asymptotic improvement for small inputs.

## Common mistakes and edge cases

A parent pointer may not point directly to the root until find compresses the path; call find to compare representatives. Rank is a balancing upper bound, not necessarily the tree’s current exact height. Do not increase component size when union finds both items already in the same set.

Test empty structures, one element, repeated keys, minimum/maximum legal index, and invalid bounds. If the algorithm mutates the input, document that behavior.

## Exercises

1. Draw the parent forest after a sequence of unions. 2. Compare a long find path before and after compression. 3. Explain why DSU cannot undo an arbitrary merge when one graph edge is deleted.

For each exercise, write the state and invariant before coding, then analyze both time and memory.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What does find(x) return?
   **Answer:** The representative/root of x’s component.
2. **Question:** What does path compression change?
   **Answer:** It shortens paths by pointing visited nodes directly to the root.
3. **Question:** What is union by size/rank for?
   **Answer:** Keeping the forest shallow.
4. **Question:** What is the amortized operation bound?
   **Answer:** O(α(n)) with both optimizations.
5. **Question:** What operation is not naturally supported?
   **Answer:** Arbitrary deletion that splits a set/component.

## Mastery checklist

- [ ] I can explain the data representation and its invariant.
- [ ] I can execute an update/query by hand on a small example.
- [ ] I know which operation is optimized and which assumptions are required.
- [ ] I can compare the structure with a simpler alternative.
- [ ] I can analyze build time, operation time, and space separately.

## Further reading and references

This lesson is designed to stand on its own; use these primary or educational sources for deeper study.

- [CP-Algorithms — Disjoint Set Union](https://cp-algorithms.com/data_structures/disjoint_set_union.html)
- [Tarjan, “Efficiency of a Good But Not Linear Set Union Algorithm” (1975)](https://doi.org/10.1145/321879.321884)
- [AtCoder Library — DSU documentation](https://atcoder.github.io/ac-library/production/document_en/dsu.html)
- [Princeton Algorithms — Kruskal MST](https://algs4.cs.princeton.edu/43mst/KruskalMST.java.html)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
