# Linked List

> Course: [Chapter 2](../readme.en.md) · [Original Persian lesson](readme.md) · Prerequisites: references or pointers, nodes, and loops

## Learning goals and prerequisites

You should be comfortable with references or pointers, nodes, and loops. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

A linked list stores values in nodes connected by references; nodes need not occupy adjacent memory. A singly linked node points to its successor. A doubly linked node also points to its predecessor. The structure supports cheap local rewiring, but reaching the i-th node requires walking the links.

## Representation, contract, and invariant

`head` identifies the first node; some implementations also keep `tail`. An empty list has a null head. A sentinel node can simplify boundary cases. In a doubly linked list, every link must be reciprocal: if `x.next = y`, then `y.prev = x`. In a singly linked list, walking from head must eventually reach null unless a cycle is intentional.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

To insert node x after known node p: set `x.next = p.next`, then `p.next = x`; in a doubly linked list also repair both predecessor/successor links. To delete the node after p, save it as victim, link p to victim.next, repair `prev` if needed, then release victim if the language requires it. Removing the head is a separate case unless a sentinel is used.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

Given `A → B → D`, insert C after B. First point C to D; then point B to C, producing `A → B → C → D`. If B is redirected before C is connected to D, the remainder of the list can be lost.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

A traversal from head visits each live node once and terminates. In a doubly linked list, each forward link has a matching backward link. Insertion/deletion rewiring must preserve these invariants and leave all other reachable nodes reachable.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Finding an element or index i: O(n). Inserting at the head: O(1); inserting after a node already known: O(1). Finding that node may still cost O(n). Deletion from a singly linked list needs its predecessor; a doubly linked node can be unlinked in O(1) when its reference is known. Each node pays pointer and allocation overhead.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

A doubly linked list plus a hash map is a common LRU-cache design: the map locates a node while the list moves or removes it in constant time. For large sequential scans, an array may still be faster because of cache locality.

## Common mistakes and edge cases

“Insertion is O(1)” is incomplete unless the insertion location is already available. Test empty, one-node, head, tail, and missing-value deletion. An accidental cycle can cause an infinite traversal; dangling references and double-free errors matter in manual-memory languages.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Design insertion at the head and tail with and without sentinels. 2. Explain how slow/fast pointers detect a cycle. 3. Why does deleting a node from a singly linked list normally require its predecessor?

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** Why is indexing a linked list O(n)?
   **Explained answer:** The list must follow one link at a time from its head.
2. **Question:** When is insertion O(1)?
   **Explained answer:** When the insertion node or predecessor is already known.
3. **Question:** Why update C.next before B.next?
   **Explained answer:** It preserves the link to the old suffix before changing its predecessor.
4. **Question:** What does a doubly linked list trade?
   **Explained answer:** Extra pointer memory and update work for backward traversal and direct unlinking.
5. **Question:** Where is a list used with a hash map?
   **Explained answer:** An LRU cache can use a map to find a node and a doubly linked list to update recency.

## Further reading and references

- [Princeton Algorithms, Section 1.3: Stacks and Queues](https://algs4.cs.princeton.edu/13stacks/) — Linked implementations and collection contracts.
- [USFCA data-structure visualizations](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html) — Animations include linked-list operations.
- [Java LinkedList API](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/LinkedList.html) — A standard doubly linked list API.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Data structures and their cost models.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
