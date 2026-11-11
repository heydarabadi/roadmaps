# Keyword Fields

> Chapter 04: Indexing and Query Languages · Lesson 06

[Read the Persian version](README.md)

## Learning goals

- Choose `keyword` for exact values such as codes, status, and categories.
- Use keyword values for terms queries, sorting, and aggregations.
- Apply a normalizer only when its exact-match semantics are intentional.

## Exact values, not natural-language search

A `keyword` field indexes the whole value as one term (subject to mapping options). It is appropriate for product IDs, status values, brand facets, and other values that should be compared as a whole. It can support term queries, sorting, and bucket aggregations. It is not the default choice for a long description where users expect individual words to match.

~~~http
POST /products-v1/_search
{"query":{"term":{"brand":{"value":"Acme"}}},
 "sort":[{"brand":{"order":"asc"}}]}
~~~

Exact query values must match the indexed term. A normalizer can apply controlled transformations such as lowercasing, but it should be configured before indexing and tested with representative data. For titles that need both analyzed search and exact operations, use a `text` field with a keyword multi-field. High-cardinality keyword fields can affect aggregation memory and cost, so understand the cardinality and query pattern.

## Exercise

Design mappings for SKU, brand, category, and title. Write a term query for one exact brand, a terms aggregation by category, and a match query over title. Explain why sending a lowercase query for `ACME` might depend on the normalizer.

## Quiz with answers

1. **When is keyword appropriate?** When the entire string is treated as one value for exact matching, sorting, or grouping.
2. **Does keyword search each word in a title?** No. It treats the entire value as a term rather than analyzing it as natural language.
3. **How can one field serve full-text and exact use cases?** Use a text field with a keyword multi-field.
4. **What should be evaluated before adding a normalizer?** Which values should compare equal and whether indexing and query normalization remain compatible.

## References and further reading

- [Keyword field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword) — exact-value field behavior and limits.
- [Term query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-term-query) — exact term matching.
- [Sort search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/sort-search-results) — sorting on fields.
- [Terms aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-terms-aggregation) — group by keyword values.
- [Normalizers](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/normalizer) — normalize keyword values.
- Persian discovery search (not a verified article): [Persian articles on Elasticsearch keyword fields](https://www.google.com/search?q=Elasticsearch+keyword+field+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

