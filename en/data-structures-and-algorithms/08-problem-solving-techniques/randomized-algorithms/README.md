# Randomized Algorithms

> Chapter: [08 Problem Solving Techniques](../README.md) · [Persian version](../../../../fa/data-structures-and-algorithms/08-problem-solving-techniques/randomized-algorithms/README.md)

## Learning goals and prerequisites

Prerequisites: Basic probability, expected value, and algorithm analysis. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

A randomized algorithm uses random choices to improve expected runtime, simplify design, or approximate an answer. A Las Vegas algorithm always returns a correct result but has random runtime. A Monte Carlo algorithm has bounded runtime but may return an incorrect result with a controlled probability. State which guarantee you have.

## Model, contract, and invariant

Expected runtime is an average over the algorithm’s random choices, not over a presumed input distribution. A uniform random pivot changes the behavior of quicksort/Quickselect without relying on input order. A pseudorandom seed helps reproducible debugging; security-sensitive randomness requires a cryptographically secure source.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

Randomized Quickselect: choose a pivot uniformly; partition; continue only in the side containing the target rank. Reservoir sample k items from a stream: keep the first k; for item i>k, draw a uniform integer from 1..i and replace a reservoir slot only if the draw is ≤k.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

For reservoir size 1, keep the first item. At item i, replace the current item with probability 1/i. The first item survives all later steps with probability (1/2)(2/3)…((n−1)/n)=1/n; each later item is selected with probability 1/i and survives through n with probability i/n, also giving 1/n.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

For reservoir sampling, use induction: after i items, every item has probability k/i of being in the reservoir. A new item is admitted with probability k/i; an old item survives the replacement step with probability 1−1/i when one slot is selected, which preserves the same marginal probability. The full algorithm must sample the replacement slot uniformly.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

Randomized Quickselect is expected O(n) but worst-case O(n²). Reservoir sampling uses O(n) time and O(k) memory. Hash tables often have expected constant operations under their hash assumptions, not unconditional worst-case guarantees. Quantify error probability for Monte Carlo methods.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Sampling large streams, randomized load balancing, pivot selection, probabilistic testing, and cryptographic protocols. Use a CSPRNG for secrets; ordinary simulation randomness is not appropriate for tokens or keys.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Random-looking does not mean unbiased. Expected-case bounds are not worst-case bounds. Fixed seeds aid tests but may expose adversarial behavior if used in a security context. Monte Carlo error should be derived and reported, not guessed.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Derive the probability that the first element remains in a size-one reservoir after n items. 2. Contrast Las Vegas and Monte Carlo with concrete algorithms. 3. Explain how a random pivot changes quicksort’s expected analysis.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What does Las Vegas guarantee?
   **Answer:** Correct output, with a runtime that may vary randomly.
2. **Question:** What does Monte Carlo trade?
   **Answer:** A bounded/runtime guarantee for a small probability of an incorrect result.
3. **Question:** What is the expected time of randomized Quickselect?
   **Answer:** O(n), although the worst case is still O(n²).
4. **Question:** Why use a fixed seed in a test?
   **Answer:** To reproduce and debug a random execution.
5. **Question:** What RNG is appropriate for secrets?
   **Answer:** A cryptographically secure random-number generator.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [UT Austin — Randomized Algorithms lecture notes](https://www.cs.utexas.edu/~ecprice/courses/randomized/fa15/notes/lec1.pdf)
- [Cornell ORIE 5270 — Randomized algorithms and reservoir sampling](https://people.orie.cornell.edu/vc333/orie5270/lectures/04/)
- [University of Bonn — Randomized Algorithms notes (reservoir sampling)](https://nerva.cs.uni-bonn.de/doku.php/lehre/ss16/vl-randalg)
- [CP-Algorithms — Primality tests and randomized algorithms](https://cp-algorithms.com/algebra/primality_tests.html)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
