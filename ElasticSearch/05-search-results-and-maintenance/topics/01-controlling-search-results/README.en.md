# Controlling Search Results

> Chapter 05: Search Results and Maintenance · Lesson 01

[Read the Persian version](README.md)

## Learning goals

- Shape search output for a real application interface.
- Distinguish matching, scoring, sorting, pagination, totals, and returned fields.
- Read response metadata and avoid hiding timeout or shard failures.

## A search response is a product contract

A search request controls which documents qualify, how relevance is scored, how results are ordered, which page is returned, and which fields are included. It can also request highlights and aggregations. Each option affects response size, latency, or user-visible meaning, so begin with the user experience and required guarantees rather than adding every feature.

~~~http
POST /products-v1/_search
{"track_total_hits":1000,"size":10,
 "query":{"bool":{"must":[{"match":{"title":"wireless headphones"}}],
   "filter":[{"term":{"available":true}}]}},
 "sort":[{"_score":"desc"},{"product_id":"asc"}],
 "_source":["product_id","title","price"]}
~~~

The response includes `took`, `timed_out`, `_shards`, and `hits`. `took` is the Elasticsearch-side duration, not the full time perceived by a user across network and application layers. Check `timed_out` and shard failures. `hits.total` may be an exact count or a lower bound (with relation `gte`) depending on tracking configuration. Ask for exact totals only when the interface needs them; exact counting can increase work.

## Exercise

Design two responses for the same catalog: an autocomplete result and a CSV export. Specify page size, sort, total-count behavior, source fields, and whether highlights or aggregations are needed. Explain why the two endpoints should not necessarily share settings.

## Quiz with answers

1. **Which part limits eligibility and which can rank?** Filter conditions limit eligibility; query-context clauses can contribute relevance score.
2. **Why may total hits be approximate?** Exact count tracking can cost more, so a bounded threshold may return a lower-bound relation.
3. **What does `took` exclude?** It does not include every application and network component of end-to-end user latency.
4. **Why check shard failures?** A response may be incomplete if some shards failed.

## References and further reading

- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — request and response options.
- [Track total hits](https://www.elastic.co/docs/solutions/search/the-search-api#track-total-hits) — exact and bounded counts.
- [Paginate search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/paginate-search-results) — result windows and deep pagination.
- [Sort search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/sort-search-results) — deterministic ordering.
- [Ranking and reranking](https://www.elastic.co/docs/solutions/search/ranking) — relevance design.
- Persian discovery search (not a verified article): [Persian search-results articles](https://www.google.com/search?q=Elasticsearch+search+results+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


