# Control Structures: Conditions and Loops

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../readme.en.md) · Prerequisite: comparisons, booleans, and variables  
> Language: English · [Read this lesson in Persian](readme.md)

## Prerequisites and mental model

Control flow determines which statement runs and how often. `if/else` selects a branch; `for` and `while` repeat work; `break`, `continue`, and `return` change the path. Complexity analysis depends on the actual iteration count.

## The idea from first principles

A condition must evaluate to a boolean or be converted to one. Understand a loop through three parts: initialization, continuation condition, and update. A loop invariant describes the state at the beginning of each iteration. A for-each loop usually traverses a collection; modifying that collection during iteration may be invalid or have language-specific behavior.

## Step-by-step algorithm

To find a maximum, initialize `best = A[0]`, then inspect indices `1` through `n−1`; if `A[i] > best`, assign the new value. For `n = 0`, this precondition is invalid, so return an optional value or report an error. In `while i < n: i += 1`, `i` progresses; if the update is omitted, the loop may never stop.

Define input/output behavior, including empty arrays and tie-breaking: using `>` keeps the first maximum, while `>=` keeps the last.

## Worked trace

On `[4, 9, 2]`, `best` starts as 4. At `i = 1`, 9 is larger, so `best` becomes 9. At `i = 2`, 2 is smaller; the final answer remains 9.

For a manual trace, record the loop index, active prefix, state change, and reason.

## Why the algorithm is correct

Before iteration `i`, `best` is the maximum of `A[0..i)`. After comparing `A[i]` and updating if necessary, `best` is the maximum of `A[0..i+1)`. At termination `i = n`, so the entire array has been examined.

The proof should cover initialization, maintenance, and termination of this invariant.

## Time and space analysis

A single `n`-iteration loop is `O(n)`. Two nested loops that each run `n` times are usually `O(n²)`. Two consecutive full loops cost `O(n+n) = O(n)`. Repeated halving takes `Θ(log n)`. Branches can change best- and worst-case iteration counts.

## Practical use

Conditions support validation; loops support retries, streams, and pagination. Production retry loops need a stopping condition or timeout to avoid infinite work.

## Common mistakes and edge cases

- Off-by-one errors around `<` and `<=`.
- Missing updates can create an infinite loop.
- Mutating a collection while iterating may invalidate the iterator.
- Do not read `A[0]` for an empty array; define its behavior in the contract.
- Check singleton arrays, equal values, large indices, and integer overflow.

## Step-by-step exercises

1. Trace the maximum loop for `n = 1` and for an empty input.
2. Count the iterations when `j = i..n` for each outer-loop value `i`.
3. Write versions that explicitly return the first and the last occurrence of the maximum.

For each exercise, derive a simple correct result, analyze the cost, and add an edge case. Trace one small input and compare it with an independent result.

## Comprehensive quiz with explained answers

1. **What are the three parts of a counted loop?** Initialization, continuation condition, and update.
2. **Why use a loop invariant?** It explains what remains true at every iteration and supports a correctness proof.
3. **What do two consecutive `n`-length loops cost?** `O(n)`, because their costs add.
4. **What do two nested `n`-length loops usually cost?** `O(n²)`, if both really execute `n` times.
5. **What should a maximum function do on an empty array?** Define a separate result, such as an error or `None`; there is no element to return.

## Recall checklist

Explain loop progress, the invariant, a trace, the iteration count, and a boundary case. If a loop might not change its state or shrink its range, fix the termination argument.

## Further reading and references

- [Python Tutorial — More Control Flow Tools](https://docs.python.org/3/tutorial/controlflow.html) — conditions, loops, and function returns.
- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — algorithm reasoning and loop analysis.
- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — statement frequencies and loop costs.
- [OpenDSA — Asymptotic Analysis and Upper Bounds](https://opendsa-server.cs.vt.edu/ODSA/Books/vt/cs3114/spring-2021/CSCI271/html/AnalAsymptotic.html) — counting algorithm work.
- [Persian supplementary course — Data Structures and Algorithms](https://cs-um.github.io/docs/mandatory/Data-Structures/).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can explain each loop's start, condition, and update.
- [ ] I can write and use an invariant.
- [ ] I can count sequential and nested loops correctly.
- [ ] I have completed the exercises and reviewed the edge cases.
