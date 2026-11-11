# Suffix Array

> Path: [Chapter 6 — Advanced Data Structures](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/06-advanced-data-structures/suffix-array/README.md) · Suggested prerequisites: Strings, lexicographic ordering, sorting, and binary search.

## Prerequisites and mental model

Strings, lexicographic ordering, sorting, and binary search. Begin by identifying the operations and constraints the structure must support; advanced structures are useful only when their special operation matters to the workload.

## Core idea

A suffix array stores the starting indices of all suffixes of a text in lexicographic order. It indexes suffixes by their positions instead of storing many repeated suffix strings. An LCP array stores the longest common prefix of adjacent suffixes in sorted order.

## Representation, contract, and invariant

For text S, suffix i is S[i..]. A unique sentinel smaller than every text symbol is often appended to make suffix endings explicit. `SA[k]` is the start position of the suffix at sorted rank k. The suffix array order is lexicographic; it is not the order in which matches occur in the original text.

An invariant is a property the representation must preserve after every update. State it before implementation so that the update rules and correctness argument can be checked against it.

## Step-by-step operations

A simple educational construction sorts indices by their suffix strings. Practical construction uses prefix-doubling and sorting/radix techniques, commonly O(n log n). To search for pattern P, use two binary searches to find the contiguous interval of suffixes beginning with P; sort the resulting positions if text-order output is required.

For production code, define empty input, duplicate keys, bounds, and update semantics explicitly. Keep the chosen indexing convention consistent throughout the implementation.

## Worked trace

For `banana$`, the sorted suffix starts are [6,5,3,1,0,4,2]: `$`, `a$`, `ana$`, `anana$`, `banana$`, `na$`, `nana$`. Pattern `ana` matches the suffixes starting at positions 1 and 3, which form a consecutive interval in suffix-array order.

Use a table with operation, affected node/index, state before, state after, and the invariant being restored. The trace should include at least one boundary or duplicate case.

## Why it works

All suffixes sharing a prefix P appear consecutively in lexicographic order. Therefore lower and upper bounds around P delimit exactly the matching suffixes. LCP values expose shared prefixes of adjacent suffixes and support repeated-substring analysis.

Check that initialization establishes the invariant, every operation preserves it, and the final query combines exactly the state required by its contract.

## Time and space analysis

Prefix-doubling construction takes O(n log n) time and O(n) auxiliary storage. Pattern search is often described as O(|P| log n) character comparisons in a simple implementation; LCP-aware search can avoid repeated comparisons. LCP-based longest repeated substring analysis is linear after construction.

Separate construction cost, per-operation cost, and auxiliary space. Expected/amortized bounds are not worst-case bounds; include the required assumptions.

## Real-world applications and trade-offs

Substring search on a static text, repeated-substring analysis, compression, and genomic/string indexing. For frequently changing text, rebuilding the array can be expensive; a dynamic or different indexing structure may be preferable.

Compare this structure with a simpler alternative before adopting it. Memory locality, implementation complexity, update pattern, and query mix may outweigh an asymptotic improvement for small inputs.

## Common mistakes and edge cases

Do not allocate every suffix as a copied string; that can use quadratic space. Define sentinel ordering and Unicode encoding. Distinguish lexicographic suffix order from text-position order. Compare suffixes carefully so the text boundary is handled correctly.

Test empty structures, one element, repeated keys, minimum/maximum legal index, and invalid bounds. If the algorithm mutates the input, document that behavior.

## Exercises

1. Construct the suffix array for `aba$` by hand. 2. Calculate the LCP of adjacent suffixes. 3. Use two binary searches to find the suffix-array interval for `ana` in `banana$`.

For each exercise, write the state and invariant before coding, then analyze both time and memory.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What does a suffix array store?
   **Answer:** Starting positions of suffixes sorted lexicographically.
2. **Question:** Why append a sentinel?
   **Answer:** To make suffix termination explicit with a unique smallest symbol.
3. **Question:** What does LCP measure?
   **Answer:** The common-prefix length of adjacent sorted suffixes.
4. **Question:** What is the common doubling construction bound?
   **Answer:** O(n log n).
5. **Question:** Is a suffix array ideal for frequently edited text?
   **Answer:** Usually not; edits can require expensive rebuilding.

## Mastery checklist

- [ ] I can explain the data representation and its invariant.
- [ ] I can execute an update/query by hand on a small example.
- [ ] I know which operation is optimized and which assumptions are required.
- [ ] I can compare the structure with a simpler alternative.
- [ ] I can analyze build time, operation time, and space separately.

## Further reading and references

This lesson is designed to stand on its own; use these primary or educational sources for deeper study.

- [CP-Algorithms — Suffix Array](https://cp-algorithms.com/string/suffix-array.html)
- [Manber & Myers, “Suffix Arrays: A New Method for On-Line String Searches” (1993)](https://epubs.siam.org/doi/10.1137/0222058)
- [Princeton Algorithms — String Searches](https://algs4.cs.princeton.edu/53substring/)
- [Princeton Algorithms — Tries and String Sorting](https://algs4.cs.princeton.edu/52trie/)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
