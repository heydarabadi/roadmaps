<div dir="ltr" align="left">

# Chapter 10 — Modern and Specialized Redis Data Types

> Persian edition: [فصل ۱۰ — ساختارهای جدید و تکمیلی Redis](./README.md) · Suggested time: 4–6 hours.

This chapter updates topics not fully covered by the classic roadmap PDF. Check the endpoint version: “latest docs” do not prove that your service runs the latest version.

## Lessons

1. [Redis JSON](./json/README.en.md): nested documents, JSONPath, path updates, schema, and indexing.
2. [Time Series and probabilistic structures](./timeseries-probabilistic/README.en.md): timestamps, retention, aggregation, approximation, and error.
3. [Vector Sets and Arrays](./vectors-arrays/README.en.md): similarity search, embeddings, indexes, and Redis 8.8 arrays.

## Selection map

| Data or question | Type to evaluate |
| --- | --- |
| Nested JSON document with path updates | JSON |
| Numeric values with timestamps, ranges, and retention | Time Series |
| Approximate membership, frequency, rank, or cardinality | Bloom/Cuckoo/CMS/Top-K/t-digest/HyperLogLog |
| Similar embeddings with lightweight filters | Vector Set |
| Similarity plus full text and rich filters | Redis Query Engine over Hash/JSON |
| Ordered collection with index access or ring buffer | Array (Redis 8.8+) |

## Version and packaging

Redis 8 integrated JSON, Time Series, Search, and probabilistic structures into Redis Open Source; Redis 8.0 also added Vector Sets. Redis 8.8 introduced Arrays. Older deployments may require a module/Redis Stack or may not have the commands. Cloud/Software products and SDKs can differ too. Before migration, verify version, edition, command availability, backup/restore, and client support in CI/staging.

## Conceptual review

A specialized type is helpful only when its operations match the workload. JSON does not automatically enforce an application schema; a Time Series can grow indefinitely without retention; a probabilistic type is not an exact source of truth; vector similarity does not guarantee relevance; and an Array is not a durable queue. Each lesson includes a lab, answered practice, and operational risks.

## Chapter quiz

1. Which probabilistic type would you not use as the sole source for exact billing, and why?
2. Why does a vector-search score not guarantee a model response is correct?
3. What else besides raw timestamps does a latency dashboard need?
4. When is a List a better choice than an Array?

<details><summary>Answer guide</summary>

Do not use an approximate sketch as an exact billing ledger; use an authoritative exact source. A vector score ranks embeddings; model quality and evaluation data determine relevance. A dashboard also needs retention, suitable aggregation (such as p95/max), bounded labels, and gap handling. Lists or Streams/brokers fit queue operations better; Arrays fit index/range operations and bounded ring buffers.

</details>

## Further reading

- [What's new in Redis 8.0](https://redis.io/docs/latest/develop/whats-new/8-0/)
- [What's new in Redis 8.8](https://redis.io/docs/latest/develop/whats-new/8-8/)
- [Compare Redis data types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Official Redis roadmap PDF](https://roadmap.sh/pdfs/roadmaps/redis.pdf)
- [Redis 8.8 release announcement](https://redis.io/blog/announcing-redis-8-8/)

</div>
