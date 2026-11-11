# Object Fields

> Chapter 04: Indexing and Query Languages · Lesson 07

[Read the Persian version](README.md)

## Learning goals

- Represent hierarchical JSON with object fields.
- Understand how Elasticsearch flattens fields inside ordinary objects.
- Decide whether array members need `nested` semantics.

## Hierarchy and array correlation

An `object` field represents nested JSON properties and exposes them through dotted paths such as `seller.city`. For a single object this is convenient and efficient. Arrays of objects have an important caveat: ordinary object fields are flattened for indexing. A query may match a condition from one array element and another condition from a different element, creating a false positive when the application's logic requires both conditions to hold on one object.

~~~json
{"seller":{"name":"Example Store","city":"Tehran"}}
~~~

~~~json
{"variants":[{"color":"red","size":"small"},{"color":"blue","size":"large"}]}
~~~

If no query needs to preserve relationships between members, ordinary objects are usually simpler. If a query must prove that a specific variant is both red and small, map the array as `nested` and use a nested query. That incurs additional internal documents and query complexity. Do not choose nested simply because JSON contains a child object; choose it for same-element correlation.

## Exercise

Create a product with two variants: one red-small and one blue-large. Query for red-large using ordinary object semantics, then compare with a nested mapping. Explain why the result differs and which business rule is correct.

## Quiz with answers

1. **How is a path such as `seller.city` queried?** Use the dotted path for the mapped child field.
2. **What can go wrong with an array of ordinary objects?** Conditions can match across different array elements.
3. **When is an ordinary object enough?** When query logic does not need to bind multiple conditions to one array object.
4. **What does `nested` cost?** Extra Lucene documents and more involved queries and aggregations.

## References and further reading

- [Object field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/object) — object mapping behavior.
- [Nested field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/nested) — preserve relationships in arrays.
- [Nested query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-nested-query) — query nested objects.
- [Flattened field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/flattened) — alternative for arbitrary key-value objects.
- Persian discovery search (not a verified article): [Persian articles about object and nested mappings](https://www.google.com/search?q=Elasticsearch+object+nested+mapping+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

