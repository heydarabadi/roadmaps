# Chapter 4 — Aggregation, Search, and Performance

> **Persian edition:** [Read the Persian version](../../04-performance/readme.md).

## Lessons

- [Indexes](./indexes/readme.md) — derive indexes from real filters, sorts, and projections.
- [Explain plans and query tuning](./query-performance/readme.md) — interpret execution work and tune one hypothesis at a time.
- [Aggregation pipelines](./aggregation/readme.md) — transform and summarize data through ordered stages.
- [Atlas Search](./atlas-search/readme.md) — design text search with indexes, analyzers, relevance, and pagination.

## Study method

Use representative data, run a query, inspect `explain("executionStats")`, change one design choice, and compare both read and write effects. A collection scan in a tiny lab collection is not automatically a production problem.
