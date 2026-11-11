# Undirected Graphs

> Path: [Chapter 5 — Graphs](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/05-graphs/undirected-graph/README.md) · Suggested prerequisites: Vertices, edges, paths, and adjacency lists.

## Prerequisites and mental model

Vertices, edges, paths, and adjacency lists. Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

An undirected edge {u,v} is a symmetric connection: u is adjacent to v and v is adjacent to u. Connectivity, connected components, cycles, bridges, and spanning trees are central concepts in this model.

## Representation, contract, and invariant

The degree of a vertex is the number of incident edges; under the usual convention a self-loop contributes two to the degree. A connected component is a maximal set in which every pair of vertices has a path. An undirected tree is connected and acyclic; a tree on V vertices has V−1 edges.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

To label components, scan all vertices. Whenever an unseen vertex is found, start BFS or DFS and assign the same component ID to every reachable vertex. In an adjacency list, insert each undirected edge in the lists of both endpoints. A disjoint-set union structure is another choice when the graph is built only by merging components.

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

Edges 0–1, 1–2, and 3–4 form components {0,1,2} and {3,4}. Adding edge 2–3 joins the components. If that edge connects two previously separate trees, it cannot create a cycle.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

Each BFS/DFS started from a seed reaches exactly the vertices connected to it by paths, because every edge can be followed in either direction. Once all reachable vertices receive one label, no path crosses to an unlabeled component; the outer scan starts the next component.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

With adjacency lists, component labeling takes O(V+E) time and O(V) visited/stack/queue space. In an undirected list, the sum of degrees is 2E. DSU supports connectivity under union operations in near-constant amortized time, but it does not provide general edge deletion.

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

Two-way road networks, physical cable connections, and symmetric relationships are undirected models. A one-way street or dependency must remain directed; dropping its direction changes which paths exist.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

Store both directions in an adjacency list. A tree must be both connected and cycle-free. Self-loops and parallel edges affect degree and cycle checks and should be covered by the graph’s contract.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Find all components in a seven-vertex graph of your choice and show BFS states. 2. Prove that the reachable set from a vertex is one connected component. 3. How many edges does a tree with 12 vertices have, and why?

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What does an undirected edge mean?
   **Answer:** A symmetric connection that can be traversed in both directions.
2. **Question:** What is the sum of degrees in a standard undirected graph?
   **Answer:** 2E; a self-loop contributes two under the usual convention.
3. **Question:** How many edges are in a tree with n vertices?
   **Answer:** n−1.
4. **Question:** Define a connected component.
   **Answer:** A maximal set of vertices with a path between every pair.
5. **Question:** Which traversals label all components in linear time?
   **Answer:** BFS or DFS, in O(V+E) with adjacency lists.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [Princeton Algorithms — Undirected Graphs](https://algs4.cs.princeton.edu/41graph/)
- [CP-Algorithms — Connected components](https://cp-algorithms.com/graph/search-for-connected-components.html)
- [CP-Algorithms — Minimum spanning tree](https://cp-algorithms.com/graph/mst_kruskal.html)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [NIST Dictionary — graph](https://xlinux.nist.gov/dads/HTML/graph.html)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
