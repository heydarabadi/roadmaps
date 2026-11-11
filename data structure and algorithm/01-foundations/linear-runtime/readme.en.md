# Linear Time — O(n)

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../readme.en.md) · Prerequisite: loops and arrays  
> Language: English · [Read this lesson in Persian](readme.md)

## Prerequisites and mental model

In a linear-time algorithm, work grows in proportion to the number of input elements. A pass that visits each element a constant number of times is `Θ(n)`.

## The idea from first principles

If `T(n) = an + b` for `a > 0`, then `T(n) ∈ Θ(n)`. Best and worst cases can differ: linear search is `O(1)` in its best case and `Θ(n)` in its worst case, while a complete traversal is `Θ(n)` for every input of size `n`.

An invariant describes what has been processed so far. For a running sum, it can state that after `i` iterations the accumulator equals the sum of the first `i` values.

## Step-by-step pattern

For an array sum, initialize `total = 0`, then add each element once. For `n` elements, there are `n` additions and `O(1)` auxiliary space. A count or a one-to-one transformation also takes one pass unless the loop body performs additional work depending on `n`.

Define the contract for an empty input: a sum naturally returns the additive identity `0`; a maximum operation may instead return an error or optional result.

## Worked example

For `[2, 5, −1, 4]`, read four values and compute a sum of `10`. Doubling the array size approximately doubles the number of reads. Copying an array to produce a new output also takes linear time and linear output space.

For a manual trace, record the loop index, processed prefix, accumulator, and update reason.

## Why the bound holds

After `i` iterations, the accumulator represents the result over the first `i` items. Each step extends that correct prefix by one element; after `n` steps, all elements have been processed. A function with a tight linear bound must perform a constant amount of work per item, subject to its stated case.

## Time and space analysis

Two consecutive passes cost `Θ(n) + Θ(n) = Θ(n)`. A nested pass over all items for each item costs `Θ(n²)`. Preserve separate dimensions as `O(n + m)` when inputs have independent sizes. A streaming sum can use `O(1)` auxiliary space; storing every transformed value uses `O(n)` output space.

## Practical use

File scans, checksums, map/filter operations, statistics, and text parsing often use linear passes. Streaming algorithms can compute some statistics in one pass with constant state.

## Common mistakes and edge cases

- Include any loop or called function inside the body; it may make the total superlinear.
- Consider amortized cost for dynamic-array appends.
- If all output values must be stored, report the output space.
- Check empty, singleton, duplicate, minimum/maximum, and large inputs.

## Step-by-step exercises

1. What is the cost of two independent full passes over `n` elements?
2. What is the cost if every element triggers another linear search?
3. How much auxiliary space does a streaming sum need?

First derive a simple correct result, then count work and add an edge case. Trace a small input and compare the result with an independent expectation.

## Comprehensive quiz with explained answers

1. **What does one full pass usually cost?** `Θ(n)`, because each of the `n` elements is visited a constant number of times.
2. **What do two consecutive passes cost?** `Θ(n)`, since their costs add to `2n`.
3. **What if every item triggers a full linear search?** `Θ(n²)` work.
4. **What auxiliary space does a streaming sum use?** `O(1)`; it needs only a running accumulator.
5. **What are linear search's best and worst cases?** Best `O(1)` if the first element matches; worst `Θ(n)` if the target is last or absent.

## Recall checklist

Explain the one-pass pattern, invariant, trace, time and auxiliary space, plus a nested-work counterexample. If a function is called inside the loop, include its cost in the estimate.

## Further reading and references

- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — cost of loops and program growth.
- [Princeton Algorithms — Searching](https://algs4.cs.princeton.edu/11model/) — search costs and comparison models.
- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — algorithmic reasoning and analysis.
- [OpenDSA — Asymptotic Analysis and Upper Bounds](https://opendsa-server.cs.vt.edu/ODSA/Books/vt/cs3114/spring-2021/CSCI271/html/AnalAsymptotic.html) — formal growth bounds.
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can count the work in one complete pass.
- [ ] I can distinguish sequential loops from nested loops.
- [ ] I can state time and auxiliary space separately.
- [ ] I have completed and reviewed the exercises independently.
