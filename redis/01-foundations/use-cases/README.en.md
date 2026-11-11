<div dir="ltr" align="left">

# Redis Use Cases and Patterns

> Level: beginner to intermediate · Time: 45–75 minutes
>
> Persian edition: [کاربردها و انتخاب الگو](./README.md)

## Learning objectives

Choose a suitable Redis pattern for caching, sessions, counters, leaderboards, and messaging. For each one, define freshness, data loss, and outage behavior.

## The lesson

Common patterns include cache-aside to reduce database reads, shared sessions across application instances, atomic counters with `INCR`, leaderboards with Sorted Sets, membership with Sets, queues/events with Lists or Streams, and live notifications with Pub/Sub. If an offline consumer must read a message later, prefer Streams over Pub/Sub: Pub/Sub does not retain messages.

For a cache, define a TTL and a cache-miss path. For important state, align Redis with the source of truth and a recovery process. If the workload needs relational constraints or complex analytics, keep a database that supports those needs.

## Cache-aside, step by step

Assume a product page is read from PostgreSQL and repeated reads are expensive. With cache-aside, the application checks Redis first:

1. The application runs `GET shop:product:42`.
2. If the value exists, return it. This is a cache hit.
3. If it does not, read from the primary database. This is a cache miss.
4. Write the result to Redis with a TTL, then return it.
5. When the price changes, commit to the primary database and invalidate the cache so the next request reloads the current value.

The last steps can be illustrated with these commands:

```text
SET cache:product:42 "{\"id\":42,\"price\":129000}" EX 300
GET cache:product:42
TTL cache:product:42
DEL cache:product:42
```

Redis normally replies `OK` to `SET`; `GET` returns the document, `TTL` returns the remaining seconds, and `DEL` returns the number of keys removed. This example stores JSON text inside a Redis String. That is not the native JSON data type: `GET` returns the whole string. The JSON lesson explains the difference.

In cache-aside, the database remains authoritative. Define what happens if Redis is unavailable: do all requests fall back to SQL? Should some requests fail? If millions of misses reach SQL at once, the fallback can create a second outage. Common stampede controls include randomized TTLs, stale-while-revalidate, or a short expiring lock. Do not copy a distributed lock without understanding expiry, ownership, and failover.

## Match five use cases to real requirements

### 1. Session

Several application instances can share a session stored under a key such as `session:{opaque-id}` with a TTL. Remove it on logout or session expiry. Use an unguessable identifier; do not put raw passwords, tokens, or sensitive data in key names without a reason. What does losing a session mean? If the user can simply sign in again, it may be tolerable. If a session contains critical state, evaluate persistence and backups.

### 2. Counter and rate limiter

`INCR` is suitable for an atomic counter. A fixed-window rate limiter also needs correct expiry. Redis 8.8 introduced `INCREX`, which combines increment, a bound, and expiry in one atomic command:

```text
INCREX rate:user:42 BYINT 1 UBOUND 5 EX 60 ENX
```

The reply contains the new value and the applied delta. When the limit has been reached, the delta is zero so the application can reject the request. `EX 60` sets a 60-second window; `ENX` means not to restart the TTL if one already exists. This command requires Redis 8.8.0; use a compatible Lua pattern or another supported method on older releases. This is a fixed-window example; sliding-window behavior is different.

### 3. Leaderboard

A Sorted Set orders unique members by score. Equal scores may be ordered lexicographically by member; if the product requires a different tie-break rule, define it explicitly. The Sorted Set lesson builds a game example.

### 4. Membership and analytics

A Set works for a question such as “Is this user in the campaign?” HyperLogLog can reduce memory when an approximate unique count is sufficient, but it cannot return the member list. Do not use an approximate statistic for billing or reconciliation.

### 5. Messaging

Pub/Sub provides immediate notifications to connected subscribers and does not retain messages. Streams retain entries and support consumer-group acknowledgement and pending tracking. A List used as a basic queue does not automatically provide full recovery and replay. Start the design with this question: “If a worker is offline, must it receive the message later?”

## When not to choose Redis

- Do not use a cache to hide a poor query or schema in the primary store.
- If current latency is acceptable and the database has enough capacity, Redis adds operating cost and failure modes without clear benefit.
- If data cannot be rebuilt and has no defined RPO, design durability and backups first.
- For joins, constraints, and multidimensional reporting, use a database suited to those queries.

## Product-cache design: sample answer

For a frequently viewed product page, a reasonable starting design is:

- **Source of truth:** PostgreSQL.
- **Cache key:** `shop:product:{id}:summary:v1`.
- **Initial TTL:** for example, five minutes with jitter; the freshness requirement determines the final value.
- **Miss:** read PostgreSQL, then populate the cache.
- **Price change:** commit in the database, then invalidate with a retryable outbox/event. If invalidation fails, the TTL limits the maximum stale period.
- **Redis outage:** controlled fallback, a concurrency limit on database reads, and an error metric.
- **Metrics:** hit ratio, p95 latency, misses, Redis errors, and fallback rate to the database.

This is a teaching design, not a universal best practice. If even a few seconds of stale price are unacceptable, checkout should read the authoritative source. A cached display value must not make the final payment decision.

## Example and experiment

For each requirement, write a type, TTL, and outage behavior: requests per user per minute; the top ten game scores; and an order event processed by several workers.

## Published real-world example

An AWS case study describes DBS Bank using ElastiCache for Redis for caching and near-real-time pricing calculations. The report claims a 100-fold improvement in pricing-query response time. Treat that figure as a claim from the published case, not a guarantee for another workload.

- [DBS Bank case study](https://aws.amazon.com/solutions/case-studies/dbs-bank-case-study/)

## Common mistakes

Do not add Redis without measurement. Design invalidation, stampede protection, RAM capacity, and database fallback first.

## Practice

1. Run the example in local Redis and explain the replies.
2. Write two failure modes or edge cases for the pattern.
3. Estimate workload size, read/write rate, TTL/retention, and outage behavior.
4. Pick a metric: p95 latency, hit rate, RAM, replication lag, pending count, or restore time.

## Quiz

### 1. Which option provides immediate fan-out when a message may be lost?

<details><summary>Answer</summary>

Pub/Sub.

</details>

### 2. Which type is a starting point for top-N scores?

<details><summary>Answer</summary>

A Sorted Set.

</details>

### 3. Does using Redis automatically make it the source of truth?

<details><summary>Answer</summary>

No. The role, durability, and recovery path must be explicit.

</details>

## Further reading

### English and official references

- [Redis use patterns](https://redis.io/docs/latest/develop/use/patterns/)
- [Compare Redis data types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Redis rate-limiter use case](https://redis.io/docs/latest/develop/use-cases/rate-limiter/)
- [Cache-aside pattern — Microsoft Azure Architecture Center](https://learn.microsoft.com/azure/architecture/patterns/cache-aside)
- [DBS Bank case study — AWS](https://aws.amazon.com/solutions/case-studies/dbs-bank-case-study/)
- [Redis caching patterns](https://redis.io/docs/latest/develop/use/patterns/)

### Persian references

- [Persian overview of Redis use cases](https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh)
- [DNTips overview of Redis data structures (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [SalamLang Redis guide in Persian](https://www.salamlang.ir/std/db/redis/)

For specialized features, check documentation for the exact Redis version and service you use. Persian coverage varies; the lesson teaches the core concepts and labels supplementary references honestly.

</div>
