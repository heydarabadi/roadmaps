# AVL Tree

> Course: [Chapter 4](../readme.en.md) · [Original Persian lesson](readme.md) · Prerequisites: BST ordering, node heights, and rotations

## Learning goals and prerequisites

You should be comfortable with BST ordering, node heights, and rotations. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

An AVL tree is a self-balancing BST. At every node, the heights of the left and right children differ by at most one, keeping tree height logarithmic and ordered operations worst-case O(log n).

## Representation, contract, and invariant

Define `balanceFactor = height(left) − height(right)`; valid values are −1, 0, and +1. Insertion can create the first imbalance on the path back to the root. Four shapes—LL, RR, LR, and RL—are repaired with one or two rotations.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

After insertion, update heights on the return path. If BF>1 and the inserted key lies in the left child's left subtree, rotate right (LL). If BF<−1 and it lies in the right child's right subtree, rotate left (RR). LR is left-rotate the child then right-rotate the node; RL is the mirror. Deletion may require rebalancing multiple ancestors.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

Insert 30,20,10. Node 30 gets BF=2, a left-left case. Rotate right at 30: 20 becomes the root, with 10 on the left and 30 on the right. Inorder remains 10,20,30, while height drops.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

A rotation preserves inorder key order because it changes only a local parent/child arrangement. Recompute lower-node heights before higher-node heights; the selected rotation restores the AVL height condition in the affected subtree.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Search, insert, and delete are worst-case O(log n). Each rotation changes O(1) pointers; the update walks O(log n) ancestors. Storing heights/balance factors adds O(n) metadata.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

AVL trees suit in-memory ordered maps when predictable lookup height matters. They maintain stricter height balance than some alternatives, which can make updates involve more rebalancing work.

## Common mistakes and edge cases

Update heights in bottom-up order. For LR/RL, use the child balance to select both rotations. Do not assume deletion stops after one repair as insertion often can. Rotations must preserve the BST order as well as the AVL height constraint.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Construct LL, RR, LR, and RL insert sequences and draw each repair. 2. Recompute heights from the bottom after every rotation. 3. Why may deletion trigger repair at several ancestors?

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What is the AVL balance condition?
   **Explained answer:** The two child-subtree heights differ by at most one at every node.
2. **Question:** How is an LL case repaired?
   **Explained answer:** By a right rotation at the unbalanced node.
3. **Question:** How is an LR case repaired?
   **Explained answer:** Left-rotate the left child, then right-rotate the node.
4. **Question:** What is operation complexity?
   **Explained answer:** O(log n) worst-case.
5. **Question:** How can deletion differ from insertion?
   **Explained answer:** Rebalancing may be needed at several ancestors up to the root.

## Further reading and references

- [MIT 6.006 lecture notes: AVL trees](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Course notes include binary trees and AVL balancing.
- [USFCA AVL visualization](https://www.cs.usfca.edu/~galles/visualization/AVLtree.html) — Rotations and balance-factor changes.
- [Princeton Algorithms, Chapter 3.3](https://algs4.cs.princeton.edu/33balanced/) — Balanced search-tree concepts and rotations.
- [OpenDSA book catalog](https://opendsa.cs.vt.edu/home/booksAVL.html) — browse the interactive book listings for tree and balancing modules.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
