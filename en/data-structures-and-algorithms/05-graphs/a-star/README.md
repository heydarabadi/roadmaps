# A* Search

> Path: [Chapter 5 — Graphs](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/05-graphs/a-star/README.md) · Suggested prerequisites: BFS, Dijkstra, priority queues, and heuristic estimates.

## Prerequisites and mental model

BFS, Dijkstra, priority queues, and heuristic estimates. Start with the graph’s contract: what a vertex and edge mean, which directions can be followed, what each weight measures, and what counts as a valid answer.

## Core idea

A* is goal-directed graph search. For a node n, g(n) is the cost already paid and h(n) estimates the remaining cost; the frontier is ordered by f(n)=g(n)+h(n). With h=0, A* becomes Dijkstra. A useful heuristic reduces exploration without losing optimality if its assumptions hold.

## Representation, contract, and invariant

An admissible heuristic never overestimates the true least remaining cost: h(n)≤h*(n). A consistent heuristic additionally satisfies h(u)≤cost(u,v)+h(v) for every edge. In the classical setup h(goal)=0. Consistency makes f nondecreasing along a path and allows a settled/closed vertex to stay closed; with an inconsistent heuristic, an implementation may need to reopen vertices.

An invariant is a property that must stay true through every step. Write it down before implementing; it clarifies what state may change and why discarded alternatives are safe to discard.

## Step-by-step algorithm

Initialize g[start]=0 and push the start with priority g+h. Pop the smallest f; skip stale entries. If the goal is popped under the algorithm’s correctness conditions, reconstruct the route. For each neighbor v, compute tentative=g[u]+cost(u,v); if it improves g[v], update g and parent, then push v with priority tentative+h(v).

Pseudocode should be translated into the target language with the same edge, duplicate, and empty-graph conventions. Guard invalid vertex IDs and unreachable states explicitly.

## Worked trace

On a four-direction unit-cost grid, Manhattan distance |x−x_goal|+|y−y_goal| is admissible and consistent when obstacles can only add detours. A* tends to explore cells toward the target first. With h=0, the same graph and queue order reduce to Dijkstra.

For a paper trace, make a table with step, selected vertex/edge, frontier or component state, distance/parent or key, and the reason for each change. This catches stale heap entries, direction mistakes, and off-by-one errors.

## Why it works

An admissible heuristic makes f a lower bound on the cost of a solution through a frontier node. While some frontier node has f below the best goal cost, a cheaper solution may still exist. Once the optimal goal is selected under the standard assumptions and stopping rule, no unseen route can improve it.

Check initialization, preservation, and termination: the invariant is true before the first step, every update preserves it, and the stopping condition plus the invariant implies the required result.

## Time and space analysis

Worst-case time and memory can still be exponential in solution depth; heuristic quality dominates practical performance. With h=0, the standard Dijkstra bound applies. Do not promise a polynomial bound for arbitrary A* heuristics.

State whether the graph uses an adjacency list, matrix, or edge list; the same algorithm can have different costs under different representations. Report auxiliary memory separately from storage for the input graph.

## Real-world applications and trade-offs

Grid and map navigation, robot motion planning, and game pathfinding. Manhattan distance suits four-direction unit movement; other movement rules and weights require a matching lower-bound heuristic.

Model selection matters as much as algorithm selection. Before using a graph algorithm, write down whether edges are directed, weighted, mutable, duplicated, or disconnected, and whether the goal is reachability, route cost, or total network cost.

## Common mistakes and edge cases

An overestimating heuristic can return a suboptimal route. Geometric closeness does not automatically lower-bound travel cost. Do not permanently close nodes under an inconsistent heuristic unless the implementation supports reopening them. Keep g and h in compatible units.

Always consider an empty graph, one vertex, disconnected components, duplicate/parallel edges, self-loops, equal costs, and the weight values allowed by the problem.

## Exercises

1. Compare Manhattan and Chebyshev heuristics for four-way and eight-way movement. 2. Construct an overestimating heuristic that makes A* choose a nonoptimal path. 3. Set h=0 and explain why the algorithm becomes Dijkstra.

For each exercise, state the invariant and complexity, then trace a small input before implementing it.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What is A*’s priority function?
   **Answer:** f(n)=g(n)+h(n): cost so far plus estimated remaining cost.
2. **Question:** What does admissible mean?
   **Answer:** The heuristic never exceeds the true least remaining cost.
3. **Question:** What does h=0 produce?
   **Answer:** Dijkstra’s algorithm.
4. **Question:** Why can a heuristic reduce work?
   **Answer:** It orders the search toward the goal while preserving a lower bound.
5. **Question:** When might a previously closed node need reopening?
   **Answer:** With an inconsistent heuristic, a better route may be found later.

## Mastery checklist

- [ ] I can state the graph model and the algorithm’s preconditions.
- [ ] I can trace the frontier/state by hand and justify each update.
- [ ] I can prove the invariant and termination argument.
- [ ] I can analyze time and space for the chosen graph representation.
- [ ] I can identify a counterexample when a precondition is violated.

## Further reading and references

The lesson above is self-contained; these sources are for deeper study and implementation details.

- [Hart, Nilsson & Raphael, “A Formal Basis for the Heuristic Determination of Minimum Cost Paths” (1968)](https://ai.stanford.edu/~nilsson/OnlinePubs-Nils/PublishedPapers/astar.pdf)
- [Correction to the original A* paper](https://cse.sc.edu/~mgv/csce580sp15/astarHNR1972.pdf)
- [Stanford CS106B — Dijkstra and A*](https://web.stanford.edu/class/archive/cs/cs106b/cs106b.1258/lectures/26-graph-algorithms/)
- [Dijkstra and shortest paths — Princeton Algorithms](https://algs4.cs.princeton.edu/44sp/)
- [DOI record for Hart, Nilsson & Raphael (1968)](https://doi.org/10.1109/TSSC.1968.300136)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
