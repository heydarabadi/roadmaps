# Postorder Traversal

> Course: [Chapter 4](../README.md) · [Original Persian lesson](../../../../../fa/data-structures-and-algorithms/04-trees/tree-traversal/postorder/README.md) · Prerequisites: binary trees, recursion, and subtree results

## Learning goals and prerequisites

You should be comfortable with binary trees, recursion, and subtree results. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Postorder processes Left → Right → Node. When a node is visited, both child subtrees have already been processed.

## Representation, contract, and invariant

Return immediately for null. For each non-null node, recursively process its left and right children, then visit the node. An iterative version can use two stacks or an explicit visited/state marker.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

`post(node): if node==null return; post(node.left); post(node.right); visit(node)`. For an expression tree, compute the child results before applying the operator at the parent.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

For A with children B,C and B with D,E, output is `D,E,B,C,A`. To free a manually managed tree, release children before their parent so their links can still be followed.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

Before visiting a node, both subtree computations are complete. Thus any result defined from child results—size, hash, or expression value—can be computed at the parent.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Time O(n); recursive stack O(h). A stored traversal output needs an additional O(n) for the output itself.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Postorder supports deleting hierarchical structures, evaluating expression trees, and computing values that depend on complete child subtrees.

## Common mistakes and edge cases

Place `visit` after both recursive calls. Test empty and singleton trees. Garbage collection may reclaim nodes automatically, but external resources or filesystem children can still require postorder cleanup.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Write postorder for a seven-node tree. 2. Build an expression tree for `(2+3)×4` and evaluate it postorder. 3. Explain why directory cleanup usually removes children before the directory itself.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What is the order?
   **Explained answer:** Left, Right, Node.
2. **Question:** Why is postorder useful for computing a parent value?
   **Explained answer:** Both child results are available first.
3. **Question:** Why free children before their parent?
   **Explained answer:** The parent's child links are needed to reach them.
4. **Question:** What is the time?
   **Explained answer:** O(n).
5. **Question:** What is recursive stack space?
   **Explained answer:** O(h).

## Further reading and references

- [Princeton Algorithms, Chapter 3.2](https://algs4.cs.princeton.edu/32bst/) — Recursive tree traversal concepts.
- [USFCA tree visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Traversal demonstrations.
- [Open Data Structures: Binary Trees](https://opendatastructures.org/ods-java/6_Binary_Trees.html) — Tree structure and traversal examples.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Tree algorithms and recursive reasoning.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
