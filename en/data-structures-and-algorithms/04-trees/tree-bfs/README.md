# Tree Breadth-First Search (BFS)

> Course: [Chapter 4](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/04-trees/tree-bfs/README.md) · Prerequisites: FIFO queues, tree nodes, and parent/level maps

## Learning goals and prerequisites

You should be comfortable with FIFO queues, tree nodes, and parent/level maps. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

BFS expands the root's neighborhood one level at a time. In a tree, it visits nodes in increasing depth. In a graph, it also needs a visited set to prevent cycles and repeated work.

## Representation, contract, and invariant

A queue holds the frontier. Set `level[root]=0`. When first discovering child v of u, set `level[v]=level[u]+1` and `parent[v]=u`, then enqueue v. In a tree with unique parent paths, a visited set is optional; in a general graph it is required.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Initialize a queue with root. While nonempty, dequeue u; if it is the target, reconstruct the path through parent links; otherwise for each unseen child/neighbor, mark it seen, record parent/level, and enqueue it. Mark at enqueue time, not dequeue time.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

For root S with children A,B and A with children C,D: queue `[S]`; process S→`[A,B]`; process A→`[B,C,D]`; then B, C, D. A goal first found at depth d has a minimum-edge path when every edge has equal cost.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

The queue is ordered by nondecreasing distance. When a node is first enqueued, its recorded path uses the fewest edges; all shallower nodes have already been processed. This proof assumes unweighted/equal-cost edges.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

On a tree, time O(n), queue space O(w) for maximum width w. On an adjacency-list graph, O(V+E) time and O(V) visited/parent state. Unequal edge weights require a weighted shortest-path algorithm instead.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

BFS finds the minimum number of hops in unweighted networks, nearest facilities on grid maps, and level/depth relationships in trees. File-system traversal must account for symbolic links that can create cycles.

## Common mistakes and edge cases

Mark nodes when enqueued so multiple neighbors cannot add them repeatedly. BFS minimizes edge count, not total weight. Consider disconnected nodes unreachable from the root, and define their distance as absent/infinity.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Trace the queue and level for a three-level tree. 2. Record parent links and reconstruct a shortest path. 3. Give a counterexample showing BFS is not minimum-cost with unequal weights.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What data structure drives BFS?
   **Explained answer:** A FIFO queue.
2. **Question:** What does BFS minimize in an unweighted graph?
   **Explained answer:** Number of edges in the path.
3. **Question:** Why mark a node at enqueue time?
   **Explained answer:** To prevent it from being queued multiple times.
4. **Question:** What is graph complexity with adjacency lists?
   **Explained answer:** O(V+E).
5. **Question:** Does BFS solve unequal-weight shortest paths?
   **Explained answer:** No; use a weighted algorithm such as Dijkstra when weights are nonnegative.

## Further reading and references

- [CP-Algorithms: Breadth-First Search](https://cp-algorithms.com/graph/breadth-first-search.html) — BFS invariants and shortest paths in unweighted graphs.
- [Princeton Algorithms, Chapter 4.1](https://algs4.cs.princeton.edu/41graph/) — Graph traversal and paths.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Breadth-first graph search.
- [USFCA graph visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Animated graph and tree traversals.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
