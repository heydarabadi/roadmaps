# Linear Search

> Course: [Chapter 3](../readme.en.md) · [Original Persian lesson](readme.md) · Prerequisites: sequences and loops

## Learning goals and prerequisites

You should be comfortable with sequences and loops. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Check each element against the target in sequence. Linear search requires no ordering, so it is a sound baseline for small, unsorted data and a useful reference implementation.

## Representation, contract, and invariant

First define the contract: return any matching index, the first match, the last match, or every match? Before checking index i, the loop invariant says no earlier element matched. After an unsuccessful full pass, the target is absent.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

For `i` from 0 through n−1, compare A[i] with x. Return i as soon as they match; if the loop ends, return an explicit not-found result. To collect all matches, record each one and continue to the end.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

In `[8,3,9,3]`, searching for 3 compares 8 then 3, so the first matching index is 1. Searching for 7 compares all four elements. A target at index 0 takes one comparison.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

After i unsuccessful comparisons, x does not occur in A[0..i). When the loop reaches n, the whole sequence has been ruled out. This proves both the successful early return and the not-found result.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Best case O(1), worst/typical unsuccessful search O(n), auxiliary space O(1). Finding all occurrences always requires a full pass, O(n).

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

A quick scan is often best for a small in-memory list, a one-off lookup, or validating a collection before building an index. For repeated queries, preprocessing may pay off.

## Common mistakes and edge cases

Distinguish “not found” from index 0 with a sentinel/result type. If equality is expensive, include its cost. Do not sort a dataset unless the expected future queries justify sorting and maintaining order.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Count comparisons for a first-position hit, last-position hit, and miss in a 6-element list. 2. Write a version returning every index. 3. Why can a single linear query be cheaper than sorting first and then using binary search?

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What precondition does linear search avoid?
   **Explained answer:** The data does not need to be sorted.
2. **Question:** What is its worst-case time?
   **Explained answer:** O(n) comparisons.
3. **Question:** What does the loop invariant say?
   **Explained answer:** No element before the current index matched the target.
4. **Question:** How do you find every occurrence?
   **Explained answer:** Continue through the full sequence and collect all matching indexes.
5. **Question:** When is it a good choice?
   **Explained answer:** For small or unsorted inputs, or only a few searches.

## Further reading and references

- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Searching and algorithm analysis.
- [Princeton Algorithms, Section 1.1](https://algs4.cs.princeton.edu/11model/) — Cost models and elementary analysis.
- [OpenDSA search and sort modules](https://opendsa.cs.vt.edu/home/books) — Search-related teaching material; browse the book index.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — The roadmap placement of search topics.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
