# Filter Context

> Chapter 04: Indexing and Query Languages · Lesson 22

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/22-filter/README.md)

## Learning goals

- Use filter context for yes/no eligibility conditions.
- Distinguish filtering from relevance scoring.
- Avoid treating filters as free or assuming every filter is cached.

## Eligibility without relevance score

Filter context answers whether a document satisfies a condition without calculating a score for that condition. It is suitable for exact term checks, numeric/date ranges, existence tests, tenant boundaries, and other restrictions. Put text relevance in query context and hard eligibility in filters when those are the semantics the product needs.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"wireless headphones"}}],
  "filter":[{"term":{"available":true}},
             {"range":{"price":{"gte":10,"lte":100}}}]}}}
~~~

Filter context does not mean zero-cost execution. Elasticsearch may cache some filter results depending on conditions, but caching is not guaranteed for every filter. Do not make correctness or performance depend on assumptions about caching. Authorization boundaries must be enforced by Elasticsearch roles or application security design, not solely by a UI filter that a user can remove.

## Exercise

Write a product search with a `match` query for title, a filter for tenant ID, a range for price, and an existence condition. Remove one filter at a time and explain the security or business consequence. Do not test tenant isolation against production data.

## Quiz with answers

1. **Does filter context calculate relevance score for its conditions?** No; it tests match or no-match.
2. **What conditions commonly belong in filters?** Exact status, tenant, availability, permissions, and numeric or date ranges.
3. **Are filters always cached and free?** No. They still require work; cache behavior depends on execution and usage.
4. **Can a UI filter enforce access control?** No. Access restrictions need a server-side authorization boundary.

## References and further reading

- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context) — why and where to filter.
- [Boolean query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query) — combine must, filter, should, and must_not.
- [Term query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-term-query) — exact filters.
- [Range query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-range-query) — numeric and date filters.
- [User roles](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/user-roles) — enforce access beyond query construction.
- Persian discovery search (not a verified article): [Persian Elasticsearch filter-context articles](https://www.google.com/search?q=Elasticsearch+filter+context+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

