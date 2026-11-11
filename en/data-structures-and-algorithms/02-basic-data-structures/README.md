# Chapter 2 — Basic Data Structures

> [Persian chapter](../../../fa/data-structures-and-algorithms/02-basic-data-structures/README.md) · [Course index](../README.md)

Choose a representation based on the operations the workload performs most often. A familiar data structure is not automatically the right one; access pattern, mutation rate, ordering, memory, and failure behavior all matter.

## Choose by workload

| Frequent need | Common choice | Cost to remember |
|---|---|---|
| Indexed access and compact traversal | Dynamic array | Index O(1); middle insert/delete O(n) |
| Insert/delete after a known node | Linked list | Finding the node may still take O(n) |
| Last-in, first-out | Stack | Push/pop at the top |
| First-in, first-out | Queue/deque | Avoid shifting the whole array for each dequeue |
| Lookup by key | Hash table | Average/expected O(1), worst case may be O(n) |

## Worked design: an LRU cache

Suppose a cache has a fixed capacity and must find values by key while evicting the least recently used item. A hash map finds the node by key in expected O(1). A doubly linked list stores recency order: move a used node to the front, and evict the tail. This combines structures because one representation does not efficiently support both operations. The map and list must agree: every map entry points to exactly one live list node.

## Roadmap parent lesson: Basic Data Structures

The roadmap group contains arrays, linked lists, queues, stacks, and hash tables. First list the dominant operations: indexed access, insertion at a known position, FIFO/LIFO behavior, or key lookup. Compare their costs and memory layout. A common mistake is choosing a structure by its name while ignoring ordering, resizing, collisions, or deletion.

**Parent-branch self-check**

1. Which structure provides indexed access? An array.
2. Which structure models FIFO? A queue, with efficient operations at both ends.
3. What assumption usually accompanies O(1) hash lookup? It is an average/expected bound; collisions can worsen the worst case.

## Chapter review quiz

1. **Why is indexed access faster in an array than a linked list?** The address is computed directly; a linked list must follow links.
2. **When is linked-list insertion truly O(1)?** When the location or predecessor node is already known.
3. **What is the difference between a stack and a queue?** LIFO versus FIFO order.
4. **Why is `list.pop(0)` a poor BFS queue operation?** It may shift all remaining elements on each dequeue.
5. **Does a hash collision mean two keys are equal?** No; equality must still be checked.
6. **What makes an LRU cache efficient?** A hash map locates a node and a doubly linked list updates or removes it in constant pointer operations.

## Further reading and references

- [Python Tutorial — Data Structures](https://docs.python.org/3/tutorial/datastructures.html)
- [Princeton Algorithms — Stacks and Queues](https://algs4.cs.princeton.edu/13stacks/)
- [C++ standard library containers](https://en.cppreference.com/w/cpp/container.html)
- [Java Collections Framework API](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/package-summary.html)
- [Ferdowsi University — Data Structures](https://cs-um.github.io/docs/mandatory/Data-Structures/)
- [Full bibliography](../references.md)

## Topic lessons

- [Arrays and Dynamic Arrays](array/README.md)
- [Linked Lists](linked-list/README.md)
- [Queues and Circular Buffers](queue/README.md)
- [Stacks](stack/README.md)
- [Hash Tables](hash-table/README.md)

## Mastery standard

For an application you know, list its five most common operations, estimate data size and read/write ratio, and compare two possible structures. Explain both the operations each structure optimizes and the operations it makes expensive. Check the actual collection API in your language rather than inferring cost from a method’s name.
