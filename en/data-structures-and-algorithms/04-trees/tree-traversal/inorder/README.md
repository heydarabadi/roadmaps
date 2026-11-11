# Inorder Traversal

> Course: [Chapter 4](../README.md) · [Original Persian lesson](../../../../../fa/data-structures-and-algorithms/04-trees/tree-traversal/inorder/README.md) · Prerequisites: binary trees and, for sorted output, the BST invariant

## Learning goals and prerequisites

You should be comfortable with binary trees and, for sorted output, the BST invariant. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Inorder processes Left → Node → Right. It yields sorted keys only when the input is a binary search tree with a comparator consistent with its ordering rule.

## Representation, contract, and invariant

A null node does nothing. For a non-null node, recursively traverse left, visit the node, then traverse right. An iterative form stores the path while walking left, pops and visits, then moves into the right subtree.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Recursive: `in(node): if node==null return; in(node.left); visit(node); in(node.right)`. Iterative: set current=root; push the left chain; pop/visit; continue at current.right until both current and stack are empty.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

For a BST rooted at 8, with left subtree 3 (children 1 and 6) and right child 10, output is `1,3,6,8,10`. The same traversal of an arbitrary binary tree is not necessarily sorted.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

When a node is visited, its whole left subtree has already been output and its right subtree has not. The BST invariant places every left key below the node and every right key above it, so the complete output is sorted.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Time O(n); recursive or iterative stack space O(h). To find the k-th smallest, count visits and stop at k instead of storing every output.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Inorder iteration produces ordered map/set entries, supports rank selection, and can scan key ranges without sorting the output separately.

## Common mistakes and edge cases

Inorder on a general binary tree is not a sorting operation. Keep the BST comparator consistent between insertion and traversal. For a range query, begin at a lower bound and stop once values exceed the upper bound.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Use inorder to find the third-smallest key without materializing the full list. 2. Trace the iterative stack for root 8. 3. What BST violation would make the output unsorted?

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What is the order?
   **Explained answer:** Left, Node, Right.
2. **Question:** What makes inorder sorted?
   **Explained answer:** The BST ordering invariant, not the traversal alone.
3. **Question:** How can we find the k-th smallest?
   **Explained answer:** Count visits during inorder and stop at visit k.
4. **Question:** What is stack space?
   **Explained answer:** O(h).
5. **Question:** How does inorder help with a range query?
   **Explained answer:** Start from the lower bound and stop after passing the upper bound.

## Further reading and references

- [Princeton Algorithms, Chapter 3.2](https://algs4.cs.princeton.edu/32bst/) — BST inorder traversal and ordered operations.
- [USFCA BST visualization](https://www.cs.usfca.edu/~galles/visualization/BST.html) — Animated inorder traversal of a BST.
- [Java NavigableMap API](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/NavigableMap.html) — Ordered-map boundary and range operations.
- [Open Data Structures: Binary Search Trees](https://opendatastructures.org/ods-java/6_Binary_Trees.html) — BST properties and ordered traversal.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
