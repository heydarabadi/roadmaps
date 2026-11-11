# Text Fields

> Chapter 04: Indexing and Query Languages · Lesson 05

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/05-text/README.md)

## Learning goals

- Explain how analyzers turn text into searchable terms.
- Use full-text queries for natural language.
- Add an exact-value multi-field when sorting or aggregating on the original value.

## Analyzed text

A `text` field is intended for full-text search. At indexing time, an analyzer can tokenize text, normalize case, remove or transform terms, and build the structures used to find documents. A `match` query runs query text through analysis as well, allowing words in a phrase to match indexed terms. A text field is not normally an exact string value suitable for sorting or terms aggregations.

~~~http
PUT /products-v1
{"mappings":{"properties":{"title":{"type":"text","fields":{"keyword":{"type":"keyword"}}}}}}

POST /products-v1/_search
{"query":{"match":{"title":"mechanical keyboard"}}}
~~~

Use `title.keyword` for exact matching or sorting when that behavior is required and the value length fits the keyword field limits. Choose the analyzer deliberately, especially for multilingual text. Check tokenization with the Analyze API before committing to a production mapping. Changing an analyzer for indexed content normally requires reindexing so existing values are rebuilt using the new analysis chain.

## Exercise

Index product titles with punctuation, diacritics, and mixed case. Compare a `match` query with an exact `term` query on the keyword multi-field. Inspect the tokens produced by your analyzer and explain why the query terms do or do not match.

## Quiz with answers

1. **What happens to text at indexing time?** An analyzer converts it into terms that are stored in search-oriented structures.
2. **Why is `match` a usual choice for natural-language text?** It analyzes the query text in a way compatible with the field's analysis.
3. **How can a title also be sortable?** Add a `keyword` multi-field and sort on that representation.
4. **What is a common migration need after changing analyzers?** Reindex documents so their existing indexed terms are rebuilt.

## References and further reading

- [Text field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/text) — full-text field behavior.
- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis) — analyzers and token streams.
- [Match query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-match-query) — analyzed search.
- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze) — inspect tokenization.
- [Create a custom analyzer](https://www.elastic.co/docs/manage-data/data-store/text-analysis/create-custom-analyzer) — compose tokenizers and filters.
- Persian discovery search (not a verified article): [ParsiAnalyzer](https://github.com/NarimanN2/ParsiAnalyzer) and [Persian Elasticsearch analysis articles](https://www.google.com/search?q=Elasticsearch+Persian+analysis+ParsiAnalyzer+%D9%85%D9%82%D8%A7%D9%84%D9%87).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


