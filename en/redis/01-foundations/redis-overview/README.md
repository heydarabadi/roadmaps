<div dir="ltr" align="left">

# What Is Redis?

> Level: beginner to intermediate · Time: 45–75 minutes
>
> Persian edition: [Redis چیست؟](../../../../fa/redis/01-foundations/redis-overview/README.md)

## Learning objectives

By the end of this lesson, you should be able to explain Redis's structured key-value model, its server/client architecture, atomic commands, the difference between RAM and durability, and when Redis is a poor fit.

## The lesson

Redis is an in-memory data server with a key-value model. A value can be a string, list, hash, set, sorted set, or a more specialized type. Commands perform meaningful operations on those structures, and individual commands are generally atomic. Calling Redis “only a cache” is misleading: it can serve as a cache, session store, counter, simple queue, or event channel. The right role depends on durability, ordering, message-delivery behavior, and failure tolerance.

Data is normally held in RAM. RDB and AOF make disk persistence optional. RAM has a capacity and cost; persistence does not replace an independent backup. Redis is not an automatic replacement for SQL: it does not provide general-purpose relational joins, constraints, and query semantics.

## Mental model: application, network, server, key, value

Imagine your application on one side and a Redis server on the other. The application commonly uses a client library; in this course, `redis-cli` fills that role. The client sends a command over a TCP connection using the Redis protocol. The server executes it in the selected logical database and returns a reply. Redis is therefore not merely a dictionary inside your application process. It is a separate service, so network round trips and connection management matter.

A key is a unique name for one value in a logical database. The value's type determines the commands that make sense: use `GET` for a string and `HGET`/`HSET` for a hash. A key has one type at a time. An incompatible command usually returns `WRONGTYPE`; Redis does not silently convert the value. That error often means the key model or command choice is wrong.

## What problems do the data types solve?

| Type | Mental picture | Useful operations | Example |
| --- | --- | --- | --- |
| String | One value or byte string | `GET`, `SET`, `INCR` | token, counter, small payload |
| List | Ordered sequence with two ends | `LPUSH`, `RPOP` | simple queue |
| Set | Unordered unique members | `SADD`, `SISMEMBER` | tags and membership |
| Hash | Record of fields and values | `HSET`, `HGET` | small profile |
| Sorted Set | Unique members ordered by score | `ZADD`, `ZRANGE` | ranking |

Other types include bitmaps, HyperLogLog, Streams, geospatial data, JSON, Time Series, and Vector Sets. They solve specialized problems and are taught in their own chapters. Choose a type based on the operations the application performs most often. If a program repeatedly reads an entire JSON string, changes one counter, and writes the whole value back, a better data model may exist.

## What does atomicity mean?

A Redis command is applied as one operation; another client does not run halfway through that command. This is why `INCR` is safer for a counter than a client-side read-modify-write sequence: the application reads with `GET`, adds one, then writes with `SET`. Two clients could read the same old value and lose one update.

That does not make an entire application workflow atomic. If a workflow reads inventory, checks a condition, creates an order, and charges a payment, separate `GET` and `SET` commands can interleave with other requests. `WATCH`/`MULTI`, scripts, or functions can help with part of the Redis-side operation; they do not replace domain transaction design in the primary database.

## In-memory does not mean durable

Redis keeps data in memory for fast access. “In RAM” does not tell you what happens after a shutdown. With persistence disabled, the in-memory dataset is lost when the process exits. RDB creates snapshots at selected times; AOF records changes and replays them at startup. Each option has its own data-loss window, write cost, file size, and restore duration.

Keep these three concepts separate:

1. **Replication:** copies changes to replicas for availability or reads; it is usually asynchronous.
2. **Persistence:** writes state to disk for later loading.
3. **Backup:** a recoverable copy in a separate destination, with restore testing.

A replica or persistence file alone does not prove that you can recover from accidental deletion, disk loss, or a destructive change. For important state, define the source of truth, RPO, RTO, and recovery procedure before deployment.

## Walkthrough: basic commands

Run each command in the local lab from lesson zero:

