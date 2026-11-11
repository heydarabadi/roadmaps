# Query DSL

> Chapter 04: Indexing and Query Languages · Supplementary Lesson

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/query-dsl/README.md)

## Learning goals

- Build a JSON-native Elasticsearch query.
- Distinguish query context from filter context.
- Combine leaf and compound queries while respecting field mappings.
- Explain a surprising match or non-match using Explain or Profile appropriately.

## How the DSL fits together

Query DSL is Elasticsearch's JSON-based language for search requests. A leaf query such as `match`, `term`, or `range` expresses one kind of condition. A compound query such as `bool` combines clauses. In query context, Elasticsearch calculates a relevance score; in filter context it tests whether a document qualifies without scoring that condition. Aggregations can summarize the matching set in the same request.

~~~http
POST /products-v1/_search
{
  "query": {
    "bool": {
      "must": [{"match": {"title": "mechanical keyboard"}}],
      "filter": [
        {"term": {"available": true}},
        {"range": {"price": {"lte": 8000}}}
      ],
      "must_not": [{"term": {"status": "hidden"}}],
      "should": [{"match": {"brand": "mechanical"}}]
    }
  }
}
~~~

The title search contributes relevance. Availability and price define eligibility, while hidden products are excluded. The optional brand clause can boost results, but its requiredness depends on bool defaults and `minimum_should_match`; set the latter when product semantics require it. Query DSL syntax must agree with mapping. `term` is not a substitute for analyzed full-text search, and valid JSON can still describe a query that never matches.

## Debugging path

Start with a few documents whose expected behavior you can explain. Inspect mappings and analysis, then add clauses one at a time. Use the Explain API for a specific document's match and score breakdown. Use Profile only for targeted performance analysis because profiling adds overhead. Finally, evaluate real user queries against representative data and measure relevance and latency.

Query DSL is not the same as ES|QL, EQL, SQL, KQL, or Lucene query-string syntax. Each has a different purpose and context.

## Exercise

Build a catalog query containing text relevance, a stock filter, a price range, a category facet, and an optional brand preference. Explain what happens when you move the range condition from `filter` into `must` and when you set `minimum_should_match` to 1.

## Quiz with answers

1. **What is Query DSL?** The JSON-native language used to define Elasticsearch searches and related request components.
2. **Why read the mapping before debugging a query?** Field type and analysis determine how query values are interpreted.
3. **What is the difference between query and filter context?** Query context calculates relevance; filter context performs a yes/no eligibility test.
4. **When should Profile be used?** For targeted diagnosis of query execution cost, not as a routine production setting.

## References and further reading

- [Query DSL reference](https://www.elastic.co/docs/reference/query-languages/query-dsl) — query types and composition.
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — complete request and response options.
- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context) — scoring versus filtering.
- [Explain API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-explain) and [Profile API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search-profile) — understand matching and cost.
- [Boolean relevance article](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries) — worked ranking example.
- Persian discovery search (not a verified article): [Persian Query DSL articles](https://www.google.com/search?q=Elasticsearch+Query+DSL+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


