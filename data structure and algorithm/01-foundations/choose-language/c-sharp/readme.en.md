# Practicing Data Structures and Algorithms with C#

> Parent: [Choose a language](../readme.en.md) · [Chapter 1: Foundations](../../readme.en.md) · [فارسی](readme.md)

## Prerequisites and mental map

You should be comfortable with types, generics, classes, interfaces, arrays, and basic loops. Treat a collection API as a contract: identify the values it stores, the operations it supports, and what each operation promises. Then trace a small input by writing down the state after every step. The goal is not to memorize class names; it is to explain why a chosen structure fits the operations your algorithm needs.

## The idea from first principles

C# and .NET provide generic collections, LINQ, and a managed runtime. For algorithm work, learn the difference between `List<T>` and `LinkedList<T>`, the expected behavior of hash-based collections, how comparers define order and equality, and where allocations or copies occur. LINQ can make transformations concise, but deferred enumeration or materialization can hide repeated work and memory use.

## Model, contract, and invariant

- `T[]` is a fixed-length array with indexed access.
- `List<T>` is a resizable array. It supports fast indexing and appending, while inserting or removing in the middle shifts elements.
- `LinkedList<T>` is a doubly linked list. Insertion/removal at a known node is constant time, but finding that node is linear and each node adds allocation and pointer overhead.
- `Queue<T>` is FIFO; `Stack<T>` is LIFO; `PriorityQueue<TElement,TPriority>` exposes the smallest priority first in current .NET implementations/API contracts.
- `Dictionary<TKey,TValue>` and `HashSet<T>` are hash-based. `SortedDictionary<TKey,TValue>` keeps keys ordered using a tree.

An **invariant** is a statement that must remain true throughout an algorithm. State it before coding; it helps prove correctness and reveals boundary conditions. For BFS, for example, every vertex already removed from the queue has been discovered, and the queue contains discovered vertices awaiting expansion.

## Step-by-step operation: BFS and Dijkstra

For breadth-first search, a typical queue skeleton is:

```csharp
var queue = new Queue<int>();
queue.Enqueue(start);
while (queue.Count > 0)
{
    int u = queue.Dequeue();
    // Visit each undiscovered neighbor v:
    // mark v discovered, then queue.Enqueue(v).
}
```

Mark a vertex as discovered when you enqueue it, not when you later dequeue it; otherwise the same vertex can be queued repeatedly. For Dijkstra's algorithm, use a priority queue keyed by tentative distance. When an item is removed, compare its queued distance with the current `dist[u]`; skip stale entries. Define the input/output contract explicitly, including an empty graph, duplicate edges, unreachable vertices, and negative weights (Dijkstra requires nonnegative edge weights).

For custom keys, equality and hashing must agree: values considered equal by the equality comparer must produce the same hash code. Use the target framework's documentation for APIs such as `TryDequeue`, which may differ across older framework versions.

## Worked trace

Consider edges `S→A (2)`, `S→B (5)`, `A→B (1)`, `A→C (4)`, `B→C (1)`. Start with `dist[S]=0` and all other distances infinite.

| Step | Removed `(vertex, distance)` | Relaxation | Queue afterward |
|---|---|---|---|
| 1 | `(S,0)` | `A=2`, `B=5` | `(A,2),(B,5)` |
| 2 | `(A,2)` | improve `B=3`; set `C=6` | `(B,3),(B,5),(C,6)` |
| 3 | `(B,3)` | improve `C=4` | `(C,4),(C,6),(B,5)` |
| 4 | `(C,4)` | no change | stale entries are skipped |

The final distances are `S=0, A=2, B=3, C=4`. This trace shows why old priority-queue entries must be checked against the current distance. In a real exercise, use a table with step, index/pointer, active code, state change, and reason; it prevents mental leaps in in-place and divide-and-conquer algorithms.

## Why the approach is correct

For the BFS queue, the invariant is that all queued vertices have been discovered and are waiting to be expanded; FIFO order processes vertices in nondecreasing distance from the start. Marking a vertex before enqueueing ensures it enters the queue once. Therefore the first discovery assigns the shortest unweighted-path distance.

For a `Dictionary` key, `Equals` and `GetHashCode` must remain consistent. Mutating a key in a way that changes its hash/equality after insertion can make it unreachable in its old bucket. Structural changes to most .NET collections during enumeration invalidate the enumerator and commonly throw `InvalidOperationException`.

