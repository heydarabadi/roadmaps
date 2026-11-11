# Practicing Data Structures and Algorithms with Go

> Parent: [Choose a language](../README.md) · [Chapter 1: Foundations](../../README.md) · [فارسی](../../../../../fa/data-structures-and-algorithms/01-foundations/choose-language/go/README.md)

## Prerequisites and mental map

You should know slices, maps, functions, structs, loops, and basic pointer/value behavior. Start by stating what each collection promises, then trace a small input and record the state after every operation. Pay particular attention to a slice's length and capacity: they affect how append works and whether two slices still share storage.

## The idea from first principles

Go favors simple built-in types and value semantics. A slice is a small descriptor over an array, a map is a hash-based key/value structure, and `container/heap` operates through an interface you implement. The language's apparent simplicity does not remove allocation costs or aliasing: two slice values can refer to the same backing array, and an `append` can either reuse that array or allocate a new one.

## Model, contract, and invariant

- A slice descriptor contains a pointer to a backing array, a length, and a capacity. Indexing is constant time; append is amortized constant time, but may allocate and copy when capacity is exhausted.
- A map supports expected fast lookup/update but does not promise iteration order.
- `container/list` provides a doubly linked list.
- `container/heap` expects a type implementing `heap.Interface` (`Len`, `Less`, `Swap`, `Push`, `Pop`). Your `Less` method determines whether the root behaves as a minimum or maximum.

An **invariant** is a statement that remains true at every step. For BFS, one useful invariant is: all vertices in the queue have been discovered, and each queued vertex is awaiting its first expansion.

## Step-by-step operation: BFS queue and heap

A simple BFS queue can use a slice plus a head index:

```go
q := []int{start}
for head := 0; head < len(q); head++ {
	u := q[head]
	for _, v := range graph[u] {
		if !visited[v] {
			visited[v] = true // mark before enqueueing
			q = append(q, v)
		}
	}
}
```

For a heap, implement the five `heap.Interface` methods and call `heap.Init`, `heap.Push`, and `heap.Pop`; do not directly append/pop the underlying slice after heap initialization because that can break the invariant. For a long-lived queue, consider periodically compacting consumed elements or using a ring buffer. If queued values contain pointers, clear consumed slots when appropriate so the backing array does not keep otherwise-dead objects reachable.

## Worked trace

For an undirected graph with edges `A—B`, `A—C`, `B—D`, `C—D`, begin at `A` and process neighbors in the listed order.

| Step | Head | Removed | Queue | Newly discovered |
|---|---:|---|---|---|
| 0 | 0 | — | `[A]` | `A` |
| 1 | 0 | `A` | `[A,B,C]` | `B,C` |
| 2 | 1 | `B` | `[A,B,C,D]` | `D` |
| 3 | 2 | `C` | `[A,B,C,D]` | none; `D` was already marked |
| 4 | 3 | `D` | `[A,B,C,D]` | none |

The visitation order is `A,B,C,D`; their BFS distances are `0,1,1,2`. A head-index queue avoids shifting every remaining element as `pop(0)`-style removal would. For every exercise, record the step, indices/pointers, active region, state change, and reason; that makes in-place and divide-and-conquer traces easier to audit.

## Why the approach is correct

In the trace, marking a neighbor visited before appending it ensures it is enqueued once, even if multiple vertices point to it. FIFO order processes all vertices at distance `d` before any at distance `d+1`. Therefore the first time a vertex is discovered, its assigned distance is minimal.

Slices are descriptors, not owned arrays: copying a slice copies its descriptor, not the elements. Changes through one alias can be visible through another while both refer to the same backing array; append may break that sharing if it has to allocate. A nil map can be read and has length zero, but assigning a key to it panics; initialize it with `make` or a map literal.

A proof normally shows **initialization**, **maintenance**, and **termination**: the invariant holds before the loop, every operation preserves it, and the stopping condition plus the invariant yields the result.

## Time and space analysis

Slice indexing is `O(1)`, append is amortized `O(1)`, and searching a slice is `O(n)`. Map operations are expected/average `O(1)` under ordinary hashing assumptions, not a worst-case guarantee. Heap push and pop are `O(log n)`; reading the root is `O(1)`. BFS takes `O(V+E)` time and `O(V)` additional queue/visited space for a graph with `V` vertices and `E` edges.

Define the input size and the case being analyzed. Include allocation/copy costs when capacity grows, and count only extra memory as auxiliary space. Escaping values, interface conversions, and garbage collection can affect measured runtime even when asymptotic bounds stay the same.

## Real-world use and choosing the right structure

Go is common in backend services and developer tools. Goroutines make concurrency convenient, but they do not automatically make an algorithm parallel or safe. Shared mutable maps need synchronization or a concurrency-safe design; parallel work also needs a suitable task size and a clear ownership/synchronization strategy. Choose the structure by expected operations, ordering requirements, input size, memory limits, worst-case latency, and concurrency needs.

## Common mistakes and edge cases

- Assuming append always reuses the old backing array, or that it always allocates a new one.
- Depending on map iteration order; it is unspecified.
- Reading and writing a shared map concurrently without synchronization.
- Implementing heap ordering backwards when a min-heap is required.
- Using repeated slice-front removal; it copies/shifts the remaining elements and can make a loop quadratic.
- Retaining pointers in the consumed prefix of a long-lived queue's backing array.
- Forgetting empty input, one element, duplicate values, absent keys, large capacity growth, and integer overflow in index/capacity calculations.

## Progressive exercises

1. Print a slice's `len` and `cap` before and after a sequence of appends; identify which slices can alias the same array.
2. Implement BFS with a head index. Add a cycle and verify each vertex is enqueued at most once.
3. Implement both a min-heap and max-heap by changing `Less`; test insertion, root access, and removal.

Write a simple correct version first, state its complexity, then add edge cases and hand-trace a small input. Compare the output with an independent expected result.

## Comprehensive quiz with explained answers

Try the questions before reading their explanations.

1. **What are the three key parts of a slice descriptor?** — A pointer to the backing array, its current length, and its capacity. Length limits valid indexing; capacity describes available room before append must allocate a new array.
2. **When can append stop sharing the old backing array?** — When the old slice lacks capacity for the appended elements and Go allocates a new backing array.
3. **Does a Go map guarantee iteration order?** — No. Code must not rely on the order.
4. **What are the usual heap push/pop costs?** — `O(log n)`, because an element may move along the heap's height.
5. **Can a built-in map be mutated concurrently without coordination?** — No. Protect shared writes (and concurrent read/write access) with synchronization, or use a design intended for concurrent use.

## Mastery checklist

Explain slice aliasing using pointer/length/capacity, trace a BFS with a head index, describe how `Less` sets heap priority, and state expected versus worst-case map costs. You are ready to move on when you can reason about the empty queue, cycles, append reallocation, and concurrent access without guessing.

## Further reading and references

- [The Go Specification: Slice types](https://go.dev/ref/spec#Slice_types) — formal slice and array semantics.
- [Go Slices: usage and internals](https://go.dev/blog/slices-intro) — official explanation of slices and backing arrays.
- [Maps in Go](https://go.dev/blog/maps) — official Go blog discussion of maps and common use.
- [`container/heap` package](https://pkg.go.dev/container/heap) — interface contract and priority-queue example.
- [The Go Memory Model](https://go.dev/ref/mem) — synchronization and visibility rules for concurrent programs.
- [Roadmap.sh: Data Structures and Algorithms](https://roadmap.sh/datastructures-and-algorithms) — source roadmap for this course.
