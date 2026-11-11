# Lucene Query String

> Chapter 04: Indexing and Query Languages · Lesson 20

[Read the Persian version](README.md)

## Learning goals

- Read fielded text expressions using Lucene query-string syntax.
- Distinguish this parser syntax from Query DSL, KQL, and ES|QL.
- Avoid exposing unrestricted query syntax to untrusted users.

## Compact text syntax

The Elasticsearch `query_string` query parses an expression such as field names, boolean operators, phrases, ranges, and grouping into a search query. It can be convenient for expert search boxes and manual investigation. It is a parser language with reserved characters and syntax errors, not an ordinary literal string.

~~~text
title:(wireless headphones) AND available:true AND price:[0 TO 5000]
~~~

The expression depends on field mappings and parser rules. For a public search box, an unrestricted query string may let users add fields or operators beyond what the product intended, and unescaped special characters can cause errors. Prefer a structured Query DSL built by the application for known UI controls. If you intentionally offer expert syntax, document and validate the supported subset and handle parse errors clearly.

## Exercise

Translate the example into a bool query with a title match, availability filter, and numeric range filter. Try a title containing punctuation and compare error behavior. Decide which format belongs in a customer-facing product search field and why.

## Quiz with answers

1. **What is the query string query?** A text syntax parsed into an Elasticsearch query.
2. **How is it different from Query DSL?** Query string is compact textual syntax; Query DSL expresses a structured JSON tree.
3. **Why not pass arbitrary user text directly to it?** Users can introduce operators or unsupported syntax, creating unexpected behavior or parser errors.
4. **When is it useful?** Expert search or investigation interfaces where users intentionally need fielded syntax.

## References and further reading

- [Query string query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-query-string-query) — operators and parser behavior.
- [Simple query string query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-simple-query-string-query) — a more forgiving alternative with limited syntax.
- [Kibana Lucene query syntax](https://www.elastic.co/docs/explore-analyze/query-filter/languages/lucene-query-syntax) — search-bar usage.
- [Query DSL](https://www.elastic.co/docs/reference/query-languages/query-dsl) — structured alternative.
- Persian discovery search (not a verified article): [Persian Elasticsearch Lucene query-string articles](https://www.google.com/search?q=Elasticsearch+Lucene+query+string+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

