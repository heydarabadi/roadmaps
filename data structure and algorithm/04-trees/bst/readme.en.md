# Binary Search Tree (BST)

> Course: [Chapter 4](../readme.en.md) · [Original Persian lesson](readme.md) · Prerequisites: binary trees, comparisons, and recursion or loops

## Learning goals and prerequisites

You should be comfortable with binary trees, comparisons, and recursion or loops. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

A BST adds an ordering rule: keys in a node's left subtree are smaller, and keys in its right subtree are larger, under a chosen duplicate policy. Comparing at each node lets a search discard one subtree.

## Representation, contract, and invariant

The ordering applies to every key in a subtree, not just the immediate children. Validate with allowed ranges passed downward: left gets `(min,node.key)`, right gets `(node.key,max)`. If duplicates are allowed, choose a consistent rule such as a count, a designated side, or a composite key.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Search: compare at each node; go left for a smaller target, right for larger, stop on equality or null. Insert follows the same path and adds at the first empty child. Delete: remove a leaf directly; replace a one-child node with its child; with two children, copy the inorder successor (minimum of right subtree) and delete that successor.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

Insert 8,3,10,1,6,14,4,7,13. To delete 3, its inorder successor is 4; put 4 at its position, then remove the old 4 leaf. Inorder remains sorted.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

The successor is the smallest key greater than the deleted key, so replacing a two-child node preserves the ordering ranges. Each update must also preserve the range invariant for all affected descendants.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Search/insert/delete take O(h), where h is actual tree height. A balanced shape has h=Θ(log n); sorted insertions can produce h=Θ(n). Inorder traversal is O(n) and yields keys in ascending order.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

BSTs support ordered maps/sets, range queries, predecessor, and successor. Production libraries often use self-balancing trees to guarantee logarithmic height regardless of insertion order.

## Common mistakes and edge cases

A plain BST is not necessarily balanced. Direct-child checks miss deeper violations. Decide how duplicates are represented. Deleting a two-child node requires removing the replacement from its old position as well.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Compare heights after inserting 1..6 in sorted order versus 4,2,6,1,3,5. 2. Validate a proposed BST using ranges, not only direct children. 3. Trace deletion of a two-child node using successor replacement.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What is the global BST property?
   **Explained answer:** Every key in the left subtree is smaller and every key in the right subtree larger, per the duplicate policy.
2. **Question:** Why validate with ranges?
   **Explained answer:** A deeper descendant may violate an ancestor's ordering even if it fits its parent.
3. **Question:** What is operation cost?
   **Explained answer:** O(h), the actual height.
4. **Question:** What is worst-case height?
   **Explained answer:** Θ(n), for a chain-shaped tree.
5. **Question:** Why does inorder yield sorted keys?
   **Explained answer:** It visits the left range, node key, then right range under the BST invariant.

## Further reading and references

- [Princeton Algorithms, Chapter 3.2: Binary Search Trees](https://algs4.cs.princeton.edu/32bst/) — BST search, insertion, deletion, and ordered operations.
- [USFCA BST visualization](https://www.cs.usfca.edu/~galles/visualization/BST.html) — Step-through BST operations.
- [Java TreeMap API](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/TreeMap.html) — A production navigable ordered map.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Search trees and balancing concepts.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
