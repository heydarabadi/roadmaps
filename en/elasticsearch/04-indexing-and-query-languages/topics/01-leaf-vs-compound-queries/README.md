# Leaf vs. Compound Queries

> Chapter 04: Indexing and Query Languages · Lesson 01

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/01-leaf-vs-compound-queries/README.md)

## Learning goals

- Recognize leaf queries such as `match`, `term`, and `range`.
- Use a compound query to combine multiple conditions.
- Decide whether a clause filters eligibility or contributes to relevance.

## Query building blocks

A leaf query tests a field condition. A `match` query analyzes text, a `term` query checks an exact indexed value, and a `range` query checks a numeric, date, or other ordered interval. A compound query controls how other queries combine. The `bool` query exposes four common clauses: `must`, `should`, `filter`, and `must_not`.

~~~http
POST /products-v1/_search
{"query":{"bool":{
  "must":[{"match":{"title":"wireless headphones"}}],
  "filter":[{"range":{"price":{"lte":100}}},{"term":{"available":true}}],
  "should":[{"term":{"brand":"Acme"}}],
  "must_not":[{"term":{"status":"hidden"}}]
}}}
~~~

The `must` text condition contributes to score. Filters constrain eligible products without calculating relevance score. `should` can boost a preferred brand; when the bool query also has `must` or `filter`, the default minimum number of matching `should` clauses is commonly zero, so set `minimum_should_match` if a preferred condition must be required. `must_not` excludes matches. Put a condition according to its semantics, not as a micro-optimization guess.

## Exercise

Build a query for a text search that must exclude archived products, require availability, limit a price range, and boost a preferred brand. Decide whether the brand is a boost or a strict requirement and encode that decision explicitly.

## Quiz with answers

1. **What is the difference between leaf and compound queries?** A leaf tests a field condition; a compound query combines or changes the behavior of other queries.
2. **Where does an eligibility range usually belong?** In `bool.filter`, because it should constrain candidates rather than change text relevance.
3. **When should `minimum_should_match` be explicit?** When one or more `should` clauses are required for a document to qualify.
4. **Why use `match` for natural language and `term` for an exact code?** `match` analyzes text; `term` compares the exact indexed term and does not perform full-text analysis.

## References and further reading

- [Query DSL](https://www.elastic.co/docs/reference/query-languages/query-dsl) — JSON query language overview.
- [Boolean query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query) — clause behavior and `minimum_should_match`.
- [Match query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-match-query) — analyzed full-text search.
- [Term query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-term-query) — exact term matching.
- [Improve search relevance with boolean queries](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries) — practical relevance examples from the Elastic blog.
- Persian discovery search (not a verified article): [Persian bool-query articles](https://www.google.com/search?q=Elasticsearch+bool+query+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


