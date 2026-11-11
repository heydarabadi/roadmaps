# Preorder Traversal

> Course: [Chapter 4](../README.md) · [Original Persian lesson](../../../../../fa/data-structures-and-algorithms/04-trees/tree-traversal/preorder/README.md) · Prerequisites: binary trees and recursion or an explicit stack

## Learning goals and prerequisites

You should be comfortable with binary trees and recursion or an explicit stack. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Preorder processes the current node first, then the left subtree, then the right: Node → Left → Right. A subtree's output begins with that subtree's root.

## Representation, contract, and invariant

For a non-null node, visit it before recursing into either child; return immediately for null. An iterative stack version pushes right before left so left is popped and processed first.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Recursive: `pre(node): if node==null return; visit(node); pre(node.left); pre(node.right)`. Iterative: push root; pop and visit; push right child, then left child.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

For A with children B,C, and B with right child D, output is A,B,D,C. Preorder serialization needs explicit null markers (or another shape convention) to reconstruct missing-child positions unambiguously.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

The root of each subtree is emitted before all descendants, and the recursive calls emit the two child subtrees in order. Each node is visited once, so the traversal is complete and linear.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Time O(n); recursion stack O(h), explicit DFS stack usually O(h) for a tree traversal. If saving the output, the output itself uses O(n) space.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Preorder is useful when a parent must be emitted before its children, including tree copying, serialization, and prefix-form expression output.

## Common mistakes and edge cases

Push children in the order needed for a LIFO stack. A graph with shared descendants is not a tree; it may need identity/visited handling to avoid repeated visits. Do not assume preorder alone encodes shape.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Write preorder for a tree with seven nodes. 2. Trace the iterative stack. 3. Show why preorder values without null markers may not uniquely encode shape.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What is the order?
   **Explained answer:** Node, Left, Right.
2. **Question:** What should be pushed first for left-first iterative traversal?
   **Explained answer:** Push right first, then left.
3. **Question:** What is the time?
   **Explained answer:** O(n).
4. **Question:** What is needed to serialize shape unambiguously?
   **Explained answer:** Null markers or an equivalent shape encoding.
5. **Question:** Name a use.
   **Explained answer:** Parent-first serialization, cloning, or prefix-expression output.

## Further reading and references

- [Princeton Algorithms, Chapter 3.2](https://algs4.cs.princeton.edu/32bst/) — Tree recursion and ordered traversal.
- [USFCA tree visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Preorder and tree traversal demonstrations.
- [OpenDSA book catalog](https://opendsa.cs.vt.edu/home/booksBinaryTree.html) — browse the interactive book listings for tree and traversal modules.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Tree algorithms and recursion.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
