# Practicing Data Structures and Algorithms with Java

> Parent: [Choose a language](../README.md) · [Chapter 1: Foundations](../../README.md) · [فارسی](../../../../../fa/data-structures-and-algorithms/01-foundations/choose-language/java/README.md)

## Prerequisites and mental map

You should know classes, generics, arrays, interfaces, loops, and basic object equality. Treat a collection as a contract: choose it from the operations needed, not from familiarity alone. Trace a small input and record the state after each step. For Java, also distinguish primitives from boxed values such as `int` and `Integer`; boxing and object references can affect memory and runtime.

## The idea from first principles

The Java Collections Framework provides standard interfaces and interchangeable implementations. Learn the cost and behavior behind each type: dynamic arrays versus linked nodes, equality and hashing for keys, ordering contracts for comparators, and the memory overhead of boxed values. An interface such as `Queue<E>` names behavior; a concrete type such as `ArrayDeque<E>` provides an implementation.

## Model, contract, and invariant

- `ArrayList<E>` is a resizable array: indexed reads are `O(1)`, appending is amortized `O(1)`, and middle insertion/removal shifts elements.
- `LinkedList<E>` is a doubly linked implementation of `List` and `Deque`; it does not make finding an arbitrary position constant time.
- `ArrayDeque<E>` is a resizable array deque and is a strong default for stack/queue use. It rejects `null` elements.
- `HashMap`/`HashSet` are hash-based and commonly provide average constant-time lookup; `TreeMap`/`TreeSet` keep keys/elements sorted with logarithmic operations.
- `PriorityQueue<E>` is a min-priority queue by natural ordering unless given a comparator.

An **invariant** is a statement that stays true as the algorithm runs. For BFS, all enqueued vertices have already been marked discovered and await expansion. Mark a vertex before adding it so cycles cannot put it in the queue repeatedly.

## Step-by-step operation: BFS and Dijkstra

For BFS, use a deque as a FIFO queue:

```java
Deque<Integer> queue = new ArrayDeque<>();
queue.addLast(start);
visited[start] = true;
while (!queue.isEmpty()) {
    int u = queue.removeFirst();
    for (int v : graph[u]) {
        if (!visited[v]) {
            visited[v] = true;
            queue.addLast(v);
        }
    }
}
```

For Dijkstra, use `PriorityQueue<State>` ordered by distance, typically with `Comparator.comparingLong(State::distance)`. When removing a state, skip it if its distance no longer equals `dist[state.node()]`; the queue can contain obsolete entries after a better route is found. Use `long` for path totals when the maximum sum may exceed the `int` range. Avoid a comparator such as `(a, b) -> (int)(a.distance - b.distance)`: subtraction/casting may overflow and violate comparator ordering.

## Worked trace

For directed weighted edges `S→A (2)`, `S→B (5)`, `A→B (1)`, `A→C (4)`, `B→C (1)`, run Dijkstra from `S`.

| Step | Polled `(node,distance)` | Relaxations | Relevant queue entries |
|---|---|---|---|
| 1 | `(S,0)` | `A=2`, `B=5` | `(A,2),(B,5)` |
| 2 | `(A,2)` | improve `B=3`; set `C=6` | `(B,3),(B,5),(C,6)` |
| 3 | `(B,3)` | improve `C=4` | `(C,4),(C,6),(B,5)` |
| 4 | `(C,4)` | no change | `(C,6),(B,5)` are stale and skipped later |

The final distances are `S=0, A=2, B=3, C=4`. Java's `PriorityQueue` returns the least item at its head, but its iterator does not promise sorted traversal. For a hand trace, record each step, active state, change, and reason; this helps expose missed updates and boundary mistakes.

## Why the approach is correct

For BFS, FIFO ordering processes every vertex at distance `d` before vertices at `d+1`; marking on enqueue prevents duplicate queue entries. Therefore the first assigned distance is the shortest unweighted path length.

For a custom `HashMap` key, equal objects must have equal hash codes, and the key's equality/hash behavior must not change while stored. `ArrayDeque` prohibits `null`, so use an explicit sentinel or a separate empty-state check rather than a null element. Dijkstra is correct only when all edge weights are nonnegative; its greedy removal of the smallest tentative distance is then final for that vertex.

