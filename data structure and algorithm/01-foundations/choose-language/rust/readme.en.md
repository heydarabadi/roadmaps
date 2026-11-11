# Practicing Data Structures and Algorithms with Rust

> Parent: [Choose a language](../readme.en.md) · [Chapter 1: Foundations](../../readme.en.md) · [فارسی](readme.md)

## Prerequisites and mental map

You should understand ownership, borrowing, `Vec`, `Option`, structs, traits, and basic iteration. Before coding an algorithm, ask who owns each value, which references are needed, and how long they must remain valid. Then trace a small input while tracking both the algorithmic state and the ownership/borrowing constraints.

## The idea from first principles

Rust uses ownership and borrowing, checked by the compiler, to prevent many invalid memory accesses. This changes how algorithms are expressed: moving a value transfers ownership; borrowing lets code access it temporarily; and a mutable borrow must be exclusive. The standard collection APIs are designed around these rules. A `Vec` is often simpler and faster in practice than a pointer-heavy linked structure; use more complex structures when their operations justify the additional ownership design.

## Model, contract, and invariant

- `Vec<T>` is a resizable contiguous array. Indexing is `O(1)`; `push` is amortized `O(1)`; insertion/removal in the middle shifts elements.
- `VecDeque<T>` is a growable ring buffer for efficient operations at both ends, so it is a good queue/deque.
- `HashMap<K,V>` and `HashSet<T>` provide expected fast hash-based access. Keys/elements need compatible `Eq` and `Hash` implementations.
- `BTreeMap`/`BTreeSet` keep elements ordered and support `O(log n)` operations.
- `BinaryHeap<T>` is a max-heap by default. `Reverse<T>` wraps an ordering to make a min-heap.
- A linked node can be modeled using `Option<Box<Node>>`, with ownership of the next node nested in the current one.

An **invariant** is a statement preserved by every step. In BFS, all vertices in the deque have been marked visited and are waiting to be expanded; each vertex is enqueued at most once.

## Step-by-step operation: BFS and Dijkstra

Use `VecDeque` for BFS:

```rust
use std::collections::{HashSet, VecDeque};

let mut queue = VecDeque::from([start]);
let mut visited = HashSet::from([start]);
while let Some(u) = queue.pop_front() {
    for &v in &graph[u] {
        if visited.insert(v) { // true only for a newly discovered vertex
            queue.push_back(v);
        }
    }
}
```

For Dijkstra, `BinaryHeap<Reverse<(u64, usize)>>` returns the lowest cost first. Compare the popped cost to the current `dist[node]` and skip stale entries. The tuple orders by cost and then node ID when costs tie. If a custom state type is used, implement `Ord` and `PartialOrd` consistently with `Eq` and `PartialEq`; ordering must not change while an item is inside a heap.

## Worked trace

For directed weighted edges `S→A (2)`, `S→B (5)`, `A→B (1)`, `A→C (4)`, `B→C (1)`, use `Reverse<(cost,node)>` in the heap.

| Step | Popped item | Relaxations | Heap entries (conceptually) |
|---|---|---|---|
| 1 | `(S,0)` | set `A=2`, `B=5` | `(2,A),(5,B)` |
| 2 | `(A,2)` | improve `B=3`; set `C=6` | `(3,B),(5,B),(6,C)` |
| 3 | `(B,3)` | improve `C=4` | `(4,C),(6,C),(5,B)` |
| 4 | `(C,4)` | no change | `(5,B),(6,C)` are stale |

The final distances are `0,2,3,4`. In actual Rust code, `Reverse` changes heap ordering, but does not reverse the data stored in the tuple. In a hand trace, list the popped state, each relaxation, and why an obsolete state is ignored.

## Why the approach is correct

For BFS, `visited.insert(v)` returns `true` only on the first insertion of `v`. This prevents duplicate queue entries. FIFO processing expands vertices in nondecreasing distance order, so the first discovery assigns the shortest unweighted distance.

Rust enforces that a reference cannot outlive its owner and that conflicting mutable/shared borrows are not used at the same time. For example, holding a reference into a `Vec` while pushing may require a reallocation, so the borrow checker rejects designs that could leave a dangling reference. The owner of a `Box` releases its allocation when dropped. If using `HashMap`, the key's `Eq`/`Hash` behavior must remain stable while it is stored; interior mutability that changes a key's hash/equality is a logic error.

A proof should cover **initialization**, **maintenance**, and **termination**: establish the invariant before the loop, show that each operation preserves it, and use the stopping condition plus the invariant to conclude the result.

