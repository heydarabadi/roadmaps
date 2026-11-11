# B+ Tree

> Path: [Chapter 7 — Complex Structures and Indexing](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/07-complex-structures-and-indexing/b-plus-tree/README.md) · Suggested prerequisites: B-trees, page I/O, ordered keys, and range queries.

## Prerequisites and mental model

B-trees, page I/O, ordered keys, and range queries. These structures are specialized: start from the operation pattern and constraints, then decide whether the extra representation is justified.

## Core idea

A B+ tree keeps record entries or record pointers in its leaves; internal nodes hold separators and child pointers. Leaves are commonly linked, so after finding a range’s first key, the scan can continue sequentially through neighboring leaves.

## Representation, contract, and invariant

A search follows separators from root to a leaf, even if an internal separator equals the search key. High internal-node fan-out reduces height. Leaf links preserve sorted order. Details such as whether separator values are copied from a leaf or represent interval boundaries vary by implementation.

An invariant is a structural property that must remain true after each operation. It is the bridge between the representation and the correctness proof.

## Step-by-step operations

Lookup: compare against separators until reaching a leaf. Insert into the sorted leaf; if it overflows, split it and copy/promote the right leaf’s separator into the parent, propagating splits as needed. Delete handles underflow by redistribution or merging and repairs parent separators and leaf links. For a range query, find the lower-bound leaf, scan forward, and stop past the upper bound.

Make contracts explicit for empty structures, duplicate keys, boundary values, and mutation. State any balancing, randomization, or page-size assumptions.

## Worked trace

To answer keys in [25,60], descend to the first leaf containing a key at least 25. Read entries in order, following next-leaf links until the first key greater than 60. The tree is traversed once for the starting boundary; the rest is a sequential leaf scan.

Use a table with the operation, affected nodes/pages/indices, state before and after, and which invariant the step preserves.

## Why it works

All records are in the ordered leaves, and internal separators route every key to its correct leaf interval. Splits and merges preserve that partitioning, balanced leaf depth, and leaf order. Because leaf links follow the same key order, range scanning visits exactly the intervening records.

Check initialization, preservation, and termination. If an operation changes multiple levels or parent separators, verify the invariant at every affected ancestor.

## Time and space analysis

Search, insertion, and deletion take O(log_f n) page levels for fan-out f. A range scan takes O(log_f n + pages/records returned). The page count often matters more than CPU comparisons for an on-disk index.

Report build cost separately from update and query costs. Keep average, expected, amortized, and worst-case claims distinct.

## Real-world applications and trade-offs

Relational database indexes, ordered retrieval, and range scans. Database engines may store row data directly in leaf pages or store row identifiers; exact details vary by engine and index type.

Compare with a simpler array, map, tree, or scan. Data size, update frequency, page I/O, locality, memory overhead, and implementation complexity can change the practical choice.

## Common mistakes and edge cases

Do not stop at an internal separator as if it were a record. Repair separators after borrowing/merging. Keep leaf links valid after a split. Define how duplicate keys are represented. B+ tree layouts are related, but not identical across database products.

Check empty input, one key, duplicates, split/merge boundaries, minimum/maximum key, and long update sequences. For disk structures, count overflow pages and page accesses.

## Exercises

1. Draw linked leaves holding keys 10,20,30,40,50. 2. Trace the range [22,45]. 3. Compare the separator update after a leaf split with the change after an internal-node split.

For each exercise, write the invariant and expected complexity before implementing it.

## Comprehensive quiz with explained answers

Try to answer first; then use the explanations to find any missing assumptions.

1. **Question:** Where are record entries usually stored?
   **Answer:** In the leaves.
2. **Question:** What do internal separators do?
   **Answer:** Route a search to the correct child interval.
3. **Question:** Why link leaves?
   **Answer:** To scan a key range sequentially after one tree descent.
4. **Question:** Does an equal internal separator mean the record is found?
   **Answer:** Usually no; lookup continues to a leaf.
5. **Question:** What is the height-based lookup cost?
   **Answer:** O(log_f n) page levels.

## Mastery checklist

- [ ] I can draw the internal representation for a small input.
- [ ] I can trace search and at least one update step by step.
- [ ] I can state and preserve the structural invariant.
- [ ] I know the preconditions and expected versus worst-case guarantees.
- [ ] I can justify this structure over a simpler alternative for a workload.

## Further reading and references

The lesson is self-contained; these sources provide deeper theory, implementation details, and database context.

- [Comer, “The Ubiquitous B-Tree” (includes B+ tree variants)](https://doi.org/10.1145/356770.356776)
- [Carnegie Mellon 15-445/645 — B+ Tree Indexes](https://15445.courses.cs.cmu.edu/fall2022/slides/08-trees.pdf)
- [PostgreSQL — B-Tree Indexes](https://www.postgresql.org/docs/current/btree.html)
- [SQLite — B-tree pages in the file format](https://www.sqlite.org/fileformat.html)
- [Washington University in St. Louis — B+ tree database lecture notes](https://www.cse.wustl.edu/~dshook/cse530/lectures/Btree.pdf)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
