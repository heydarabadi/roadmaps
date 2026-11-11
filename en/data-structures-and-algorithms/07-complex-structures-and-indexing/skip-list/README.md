# Skip List

> Path: [Chapter 7 — Complex Structures and Indexing](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/07-complex-structures-and-indexing/skip-list/README.md) · Suggested prerequisites: Linked lists, ordered keys, and randomized choices.

## Prerequisites and mental model

Linked lists, ordered keys, and randomized choices. These structures are specialized: start from the operation pattern and constraints, then decide whether the extra representation is justified.

## Core idea

A skip list layers several sorted linked lists. The bottom level contains every key; higher levels contain progressively sparser subsets. Search moves right while the next key is below the target, then drops down a level. Random node heights provide expected logarithmic performance.

## Representation, contract, and invariant

Every higher-level list is a subset of the level below. A node’s randomly chosen height determines which forward pointers it owns. Each level must remain sorted. A header/sentinel node supports traversal from the maximum active level.

An invariant is a structural property that must remain true after each operation. It is the bridge between the representation and the correctness proof.

## Step-by-step operations

Search from the highest level: advance while the next key is less than the target; if advancing would pass the target, drop one level. For insertion, record the predecessor at every level, choose a random height, and splice the new node into those levels. For deletion, reconnect every predecessor to the deleted node’s successor.

Make contracts explicit for empty structures, duplicate keys, boundary values, and mutation. State any balancing, randomization, or page-size assumptions.

## Worked trace

Suppose the top level has 1→7→12 and the lower level also contains 4 and 9. To find 9, move from 1 to 7 at the top; 12 is too large, so descend; then move from 7 to 9 at the lower level.

Use a table with the operation, affected nodes/pages/indices, state before and after, and which invariant the step preserves.

## Why it works

Each level remains a sorted subsequence of the level below, so moving right never skips a possible predecessor and descending preserves the search position. Under independent randomized promotion with a suitable probability, expected level height and horizontal work are logarithmic.

Check initialization, preservation, and termination. If an operation changes multiple levels or parent separators, verify the invariant at every affected ancestor.

## Time and space analysis

Expected O(log n) search, insertion, and deletion with standard random-height assumptions; worst case O(n) if the height pattern is unlucky or adversarially controlled. Expected storage is O(n), with a constant-factor overhead for extra forward pointers.

Report build cost separately from update and query costs. Keep average, expected, amortized, and worst-case claims distinct.

## Real-world applications and trade-offs

Ordered maps/sets, concurrent structures, and database sorted sets. Redis sorted sets use skiplist-related indexing together with a dictionary in relevant implementation paths; consult the official type documentation for the API-level behavior.

Compare with a simpler array, map, tree, or scan. Data size, update frequency, page I/O, locality, memory overhead, and implementation complexity can change the practical choice.

## Common mistakes and edge cases

Expected performance is not a deterministic worst-case guarantee. Make the random generator appropriate and seedable for tests. Define duplicate-key behavior. Ensure the header supports the maximum level, and do not confuse a skip list with a hash-based set.

Check empty input, one key, duplicates, split/merge boundaries, minimum/maximum key, and long update sequences. For disk structures, count overflow pages and page accesses.

## Exercises

1. Trace search for 8 through a two-level list. 2. Simulate random heights with coin flips and calculate the level links. 3. Compare skip lists with AVL trees in expected/worst guarantees and implementation complexity.

For each exercise, write the invariant and expected complexity before implementing it.

## Comprehensive quiz with explained answers

Try to answer first; then use the explanations to find any missing assumptions.

1. **Question:** What is stored at the bottom level?
   **Answer:** Every key in sorted order.
2. **Question:** When does search descend a level?
   **Answer:** When the next key would be greater than the target or no next key exists.
3. **Question:** What kind of O(log n) guarantee is standard?
   **Answer:** Expected performance under the random-height model.
4. **Question:** What must insertion remember?
   **Answer:** The predecessor at each level the new node will occupy.
5. **Question:** Name a common trade-off.
   **Answer:** Simpler update logic than some balanced trees, but randomized rather than deterministic balance.

## Mastery checklist

- [ ] I can draw the internal representation for a small input.
- [ ] I can trace search and at least one update step by step.
- [ ] I can state and preserve the structural invariant.
- [ ] I know the preconditions and expected versus worst-case guarantees.
- [ ] I can justify this structure over a simpler alternative for a workload.

## Further reading and references

The lesson is self-contained; these sources provide deeper theory, implementation details, and database context.

- [Pugh, “Skip Lists: A Probabilistic Alternative to Balanced Trees” (1990)](https://dl.acm.org/doi/10.1145/78973.78977)
- [William Pugh’s skip-list paper — CMU course copy](https://15721.courses.cs.cmu.edu/spring2017/papers/07-oltpindexes1/pugh-skiplists-cacm1990.pdf)
- [Redis — Sorted Sets](https://redis.io/docs/latest/develop/data-types/sorted-sets/)
- [Princeton Algorithms — Balanced Search Trees](https://algs4.cs.princeton.edu/33balanced/)
- [NIST Dictionary — skip list](https://xlinux.nist.gov/dads/HTML/skiplist.html)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
