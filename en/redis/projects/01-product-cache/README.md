<div dir="ltr" align="left">

# Project 1 — Cache-Aside for a Product Catalog

> Level: beginner to intermediate · Time: 90–150 minutes · Environment: local Redis from lesson zero

> Persian edition: [پروژهٔ ۱ — Cache-aside برای کاتالوگ محصول](../../../../fa/redis/projects/01-product-cache/README.md)

## Problem and outcome

A store keeps product data in its primary database. Frequent reads are served from Redis to reduce latency and load on the database. Cached results may be briefly stale; deleting Redis must not destroy the authoritative product record.

By the end, explain cache miss, outage, expiration, invalidation, stampede, and stale-data behavior. The CLI exercise simulates the flow; a key such as lab:source:* is not a real database.

## Requirements and contract

- product_id identifies the record in the authoritative source.
- Keep a product response in cache for up to five minutes; add random TTL jitter in production.
- A price/status change must invalidate or version the cached key.
- If Redis is unavailable, critical product reads fall back to the database with bounded concurrency. A low-priority page might use a limited stale response if the business allows it.
- Measure cache hit/miss, database fallback, error rate, and latency.
- Redis is not the source of truth for checkout price; the final order validates price and availability against an authoritative service.

## Key and value design

| Key | Contents | Role |
| --- | --- | --- |
| lab:source:product:42 | JSON-like record, only for simulation | Fake source of truth |
| lab:cache:product:42 | Cached response | Short-lived Redis value |
| lab:lock:product:42 | Temporary token | Optional rebuild coordination |

In a real service, standardize prefixes and tenant boundaries. Add a schema version if different application releases may read the same cached payload.

## Step 1 — Create simulated source data

In redis-cli:

~~~text
DEL lab:source:product:42 lab:cache:product:42 lab:lock:product:42
SET lab:source:product:42 '{"id":42,"name":"keyboard","price":125000,"active":true,"schema":1}'
GET lab:source:product:42
~~~

The lab:source key only simulates a database. A real application reads the primary database; do not treat two Redis keys in the lab as independent production systems.

## Step 2 — Cache-aside on a miss

Application flow:

1. Read the cache key.
2. If a value exists, record a hit and return it.
3. Otherwise, record a miss.
4. Read the authoritative database.
5. Apply the not-found or negative-cache policy if no product exists.
6. Store the value with a TTL.
7. Return the response.

Simulate it:

~~~text
GET lab:cache:product:42
GET lab:source:product:42
SET lab:cache:product:42 '{"id":42,"name":"keyboard","price":125000,"active":true,"schema":1}' EX 300
TTL lab:cache:product:42
GET lab:cache:product:42
~~~

The first cache read should return nil. The application then reads the source and fills Redis. SET with EX 300 applies the value and TTL in one command, which reduces the chance of writing the value but forgetting its expiry.

## Step 3 — Observe hit, expiry, and miss

~~~text
GET lab:cache:product:42
PTTL lab:cache:product:42
SET lab:cache:short demo EX 3
TTL lab:cache:short
~~~

GET reads the cached value; PTTL reports remaining milliseconds. Use a three-second TTL in the lab to observe expiry quickly. Expiry is automatic lifetime management, not the same operation as manually deleting a key.

## Step 4 — Update and invalidation

A simple production sequence is: commit the database transaction, then invalidate the cache key. The next cache-aside request reads the new database value and fills Redis.

~~~text
SET lab:source:product:42 '{"id":42,"name":"keyboard","price":119000,"active":true,"schema":1}'
DEL lab:cache:product:42
GET lab:cache:product:42
~~~

The final GET should miss. The application then reads the database and fills a fresh cache entry.

### The stale-fill race

Request A can read the old value from the database before a commit, pause, then write that old value to Redis after request B has invalidated the cache. A’s stale fill can survive until TTL expiry. Simple invalidation does not make a database and Redis one transaction.

Possible mitigations include versioned keys, validating and retrying against a record version, an outbox/event-driven invalidation flow, short TTLs, or another design that fits the consistency requirement. Document the maximum allowed stale window.

## Step 5 — Negative caching and stampede

For an unknown product ID, every miss can burden the database. A short-lived “not found” value can help, but it must be invalidated when a product is created. A long negative TTL can hide the newly created product.

