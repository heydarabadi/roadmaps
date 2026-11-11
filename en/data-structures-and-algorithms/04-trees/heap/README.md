# Binary Heap

> Course: [Chapter 4](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/04-trees/heap/README.md) · Prerequisites: arrays and complete binary trees

## Learning goals and prerequisites

You should be comfortable with arrays and complete binary trees. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

A binary heap is a complete binary tree satisfying heap order. In a max-heap, each parent is at least as large as its children and the maximum is at the root; in a min-heap, the minimum is at the root. The rest of the heap is not globally sorted.

## Representation, contract, and invariant

For zero-based arrays, left child is `2i+1`, right child `2i+2`, parent `floor((i−1)/2)`. Insert at the final slot, then sift up. Removing the root moves the last item to the root, then sifts it down.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Sift up while the parent-child order is violated, swapping upward. Sift down by choosing the best child for the heap type; swap if it outranks the parent and continue. Build a heap by sifting down from the last parent to the root; this bottom-up construction is Θ(n).

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

For max-heap `[9,7,8,2,5,3]`, insert 10 at the end. Swap it with 8, then 9, until it reaches the root. To remove max, move 3 to the root and sift it below 8 and then the larger eligible child.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

After each update, the tree remains complete and every parent-child relation satisfies heap order; together these imply the minimum or maximum is at the root. Only the ancestor path (sift-up) or descendant path (sift-down) can need repair.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Peek is O(1); push and pop are O(log n); bottom-up build-heap is O(n); arbitrary search is O(n). Storage is O(n).

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Priority queues power event simulation, job scheduling, top-k selection, Dijkstra's algorithm, and merging sorted streams. Use an indexed heap or lazy deletion strategy if arbitrary-priority updates/removals are required.

## Common mistakes and edge cases

Do not confuse heap with BST: sibling subtrees are not ordered relative to each other. During sift-down, choose the better child. Check child indexes against current heap size. Bottom-up heapify is linear, unlike inserting every item separately.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Convert `[4,9,7,1,3,8]` into a max-heap. 2. Trace insert and extract-max. 3. Count nodes at each height to understand why build-heap is linear.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What is at the max-heap root?
   **Explained answer:** The largest item.
2. **Question:** What is peek complexity?
   **Explained answer:** O(1).
3. **Question:** What is push/pop complexity?
   **Explained answer:** O(log n).
4. **Question:** Is the full array sorted?
   **Explained answer:** No; only parent-child heap order is guaranteed.
5. **Question:** What workload suits a heap?
   **Explained answer:** Repeatedly retrieving the next minimum/maximum, such as priority scheduling or top-k.

## Further reading and references

- [Princeton Algorithms, Section 2.4](https://algs4.cs.princeton.edu/24pq/) — Heap representation and priority queues.
- [Python `heapq` documentation](https://docs.python.org/3/library/heapq.html) — Min-heap API and heap operations.
- [USFCA heap visualization](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Animated heap insertion and removal.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Binary heaps and asymptotic analysis.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
