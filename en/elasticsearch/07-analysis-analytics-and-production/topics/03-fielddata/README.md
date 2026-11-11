# Fielddata

> Chapter 07: Analysis, Analytics, and Production · Lesson 03

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/03-fielddata/README.md)

## Learning goals

- Understand why fielddata exists for analyzed text.
- Recognize its JVM heap and garbage-collection risks.
- Prefer a keyword multi-field for common exact sorting and aggregation needs.

## Why fielddata can be expensive

Text fields are designed for full-text retrieval using the inverted index. To sort or aggregate on analyzed text, Elasticsearch can load fielddata into JVM heap. That can consume substantial memory, especially when many documents or high-cardinality terms are involved, increasing garbage collection pressure or causing memory failures.

~~~json
{"properties":{"title":{"type":"text","fields":{"keyword":{"type":"keyword"}}}}}
~~~

For common use cases, query `title` with full-text search and use `title.keyword` for exact sorting or terms aggregation. Enabling fielddata just to bypass a mapping mistake is usually not the right first fix. There are specialized cases where token-level aggregation is intentional; if so, measure heap usage, cardinality, and concurrent demand, then apply safeguards.

## Exercise

On a disposable cluster, compare an aggregation over a keyword subfield with fielddata on text using representative data. Monitor heap and garbage collection. Explain which terms each aggregation counts and whether the result matches the business question.

## Quiz with answers

1. **What is fielddata used for?** It loads analyzed text terms into memory so operations such as sorting or aggregation can use them.
2. **What is its primary operational risk?** High JVM heap consumption and garbage-collection pressure.
3. **What is the common alternative?** A keyword multi-field with doc values for exact-value sorting or aggregation.
4. **When could fielddata be justified?** When token-level operations are explicitly required, measured, and resource impact is controlled.

## References and further reading

- [Fielddata mapping parameter](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/fielddata) — behavior and configuration.
- [Text field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/text) — fielddata considerations.
- [Doc values](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/doc-values) — column-oriented alternative for supported types.
- [Keyword field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword) — exact terms for aggregation and sort.
- [Circuit breakers](https://www.elastic.co/docs/reference/elasticsearch/configuration-reference/circuit-breaker-settings) — protect nodes from memory-intensive operations.
- Persian discovery search (not a verified article): [Persian fielddata and heap articles](https://www.google.com/search?q=Elasticsearch+fielddata+heap+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

