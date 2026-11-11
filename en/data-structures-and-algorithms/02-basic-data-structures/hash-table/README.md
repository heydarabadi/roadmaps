# Hash Table

> Course: [Chapter 2](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/02-basic-data-structures/hash-table/README.md) · Prerequisites: arrays, equality, functions, and average versus worst-case analysis

## Learning goals and prerequisites

You should be comfortable with arrays, equality, functions, and average versus worst-case analysis. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

A hash table maps a key through a hash function to an array bucket, aiming for average O(1) insertion and lookup. Because there are usually more possible keys than buckets, collisions are unavoidable; collision resolution is central to the design.

## Representation, contract, and invariant

Equal keys must have equal hashes, and a key's hash/equality must remain stable while stored. A common index is `hash(key) mod capacity`. Chaining stores several key/value pairs per bucket; open addressing probes other slots. For chaining, load factor is n/m, where n is stored keys and m is buckets; implementations resize to control it.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

With chaining, compute the bucket and compare its keys using equality. Update the value if the key exists; otherwise insert a new pair. With open addressing, follow the probe sequence until the key or a never-used empty slot is found. Deletion typically uses a tombstone so lookup does not stop too early.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

Let capacity be 7 and `h(k)=k mod 7`. Keys 10 and 17 both map to bucket 3. Chaining stores both in bucket 3, and lookup for 17 checks equality in that bucket. Linear probing stores the second key in a later empty slot; as the table fills, probe sequences can grow.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

In chaining, every pair must be in the bucket determined by its current hash. In open addressing, a key's probe path must not be cut off by a truly empty slot before its stored position. The hash narrows the search; equality decides whether a key matches.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

With a good hash distribution and controlled load factor, lookup/insert/delete are average or expected O(1); worst-case collisions can make them O(n). A resize costs O(n) but is typically amortized across insertions. Space is O(m+n), depending on representation.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Maps and sets power caches, in-memory indexes, frequency counting, de-duplication, and identifier-to-object lookup. Services exposed to hostile input should consider hash-flooding defenses; some runtimes randomize hashing.

## Common mistakes and edge cases

Do not state O(1) without the average/expected qualification. Do not mutate fields used by hash/equality while a key is stored. In probing, distinguish tombstones from never-used empty slots. Hash-table hashing is not the same problem as cryptographic hashing. Ordered iteration is not guaranteed unless the API promises it.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Insert 12, 7, and 22 into a capacity-5 table using `h(k)=k mod 5`, once with chaining and once with linear probing. 2. Explain why mutating a key after insertion can make it seem to disappear. 3. What can collision flooding do to an untrusted-input service?

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** Why do collisions happen?
   **Explained answer:** The key space is usually much larger than the finite number of table slots.
2. **Question:** If two keys have the same hash, are they equal?
   **Explained answer:** No. Equal keys must hash alike, but equal hashes do not prove equality.
3. **Question:** What is average lookup complexity?
   **Explained answer:** O(1) with suitable hashing and load control; worst-case can be O(n).
4. **Question:** Why use tombstones in open addressing?
   **Explained answer:** A truly empty slot would prematurely terminate lookup for keys farther along the probe path.
5. **Question:** What must remain stable about a stored key?
   **Explained answer:** Its hash and equality behavior.

## Further reading and references

- [Princeton Algorithms, Section 3.4: Hash Tables](https://algs4.cs.princeton.edu/34hash/) — Hash functions, collision resolution, and implementations.
- [Python mapping types: dict](https://docs.python.org/3/library/stdtypes.html#mapping-types-dict) — Official dictionary API and semantics.
- [Java HashMap API](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/HashMap.html) — Hash-map contract and performance notes.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Hashing and expected-cost analysis.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
