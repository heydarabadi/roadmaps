# Heap Sort

> Course: [Chapter 3](../readme.en.md) · [Original Persian lesson](readme.md) · Prerequisites: arrays, complete binary trees, and heap order

## Learning goals and prerequisites

You should be comfortable with arrays, complete binary trees, and heap order. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

Interpret the array as a max-heap, whose root is the largest item. Swap the root into the end of the active region, shrink the heap, and restore heap order.

## Representation, contract, and invariant

With zero-based indexes, left child is `2i+1`, right child `2i+2`, parent `floor((i−1)/2)`. A max-heap requires each parent to be at least as large as its children. After each extraction, the suffix contains sorted final positions.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Sift-down(i,n): find the largest among i and its existing children; if a child is larger, swap and continue from that child. Build a heap by calling sift-down from `floor(n/2)−1` down to 0. Then for end=n−1 down to 1, swap root with end and sift down within `[0,end)`.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

For `[4,10,3,5,1]`, heapify so 10 is the root. Swap 10 to the last active slot; move 1 to the root and sift it below the larger child 5. Repeat: each root maximum is moved to its final suffix position.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

Bottom-up heap construction establishes parent/child order across the active array. After extracting the root, the only possible violation is along the root path; sift-down repairs it. The completed suffix is never touched again.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Build-heap is Θ(n); n extractions at O(log n) make total Θ(n log n) in all cases. Array implementation uses O(1) auxiliary space but is not stable. Heap locality can be less favorable than quicksort.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Heap sort is an option when worst-case Θ(n log n) time and constant auxiliary space are important. Heaps are also widely useful as priority queues, though that is a distinct use from sorting.

## Common mistakes and edge cases

Do not claim the heap is fully sorted; only parent/child order is guaranteed. Choose the larger child during max-heap sift-down. Check child indexes against the active heap boundary. Bottom-up heap construction has a tighter bound than n separate insertions.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Write parent/child indexes for n=7. 2. Build a max-heap from `[2,9,7,1,6]`. 3. Explain why bottom-up build-heap is Θ(n), not Θ(n log n), by counting nodes at each height.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What is the max-heap root?
   **Explained answer:** The maximum item.
2. **Question:** What is the right-child index?
   **Explained answer:** `2i+2` in a zero-based array.
3. **Question:** What is heap sort's total time?
   **Explained answer:** Θ(n log n) in best, average, and worst cases.
4. **Question:** What is bottom-up heap construction?
   **Explained answer:** Θ(n).
5. **Question:** Name one trade-off.
   **Explained answer:** Worst-case bound and O(1) auxiliary space, but unstable and often weaker locality.

## Further reading and references

- [Princeton Algorithms, Section 2.4: Priority Queues](https://algs4.cs.princeton.edu/24pq/) — Heap representation and heap operations.
- [USFCA heap visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Animated heap construction and sort.
- [C++ `priority_queue` reference](https://en.cppreference.com/w/cpp/container/priority_queue.html) — Official container API and comparator behavior.
- [Python `heapq` documentation](https://docs.python.org/3/library/heapq.html) — Official heap operations and min-heap interface.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
