# Match Query

> Chapter 05: Search Results and Maintenance · Lesson 06

[Read the Persian version](README.md)

## Learning goals

- Use `match` for analyzed full-text search.
- Understand how `operator` and `minimum_should_match` change multi-term behavior.
- Debug unexpected matches by inspecting analysis.

## Analyze the user's text

The `match` query analyzes its input using the field's search analyzer and combines the resulting terms. Its default operator is generally OR, so a document may match some query terms without matching every term. Use `operator: and` when all terms should be present, or `minimum_should_match` for a more flexible threshold. These choices trade recall against strictness and should reflect actual user intent.

~~~http
POST /products-v1/_search
{"query":{"match":{"title":{"query":"quiet mechanical keyboard","operator":"and"}}}}
~~~

The exact result depends on the field mapping and analyzer. If a query behaves unexpectedly, inspect the mapping, use the Analyze API to see tokens, and compare `match` with `term` on an exact keyword field. `match` is designed for full text; it is not a universal exact lookup for product IDs or status values.

## Exercise

Index titles with some but not all words from the query. Compare default OR, AND, and `minimum_should_match: "75%"`. Use the Analyze API to inspect punctuation and Persian half-space behavior in a Persian title.

## Quiz with answers

1. **What is the difference between `match` and `term`?** `match` analyzes query text for full-text search; `term` checks an exact indexed term.
2. **What does `operator: and` do?** All analyzed query terms must match.
3. **What should you inspect when token matching is surprising?** The field mapping and the analyzer output for both indexed and query text.
4. **Which query suits a SKU exact lookup?** A `term` query on a keyword-mapped SKU field.

## References and further reading

- [Match query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-match-query) — operators and minimum matching.
- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis) — analyzer behavior.
- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze) — inspect tokens.
- [Term query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-term-query) — compare exact matching.
- [Improve search relevance with boolean queries](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries) — practical multi-clause search.
- Persian discovery search (not a verified article): [Persian tutorials on match queries and text analysis](https://www.google.com/search?q=Elasticsearch+match+query+%D8%AA%D8%AD%D9%84%DB%8C%D9%84+%D9%85%D8%AA%D9%86+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

