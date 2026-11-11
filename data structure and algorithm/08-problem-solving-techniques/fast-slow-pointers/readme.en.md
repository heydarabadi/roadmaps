# Fast and Slow Pointers

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Linked lists, references, and loop conditions. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

Two pointers follow the same sequence at different speeds. On a finite acyclic list, the fast pointer reaches the end first; on a cyclic list, the relative gap changes until the pointers meet. The method can detect a cycle or find a midpoint with O(1) auxiliary space.

## Model, contract, and invariant

Floyd’s cycle-finding algorithm moves slow by one edge and fast by two. Once both are in a cycle of length L, their relative position advances by one modulo L per iteration, so they eventually collide. Null checks must happen before dereferencing `fast.next`.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

slow=head; fast=head
while fast != null and fast.next != null:
    slow=slow.next
    fast=fast.next.next
    if slow==fast: cycle-found

To find the cycle entry, reset one pointer to head and move both one step at a time; their next meeting is the entry.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

Consider 1→2→3→4→5 with 5→3. The pointers move at speeds one and two; after fast enters the 3→4→5 cycle, the gap changes by one node each round. They eventually meet inside the cycle. Reset one pointer to 1 and advance both one step; they meet at 3, the cycle entry.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

Let μ be the number of edges before the cycle and λ its length. At the first collision, the difference in traveled distances is a multiple of λ. Since fast has traveled twice as far, the collision position implies that moving one pointer from head and one from the collision at equal speed brings both to the entry after μ steps.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

Cycle detection and entry location are O(n) time and O(1) auxiliary space. A hash set is easier to explain but uses O(n) additional memory. Midpoint search is also linear time and constant extra space.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Linked-list cycle detection, finding the midpoint, splitting a list for merge sort, and some number-theoretic cycle-detection methods use this pattern.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Check `fast` and `fast.next` before advancing two links. Lists of length zero, one, or two expose boundary bugs. For an even-length list, the loop condition determines which middle is returned. A circular list may be intentional; follow the data contract.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Trace both pointers on a list with a two-node prefix and a three-node cycle. 2. Compare midpoint loop conditions for odd and even lengths. 3. Prove the cycle-entry reset rule using μ and λ.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** How fast do the pointers move?
   **Answer:** Slow advances one link per round; fast advances two.
2. **Question:** Why do they meet if a cycle exists?
   **Answer:** Their relative gap changes modulo the cycle length until it reaches zero.
3. **Question:** What is the extra space?
   **Answer:** O(1), unlike the common hash-set approach.
4. **Question:** What must be checked before a two-step advance?
   **Answer:** Both `fast` and `fast.next` must be non-null.
5. **Question:** What can the pattern also find?
   **Answer:** The midpoint of a linked list.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [CP-Algorithms — Floyd’s cycle-finding algorithm](https://cp-algorithms.com/others/tortoise_and_hare.html)
- [LeetCode — Linked List Cycle](https://leetcode.com/problems/linked-list-cycle/)
- [LeetCode — Linked List Cycle II](https://leetcode.com/problems/linked-list-cycle-ii/)
- [LeetCode — Middle of the Linked List](https://leetcode.com/problems/middle-of-the-linked-list/)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
