# B-Tree

> Path: [Chapter 7 — Complex Structures and Indexing](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/07-complex-structures-and-indexing/b-tree-complex/README.md) · Suggested prerequisites: Multiway search trees, disk pages, sorted keys, and split/merge operations.

## Prerequisites and mental model

Multiway search trees, disk pages, sorted keys, and split/merge operations. These structures are specialized: start from the operation pattern and constraints, then decide whether the extra representation is justified.

## Core idea

A B-tree generalizes balanced multiway search. Each node stores several sorted keys and child pointers, reducing height and disk/page accesses. It was designed for secondary storage, where one page read is much more expensive than several comparisons within a page.

## Representation, contract, and invariant

This lesson uses minimum degree t: a non-root node has at least t−1 and at most 2t−1 keys, and at most 2t children. Keys separate k+1 child ranges. All leaves have the same depth; the root has special minimum-occupancy rules. Other texts define “order” differently, so translate their definitions before comparing.

An invariant is a structural property that must remain true after each operation. It is the bridge between the representation and the correctness proof.

## Step-by-step operations

Search within a node for a matching key or the child interval to descend. A top-down insertion splits a full child before descending; its middle key moves into the parent. For deletion, borrow from a sibling or merge children with a separator so a minimum-occupancy child is not entered without enough keys for repair.

Make contracts explicit for empty structures, duplicate keys, boundary values, and mutation. State any balancing, randomization, or page-size assumptions.

## Worked trace

For t=2, a node can hold up to three keys and four children. A root [20,40] divides values into <20, 20–40, and >40 ranges. If a full child [25,30,35] splits, 30 is promoted and the child becomes [25] and [35], with the parent’s child ranges updated.

Use a table with the operation, affected nodes/pages/indices, state before and after, and which invariant the step preserves.

## Why it works

Sorted separators partition all key values into disjoint child ranges. Splits, borrowing, and merges maintain those ranges and the occupancy bounds. Equal leaf depth is preserved by splitting or merging at one level; only a root split increases the height.

Check initialization, preservation, and termination. If an operation changes multiple levels or parent separators, verify the invariant at every affected ancestor.

## Time and space analysis

Height is O(log_t n); lookup, insertion, and deletion visit O(log_t n) pages. A high fan-out t reduces page reads. Searching inside a node can use binary search or a short linear scan, depending on page layout and implementation.

Report build cost separately from update and query costs. Keep average, expected, amortized, and worst-case claims distinct.

## Real-world applications and trade-offs

Database and file-system indexes. A node is commonly designed around a storage page, so the tree minimizes page I/O. Buffer pools may keep upper levels cached, making page access at lower levels the main cost.

Compare with a simpler array, map, tree, or scan. Data size, update frequency, page I/O, locality, memory overhead, and implementation complexity can change the practical choice.

## Common mistakes and edge cases

Do not confuse minimum degree with order. Specify key/child occupancy bounds and root exceptions. B-tree and B+ tree layouts differ: in a B-tree, records or record pointers may occur in internal nodes as well as leaves.

Check empty input, one key, duplicates, split/merge boundaries, minimum/maximum key, and long update sequences. For disk structures, count overflow pages and page accesses.

## Exercises

1. For t=3, state the allowed key and child counts for a non-root node. 2. Choose insertions that split a child and then the root. 3. Estimate page reads on a root-to-leaf lookup with height four.

For each exercise, write the invariant and expected complexity before implementing it.

## Comprehensive quiz with explained answers

Try to answer first; then use the explanations to find any missing assumptions.

1. **Question:** What is the maximum key count for minimum degree t?
   **Answer:** 2t−1.
2. **Question:** What is the maximum child count?
   **Answer:** 2t.
3. **Question:** Why are all leaves at the same depth?
   **Answer:** To keep search height bounded and lookup paths balanced.
4. **Question:** Why use high fan-out?
   **Answer:** To reduce tree height and page I/O.
5. **Question:** How does a B+ tree commonly differ?
   **Answer:** It keeps records in leaves and links the leaves for ordered scans.

## Mastery checklist

- [ ] I can draw the internal representation for a small input.
- [ ] I can trace search and at least one update step by step.
- [ ] I can state and preserve the structural invariant.
- [ ] I know the preconditions and expected versus worst-case guarantees.
- [ ] I can justify this structure over a simpler alternative for a workload.

## Further reading and references

The lesson is self-contained; these sources provide deeper theory, implementation details, and database context.

- [Comer, “The Ubiquitous B-Tree” (1979)](https://doi.org/10.1145/356770.356776)
- [PostgreSQL — B-Tree Indexes](https://www.postgresql.org/docs/current/btree.html)
- [PostgreSQL — Index Types](https://www.postgresql.org/docs/current/indexes-types.html)
- [SQLite — Database File Format and B-tree Pages](https://www.sqlite.org/fileformat.html)
- [NIST Dictionary — B-tree](https://xlinux.nist.gov/dads/HTML/btree.html)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
