# Directed Graphs

> Path: [Chapter 5 — Graphs](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/05-graphs/directed-graph/README.md) · Suggested prerequisites: Vertices, edges, and the meaning of a one-way relation.

## Prerequisites and mental model

Vertices, edges, and the meaning of a one-way relation. Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

A directed edge u→v permits travel from u to v; it does not imply that v→u exists. This changes reachability, in-degree, out-degree, and whether a dependency order is possible. A directed acyclic graph (DAG) has no directed cycle.

## Representation, contract, and invariant

A path follows edge direction. In-degree is the number of incoming edges; out-degree is the number of outgoing edges. In a DAG, a topological order places the source of every edge before its destination. A directed cycle means the vertices in that cycle depend on one another, so no topological order can satisfy every edge.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

Store each directed edge u→v only in adj[u]. Kahn’s topological-sort algorithm computes all in-degrees, enqueues every zero-in-degree vertex, repeatedly removes one, appends it to the order, and decreases the in-degree of its outgoing neighbors. If fewer than V vertices are removed, the graph contains a cycle. A DFS alternative marks vertices white/gray/black; an edge to a gray vertex reveals a cycle, and reverse finish order yields a topological ordering for a DAG.

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

Dependencies A→B, A→C, B→D, C→D require A before B and C, and both before D. A,C,B,D and A,B,C,D are valid. Adding D→A creates a directed cycle and makes a topological order impossible.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

During Kahn’s algorithm, the queue contains exactly vertices whose remaining predecessors have already been removed. Removing one cannot violate an ordering constraint; all its outgoing constraints are handled by decrementing the destinations’ in-degrees. If a cycle remains, every vertex in it retains at least one incoming edge, so the queue empties before all vertices are emitted.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

With adjacency lists, topological sorting and cycle detection take O(V+E) time and O(V+E) graph storage plus O(V) auxiliary state. A DAG may have many valid topological orders; uniqueness is a separate property.

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

Build systems, package dependencies, course prerequisites, job workflows, and one-way routing are naturally directed. The direction must match the semantics: “A must finish before B” should be represented A→B if the output order follows prerequisite to dependent.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

Do not insert a reverse edge unless the relation is genuinely bidirectional. A topological order exists only for a DAG. If Kahn emits fewer than V vertices, that is evidence of a cycle, not a partial valid schedule. A valid order is not necessarily unique.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Compute in-degree and out-degree for the example graph. 2. Run Kahn’s algorithm by hand and show the queue after each removal. 3. Add a cycle and explain why no ordering can satisfy it.

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** In u→v, which direction is traversable?
   **Answer:** From u to v; the reverse edge is not implied.
2. **Question:** What is in-degree?
   **Answer:** The number of incoming edges at a vertex.
3. **Question:** When does a topological order exist?
   **Answer:** For a directed acyclic graph.
4. **Question:** Which vertices enter Kahn’s queue first?
   **Answer:** All vertices with in-degree zero.
5. **Question:** How does Kahn detect a cycle?
   **Answer:** It emits fewer than V vertices before the queue becomes empty.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [Princeton Algorithms — Directed Graphs](https://algs4.cs.princeton.edu/42digraph/)
- [CP-Algorithms — Topological sorting](https://cp-algorithms.com/graph/topological-sort.html)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [NIST Dictionary — directed graph](https://xlinux.nist.gov/dads/HTML/directedGraph.html)
- [Stanford CS161 — Data Structures and Algorithms](https://web.stanford.edu/class/cs161/)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
