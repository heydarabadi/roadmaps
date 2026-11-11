# Programming Language Syntax

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../README.md) · Prerequisite: variables, values, and calling a function  
> Language: English · [Read this lesson in Persian](../../../../fa/data-structures-and-algorithms/01-foundations/syntax/README.md)

## Prerequisites and mental model

Syntax is the grammar used to write a program. A compiler or interpreter checks whether the code follows that grammar. Code can parse successfully and still behave incorrectly. For DSA, learn enough variable, expression, condition, loop, function, and collection syntax to express an algorithm; you do not need to memorize an entire language.

## The idea from first principles

A program stores values under names and types. An expression computes a value; a statement performs an action; a block groups statements and defines a scope. In many languages, `=` assigns a value, `==` compares values, and `return` exits a function with a result. Details differ: some languages use indentation for blocks, others braces.

An invariant is a claim that remains true while an algorithm executes. Establishing one before coding helps prove correctness and catch boundary errors.

## Step-by-step code reading

Consider:

~~~python
for x in values:
    if x == target:
        return True
~~~

The loop reads each value; the condition checks equality; a match returns immediately. Translating this logic to another language should preserve semantics, not necessarily the same punctuation.

Specify the input/output contract too: define behavior for empty input, duplicates, missing values, and exhausted capacity.

## Worked trace

For `[4, 7, 2]` and `target = 7`, the first iteration checks 4 and continues; the second checks 7 and returns `True`; 2 is never examined. For target 9, all three values are checked and the function needs a `False` result after the loop.

For a manual trace, record each iteration, index or pointer, active region, state change, and reason.

## Why the result is correct

Before each iteration, every earlier element has been checked and none matched. If no match is found after the loop, the target is absent. If a language requires an explicit return on every path, include that missing-target result.

A complete algorithm proof usually shows initialization, maintenance, and termination of its invariant.

## Time and space analysis

Syntax by itself has no complexity; the executed operations do. A copy, slice, concatenation, or built-in call may quietly take `Θ(n)`. Check the semantics and library cost of each construct in the language documentation. State the input size and case, and separate auxiliary space from input storage.

## Practical use

Reading teammates' code, debugging, and translating pseudocode into a precise implementation all depend on understanding syntax. Standard formatting makes control-flow errors easier to spot.

## Common mistakes and edge cases

- Do not confuse syntax errors with logical errors.
- `=` and `==`, mutable and immutable values, null/nil, operator precedence, and integer division vary by language.
- Shorter code is not necessarily cheaper code.
- Check empty, singleton, duplicate, absent-target, minimum/maximum, and large-input cases; consider integer overflow in indexing or capacity calculations.

## Step-by-step exercises

1. Implement the search example in your chosen language.
2. Add tests for a target at the beginning, at the end, and absent.
3. Find a collection copy in that language and determine its complexity.

For each exercise, write a correct baseline, analyze it, and add an edge case. Trace a small input and compare it with an independently derived result.

## Comprehensive quiz with explained answers

1. **What does syntax check?** Whether code follows a language's grammar; it does not prove the algorithm is correct.
2. **Does syntactically valid code have to be correct?** No. It may produce a logically wrong result.
3. **Why do language details matter?** Assignment, scope, collection, and type semantics differ.
4. **What does `return` do?** It exits a function and supplies its result to the caller.
5. **Name a hidden linear-cost operation.** Copying or slicing a collection can take `O(n)` time and space.

## Recall checklist

Explain the difference between parsing and correctness, trace a simple loop, name language-specific semantics, and identify a hidden library cost. If a boundary path is unclear, define the function's return behavior first.

## Further reading and references

- [Python Tutorial — Control Flow Tools](https://docs.python.org/3/tutorial/controlflow.html) — syntax for conditions, loops, and functions.
- [Python Tutorial — Data Structures](https://docs.python.org/3/tutorial/datastructures.html) — common collection operations.
- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — expressing and analyzing algorithms.
- [MDN — JavaScript Guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide) — language syntax and semantics in a second mainstream language.
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can read and write the core syntax in my chosen language.
- [ ] I can distinguish a parsing error from a logic error.
- [ ] I can identify an operation with a hidden cost.
- [ ] I have completed the exercises and reviewed the edge cases.
