# Practicing Data Structures and Algorithms with Ruby

> Parent: [Choose a language](../readme.en.md) · [Chapter 1: Foundations](../../readme.en.md) · [فارسی](readme.md)

## Prerequisites and mental map

You should know `Array`, `Hash`, `Set`, `Enumerable`, methods, loops, and blocks. Treat each collection as a tool with specific operations and costs, not as a magic shortcut. Ruby's expressive syntax makes it easy to write compact code, so slow down and count the work performed by each call. For a small input, write down the state after every step.

## The idea from first principles

Ruby's `Array`, `Hash`, and `Enumerable` methods are convenient for prototyping algorithms. The short form can hide shifts, allocations, repeated enumerations, or mutation. In DSA, readable helpers and explicit state are often better than a long chain of clever expressions because they make loop invariants and complexity visible.

## Model, contract, and invariant

- `Array` is an indexable, resizable sequence. Indexing is constant-time; appending/removing at the end is generally efficient, while insertion/removal near the front shifts many elements.
- `Hash` associates keys with values. Lookup/update is typically expected constant time under ordinary hashing assumptions; iteration preserves insertion order in modern Ruby, but key lookup is not sorted order.
- `Set` stores unique elements and uses hash/equality behavior for membership.
- `Enumerable` supplies higher-level traversal methods; understand whether an operation returns a new collection, mutates one, or returns an enumerator.
- Ruby's core standard library does not provide a general binary priority queue API comparable to some language libraries. Implement a heap carefully or select a maintained library with a documented contract.

An **invariant** is a statement that remains true through all loop iterations. For BFS, every item before the `head` index has been processed, every item from `head` onward has been discovered and is waiting, and each vertex is enqueued at most once.

## Step-by-step operation: BFS with a head index

Use an array with a moving index instead of repeatedly removing its first element:

```ruby
queue = [start]
head = 0
visited = { start => true }

while head < queue.length
  u = queue[head]
  head += 1
  graph[u].each do |v|
    next if visited[v]
    visited[v] = true
    queue << v
  end
end
```

Mark a neighbor before appending it so cycles and multiple incoming edges cannot enqueue it more than once. For a queue that lives a long time, a head index can keep the consumed prefix alive; compact occasionally or use a suitable ring-buffer/queue implementation. For a frequency table, `freq[x] = (freq[x] || 0) + 1` works, while a default proc can shorten the code but may mutate the hash on lookup.

## Worked trace

For an undirected graph with edges `A—B`, `A—C`, `B—D`, `C—D`, start at `A` and visit neighbors in the listed order.

| Step | Head before processing | Current vertex | Queue afterward | New discoveries |
|---|---:|---|---|---|
| 0 | 0 | — | `[A]` | `A` |
| 1 | 0 | `A` | `[A,B,C]` | `B,C` |
| 2 | 1 | `B` | `[A,B,C,D]` | `D` |
| 3 | 2 | `C` | `[A,B,C,D]` | none; `D` is visited |
| 4 | 3 | `D` | `[A,B,C,D]` | none |

The order is `A,B,C,D`, with distances `0,1,1,2`. If `shift` were used at every step instead, it would move the remaining array elements repeatedly and can make this queue process quadratic. In your own traces, record each step, pointer/index, active part of the data, state change, and reason.

## Why the approach is correct

Marking on insertion ensures each vertex enters the array once. The head index processes entries in FIFO order: all vertices at distance `d` are processed before vertices at distance `d+1`. Thus first discovery gives a shortest unweighted distance. The loop ends only after every discovered vertex has been processed, so all vertices reachable from the start have been visited.

Hash-based collections depend on keys' `hash` and equality behavior remaining consistent while stored. Mutating an array key in a way that changes its hash/equality can make lookup unreliable. Another Ruby-specific trap is `Array.new(n, [])`: all `n` entries refer to the same inner array. Use a block (`Array.new(n) { [] }`) to create independent rows.

A complete proof names the invariant, checks it before the first iteration, shows each iteration preserves it, and connects the stopping condition to the final result.

