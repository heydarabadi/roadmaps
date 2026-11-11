<div dir="ltr" align="left">

# Redis Compared with SQL and NoSQL

> Level: beginner to intermediate · Time: 45–75 minutes
>
> Persian edition: [Redis در برابر SQL و NoSQL](../../../../fa/redis/01-foundations/choose-datastore/README.md)

## Learning objectives

Explain when Redis is a good or poor fit by looking at workload, query shape, durability, consistency, latency, and operating cost.

## The lesson

SQL databases are often well suited to durable data, constraints, joins, analytical queries, and domain transactions. Redis is useful for fast key/structure access, counters, caches, and sessions. These labels are not absolute: Redis can persist data, but its query model and RAM cost differ from a relational database.

Before choosing, ask: Where is the source of truth? What is the latency target? How large is the dataset and how often is it accessed? What happens if Redis is unavailable? What consistency and RPO are required? Can the query be expressed with keys and data structures? What will RAM and replication cost?

## Compare by workload

| Question | Redis is often a fit when… | A relational database is often a better fit when… |
| --- | --- | --- |
| What is the query? | Frequent key lookups, counters, membership, or rank are needed. | Joins, reports across tables, constraints, and varied queries are needed. |
| How long must data live? | Expiry, low latency, or short-lived state is valuable. | Data must remain the durable, auditable source of truth. |
| Which trade-off is acceptable? | RAM, replicas, and possible stale cache are controlled. | Central database constraints and transactions should enforce correctness. |
| What happens during an outage? | A fallback or recovery path is defined. | The primary database's durability and availability are used. |

This table is a starting point, not a final verdict. Workload, version, managed-service features, and team expertise can change the decision. Redis has persistence, and SQL systems can have caches. The core differences are access model and which guarantees you must design.

## Three selection exercises

### A. One-time phone verification code

A short-lived code has a simple lookup key and TTL, so Redis may be a good fit. You still need to design attempt limits, one-time use, brute-force protection, deletion after success, and rate limiting. Storing the code in Redis alone does not prevent attacks.

### B. Payment and ledger

Keep financial transactions, uniqueness constraints, and an auditable history in an appropriate primary database. Redis may serve a low-risk display projection or cache, but a fast cached response does not prove a payment occurred. The final decision must come from an authoritative source.

### C. Page-view count

If an approximate statistic is sufficient and you need unique visitors, HyperLogLog may fit. If the count must be exact, measure the cost of an exact model. Label these results “approximate” or “exact” in reports.

## Coexisting with a primary database

A common architecture keeps source data in PostgreSQL. The application checks Redis for a frequent response; on a miss, it reads PostgreSQL and populates the cache. A database update later invalidates the cache. This creates two copies of the data, so stale reads and failed invalidation become new failure modes. TTL bounds staleness in time but does not guarantee immediate consistency.

## Decision checklist

1. Write the primary query precisely, such as “get this product summary by ID.”
2. Set the freshness requirement: how many seconds or minutes of stale data are acceptable?
3. Identify the source of truth and say whether Redis can be deleted and rebuilt.
4. Estimate peak key count, average key/value size, and monthly growth.
5. Estimate cache-miss cost and outage impact; constrain the fallback path too.
6. Model consistency, TTL, invalidation, and multi-key operations.
7. Benchmark with representative payloads and key patterns; record p95/p99. A small `SET` benchmark does not predict the whole system.

**Sample answer:** A short-lived verification code, product cache, and ranking query have different requirements. Redis can fit the first two depending on security/freshness, and a Sorted Set can fit ranking. A payment ledger should not be moved to a cache just to make it faster.

## Example and experiment

Assume PostgreSQL is the source of truth for a product price and Redis caches a high-traffic product page. Write down how a price change invalidates the cache and what fallback you use during an outage.

## Published real-world example

The DBS case is an example of Redis coexisting with other systems. The report does not claim that Redis completely replaced the primary database.

- [DBS Bank case study — AWS](https://aws.amazon.com/solutions/case-studies/dbs-bank-case-study/)

## Common mistakes

- Choosing from one command benchmark or a database label alone.
- Ignoring consistency, query shape, durability, and operating cost.
- Treating a cache hit as proof of an authoritative business decision.

## Practice

1. Run a local product-cache example and describe its output.
2. Write two failure modes or edge cases.
3. Estimate data size, read/write rate, TTL/retention, and outage behavior for your workload.
4. Select a metric such as p95 latency, hit rate, RAM, lag, pending count, or restore time.

## Quiz

### 1. Does Redis provide general relational constraints?

<details><summary>Answer</summary>

No. Redis structures are not a replacement for general SQL constraints.

</details>

### 2. Where should a disposable cache be rebuilt from?

<details><summary>Answer</summary>

From an authoritative source or a defined recomputation path.

</details>

### 3. What makes a datastore decision defensible?

<details><summary>Answer</summary>

Measured latency and throughput, RAM/cost estimates, SLOs, and documented failure behavior.

</details>

## Further reading

### English and official references

- [Compare Redis data types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Redis data types](https://redis.io/docs/latest/develop/data-types/)
- [Redis use patterns](https://redis.io/docs/latest/develop/use/patterns/)
- [Cache-aside pattern — Microsoft Azure Architecture Center](https://learn.microsoft.com/azure/architecture/patterns/cache-aside)
- [DBS Bank case study — AWS](https://aws.amazon.com/solutions/case-studies/dbs-bank-case-study/)
- [Redis keyspace and expiry](https://redis.io/docs/latest/develop/using-commands/keyspace/)

### Persian references

- [Introductory Persian article about Redis](https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh)
- [DNTips overview (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [SalamLang Redis guide](https://www.salamlang.ir/std/db/redis/)

Persian articles on selecting stores by workload are limited. The lesson explains the core comparison; use the official references for current command and product details.

</div>
