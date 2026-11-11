# Chapter 5 — Graphs and Graph Algorithms

> [Persian chapter](readme.md) · [Course index](../readme.en.md)

Model relationships precisely, then select a traversal or optimization algorithm that matches direction, edge weights, density, and the requested objective.

## Algorithm selection guide

| Question | Typical choice |
|---|---|
| Reachability or connected components | DFS or BFS |
| Shortest path when all edges have equal cost | BFS |
| Nonnegative weighted shortest paths from one source | Dijkstra |
| Negative weights and reachable negative-cycle detection | Bellman–Ford |
| One target plus a valid lower-bound heuristic | A* |
| Connect every vertex with minimum total edge weight | Prim or Kruskal |

## Worked decision: a road network

Let intersections be vertices and roads be edges. Record one-way streets as directed edges; assign travel time as the weight. If travel times are nonnegative, Dijkstra finds minimum-time routes. With a target and a heuristic that never overestimates remaining travel cost, A* can guide the search toward that target. If every road counts equally and we want the fewest roads, BFS is enough. If the goal is to connect all towns with the least total cable cost, that is an MST problem; shortest-path algorithms solve a different objective.

## Roadmap parent lesson: Graph Data Structures

Choose vertices and edges to match the domain, then specify direction, weight, parallel edges, and self-loops. An adjacency list uses O(V+E) space and is effective for sparse graphs and neighbor traversal. An adjacency matrix uses O(V²) space but answers whether an edge exists in O(1). For an undirected graph, list entries or matrix values must be symmetric.

**Self-check**

1. When is an adjacency list a natural choice? A sparse graph where traversing neighbors is common.
2. What is an edge-presence lookup in an adjacency matrix? O(1).
3. What must a graph model specify? Vertices, edges, direction, weights, and adjacency semantics.

## Roadmap parent lesson: Graph Search Algorithms

BFS uses a queue and expands the frontier layer by layer. DFS uses a stack or recursion and follows a branch before backtracking. With an adjacency list, both take O(V+E). Mark a vertex visited when it is first enqueued/pushed. BFS finds a path with the fewest edges only when edges are unweighted or equal-cost; DFS does not generally find shortest paths.

**Self-check**

1. Which traversal is layer-by-layer? BFS.
2. What is BFS’s natural control structure? A FIFO queue.
3. Why is `visited` needed? To prevent repeated work and infinite traversal through cycles.

## Roadmap parent lesson: Shortest-Path Algorithms

Shortest path minimizes the sum of edge weights. Use Dijkstra when every weight is nonnegative, Bellman–Ford when negative weights must be allowed and reachable negative cycles detected, and A* for a target-directed search with an admissible heuristic. Relaxation updates a distance when a shorter route is found; parent pointers reconstruct a path.

**Self-check**

1. Which algorithm detects a reachable negative cycle? Bellman–Ford.
2. What is Dijkstra’s key precondition? All edge weights are nonnegative.
3. What guides A* toward a target? `f(n)=g(n)+h(n)`, where h estimates remaining cost.

## Roadmap parent lesson: Minimum Spanning Tree

An MST connects all vertices of a connected, undirected weighted graph with minimum total edge weight and no cycle. Prim grows one tree by taking its cheapest outgoing edge; Kruskal sorts edges and uses disjoint sets to avoid cycles. A disconnected input produces a minimum spanning forest instead.

**Self-check**

1. What is an MST optimizing? Total connection weight over a spanning tree.
2. Which algorithm naturally uses Union-Find? Kruskal.
3. How many edges are in a tree with V vertices? V−1.

## Chapter review quiz

1. Why use a visited set in cyclic graphs? To prevent revisiting vertices and looping indefinitely.
2. Does BFS solve a weighted shortest-path problem with unequal weights? Not in general; use a weight-aware algorithm.
3. Why is Dijkstra invalid with negative edge weights? A vertex removed as minimum may later receive a shorter path through a negative edge.
4. What can invalidate A* optimality? A heuristic that overestimates, or an implementation that mishandles inconsistent heuristics.
5. Is an MST a shortest-path tree? No; MST minimizes total tree weight, while a shortest-path tree minimizes source-to-vertex path costs.
6. What does a disconnected graph return under a spanning-tree algorithm? A forest, not a single spanning tree.

## Further reading and references

- [MIT 6.006 — BFS, shortest paths, Bellman–Ford, and Dijkstra lectures](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)
- [CP-Algorithms — Breadth-First Search](https://cp-algorithms.com/graph/breadth-first-search.html)
- [CP-Algorithms — Dijkstra](https://cp-algorithms.com/graph/dijkstra.html)
- [CP-Algorithms — Bellman–Ford](https://cp-algorithms.com/graph/bellman_ford.html)
- [CP-Algorithms — Kruskal and MST](https://cp-algorithms.com/graph/mst_kruskal.html)
- [RFC 2328 — OSPF](https://www.rfc-editor.org/rfc/rfc2328)
- [Full bibliography](../references.en.md)

## Topic lessons

- [Graph Representations](graph-representation/readme.en.md)
- [Directed Graphs](directed-graph/readme.en.md)
- [Undirected Graphs](undirected-graph/readme.en.md)
- [BFS](bfs/readme.en.md)
- [DFS](dfs/readme.en.md)
- [Dijkstra](dijkstra/readme.en.md)
- [Bellman–Ford](bellman-ford/readme.en.md)
- [A*](a-star/readme.en.md)
- [Minimum Spanning Trees](mst/readme.en.md)
- [Prim](prim/readme.en.md)
- [Kruskal](kruskal/readme.en.md)

## Mastery standard

Given a network problem, define direction, weights, density, and goal; choose an algorithm with a stated reason; trace its queue, heap, distances, parents, or DSU state; and check disconnected inputs, cycles, parallel edges, and negative weights.
