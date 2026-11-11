# Practicing Algorithms with LeetCode

> Chapter: [Practice and Self-Assessment](../README.md) · [Persian version](../../../../fa/data-structures-and-algorithms/09-practice-platforms/leetcode/README.md)

## Learning goals and prerequisites

Prerequisites: one working programming language, Big-O notation, and the basic data structures. After this lesson, you should be able to turn a problem statement into a contract, choose a suitable approach, justify its correctness, and use the judge as feedback rather than as a substitute for reasoning.

## Core idea

LeetCode provides problem statements, examples, an editor, and automated evaluation. It is useful for deliberate practice, but memorizing accepted solutions does not build transferable skill. An Accepted result establishes that a submission passed the platform’s test set; it does not prove the code is correct for every possible input or that its author understands the algorithm.

## Model and invariant

Treat each problem as a specification: input types and bounds, exact output, duplicates, ordering, and failure behavior. Keep correctness, efficiency, and implementation separate. A correct algorithm may be too slow; a fast idea may still have an off-by-one error; code may pass examples without a correctness argument.

For a hash-map solution to Two Sum, before processing index `i`, the map contains exactly the values at earlier indices. If a valid pair ends at `i`, its earlier complement is in the map. Looking up before inserting prevents the current element from being paired with itself.

## A repeatable solving process

1. Restate the contract in your own words and extract constraints.
2. Write edge cases: empty/singleton, duplicates, negatives, missing answer, maximum input.
3. Trace a small example by hand.
4. Write a simple brute-force baseline.
5. Compare its growth with the input limits; identify the repeated work.
6. Choose a pattern or data structure, then state its invariant before coding.
7. Implement, trace boundary cases, and submit.
8. After solving, close the editorial and reconstruct the proof and code later.

## Worked example: Two Sum

Brute force checks all pairs `i < j` in O(n²). An optimized scan looks for `target - x` among values already seen; if found, return the earlier and current indices; otherwise insert `x`. Lookup-before-insert ensures distinct indices. The expected time is O(n), with O(n) extra memory under ordinary hash-table assumptions.

## Correctness reasoning

The map invariant is true before the first element because the map is empty. Each iteration either finds the needed earlier complement or adds the current value for future indices, preserving the invariant. If a pair exists, its later member will encounter the earlier member’s complement. If the scan finishes without a match, no pair exists.

## Complexity and practical limits

Use constraints to reject clearly unsuitable growth rates, but treat operation-count rules as rough guidance: runtime depends on the language, judge limits, implementation, and constant factors. Count sorting, copies, slicing, recursion depth, and hash assumptions. Report auxiliary space separately from returned output.

Online judges provide focused practice and fast feedback. Production engineering also includes API compatibility, malformed input, observability, concurrency, deployment, maintainability, and reliability, which a single challenge may not model.

## Pitfalls and exercises

Do not read the editorial before making an independent attempt. Accepted is not a proof. Watch integer overflow, language-specific indexing, mutation, duplicates, memory limits, and worst-case hash behavior. After reading an explanation, reproduce the invariant and solution later without looking; recognition can feel like understanding.

1. Write a quadratic reference and an optimized solution, then compare them on small random inputs.
2. Record the first failing edge case and the assumption it exposed.
3. Re-solve a completed problem tomorrow and again in a week, explaining the invariant before coding.

## Self-check quiz — with answers

1. **What does Accepted establish?** It passed the judge’s test set; that is evidence, not a proof for all inputs.
2. **Why write brute force first?** It clarifies the contract and can serve as a correctness oracle for small cases.
3. **What should you record after reading an editorial?** The invariant, correctness argument, complexity, and a plan to reconstruct the solution independently.
4. **What may a challenge omit from production work?** API behavior, observability, concurrency, deployment, and maintenance requirements.
5. **How should tags be used?** As study and review clues, not as a substitute for deriving an approach from the constraints.

## Further reading and references

- [LeetCode Problem Set and topic filters](https://leetcode.com/problemset/)
- [LeetCode Help Center: How to use Explore](https://support.leetcode.com/hc/en-us/articles/360013578114-How-to-use-Explore)
- [LeetCode Explore](https://leetcode.com/explore/)
- [LeetCode Data Structures and Algorithms interview crash course](https://leetcode.com/explore/interview/card/leetcodes-interview-crash-course-data-structures-and-algorithms/)
- [MIT 6.006: Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)

## Mastery checklist

- [ ] I can restate the contract and constraints without relying on examples.
- [ ] I can compare a brute-force baseline with an improved approach.
- [ ] I can explain the invariant, correctness, runtime, and auxiliary space.
- [ ] I can create edge cases and reproduce the solution after a delay.
