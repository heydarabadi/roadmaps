# The `should` Clause

> Chapter 06: How Search Works · Lesson 03

[Read the Persian version](README.md)

## Learning goals

- Use `should` to express optional boosts or alternative matches.
- Understand when a `should` clause becomes required.
- Make requiredness explicit with `minimum_should_match`.

## Preferred matches and alternatives

`should` clauses can increase score when they match. They can also behave as alternatives that a document must satisfy. If a bool query has only `should` clauses, at least one is required by default. When it also has `must` or `filter`, `should` is commonly optional unless `minimum_should_match` says otherwise.

~~~http
POST /products-v1/_search
{"query":{"bool":{
  "must":[{"match":{"title":"wireless headphones"}}],
  "should":[{"term":{"brand":"Acme"}}],
  "minimum_should_match":0
}}}
~~~

Here, the title is required and a preferred brand can boost rank. If at least one of several synonym or title alternatives must match, set `minimum_should_match` accordingly. Evaluate boost effects on a judged query set; a high boost does not guarantee better relevance. `should` is for ranking or alternatives, not for hard authorization rules.

## Exercise

Add three optional brand and category clauses. Compare minimums of 0, 1, and 2. Record which documents remain eligible and how scores change. Decide whether each clause is a ranking preference or a required alternative.

## Quiz with answers

1. **What can `should` do?** Add a relevance preference or express alternatives, depending on bool context.
2. **When is a `should` clause required by default?** In a bool query containing only `should` clauses, at least one must match.
3. **What does `minimum_should_match` control?** How many `should` clauses must match.
4. **How should a boost be evaluated?** Against representative queries and judged relevance, not by assuming higher is better.

## References and further reading

- [Boolean query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query) — defaults and minimum matching.
- [Minimum should match parameter](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-minimum-should-match) — count and percentage syntax.
- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context) — scores and eligibility.
- [Ranking and reranking](https://www.elastic.co/docs/solutions/search/ranking) — rank features and multi-stage search.
- [Boolean relevance article](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries) — practical query composition.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

