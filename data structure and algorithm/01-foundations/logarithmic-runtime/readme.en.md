# Logarithmic Time — O(log n)

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../readme.en.md) · Prerequisite: powers, interval halving, and binary search  
> Language: English · [Read this lesson in Persian](readme.md)

## Prerequisites and mental model

If each step reduces the problem by a constant factor—halving or dividing into a fixed number of parts—the number of steps is usually logarithmic. `log₂ n` is the number of halvings needed to reduce a size-`n` range to one item.

## The idea from first principles

After `k` halvings, the remaining size is at most `n / 2ᵏ`. To reach one item, `n / 2ᵏ ≤ 1`, so `2ᵏ ≥ n` and `k ≥ log₂ n`. Logarithms with different constant bases differ only by a constant factor. But if each step removes just one item, the number of steps is `O(n)`, not logarithmic.

An invariant is a claim that remains true after every step. For binary search it records that the answer remains inside the candidate interval while that interval shrinks.

## Step-by-step patterns

Binary search halves its candidate interval. Heap operations travel along a heap's height; a complete heap with `n` nodes has height `Θ(log n)`. A loop such as `i *= 2` visits `1, 2, 4, …` and runs `Θ(log n)` times.

Before implementing, state the required contract: for example, binary search needs sorted input under the same comparison relation used by the search.

## Worked estimate

One million candidates take about 20 halvings to reach one, because `2²⁰ = 1,048,576`. This estimates comparisons or steps, not milliseconds.

In a manual trace, write the interval before and after each halving and show why the discarded portion cannot contain the answer.

## Why the bound holds

The input must shrink by a constant factor, and every iteration must make progress. A binary-search loop whose bounds fail to change can run forever. Check the interval convention and update rule.

Correctness is shown by the invariant: every discarded index is excluded by the ordering property, so the answer remains in the active interval. Termination follows because the interval strictly shrinks.

## Time and space analysis

`O(log n)` is highly scalable, but multiply by the cost per level if it is not constant. A balanced-tree lookup is logarithmic because the height is logarithmic; a skewed BST can have height `n` and lookup time `O(n)`.

## Practical use

Logarithmic growth appears in searches for boundaries in sorted data, balanced tree/heap height, binary lifting, and repeated scaling or halving. A B-tree's high fan-out reduces the number of storage-page levels.

## Common mistakes and edge cases

- State the sorted-input or balance assumption.
- Do not assume every BST has logarithmic height.
- Make sure `lo` and `hi` updates always reduce the interval.
- A loop that increments by 2 is not logarithmic.
- Handle empty and singleton intervals, duplicate keys, and overflow in midpoint arithmetic.

## Step-by-step exercises

1. How many candidates remain after 10 halvings?
2. Compare repeatedly replacing `n` with `n/2` against replacing it with `n−1`.
3. What insertion order can make a plain BST have height `Θ(n)`?

For each exercise, write a correct baseline, analyze the work, and add an edge case. Trace the interval changes on a small input.

## Comprehensive quiz with explained answers

1. **Where does `log n` growth come from?** A constant-factor reduction at every step.
2. **Does the logarithm base matter asymptotically?** No; changing a constant base changes only a constant factor.
3. **What if each step removes one item?** The number of steps is usually `O(n)`.
4. **Is lookup in every BST logarithmic?** No. It is `O(h)` and only logarithmic when height is logarithmic.
5. **How many iterations does `i *= 2` take before reaching `n`?** `Θ(log n)`.

## Recall checklist

Explain why the interval shrinks geometrically, trace each bound update, state the precondition, and give one example where the tree assumption fails. If the interval can stay unchanged, fix the termination argument.

## Further reading and references

- [CP-Algorithms — Binary Search](https://cp-algorithms.com/num_methods/binary_search.html) — interval invariants and boundary-search variants.
- [Princeton Algorithms — Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — logarithmic growth and cost models.
- [Princeton Algorithms — Binary Search Trees](https://algs4.cs.princeton.edu/32bst/) — how tree shape controls search cost.
- [NIST Dictionary — Big-O notation](https://xlinux.nist.gov/dads/HTML/bigOnotation.html) — formal asymptotic bounds.
- [Persian supplementary course — Data Structures and Algorithms](https://cs-um.github.io/docs/mandatory/Data-Structures/).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can state the preconditions for logarithmic search.
- [ ] I can trace the shrinking interval and termination.
- [ ] I can distinguish logarithmic from linear shrinkage.
- [ ] I have solved the exercises and reviewed the edge cases.
