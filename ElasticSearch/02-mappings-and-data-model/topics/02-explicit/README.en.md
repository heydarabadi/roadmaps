# Explicit Mapping

> Chapter 02: Mappings and Data Modeling · Lesson 02

[Read the Persian version](README.md)

## Learning goals

- Define known field types before the first production document arrives.
- Choose a policy for fields that are missing from the declared contract.
- Validate the effective mapping before deploying an index template or pipeline.

## Why explicit mapping matters

With explicit mapping, the team decides how stable fields should behave instead of allowing the first document to make the decision. For a product catalog, an SKU is usually exact-match `keyword`; a title is often `text` with a `keyword` subfield; price is numeric; `active` is boolean; and a timestamp is `date`. These choices should follow required queries and data contracts.

~~~http
PUT /products-v1
{"mappings":{"dynamic":"strict","properties":{
  "sku":{"type":"keyword"},
  "title":{"type":"text","fields":{"raw":{"type":"keyword"}}},
  "price":{"type":"scaled_float","scaling_factor":100},
  "active":{"type":"boolean"},
  "created_at":{"type":"date"}
}}}
~~~

`dynamic: strict` rejects a document that introduces an undeclared field. This is useful when the producer contract is controlled and schema drift should be caught quickly. `dynamic: false` leaves unknown fields out of the mapping while retaining them in `_source` by default; that can support gradual rollout but means unknown fields cannot be searched normally. A hybrid design explicitly maps core fields and allows a bounded set of dynamic fields through templates.

Test valid and invalid payloads before rollout. Retrieve the created mapping and compare it to the intended schema. For changes that affect existing indexed values, version the index and use a reindex/cutover plan. Do not rely on development examples as proof that production producer formats are consistent.

## Exercise

Write an explicit mapping for orders with ID, customer, status, monetary total, creation date, and line items. Decide how an unexpected property is handled. Submit one valid payload and one with a misspelled field, then explain the outcome for your selected policy.

## Quiz with answers

1. **What is the main benefit of explicit mapping?** Predictable field types and query behavior that can be reviewed before ingest.
2. **When is `dynamic: strict` appropriate?** When the input schema is controlled and unknown fields should fail fast rather than silently changing the index.
3. **How does `dynamic: false` differ?** It does not add unknown fields to the mapping; the values can remain in `_source` but are not normally indexed for search.
4. **How should a mapping change be released?** Test it, version templates and indices, reindex incompatible data, compare, then cut over deliberately.

## References and further reading

- [Explicit mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/explicit-mapping) — define a schema before ingest.
- [Dynamic mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/dynamic-mapping) — explicit, dynamic, and mixed approaches.
- [Dynamic field mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/dynamic-field-mapping) — field detection behavior.
- [Reindex API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/reindex-indices) — copy documents into a newly designed index.
- [Index templates](https://www.elastic.co/docs/manage-data/data-store/templates) — apply mappings consistently to future indices.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

