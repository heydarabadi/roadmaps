# Practicing DSA with Python

> Parent: [Choose a Language](../README.md) · [Chapter 1](../../README.md)  
> Language: English · [Read this guide in Persian](../../../../../fa/data-structures-and-algorithms/01-foundations/choose-language/python/README.md)

## Prerequisites and mental model

Python is readable for learning and quick algorithm prototyping. The syntax can make an idea clear, but you still need to understand internal costs, object overhead, and mutation.

## Core collections for DSA

- `list` is a dynamic array: indexed access is `O(1)`, append is amortized `O(1)`, and insertion/removal near the front is `O(n)`.
- `dict` and `set` are hash-based; their common membership and lookup costs are average/expected `O(1)` under suitable assumptions.
- `collections.deque` supports efficient operations at both ends and is a natural FIFO queue.
- `heapq` provides a min-heap.
- `bisect` finds a binary-search insertion point in a sorted list, but inserting at that point still shifts items and costs `O(n)`.

## Step-by-step patterns

Use a list as a stack with `append(x)` and `pop()`. Use a deque as a queue with `append(x)` and `popleft()`. For a BFS, initialize `q = deque([s])` and `seen = {s}`; repeatedly call `popleft()`, then add each unseen neighbor to `seen` before appending it. A dictionary such as `parent` can store the path tree. Use `heapq.heappush(h, (priority, item))` for a min-priority queue; a max-priority queue can use negative priorities or the API available in the target Python version.

State empty-input, duplicate, and missing-target behavior explicitly.

## Worked example: BFS

~~~python
q = deque([s])
seen = {s}
while q:
    u = q.popleft()
    for v in adj[u]:
        if v not in seen:
            seen.add(v)
            q.append(v)
~~~

Mark `v` seen when it is enqueued; otherwise several parents may add it repeatedly. Store `parent[v] = u` at the same point if you need to reconstruct a path.

## Correctness and language semantics

Array indices are valid from `0` through `len(A)−1`. Dictionary keys must be hashable; a key's hash and equality must remain stable while it is stored. A heap only guarantees that the root is the minimum; the underlying list is not fully sorted.

For a BFS, the queue and `seen` set establish the invariant that every enqueued vertex is discovered and each vertex is enqueued at most once.

## Time and space analysis

`x in list` is `O(n)`, while dictionary/set membership is average/expected `O(1)`. Slicing a list or string creates a new value and typically costs `O(k)` for the copied length. Python integers can grow beyond a fixed machine-word range, but larger integers require more storage and arithmetic work. Object overhead is larger than in a packed native array and can matter under memory limits.

## Practical use

Python is useful for algorithm prototypes, data processing, and interview practice. Large CPU-heavy loops may expose interpreter overhead; profile before replacing a clear implementation with lower-level code or an optimized library.

## Common mistakes and edge cases

- Do not use `list.pop(0)` as a repeatedly used queue; it shifts the remaining elements.
- Slicing creates copies; account for time and memory.
- `list.sort()` mutates the list; `sorted()` returns a new list.
- A heap tuple uses later tuple fields to break priority ties; choose tie behavior deliberately.
- Recursion has a depth limit; consider an iterative algorithm for deep inputs.
- Check custom key hashability and equality, empty collections, duplicates, and large integers.

## Step-by-step exercises

1. Implement a stack, queue, and min-heap using standard APIs.
2. Compare membership in a list with membership in a dictionary or set for large `n`.
3. Write BFS using `deque` and analyze the memory used by `seen`.

For each exercise, begin with a correct baseline, analyze the costs, and add an edge case. Trace a small input and compare the result with an independently derived expectation.

## Comprehensive quiz with explained answers

1. **Which standard collection makes a good queue?** `collections.deque`, using `popleft()` at the front.
2. **What kind of heap does `heapq` provide?** A min-heap, so the smallest item is at the root.
3. **What is `x in list`?** `O(n)` in the worst case because items may need to be scanned.
4. **Why does slicing cost time?** It creates a new collection with copied elements, typically `O(k)` for a slice of length `k`.
5. **What condition should dictionary keys meet?** They must be hashable, and their hash/equality behavior must stay stable while stored.

## Further reading and references

- [Python Tutorial — Data Structures](https://docs.python.org/3/tutorial/datastructures.html) — list operations, stacks, and queues.
- [Python `collections.deque`](https://docs.python.org/3/library/collections.html#collections.deque) — double-ended queue API.
- [Python `heapq`](https://docs.python.org/3/library/heapq.html) — priority queue and min-heap operations.
- [Python `bisect`](https://docs.python.org/3/library/bisect.html) — binary search and insertion points in sorted lists.
- [CP-Algorithms — Introduction to Data Structures](https://cp-algorithms.com/data_structures/intro.html) — broader algorithmic structures.
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html).

## Mastery checklist

- [ ] I can choose the correct Python collection for a workload.
- [ ] I can explain its complexity and copy/mutation behavior.
- [ ] I can trace BFS and handle empty or duplicate data.
- [ ] I have completed the exercises and reviewed the edge cases.
