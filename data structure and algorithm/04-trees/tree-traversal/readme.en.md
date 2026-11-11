# Tree Traversal

> Course: [Chapter 4](../readme.en.md) · [Original Persian lesson](readme.md) · Prerequisites: binary trees, recursion, and queues

## Learning goals and prerequisites

You should be comfortable with binary trees, recursion, and queues. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Traversal visits every tree node in a defined order. The order determines what information is available at visit time: before children, between children, after children, or by level.

## Representation, contract, and invariant

Depth-first orders: preorder = Node, Left, Right; inorder = Left, Node, Right; postorder = Left, Right, Node. Level order is breadth-first search using a queue. The first three are DFS variants; level order is BFS.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Recursive DFS: if node is null, return; place `visit(node)` before, between, or after recursive calls according to the desired order. BFS: enqueue the root; while the queue is nonempty, dequeue and visit a node, then enqueue its existing children.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

For root A with children B,C and B with D,E, preorder is A,B,D,E,C; inorder is D,B,E,A,C; postorder is D,E,B,C,A; level order is A,B,C,D,E.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

Each DFS call is responsible for exactly one subtree, so every node is visited once. In BFS, the queue contains nodes in nondecreasing distance from the root, which yields level order.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

All traversals take O(n) time. Recursive DFS uses O(h) stack. BFS uses O(w), where w is the maximum tree width and can be Θ(n). Iterative DFS uses a stack proportional to the frontier/depth.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Preorder is useful for serialization and parent-first output, inorder for ordered BST iteration, postorder for subtree computation/cleanup, and level order for layer-by-layer output.

## Common mistakes and edge cases

Inorder is sorted only for a BST, not an arbitrary binary tree. Define behavior on null trees. An array `pop(0)` can make BFS quadratic; use a queue/deque. Deep recursion may overflow.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. List the four orders for a seven-node tree. 2. Why is postorder natural for deleting a tree? 3. What extra marker is needed for a preorder serialization to reconstruct missing children unambiguously?

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** Which traversal visits the node before its children?
   **Explained answer:** Preorder.
2. **Question:** Which traversal gives sorted output for a BST?
   **Explained answer:** Inorder.
3. **Question:** Which traversal is level-by-level?
   **Explained answer:** BFS/level order with a FIFO queue.
4. **Question:** What determines BFS space?
   **Explained answer:** The maximum width of the tree/frontier.
5. **Question:** Why use postorder for deleting subtrees?
   **Explained answer:** Children are processed before their parent.

## Further reading and references

- [Princeton Algorithms, Chapter 3.2](https://algs4.cs.princeton.edu/32bst/) — Tree recursion and inorder operations.
- [USFCA tree visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Binary-tree and traversal animations.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Tree and graph traversal concepts.
- [Open Data Structures: Binary Trees](https://opendatastructures.org/ods-java/6_Binary_Trees.html) — Tree traversals and properties.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
