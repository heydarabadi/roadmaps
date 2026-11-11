# Chapter 7 — Complex Structures and Indexing

> [Persian chapter](readme.md) · [Course index](../readme.en.md)

In-memory trees often optimize comparison count; database indexes also optimize page reads and range scans. Fan-out, locality, update rate, and storage layout all shape the right design.

## From memory to storage

A balanced binary tree uses O(log n) comparisons along a search path. A disk-based B-tree stores many separators per page, reducing the number of page reads. B+ tree leaves hold ordered records or references and are linked for range scans. ISAM uses a largely static index and overflow pages; long overflow chains can slow lookup. A skip list offers expected logarithmic operations for an ordered in-memory set.

| Structure | Key behavior | Main trade-off |
|---|---|---|
| 2–3 tree | Balanced multiway search tree | Simple model; node split/merge logic |
| B-tree | Multi-key nodes with balanced leaves | High fan-out and fewer page reads |
| B+ tree | Records concentrated in linked leaves | Efficient ordered range scans |
| ISAM | Static index plus overflow chain | Simple inserts until chains grow |
| Skip list | Randomized multi-level ordered list | Expected, rather than deterministic, balance |
| Dense/sparse index | Key-to-record or block pointers | Space versus local search cost |

## Roadmap parent lesson: Complex Data Structures

2–3 and B trees maintain balanced multiway search order; B+ trees separate routing separators from leaf records; skip lists use randomized height; ISAM absorbs some inserts through overflow pages. For page-based storage, node capacity should fit a page. For an ordered in-memory set, compare tree guarantees and skip-list expected behavior.

## Roadmap parent lesson: Indexing

An index stores search keys and pointers to records or storage blocks. A dense index has an entry for each record; a sparse index has entries for groups or pages. A clustered index aligns physical row order with the key; a secondary index may require an extra lookup. Ordered indexes help range scans but consume space and add maintenance work on writes.

## Chapter review quiz

1. Why are all B-tree leaves at the same depth? To bound search height and keep lookup paths balanced.
2. What do linked B+ tree leaves help with? Sequential range scans after locating the first matching leaf.
3. Where may an ISAM insert go when its primary page is full? An overflow page.
4. What is the difference between dense and sparse indexes? An entry per record versus an entry per page/group.
5. What is a skip list’s common complexity guarantee? Expected O(log n) operations under its randomized-height model.
6. Is an index scan always faster than a table scan? No; selectivity, page layout, and access costs determine the better plan.

## Further reading and references

- [PostgreSQL — B-tree indexes](https://www.postgresql.org/docs/current/btree.html)
- [PostgreSQL — Indexes](https://www.postgresql.org/docs/current/indexes.html)
- [PostgreSQL — Bloom indexes](https://www.postgresql.org/docs/current/bloom.html)
- [Redis — Sorted sets](https://redis.io/docs/latest/develop/data-types/sorted-sets/)
- [Princeton Algorithms — Balanced Search Trees](https://algs4.cs.princeton.edu/33balanced/)
- [Full bibliography](../references.en.md)

## Topic lessons

- [2–3 Trees](two-three-tree/readme.en.md)
- [B-Trees for Indexing](b-tree-complex/readme.en.md)
- [B+ Trees](b-plus-tree/readme.en.md)
- [ISAM](isam/readme.en.md)
- [Linear Indexing](linear-indexing/readme.en.md)
- [Skip Lists](skip-list/readme.en.md)
- [Tree-Based Indexing](tree-indexing/readme.en.md)

## Mastery standard

Draw a page-based tree for an ordered range query. Count index-page accesses, leaf pages, and output records. Explain how inserts and deletes affect separators, occupancy, and storage maintenance.
