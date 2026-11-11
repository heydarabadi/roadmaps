# Recursion

> Chapter: [08 Problem Solving Techniques](../README.md) · [Persian version](../../../../fa/data-structures-and-algorithms/08-problem-solving-techniques/recursion/README.md)

## Learning goals and prerequisites

Prerequisites: Functions, parameters, return values, and a basic understanding of the call stack. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

A recursive function solves a problem by solving smaller instances of the same problem. Every correct recursive design needs a base case and a recursive step that makes measurable progress toward that base case. Recursion is a way to express a solution; it is not automatically more efficient than iteration.

## Model, contract, and invariant

Each call has its own arguments and local variables in a stack frame. The recurrence describes total work; maximum simultaneous call depth describes stack space. These are different quantities: a program may make many total calls but have modest depth, or make one long chain of calls.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

Design in this order: define what the function returns; define the smallest input and its answer; assume the function works on a strictly smaller input; combine that result into the current answer; prove the input measure decreases. Example: `sum(i)=0` when i=n; otherwise `A[i]+sum(i+1)`.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

For A=[4,2,7], sum(0)=4+sum(1); sum(1)=2+sum(2); sum(2)=7+sum(3); sum(3)=0. Calls return in reverse order, producing 7, then 9, then 13. The base case prevents a call beyond the array.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

Use induction on the size of the input. The base case returns the correct answer. For a larger input, the recursive call receives a smaller valid instance and, by the induction hypothesis, returns its correct answer; the combination step then constructs the correct answer for the original instance. A decreasing nonnegative measure proves termination.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

A linear chain such as factorial makes Θ(n) calls and uses Θ(n) stack space. Binary search makes Θ(log n) calls. A recursive traversal of a tree uses O(h) stack, where h is its height and may be Θ(n). Memoization changes repeated-work time but consumes cache space. Tail-call elimination is language/runtime-specific and must not be assumed.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Tree and graph traversals, divide-and-conquer, parsers, nested document processing, and backtracking naturally match recursive structure. For untrusted or very deep inputs, an explicit stack can avoid runtime call-stack limits and make memory behavior more controllable.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Missing base cases, recursive calls that do not shrink the problem, repeated subproblems (naive Fibonacci), accidentally copying an entire collection per call, and stack overflow are common failures. State both total calls and maximum depth.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Define recursive sum and factorial with clear base cases. 2. Draw all calls made by naive Fibonacci(5), and identify repeated subproblems. 3. Convert recursive depth-first tree traversal to an explicit stack and compare the order.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What two pieces must every terminating recursive design have?
   **Answer:** A base case and a recursive step that decreases a well-founded measure toward it.
2. **Question:** Does stack depth equal the total number of calls?
   **Answer:** No. Stack space is the maximum number of simultaneously active calls.
3. **Question:** Why is naive Fibonacci exponential?
   **Answer:** It recomputes the same subproblems many times, creating a branching call tree.
4. **Question:** Is tail-call optimization guaranteed?
   **Answer:** No. It depends on the language, compiler, and runtime.
5. **Question:** What is a practical alternative for very deep recursion?
   **Answer:** Use an explicit stack or queue and iterate.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [Stanford CS106B — Thinking Recursively](https://see.stanford.edu/Course/CS106B/163)
- [MIT 6.006 — Introduction to Algorithms lectures](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)
- [Princeton Algorithms — Recursion and divide-and-conquer sorting](https://algs4.cs.princeton.edu/22mergesort/)
- [Persian supplementary course: Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
