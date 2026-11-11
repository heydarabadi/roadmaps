# Functions, Inputs, and Outputs

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../readme.en.md) · Prerequisite: variables, expressions, and blocks  
> Language: English · [Read this lesson in Persian](readme.md)

## Prerequisites and mental model

A function gives a behavior a name and a contract. A good function states its inputs, result and side effects, preconditions, and cost. Recursive and modular algorithms rely on this abstraction.

## The idea from first principles

Parameters are function inputs. Local state is valid only in its scope. `return` sends a result to the caller. Pass-by-value and pass-by-reference behavior depends on the language and value type. A pure function does not mutate its inputs or external state, so its output depends only on its inputs; document side effects explicitly.

An invariant is a statement that remains true during execution. It supports reasoning about a function's loops and postconditions.

## Step-by-step contract design

For `contains(A, x)`, define `A` as a sequence, `x` as the target, and the result as a Boolean. There is no required precondition. If the function returns true, some index `i` must satisfy `A[i] = x`. A linear implementation checks every element; its invariant says the previously checked prefix contains no target.

For each function, specify behavior for empty input, duplicates, missing values, and capacity limits.

## Worked example

Define `sumRange(l, r)` to sum the half-open range `[l, r)`. For an empty range where `l = r`, return 0, the additive identity. Half-open ranges make the length `r−l` and simplify boundary handling.

For a trace, list the arguments, local state, return value, and each change to a collection.

## Why the contract supports correctness

The precondition holds before the call; the invariant holds during execution; the postcondition must hold on return. Composing contracts lets a caller reason about correctness step by step. A function that may fail should specify whether it throws, returns an optional value, or returns a result/error object.

## Time and space analysis

A function call is usually constant overhead, but the body must be analyzed separately. Recursion stacks, returned collections, and parameter copies add time or space. If an `O(n)` helper runs inside an `n`-iteration loop, the total may be `O(n²)`.

## Practical use

Functions separate parsing, algorithms, data access, and presentation; they support reuse and independent unit tests. Public APIs should communicate failures explicitly.

## Common mistakes and edge cases

- Avoid global mutable state, vague names, hidden side effects, missing returns on branches, and unintended aliasing.
- A function named `sort` might mutate its input or return a new collection; inspect its contract.
- Test empty and singleton inputs, duplicates, absent values, large data, and overflow.

## Step-by-step exercises

1. Write a contract for binary search.
2. Create a pure function and a function with a side effect; explain how their tests differ.
3. Analyze an `O(n)` helper called once per iteration in an `n`-iteration loop.

For each exercise, write a correct baseline, analyze its complexity, and add an edge case. Trace a small input and verify the result independently.

## Comprehensive quiz with explained answers

1. **What belongs in a function contract?** Inputs, output, preconditions/postconditions, and side effects.
2. **What is a pure function?** Its result depends on its inputs and it does not mutate external state.
3. **What does an `O(n)` helper inside an `n`-iteration loop cost?** Up to `O(n²)` total work.
4. **What does scope determine?** Where a name can be accessed.
5. **Why use a half-open range?** Its length is `r−l`, and the empty case is simply `l = r`.

## Recall checklist

Explain a function's contract, scope, side effects, invariant, cost, and one edge case. If you cannot state what happens on failure, the contract is incomplete.

## Further reading and references

- [Python Tutorial — Defining Functions](https://docs.python.org/3/tutorial/controlflow.html#defining-functions) — function definitions and return behavior.
- [Python Tutorial — Data Structures](https://docs.python.org/3/tutorial/datastructures.html) — collection behavior relevant to function contracts.
- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — algorithm decomposition and proof.
- [OpenDSA — Algorithm Analysis Chapter](https://opendsa-server.cs.vt.edu/ODSA/Books/pubbook/odsa-all-0013bb43-a12f-4ab3-9b86-73b317f1e37e/fall-2017/Public_1092017/html/AnalChap.html) — analysis of operations and algorithms.
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can define preconditions and postconditions for a function.
- [ ] I can identify side effects and scope.
- [ ] I can include helper-function costs in the total.
- [ ] I have completed and reviewed the exercises independently.
