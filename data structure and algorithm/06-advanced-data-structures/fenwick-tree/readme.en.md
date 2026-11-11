# Fenwick Tree (Binary Indexed Tree)

> Path: [Chapter 6 — Advanced Data Structures](../readme.en.md) · [Persian lesson](readme.md) · Suggested prerequisites: Arrays, prefix sums, and bitwise two’s-complement operations.

## Prerequisites and mental model

Arrays, prefix sums, and bitwise two’s-complement operations. Begin by identifying the operations and constraints the structure must support; advanced structures are useful only when their special operation matters to the workload.

## Core idea

A Fenwick tree stores sums of carefully chosen power-of-two blocks so point updates and prefix-sum queries both take O(log n). Each position’s lowest set bit identifies the size of the block represented by that cell.

## Representation, contract, and invariant

Use one-based indices. Let `lowbit(i)=i & -i`. `bit[i]` stores the sum over `[i−lowbit(i)+1, i]`. A prefix query repeatedly subtracts lowbit to visit disjoint blocks; a point update repeatedly adds lowbit to update every block containing the position.

An invariant is a property the representation must preserve after every update. State it before implementation so that the update rules and correctness argument can be checked against it.

## Step-by-step operations

`sum(i)`: result=0; while i>0, add bit[i], then set i-=lowbit(i). `add(i,delta)`: while i≤n, add delta to bit[i], then set i+=lowbit(i). For inclusive range [l,r], return sum(r)−sum(l−1). This update accepts a delta, not a replacement value.

For production code, define empty input, duplicate keys, bounds, and update semantics explicitly. Keep the chosen indexing convention consistent throughout the implementation.

## Worked trace

For values [3,2,−1,6], one-based update `add(3,+4)` changes the third value from −1 to 3. Then `sum(3)` returns 3+2+3=8. The query combines stored blocks rather than reading all three source cells one by one.

Use a table with operation, affected node/index, state before, state after, and the invariant being restored. The trace should include at least one boundary or duplicate case.

## Why it works

Every Fenwick cell stores exactly its defined block sum. An update follows all parent indices whose represented blocks include the changed position, preserving that invariant. A prefix query visits non-overlapping blocks whose union is exactly indices 1 through i, so their sums equal the requested prefix.

Check that initialization establishes the invariant, every operation preserves it, and the final query combines exactly the state required by its contract.

## Time and space analysis

Point update and prefix/range sum take O(log n) time and O(n) storage. Two Fenwick trees support common range-add/range-sum variants. The simple structure works naturally for sums and invertible prefix aggregates; arbitrary operations such as max with decreasing updates need a different design or extra constraints.

Separate construction cost, per-operation cost, and auxiliary space. Expected/amortized bounds are not worst-case bounds; include the required assumptions.

## Real-world applications and trade-offs

Dynamic cumulative frequencies, inversion counting after coordinate compression, prefix statistics, and order-statistic search over nonnegative frequencies. It is compact and simpler than a segment tree for its supported operations.

Compare this structure with a simpler alternative before adopting it. Memory locality, implementation complexity, update pattern, and query mix may outweigh an asymptotic improvement for small inputs.

## Common mistakes and edge cases

With one-based indexing, i=0 causes an infinite loop because lowbit(0)=0; validate or shift indices. `add` takes a delta. The bit trick relies on the integer representation and arithmetic of the implementation language. Range endpoints must use a single inclusive or half-open convention.

Test empty structures, one element, repeated keys, minimum/maximum legal index, and invalid bounds. If the algorithm mutates the input, document that behavior.

## Exercises

1. Compute lowbit(12) and lowbit(10). 2. Trace one point update and three prefix queries. 3. Coordinate-compress values and use a Fenwick tree to count how many earlier values are smaller.

For each exercise, write the state and invariant before coding, then analyze both time and memory.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What is lowbit(i)?
   **Answer:** The value `i & -i`, which isolates the least significant set bit.
2. **Question:** How does a prefix query move?
   **Answer:** It subtracts lowbit(i) each step.
3. **Question:** How does a point update move?
   **Answer:** It adds lowbit(i) each step.
4. **Question:** What is the time per update or prefix sum?
   **Answer:** O(log n).
5. **Question:** Does add(i,x) usually set the value to x?
   **Answer:** No; it adds a delta to the current value.

## Mastery checklist

- [ ] I can explain the data representation and its invariant.
- [ ] I can execute an update/query by hand on a small example.
- [ ] I know which operation is optimized and which assumptions are required.
- [ ] I can compare the structure with a simpler alternative.
- [ ] I can analyze build time, operation time, and space separately.

## Further reading and references

This lesson is designed to stand on its own; use these primary or educational sources for deeper study.

- [CP-Algorithms — Fenwick Tree](https://cp-algorithms.com/data_structures/fenwick.html)
- [Fenwick, “A New Data Structure for Cumulative Frequency Tables” (1994)](https://doi.org/10.1002/SPE.4380240306)
- [AtCoder Library — Fenwick Tree documentation](https://atcoder.github.io/ac-library/production/document_en/fenwicktree.html)
- [Topcoder — Binary Indexed Trees](https://www.topcoder.com/thrive/articles/Binary%20Indexed%20Trees)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
