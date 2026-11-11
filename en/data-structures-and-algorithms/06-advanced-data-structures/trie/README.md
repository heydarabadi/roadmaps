# Trie (Prefix Tree)

> Path: [Chapter 6 — Advanced Data Structures](../README.md) · [Persian lesson](../../../../fa/data-structures-and-algorithms/06-advanced-data-structures/trie/README.md) · Suggested prerequisites: Trees, strings, child maps/arrays, and equality of characters.

## Prerequisites and mental model

Trees, strings, child maps/arrays, and equality of characters. Begin by identifying the operations and constraints the structure must support; advanced structures are useful only when their special operation matters to the workload.

## Core idea

A trie shares common prefixes. Each edge stores one symbol, and a path from the root represents a prefix. A separate end-of-word marker distinguishes a complete key from a prefix of a longer key.

## Representation, contract, and invariant

For a small fixed alphabet, each node can hold an array of child pointers; for a large or sparse alphabet, use a map. A node may have children while not representing a stored word. For example, the path `car` is also a prefix of `cart`, but `car` is a complete key only when its terminal marker is set.

An invariant is a property the representation must preserve after every update. State it before implementation so that the update rules and correctness argument can be checked against it.

## Step-by-step operations

Insert: start at the root; for each symbol, create or follow its child; mark the final node as a word. Exact lookup follows the same path and returns the terminal marker. Prefix lookup only requires reaching the prefix node. Delete by clearing the terminal marker, then prune empty nodes from the bottom while no stored word uses them.

For production code, define empty input, duplicate keys, bounds, and update semantics explicitly. Keep the chosen indexing convention consistent throughout the implementation.

## Worked trace

Insert `to`, `tea`, and `ten`. They share the first edge `t`; under it, `o` ends a word and `e` branches to `a` and `n`. Lookup for `te` succeeds as a prefix but not as a complete word unless its terminal marker was set.

Use a table with operation, affected node/index, state before, state after, and the invariant being restored. The trace should include at least one boundary or duplicate case.

## Why it works

Every stored word corresponds to a root-to-node path whose edge labels concatenate to the word and whose terminal marker is true. All keys below a node share the prefix represented by the path to that node. Lookup is correct because it follows exactly those labels and checks the right terminal condition.

Check that initialization establishes the invariant, every operation preserves it, and the final query combines exactly the state required by its contract.

## Time and space analysis

Insert and exact/prefix lookup take O(L) symbol steps for a key of length L, independent of the number of keys in the idealized model. Space is proportional to distinct prefixes multiplied by per-node child storage. A fixed child array is fast but can waste space; a map reduces empty slots but adds lookup/entry overhead.

Separate construction cost, per-operation cost, and auxiliary space. Expected/amortized bounds are not worst-case bounds; include the required assumptions.

## Real-world applications and trade-offs

Autocomplete, prefix dictionaries, routing prefixes, lexicographic enumeration, and multi-pattern matching when combined with failure links (Aho–Corasick). Radix/compressed tries merge one-child paths to reduce node overhead.

Compare this structure with a simpler alternative before adopting it. Memory locality, implementation complexity, update pattern, and query mix may outweigh an asymptotic improvement for small inputs.

## Common mistakes and edge cases

Do not infer word completion from leaf status. Deletion must preserve branches shared by other keys. Define Unicode normalization, case folding, and what a “character” means; a code unit may not be a user-perceived character. Memory overhead can dominate for many short keys.

Test empty structures, one element, repeated keys, minimum/maximum legal index, and invalid bounds. If the algorithm mutates the input, document that behavior.

## Exercises

1. Draw a trie for `a`, `an`, `ant`, and `all`. 2. Test exact lookup and prefix lookup for `an`. 3. Compare memory use of a 26-child array versus a sparse map for one-character words.

For each exercise, write the state and invariant before coding, then analyze both time and memory.

## Comprehensive quiz with explained answers

Try to answer before reading the explanations.

1. **Question:** What does each trie edge contain?
   **Answer:** One symbol or character unit.
2. **Question:** Why have a terminal-word flag?
   **Answer:** A path can be a valid prefix without being a stored complete word.
3. **Question:** What is the lookup time for a length-L string?
   **Answer:** O(L) in the usual model.
4. **Question:** Name a common use.
   **Answer:** Autocomplete or prefix lookup.
5. **Question:** What is a weakness of a fixed child array?
   **Answer:** It allocates slots even for absent children, which can waste memory.

## Mastery checklist

- [ ] I can explain the data representation and its invariant.
- [ ] I can execute an update/query by hand on a small example.
- [ ] I know which operation is optimized and which assumptions are required.
- [ ] I can compare the structure with a simpler alternative.
- [ ] I can analyze build time, operation time, and space separately.

## Further reading and references

This lesson is designed to stand on its own; use these primary or educational sources for deeper study.

- [Princeton Algorithms — Tries](https://algs4.cs.princeton.edu/52trie/)
- [CP-Algorithms — Aho–Corasick (trie-based matching)](https://cp-algorithms.com/string/aho_corasick.html)
- [NIST Dictionary — trie](https://xlinux.nist.gov/dads/HTML/trie.html)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
- [Princeton Algorithms — Strings](https://algs4.cs.princeton.edu/50strings/)
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)
