# Kibana Query Language (KQL)

> Chapter 04: Indexing and Query Languages · Lesson 19

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/19-kql/README.md)

## Learning goals

- Write simple field filters in Kibana Query Language.
- Use the mapped field type to understand exact, text, and range behavior.
- Distinguish KQL from Query DSL and from the Lucene query-string syntax.

## A filter language for Kibana

KQL is used in Kibana interfaces such as Discover to filter documents with concise expressions. It supports field-oriented conditions such as `status: 200`, ranges, and boolean combinations. Kibana translates the expression into Elasticsearch queries, but KQL itself is not a JSON request body and does not define aggregations or every Search API feature.

~~~text
status: 200 and response: "success" and bytes > 1000
~~~

The result depends on field mappings and the Kibana data view. An exact `keyword` field, analyzed `text` field, numeric value, and date range can have different matching semantics. Use the field list and sample documents to validate the filter. For application APIs, construct Query DSL requests with the official client rather than sending a KQL expression as though it were the REST query body.

## Exercise

In Kibana Discover, filter events by status, response text, and a numeric byte threshold. Translate the same logic into `bool.filter` Query DSL and compare the visible document set. Change a field mapping in a lab to see how its matching behavior is affected.

## Quiz with answers

1. **Where is KQL primarily used?** Kibana interfaces for filtering and exploring documents.
2. **Is KQL the same as Query DSL?** No. KQL is a concise UI expression; Query DSL is the JSON API query structure.
3. **Why does mapping affect KQL?** KQL expressions are translated against actual fields and their indexed types.
4. **Can KQL express every aggregation or application search feature?** No. It is intended for filtering, not the full Search API.

## References and further reading

- [Kibana Query Language](https://www.elastic.co/docs/reference/query-languages/kql) — syntax and operators.
- [KQL field filters](https://www.elastic.co/docs/reference/query-languages/kql/kql-field-filters) — matching and range examples.
- [Kibana Discover](https://www.elastic.co/docs/explore-analyze/discover) — search and inspect documents.
- [Query DSL](https://www.elastic.co/docs/reference/query-languages/query-dsl) — API query counterpart.
- [Lucene query syntax in Kibana](https://www.elastic.co/docs/explore-analyze/query-filter/languages/lucene-query-syntax) — compare another search-bar language.
- Persian discovery search (not a verified article): [Persian KQL and Kibana query articles](https://www.google.com/search?q=Kibana+KQL+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

