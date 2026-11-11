# Depth-First Search (DFS)

> Path: [Chapter 5 — Graphs](../readme.en.md) · [Persian lesson](readme.md) · Suggested prerequisites: Graphs, adjacency lists, recursion or an explicit stack.

## Prerequisites and mental model

Graphs, adjacency lists, recursion or an explicit stack. Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

DFS follows one branch as far as possible, then backtracks. It is useful for reachability, connected components, cycle detection, topological ordering, and many graph-structure analyses. It does not in general find a shortest path.

## Representation, contract, and invariant

A visited set prevents repeated processing. For directed-cycle detection, use white (unseen), gray (active on the recursion path), and black (finished) states; an edge to a gray vertex reveals a cycle. In an undirected graph, ignore the edge back to the parent when checking for a cycle.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

Recursive form: mark u visited; for every neighbor v, recursively visit v if unseen. To cover a disconnected graph, run DFS from every still-unseen vertex. Iterative form uses a stack; because a stack is LIFO, push neighbors in reverse order if you want the same visitation order as a left-to-right recursive traversal.

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

For S→A,B and A→C, adjacency order can produce S,A,C,B. If A can also reach S, visited prevents the traversal from recursing around the cycle indefinitely. The chosen path depends on neighbor order and is not necessarily the minimum-edge path.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

A vertex is marked before its outgoing edges are explored, so a cycle cannot cause unbounded revisiting. When DFS finishes u, it has explored every outgoing edge from u and every newly reachable descendant reached through those edges. The gray/black distinction identifies edges to the active path versus already-completed subgraphs.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

With adjacency lists, DFS takes O(V+E) time and O(V) auxiliary memory. Recursive stack depth can reach O(V); on deep input, an iterative implementation avoids runtime recursion limits. Matrix-based neighbor scanning raises the traversal cost to O(V²).

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

Dependency-cycle detection, component labeling, flood fill, topological sorting in a DAG, spanning forests, and strongly connected component algorithms. DFS is a building block; the desired result often needs timestamps, low-link values, or parent links as well as visited.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

Without visited, a cyclic graph can loop forever. A single visited boolean is insufficient for the classic directed back-edge test; active state matters. Mark timing and neighbor order affect the exact output. Do not claim DFS provides shortest paths.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Record discovery and finish times for a DAG. 2. Detect a cycle in A→B→C→A using gray/black states. 3. Give a graph where DFS finds a longer route than BFS.

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** How does DFS explore?
   **Answer:** It follows a branch deeply, then backtracks.
2. **Question:** Does DFS guarantee a shortest path?
   **Answer:** No.
3. **Question:** What does gray mean in directed DFS?
   **Answer:** The vertex is still on the active recursion path.
4. **Question:** What is the adjacency-list complexity?
   **Answer:** O(V+E).
5. **Question:** How do you traverse a disconnected graph completely?
   **Answer:** Start DFS from each vertex that remains unseen.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [CP-Algorithms — Depth-First Search](https://cp-algorithms.com/graph/depth-first-search.html)
- [Princeton Algorithms — Depth-First Search](https://algs4.cs.princeton.edu/41graph/)
- [CP-Algorithms — Topological sorting](https://cp-algorithms.com/graph/topological-sort.html)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [NIST Dictionary — depth-first search](https://xlinux.nist.gov/dads/HTML/depthfirst.html)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
