# Kruskal’s Algorithm

> Path: [Chapter 5 — Graphs](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/05-graphs/kruskal/README.md) · Suggested prerequisites: Sorting weighted edges and a disjoint-set union structure.

## Prerequisites and mental model

Sorting weighted edges and a disjoint-set union structure. Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

Kruskal examines edges from lightest to heaviest. It accepts an edge only when its endpoints belong to different components, so the chosen edges stay acyclic while components merge.

## Representation, contract, and invariant

A DSU stores one representative per current component. If find(u) differs from find(v), adding edge (u,v) joins two trees. If the representatives are equal, the edge would close a cycle and is rejected. Union by size/rank with path compression makes these checks nearly constant amortized time.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

Sort all edges by nondecreasing weight. Initialize DSU with one set per vertex. For each edge (w,u,v), if find(u)≠find(v), add the edge and union the sets. Stop after V−1 accepted edges for a connected graph. If the graph is disconnected, process the full edge list to obtain a minimum spanning forest.

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

Edges A–B=1, C–D=1, B–C=2, A–C=3, B–D=4. Accept A–B, C–D, and B–C. The remaining two edges connect vertices already in the same component and are rejected. The tree has total weight 4.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

The accepted edge never creates a cycle because it joins distinct components. Since edges are considered in ascending order, each accepted edge is a light safe connection between components; the cut/cycle property guarantees it can belong to an MST. After V−1 accepted edges, a connected graph is fully spanned.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

Sorting costs O(E log E). DSU operations over all edges take O(E α(V)) amortized with path compression and union by rank/size, so sorting dominates: commonly O(E log E). Space is O(V+E).

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

Edge-list graphs, sparse network design, clustering by stopping when the desired number of components remains, and minimum-cost connectivity. DSU gives a particularly simple cycle check.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

Kruskal is for undirected MSTs; DSU is not a directed-cycle detector. Self-loops are rejected because both endpoints have the same representative. Parallel edges are valid. Sorting tie order may change the chosen MST, not its optimal total.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Record every DSU set after processing the sample edges. 2. Find the minimum spanning forest of a disconnected graph. 3. Compare the sorting cost with the cost of DSU operations.

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** In what order are edges processed?
   **Answer:** Nondecreasing weight.
2. **Question:** When is an edge accepted?
   **Answer:** When its endpoints currently belong to different DSU components.
3. **Question:** What structure prevents cycles efficiently?
   **Answer:** Disjoint-set union (Union-Find).
4. **Question:** What usually dominates the runtime?
   **Answer:** Sorting E edges: O(E log E).
5. **Question:** Does Kruskal compute a directed MST?
   **Answer:** No; the standard algorithm is for undirected graphs.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [CP-Algorithms — Kruskal and DSU](https://cp-algorithms.com/graph/mst_kruskal.html)
- [Princeton Algorithms — Kruskal MST](https://algs4.cs.princeton.edu/43mst/KruskalMST.java.html)
- [Princeton Algorithms — Minimum Spanning Trees](https://algs4.cs.princeton.edu/43mst/)
- [Tarjan, “Efficiency of a Good But Not Linear Set Union Algorithm” (1975)](https://doi.org/10.1145/321879.321884)
- [NIST Dictionary — minimum spanning tree](https://xlinux.nist.gov/dads/HTML/minimumSpanningTree.html)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
