# Chapter 3 — Searching and Sorting

> [Persian chapter](readme.md) · [Course index](../readme.en.md)

Respect each algorithm’s preconditions. Compare not only comparisons but also data movement, memory, stability, and worst-case behavior.

## Algorithm selection table

| Method | Preconditions / useful case | Time | Space or property |
|---|---|---:|---|
| Linear search | Any sequence; small input or few queries | O(n) worst | O(1), no ordering needed |
| Binary search | Sorted random-access data | O(log n) | O(1) iterative; can find boundaries |
| Insertion sort | Small or nearly sorted input | Best O(n), worst O(n²) | In-place and stable |
| Merge sort | Stable order, guaranteed bound, external data | Θ(n log n) | Θ(n) buffer in array version |
| Quicksort | In-memory sort with strong average performance | Average O(n log n), worst O(n²) | Usually in-place, not stable |
| Heapsort | Guaranteed worst-case bound and little extra space | Θ(n log n) | O(1) auxiliary, not stable |
| Bubble/selection sort | Mainly teaching or a narrow write-cost constraint | Θ(n²) | Simple, but limited at scale |

## Choosing in practice

If an unsorted sequence needs one search, sorting first may cost more than scanning. If the data is mostly static and many queries follow, sorting once and using binary search can pay off. Stability matters when records share a sort key and their original order must remain. If memory is constrained, include auxiliary space; if a worst-case guarantee matters, do not rely on average quicksort behavior without a protective hybrid implementation.

## Roadmap parent lesson: Sorting Algorithms

Sorting orders items under a comparator. The roadmap includes bubble, insertion, selection, merge, quick, and heap sort. Choose based on stability, auxiliary memory, worst-case requirements, input size, and existing order. Standard library sorts are usually the right production default unless a special constraint requires otherwise.

**Self-check**

1. What does stability mean? Equal-key items preserve their original relative order.
2. Which familiar sort has a guaranteed O(n log n) worst case and constant auxiliary array space? Heapsort.
3. Why can a benchmark on one tiny input be misleading? Inputs and implementations affect observed constants and pivot behavior.

## Roadmap parent lesson: Search Algorithms

Linear search scans without requiring sorted data. Binary search repeatedly removes half of a sorted range and can locate insertion boundaries as well as exact matches. If the data is small or unsorted and only one query is needed, a scan may beat sorting and indexing it first.

**Self-check**

1. What lets binary search discard half the range? Sorted order under the comparison being used.
2. What is linear search’s worst-case cost? O(n).
3. What must you include when comparing sort-then-search with a scan? Number of queries and the one-time sorting/indexing cost.

## Chapter review quiz

1. **What precondition does binary search have?** The sequence must be sorted using the same comparison relation.
2. **How do you find the first occurrence among duplicates?** Use a lower-bound search, then check equality.
3. **Which simple sort is useful on nearly sorted input?** Insertion sort.
4. **How do merge sort and heapsort trade space and stability?** Merge sort is commonly stable but uses O(n) buffer; heapsort uses O(1) auxiliary space and is not stable.
5. **Is quicksort always worst-case O(n log n)?** No. Repeatedly poor partitions can produce O(n²).
6. **What should a sort return for an empty input?** The empty sequence, with base cases that do not read an invalid index.

## Further reading and references

- [Princeton Algorithms — Elementary Sorts](https://algs4.cs.princeton.edu/21elementary/)
- [Princeton Algorithms — Mergesort](https://algs4.cs.princeton.edu/22mergesort/)
- [Princeton Algorithms — Quicksort](https://algs4.cs.princeton.edu/23quicksort/)
- [Princeton Algorithms — Priority Queues and Heaps](https://algs4.cs.princeton.edu/24pq/)
- [CP-Algorithms — Binary Search](https://cp-algorithms.com/num_methods/binary_search.html)
- [MIT 6.006 course materials](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/)
- [Full bibliography](../references.en.md)

## Topic lessons

- [Linear Search](linear-search/readme.en.md)
- [Binary Search](binary-search/readme.en.md)
- [Bubble Sort](bubble-sort/readme.en.md)
- [Insertion Sort](insertion-sort/readme.en.md)
- [Selection Sort](selection-sort/readme.en.md)
- [Merge Sort](merge-sort/readme.en.md)
- [Quicksort](quick-sort/readme.en.md)
- [Heapsort](heap-sort/readme.en.md)

## Mastery standard

Manually sort a list containing duplicates, use original IDs to verify stability, and explain each algorithm’s best/average/worst time and auxiliary memory. Be able to state when its preconditions hold and when a library implementation is a better choice.
