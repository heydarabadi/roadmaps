# Chapter 05: Search Results and Data Maintenance

[Read the Persian chapter guide](README.md)

## Learning goals

- Shape search responses for a UI, API, export, or interactive investigation.
- Choose stable sorting and pagination for shallow and deep result sets.
- Use full-text, exact, range, existence, ID, prefix, and wildcard queries appropriately.
- Migrate or update data without assuming background APIs keep the source synchronized.
- Treat bulk updates and deletes as monitored operational tasks.

## Chapter thesis

A search endpoint is a product contract: it defines matching, ranking, ordering, pagination, returned fields, highlights, totals, and failure behavior. Shallow UI pages can use `from` and `size`; deep traversal needs stable `search_after` sorting and often a Point in Time. Query types must agree with field mappings. Reindexing and query-based mutations are operational migrations, not magic synchronization: validate scope, handle concurrent writes, monitor tasks, and retain a rollback or restore strategy.

## Study sequence

1. [Controlling Search Results](topics/01-controlling-search-results/README.en.md)
2. [Pagination](topics/02-pagination/README.en.md)
3. [Sorting](topics/03-sorting/README.en.md)
4. [Source Filtering](topics/04-source-filtering/README.en.md)
5. [Highlighting](topics/05-highlighting/README.en.md)
6. [Match Query](topics/06-match-query/README.en.md)
7. [Term Query](topics/07-term-query/README.en.md)
8. [Range Query](topics/08-range-query/README.en.md)
9. [Exists Query](topics/09-exists-query/README.en.md)
10. [IDs Query](topics/10-id-query/README.en.md)
11. [Prefix Query](topics/11-prefix-query/README.en.md)
12. [Wildcard Query](topics/12-wildcard-query/README.en.md)
13. [Reindex API](topics/13-reindex-api/README.en.md)
14. [Update by Query](topics/14-update-by-query/README.en.md)
15. [Delete by Query](topics/15-delete-by-query/README.en.md)

## Applied workshop: catalog search and migration

Build a catalog search that matches a title, filters by availability and price, sorts by score with a unique product ID tie-breaker, and returns only fields required by the UI. Add highlighting and inspect its safety and cost. Implement two shallow pages, then traverse deeply with `search_after` and a PIT. Finally create a new mapping version, reindex sample data, compare counts and business queries, and plan how concurrent writes reach the destination before switching an alias.

## Architecture choices and common traps

| Need | Recommended starting point | Main risk |
| --- | --- | --- |
| Shallow UI pages | `from` / `size` with deterministic sort | Deep offsets increase shard work |
| Deep traversal | `search_after` with stable sort; PIT for a stable view | Changing query or sort can skip or repeat records |
| Full-text search | `match` on an analyzed text field | Using `term` against analyzed content |
| Exact match | `term` on an appropriately mapped field | Mapping or normalization mismatch |
| Prefix autocomplete | Prefix, search-as-you-type, or completion design selected by measurement | Very broad short prefixes |
| Flexible pattern | Constrained wildcard on a suitable field | Leading wildcard and unbounded user patterns |
| Schema migration | New index, reindex, validate, alias cutover | Missing writes that occur during copying |
| Mass update/delete | Preview query, async task, throttle, monitor | Wrong predicate or unchecked conflicts/failures |

Never treat `_source` filtering as access control. Never assume a status code means every bulk operation succeeded. Never use a destructive query against production as a learning exercise. A copy or alias change is not a substitute for a tested recovery plan.

## Chapter quiz

1. Why is a unique tie-breaker needed for `search_after`?
2. When can a search total be a lower bound rather than exact?
3. How do `match` and `term` differ?
4. Why is a wildcard pattern beginning with `*` potentially expensive?
5. What does reindex not do automatically while the copy is running?
6. What should be checked before Delete by Query?

**Answer key:** (1) Equal sort values otherwise leave order unstable and can lead to skipped or duplicated hits. (2) When exact total tracking is bounded or disabled. (3) `match` analyzes text; `term` checks an exact indexed term. (4) It lacks a fixed starting prefix to narrow term enumeration. (5) It does not automatically synchronize later source writes. (6) Exact index, predicate, sample hits, expected count, retention, task behavior, and recovery plan.

## References and real-world context

- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- [Paginate search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/paginate-search-results)
- [Reindex API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/reindex-indices)
- [Update by Query](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/update-by-query-api)
- [Delete by Query](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/delete-by-query-api)
- [Elastic search case studies](https://www.elastic.co/customers/) — vendor-published examples; reported outcomes are workload-specific.
- [Canals hybrid search case](https://www.elastic.co/customers/canals) — reported top-three catalog accuracy improvement using keyword and vector methods.
