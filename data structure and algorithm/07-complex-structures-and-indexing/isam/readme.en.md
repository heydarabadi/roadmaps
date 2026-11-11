# ISAM (Indexed Sequential Access Method)

> Path: [Chapter 7 — Complex Structures and Indexing](../readme.en.md) · [Persian lesson](readme.md) · Suggested prerequisites: Sorted files, multi-level indexes, data pages, and overflow pages.

## Prerequisites and mental model

Sorted files, multi-level indexes, data pages, and overflow pages. These structures are specialized: start from the operation pattern and constraints, then decide whether the extra representation is justified.

## Core idea

ISAM organizes a sorted data file with a multi-level index that points to fixed primary pages. Inserts that do not fit in a primary page go to overflow pages. The primary index is comparatively static; long overflow chains can gradually make lookups slower.

## Representation, contract, and invariant

Index separators route a key range to a data page. Each primary page contains an ordered range. When full, an overflow page is linked to the relevant primary page or chain rather than rebalancing the main index on every insert. A rebuild can merge overflow records back into the base file.

An invariant is a structural property that must remain true after each operation. It is the bridge between the representation and the correctness proof.

## Step-by-step operations

Lookup descends through index levels to the target primary page, scans it, and then checks its overflow chain if necessary. Insert into the correct ordered page; if it is full, place the record in overflow storage and link it. Deletion may mark records or require periodic reorganization, depending on the system.

Make contracts explicit for empty structures, duplicate keys, boundary values, and mutation. State any balancing, randomization, or page-size assumptions.

## Worked trace

Suppose page P covers keys 100–199 and is full. Inserting key 175 places it on overflow page O linked from P. A lookup for 175 finds P through the index, scans P, then follows O. As more overflow pages accumulate, the number of page reads grows.

Use a table with the operation, affected nodes/pages/indices, state before and after, and which invariant the step preserves.

## Why it works

The sorted primary-page ranges and index separators ensure that lookup reaches the correct base page. Overflow links preserve access to later inserted records that do not fit there. Reorganization restores compact primary pages and reduces chain traversal without changing key ordering.

Check initialization, preservation, and termination. If an operation changes multiple levels or parent separators, verify the invariant at every affected ancestor.

## Time and space analysis

The initial index descent takes logarithmic page levels in the number of indexed pages, followed by primary-page and overflow-chain reads. If k overflow pages accumulate, an unsuccessful or late-chain search can incur O(k) additional page reads. Inserts are simple but workload drift may require a rebuild.

Report build cost separately from update and query costs. Keep average, expected, amortized, and worst-case claims distinct.

## Real-world applications and trade-offs

Mostly read-oriented or batch-maintained files, and as a historical contrast with dynamically balanced B+ trees. It helps explain why an index can have fast initial lookups yet degrade as updates accumulate.

Compare with a simpler array, map, tree, or scan. Data size, update frequency, page I/O, locality, memory overhead, and implementation complexity can change the practical choice.

## Common mistakes and edge cases

Do not treat ISAM as a dynamically rebalanced B+ tree. Count overflow I/O as part of lookup cost. Frequent inserts into the same full page can create a long chain. Maintenance/rebuild cost belongs in the workload analysis.

Check empty input, one key, duplicates, split/merge boundaries, minimum/maximum key, and long update sequences. For disk structures, count overflow pages and page accesses.

## Exercises

1. Draw a sparse index over eight primary data pages. 2. Add three records to one full page and count page reads for a later lookup. 3. Explain why a rebuild can restore lookup performance.

For each exercise, write the invariant and expected complexity before implementing it.

## Comprehensive quiz with explained answers

Try to answer first; then use the explanations to find any missing assumptions.

1. **Question:** Is ISAM’s main index static or dynamically rebalanced?
   **Answer:** The primary organization is static; overflow pages absorb later inserts.
2. **Question:** Where does an insert go when its primary page is full?
   **Answer:** Into an overflow page linked to that range.
3. **Question:** What is the cost of a long overflow chain?
   **Answer:** More page I/O during lookup.
4. **Question:** What workloads suit the historical ISAM model?
   **Answer:** Relatively stable files with sequential or read-heavy access.
5. **Question:** How does a B+ tree differ?
   **Answer:** It dynamically splits/merges to maintain balance instead of relying on growing overflow chains.

## Mastery checklist

- [ ] I can draw the internal representation for a small input.
- [ ] I can trace search and at least one update step by step.
- [ ] I can state and preserve the structural invariant.
- [ ] I know the preconditions and expected versus worst-case guarantees.
- [ ] I can justify this structure over a simpler alternative for a workload.

## Further reading and references

The lesson is self-contained; these sources provide deeper theory, implementation details, and database context.

- [University of Rochester — ISAM lecture notes](https://www.cs.rochester.edu/courses/261/spring2017/lectures/l27.pdf)
- [Bilkent University — Index Sequential Access Method](https://www.cs.bilkent.edu.tr/~canf/CS351Fall2009/cs351lecturenotes/week7/index.html)
- [Alagappa University — ISAM course material](https://mis.alagappauniversity.ac.in/siteAdmin/dde-admin/uploads/4/UG_B.Com_Computer%20Applications_Database%20management%20system_9152.pdf)
- [Carnegie Mellon 15-445/645 — Database Systems](https://15445.courses.cs.cmu.edu/fall2022/)
- [Comer, “The Ubiquitous B-Tree” (comparison with dynamic index structures)](https://doi.org/10.1145/356770.356776)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
