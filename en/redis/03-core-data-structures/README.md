<div dir="ltr" align="left">

# Chapter 3 — Core Data Structures

> Persian edition: [فصل ۳ — ساختارهای دادهٔ اصلی](../../../fa/redis/03-core-data-structures/README.md) · Suggested time: 4–6 hours. Run each lesson in Redis.

The key skill in this chapter is choosing a structure from the operations and queries the application needs.

## Lesson map

1. [Strings, counters, and bitmaps](strings-bitmaps/README.md): simple values, atomic numeric operations, bits, and size limits.
2. [Lists and simple queues](lists-queues/README.md): push/pop at both ends, blocking, ordering, races, and the difference between a simple list and a durable queue.
3. [Sets](sets/README.md): exact membership, union/intersection/difference, and Set versus probabilistic filters.
4. [Hashes](hashes/README.md): flat records, field updates, and key contracts.
5. [Sorted Sets](sorted-sets/README.md): score, rank, leaderboards, and range queries.

## How to choose a type

Before choosing, list the operations: Do you look up by field name? Must members be unique? Is score ordering required? Do producers and consumers push/pop? Is an atomic counter enough? Then choose a type. A name alone is not sufficient: a “list of jobs” may need a Sorted Set ordered by next-run time rather than a basic List.

| Application question | First type to evaluate |
| --- | --- |
| A small text/JSON value or counter | String |
| A compact boolean bitset | Bitmap over a String |
| Exact unique membership | Set |
| Fields in a flat record | Hash |
| Simple push/pop queue | List; evaluate Streams or a broker for stronger delivery needs |
| Ranking and score ranges | Sorted Set |

This table is only a starting point. For each type, study complexity, memory encoding, atomic commands, persistence, and behavior under load. `O(1)` does not mean end-to-end latency is constant; network, serialization, payload size, and contention still matter.

## Shared lab: model an order

Use the `lab:` prefix and avoid destructive commands on other data:

```text
SET lab:order:42:status created
HSET lab:order:42 customer_id 7 total 125000 status created
SADD lab:order:42:tags fragile express
ZADD lab:orders:by-time 1794384000 42
LPUSH lab:orders:work 42
```

This example intentionally demonstrates several types; a real product should not duplicate every field without a reason. For each access pattern, identify the authoritative state and explain how derived indexes are updated or rebuilt. `LPUSH` alone is not a reliable retry/ack queue; continue with [Streams](../04-advanced-features/streams/README.en.md) and the order project.

## Diagnostic exercise

Choose a type and reject one alternative with a reason:

1. A page cache value with a TTL.
2. A count of visits per user for one week.
3. A set of unique product tags.
4. The top 100 leaderboard scores.
5. Jobs that must remain visible until they are retried/acknowledged.

<details><summary>Answer guide</summary>

A String with `SET ... EX` is a simple cache; a String counter with `INCR` and an expiry may fit a counter, but the time-window boundary must be designed; a Set models unique tags; a Sorted Set models score ranking; Streams/consumer groups or a broker support pending/ack/retry better than a raw List. Another answer can be valid if the workload differs and the trade-offs are explained.

</details>

## Chapter exit criteria

- Name two useful commands and one limitation for each core type.
- Translate an application operation into a Redis query and suitable type.
- Distinguish a key's String value, a Hash field, and a Set member.
- Explain how a derived index stays consistent or can be rebuilt.
- Never test global or destructive commands against a real database.

## Further reading

- [Compare Redis data types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Redis data types](https://redis.io/docs/latest/develop/data-types/)
- [Redis data-structure commands](https://redis.io/docs/latest/commands/)
- [DNTips data-structure overview in Persian (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [SalamLang Redis guide in Persian](https://www.salamlang.ir/std/db/redis/)

</div>