```text
SET user:42:name "Sara"
GET user:42:name
TYPE user:42:name
HSET user:42 profile "premium" city "Tehran"
HGETALL user:42
TYPE user:42
```

Expected behavior:

1. `SET` creates or replaces a string key and normally replies `OK`.
2. `GET` returns that string.
3. `TYPE` reports `string` for the first key.
4. `HSET` writes two hash fields; for a new key, the integer reply is the number of fields created.
5. `HGETALL` returns the record's field/value pairs.
6. `TYPE` reports `hash` for the second key.

The two keys are named differently so you do not confuse a hash field with a separate string key. A command such as `HGET` on the string key returns a type error. If you run `SET` on an existing key, it replaces that key's previous value; two identical key names are not separate namespaces.

## Where Redis may be the wrong choice

- For durable relational constraints, complex joins, and analytical reporting, SQL is often a better primary store.
- If an offline consumer must not miss a message, basic Pub/Sub is insufficient; evaluate Streams or a suitable broker.
- If data cannot be rebuilt from another source, it is no longer a disposable cache; durability and backups matter.
- If the dataset exceeds available RAM, evaluate cost, eviction, and tiering before choosing Redis.

## Pre-use checklist

Before adding Redis to a service, answer these questions: What data will be stored? What is the source of truth? What are the peak size and read/write rates? How much staleness is acceptable? What happens if Redis is unreachable? How will keys expire or be removed? Who operates ACLs and backups? Which metric will show that the design is working?

## Example and experiment

```text
SET user:42:name "Sara"
GET user:42:name
HSET user:42 profile "premium" city "Tehran"
HGETALL user:42
```

Predict each reply before running the command. Then explain the difference between the string key and the hash key.

## Published real-world example

Redis published a North American retail customer story describing Redis for caching and event-driven inventory messaging. The vendor report says inventory-update latency fell from about 30 minutes to about 30 seconds. Treat this as a vendor-published case, not a promise for another workload. It illustrates Redis acting as a speed layer beside a primary database.

- [North American retail customer story](https://redis.io/customers/retail-na/)

## Common mistakes

- Assuming in-memory data is automatically durable.
- Making Redis the source of truth without a clear RPO, RTO, and recovery plan.
- Assuming every Redis data type has the same behavior.

## Practice

1. Run the example in local Redis and explain the replies.
2. Write two failure modes or edge cases for this design.
3. For a workload of your choice, estimate data size, read/write rate, TTL/retention, and behavior during an outage.
4. Choose one measure: p95 latency, hit rate, RAM, replication lag, pending count, or restore time.

## Quiz

### 1. Is Redis only a cache?

<details><summary>Answer</summary>

No. It has native data structures and optional persistence, and can serve several roles.

</details>

### 2. Why use a native data type instead of a plain string?

<details><summary>Answer</summary>

The native type can provide semantic, atomic operations that match the problem.

</details>

### 3. If persistence is disabled, does the dataset survive a restart?

<details><summary>Answer</summary>

No. The in-memory dataset does not survive a process restart without a persistence or rebuild path.

</details>

## Further reading

### English and official references

- [Redis roadmap PDF](https://roadmap.sh/pdfs/roadmaps/redis.pdf)
- [About Redis](https://redis.io/about/)
- [Redis data types](https://redis.io/docs/latest/develop/data-types/)
- [Compare Redis data types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Redis persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/)
- [Redis security overview](https://redis.io/docs/latest/operate/oss_and_stack/management/security/)
- [North American retail customer story](https://redis.io/customers/retail-na/)

### Persian references

- [DNTips Redis overview (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [Introductory Persian Redis article](https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh)
- [Persian video on strings and atomic increments](https://www.youtube.com/watch?v=e5Q_RUwviaE)
- [Persian Redis guide from SalamLang](https://www.salamlang.ir/std/db/redis/)

The linked resources supplement this lesson. For specialized features, consult documentation for the exact Redis version and service you run. Persian coverage is uneven; the course identifies the gaps instead of treating a search page as a finished article.

</div>
