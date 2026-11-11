# Tree Depth-First Search (DFS)

> Course: [Chapter 4](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/04-trees/tree-dfs/README.md) · Prerequisites: trees, recursion or stacks, and loop invariants

## Learning goals and prerequisites

You should be comfortable with trees, recursion or stacks, and loop invariants. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

DFS follows one branch as far as possible, then backtracks. Recursion uses the call stack implicitly; an iterative implementation uses an explicit stack. Neighbor order determines the exact visitation order.

## Representation, contract, and invariant

For a tree, common DFS orders are preorder, inorder, and postorder. For a general graph, use `visited`; directed-cycle detection often distinguishes white (unseen), gray (currently active), and black (finished) nodes.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Recursive form: `dfs(u)`: if null return; mark/visit u; for each child or unseen neighbor v, recurse. Iterative form: push root; repeatedly pop and visit; push neighbors in reverse order if you want to match a left-first recursive traversal.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

With A having children B,C and B having child D, a left-first preorder DFS visits A,B,D,C. For an explicit LIFO stack, push C before B so B is popped first.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

Mark a graph node when its DFS frame begins, preventing cycles from recursing forever. When the call for u finishes, all nodes reached through its DFS exploration have been considered. In a directed graph, an edge to a gray node identifies a back edge and a cycle.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Tree traversal time is O(n); recursive stack O(h), worst-case O(n) for a skewed tree. Graph DFS with adjacency lists is O(V+E), using O(V) visited and stack/recursion state.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

DFS is used for reachability, connected components, cycle detection, topological ordering of DAGs, flood fill, and recursive tree computation. It is not a substitute for BFS when minimum hop count is required.

## Common mistakes and edge cases

Without visited, a cyclic graph can loop forever. For undirected cycle detection, ignore the edge back to the parent. Stack push order changes the visitation order; very deep recursion may overflow.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Compare preorder and postorder on a tree. 2. Trace DFS colors on A→B→C→A. 3. Add a depth field to iterative DFS. 4. Explain why DFS does not guarantee a shortest path.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** How does DFS explore?
   **Explained answer:** It follows a path deeply and backtracks when needed.
2. **Question:** When is a visited set essential?
   **Explained answer:** For graphs with cycles or multiple routes to a node.
3. **Question:** Does DFS find a shortest path?
   **Explained answer:** Not in general; use BFS for unweighted shortest paths.
4. **Question:** Why push neighbors in reverse for iterative DFS?
   **Explained answer:** A LIFO stack pops the last pushed neighbor first.
5. **Question:** What is graph DFS time?
   **Explained answer:** O(V+E) with an adjacency-list representation.

## Further reading and references

- [CP-Algorithms: Depth-First Search](https://cp-algorithms.com/graph/depth-first-search.html) — DFS states, timestamps, and cycle edges.
- [Princeton Algorithms, Chapter 4.1](https://algs4.cs.princeton.edu/41graph/) — Depth-first search and graph traversal.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — DFS and graph algorithms.
- [USFCA graph visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Animated depth-first graph traversal.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
