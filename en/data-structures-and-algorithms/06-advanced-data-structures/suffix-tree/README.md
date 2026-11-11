# Suffix Tree

> Path: [Chapter 6 — Advanced Data Structures](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/06-advanced-data-structures/suffix-tree/README.md) · Suggested prerequisites: Strings, tries, suffixes, and compressed edge labels.

## Prerequisites and mental model

Strings, tries, suffixes, and compressed edge labels. Begin by identifying the operations and constraints the structure must support; advanced structures are useful only when their special operation matters to the workload.

## Core idea

A suffix tree is a compressed trie of all suffixes of a text. Paths with only one child are merged into one edge whose label refers to a range in the original text, avoiding repeated copies of long suffix strings.

## Representation, contract, and invariant

Append a unique sentinel so every suffix ends at its own leaf. A pattern may finish in the middle of an edge and still be present; the search need not stop exactly at an explicit node. Edge labels are usually text-index ranges rather than allocated strings.

An invariant is a property the representation must preserve after every update. State it before implementation so that the update rules and correctness argument can be checked against it.

## Step-by-step operations

A naive method inserts every suffix into a trie and can require quadratic work/space. Ukkonen’s online algorithm uses suffix links and active-point state to build a suffix tree in linear time under its alphabet/child-access assumptions. For learning, first construct the suffix trie of a short string by hand, then compress unary paths.

For production code, define empty input, duplicate keys, bounds, and update semantics explicitly. Keep the chosen indexing convention consistent throughout the implementation.

## Worked trace

For `banana$`, the suffixes are `$`, `a$`, `ana$`, `anana$`, `banana$`, `na$`, and `nana$`. Shared paths such as `ana` are represented once and branch toward distinct leaves. Searching `nan` follows the corresponding compressed edges and can terminate inside one.

Use a table with operation, affected node/index, state before, state after, and the invariant being restored. The trace should include at least one boundary or duplicate case.

## Why it works

Each suffix corresponds to exactly one leaf, and the concatenated edge labels from the root to that leaf reproduce that suffix. Because edge labels reference ranges in the source text, the representation shares repeated text rather than copying it.

Check that initialization establishes the invariant, every operation preserves it, and the final query combines exactly the state required by its contract.

## Time and space analysis

Ukkonen construction is O(n) time and O(n) space under the usual assumptions, but implementation details are subtle. Pattern search is O(m) plus the cost of reporting matches for a pattern of length m. Constants and alphabet representation can be significant.

Separate construction cost, per-operation cost, and auxiliary space. Expected/amortized bounds are not worst-case bounds; include the required assumptions.

## Real-world applications and trade-offs

Substring indexing over static text, DNA/genome analysis, repeated-substring queries, and text-processing systems. Suffix arrays with LCP often use less memory and may be preferred in practice.

Compare this structure with a simpler alternative before adopting it. Memory locality, implementation complexity, update pattern, and query mix may outweigh an asymptotic improvement for small inputs.

## Common mistakes and edge cases

Without a unique sentinel, one suffix may be a prefix of another and leaf endings are less explicit. Do not copy edge-label substrings. State the alphabet model behind a linear-time claim. The construction is substantially harder to implement than suffix-array doubling.

Test empty structures, one element, repeated keys, minimum/maximum legal index, and invalid bounds. If the algorithm mutates the input, document that behavior.

## Exercises

1. Build the suffix trie for `aba$` and compress its unary paths. 2. Show a successful pattern search that ends mid-edge. 3. Compare suffix-tree and suffix-array trade-offs in memory, search, and implementation complexity.

For each exercise, write the state and invariant before coding, then analyze both time and memory.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What is compressed in a suffix tree?
   **Answer:** Unary paths in the suffix trie are merged into labeled edges.
2. **Question:** How are edge labels stored efficiently?
   **Answer:** As ranges into the original text.
3. **Question:** Why append a sentinel?
   **Answer:** To distinguish and terminate every suffix at a separate leaf.
4. **Question:** What is Ukkonen’s usual construction bound?
   **Answer:** O(n) under the standard alphabet/data-structure assumptions.
5. **Question:** What is a common lower-memory alternative?
   **Answer:** A suffix array with an LCP array, or an FM-index for compressed text indexing.

## Mastery checklist

- [ ] I can explain the data representation and its invariant.
- [ ] I can execute an update/query by hand on a small example.
- [ ] I know which operation is optimized and which assumptions are required.
- [ ] I can compare the structure with a simpler alternative.
- [ ] I can analyze build time, operation time, and space separately.

## Further reading and references

This lesson is designed to stand on its own; use these primary or educational sources for deeper study.

- [Ukkonen, “On-Line Construction of Suffix Trees” (1995), author-hosted course copy](https://cs.brown.edu/courses/csci1820/spring-2022/resources/Ukkonen_1995.pdf)
- [Ukkonen paper DOI](https://doi.org/10.1007/BF01206331)
- [Manber & Myers — Suffix Arrays (1993)](https://epubs.siam.org/doi/10.1137/0222058)
- [Princeton Algorithms — String Searches and Tries](https://algs4.cs.princeton.edu/50strings/)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