A correctness proof normally has three parts: **initialization** (the invariant holds before the first step), **maintenance** (each step preserves it), and **termination** (the stopping condition plus the invariant implies the desired result). If one part is missing, the reasoning is incomplete.

## Time and space analysis

Typical costs: `List<T>` index access `O(1)`, append amortized `O(1)`, and middle insertion/removal `O(n)`; queue enqueue/dequeue `O(1)` amortized; dictionary/set lookup average `O(1)`; sorted dictionary lookup/update `O(log n)`. These are growth bounds, not seconds. Actual performance also depends on cache behavior, allocation, element type, and implementation constants. Value types can be copied; reference types add indirection; boxing can allocate when value types cross APIs typed as `object` or non-generic interfaces.

For every complexity statement, define the input size (for example, `n` elements), identify best/average/worst case, and distinguish auxiliary space from the input itself. A BFS over `V` vertices and `E` edges takes `O(V+E)` time and `O(V)` auxiliary space, excluding the graph representation.

## Real-world use and choosing the right structure

These collections are used in .NET services, command-line tools, and games. A small `struct` may reduce object allocations but can make copying more expensive; measure the real workload after choosing a correct, clear design. Before choosing, ask which operations are frequent, whether key order matters, how large the input can become, and whether memory limits, worst-case latency, or concurrent access matter. A suitable structure for the wrong workload is still a poor choice.

## Common mistakes and edge cases

- Re-enumerating a deferred LINQ query can repeat its computation; `ToList()`/`ToArray()` materializes it but allocates memory.
- `List<T>.RemoveAt(0)` shifts the remaining elements; use `Queue<T>` for FIFO behavior.
- Integer overflow depends on the type and checked context; check distance and index arithmetic.
- Recursive calls consume stack space and can overflow on deep inputs.
- Never mutate equality/hash-relevant parts of a key while it is stored in a hash collection.
- Test empty input, one item, duplicate values, absent targets, minimum/maximum values, and large inputs.

## Progressive exercises

1. Implement BFS using `Queue<int>` and a `HashSet<int>` or a Boolean array for visited state. State the queue invariant and test a cycle.
2. Compare `Dictionary<TKey,TValue>` with `SortedDictionary<TKey,TValue>` for lookup, sorted iteration, and range-oriented tasks.
3. Check your target framework's `PriorityQueue` API, then implement Dijkstra. Include an unreachable vertex and a stale queue entry.

For each exercise, first write the simplest correct version, then analyze it, add edge cases, and trace one small input by hand. Compare the result with an independently reasoned expected output.

## Comprehensive quiz with explained answers

Try each question before reading its explanation.

1. **What is `List<T>` backed by conceptually?** — A resizable array. Indexing is constant time; insertion in the middle shifts elements.
2. **Which standard type provides FIFO operations?** — `Queue<T>` with `Enqueue` and `Dequeue`.
3. **What is the usual average lookup cost of `Dictionary<TKey,TValue>`?** — `O(1)`, assuming a reasonable hash distribution; this is not a promise of worst-case constant time.
4. **Why can a mutable dictionary key be dangerous?** — If its hash/equality changes after insertion, lookup searches a different bucket from the one where it was stored.
5. **What work can LINQ hide?** — Deferred computation that runs during enumeration, repeated enumeration, and allocations when a result is materialized.

## Mastery checklist

Without looking back, explain the collection choices, their operation costs, one invariant, a hand-traced BFS or Dijkstra run, and at least two edge cases. You are ready to move on when you can justify the structure from the workload and distinguish average-case from worst-case claims.

## Further reading and references

- [Collections and data structures in .NET](https://learn.microsoft.com/en-us/dotnet/standard/collections/) — official selection guide and collection behavior.
- [Commonly used collection types](https://learn.microsoft.com/en-us/dotnet/standard/collections/commonly-used-collection-types) — official overview of lists, queues, stacks, and dictionaries.
- [System.Collections.Generic namespace](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic?view=net-10.0) — API reference, including `PriorityQueue<TElement,TPriority>`.
- [List<T> API reference](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1) — methods and type contract.
- [Princeton Algorithms, 4th ed.: Analysis of Algorithms](https://algs4.cs.princeton.edu/14analysis/) — asymptotic analysis and practical cost models.
- [Roadmap.sh: Data Structures and Algorithms](https://roadmap.sh/datastructures-and-algorithms) — source roadmap for this course.
