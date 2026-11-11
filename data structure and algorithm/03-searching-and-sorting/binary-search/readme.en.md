# Binary Search and Lower Bound

> Course: [Chapter 3](../readme.en.md) · [Original Persian lesson](readme.md) · Prerequisites: a sorted array, a consistent comparator, and interval reasoning

## Learning goals and prerequisites

You should be comfortable with a sorted array, a consistent comparator, and interval reasoning. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Sorted order lets each comparison discard half the remaining candidate positions. The classic array version depends on random access; a linked list does not provide constant-time access to its midpoint.

## Representation, contract, and invariant

Maintain a half-open interval `[lo, hi)`. If x occurs, its possible index stays inside this interval. In the lower-bound version, the answer is the first position whose value is at least x. Half-open ranges make an empty interval exactly `lo == hi` and its length `hi−lo`.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

While `lo < hi`, set `mid = lo + (hi−lo)//2`. If A[mid] < x, set `lo=mid+1`; otherwise set `hi=mid`. At termination, `lo` is lower_bound. Check `lo<n and A[lo]==x` to test membership. For an arbitrary match, equality may return immediately; for first/last duplicate, use lower/upper bound.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

For A=`[1,3,3,3,8,12]`, x=3: `[0,6)` has mid 3, so hi=3; `[0,3)` has mid 1, so hi=1; `[0,1)` has mid 0 and 1<3, so lo=1. The lower bound is index 1, the first 3.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

Each iteration keeps every possible answer in the active range and strictly shrinks the range. At termination the range is empty; the boundary lo separates values `<x` from values `≥x`, which proves the lower-bound result.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Time O(log n), iterative auxiliary space O(1); recursive space O(log n). If the array must first be sorted, one query may cost more overall; repeated searches can amortize that preprocessing.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Binary search finds insertion positions, version thresholds, sorted ranges, and the first point where a monotone condition becomes true. Database storage often uses a B-tree instead because it is designed around page I/O.

## Common mistakes and edge cases

Do not mix inclusive and half-open endpoints. Ensure every loop removes at least one candidate; use a safe midpoint formula. Sortedness must match the comparator. Define which duplicate occurrence you need.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Find lower_bound of 4 and 5 in `[2,4,4,4,9]`. 2. Modify the predicate to find the first value greater than x. 3. For binary search on an answer, state why the feasibility predicate must be monotone.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What is the main precondition?
   **Explained answer:** The array is sorted according to the same comparator used by the search.
2. **Question:** What happens each iteration?
   **Explained answer:** The invariant lets us discard half of the remaining candidate interval.
3. **Question:** What is the time complexity?
   **Explained answer:** O(log n).
4. **Question:** Why search carefully when values repeat?
   **Explained answer:** You may need a first/last occurrence or a lower/upper bound, not any match.
5. **Question:** What is lower_bound?
   **Explained answer:** The first index with A[i] ≥ x, or n if no such position exists.

## Further reading and references

- [CP-Algorithms: Binary Search](https://cp-algorithms.com/num_methods/binary_search.html) — Boundary-based binary search and common variants.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Searching, sorting, and binary-search reasoning.
- [Python bisect documentation](https://docs.python.org/3/library/bisect.html) — `bisect_left` and `bisect_right` boundary APIs.
- [Princeton Algorithms, Section 1.1](https://algs4.cs.princeton.edu/11model/) — Search cost models and ordered data.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
