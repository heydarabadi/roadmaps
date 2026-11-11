# Queue and Circular Buffer

> Course: [Chapter 2](../README.md) · [Original Persian lesson](../../../../fa/data-structures-and-algorithms/02-basic-data-structures/queue/README.md) · Prerequisites: arrays, modulo arithmetic, and simple operations

## Learning goals and prerequisites

You should be comfortable with arrays, modulo arithmetic, and simple operations. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

A queue follows First-In, First-Out (FIFO): the earliest inserted item is removed first. Items enter at the rear and leave at the front. A circular buffer wraps array indexes around so that removing from the front does not require shifting every remaining element.

## Representation, contract, and invariant

For capacity C, the next circular index is `(i + 1) mod C`. One convention tracks `size` separately (`size=0` means empty and `size=C` means full). Another leaves one slot unused so `front == rear` means empty, making usable capacity C−1. Choose one convention and use it consistently.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

`enqueue(x)`: if full, follow the documented policy; otherwise write at rear, advance rear modulo C, and increase size. `dequeue()`: if empty, return an error/None; otherwise save data[front], advance front modulo C, decrease size, and return the saved item.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

With C=5 and front=rear=3, size=0, enqueue three items into positions 3, 4, and 0; rear becomes 1. Dequeue twice removes positions 3 and 4; front becomes 0 and the item at position 0 remains. The physical indexes wrap, but the logical FIFO order does not.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

The queue's live elements occupy exactly `size` circular positions starting at front; rear is the next write position. Full and empty checks must match the chosen representation.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Circular-array enqueue/dequeue are O(1); storage is O(C). A resize can make one enqueue O(n), but geometric growth makes appends amortized O(1). A linked queue with head and tail also supports both operations in O(1).

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Message brokers, print jobs, request processing, and network buffers use queues. A bounded real-time queue makes memory use predictable, but its full-buffer policy changes observable product behavior.

## Common mistakes and edge cases

Advance indexes with modulo. Wrapping around does not mean the queue is empty. Reject zero capacity. A single-threaded queue is not automatically safe for concurrent producers/consumers; synchronization and memory visibility must be designed.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. With C=4 and size tracking, trace enqueue A,B,C; dequeue; enqueue D,E. 2. Compare “reject when full” with “drop oldest” for a log buffer. 3. Explain why FIFO is fair for a print queue.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What does FIFO mean?
   **Explained answer:** The first item inserted is the first item removed.
2. **Question:** What problem does a circular queue solve?
   **Explained answer:** It reuses freed prefix slots without shifting all remaining elements.
3. **Question:** With separate size tracking, when is it empty/full?
   **Explained answer:** Empty when size=0; full when size=capacity.
4. **Question:** Why use modulo?
   **Explained answer:** To wrap an index from the array's end back to its beginning.
5. **Question:** What policy is needed when full?
   **Explained answer:** A workload-specific backpressure policy: reject, wait, grow, overwrite, or discard an item.

## Further reading and references

- [Python collections.deque](https://docs.python.org/3/library/collections.html#collections.deque) — Double-ended queue API and operations.
- [Princeton Algorithms, Section 1.3](https://algs4.cs.princeton.edu/13stacks/) — Queue implementations and FIFO behavior.
- [USFCA queue visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Animations include array- and list-based queues.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Data structures and amortized costs.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