## Time and space analysis

`Vec` indexing is `O(1)`, `push` amortized `O(1)`, and insertion/removal away from the end `O(n)`. `VecDeque` pushes/pops at either end are amortized `O(1)`. Hash-map/set operations are expected `O(1)` but can have worse cases; `BTreeMap` operations are `O(log n)`; heap push/pop are `O(log n)` and root inspection is `O(1)`. Cloning a collection or a non-`Copy` value may be linear in the cloned data, so account for every `.clone()` and allocation.

For BFS, the algorithm uses `O(V+E)` time and `O(V)` auxiliary space with adjacency lists. Define whether the graph itself is included in the space total, and state assumptions behind expected hash costs. Allocation and cache locality can affect actual elapsed time without changing the asymptotic bound.

## Real-world use and choosing the right structure

Rust's collections are used in performance-sensitive services, tools, and systems programs where predictable memory behavior matters. `Vec` is often the right starting point because it is contiguous and easy to own. A linked list may help only for a specific operation mix such as constant-time splicing when nodes are already known; its pointer chasing and ownership complexity often outweigh theoretical advantages. Use profiling to confirm a structure choice for a real workload.

## Common mistakes and edge cases

- Cloning a large vector or string to satisfy ownership without noticing the hidden `O(n)` work.
- Trying to retain a reference into a vector while mutating/growing the vector; redesign the state, use indices, or structure ownership deliberately.
- Reaching immediately for `Rc<RefCell<_>>` to bypass a borrow conflict instead of reconsidering the ownership model.
- Forgetting that `BinaryHeap` is a max-heap unless wrapped with `Reverse` or given reversed ordering.
- Using ordering implementations that disagree with equality, or changing an item's order while it is inside a heap.
- Ignoring checked/unchecked integer overflow behavior and the architecture-dependent width of `usize`.
- Test empty input, one vertex, cycles, equal priorities, unreachable vertices, and large path totals.

## Progressive exercises

1. Implement BFS with `VecDeque` and `HashSet`; explain when `visited.insert` succeeds.
2. Use `BinaryHeap<Reverse<(u64, usize)>>` for a min-priority queue; compare its output with the default max-heap.
3. Define a linked node using `Option<Box<Node>>`. Draw ownership after each insertion and explain what happens when the head is dropped.
4. Add a `.clone()` to a small algorithm, then identify the amount of data it copies and whether a borrow or move would suffice.

For every task, state the data-structure invariant and complexity, test boundary cases, and hand-trace at least one small input.

## Comprehensive quiz with explained answers

Try each question before reading the explanation.

1. **What does `VecDeque` provide?** — A growable ring-buffer deque with efficient operations at the front and back; it is the standard-library choice for a FIFO queue.
2. **What does `BinaryHeap` return first by default?** — The greatest item according to its `Ord` implementation; it is a max-heap.
3. **How do you make a min-heap from `BinaryHeap`?** — Wrap values with `std::cmp::Reverse`, or implement a consistent reversed ordering for a custom state.
4. **What traits do `HashMap` keys require?** — `Eq` and `Hash`, with equality and hashing that agree.
5. **Why is `Vec` often preferred over a linked list?** — It provides contiguous storage, good cache locality, simpler ownership, and efficient indexing/appending. A linked list is useful only when its particular operations justify its overhead.

## Mastery checklist

Explain ownership for the structures you use; trace BFS and a min-heap by hand; justify `Reverse`; identify hidden clone costs; and state the `Eq`/`Hash` and ordering contracts. You are ready to continue when you can resolve a borrow issue by clarifying ownership rather than adding shared mutability automatically.

## Further reading and references

- [Rust standard-library collections](https://doc.rust-lang.org/std/collections/) — official collection overview, selection guidance, and operation costs.
- [`VecDeque` documentation](https://doc.rust-lang.org/std/collections/struct.VecDeque.html) — ring-buffer behavior and deque operations.
- [`BinaryHeap` documentation](https://doc.rust-lang.org/std/collections/struct.BinaryHeap.html) — max-heap contract and ordering invariant.
- [`HashMap` documentation](https://doc.rust-lang.org/std/collections/struct.HashMap.html) — key requirements, expected costs, and logic-error caveats.
- [The Rust Programming Language: Common Collections](https://doc.rust-lang.org/book/ch08-00-common-collections.html) — introductory guide to vectors, strings, and hash maps.
- [Roadmap.sh: Data Structures and Algorithms](https://roadmap.sh/datastructures-and-algorithms) — source roadmap for this course.
