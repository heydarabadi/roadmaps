# Graph Representations

> Path: [Chapter 5 — Graphs](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/05-graphs/graph-representation/README.md) · Suggested prerequisites: Arrays, sets, adjacency, and the parameters V (vertices) and E (edges).

## Prerequisites and mental model

Arrays, sets, adjacency, and the parameters V (vertices) and E (edges). Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

A graph is a set of vertices and edges. The representation determines how much memory you use, how quickly you test whether an edge exists, and how efficiently you enumerate a vertex’s neighbors. Choose it from the operations your algorithms perform; there is no universally best representation.

## Representation, contract, and invariant

An adjacency list stores a neighbor collection for every vertex. An adjacency matrix stores a V×V table. An edge list stores each edge as a pair (or a weighted triple). For a directed edge u→v, record v under u. For an undirected edge {u,v}, record the connection at both endpoints in a list, or set both symmetric matrix cells. State how you treat self-loops, parallel edges, weights, and sparse/non-contiguous vertex IDs.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

To add a directed edge (u,v), validate both IDs and append v to adj[u]. For an undirected edge, also append u to adj[v]. For a matrix, set M[u][v]=true and, for an undirected graph, M[v][u]=true. To traverse neighbors, iterate only through adj[u] when using a list; scan row u when using a matrix.

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

For edges 0–1, 0–2, and 2–3, the lists are 0:[1,2], 1:[0], 2:[0,3], 3:[2]. A matrix uses 16 cells for these four vertices and marks symmetric cells. An edge list contains just three edge records. The list stores information proportional to the actual connections; the matrix reserves a cell for every possible pair.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

The representation is faithful when every input edge is present with the correct direction and weight, and no unintended edge is introduced. An undirected list has reciprocal neighbor records; an undirected matrix is symmetric. If an update changes only one side, the representation becomes inconsistent and later traversals may silently behave as if the graph were directed.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

Adjacency list: O(V+E) space; enumerating neighbors of u costs O(deg(u)); a full BFS/DFS costs O(V+E). Matrix: O(V²) space, edge existence in O(1), and neighbor enumeration in O(V) per vertex. Edge list: O(E) space, but finding all neighbors of an arbitrary vertex usually scans O(E). For an undirected list, the sum of degrees is 2E.

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

A sparse social or dependency network usually favors adjacency lists. A small dense graph or a workload with many direct edge-existence checks may favor a matrix. Kruskal naturally starts from an edge list because it sorts edges. For large external IDs, map them to compact integer indices before allocating arrays.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

Do not forget the reciprocal record for an undirected edge. Decide whether duplicate edges are allowed or deduplicated. A dense matrix consumes O(V²) even when E is tiny. If IDs are arbitrary strings, do not use them directly as array offsets. Keep edge direction, weight, and self-loop conventions consistent across the entire course.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Write one directed weighted graph in all three representations. 2. Estimate the matrix size for V=10,000 and compare it with an adjacency list when E=20,000. 3. Explain the cost of enumerating one vertex’s neighbors in each representation.

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** Name the three common graph representations.
   **Answer:** Adjacency list, adjacency matrix, and edge list.
2. **Question:** What is the space cost of an adjacency list?
   **Answer:** O(V+E), because it stores the vertices and actual neighbor records.
3. **Question:** When is a matrix attractive?
   **Answer:** For a small or dense graph, or when many O(1) edge-existence checks justify O(V²) space.
4. **Question:** How is one undirected edge represented in a list?
   **Answer:** As a neighbor entry at each endpoint.
5. **Question:** Why is an edge list convenient for Kruskal?
   **Answer:** The algorithm processes edges globally in nondecreasing weight order.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [Princeton Algorithms — Graphs, Chapter 4](https://algs4.cs.princeton.edu/40graphs/)
- [Princeton Graph API](https://algs4.cs.princeton.edu/41graph/)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [CP-Algorithms — Connected components](https://cp-algorithms.com/graph/search-for-connected-components.html)
- [NIST Dictionary — graph](https://xlinux.nist.gov/dads/HTML/graph.html)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
