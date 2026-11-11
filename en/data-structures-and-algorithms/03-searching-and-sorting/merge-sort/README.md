# Merge Sort

> Course: [Chapter 3](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/03-searching-and-sorting/merge-sort/README.md) · Prerequisites: recursion, arrays, two pointers, and recurrences

## Learning goals and prerequisites

You should be comfortable with recursion, arrays, two pointers, and recurrences. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Merge sort uses divide and conquer: split the array, recursively sort each half, then merge the two sorted halves in linear time.

## Representation, contract, and invariant

The base case is an interval with fewer than two elements. The merge operation reads the head of each sorted half and repeatedly moves the smaller head into an output buffer. When keys tie, take the left-half item first to preserve stability.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

For a half-open interval `[lo,hi)`, stop when `hi−lo≤1`; let `mid=lo+(hi−lo)//2`; sort `[lo,mid)` and `[mid,hi)`; merge them into a reusable buffer, then copy back. During merge use two pointers and append any remaining suffix.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

`[8,3,6,2]` splits into `[8,3]` and `[6,2]`; these split into singleton runs. Merge to `[3,8]` and `[2,6]`, then compare heads: 2, 3, 6, 8. The final result is `[2,3,6,8]`.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

Each recursive call returns a sorted permutation of its input interval. Merging sorted halves chooses their smallest remaining item at every step, so the merged interval is sorted and contains exactly the original items. This preserves the postcondition at each level.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

The recurrence is `T(n)=2T(n/2)+Θ(n)=Θ(n log n)` in all cases. An array implementation usually needs Θ(n) auxiliary buffer and Θ(log n) recursion depth. The standard merge is stable.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

External sorting uses sorted runs and sequential disk reads/writes to process data larger than memory. Stable sorting is also useful when a previous ordering must be preserved among equal keys.

## Common mistakes and edge cases

Account for the buffer and copying. Use one interval convention consistently. Taking the right item first on equal keys breaks stability. Reusing a buffer avoids repeatedly allocating at every recursive level.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Draw the split tree for `[7,2,6,3,5]`. 2. Stably merge `[1,4,8]` and `[2,4,9]`, labeling the equal 4s. 3. Solve the recurrence using a recursion tree.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What are the three stages?
   **Explained answer:** Divide the interval, recursively conquer each half, and merge the sorted results.
2. **Question:** What is the time complexity?
   **Explained answer:** Θ(n log n) in all cases.
3. **Question:** How much auxiliary array space is usual?
   **Explained answer:** Θ(n).
4. **Question:** How do we preserve stability?
   **Explained answer:** Take the left-half item first when keys compare equal.
5. **Question:** What is an external use?
   **Explained answer:** External merge sort orders files larger than RAM using sequential runs and merges.

## Further reading and references

- [Princeton Algorithms, Section 2.2: Mergesort](https://algs4.cs.princeton.edu/22mergesort/) — Implementation, analysis, and stability.
- [MIT 6.006 Fall 2011 notes](https://courses.csail.mit.edu/6.006/fall11/notes.shtml) — Sorting lectures and recurrence analysis.
- [Python Sorting HOWTO](https://docs.python.org/3/howto/sorting.html) — Stable library sorting and practical uses.
- [USFCA sorting visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Visual split and merge trace.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