## Time and space analysis

Array indexing is `O(1)`, searching for a value is `O(n)`, and sorting is typically `O(n log n)`. Hash/Set membership is expected `O(1)` under ordinary hashing assumptions; worst-case behavior can differ. With adjacency lists, BFS takes `O(V+E)` time and `O(V)` extra space for visited state and the queue. Ruby object allocation and garbage collection can have substantial real costs in allocation-heavy algorithms.

Define the input size and the case being discussed. Account for every nested traversal and for data copied by mutating/non-mutating collection methods. Complexity is a growth model, not a wall-clock prediction.

## Real-world use and choosing the right structure

Ruby is used for scripts, web backends, and interview practice. For a complex problem, small named helpers and an explicit loop are often easier to maintain than a long chained expression. Choose from the operations and ordering required, input size, memory budget, and concurrency/latency needs; profile only after the algorithm is correct and understandable.

## Common mistakes and edge cases

- Repeated `shift` inside a growing queue can turn an otherwise linear traversal into `O(n²)` work.
- Only `nil` and `false` are falsey in Ruby; `0` and empty collections are truthy.
- `Array.new(n, [])` shares one inner array; mutable objects may alias unexpectedly.
- A hash default proc may insert a value during a lookup, so a read can change the collection.
- A mutable hash key can become difficult to find after its hash/equality changes.
- Deep recursion consumes stack; prefer an explicit stack for inputs with unbounded depth.
- Check empty arrays, duplicate elements, missing keys, zero-valued inputs, and large inputs.

## Progressive exercises

1. Implement BFS using an array and `head`; then explain why it is linear while repeated `shift` can be quadratic.
2. Count frequencies with a `Hash`, then use a `Set` to solve a duplicate-detection task. Compare the required information and cost.
3. Build a two-dimensional array whose rows are independent; mutate one row and verify that the others do not change.
4. Implement a binary min-heap with `push` and `pop`, and trace how each operation restores the heap property.

For every exercise, start with a clear correct solution, state the invariant and complexity, add edge cases, and trace a tiny example by hand.

## Comprehensive quiz with explained answers

Try to answer each question before reading its explanation.

1. **What is the cost of searching an array for a value?** — `O(n)` in the general case because elements may need to be checked one at a time.
2. **What should a simple large BFS queue use instead of repeated `shift`?** — A head index or a ring-buffer/queue structure, so removing the next item does not shift the whole remaining sequence.
3. **What is typical Hash/Set membership cost?** — Expected `O(1)` under ordinary hash behavior; do not claim that as a worst-case guarantee.
4. **Is `0` false in a Ruby conditional?** — No. `0` is truthy; only `nil` and `false` are falsey.
5. **Why is `Array.new(n, [])` dangerous for a matrix?** — It repeats the same inner-array object `n` times. Use `Array.new(n) { [] }` so each row is independent.

## Mastery checklist

Explain the head-index queue invariant, trace BFS by hand, distinguish array membership from hash membership, identify Ruby truthiness and aliasing traps, and state what a hash default proc changes. You are ready when you can choose a collection from required operations and give a defensible complexity argument.

## Further reading and references

- [Ruby `Array` documentation](https://docs.ruby-lang.org/en/master/Array.html) — array indexing, insertion, removal, and transformation APIs.
- [Ruby `Hash` documentation](https://docs.ruby-lang.org/en/master/Hash.html) — key/value behavior, defaults, equality, and hash-related methods.
- [Ruby `Set` documentation](https://docs.ruby-lang.org/en/master/Set.html) — uniqueness, set operations, and key hash/equality assumptions.
- [Ruby official documentation index](https://docs.ruby-lang.org/en/master/index.html) — links to the language and standard-library references.
- [Princeton Algorithms, 4th ed.: Priority Queues](https://algs4.cs.princeton.edu/24pq/) — binary heaps and priority-queue operation costs.
- [Roadmap.sh: Data Structures and Algorithms](https://roadmap.sh/datastructures-and-algorithms) — source roadmap for this course.
