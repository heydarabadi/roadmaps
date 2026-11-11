# Array and Dynamic Array

> Course: [Chapter 2](../readme.en.md) · [Original Persian lesson](readme.md) · Prerequisites: indexes, variables, loops, and asymptotic growth

## Learning goals and prerequisites

You should be comfortable with indexes, variables, loops, and asymptotic growth. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

An array is a sequence of slots addressed by integer indexes. In a contiguous array, the address of A[i] is computed as `base + i × element_size`, so random access does not require visiting earlier elements. A dynamic array presents the same sequence interface but reserves spare capacity and occasionally allocates a larger buffer and copies its elements.

## Representation, contract, and invariant

Keep `size` (number of live elements), `capacity` (number of allocated slots), and `index` (a position from 0 through size−1) distinct. A reserved slot outside `[0,size)` is not part of the sequence. If capacity grows geometrically, such as doubling, appends are amortized O(1), although the append that triggers a resize costs O(n).

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

Read or replace A[i] only after checking `0 ≤ i < size`. To insert x at i, shift A[i..size−1] one slot right from the end, write x at i, and increment size. To delete at i, shift A[i+1..size−1] left and decrement size. For append, allocate and copy only when `size == capacity`, then write at A[size].

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

Starting with `[10,20,30,40]`, insert 25 at index 2. Copy 40 from index 3 to 4, then 30 from index 2 to 3. Slot 2 is free, so write 25: `[10,20,25,30,40]`. By contrast, reading the value at index 1 computes its address directly; it does not scan index 0.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

After each operation, exactly the first `size` slots are live and their logical order matches the sequence contract. During geometric growth, the total elements copied across many appends is bounded by a constant multiple of the number appended; therefore the sequence of appends has O(1) amortized cost.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Indexed access/update: O(1). Unordered search and full traversal: O(n). Insert/delete near the beginning or middle: O(n) due to shifting. Dynamic-array append: O(1) amortized and O(n) for a resize. Stored data uses O(n) space; spare capacity depends on the growth policy.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Image pixels, result tables, network buffers, and many language list implementations use contiguous arrays. Locality often makes arrays faster than pointer-heavy lists in practice, even when an asymptotic comparison looks similar.

## Common mistakes and edge cases

Do not confuse a fixed array with a dynamic array. O(1) indexed access does not make middle insertion free. Do not keep pointers/references into a dynamic buffer across a resize. Check whether a language API returns a copy, view, or slice; slices often allocate or retain the original buffer.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Count shifts when inserting and deleting at index 0, the middle, and the end. 2. Starting with capacity 1 and doubling, list the capacities through the eighth append. 3. Compare 100,000 front insertions in a dynamic array and a linked list; include the cost of finding a linked-list position and the loss of random access.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** Why is A[i] constant-time?
   **Explained answer:** The address follows from the base address and a fixed offset; no earlier slots need to be visited.
2. **Question:** Why is middle insertion linear?
   **Explained answer:** The suffix must move to make room while preserving sequence order.
3. **Question:** Is every dynamic-array append O(1)?
   **Explained answer:** No. It is O(1) amortized over a sequence; a resize-triggering append can copy n elements.
4. **Question:** How do size and capacity differ?
   **Explained answer:** Size counts live elements; capacity counts allocated slots.
5. **Question:** When is an array a good choice?
   **Explained answer:** When indexed access and compact traversal matter and shifting for updates is acceptable.

## Further reading and references

- [Python Tutorial: Data Structures](https://docs.python.org/3/tutorial/datastructures.html) — List operations and their behavior.
- [C++ std::vector reference](https://en.cppreference.com/w/cpp/container/vector.html) — Dynamic-array operations and iterator invalidation.
- [MIT 6.006: Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Lecture notes on dynamic arrays and data-structure costs.
- [Princeton Algorithms, Section 1.3](https://algs4.cs.princeton.edu/13stacks/) — Array-backed collections and resizing.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
