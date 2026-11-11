# 6.3 — Algorithms and Data Structures

**Language:** English | [فارسی](../../../../fa/backend-performance/06-code-optimization/03-algorithms-and-data-structures/README.md)

An algorithm determines what work is done and how many times; the data structure shapes the cost of access, updates, and storage. Optimization at this layer often removes repeated work, but first confirm with a [profile](../02-application-profiling/README.md) that this work matters under the target load.

**Learning goal:** recognize cost growth with input size, choose between scanning, hashing, and ordering, account for construction and memory, and understand the limits of Big-O. Sources reviewed: **2026-11-10**.

## Prerequisites defined here

A collection holds multiple members. Here, n is the number of orders and m the number of customers; a lookup finds a member by key. Big-O describes how an operation count grows as input grows, not milliseconds or exact CPU cost. The worst case measures the most work for allowed inputs. A hash computes a code from a key to find a likely map location; collisions between keys can add work. A heap is a priority structure that gives quick access to a minimum or maximum member. A deque allows items to be added or removed at either end. These definitions help match a structure's cost to its operations.

## Mental model: growth, constants, and memory

<code>O(n)</code> describes a growth rate within a model, not elapsed time. Cache locality, key size, allocation, locks, and implementation details affect actual constants. Algorithm comparisons must preserve the same semantics: order, duplicate-key behavior, and equality for Persian/Unicode text must be clear.

| Need | Simple option | Alternative | Alternative's cost |
| --- | --- | --- | --- |
| One lookup in a small list | Linear scan | Hash map | Construction and memory may outweigh the gain |
| Repeated lookups by key | Scan for every request | Map/Set | More memory, collision and update handling |
| Smallest k values among n | Sort everything | Bounded heap of size k | More implementation complexity; final ordering may still be needed |
| Ordered traversal or range | Sorted list/tree | Hash map | Hash maps do not provide ordering or ranges directly |
| Remove from the front of a queue | Shift an array for each removal | Deque/ring buffer | Capacity and full-queue policy |

For a hash map, expected/average access may be close to constant, but worst-case collisions, resizing, and hashing the key still matter. For top-k using a bounded heap, maintenance is usually <code>O(n log k)</code> and auxiliary memory <code>O(k)</code>; sorting the final k members adds work if ordered output is required.

## Worked example: joining data in memory

**Instructional assumption:** we have 10,000 orders and 5,000 customers in memory. For each order, find the customer name; the key is unique and missing-customer behavior is defined.

~~~text
# Before: repeated scan
for order in orders:
    order.customer_name = find_by_id(customers, order.customer_id)

# After: build once, then lookup
by_id = map(customers, key = customer.id)
for order in orders:
    customer = by_id.get(order.customer_id)
    order.customer_name = customer.name if found else "unknown"
~~~

Repeated scans have about 50 million comparisons in the worst case: <code>n × m</code>. Building a map and looking up each key takes work proportional to <code>n + m</code> in a suitable expected hash model: about 15,000 operations here. This is **not a runtime ratio**. Map memory, hashing, and construction also cost something. With one order and five customers, a simple scan may be sufficient or faster.

Do not rebuild the map for every order; that repeats construction. If customers live in a database, consider a batched fetch or join and the [ORM fetch strategy](../../04-databases/03-orm-fetch-strategies/README.en.md) first. An in-memory map after thousands of network calls does not remove those earlier round trips. A global map also needs a freshness and concurrency contract.

## Exercise with worked solution

For <code>n = 100, 1000, 10000</code> and <code>m = n/2</code>, calculate worst-case scan comparisons. For a map, account for construction separately from lookup. Compare one lookup with looking up every order.

**Solution:** for one lookup, the scan limits are 50, 500, and 5,000 comparisons. For every order, <code>n × m</code> is 5,000, 500,000, and 50,000,000 comparisons. In the expected hash model, construction is about m operations and all lookups about n; totals for all orders are approximately 150, 1,500, and 15,000 operations. These counts are neither milliseconds nor a worst-case guarantee. When both collection sizes grow tenfold, the scan count grows one hundredfold while the construction-plus-lookup model grows about tenfold. For one lookup only, map construction can erase the benefit. In an implementation, also compare outputs, memory, duplicates, and build time; operation counts do not replace runtime measurements.

