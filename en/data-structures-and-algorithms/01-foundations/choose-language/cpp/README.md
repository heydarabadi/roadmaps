# Practicing DSA with C++

> Parent: [Choose a Language](../README.md) · [Chapter 1](../../README.md)  
> Language: English · [Read this guide in Persian](../../../../../fa/data-structures-and-algorithms/01-foundations/choose-language/cpp/README.md)

## Prerequisites and mental model

C++ provides control over memory and types along with the Standard Template Library (STL). You also need to understand ownership, iterator invalidation, and undefined behavior. Standard containers usually provide efficient implementations for common DSA operations.

## Core collections for DSA

- `vector<T>` is a dynamic array: indexed access is `O(1)`, and `push_back` is amortized `O(1)`.
- `deque<T>` supports efficient operations at both ends.
- `list<T>` is a doubly linked list.
- `stack`, `queue`, and `priority_queue` provide common ADTs.
- `map` and `set` are ordered tree-based containers with `O(log n)` operations.
- `unordered_map` and `unordered_set` are hash-based and provide average `O(1)` operations, with weaker worst-case behavior.
- `priority_queue` is a max-heap by default.

## Step-by-step patterns

Use `queue<int>` and `vector<char>` for a graph BFS. For a min-priority queue in Dijkstra's algorithm, use a `priority_queue` with `greater<>`, for example a queue of `(distance, vertex)` pairs. Store distances in `long long`; with lazy duplicate entries, discard a popped pair whose distance is no longer current. Use `vector::reserve` when the expected size is known to reduce reallocations.

Define integer ranges, empty-input behavior, duplicate policy, and comparator ordering before implementation.

## Worked example

~~~cpp
priority_queue<int, vector<int>, greater<int>> pq;
pq.push(8);
pq.push(3);
int smallest = pq.top(); // 3
~~~

The comparator changes the default max-heap into a min-heap. In Dijkstra, a stale entry can be skipped with `if (d != dist[u]) continue;`.

For a trace, record the heap contents, current distance, parent, and every relaxation.

## Correctness and language semantics

A `vector` reallocation may invalidate pointers, references, and iterators. Inserts and erases can also invalidate iterators at or after the changed position. A sort/map comparator must define a strict weak ordering; using `<=` is not a valid comparator. Be deliberate about signed and unsigned values.

## Time and space analysis

Vector indexed access is `O(1)`, `push_back` is amortized `O(1)`, and middle insertion is `O(n)`. `map` lookup is `O(log n)`; `unordered_map` lookup is average `O(1)` and worst-case `O(n)`. `std::sort` is `O(n log n)` but not stable; `stable_sort` preserves equal-key order and may use extra memory.

## Practical use

C++ is used for performance-sensitive systems, native libraries, graph algorithms, and programming contests. RAII and standard containers help avoid manual memory-management errors; raw pointers are rarely needed just to own new objects.

## Common mistakes and edge cases

- Watch signed/unsigned comparisons and integer overflow.
- Do not use iterators or references after invalidating operations.
- Account for vector growth and recursive depth.
- `vector<bool>` is a specialized representation with different reference behavior.
- Comparator subtraction can overflow; use a safe comparison such as `std::less` or explicit branches.
- Check empty containers, very large sums, and duplicate keys.

## Step-by-step exercises

1. Compare `stack`, `queue`, ordered `map`, and `priority_queue` operations.
2. Rewrite a vector loop so an iterator is not used after `erase` invalidates it.
3. Implement Dijkstra using 64-bit distances and a min-heap.

For each exercise, start with a correct baseline, analyze cost and invalidation, and add an edge case. Trace a small input and check its result independently.

## Comprehensive quiz with explained answers

1. **What is the default `priority_queue`?** A max-heap; the largest element appears at `top()`.
2. **What is `vector::push_back`?** Amortized `O(1)`; a particular reallocation may take `O(n)`.
3. **How do `map` and `unordered_map` differ?** `map` is ordered and `O(log n)`; `unordered_map` is hash-based with average `O(1)` and worst-case `O(n)`.
4. **Why use `reserve`?** If the expected size is known, it can reduce reallocations.
5. **When can vector iterators become invalid?** Reallocation invalidates them; insert/erase can invalidate iterators at and after the affected position.

## Further reading and references

- [cppreference — Containers Library](https://en.cppreference.com/w/cpp/container.html) — overview and categories of standard containers.
- [cppreference — `std::vector`](https://en.cppreference.com/w/cpp/container/vector) — dynamic-array behavior and iterator invalidation.
- [cppreference — `std::priority_queue`](https://en.cppreference.com/w/cpp/container/priority_queue) — heap ordering and complexity.
- [cppreference — `std::unordered_map`](https://en.cppreference.com/w/cpp/container/unordered_map) — hash map semantics and average complexity.
- [Princeton Algorithms — Priority Queues](https://algs4.cs.princeton.edu/24pq/) — heap operations and implementations.
- [Persian supplementary course — Data Structures and Algorithms](https://cs-um.github.io/docs/mandatory/Data-Structures/).

## Mastery checklist

- [ ] I can select a standard container for the required operations.
- [ ] I can identify iterator/reference invalidation risks.
- [ ] I can implement a min-priority queue and use a safe numeric type.
- [ ] I have completed and reviewed the exercises independently.
