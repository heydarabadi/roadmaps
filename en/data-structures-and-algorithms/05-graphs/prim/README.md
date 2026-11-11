# Prim’s Algorithm

> Path: [Chapter 5 — Graphs](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/05-graphs/prim/README.md) · Suggested prerequisites: MSTs, weighted undirected graphs, and priority queues.

## Prerequisites and mental model

MSTs, weighted undirected graphs, and priority queues. Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

Prim starts from one vertex and grows a single tree. At each step it chooses the cheapest edge connecting the current tree to an outside vertex. Negative edge weights are allowed because this is a spanning-tree problem, not a shortest-path problem.

## Representation, contract, and invariant

For each outside vertex v, key[v] is the lightest known edge connecting v to the current tree; parent[v] records the endpoint. Once v is extracted and added, its chosen edge becomes part of the tree. The key is an edge cost—not a path distance.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

Set key[root]=0 and all others to infinity. Repeatedly extract the smallest key vertex not yet in the tree, add it, and inspect its incident edges. For each outside neighbor x, if edge weight w<key[x], update key and parent. To handle disconnected graphs, restart from each vertex not yet included, producing a forest.

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

Edges A–B=1, A–C=5, B–C=2, B–D=4, C–D=1. Starting at A selects A–B, then B–C, then C–D; total weight is 4. A–C with weight 5 never improves the cheapest connection.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

The current tree defines a cut between included and outside vertices. Prim chooses the lightest crossing edge. By the cut property, that edge is safe for some MST, so each extension preserves optimality.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

With adjacency lists and a binary heap with decrease-key, O(E log V); a lazy heap is often described as O(E log E). Matrix plus linear minimum selection takes O(V²), useful for dense graphs. Space is O(V+E).

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

Growing a least-cost network from a starting node, dense/sparse MST construction according to representation, and teaching the cut-property greedy proof. The chosen start does not change the optimum total, although ties can produce a different MST.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

Track whether a vertex is already in the tree. Do not confuse key[v] with a shortest-path distance. Prim’s standard MST definition is for undirected graphs. Negative weights are fine; disconnected input gives a forest.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Record key and parent after every extraction in the example. 2. Run Prim on a disconnected graph and show the restart. 3. Explain why an edge of negative weight is safe to consider.

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What edge does Prim choose each round?
   **Answer:** The lightest edge crossing from the current tree to an outside vertex.
2. **Question:** Are negative weights allowed?
   **Answer:** Yes, for an undirected MST.
3. **Question:** What is the common heap-based complexity?
   **Answer:** O(E log V), subject to heap/representation details.
4. **Question:** Does the starting vertex change the minimum total weight?
   **Answer:** No, though ties can produce a different optimal tree.
5. **Question:** What happens on a disconnected graph?
   **Answer:** Restart from an unseen vertex to build a minimum spanning forest.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [Princeton Algorithms — Prim’s MST implementations](https://algs4.cs.princeton.edu/43mst/)
- [CP-Algorithms — Minimum spanning tree](https://cp-algorithms.com/graph/mst_kruskal.html)
- [Princeton Lazy Prim implementation](https://algs4.cs.princeton.edu/43mst/LazyPrimMST.java.html)
- [Princeton Eager Prim implementation](https://algs4.cs.princeton.edu/43mst/PrimMST.java.html)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