A proof should establish **initialization** (invariant initially holds), **maintenance** (each step preserves it), and **termination** (the invariant plus stopping condition implies the requested result).

## Time and space analysis

Common costs: `ArrayList.get` `O(1)`, append amortized `O(1)`, middle insertion `O(n)`; `HashMap` lookup average `O(1)`; `TreeMap` lookup/update `O(log n)`; priority-queue `offer`/`poll` `O(log n)` and `peek` `O(1)`. `PriorityQueue.remove(Object)` and `contains(Object)` are linear, and iteration is not ordered. Boxing values into `Integer` or allocating per-vertex objects adds memory and garbage-collection work.

Define `n` (or `V` and `E` for graphs), say whether you analyze best, average, or worst case, and separate auxiliary memory from the input. Dijkstra with a binary heap is typically `O((V+E) log V)` time and `O(V+E)` total space including the graph, or `O(V)` additional state excluding the graph.

## Real-world use and choosing the right structure

These structures support Java services, graph processing, caches, and general collection APIs. For primitive-heavy workloads, primitive arrays can use less memory than `List<Integer>` and avoid boxing. Decide from the operation mix, required ordering, input size, memory/latency constraints, and concurrency requirements; then measure the real workload if performance matters.

## Common mistakes and edge cases

- Comparing objects with `==` when value equality requires `equals`.
- Violating the `equals`/`hashCode` contract for hash keys, or mutating a key after insertion.
- Assuming `PriorityQueue` iteration is sorted or that arbitrary removal is logarithmic.
- Using subtraction in a comparator where values may overflow.
- Forgetting integer overflow in path totals; choose a wide enough type and handle “infinity” safely.
- Assuming recursion has unlimited stack; deep recursion can still overflow the thread stack.
- Test empty graphs, a single vertex, duplicate edges, unreachable vertices, tied priorities, negative weights, and large path sums.

## Progressive exercises

1. Compare `HashMap` with `TreeMap` and `HashSet` with `TreeSet`; include ordering and operation costs.
2. Define a `State` record/class and write a safe comparator for a priority queue of distances.
3. Create two custom key objects that are equal and show why inconsistent `equals` and `hashCode` can cause incorrect map behavior.

For each, write a simple correct solution first, state the complexity, add edge cases, and hand-trace one small input before checking your output independently.

## Comprehensive quiz with explained answers

Try to answer before reading each explanation.

1. **What is a good general-purpose FIFO queue implementation?** — `ArrayDeque`, using `addLast` and `removeFirst` (or the queue methods). It avoids shifting all remaining elements on every removal.
2. **What does a default `PriorityQueue<Integer>` expose first?** — The least integer according to natural ordering, so it behaves as a min-priority queue.
3. **What is the typical average `HashMap` lookup cost?** — `O(1)` under ordinary hash distribution; this is not a universal worst-case guarantee.
4. **Why may distances need `long`?** — A path is a sum of edge weights and that sum can exceed the `int` range even when each edge fits in `int`.
5. **What must be true for objects considered equal by `equals`?** — They must return the same `hashCode`; otherwise hash-based collections cannot reliably find equivalent keys.

## Mastery checklist

Explain the difference between a collection interface and implementation; select `ArrayDeque`, `ArrayList`, `HashMap`, `TreeMap`, or `PriorityQueue` from operation needs; trace BFS or Dijkstra; and justify the invariant, comparator, complexity, and edge cases. You should also be able to explain why a queue's iteration order and a map's key lookup contract are separate concerns.

## Further reading and references

- [Collections Framework Overview (Java SE 21)](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/doc-files/coll-overview.html) — official implementation comparison and framework concepts.
- [ArrayDeque API (Java SE 21)](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/ArrayDeque.html) — deque operations and null restriction.
- [ArrayList API (Java SE 21)](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/ArrayList.html) — resizable-array list contract.
- [PriorityQueue API (Java SE 21)](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/PriorityQueue.html) — ordering, iteration caveat, and operation costs.
- [Map API (Java SE 21)](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/Map.html) — key equality and ordering contracts.
- [Roadmap.sh: Data Structures and Algorithms](https://roadmap.sh/datastructures-and-algorithms) — source roadmap for this course.
