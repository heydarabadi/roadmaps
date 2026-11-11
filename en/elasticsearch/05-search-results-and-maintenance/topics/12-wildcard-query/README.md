# Wildcard Query

> Chapter 05: Search Results and Maintenance · Lesson 12

[Read the Persian version](../../../../../fa/elasticsearch/05-search-results-and-maintenance/topics/12-wildcard-query/README.md)

## Learning goals

- Use wildcard patterns for term-pattern matching rather than natural-language search.
- Understand the cost of leading wildcards.
- Restrict and measure wildcard input in an application.

## Match a term pattern

The wildcard query matches indexed terms with `*` for zero or more characters and `?` for one character. For example, a product identifier pattern such as `sku-1*` can match a family of IDs. Use a keyword field when the pattern is intended for the whole identifier.

~~~http
POST /products-v1/_search
{"query":{"wildcard":{"product_id":{"value":"sku-1*"}}}}
~~~

Wildcard is not a replacement for full-text search. A leading pattern such as `*suffix` has no fixed starting point and may require examining many terms, making it costly. Restrict the fields and patterns exposed to users, enforce query budgets, and measure representative traffic. For known starts, a prefix query may be more appropriate. Consider a normalized auxiliary field when the product frequently searches a structured identifier pattern.

## Exercise

Compare a prefix query, a `sku-1*` wildcard, and a `*100` wildcard on representative data. Record matching counts and latency. Decide which patterns the product will allow and how to bound them.

## Quiz with answers

1. **What do `*` and `?` represent?** Zero-or-more characters and exactly one character, respectively.
2. **Why can a leading wildcard be expensive?** It lacks a fixed prefix to narrow dictionary term enumeration.
3. **Is wildcard appropriate for natural-language text search?** Usually no; use full-text queries such as `match`.
4. **How can wildcard exposure be controlled?** Restrict target fields, validate patterns, and measure or limit expensive requests.

## References and further reading

- [Wildcard query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-wildcard-query) — syntax and expensive-query notes.
- [Prefix query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-prefix-query) — a narrower alternative for starts-with behavior.
- [Keyword fields](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword) — exact term storage.
- [Search API query controls](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — request limits and options.
- Persian discovery search (not a verified article): [Persian Elasticsearch wildcard-query articles](https://www.google.com/search?q=Elasticsearch+wildcard+query+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

