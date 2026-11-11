# Insertion Sort

> Course: [Chapter 3](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/03-searching-and-sorting/insertion-sort/README.md) · Prerequisites: arrays, loops, and comparisons

## Learning goals and prerequisites

You should be comfortable with arrays, loops, and comparisons. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Process items one at a time and insert each into its correct place in the sorted prefix—like arranging cards in your hand.

## Representation, contract, and invariant

Before iteration i, `[0,i)` is sorted. Save `key=A[i]`, shift larger prefix elements one position right, then put key into the hole. Use `>` rather than `>=` so equal items keep their original order.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

For i from 1 to n−1: `key=A[i]`, `j=i−1`; while j≥0 and A[j]>key, assign A[j+1]=A[j] and decrement j; finally assign `A[j+1]=key`.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

Trace `[5,2,4,2]`: insert 2 before 5→`[2,5,4,2]`; insert 4 before 5→`[2,4,5,2]`; insert the final 2 after the existing 2 and before 4→`[2,2,4,5]`.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

At the start of each iteration, the prefix is sorted. Shifting only values greater than key preserves their order and creates one slot; writing key into that slot leaves a sorted prefix one element longer. The unchanged order among equals proves stability.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Best case Θ(n) for already sorted input; average and worst Θ(n²); auxiliary space O(1); stable. Its number of shifts is proportional to the number of inversions, so nearly sorted input is favorable.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Insertion sort is simple and performs well for tiny or nearly sorted runs. Production sorting libraries often combine it with a larger algorithm to reduce overhead on small partitions.

## Common mistakes and edge cases

Save key before shifting, or it can be overwritten. Check `j>=0` before reading A[j]. The quadratic worst case makes it a poor choice for large random arrays, although hybrid library sorts may use it for small runs.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Trace `[7,3,5,3]` after each insertion. 2. Explain why `>` preserves stability. 3. Compare shifts on sorted input with a reverse-sorted input.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What is the insertion-sort idea?
   **Explained answer:** Insert each next item into its proper position in the sorted prefix.
2. **Question:** What is the invariant at the start of iteration i?
   **Explained answer:** The prefix before i is sorted.
3. **Question:** What is the best-case time?
   **Explained answer:** Θ(n) on already sorted input.
4. **Question:** Why is it stable with the stated condition?
   **Explained answer:** An item shifts only past strictly greater keys, not equal ones.
5. **Question:** When is it useful?
   **Explained answer:** Small or nearly sorted arrays, including small runs in hybrid sorts.

## Further reading and references

- [Princeton Algorithms, Section 2.1](https://algs4.cs.princeton.edu/21elementary/) — Insertion sort, stability, and elementary-sort analysis.
- [MIT 6.006 Sorting lecture notes](https://courses.csail.mit.edu/6.006/fall11/notes.shtml) — Lecture notes cover insertion and merge sorting.
- [USFCA sorting visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Stepwise insertion-sort animation.
- [Python sorting HOWTO](https://docs.python.org/3/howto/sorting.html) — Practical sorting behavior and key functions.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
