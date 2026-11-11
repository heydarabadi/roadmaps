# Linear Indexing

> Path: [Chapter 7 — Complex Structures and Indexing](../readme.en.md) · [Persian lesson](readme.md) · Suggested prerequisites: Sorted files, search keys, records, and block-oriented storage.

## Prerequisites and mental model

Sorted files, search keys, records, and block-oriented storage. These structures are specialized: start from the operation pattern and constraints, then decide whether the extra representation is justified.

## Core idea

An index is an auxiliary ordered structure mapping search keys to records or storage locations. A dense index has an entry for each record; a sparse index has entries for blocks or groups. This lesson treats the roadmap’s “Linear” indexing topic as the classic ordered/sequential index family, not as a claim that every lookup takes linear time.

## Representation, contract, and invariant

An index entry is typically a (search-key, pointer) pair. A key may be non-unique and point to a group/bucket of matching rows. A clustered index keeps physical row order aligned with the indexed key; a secondary index uses another ordering and may require a separate record lookup.

An invariant is a structural property that must remain true after each operation. It is the bridge between the representation and the correctness proof.

## Step-by-step operations

On a sorted in-memory index, binary search can locate the lower-bound entry. A sparse index routes to a block using its separator, then scans within that block. For a range query, find the first matching key and walk ordered entries/records until the upper bound. Insertions may shift an in-memory array or trigger page splits/reorganization.

Make contracts explicit for empty structures, duplicate keys, boundary values, and mutation. State any balancing, randomization, or page-size assumptions.

## Worked trace

Assume a file sorted by customer_id, with 100 records per page. A sparse index stores the first key of each page. To find an ID, binary-search the separators for the greatest separator ≤ ID, read that page, and scan within it. A dense index stores every ID pointer, consuming more space but reducing the local scan.

Use a table with the operation, affected nodes/pages/indices, state before and after, and which invariant the step preserves.

## Why it works

A sparse separator must identify the page whose key interval contains each record. The index and data file must use the same ordering comparator. If records move or pages split, pointers and separators must be repaired so that lookup still lands in the correct block.

Check initialization, preservation, and termination. If an operation changes multiple levels or parent separators, verify the invariant at every affected ancestor.

## Time and space analysis

A binary search over I in-memory index entries costs O(log I), followed by one or more page reads and local scan. Dense indexes use O(n) entries; a sparse index over B-record pages uses roughly O(n/B) entries. Writes incur index maintenance and possible page-split costs.

Report build cost separately from update and query costs. Keep average, expected, amortized, and worst-case claims distinct.

## Real-world applications and trade-offs

Database lookups and range scans, composite-key indexes, and covering indexes that can answer a query without fetching the base row. Index design depends on query frequency, selectivity, ordering, and update rate.

Compare with a simpler array, map, tree, or scan. Data size, update frequency, page I/O, locality, memory overhead, and implementation complexity can change the practical choice.

## Common mistakes and edge cases

Indexes use storage and add write work. Composite-column order matters. A secondary index can cause random I/O; a low-selectivity query may be cheaper as a sequential table scan. Duplicate keys require multiple row pointers or a posting structure.

Check empty input, one key, duplicates, split/merge boundaries, minimum/maximum key, and long update sequences. For disk structures, count overflow pages and page accesses.

## Exercises

1. Build dense and sparse indexes for a small sorted file. 2. Estimate the within-page scan after a sparse lookup. 3. Propose an index for `WHERE city=? ORDER BY age` and explain the column order.

For each exercise, write the invariant and expected complexity before implementing it.

## Comprehensive quiz with explained answers

Try to answer first; then use the explanations to find any missing assumptions.

1. **Question:** What is a dense index?
   **Answer:** An index with an entry for each data record.
2. **Question:** What is a sparse index?
   **Answer:** An index with entries for blocks/groups or boundary keys.
3. **Question:** Why do ordered indexes help range queries?
   **Answer:** After finding the lower bound, subsequent keys can be scanned in order.
4. **Question:** What is a cost of maintaining an index?
   **Answer:** Extra storage and work on inserts/deletes/updates.
5. **Question:** What does “clustered” mean?
   **Answer:** The physical data order is aligned with the index key order.

## Mastery checklist

- [ ] I can draw the internal representation for a small input.
- [ ] I can trace search and at least one update step by step.
- [ ] I can state and preserve the structural invariant.
- [ ] I know the preconditions and expected versus worst-case guarantees.
- [ ] I can justify this structure over a simpler alternative for a workload.

## Further reading and references

The lesson is self-contained; these sources provide deeper theory, implementation details, and database context.

- [PostgreSQL — Index Types and their use cases](https://www.postgresql.org/docs/current/indexes-types.html)
- [PostgreSQL — B-Tree indexes](https://www.postgresql.org/docs/current/btree.html)
- [SQLite — Database File Format](https://www.sqlite.org/fileformat.html)
- [Carnegie Mellon 15-445/645 — Database Systems](https://15445.courses.cs.cmu.edu/fall2022/)
- [Comer, “The Ubiquitous B-Tree”](https://doi.org/10.1145/356770.356776)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
