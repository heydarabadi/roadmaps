# Capstone Project: Search for an Ecommerce Catalog

[Read the Persian version](README.md)

Treat the application database as the source of truth. Elasticsearch is a rebuildable search projection, updated from the system of record through a reliable synchronization path.

## Requirements to define first

Write down the user-facing behavior before designing mappings: Persian and Latin queries, exact SKU lookup, spelling tolerance, category and availability filters, sorting, facets, freshness, expected catalog size, peak query rate, and latency targets. Create a small judged query set with expected useful products so that later changes can be evaluated rather than guessed.

## Build milestones

1. Create `products-v1` with explicit mappings. Map searchable titles as `text` and add a `keyword` multi-field for exact matching, sorting, or facets where those operations are needed.
2. Index at least 20 products with numeric prices, category, availability, timestamps, Persian and Latin text, and representative attribute variation. Keep product IDs stable and make indexing retries idempotent.
3. Use the Bulk API with bounded batches. Inspect per-item failures; a successful HTTP response can still contain failed bulk items.
4. Implement `match`, exact `term`, Boolean filters, ranges, highlighting, source filtering, sorting, and category aggregations. Explain which clauses score results and which merely restrict them.
5. Use deterministic tie-breakers for pagination. For deep or changing result sets, use `search_after` with a stable sort and a Point in Time when appropriate.
6. Build `products-v2` when a mapping or analyzer change requires reindexing. Compare document counts, sampled source data, query results, relevance metrics, and index health before switching an alias.
7. Measure quality on the judged query set using an appropriate ranking metric such as NDCG@k or MRR, plus success, zero-result, latency, and operational cost metrics.
8. Write a production runbook covering alerts, disk and heap pressure, access roles, lifecycle and retention, snapshots, restore rehearsal, and the rollback procedure.

## Acceptance criteria

- Replaying the same source event does not create a duplicate product or stale overwrite.
- Price, dates, identifiers, text, and nested offers use types that match their query behavior.
- Filters do not accidentally contribute relevance score.
- Mapping migration has a verification checklist, cutover steps, and rollback plan.
- Persian queries are checked for half-spaces, Arabic/Persian character variants, digit forms, plurals, and mixed Latin/Persian text.
- Benchmarks identify their dataset, query set, hardware or deployment, cache state, and measurement window. Estimates are never presented as production results.

## Review questions

1. Which system owns each field, and how are deletes propagated?
2. What happens when the database update succeeds but the Elasticsearch write fails?
3. How do you avoid indexing stale events out of order?
4. Which fields are analyzed, and which support exact filters, facets, or sort?
5. How will you detect an analyzer change that improves some Persian queries but harms others?
6. What evidence is required before moving the read alias to `products-v2`?

## Further reading

- [Elasticsearch indexing overview](https://www.elastic.co/docs/manage-data/data-store/index-basics)
- [Mappings](https://www.elastic.co/docs/manage-data/data-store/mapping)
- [Bulk API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk)
- [Search API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-search)
- [Pagination](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/paginate-search-results)
- [Aliases](https://www.elastic.co/docs/manage-data/data-store/aliases)
- [Reindex API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-reindex)
- [Search relevance evaluation](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-relevance.html)
- [Persian language analyzer](https://www.elastic.co/docs/reference/text-analysis/analysis-lang-analyzer)
- [Bilingual bibliography](../../references/README.en.md)
