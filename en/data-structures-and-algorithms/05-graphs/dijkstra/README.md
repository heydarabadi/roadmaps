# Dijkstra’s Algorithm

> Path: [Chapter 5 — Graphs](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/05-graphs/dijkstra/README.md) · Suggested prerequisites: Weighted graphs, a min-priority queue, and edge relaxation.

## Prerequisites and mental model

Weighted graphs, a min-priority queue, and edge relaxation. Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

Dijkstra computes shortest-path distances from one source when every edge weight is nonnegative. It repeatedly finalizes the unsettled vertex with the smallest tentative distance. Nonnegative weights are essential to the greedy proof.

## Representation, contract, and invariant

Relaxing edge u→v with weight w tests whether dist[u]+w improves dist[v]. On improvement, record the new distance and parent. A binary heap chooses the smallest tentative distance. If the language’s heap has no decrease-key operation, push a new pair and ignore stale pairs when popped.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

Set dist[s]=0 and all other distances to infinity. Push (0,s). While the heap is nonempty, pop (d,u); skip it if d differs from the current dist[u]. For each edge (u,v,w), if d+w<dist[v], update dist[v] and parent[v], then push (dist[v],v). Reconstruct a route through parent links. Choose a numeric type that cannot overflow on valid path sums.

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

Edges S→A(4), S→B(1), B→A(2), A→T(1), B→T(7). B is finalized at 1; A improves to 3 through B; then T gets distance 4 through A. The route S–B–A–T costs 4.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

When u is removed with its current minimum distance, any route to u not yet accounted for must continue from some unsettled vertex. Because all remaining edge costs are nonnegative, extending such a route cannot produce a value smaller than u’s current minimum. Therefore u’s distance is final.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

With an adjacency list and binary heap, the usual bound is O((V+E) log V), with O(V+E) graph/auxiliary storage. A matrix and linear minimum selection take O(V²), which can suit dense graphs. With lazy duplicates, heap operations may be expressed as O(E log E).

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

Weighted routing, travel-time networks, latency/cost minimization, and shortest paths from one source. A* is a goal-directed extension when a suitable lower-bound heuristic is available.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

Negative edge weights invalidate Dijkstra. Skip stale heap entries. Check infinity and integer overflow before addition. Early exit is safe only when the target is popped with its current best key. Parent tie-breaking may matter when multiple shortest paths exist.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Trace the heap and distance table on the example. 2. Create a negative-edge graph where Dijkstra finalizes the wrong answer. 3. Reconstruct the path from parents and verify its total cost by summing the edges.

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What is the required edge-weight condition?
   **Answer:** All weights must be nonnegative.
2. **Question:** What does relaxation do?
   **Answer:** It replaces a tentative distance if a newly found path is shorter.
3. **Question:** Why is a popped vertex final?
   **Answer:** With nonnegative edges, continuing another route cannot reduce its cost.
4. **Question:** What is the standard heap-based bound?
   **Answer:** O((V+E) log V), often written with a lazy heap as O(E log E).
5. **Question:** What is a stale heap entry?
   **Answer:** An old pair whose distance is worse than the current dist[u], so it must be skipped.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [CP-Algorithms — Dijkstra’s Algorithm](https://cp-algorithms.com/graph/dijkstra.html)
- [Princeton Algorithms — Dijkstra and Shortest Paths](https://algs4.cs.princeton.edu/44sp/)
- [Dijkstra, “A Note on Two Problems in Connexion with Graphs” (1959)](https://doi.org/10.1007/BF01386390)
- [RFC 2328 — OSPF Version 2](https://www.rfc-editor.org/rfc/rfc2328)
- [Stanford CS161 — Dijkstra and Bellman–Ford notes](https://stanford-cs161.github.io/winter2021/assets/files/lecture11-notes.pdf)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