## Operational evidence and evidence gap

**Operational tool documentation:** [Redis Sorted Sets](https://redis.io/docs/latest/develop/data-types/sorted-sets/) documents a scored collection for leaderboards and the complexity of its operations. It is evidence that a ranking/range requirement informs data-structure choice, not a guarantee that every command has constant-time cost. No public production study directly comparable to this lesson's “scan customers versus map” example was identified; the operation reduction is instructional reasoning, not a company result.

## Fit, failures, and signals

Before adding algorithmic complexity, record actual input sizes and distributions. Better Big-O matters as input grows, while a complex structure for an always-small collection can hurt readability. Hashing trusted input and attacker-controlled input do not share the same security assumptions; use standard implementations and bound inputs.

| Failure | Signal | What to inspect |
| --- | --- | --- |
| Building the index in an outer loop | High allocation with unchanged CPU | Fix the structure's lifetime |
| Losing order or duplicates | Faster but incorrect output | Preserve equality and ordering contracts |
| Unbounded global map | Memory grows with new keys | Define lifetime, size, and eviction |
| Measuring only small inputs | Failure on large data | Include a range of sizes and skew |
| Optimizing outside the hot path | Latency barely changes | Check the path's profile/trace share |

### Operational checklist

- [ ] Typical and maximum allowed input sizes, lookup count, and skew are known.
- [ ] Construction, update, lookup, and release costs are accounted for separately.
- [ ] Order, duplicates, missing keys, and Unicode semantics are preserved.
- [ ] Memory, allocation, resizing, and concurrency are checked.
- [ ] Large/adversarial input and resource limits are considered.
- [ ] Cost reduction is verified with correct output under representative load.

## Quiz

1. Why does <code>O(1)</code> for a hash map not mean one nanosecond?
2. In the example, by how much does worst-case scanning grow when n and m each increase tenfold?
3. Why may a map not be better for one lookup over five elements?
4. When can top-k cost less than sorting all values?
5. If the previous ordering is lost, is the speed gain a success?
6. Why does building a map after N separate database requests not solve N round trips?

### Explained answers

1. Big-O describes growth. Hashing, collisions, memory, implementation constants, and worst-case behavior still have costs.
2. One hundred times: each factor in <code>n × m</code> grows tenfold.
3. Constructing and allocating the map may cost more than a short scan; the number of lookups matters.
4. When k is much smaller than n and only those values are needed; account for heap maintenance and final ordering too.
5. No, if order is part of the contract the result is wrong; correctness is part of the comparison.
6. Those requests have already happened. Change the fetch plan first, then optimize the in-memory join.

## Summary

Choose a structure based on the dominant operations and real input sizes, including construction and memory lifetime. Preserve ordering, duplicates, missing-key behavior, and Unicode equality. If the data is in a database, first address round trips and the fetch plan; a local map cannot remove them.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve the exercise; they provide additional reading and technical provenance.

- **Persian, course notes:** [Data Structures Lecture 22: Hash Tables](https://www.sauleh.ir/ds98/static_files/notes/Lecture22.pdf). Useful for hash and collision concepts, not a production benchmark.
- **English, official Oracle Java API:** [<code>HashMap</code>](https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html). Describes expected cost, capacity, load factor, and collisions for Java 8's implementation.
- **English, official Python docs:** [Collection types](https://docs.python.org/3/library/collections.html). Documents deque behavior and list movement costs; Python implementation details should not be generalized to all languages.
- **English, Redis documentation:** [Sorted Sets](https://redis.io/docs/latest/develop/data-types/sorted-sets/). Data-structure selection for ranking and operation costs in a real product.
- **English, Azure Well-Architected guidance:** [Optimize code and infrastructure](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure). Places algorithm changes within a measurement-led process.

**Navigation:** [Chapter 6](../README.en.md) · [Course index](../../README.en.md) · [Previous: Profiling](../02-application-profiling/README.en.md) · [Next: Critical Paths](../04-critical-paths/README.en.md)

**Related lessons:** [Batching](../08-batching-and-round-trips/README.en.md) · [ORM fetching](../../04-databases/03-orm-fetch-strategies/README.en.md) · [Performance testing](../../09-performance-testing/README.en.md)
