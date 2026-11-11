# Doc Values

> Chapter 07: Analysis, Analytics, and Production · Lesson 02

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/02-doc-values/README.md)

## Learning goals

- Explain the column-oriented structure used to read field values per document.
- Know which operations commonly use doc values.
- Design text plus keyword fields for retrieval and sorting.

## Column-oriented access

Doc values provide a column-oriented representation of field values, commonly stored on disk, for operations that need a field's values across documents. Sorting, aggregations, and some scripts commonly use doc values. They complement the inverted index: the inverted index maps terms to documents for search, while doc values make it efficient to read a field value for a set of documents.

~~~json
{"properties":{
  "title":{"type":"text","fields":{"keyword":{"type":"keyword"}}},
  "price":{"type":"long"}
}}
~~~

Use `title` for full-text search and `title.keyword` for exact sorting or terms aggregation. Numeric and date fields usually have doc values by default; text fields generally do not. Disabling doc values may reduce storage for fields that never need sorting or aggregation, but it also removes those operations. Decide from actual query requirements and test the consequence before changing a mapping.

## Exercise

Run a match query on title, sort by `title.keyword`, and aggregate by price range. Inspect the mapping. Explain why these operations use different index structures.

## Quiz with answers

1. **What operations commonly use doc values?** Sorting and aggregations, along with scripts that read field values.
2. **How do doc values relate to the inverted index?** They complement it; one supports term-to-document lookup and the other column-like value access.
3. **Why is a text field usually not sortable by default?** It is optimized for analyzed full-text search and normally lacks doc values.
4. **What mapping often serves both title search and sort?** A text field with a keyword multi-field.

## References and further reading

- [Doc values](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/doc-values) — storage and field support.
- [Text field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/text) — full-text mapping.
- [Keyword field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword) — exact values and doc values.
- [Sort search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/sort-search-results) — sort behavior.
- [Aggregations](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations) — operations that read field values.
- Persian discovery search (not a verified article): [Persian articles on Elasticsearch doc values](https://www.google.com/search?q=Elasticsearch+doc+values+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

