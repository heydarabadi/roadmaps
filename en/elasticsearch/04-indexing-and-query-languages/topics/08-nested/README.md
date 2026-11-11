# Nested Fields

> Chapter 04: Indexing and Query Languages · Lesson 08

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/08-nested/README.md)

## Learning goals

- Preserve the relationship between fields in one element of an object array.
- Write a nested query and interpret its result.
- Understand the indexing and query cost of nested objects.

## Query one array member as a unit

The `nested` type indexes each object in an array as a separate hidden Lucene document associated with its parent. A nested query evaluates its inner conditions against the same nested child. This matters for offers, product variants, or order lines where the conjunction of properties must belong to one element.

~~~http
PUT /products-v1
{"mappings":{"properties":{"offers":{"type":"nested","properties":{
  "seller":{"type":"keyword"},"price":{"type":"double"}
}}}}}

POST /products-v1/_search
{"query":{"nested":{"path":"offers","query":{"bool":{"must":[
  {"term":{"offers.seller":"A"}},
  {"range":{"offers.price":{"lte":100}}}
]}}}}}
~~~

This query finds a product only if one offer from seller A has a price at or below 100. If seller A's offer costs 150 while seller B's offer costs 80, the product should not match. `inner_hits` can return which nested offer matched. The nested mapping must exist before indexing; changing an existing ordinary object field to nested generally requires a new index and reindex. Nested fields increase internal document count, so choose them only for required same-object semantics.

## Exercise

Index the two-offer example described above. Run the nested query, add an offer from seller A at 95, and observe the match. Use `inner_hits` to show the matching offer. Estimate how nested-object count changes compared with parent-document count.

## Quiz with answers

1. **What does the nested query guarantee?** Its inner conditions are evaluated against the same nested array element.
2. **Why is a regular object array insufficient for that guarantee?** Its fields are flattened and can match across separate elements.
3. **What is one way to inspect matching nested children?** Add `inner_hits` to the nested query.
4. **What is the main cost?** Additional internal documents and more complex queries, aggregations, and indexing.

## References and further reading

- [Nested field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/nested) — storage and mapping behavior.
- [Nested query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-nested-query) — same-object query semantics.
- [Nested inner hits](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/retrieve-inner-hits) — return matching child objects.
- [Object field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/object) — compare ordinary object behavior.
- [Mapping explosion troubleshooting](https://www.elastic.co/docs/troubleshoot/elasticsearch/mapping-explosion) — why nested is not a general remedy for field growth.
- Persian discovery search (not a verified article): [Persian nested-query articles](https://www.google.com/search?q=Elasticsearch+nested+query+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

