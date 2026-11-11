# Pagination

> Chapter 05: Search Results and Maintenance · Lesson 02

[Read the Persian version](README.md)

## Learning goals

- Use `from` and `size` for shallow pages.
- Use `search_after` for deep, stable traversal.
- Use a Point in Time (PIT) when a traversal needs a consistent view as data changes.

## Choose pagination by workload

`from` and `size` are simple for early pages. For a deep offset, each shard must collect candidates up to `from + size`, which increases work and is constrained by `index.max_result_window`. For deep traversal, use `search_after`: keep the same query and sort, then send the last hit's sort values to retrieve the next page. The sort should include a stable unique tie-breaker so equal scores or timestamps do not cause skips or duplicates.

~~~http
POST /products-v1/_search
{"size":2,"query":{"match_all":{}},
 "sort":[{"product_id":"asc"}],
 "search_after":["sku-002"]}
~~~

If documents change during traversal and a consistent snapshot is important, open a PIT and include it in subsequent searches. Keep PITs short-lived, use the most recent PIT ID returned by the API, and close the PIT when finished. Scroll is designed for batch processing or export rather than ordinary interactive UI pagination.

## Exercise

Index five products and page through them two at a time using a unique sort field. Add a document between requests. Compare results with and without PIT and check for duplicate or skipped IDs. Then explain why a large `from` offset is expensive.

## Quiz with answers

1. **Why is a deep `from` offset costly?** Shards need to collect and discard earlier hits as well as return the requested page.
2. **What must stay fixed when using `search_after`?** The query and sort order.
3. **Why include a unique tie-breaker?** It makes ordering deterministic when earlier sort values are equal.
4. **What does PIT add?** A consistent view of the index across a sequence of search requests.
5. **When is Scroll appropriate?** Batch export or processing, not usually interactive page navigation.

## References and further reading

- [Paginate search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/paginate-search-results) — `from`, `search_after`, PIT, and scroll guidance.
- [Point in Time API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-open-point-in-time) — open a PIT.
- [Close a Point in Time](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-close-point-in-time) — release a PIT.
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — `search_after` request parameters.
- Persian discovery search (not a verified article): [Persian articles about search_after and deep pagination](https://www.google.com/search?q=Elasticsearch+search_after+pagination+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

