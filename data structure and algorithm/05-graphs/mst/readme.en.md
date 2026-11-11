# Minimum Spanning Trees (MSTs)

> Path: [Chapter 5 — Graphs](../readme.en.md) · [Persian lesson](readme.md) · Suggested prerequisites: Connected, undirected, weighted graphs, cycles, and cut properties.

## Prerequisites and mental model

Connected, undirected, weighted graphs, cycles, and cut properties. Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

A spanning tree connects every vertex of a connected undirected graph with no cycle. A minimum spanning tree minimizes the sum of its edge weights. This objective is different from minimizing a route from one source to every other vertex.

## Representation, contract, and invariant

Any spanning tree on V vertices has V−1 edges. The cut property says a lightest edge crossing a cut is safe for some MST. The cycle property says a uniquely heaviest edge on a cycle can be excluded from every MST. If edge weights tie, multiple MSTs may exist.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

Prim grows one connected tree: repeatedly choose the lightest edge from the current tree to an outside vertex. Kruskal sorts edges by weight and accepts an edge only if it joins two different components, usually checked with DSU. Both rely on safe greedy choices justified by cut/cycle properties.

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

For triangle edges A–B=1, B–C=2, A–C=4, choose the first two edges; total weight is 3. The remaining edge would make a cycle and is not needed. If weights tie, another tree with the same total may be optimal.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

At each step, the chosen light edge crosses a cut separating already connected components. By the cut property, some MST contains that edge. Adding it therefore preserves the possibility of extending the partial forest to an optimal spanning tree. Kruskal’s DSU condition also ensures the chosen edges remain acyclic.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

An MST of a connected graph has V−1 edges. Kruskal is O(E log E) due to sorting; Prim is commonly O(E log V) with a heap and adjacency list, or O(V²) with a matrix and linear selection. A disconnected graph has a minimum spanning forest, not one spanning tree.

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

Minimum-cost cable or fiber layouts, connected infrastructure, and clustering from MST edge weights. Edge weights should represent additive construction cost or another valid global objective.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

An MST does not minimize each source-to-destination route. Do not run these standard algorithms on a directed graph. Self-loops cannot help; disconnected inputs produce a forest. Tied weights can yield different optimal edge sets.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Find all MSTs for a small square graph with tied edge weights. 2. Give a graph where the MST route from a chosen source is not a shortest-path tree. 3. Use the cut property to justify the lightest edge across a chosen cut.

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** How many edges does a spanning tree with V vertices contain?
   **Answer:** V−1.
2. **Question:** Does an MST give shortest paths from a source?
   **Answer:** No; it minimizes the sum of the selected tree edges.
3. **Question:** What does the cut property justify?
   **Answer:** That a lightest edge crossing a cut is safe to include in some MST.
4. **Question:** What does a disconnected graph produce?
   **Answer:** A minimum spanning forest.
5. **Question:** Is an MST always unique?
   **Answer:** No; tied weights can produce multiple optimal trees.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [Princeton Algorithms — Minimum Spanning Trees](https://algs4.cs.princeton.edu/43mst/)
- [CP-Algorithms — Minimum spanning tree, Kruskal and DSU](https://cp-algorithms.com/graph/mst_kruskal.html)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [NIST Dictionary — spanning tree](https://xlinux.nist.gov/dads/HTML/spanningTree.html)
- [Stanford CS161 — Data Structures and Algorithms](https://web.stanford.edu/class/cs161/)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
