# Chapter 1 — Foundations and Algorithm Analysis

> [Persian chapter](readme.md) · [Course index](../readme.en.md)

Build the programming and analysis skills needed to read, design, implement, and explain algorithms. A language is a tool for expressing an idea; the correctness argument and cost model are separate from its syntax.

## Suggested study order

1. Learn what data structures and algorithms are, then write a precise function contract.
2. Study syntax, control flow, functions, pseudocode, and only the OOP needed to use collections.
3. Choose one language and learn its array/list, map/set, stack/queue, and priority-queue APIs.
4. Define input size, count operations, and separate time from auxiliary space.
5. Study O, Θ, and Ω, then connect each runtime family to a concrete loop, recurrence, or search space.

## Growth-rate reference

| Work pattern | Typical growth | Example |
|---|---:|---|
| Fixed number of operations | Θ(1) | Read `A[i]` |
| Halve or double each iteration | Θ(log n) | Binary search |
| One pass over n items | Θ(n) | Sum or linear scan |
| All pairs | Θ(n²) | Two independent nested loops |
| Halve, then linearly merge | Θ(n log n) | Merge sort |
| Include/exclude every item | Θ(2ⁿ) | Enumerate subsets |
| Enumerate every ordering | Θ(n!) | Generate permutations |

Two consecutive n-element loops take Θ(n+n)=Θ(n); they do not become Θ(n²). Preserve independent input sizes, such as O(n+m), instead of silently treating one as a constant.

## Roadmap parent lesson: Programming Fundamentals

The programming-fundamentals branch covers language syntax, control structures, functions, pseudocode, and OOP basics. Its goal is to translate a step-by-step solution into readable, testable code. For an array-sum function, define the input and output, traverse each item, maintain a running total, and test the empty-array behavior. Syntax is not algorithm logic: first clarify the function contract and edge cases, then implement it in the chosen language.

**Parent-branch self-check**

1. What ability does this branch build? Translating a precise solution into readable, testable code.
2. What is a useful learning order? Essential syntax, conditions and loops, functions and pseudocode, then data-structure models and the OOP needed to use them.
3. What should a function contract state? Inputs, output, preconditions, postconditions, and side effects.

## Roadmap parent lesson: Algorithmic Complexity

Complexity describes how time and memory grow with input size. Count the dominant operations, state whether best/average/worst case is being analyzed, and report auxiliary memory. For a nested loop, derive the number of executions of each loop and the cost of its body. Asymptotic analysis supports comparisons; benchmarking on representative input measures real runtime.

**Parent-branch self-check**

1. What does asymptotic complexity describe? Resource growth relative to input size, not an exact time in seconds.
2. How do you analyze nested loops? Count the iterations of each loop and the cost of the body.
3. When is Θ more precise than O? When both an asymptotic upper and lower bound of the same order are established.

## Worked analysis

For `5n² + 2n + 100`, the quadratic term dominates, so the function is Θ(n²), and therefore also O(n²) and Ω(n²). For an algorithm that fully scans n values, time may be Θ(n) while auxiliary space is O(1); time and memory are distinct measures. A hash lookup is usually expected O(1), not an unconditional worst-case guarantee, because collisions can make a lookup linear.

## Chapter review quiz

1. **How many iterations does `i=1; i<n; i*=2` take?** Θ(log n), because i doubles each iteration.
2. **Can a full scan of an n-element input use O(1) auxiliary space?** Yes. The scan is linear in time but needs only a fixed number of variables.
3. **Are two consecutive n-element loops O(n²)?** No. Their costs add to 2n=Θ(n).
4. **Why distinguish O, Θ, and Ω?** They state upper, tight, and lower bounds; one does not imply the others without proof.
5. **What should accompany a hash-table O(1) claim?** The average/expected-case qualifier and its hashing assumptions.
6. **What proves a loop correct?** Initialization, invariant preservation, and termination together with the invariant.

## Further reading and references

- [MIT OpenCourseWare 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/)
- [MIT 6.006 lecture videos](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)
- [Python Tutorial](https://docs.python.org/3/tutorial/)
- [Python control flow and functions](https://docs.python.org/3/tutorial/controlflow.html)
- [Princeton Algorithms companion site](https://algs4.cs.princeton.edu/home/)
- [Persian: Ferdowsi University Data Structures course](https://cs-um.github.io/docs/mandatory/Data-Structures/)
- [Full bibliography](../references.en.md)

## Topic lessons

- [What Are Data Structures and Algorithms?](what-is-dsa/readme.en.md)
- [Why Data Structures Matter](why-dsa/readme.en.md)
- [Choosing a Language](choose-language/readme.en.md)
- [Language Syntax](syntax/readme.en.md)
- [Control Structures](control-structures/readme.en.md)
- [Pseudocode](pseudocode/readme.en.md)
- [Functions](functions/readme.en.md)
- [OOP Basics](oop-basics/readme.en.md)
- [Time and Space Complexity](time-space/readme.en.md)
- [Estimating Complexity](estimate-complexity/readme.en.md)
- [Asymptotic Notation](asymptotic-notation/readme.en.md)
- [Big-O: Upper Bounds](big-o/readme.en.md)
- [Big-Theta: Tight Bounds](theta/readme.en.md)
- [Big-Omega: Lower Bounds](omega/readme.en.md)
- [Constant Runtime](constant-runtime/readme.en.md)
- [Logarithmic Runtime](logarithmic-runtime/readme.en.md)
- [Linear Runtime](linear-runtime/readme.en.md)
- [Polynomial Runtime](polynomial-runtime/readme.en.md)
- [Exponential Runtime](exponential-runtime/readme.en.md)
- [Factorial Runtime](factorial-runtime/readme.en.md)

## Mastery standard

Explain a simple problem’s contract, pseudocode, invariant, initialization/preservation/termination proof, time, and auxiliary space without using programming syntax. Then implement it and check empty, singleton, duplicate, absent, and maximum-size cases. If you can only recite a Big-O formula or syntax rule, review the lesson before moving on.
