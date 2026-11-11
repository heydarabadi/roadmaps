# Segment Tree

> Path: [Chapter 6 — Advanced Data Structures](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/06-advanced-data-structures/segment-tree/README.md) · Suggested prerequisites: Arrays, recursive trees, and an associative combine operation.

## Prerequisites and mental model

Arrays, recursive trees, and an associative combine operation. Begin by identifying the operations and constraints the structure must support; advanced structures are useful only when their special operation matters to the workload.

## Core idea

A segment tree splits an array interval into smaller intervals and stores an aggregate for each segment. A range query combines only canonical segments fully covering the request; a point update recomputes only the root-to-leaf path.

## Representation, contract, and invariant

The combine operation must be associative, such as sum, min, max, gcd, or function composition. An identity handles empty/no-overlap results: 0 for sum and usually +∞ for minimum. Recursive arrays commonly allocate about 4n cells; iterative layouts often pad to a power of two.

An invariant is a property the representation must preserve after every update. State it before implementation so that the update rules and correctness argument can be checked against it.

## Step-by-step operations

`query(node,L,R,ql,qr)`: return identity if disjoint; return tree[node] if fully covered; otherwise query both children and combine. `update`: change the leaf, then combine children on the path back up. Lazy propagation stores a pending range update at a node and pushes it to children only when a partial descent requires it.

For production code, define empty input, duplicate keys, bounds, and update semantics explicitly. Keep the chosen indexing convention consistent throughout the implementation.

## Worked trace

For A=[2,1,5,3], a sum query on half-open interval [1,3) returns 1+5=6. The root can answer [0,4) directly; the requested subrange is assembled from the nodes covering [1,2) and [2,3).

Use a table with operation, affected node/index, state before, state after, and the invariant being restored. The trace should include at least one boundary or duplicate case.

## Why it works

Each node’s stored value equals the aggregate of its segment. An update changes a leaf and recomputes every ancestor, restoring that invariant. A query decomposes its requested range into disjoint covered segments whose union is exactly the request; associativity permits combining them in any tree grouping.

Check that initialization establishes the invariant, every operation preserves it, and the final query combines exactly the state required by its contract.

## Time and space analysis

Build takes O(n); point update and standard range query take O(log n); storage is O(n). Lazy propagation supports common range updates and range queries in O(log n), but correctness depends on defining how each pending tag composes and how it applies to a segment length.

Separate construction cost, per-operation cost, and auxiliary space. Expected/amortized bounds are not worst-case bounds; include the required assumptions.

## Real-world applications and trade-offs

Dynamic range sums/minima/maxima, coverage, frequency queries, maximum-subarray summaries, and range updates. Use a Fenwick tree for simpler prefix sums when its narrower operation set is enough.

Compare this structure with a simpler alternative before adopting it. Memory locality, implementation complexity, update pattern, and query mix may outweigh an asymptotic improvement for small inputs.

## Common mistakes and edge cases

Keep interval conventions consistent. Distinguish disjoint, fully covered, and partially covered cases. An operation may be associative but still need a correctly defined identity. Lazy tags must be composed and pushed with the segment length where required; testing only one update is not a proof.

Test empty structures, one element, repeated keys, minimum/maximum legal index, and invalid bounds. If the algorithm mutates the input, document that behavior.

## Exercises

1. Draw a sum segment tree for eight values. 2. Trace query [2,6) and a point update. 3. For range-add/range-sum, define the lazy tag and show how it changes a segment sum.

For each exercise, write the state and invariant before coding, then analyze both time and memory.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What algebraic property does combine need?
   **Answer:** Associativity.
2. **Question:** What is the build time?
   **Answer:** O(n).
3. **Question:** What is the usual point-update/range-query time?
   **Answer:** O(log n).
4. **Question:** What does lazy propagation do?
   **Answer:** It defers applying a range update to descendants until descent is needed.
5. **Question:** When is a Fenwick tree preferable?
   **Answer:** For simpler prefix/range sums when its operation set is sufficient.

## Mastery checklist

- [ ] I can explain the data representation and its invariant.
- [ ] I can execute an update/query by hand on a small example.
- [ ] I know which operation is optimized and which assumptions are required.
- [ ] I can compare the structure with a simpler alternative.
- [ ] I can analyze build time, operation time, and space separately.

## Further reading and references

This lesson is designed to stand on its own; use these primary or educational sources for deeper study.

- [CP-Algorithms — Segment Tree](https://cp-algorithms.com/data_structures/segment_tree.html)
- [AtCoder Library — Segment Tree documentation](https://atcoder.github.io/ac-library/production/document_en/segtree.html)
- [AtCoder Library — Lazy Segment Tree documentation](https://atcoder.github.io/ac-library/production/document_en/lazysegtree.html)
- [USACO Guide — Segment Tree](https://usaco.guide/gold/PURS)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
