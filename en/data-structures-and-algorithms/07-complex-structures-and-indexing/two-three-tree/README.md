# 2–3 Tree

> Path: [Chapter 7 — Complex Structures and Indexing](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/07-complex-structures-and-indexing/two-three-tree/README.md) · Suggested prerequisites: Binary search trees, ordered keys, and balanced-tree invariants.

## Prerequisites and mental model

Binary search trees, ordered keys, and balanced-tree invariants. These structures are specialized: start from the operation pattern and constraints, then decide whether the extra representation is justified.

## Core idea

A 2–3 tree is a balanced search tree in which an internal node is either a 2-node with one key/two children or a 3-node with two ordered keys/three children. All leaves have the same depth. Insertions and deletions preserve balance through splitting, borrowing, and merging rather than ordinary BST rotations.

## Representation, contract, and invariant

For a 2-node with key k, the left subtree contains keys <k and the right subtree keys >k. For a 3-node with keys a<b, its children represent ranges <a, between a and b, and >b. A temporary 4-node may appear during insertion and must be split.

An invariant is a structural property that must remain true after each operation. It is the bridge between the representation and the correctness proof.

## Step-by-step operations

Search compares within a node and chooses the child interval. Insert descends to the proper leaf and inserts the key in order. If a node overflows, promote its middle key and split the remaining keys into two nodes; propagate a parent overflow upward, creating a new root if necessary. During deletion, repair an underfull node by borrowing a key from a rich sibling or merging with a sibling and a parent separator.

Make contracts explicit for empty structures, duplicate keys, boundary values, and mutation. State any balancing, randomization, or page-size assumptions.

## Worked trace

Insert 12 into a node containing keys [10,15]. It temporarily becomes [10,12,15]. Promote 12 to the parent and leave two nodes containing 10 and 15. If the node was the root, the promoted key becomes a new root and the tree grows by one level.

Use a table with the operation, affected nodes/pages/indices, state before and after, and which invariant the step preserves.

## Why it works

Keys in each node remain sorted, each child represents the interval between adjacent separators, and every leaf remains at one common depth. Split, borrow, and merge operations are chosen to restore occupancy while preserving those ordering ranges and equal leaf depth.

Check initialization, preservation, and termination. If an operation changes multiple levels or parent separators, verify the invariant at every affected ancestor.

## Time and space analysis

All leaves remain at equal depth, so tree height is Θ(log n). Search, insertion, and deletion take O(log n) node visits. The structure is more complex than an ordinary BST but illustrates the multiway balancing ideas generalized by B-trees.

Report build cost separately from update and query costs. Keep average, expected, amortized, and worst-case claims distinct.

## Real-world applications and trade-offs

A pedagogical model for multiway balanced search and for understanding B-tree split/merge behavior. Pure 2–3 trees are less common as general-purpose implementations than red-black or B-tree variants.

Compare with a simpler array, map, tree, or scan. Data size, update frequency, page I/O, locality, memory overhead, and implementation complexity can change the practical choice.

## Common mistakes and edge cases

Do not leave a temporary 4-node in the final tree. During deletion, a parent separator may need to move along with a borrowed or merged key. State whether duplicate keys are permitted and where equal keys are routed.

Check empty input, one key, duplicates, split/merge boundaries, minimum/maximum key, and long update sequences. For disk structures, count overflow pages and page accesses.

## Exercises

1. Insert 5,10,15,12,20,25 one by one and draw each tree. 2. Construct a deletion that requires borrowing from a sibling. 3. Explain why all leaves stay at equal depth after a root split.

For each exercise, write the invariant and expected complexity before implementing it.

## Comprehensive quiz with explained answers

Try to answer first; then use the explanations to find any missing assumptions.

1. **Question:** What are the stable node types?
   **Answer:** A 2-node and a 3-node.
2. **Question:** What is true about all leaves?
   **Answer:** They are at the same depth.
3. **Question:** How is overflow repaired?
   **Answer:** Promote the middle key and split the node; propagate upward as needed.
4. **Question:** What is the operation time?
   **Answer:** O(log n).
5. **Question:** What broader structure does it help explain?
   **Answer:** B-trees and multiway balanced search trees.

## Mastery checklist

- [ ] I can draw the internal representation for a small input.
- [ ] I can trace search and at least one update step by step.
- [ ] I can state and preserve the structural invariant.
- [ ] I know the preconditions and expected versus worst-case guarantees.
- [ ] I can justify this structure over a simpler alternative for a workload.

## Further reading and references

The lesson is self-contained; these sources provide deeper theory, implementation details, and database context.

- [University of Maryland — 2–3 Trees lecture notes](https://www.cs.umd.edu/class/fall2020/cmsc420-0201/Lects/lect06-23tree.pdf)
- [University of Wisconsin — 2–3 Tree notes](https://pages.cs.wisc.edu/~vernon/cs367/notes/10.23TREE.html)
- [Duke University — 2–3 Tree operations](https://courses.cs.duke.edu/fall02/cps100/lects/oct31/23tree7.html)
- [Chinese University of Hong Kong — BST and 2–3 Tree notes](https://www.cse.cuhk.edu.hk/~taoyf/course/5610/22-spring/5610notes.pdf)
- [Rutgers — Data Structures lecture objectives](https://ds.cs.rutgers.edu/lectures/)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
