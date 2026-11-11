# Tree-Based Indexing

> Path: [Chapter 7 — Complex Structures and Indexing](../readme.en.md) · [Persian lesson](readme.md) · Suggested prerequisites: Search trees, B/B+ trees, ordered separators, and page I/O.

## Prerequisites and mental model

Search trees, B/B+ trees, ordered separators, and page I/O. These structures are specialized: start from the operation pattern and constraints, then decide whether the extra representation is justified.

## Core idea

A tree index stores ordered keys in nodes so a search can discard entire key ranges at each level. In-memory balanced BSTs reduce comparisons; disk-oriented multiway trees use high fan-out so a small number of page reads reaches a leaf.

## Representation, contract, and invariant

An internal node stores separator keys and child pointers. A lookup descends through the child interval containing the target. A range query finds the lower bound and continues through ordered leaves. A B-tree may store record pointers in internal nodes; a B+ tree usually keeps records in leaves and often links those leaves.

An invariant is a structural property that must remain true after each operation. It is the bridge between the representation and the correctness proof.

## Step-by-step operations

Lookup: binary-search separators inside each node, select the corresponding child, and continue to a leaf or matching internal entry according to the tree variant. Insert/delete preserve occupancy using split, redistribution/borrow, and merge. Range scan: descend to the first leaf, then traverse next-leaf links until the upper bound.

Make contracts explicit for empty structures, duplicate keys, boundary values, and mutation. State any balancing, randomization, or page-size assumptions.

## Worked trace

Suppose a root has separators [20,50] and the target is 37. Descend into the middle child; a leaf [31,37,42] contains the target. A range query [37,70] starts in that leaf and continues through subsequent leaves until the first key exceeds 70.

Use a table with the operation, affected nodes/pages/indices, state before and after, and which invariant the step preserves.

## Why it works

Separators partition the key space into disjoint child ranges. Balancing rules keep all leaves at equal depth and bound occupancy. Split/merge operations update separators and child pointers so every key remains in the interval represented by its path.

Check initialization, preservation, and termination. If an operation changes multiple levels or parent separators, verify the invariant at every affected ancestor.

## Time and space analysis

A balanced binary index visits O(log₂ n) nodes; a B-tree with fan-out f visits O(log_f n) pages. A range scan costs O(log_f n + output/pages). On external storage, page I/O and locality often matter more than CPU comparisons.

Report build cost separately from update and query costs. Keep average, expected, amortized, and worst-case claims distinct.

## Real-world applications and trade-offs

Database indexes, file-system metadata, and ordered storage engines. Query planners compare index scans with sequential scans using selectivity, statistics, and estimated I/O; an index is not always the cheapest plan.

Compare with a simpler array, map, tree, or scan. Data size, update frequency, page I/O, locality, memory overhead, and implementation complexity can change the practical choice.

## Common mistakes and edge cases

An index scan can lose to a sequential scan for low-selectivity queries. Composite-key prefix order matters. Secondary lookups may trigger random page reads. B/B+ tree page size and split policy are implementation-specific.

Check empty input, one key, duplicates, split/merge boundaries, minimum/maximum key, and long update sequences. For disk structures, count overflow pages and page accesses.

## Exercises

1. Trace a lookup through a root and two child levels. 2. Draw a leaf-link scan for an interval. 3. Give a query where scanning the whole table can be cheaper than using an index.

For each exercise, write the invariant and expected complexity before implementing it.

## Comprehensive quiz with explained answers

Try to answer first; then use the explanations to find any missing assumptions.

1. **Question:** What does an internal separator do?
   **Answer:** It routes each key range to the correct child.
2. **Question:** Why are B-trees useful on disk?
   **Answer:** High fan-out reduces the number of page levels and I/O.
3. **Question:** How does a B+ tree continue a range scan?
   **Answer:** It follows linked leaves after finding the lower-bound leaf.
4. **Question:** Is an index scan always faster?
   **Answer:** No; selectivity and I/O cost may favor a sequential scan.
5. **Question:** What is often the dominant external-storage cost?
   **Answer:** Page I/O and random access, plus index maintenance.

## Mastery checklist

- [ ] I can draw the internal representation for a small input.
- [ ] I can trace search and at least one update step by step.
- [ ] I can state and preserve the structural invariant.
- [ ] I know the preconditions and expected versus worst-case guarantees.
- [ ] I can justify this structure over a simpler alternative for a workload.

## Further reading and references

The lesson is self-contained; these sources provide deeper theory, implementation details, and database context.

- [PostgreSQL — Index Types](https://www.postgresql.org/docs/current/indexes-types.html)
- [PostgreSQL — B-Tree Indexes](https://www.postgresql.org/docs/current/btree.html)
- [SQLite — File Format and B-tree Pages](https://www.sqlite.org/fileformat.html)
- [Carnegie Mellon 15-445/645 — Indexes and B+ Trees](https://15445.courses.cs.cmu.edu/fall2022/)
- [Comer, “The Ubiquitous B-Tree”](https://doi.org/10.1145/356770.356776)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
