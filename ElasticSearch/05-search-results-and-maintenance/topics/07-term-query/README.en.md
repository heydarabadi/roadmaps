# Term Query

> Chapter 05: Search Results and Maintenance · Lesson 07

[Read the Persian version](README.md)

## Learning goals

- Use `term` for exact indexed values.
- Choose fields whose mappings support exact-value matching.
- Avoid using a term query as a full-text search over analyzed text.

## Match the indexed term

A `term` query searches for an exact term and does not analyze the query string as natural language. It is useful for `keyword`, numeric, boolean, or other exact-value fields. It is usually wrong for a `text` field where an analyzer has split and normalized the original value.

~~~http
POST /products-v1/_search
{"query":{"term":{"status":"active"}}}
~~~

If a keyword normalizer is configured, the indexed value may be normalized, and query behavior should be checked against that mapping. For an exact SKU, map the field as keyword. For a title, use `match` on its text representation; if exact title equality is also needed, query its keyword multi-field. Use a term filter for hard eligibility rather than scoring when appropriate.

## Exercise

Index a document with `title` mapped as text and `title.keyword` as a multi-field. Run the same term query against both, then run a match query against `title`. Explain the difference using the Analyze API output.

## Quiz with answers

1. **Which fields commonly suit `term`?** Keyword, numeric, boolean, and other exact-value fields.
2. **Why can `term` on text miss an expected phrase?** The indexed text may have been tokenized and normalized, while the term query does not analyze the whole phrase.
3. **What query should search natural-language text?** Usually a full-text query such as `match`.
4. **Can a normalizer affect exact keyword matching?** Yes; configure and test how values are normalized.

## References and further reading

- [Term query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-term-query) — exact term matching and caveats.
- [Keyword field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword) — exact-value mapping.
- [Text field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/text) — analyzed full text.
- [Match query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-match-query) — full-text alternative.
- [Normalizers](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/normalizer) — normalize keyword terms.
- Persian discovery search (not a verified article): [Persian Elasticsearch term-query guides](https://www.google.com/search?q=Elasticsearch+term+query+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

