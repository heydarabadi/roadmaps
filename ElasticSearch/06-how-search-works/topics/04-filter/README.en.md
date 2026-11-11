# The `filter` Clause

> Chapter 06: How Search Works · Lesson 04

[Read the Persian version](README.md)

## Learning goals

- Use filter context for conditions that decide eligibility but do not rank.
- Enforce tenant and access restrictions server-side.
- Understand that filters still consume resources and caching is conditional.

## Eligibility without a relevance score

The `filter` clause in a `bool` query evaluates a yes/no condition without calculating a relevance score for it. It suits structured conditions such as availability, date or price range, exact status, and tenant ID. Text clauses can remain in query context to rank results, while structured restrictions narrow the eligible candidates.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"wireless headphones"}}],
  "filter":[{"term":{"available":true}},{"term":{"tenant_id":"t-42"}}]}}}
~~~

Filters still take work to evaluate. Elasticsearch may cache some filter results in suitable situations, but do not rely on every filter being cached or free. A tenant filter can be part of a query, but authorization also depends on how every API endpoint is protected; users must not be able to omit or change the restriction. Enforce permissions through server-side query construction and security controls.

## Exercise

Create records for two tenants. Build a server-controlled filter and verify tenant A cannot retrieve tenant B's records through search, IDs queries, aggregations, or exports. This should be an isolated lab exercise, not a production experiment.

## Quiz with answers

1. **Does filter context score documents?** No; it tests whether a condition matches.
2. **What conditions belong in filter?** Structured eligibility such as availability, status, date, price, or tenant.
3. **Are filters always free or cached?** No. They require execution work, and cache behavior depends on the query and use.
4. **Can an optional UI filter enforce tenant security?** No. The restriction must be enforced server-side and across relevant access paths.

## References and further reading

- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context) — filter behavior and caching context.
- [Boolean query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query) — place clauses inside `filter`.
- [Field and document security](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/field-and-document-access-control) — access controls beyond query logic.
- [User roles](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/user-roles) — apply privileges to identities.
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — filters in search requests.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

