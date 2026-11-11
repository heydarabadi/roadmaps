# Quick Sort

> Course: [Chapter 3](../readme.en.md) · [Original Persian lesson](readme.md) · Prerequisites: arrays, recursion, and partitioning

## Learning goals and prerequisites

You should be comfortable with arrays, recursion, and partitioning. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Choose a pivot, partition elements around it, and recursively sort the two regions. The quality of the split strongly affects performance.

## Representation, contract, and invariant

In Lomuto partition, pivot is often the final item. Boundary i marks the end of the region containing items ≤ pivot; j scans the unprocessed suffix. Hoare partition returns a different boundary and must not be mixed with Lomuto recursion rules.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Lomuto: set pivot=A[R], i=L. For j=L..R−1, when A[j]≤pivot, swap A[i],A[j] and increment i. Finally swap A[i],A[R], returning p=i. Recurse on `[L,p−1]` and `[p+1,R]`. Random pivots reduce the chance of repeated bad splits but do not eliminate worst-case behavior.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

For `[4,2,7,3]` with pivot 3, 4 is skipped, 2 moves to the left boundary, and 7 is skipped. Swap pivot with 4 to get `[2,3,7,4]`. Pivot 3 is now in its final index; only the two sides remain to be sorted.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

During Lomuto partition, A[L..i)≤pivot, A[i..j)>pivot, and A[j..R) is unprocessed. At the end the pivot is in a position where all left values are no greater and all right values no smaller; recursive calls sort each side.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Average Θ(n log n), worst Θ(n²), average recursion space O(log n), worst O(n). In-place partition is not stable. Three-way partition can be effective when many keys are equal.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

In-memory library sorts often use quicksort-family ideas because partitioning has good locality and low constants. Production implementations commonly add safeguards or use hybrid algorithms.

## Common mistakes and edge cases

Use the exact partition contract to form recursive ranges. Duplicate-heavy data may cause poor two-way splits. Randomization protects expected performance against fixed input order, not the worst-case bound. Avoid excessive recursive depth or use an introspective fallback.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Run Lomuto on `[5,1,5,3,2]` with the last item as pivot. 2. Derive the recurrence for repeatedly choosing the smallest pivot on sorted input. 3. Explain why three-way partition helps when every key is equal.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What does partition guarantee?
   **Explained answer:** The pivot is placed so all left-side values compare no greater and right-side values no smaller.
2. **Question:** What is the worst-case time?
   **Explained answer:** Θ(n²), when splits remain highly unbalanced.
3. **Question:** What does random pivoting guarantee?
   **Explained answer:** It improves expected behavior, but does not remove the theoretical worst case.
4. **Question:** Is the usual quicksort stable?
   **Explained answer:** No.
5. **Question:** Why use a hybrid sort in a library?
   **Explained answer:** To combine practical speed with protection against pathological input and recursion depth.

## Further reading and references

- [Princeton Algorithms, Section 2.3: Quicksort](https://algs4.cs.princeton.edu/23quicksort/) — Partitioning, randomized pivots, and three-way quicksort.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Divide-and-conquer sorting and analysis.
- [USFCA sorting visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Animated partitions and recursive ranges.
- [Python Sorting HOWTO](https://docs.python.org/3/howto/sorting.html) — Practical production sorting alternatives.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
