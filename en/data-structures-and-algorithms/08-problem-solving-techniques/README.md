# Chapter 8 — Problem-Solving Techniques

> [Persian chapter](../../../fa/data-structures-and-algorithms/08-problem-solving-techniques/README.md) · [Course index](../README.md)

Learn to recognize a useful structure in the input, then prove that the chosen pattern is valid. Pattern names are memory aids; they are not substitutes for preconditions and correctness arguments.

## Suggested study order

1. Begin with [recursion](recursion/README.md), [brute force](brute-force/README.md), and [divide and conquer](divide-and-conquer/README.md).
2. Study [backtracking](backtracking/README.md), then [greedy algorithms](greedy/README.md) and [dynamic programming](dynamic-programming/README.md); compare their state and proof requirements.
3. Practice array and range patterns: [two pointers](two-pointers/README.md), [fast/slow pointers](fast-slow-pointers/README.md), [sliding window](sliding-window/README.md), [merge intervals](merge-intervals/README.md), [cyclic sort](cyclic-sort/README.md), and [island traversal](island-traversal/README.md).
4. Learn rank and streaming patterns: [k-th element](kth-element/README.md) and [two heaps](two-heaps/README.md).
5. Finish with [randomized algorithms](randomized-algorithms/README.md) and [multithreaded algorithms](multithreaded-algorithms/README.md), where probability and synchronization assumptions matter.

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
- [Topic-by-topic reading list](../references.md)

## Mastery standard

For three similar problems, explain why one tempting pattern fails and what condition makes the suitable pattern work. A label such as “DP” or “two pointers” is not a solution until the state, invariant, proof, and complexity are clear.

## Topic lessons

- [Brute force](brute-force/README.md)
- [Backtracking](backtracking/README.md)
- [Greedy algorithms](greedy/README.md)
- [Randomized algorithms](randomized-algorithms/README.md)
- [Divide and conquer](divide-and-conquer/README.md)
- [Recursion](recursion/README.md)
- [Dynamic programming](dynamic-programming/README.md)
- [Two pointers](two-pointers/README.md)
- [Sliding window](sliding-window/README.md)
- [Fast and slow pointers](fast-slow-pointers/README.md)
- [Cyclic sort](cyclic-sort/README.md)
- [Merge intervals](merge-intervals/README.md)
- [K-th element](kth-element/README.md)
- [Two heaps](two-heaps/README.md)
- [Island traversal](island-traversal/README.md)
- [Multithreaded algorithms](multithreaded-algorithms/README.md)
