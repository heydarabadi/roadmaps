# Bellman–Ford Algorithm

> Path: [Chapter 5 — Graphs](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/05-graphs/bellman-ford/README.md) · Suggested prerequisites: Weighted graphs, an edge list, and relaxation.

## Prerequisites and mental model

Weighted graphs, an edge list, and relaxation. Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

Bellman–Ford handles negative edge weights and can detect a negative-weight cycle reachable from the source. It is slower than Dijkstra, but it does not rely on all edges being nonnegative.

## Representation, contract, and invariant

If there is no reachable negative cycle affecting a destination, a shortest simple path uses at most V−1 edges. Repeatedly relaxing every edge propagates best distances along paths with increasing edge counts. If another full pass can still improve a distance, a reachable negative cycle exists.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

Initialize dist[s]=0 and all other values to infinity. Repeat V−1 times: for each edge (u,v,w), if dist[u] is finite and dist[u]+w<dist[v], relax it and record parent[v]=u. Stop early if a pass makes no change. On one additional pass, any further relaxation indicates a reachable negative cycle. To detect a negative cycle anywhere in the graph, add a super-source to all vertices or initialize all distances to zero.

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

Edges S→A(4), S→B(5), A→B(−2), B→C(3) give A=4, B=2, C=5 after relaxation propagates. Add C→A(−6): the cycle A→B→C→A has total weight −5, so repeated passes keep lowering distances.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

After k complete passes, every shortest path using at most k edges has had a chance to propagate its edge sequence. A finite shortest path without a negative cycle can be chosen simple and therefore contains at most V−1 edges. A further improvement must use a cycle; if its total weight were nonnegative, removing it would not make the path cheaper, so a strictly improving cycle has negative total weight.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

O(VE) time and O(V) distance/parent space, plus the graph storage. A run from source s detects only negative cycles reachable from s. The super-source technique checks all components.

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

Shortest paths with negative costs, difference constraints, and arbitrage detection after transforming multiplicative exchange rates into additive logarithmic weights. A negative cycle means some affected shortest-path values are unbounded below; it is not merely a finite negative answer.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

Never relax from infinity. Distinguish a negative cycle reachable from s from one elsewhere. Be clear whether a cycle affects the queried destination. Guard arithmetic and choose a type wide enough for repeated sums.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Record all distances after each pass. 2. Add a zero-weight cycle and explain why it does not keep improving distances. 3. Add a super-source and show how that changes the cycle-detection scope.

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** How many passes are needed for ordinary shortest paths?
   **Answer:** V−1 full passes cover simple paths with at most V−1 edges.
2. **Question:** How is a reachable negative cycle detected?
   **Answer:** An edge can still relax after V−1 passes.
3. **Question:** Does Bellman–Ford permit negative edges?
   **Answer:** Yes.
4. **Question:** What is its time complexity?
   **Answer:** O(VE).
5. **Question:** Does a run from s find a negative cycle in another disconnected component?
   **Answer:** No; use a super-source or initialize every vertex as a source.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [CP-Algorithms — Bellman–Ford](https://cp-algorithms.com/graph/bellman_ford.html)
- [Princeton Algorithms — Shortest Paths](https://algs4.cs.princeton.edu/44sp/)
- [Stanford CS161 — Dijkstra and Bellman–Ford notes](https://stanford-cs161.github.io/winter2021/assets/files/lecture11-notes.pdf)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [NIST Dictionary — shortest path](https://xlinux.nist.gov/dads/HTML/shortestpath.html)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
