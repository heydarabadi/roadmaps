# Bubble Sort

> Course: [Chapter 3](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/03-searching-and-sorting/bubble-sort/README.md) · Prerequisites: arrays, loops, and comparisons

## Learning goals and prerequisites

You should be comfortable with arrays, loops, and comparisons. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Repeatedly compare adjacent items and swap an inverted pair. After a complete left-to-right pass, the largest item in the unsorted prefix has moved to the end of that prefix.

## Representation, contract, and invariant

After pass k, the final k positions are fixed in sorted order. An optimized version tracks whether any swap happened; a swap-free pass proves the array is already sorted. Use a strict `>` test so equal keys are not swapped and stability is preserved.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

For `end` from n−1 down to 1: set `swapped=false`; scan i from 0 to end−1; if A[i]>A[i+1], swap and set swapped=true. Stop early if swapped remains false.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

Start with `[5,1,4,2]`. First pass: 5/1→`[1,5,4,2]`; 5/4→`[1,4,5,2]`; 5/2→`[1,4,2,5]`. The largest element, 5, is now final. The next pass sorts the remaining prefix.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

At each adjacent comparison, the larger value moves right when inverted. Thus the largest value in the active prefix reaches its right boundary each pass. Repeating this fixes the whole suffix and eventually the array.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Average and worst case Θ(n²); optimized best case Θ(n); auxiliary space O(1). Stable when equal items are not swapped. It is unsuitable for large datasets.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Bubble sort is mainly an instructional tool. In production, a standard library sort is usually faster and more robust.

## Common mistakes and edge cases

Without the early-stop flag, even sorted input gets unnecessary passes. Shorten the active boundary after each pass. Make sure the comparison respects the desired ordering and tie behavior.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Trace `[3,2a,2b,1]` pass by pass. 2. Relate the number of swaps to the input's inversions. 3. Check whether the relative order of 2a and 2b is preserved.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What is fixed after the first pass?
   **Explained answer:** The maximum item is at the final index.
2. **Question:** What is the worst-case time?
   **Explained answer:** Θ(n²).
3. **Question:** How does the optimized version get a linear best case?
   **Explained answer:** It stops after a pass with no swaps.
4. **Question:** When is it stable?
   **Explained answer:** When equal items are not swapped, e.g. swap only for `left > right`.
5. **Question:** What is its main use today?
   **Explained answer:** Teaching adjacent swaps, not production-scale sorting.

## Further reading and references

- [Princeton Algorithms, Section 2.1](https://algs4.cs.princeton.edu/21elementary/) — Elementary sorting algorithms and properties.
- [USFCA algorithm visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Step-through sorting animations.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Sorting and analysis material.
- [OpenDSA sorting modules](https://opendsa.cs.vt.edu/home/books) — Interactive sorting lessons; use the book navigation.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
