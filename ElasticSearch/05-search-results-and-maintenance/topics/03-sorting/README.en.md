# Sorting Search Results

> Chapter 05: Search Results and Maintenance · Lesson 03

[Read the Persian version](README.md)

## Learning goals

- Sort by relevance, numeric values, dates, or exact-value fields.
- Add a tie-breaker for deterministic result order.
- Handle missing values and understand sorting costs.

## Sort fields need the right mapping

Search results are sorted by `_score` by default when scoring queries are used. Applications may instead sort by a number, date, or keyword field. Sorting on a field uses doc values in the normal case, so a full-text `text` field is not the usual choice. If a title needs sorting, create a keyword multi-field. Sorting across shards also requires the coordinator to merge local sort order.

~~~http
POST /products-v1/_search
{"query":{"match":{"title":"wireless headphones"}},
 "sort":[{"_score":"desc"},{"price":"asc"},{"product_id":"asc"}]}
~~~

Here, relevance is primary, price breaks ties, and a unique product ID gives stable final ordering. Define where missing values appear when the field is optional. Use only the sorts the interface requires; adding several expensive sorts can increase work. When sorting by a field, scoring may not be needed unless `_score` is also requested or the query requires it.

## Exercise

Sort a catalog by relevance, then price, then product ID. Add a product with no price and set the desired missing-value position. Repeat with title text and its keyword subfield to observe mapping requirements.

## Quiz with answers

1. **Why is sorting on `text` usually problematic?** Text fields are optimized for full-text retrieval and do not normally have the doc values needed for sorting.
2. **How do you sort a title?** Add and use a keyword multi-field when that semantics and field length are appropriate.
3. **Why add a unique tie-breaker?** Scores or dates can tie, and a stable tie-breaker prevents inconsistent page order.
4. **How should missing values be handled?** Define their intended order explicitly and test representative records.

## References and further reading

- [Sort search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/sort-search-results) — sort fields and missing-value options.
- [Doc values](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/doc-values) — column-oriented structures used by sorting.
- [Keyword field](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword) — exact values and sorting.
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — combine query, sort, and pagination.
- [Search relevance guidance](https://www.elastic.co/docs/solutions/search/ranking) — relevance alongside business sorting.
- Persian discovery search (not a verified article): [Persian Elasticsearch sorting tutorials](https://www.google.com/search?q=Elasticsearch+sort+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

