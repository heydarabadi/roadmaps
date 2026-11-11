<div dir="ltr" align="left">

# Redis Quick Reference

> Persian edition: [برگهٔ مرور سریع Redis](../../fa/redis/QUICK-REFERENCE.md)

Use this sheet to recall commands after studying the lessons. Run examples in the isolated local lab, not against a production database.

## Connect and inspect

~~~text
PING
INFO server
INFO memory
INFO replication
~~~

## Keys and expiration

~~~text
SET cache:item:42 "value" EX 300
GET cache:item:42
TTL cache:item:42
TYPE cache:item:42
EXISTS cache:item:42
DEL cache:item:42
SCAN 0 MATCH cache:* COUNT 100
~~~

TTL returns -2 when the key does not exist and -1 when it exists without an expiry. Avoid KEYS * on a large keyspace; use incremental SCAN and understand its cursor semantics.

## Core structures

~~~text
SET counter 0
INCR counter

LPUSH queue "task-1"
RPOP queue

SADD user:42:tags redis database
SISMEMBER user:42:tags redis

HSET user:42 name Sara plan free
HGET user:42 name
HINCRBY user:42 login_count 1

ZADD leaderboard 900 user:42
ZREVRANGE leaderboard 0 9 WITHSCORES
~~~

## Pub/Sub and Streams

~~~text
SUBSCRIBE notifications
PUBLISH notifications "hello"

XADD events * type order-created order_id 42
XRANGE events - +
~~~

Pub/Sub does not retain messages for disconnected subscribers. Streams can support replay and consumer groups; also design retention, pending-message recovery, idempotency, and acknowledgement timing.

## Persistence and diagnosis

~~~text
BGSAVE
INFO persistence
SLOWLOG GET 10
LATENCY DOCTOR
~~~

RDB creates snapshots; AOF records write commands. Read the persistence and backup/restore lessons before changing configuration or recovering a live dataset.

## Commands requiring care

~~~text
FLUSHDB
FLUSHALL
CONFIG SET
MONITOR
~~~

These can delete data, change server behavior, or create significant overhead. Do not run them on a real service just because they appear in a quick reference.

## A starting point for choosing a data type

| Main need | Common candidate |
| --- | --- |
| Scalar value or counter | String |
| Compact flag set with known indexes | Bitmap |
| Ordered sequence and operations at both ends | List |
| Uniqueness and membership | Set |
| Fields in one flat record | Hash |
| Ranking by score | Sorted Set |
| Approximate distinct count | HyperLogLog |
| Stored events, replay, or worker groups | Streams |
| Live broadcast to connected subscribers | Pub/Sub |
| Nested document and path operations | JSON |
| Timestamped measurements | Time Series |
| Approximate membership/frequency/quantile | Probabilistic structures |
| Similarity search over embeddings | Vector Set or Query Engine |
| Sparse integer-indexed values / bounded ring | Array |

This table is only a starting point. Decide from access patterns, data size, retention, correctness, failure behavior, service support, and a representative benchmark.

</div>


