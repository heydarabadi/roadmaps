# Chapter 6 — Advanced Data Structures

> [Persian chapter](readme.md) · [Course index](../readme.en.md)

Specialized structures are valuable when their optimized operations are central to the workload. Learn the invariant and update rules before optimizing code around them.

## Choose by operation

| Need | Structure | Main operation |
|---|---|---|
| Prefix-based string search | Trie | Insert/search in O(L) for a key of length L |
| Prefix sums and point updates | Fenwick tree | Query/update in O(log n) |
| Flexible range aggregates | Segment tree | Range query and point update in O(log n) |
| Components joined over time | Disjoint Set Union | Merge/find in near-constant amortized time |
| Substring search in static text | Suffix array/tree | Indexed pattern and repeated-substring queries |

## Worked choice

If array values change and queries ask for prefix sums, a Fenwick tree is compact and simple. If the queries require min/max or richer range updates, a segment tree is more flexible. If a network only gains edges and the question is whether two vertices are connected, DSU is a strong fit; it does not directly support arbitrary edge deletion. Autocomplete suggests a trie; repeated substring searches over fixed text suggest a suffix index.

## Roadmap parent lesson: Advanced Data Structures

Trie nodes share common prefixes; Fenwick and segment trees maintain aggregates over intervals; DSU represents disjoint components; suffix structures index all suffixes of a string. Choose based on the operations and constraints, not the word “advanced.” A structure that makes one operation logarithmic may use more memory or make updates more complex.

**Self-check**

1. What does a Fenwick update take? A delta from the current value.
2. What property should a segment-tree combine operation have? Associativity.
3. Why is DSU deletion difficult? A union has merged components, and separating them requires information the standard structure discards.
4. How does a trie distinguish a full word from a prefix? A terminal-word marker.
5. What does a suffix array sort? Starting positions of all text suffixes in lexicographic order.

## Chapter review quiz

1. When is a Fenwick tree often enough? Prefix/range sums with point updates.
2. When should you prefer a segment tree? When aggregates or range updates need more flexible operations.
3. Does DSU naturally support removing an edge? No; standard DSU supports merges, not splits.
4. Why is suffix-array memory often lower than suffix-tree memory? It stores suffix positions and auxiliary arrays rather than many pointer-rich nodes.
5. Should a structure be selected only because it offers O(log n)? No; compare memory, update behavior, workload, and implementation complexity.

## Further reading and references

- [CP-Algorithms — Fenwick Tree](https://cp-algorithms.com/data_structures/fenwick.html)
- [CP-Algorithms — Segment Tree](https://cp-algorithms.com/data_structures/segment_tree.html)
- [CP-Algorithms — Disjoint Set Union](https://cp-algorithms.com/data_structures/disjoint_set_union.html)
- [CP-Algorithms — Suffix Array](https://cp-algorithms.com/string/suffix-array.html)
- [Princeton Algorithms — Tries](https://algs4.cs.princeton.edu/52trie/)
- [Ferdowsi University — Data Structures](https://cs-um.github.io/docs/mandatory/Data-Structures/)
- [Full bibliography](../references.en.md)

## Topic lessons

- [Trie](trie/readme.en.md)
- [Segment Tree](segment-tree/readme.en.md)
- [Fenwick Tree](fenwick-tree/readme.en.md)
- [Union-Find / DSU](union-find/readme.en.md)
- [Suffix Array](suffix-array/readme.en.md)
- [Suffix Tree](suffix-tree/readme.en.md)

## Mastery standard

For each structure, name one operation it optimizes and one it handles poorly. Draw the internal state for a small example, trace an update/query, and prove the invariant is restored afterward.
