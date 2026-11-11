# Multithreaded Algorithms

> Chapter: [08 Problem Solving Techniques](../readme.en.md) · [Persian version](readme.md)

## Learning goals and prerequisites

Prerequisites: Sequential algorithms, threads, synchronization, and shared-memory basics. After this lesson, you should be able to explain the pattern, identify when it applies, trace a small input, justify correctness, analyze time and space, and recognize cases where it is unsafe.

## Core idea

Multithreading splits work across workers to reduce elapsed time or increase throughput. A correct parallel design must account for dependencies and shared-state safety as well as raw operation count. More threads do not guarantee proportional speedup.

## Model, contract, and invariant

Work T₁ is the total amount of computation; span T∞ is the longest chain of dependent tasks. With P workers, runtime is bounded below by max(T₁/P,T∞), before scheduling and communication overhead. A data race occurs when concurrent accesses to shared state include a write and lack appropriate synchronization.

An invariant is a statement that remains true at a defined point in every iteration or recursive call. Write it before implementation. It gives you a way to reason about what has been processed, which candidates remain possible, and why a pointer or state update is safe.

## Step-by-step algorithm

Parallel sum: divide the array into disjoint chunks; each worker computes a local sum; combine the partial sums with a tree reduction. Avoid locking a shared accumulator for every element. For shared mutable state, use a lock or atomic primitive with a clear memory-visibility contract.

Before coding, decide the input contract: empty inputs, duplicates, out-of-range values, failure results, and whether mutation is allowed. Keep the interval convention and index base consistent throughout the implementation.

## Worked trace

Split n values over P workers, each handling about n/P values. The local work is O(n/P); merging P partial sums takes O(log P) with a reduction tree or O(P) sequentially. If all workers increment one shared counter without synchronization, updates may be lost even if the program seems to work on small runs.

For a manual trace, record the iteration or recursion depth, current indices/state, active candidate range, and the reason for each update. This makes boundary mistakes and unsafe pruning visible.

## Correctness reasoning

Each input element belongs to exactly one chunk, so each local result is the sum of a disjoint subset. The reduction combines every partial result exactly once. Thread safety additionally requires that reads/writes obey the synchronization rules and that each worker sees valid published data.

For loops, make the proof explicit: initialization establishes the invariant; each iteration preserves it; termination plus the invariant establishes the result. For recursion, identify a decreasing measure and use induction on input size. For search patterns, also explain why each discarded candidate cannot be needed in a valid answer.

## Time and space analysis

Ideal runtime is at least max(T₁/P,T∞); real performance is limited by serial work, memory bandwidth, lock contention, scheduling, false sharing, and data movement. Amdahl’s law limits speedup when some fraction is serial. Parallel tasks also consume stacks and buffers.

Define n (and any other independent input sizes) before stating complexity. Separate best, expected/average, and worst case where they differ. Report auxiliary memory separately from the required output. A complexity bound describes growth, not seconds; allocation, cache locality, runtime behavior, and constants also matter.

## Real-world use

Image processing, scientific computing, request handling, pipelines, and map/reduce workloads. For I/O-bound work, asynchronous I/O may be more effective than adding threads; for CPU-bound work, parallel computation must outweigh coordination overhead.

Choose a technique from the workload and constraints, not from its name. Ask whether the input is ordered, whether updates are allowed, whether all answers or only one are required, and whether a worst-case guarantee is necessary.

## Common pitfalls and edge cases

Races, deadlocks, starvation, false sharing, nondeterministic failures, and load imbalance. Prefer disjoint ownership where possible. Tasks that are too small spend more time scheduling than computing; tasks that are too large leave workers idle.

Always consider an empty input, a singleton, repeated values, an absent target, the largest allowed input, and values at the contract boundaries. Confirm that the termination condition guarantees progress.

## Exercises

1. Design a four-worker parallel reduction and show the partial sums. 2. Demonstrate a race on a shared counter and fix it with an atomic or lock. 3. Use Amdahl’s law to estimate the maximum speedup when 20% of the work is serial.

Solve these without looking up a template. For each one, write the invariant, trace a small example, analyze the cost, and add at least one boundary test. Then compare your explanation with the worked example and quiz below.

## Self-check quiz — with answer explanations

Try each question before reading its answer.

1. **Question:** What is work T₁?
   **Answer:** The total amount of computation, comparable to the sequential runtime.
2. **Question:** What is span T∞?
   **Answer:** The longest dependency chain that cannot run in parallel.
3. **Question:** What is a data race?
   **Answer:** Unsynchronized concurrent access to shared state, including a write.
4. **Question:** Why is speedup not always linear in worker count?
   **Answer:** Serial work, bandwidth, synchronization, scheduling, and dependencies limit scaling.
5. **Question:** How can a reduction avoid a shared-write race?
   **Answer:** Compute independent local results and combine them in a controlled reduction.

## Further reading and references

These sources provide complementary explanations, formal material, visualizations, or practice. The lesson above contains the core concepts needed to understand the topic.

- [MIT 6.506 — Parallel Algorithms, lecture 2: Work-Span model (PDF)](https://jshun.csail.mit.edu/6506-f25/lectures/lecture2.pdf)
- [MIT — Parallel Algorithms course](https://people.csail.mit.edu/ghaffari/PA26/)
- [cppreference — std::thread](https://en.cppreference.com/w/cpp/thread/thread)
- [Go Memory Model](https://go.dev/ref/mem)

## Mastery checklist

- [ ] I can explain the precondition and the invariant in my own words.
- [ ] I can trace a nontrivial example and an edge case by hand.
- [ ] I can justify why the algorithm is correct and terminates.
- [ ] I can state time, auxiliary space, and the assumptions behind each bound.
- [ ] I can name one suitable workload and one case where this technique is a poor fit.
