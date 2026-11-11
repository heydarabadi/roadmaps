# Breadth-First Search (BFS)

> Path: [Chapter 5 — Graphs](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/05-graphs/bfs/README.md) · Suggested prerequisites: Adjacency lists, a FIFO queue, and a visited set.

## Prerequisites and mental model

Adjacency lists, a FIFO queue, and a visited set. Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

BFS expands outward from a source in layers. In an unweighted graph—or one where every edge has the same cost—it finds shortest paths by number of edges. The FIFO queue ensures every vertex at distance d is processed before any vertex at distance d+1.

## Representation, contract, and invariant

Set dist[s]=0. When u first discovers v, assign dist[v]=dist[u]+1 and parent[v]=u. Because discovery happens in nondecreasing distance order, the first recorded distance is minimal. In a directed graph, follow only outgoing edges.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

Initialize a queue with s and mark s visited. While the queue is not empty, dequeue u. For each neighbor v of u that is unvisited, mark v immediately, set its distance and parent, and enqueue it. To rebuild a path, follow parent links from the target to s and reverse the result. For multiple sources, initialize the queue with all sources at distance zero.

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

Let S connect to A and B; A connects to C; B connects to D; and both C and D connect to T. The queue starts [S], then [A,B], then [C,D], and T is first discovered at distance 3. S–A–C–T is a shortest path; the equally long route through B may be found depending on neighbor order.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

When a vertex at distance d is dequeued, all vertices at smaller distance have already been processed. Any path to an undiscovered vertex with fewer than d+1 edges would have exposed it from an earlier layer. Thus the first discovery records the minimum edge count.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

Adjacency-list BFS takes O(V+E) time and O(V) auxiliary space. With a matrix it takes O(V²) time. The shortest-path claim is about edge count, not total weight. For weights restricted to 0 and 1, use 0–1 BFS with a deque; for general nonnegative weights, use Dijkstra.

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

Minimum hops in communication/social graphs, shortest routes on unweighted grids, nearest facility by number of transitions, and level-order traversal. Multi-source BFS finds distance to the nearest member of a source set.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

Mark vertices visited when enqueuing, not only when dequeuing, or the same vertex can enter the queue many times. BFS is not correct for arbitrary unequal weights. Unreachable vertices keep an infinite/unset distance. Ensure an undirected edge is stored in both directions.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Trace queue, dist, and parent on a six-vertex graph. 2. Adapt the initialization for several hospitals as sources. 3. Construct a weighted counterexample where BFS chooses more total cost than another route.

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What data structure drives BFS?
   **Answer:** A FIFO queue.
2. **Question:** What shortest path does it guarantee?
   **Answer:** A path with the fewest edges in an unweighted/equal-cost graph.
3. **Question:** What is the adjacency-list time complexity?
   **Answer:** O(V+E).
4. **Question:** When should visited be set?
   **Answer:** When a vertex is first enqueued.
5. **Question:** What should be used for arbitrary nonnegative weights?
   **Answer:** Dijkstra’s algorithm, not ordinary BFS.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [CP-Algorithms — Breadth-First Search](https://cp-algorithms.com/graph/breadth-first-search.html)
- [Princeton Algorithms — Breadth-First Search](https://algs4.cs.princeton.edu/41graph/)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [CP-Algorithms — 0–1 BFS](https://cp-algorithms.com/graph/01_breadth-first-search.html)
- [NIST Dictionary — breadth-first search](https://xlinux.nist.gov/dads/HTML/breadthfirst.html)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
