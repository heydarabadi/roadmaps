# Exists Query

> Chapter 05: Search Results and Maintenance · Lesson 09

[Read the Persian version](../../../../../fa/elasticsearch/05-search-results-and-maintenance/topics/09-exists-query/README.md)

## Learning goals

- Test whether a field has an indexed value.
- Distinguish a value in `_source` from a value available to search.
- Understand how nulls and mapping options affect existence.

## Indexed-value existence

The `exists` query checks whether Elasticsearch has an indexed value for a field. It does not simply test whether a JSON property appeared in the original payload. An explicit `null` or empty array usually does not create an indexed value. A mapping's `null_value` can make null represent a searchable term. `ignore_above`, malformed values, or fields that are not indexed can also make a value appear in `_source` without being searchable as expected.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must_not":[{"exists":{"field":"description"}}]}}}
~~~

This finds documents without an indexed description value. Test the field's actual mapping and edge cases rather than assuming missing, null, and empty string are identical. If the business domain distinguishes “not provided” from “intentionally blank,” model that meaning explicitly.

## Exercise

Index four documents: description omitted, `null`, empty string, and a real description. Run `exists`, then inspect `_source` and mapping settings. Explain any differences and decide how the API should represent unknown or blank content.

## Quiz with answers

1. **What does `exists` check?** Whether a field has an indexed value.
2. **Does a JSON property in `_source` always satisfy `exists`?** No. Mapping and indexing settings determine whether an indexed value exists.
3. **How do nulls normally behave?** A null alone usually has no indexed value unless mapping options such as `null_value` change that behavior.
4. **Can an empty string count as a value?** It can be indexed as a value, unlike null; verify actual mapping behavior.

## References and further reading

- [Exists query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-exists-query) — indexed-value semantics and edge cases.
- [`_source` field](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/mapping-source-field) — original document source.
- [Null value mapping parameter](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/null-value) — treat explicit null as a term.
- [Mapping options](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/mapping-params) — indexing and field behavior.
- Persian discovery search (not a verified article): [Persian Elasticsearch exists-query articles](https://www.google.com/search?q=Elasticsearch+exists+query+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

