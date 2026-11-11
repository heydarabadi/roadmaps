# Chapter 9 — Practice and Self-Assessment

> [Persian chapter](../../../fa/data-structures-and-algorithms/09-practice-platforms/README.md) · [Course index](../README.md)

Use practice platforms to get feedback, then turn each solution into a reusable explanation and a later retrieval exercise. The platform is a tool; reasoning and review create the learning.

## A practice cycle

1. Restate input, output, constraints, duplicate policy, and boundary behavior.
2. Trace a small example and write a brute-force baseline.
3. Identify the bottleneck and select an algorithm that meets the constraints.
4. Write the invariant and complexity before coding.
5. Test empty, one-element, duplicate, absent-answer, and maximum-size cases.
6. After passing, close the editorial and explain the proof and trade-offs from memory.
7. Revisit the problem after a day and again after a week.

Label notes by concepts—such as “lower bound with duplicates” or “two heaps for streaming median”—rather than only by problem number. When a solution fails, record whether the cause was a wrong model, incomplete proof, missed edge case, or implementation bug. That diagnosis helps choose the next exercise.

## Roadmap parent lesson: Platforms to Practice

Use Edabit for short language and syntax exercises and LeetCode for a broad set of data-structure and algorithm problems. A passing judge result is evidence that the submission passed those tests; it is not a proof for all possible inputs. The strongest practice sequence is independent attempt, explanation and implementation, error review, then delayed reconstruction.

## Chapter review quiz

1. **Does Accepted prove correctness for every input?** No; it passes the platform’s test set.
2. **Why write a brute-force solution first?** It clarifies the problem and can serve as an oracle for small inputs.
3. **What is a useful review after seeing an editorial?** Reconstruct the invariant, proof, and implementation without looking.
4. **Which platform in this chapter is suited to short syntax drills?** Edabit; LeetCode offers a broad algorithm problem set and topic-based exploration.
5. **Does copying a solution demonstrate mastery?** No; the reasoning and independent reconstruction matter.
6. **What can production software require beyond a judge problem?** Contracts, failure behavior, observability, concurrency, and maintainability.

## Further reading and references

- [LeetCode Problem Set](https://leetcode.com/problemset/)
- [LeetCode Help Center — How to use Explore](https://support.leetcode.com/hc/en-us/articles/360013578114-How-to-use-Explore)
- [Edabit coding challenges](https://edabit.com/challenges)
- [MIT 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/)
- [Topic-by-topic reading list](../references.md)

## Mastery standard

For a completed problem, explain the contract, baseline, optimized algorithm, invariant, correctness argument, time and auxiliary space, and edge cases without looking at an editorial. Then solve a related problem that changes one key assumption.

## Topic lessons

- [Practicing algorithms with LeetCode](leetcode/README.md)
- [Practicing programming with Edabit](edabit/README.md)
