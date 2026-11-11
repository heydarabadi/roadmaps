<div dir="ltr" align="left">

# Chapter 4 — Advanced Features and Their Guarantees

> Persian edition: [فصل ۴ — قابلیت‌های پیشرفته](../../../fa/redis/04-advanced-features/README.md) · Suggested time: 5–7 hours.

This chapter covers approximate membership, message processing, geospatial queries, and atomic multi-step updates. Write down the guarantee of each primitive before using it.

## Lesson order

1. [HyperLogLog](hyperloglog/README.md): approximate distinct counts with low memory.
2. [Streams and consumer groups](streams/README.md): event log, pending entries, acknowledgement, claiming, and retry.
3. [Geospatial](geospatial/README.md): locations, radius searches, and freshness/geometry limits.
4. [Transactions and WATCH](transactions-watch/README.md): command groups, optimistic concurrency, and the absence of general rollback.
5. [Lua scripting and Functions](lua-scripting/README.md): short server-side atomic logic, KEYS/ARGV, and script limits.
6. [Pub/Sub](pubsub/README.md): transient live messages that disconnected subscribers miss.

## The important decision: live notification or recoverable data?

| Need | Primitive to evaluate | Main guarantee or limitation |
| --- | --- | --- |
| Live notification to connected subscribers | Pub/Sub | No message history or per-consumer acknowledgement; refresh state after reconnect. |
| Retained events shared among consumers | Streams | Entries remain until deleted/trimmed; consumer groups track pending/ack, while retention, durability, and duplicate handling remain design responsibilities. |
| Approximate unique count | HyperLogLog | Approximate; members cannot be listed. |
| Search near a coordinate | Geo commands | Requires fresh locations; not a full GIS engine. |
| Conditional changes to Redis keys | WATCH/MULTI or Lua | Atomic execution does not mean SQL-style rollback or a transaction with another system. |

## Design exercise

For an imaginary order payment, separate “payment succeeded,” “order shipped,” and “update the live dashboard.” Which events need replay? Which updates need idempotency? Use Pub/Sub for a live UI hint if appropriate, but retain important source events in a Stream, broker, or durable store. For a conditional update, picture two workers racing and evaluate WATCH/MULTI or a short script.

## Comprehension check

1. Why is Pub/Sub alone unsuitable when a consumer may be offline?
2. Does `EXEC` roll back an entire group when one command fails at execution time?
3. Why do consumer groups still require idempotency and pending-entry handling?
4. Which operations fit HyperLogLog, and which do not?

<details><summary>Answer guide</summary>

Pub/Sub has no history, so a disconnected subscriber misses messages. A Redis transaction runs queued commands without interleaving but does not provide general SQL rollback for every runtime command error. A Stream message may be processed again and pending messages need acknowledgement/reclaim/retry, so side effects should be idempotent. HyperLogLog fits approximate distinct counts, not member lists or exact set differences.

</details>

## Further reading

- [Compare Redis data types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Redis transactions](https://redis.io/docs/latest/develop/using-commands/transactions/)
- [Redis Streams](https://redis.io/docs/latest/develop/data-types/streams/)
- [Redis Pub/Sub](https://redis.io/docs/latest/develop/pubsub/)
- [Redis probabilistic data structures](https://redis.io/docs/latest/develop/data-types/probabilistic/)
- [Redis Geo commands tutorial](https://redis.io/tutorials/howtos/solutions/geo/getting-started/)
- [Persian Redis overview from DNTips (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

</div>
