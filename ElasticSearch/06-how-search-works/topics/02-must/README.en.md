# The `must` Clause

> Chapter 06: How Search Works · Lesson 02

[Read the Persian version](README.md)

## Learning goals

- Require a document to match every `must` clause.
- Understand that query-context clauses can contribute to `_score`.
- Keep mandatory relevance conditions distinct from structured filters.

## Required and scored

Inside a `bool` query, `must` clauses are required for a document to match. They run in query context and can contribute to relevance score. Multiple `must` clauses are combined so all must match. This is appropriate when title and description should both match and both affect how results are ranked.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[
  {"match":{"title":"wireless headphones"}},
  {"match":{"description":"noise cancelling"}}
]}}}
~~~

Do not put every business condition in `must`. A numeric price range or availability flag usually decides eligibility and belongs in `filter`. If placed in scoring context, it can affect scoring semantics without adding meaningful textual relevance. Use `minimum_should_match` to control optional alternatives; `must` clauses remain mandatory regardless.

## Exercise

Search for products whose title and description both match required text. Move a price condition between `must` and `filter`, then compare hits and scores. Explain why same hits can still have different scoring behavior.

## Quiz with answers

1. **What does `must` require?** Every clause in the array must match.
2. **Can `must` contribute to score?** Yes, its query-context clauses can affect relevance.
3. **Where does a hard price limit usually belong?** In `filter`, unless the application intentionally wants it to influence score.
4. **Are all `must` clauses alternatives?** No. They are conjunctive requirements; all must match.

## References and further reading

- [Boolean query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query) — `must` and other clauses.
- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context) — score semantics.
- [Match query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-match-query) — full-text conditions.
- [Explain API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-explain) — inspect a document's score.
- [Boolean relevance article](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries) — examples of composing match clauses.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