When a hot item expires, many requests can hit the database simultaneously: a cache stampede. Options include:

- Per-process single-flight so one request rebuilds the entry.
- TTL jitter so many keys do not expire at the same instant.
- Stale-while-revalidate when the business permits serving a short-lived stale value.
- A short lock with a unique token and conditional release. Locks need lease/timeout reasoning and are not an absolute correctness guarantee.
- Database concurrency limits, timeouts, and circuit breaking.

Illustrative lock flow:

~~~text
token = random unique value
if SET lock-key token NX PX 5000 succeeds:
    load from database; update cache; release only if the saved token still matches
else:
    wait briefly and re-read cache, or use an allowed stale value
~~~

An unconditional DEL of the lock is unsafe. The first lease can expire, a second worker can acquire a new lock, and the first worker can then delete the second worker’s lock. Use an atomic compare-and-delete script or a suitable coordination primitive.

## Step 6 — Outage behavior

If Redis is unavailable, do not let every request flood the database without a limit. Decide which features fail open, how many extra reads the database can accept, and what timeout, circuit breaker, concurrency cap, and degraded response apply.

For a product page, Redis may only accelerate reads. For a session or risk-critical decision, losing Redis may change service semantics; decide persistence and HA requirements separately.

## Observe the lab

~~~text
INFO stats
INFO memory
MEMORY USAGE lab:cache:product:42
TTL lab:cache:product:42
~~~

At the application layer, consider low-cardinality metrics such as cache_hits_total, cache_misses_total, cache_errors_total, db_fallback_total, cache_fill_duration, and Redis client latency. Do not attach user or product IDs as metric labels; that can create unbounded cardinality.

## Scenario table

| Scenario | Expected behavior | What to measure |
| --- | --- | --- |
| Cache hit | Return from Redis without a database read | Hit ratio and p95 |
| Cache miss | Read source and fill cache | Miss rate and fallback latency |
| Product deleted | Return not-found with short negative TTL | Source deletion and invalidation |
| Price update | Invalidate or bump version after DB commit | Stale-read window |
| Redis outage | Bounded fallback or controlled degradation | Error rate and DB saturation |
| Hot key expires | Limit rebuild concurrency | Lock contention and DB QPS |
| Redis eviction | Miss and rebuild; source remains safe | Evictions and database capacity |

## Common mistakes

- Forgetting a TTL or applying it to the wrong key.
- Treating cached price as final checkout authority.
- Failing to invalidate after update, or invalidating before the database commit.
- Keeping negative cache entries too long.
- Translating Redis outage into unlimited database traffic.
- Adding a distributed lock without understanding lease expiry, fencing, and failure behavior.
- Calling eviction a Redis failure even when maxmemory policy intentionally removed a cache key.

## Project deliverable

Write a one-page design covering key schema, TTL/jitter, source of truth, invalidation, stale tolerance, outage fallback, stampede protection, and metrics. Answer:

1. If Redis is cleared, which values can the database rebuild?
2. Which service validates checkout price?
3. What is the maximum stale window, and where did it come from?
4. What cap protects the database during simultaneous misses?
5. Which signal pages the on-call person?

### Rubric (10 points)

- Authoritative source and cache boundary: 2
- TTL, key design, and invalidation: 2
- Race, stampede, and outage behavior: 2
- Metrics and fallback: 2
- Staleness and consistency trade-offs: 2

## Safe lab cleanup

Only remove this project’s exact lab keys:

~~~text
SCAN 0 MATCH lab:* COUNT 100
DEL lab:source:product:42 lab:cache:product:42 lab:lock:product:42 lab:cache:short
~~~

DEL does not accept a wildcard in place of keys. Never use FLUSHDB or FLUSHALL to clean up a shared database.

## References and further reading

- [Cache-aside pattern — Microsoft Azure Architecture Center](https://learn.microsoft.com/azure/architecture/patterns/cache-aside)
- [Redis caching patterns](https://redis.io/docs/latest/develop/use/patterns/)
- [EXPIRE command reference](https://redis.io/docs/latest/commands/expire/)
- [Redis memory optimization](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/memory-optimization/)
- [Cache stampede overview — AWS Builders’ Library](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/)
- [Redis guide in Persian — SalamLang](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی دلایل استفاده از Redis](https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh)

</div>

