# Practicing Programming with Edabit

> Chapter: [Practice and Self-Assessment](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: basic syntax, functions, conditionals, loops, and the standard collections of your chosen language. After this lesson, you should be able to treat a short exercise as a specification, test boundary cases, and explain a small implementation instead of only matching sample output.

## Core idea

Edabit offers short coding exercises that help build syntax fluency and confidence with small programming tasks. These exercises complement larger algorithm practice; they do not replace complexity analysis or advanced data-structure study. Even a one-line function has input types, output behavior, and edge cases.

## Contract, state, and invariant

Before coding, determine the allowed input, exact return type, behavior for empty or unusual input, and whether the function may mutate its argument. For a loop-based accumulator, a useful invariant is: before iteration `i`, the accumulator equals the result for the prefix already processed.

## Step-by-step example: summing an array

First decide what an empty array means. If the contract defines its sum as zero, initialize `total = 0`, add each element, and return the result. For `[4, -2, 5]`, the running totals are 0, 4, 2, and 7. Each input value contributes exactly once. If the specification permits `null` or nonnumeric values, define that behavior too instead of guessing.

## Correctness reasoning

At initialization, the empty prefix has sum zero. Each iteration adds the next element, so the accumulator equals the sum of the enlarged prefix. When the loop ends, the prefix is the full array; therefore the returned value is the sum of every element. This proof also suggests useful tests: empty input, one element, negative values, and duplicates.

## Time and space analysis

A single pass over n values is O(n) time and O(1) auxiliary space. Repeated immutable-string concatenation may copy the growing prefix and cost O(n²); a string builder or array join may be better. For tiny inputs, readable code is usually more valuable than micro-optimization, but understand the cost of the operation you use.

## Practical value

Short exercises build typing speed, introduce standard-library APIs, and make small functions easier to test. In production code, clear names, explicit error behavior, and maintainable control flow matter more than compressing the implementation into a clever one-liner.

## Common pitfalls and exercises

Do not test only the happy path. Languages differ in truthiness, integer division, negative remainders, Unicode representation, numeric precision, mutability, and overflow. The exercise title does not fully specify the contract; read the prompt and examples carefully.

1. Add tests for empty input, a single element, duplicates, negatives, and a large input.
2. Write a readable and a concise version of one solution; compare which explains the intent better.
3. Solve the same small exercise in a second language and record semantic differences.

## Self-check quiz — with answers

1. **What is Edabit especially useful for?** Short exercises that improve syntax and basic programming fluency.
2. **Why define a contract for a tiny function?** Empty input, types, and return behavior can still change correctness.
3. **What does the accumulator invariant say?** Before each iteration, the accumulator equals the result for the processed prefix.
4. **Why can repeated immutable-string concatenation be slow?** Each operation may copy the growing string, causing quadratic total work.
5. **Is passing the platform tests sufficient for mastery?** No. Also explain edge cases, readability, side effects, and complexity.

## Further reading and references

- [Edabit coding challenges](https://edabit.com/challenges)
- [Edabit JavaScript challenges](https://edabit.com/challenges/javascript)
- [Edabit Python challenges](https://edabit.com/challenges/python3)
- [Edabit C++ challenges](https://edabit.com/challenges/cpp)
- [MIT 6.006: Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)

## Mastery checklist

- [ ] I can restate the function contract and handle its edge cases.
- [ ] I can explain the invariant or reasoning behind the implementation.
- [ ] I can state time and auxiliary-space complexity.
- [ ] I can write readable code without relying on a copied one-liner.
