# Chapter 8 — Problem-Solving Techniques

> [Persian chapter](readme.md) · [Course index](../readme.en.md)

Learn to recognize a useful structure in the input, then prove that the chosen pattern is valid. Pattern names are memory aids; they are not substitutes for preconditions and correctness arguments.

## Suggested study order

1. Begin with [recursion](recursion/readme.en.md), [brute force](brute-force/readme.en.md), and [divide and conquer](divide-and-conquer/readme.en.md).
2. Study [backtracking](backtracking/readme.en.md), then [greedy algorithms](greedy/readme.en.md) and [dynamic programming](dynamic-programming/readme.en.md); compare their state and proof requirements.
3. Practice array and range patterns: [two pointers](two-pointers/readme.en.md), [fast/slow pointers](fast-slow-pointers/readme.en.md), [sliding window](sliding-window/readme.en.md), [merge intervals](merge-intervals/readme.en.md), [cyclic sort](cyclic-sort/readme.en.md), and [island traversal](island-traversal/readme.en.md).
4. Learn rank and streaming patterns: [k-th element](kth-element/readme.en.md) and [two heaps](two-heaps/readme.en.md).
5. Finish with [randomized algorithms](randomized-algorithms/readme.en.md) and [multithreaded algorithms](multithreaded-algorithms/readme.en.md), where probability and synchronization assumptions matter.

## Choose a pattern from the problem

| Clue in the specification | Pattern to investigate | What you must establish |
|---|---|---|
| Enumerate all valid combinations | Backtracking | State validity, exhaustive choices, and safe pruning |
| An optimal answer is built from repeated subproblems | Dynamic programming | Complete state, recurrence, base cases, evaluation order |
| A local choice appears to leave the most room | Greedy | A proof that each local choice is globally safe |
| The answer concerns a contiguous range | Sliding window or prefix sums | The condition and window movement are monotone where required |
| The input is sorted, or two sequences are sorted | Two pointers | Why moving one pointer cannot discard an answer |
| The problem asks for a rank but not a full ordering | Quickselect or a heap | Correct rank convention and duplicate policy |
| Ranges overlap | Merge intervals | Endpoint inclusivity and overlap convention |
| Several values must remain near the median boundary | Two heaps | Partition order and size-balance invariants |

## A complete selection workflow

First describe the output: one answer, all answers, an optimum, or a count of contiguous ranges. Read n and other constraints. Write a correct baseline, then identify the expensive repeated work. Ask whether the input is sorted, whether the answer has a monotonic property, whether subproblems overlap, and whether a partial choice can be rejected safely. State an invariant before coding. Finally, test a counterexample to the most tempting but invalid pattern.

For example, a variable sliding window for a sum bound works with nonnegative values because expanding cannot reduce the sum and contracting cannot increase it. A negative number destroys that monotonicity; the same-looking problem may require prefix sums or a different algorithm. A greedy scheduling rule also needs an exchange proof; trying a few examples is not enough.

## Roadmap parent lesson: Problem-Solving Techniques

These techniques connect constraints to a search or state space. Start from a simple correct method; identify which candidates can be eliminated and why; preserve a clear invariant; and include the cost of every transition, copy, and synchronization step. Brute force may be polynomial, exponential, or factorial depending on the candidate space. DP reduces repeated computation only when its states and transitions are correct. Two pointers may reduce a sorted scan to O(n), but only with a valid pointer-movement proof.

## Chapter review quiz

1. **Why does overlap among subproblems suggest DP?** The same state can be reused rather than recomputed.
2. **Can a greedy algorithm be accepted without a proof?** No; a counterexample may invalidate a plausible local rule.
3. **Does the standard sum-based sliding window always work with negative numbers?** No; its monotonicity argument can fail.
4. **What must backtracking undo?** Every shared state change made for the current branch.
5. **What do two heaps expose for an online median?** The maximum of the lower half and minimum of the upper half.
6. **What do work and span measure?** Total computation and the longest chain of dependent work.

## Further reading and references

- [MIT 6.006 lecture videos and notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)
- [MIT 6.006 Recitation 15 — Dynamic Programming](https://live.ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/6022dc36557c5e5df2ad0a77e9463855_MIT6_006S20_r15.pdf)
- [Stanford CS106B — Backtracking pseudocode and N-Queens](https://see.stanford.edu/Course/CS106B/149)
- [USACO Guide — Two Pointers and Sliding Window](https://usaco.guide/silver/two-pointers)
- [CP-Algorithms — K-th order statistic](https://cp-algorithms.com/sequences/k-th.html)
- [CP-Algorithms — Floyd cycle-finding algorithm](https://cp-algorithms.com/others/tortoise_and_hare.html)
- [MIT 6.506 — Parallel Algorithms, Work-Span model](https://jshun.csail.mit.edu/6506-f25/lectures/lecture2.pdf)
- [University of Texas — Randomized Algorithms lecture notes](https://www.cs.utexas.edu/~ecprice/courses/randomized/fa15/notes/lec1.pdf)
- [Topic-by-topic reading list](../references.en.md)

## Mastery standard

For three similar problems, explain why one tempting pattern fails and what condition makes the suitable pattern work. A label such as “DP” or “two pointers” is not a solution until the state, invariant, proof, and complexity are clear.

## Topic lessons

- [Brute force](brute-force/readme.en.md)
- [Backtracking](backtracking/readme.en.md)
- [Greedy algorithms](greedy/readme.en.md)
- [Randomized algorithms](randomized-algorithms/readme.en.md)
- [Divide and conquer](divide-and-conquer/readme.en.md)
- [Recursion](recursion/readme.en.md)
- [Dynamic programming](dynamic-programming/readme.en.md)
- [Two pointers](two-pointers/readme.en.md)
- [Sliding window](sliding-window/readme.en.md)
- [Fast and slow pointers](fast-slow-pointers/readme.en.md)
- [Cyclic sort](cyclic-sort/readme.en.md)
- [Merge intervals](merge-intervals/readme.en.md)
- [K-th element](kth-element/readme.en.md)
- [Two heaps](two-heaps/readme.en.md)
- [Island traversal](island-traversal/readme.en.md)
- [Multithreaded algorithms](multithreaded-algorithms/readme.en.md)
