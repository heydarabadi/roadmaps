# Selection Sort

> Course: [Chapter 3](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/03-searching-and-sorting/selection-sort/README.md) · Prerequisites: arrays, nested loops, and comparisons

## Learning goals and prerequisites

You should be comfortable with arrays, nested loops, and comparisons. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

At each position i, find the minimum element in the unsorted suffix and exchange it with A[i]. The sorted prefix grows by one item per pass.

## Representation, contract, and invariant

After pass i, the prefix `[0,i]` contains the i+1 smallest elements in order. Selection sort always performs n(n−1)/2 comparisons, but at most n−1 swaps; this can matter when writes are expensive.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

For i from 0 to n−2: set `min=i`; scan j from i+1 to n−1 and update min when A[j]<A[min]; then swap A[i] and A[min].

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

On `[29,10,14,37]`, the first scan finds 10 at index 1 and swaps it with 29: `[10,29,14,37]`. The next scan finds 14 and produces `[10,14,29,37]`. The final pass leaves the array unchanged.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

The selected minimum is no greater than any element remaining in the suffix. Placing it at the prefix boundary preserves the prefix order and ensures the prefix contains the smallest values. After n−1 passes, the last remaining element must be correctly placed.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Best, average, and worst time are Θ(n²); auxiliary space is O(1); swaps are O(n). The usual distant swap is not stable, because it can move an equal-key item past another equal-key item.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Selection sort can be useful when writes are unusually costly and the input is small; otherwise, insertion sort or a library algorithm is generally a better fit.

## Common mistakes and edge cases

Do not confuse the quadratic comparison count with the linear swap count. The long-distance exchange can break stability. Handle empty and one-item arrays without reading an invalid index.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Trace `[4a,2,4b,1]` and check the relative order of 4a and 4b. 2. Count comparisons for n=5. 3. Why might insertion sort be preferable on nearly sorted data?

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What does each pass select?
   **Explained answer:** The minimum of the unsorted suffix.
2. **Question:** How many comparisons are made?
   **Explained answer:** n(n−1)/2, hence Θ(n²).
3. **Question:** What is one advantage over bubble sort?
   **Explained answer:** It uses at most n−1 swaps.
4. **Question:** Is the usual implementation stable?
   **Explained answer:** No; distant swaps can reorder equal keys.
5. **Question:** When is insertion sort often better?
   **Explained answer:** For small or nearly sorted input.

## Further reading and references

- [Princeton Algorithms, Section 2.1](https://algs4.cs.princeton.edu/21elementary/) — Selection, insertion, and elementary-sort properties.
- [USFCA sorting visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Animation of selection-sort passes.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Sorting analysis and lower bounds.
- [OpenDSA sorting modules](https://opendsa.cs.vt.edu/home/books) — Additional visual lessons on sorting.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
