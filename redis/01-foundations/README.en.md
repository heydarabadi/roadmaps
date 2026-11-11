<div dir="ltr" align="left">

# Chapter 1 — Redis Foundations and Use-Case Selection

> Persian edition: [فصل ۱ — شناخت Redis و انتخاب کاربرد](./README.md) · Suggested time: 2–3 hours plus notes.

The goal is to understand what problem Redis solves, what guarantees it provides, and when it is a poor choice before memorizing commands.

## Prerequisites and lesson order

No specific programming language is required. Know the basic ideas of an application, data, and client/server networking.

1. [What is Redis?](./redis-overview/README.en.md): the in-memory key/value model, data types, commands, memory, and Redis beside a primary data source.
2. [Use cases and patterns](./use-cases/README.en.md): cache, sessions, counters, leaderboards, queues/events, rate limits, and their risks.
3. [Choosing a datastore](./choose-datastore/README.en.md): compare key/value, SQL, document, search, and broker requirements.

## Mental model for this chapter

An application sends commands to Redis and receives replies. A key names an object; its value may be a String, Hash, List, Set, Sorted Set, or a specialized type. Redis is not merely a “key/value table”: the data type, supported operations, and operation cost are part of the design.

Fast does not mean “put everything in Redis.” Redis is often a specialized layer beside a durable database. Before storing data, ask: What is the source of truth? What happens if Redis becomes empty? Can the data be rebuilt? How long should it remain?

## Design steps for a use case

Consider a product cache:

1. Identify the primary source for product data; Redis is the cache.
2. Write the query: “Read product 42.”
3. Choose the value and serialization, such as a JSON string or a Hash.
4. Set an expiration policy so the cache does not grow without limit or serve stale data forever.
5. Define a cache miss: read the database, return the result, then populate Redis.
6. Consider failure: if Redis is unavailable, can the application use the source database, and how will it protect that database from a request surge?

The same answers do not apply to sessions, rate limits, and queues. “Redis is fast” is not enough; define the requirement, what can be lost, and how to recover.

## Chapter exercise

For each workload, write the source of truth, key/data model, TTL, miss/outage behavior, stale-data risk, and monitoring metric.

| Workload | Key question |
| --- | --- |
| High-traffic product page | How many seconds or minutes of staleness are acceptable? |
| Short-lived session | Does a Redis outage sign the user out, or can the user sign in again? |
| Request count in a time window | What is the window boundary and the required accuracy? |

## Readiness quiz

1. Why can Redis be fast and still be a poor primary store for some data?
2. How is a cache miss different from a cache outage?
3. For each pattern, what does Redis store and which system is authoritative?
4. Name one cache-stampede failure mode and one mitigation.

<details><summary>Answer guide</summary>

Speed comes from the access model and in-memory data, while durability, relationships, reporting, and consistency may require a primary database. A miss means a key is absent; an outage means the service itself cannot be reached. For a cache, the database is usually authoritative. Session state may be operationally important and needs an explicit outage policy. A stampede occurs when many simultaneous misses overload the primary source; possible mitigations include per-process single-flight, TTL jitter, stale-while-revalidate, or bounded rate limiting, each with trade-offs.

</details>

## Further reading

- [Redis documentation](https://redis.io/docs/latest/)
- [Compare Redis data types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Redis use patterns](https://redis.io/docs/latest/develop/use/patterns/)
- [DNTips Redis overview in Persian (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [English case-study and attribution notes in the course guide](../README.en.md#selected-published-case-studies)

The linked resources are supplemental; the three linked lessons are the chapter's main teaching material.

</div>
