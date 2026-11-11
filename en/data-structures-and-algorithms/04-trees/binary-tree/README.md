# Binary Tree

> Course: [Chapter 4](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/04-trees/binary-tree/README.md) · Prerequisites: recursion, references, and basic tree terminology

## Learning goals and prerequisites

You should be comfortable with recursion, references, and basic tree terminology. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

A rooted tree organizes nodes by parent/child relationships. A binary tree gives each node at most two ordered child slots, left and right. It need not be sorted or balanced.

## Representation, contract, and invariant

The root has no parent; a leaf has no children. Depth counts edges from the root; height counts edges on a longest path to a leaf (some texts count nodes instead, so state the convention). Complete, perfect, and balanced describe different shape constraints, not synonyms.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

A node can be represented as `Node(value, left, right)`. Recursive traversals need a null base case. Size obeys `size(node)=1+size(left)+size(right)`; height obeys `1+max(height(left),height(right))`, under a consistent empty-tree convention.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

Let A have children B and C; let B have right child D. The depth of D is two edges. Preorder is A,B,D,C; inorder is B,D,A,C; postorder is D,B,C,A; level order is A,B,C,D.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

Each node belongs to at most one parent in a tree, and following child links does not cycle. A recursive call handles exactly its subtree; the null case returns the identity result for that computation.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

A full traversal is O(n), because every node is processed a constant number of times. Recursive auxiliary stack is O(h), where h is height; a skewed tree can have h=Θ(n). A plain binary tree offers no logarithmic search guarantee.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

DOMs, syntax trees, organizational hierarchies, and decision trees use tree-shaped relationships. A real model must specify whether children are ordered and whether there are constraints on their number or keys.

## Common mistakes and edge cases

Do not equate binary tree with binary search tree, or complete with balanced. A malformed cycle or shared child turns the structure into a graph/DAG and may require a visited set. Deep recursion can overflow the stack.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. For root A with children B,C and B with D,E, list all four traversals. 2. Compute height and leaf count. 3. Give shapes achieving minimum and maximum height for n nodes.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What limits a binary tree node?
   **Explained answer:** It has at most two ordered child slots, left and right.
2. **Question:** Is every binary tree a BST?
   **Explained answer:** No; a BST adds an ordering invariant.
3. **Question:** How long does traversal take?
   **Explained answer:** O(n) for n nodes.
4. **Question:** What determines recursive stack space?
   **Explained answer:** Tree height h, worst-case O(n).
5. **Question:** Are perfect and complete trees identical?
   **Explained answer:** No; they impose different shape constraints.

## Further reading and references

- [Princeton Algorithms, Chapter 3.2](https://algs4.cs.princeton.edu/32bst/) — Binary tree nodes, recursion, and ordered trees.
- [USFCA tree visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Animated binary-tree and traversal examples.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Binary tree structure and traversal.
- [Open Data Structures: Binary Trees](https://opendatastructures.org/ods-java/6_Binary_Trees.html) — Textbook chapter on binary-tree structures.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
