# B-Tree

> Course: [Chapter 4](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/04-trees/b-tree/README.md) · Prerequisites: multiway search trees, sorted keys, and storage pages

## Learning goals and prerequisites

You should be comfortable with multiway search trees, sorted keys, and storage pages. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

A B-tree is a balanced multiway search tree. Each node contains several sorted keys and child pointers, reducing height and the number of disk/page reads. Its fanout is chosen for block storage, not merely for having “many children.”

## Representation, contract, and invariant

For minimum degree t, a non-root node has between t−1 and 2t−1 keys and up to 2t children; the root has special minimum rules. k sorted keys divide child ranges into k+1 intervals. Every leaf is at the same depth. Some references define “order” differently, so state the chosen convention.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Search within a node for equality or the key interval, then follow the corresponding child. For top-down insertion, split a full child before descending; promote its median to the parent. For deletion, borrow from a sibling or merge before descending into a minimally occupied child, preventing underflow.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

With t=2, a node can hold at most three keys. If a child contains `[12,15,18]`, split it around median 15, promote 15 to the parent, and leave children `[12]` and `[18]`. Searching then follows the parent separator to the appropriate range.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

Keys remain sorted; every child contains only its assigned separator interval; occupancy bounds hold (except root rules); and all leaves stay at the same depth. A root split increases height by one; a root merge may reduce it.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Height and page visits are O(log_t n). Search, insertion, and deletion visit O(log_t n) nodes/pages, with an in-node search over its keys. High fanout decreases page I/O. Node size is chosen to fit the target page/cache block.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Database indexes and file systems use B-tree-family structures. A node is sized around a storage page so each level can be read as a block; fewer levels can mean fewer random I/O operations.

## Common mistakes and edge cases

Do not mix minimum-degree and order conventions. A split must update the parent separator as well as the children. A B-tree may store payloads in internal nodes; a B+ tree usually concentrates records in leaves.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. For t=3, compute the minimum and maximum keys per non-root node. 2. Insert a sequence that splits the root. 3. Estimate page reads for a search through a tree of height h.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** For minimum degree t, maximum keys per node?
   **Explained answer:** 2t−1.
2. **Question:** Maximum number of children?
   **Explained answer:** 2t.
3. **Question:** Why are all leaves at the same depth?
   **Explained answer:** It guarantees balanced height and predictable search paths.
4. **Question:** Why use high fanout?
   **Explained answer:** To reduce tree height and page I/O.
5. **Question:** How does a B+ tree differ?
   **Explained answer:** It typically stores records in leaves and links those leaves for range scans.

## Further reading and references

- [PostgreSQL documentation: B-Tree indexes](https://www.postgresql.org/docs/current/btree.html) — A database's B-tree index behavior and supported operators.
- [USFCA B-tree visualization](https://www.cs.usfca.edu/~galles/visualization/BTree.html) — Animated insertion, split, and search.
- [Open Data Structures: B-Trees](https://opendatastructures.org/ods-java/14_2_B_Trees.html) — B-tree occupancy and external-memory search.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Search-tree fundamentals and analysis.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
