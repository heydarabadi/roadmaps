# Chapter 4 — Aggregation, Search, and Performance

> **Persian edition:** [Read the Persian version](../../../fa/mongodb/04-performance/README.md).

## Lessons

- [Indexes](indexes/README.md) — derive indexes from real filters, sorts, and projections.
- [Explain plans and query tuning](query-performance/README.md) — interpret execution work and tune one hypothesis at a time.
- [Aggregation pipelines](aggregation/README.md) — transform and summarize data through ordered stages.
- [Atlas Search](atlas-search/README.md) — design text search with indexes, analyzers, relevance, and pagination.

## Study method

Use representative data, run a query, inspect `explain("executionStats")`, change one design choice, and compare both read and write effects. A collection scan in a tiny lab collection is not automatically a production problem.
