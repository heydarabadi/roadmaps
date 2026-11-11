# Mapping Explosion

> Chapter 02: Mappings and Data Modeling · Lesson 04

[Read the Persian version](README.md)

## Learning goals

- Recognize how uncontrolled field creation can harm cluster operations.
- Trace high mapping cardinality back to the producer or data model that creates field names.
- Select a bounded representation for arbitrary metadata.

## The failure pattern

Mapping explosion means an index or family of indices accumulates too many distinct mapped fields. A common cause is accepting arbitrary keys from user input, vendor payloads, or log metadata and turning every key into a new property. Field metadata is distributed as part of cluster state; excessive growth can increase memory pressure, make cluster-state updates expensive, slow searches and indexing, and affect Kibana field discovery. Elasticsearch has a field limit as a guardrail, but simply raising that limit does not repair an unbounded schema.

~~~json
{"attributes":{
  "color":"black",
  "material":"metal",
  "seller_custom_93814":"value"
}}
~~~

If each seller ID becomes a new mapping field, the schema grows with the number of sellers. First ask whether each key needs independent search, sorting, or aggregation. Keep frequently queried attributes as explicit fields. Store variable key-value data in a bounded form, such as a `flattened` field, or retain fields only in `_source` when they do not need to be indexed. Dynamic templates can constrain known naming patterns.

Investigate field counts, mapping update errors, cluster logs, master-node heap, pending cluster tasks, and the producer that introduced the growth. Remediation may require correcting ingestion and reindexing into a clean mapping. Increasing the field limit should be an evidence-based choice, not the first response.

## Exercise

Inspect a sample event payload with arbitrary labels. Separate fields needed for filtering and aggregations from opaque metadata. Propose a bounded mapping and define an alert for unexpected growth in mapped fields.

## Quiz with answers

1. **Why are arbitrary field names risky?** Each unique name can create mapping metadata and cluster-state work.
2. **What is the first question to ask about each dynamic key?** Does the product truly need this key as an independently mapped and queryable field?
3. **Why is raising the limit not a root-cause fix?** The input may continue creating fields without bound and consume more cluster resources.
4. **What alternatives can keep dynamic metadata bounded?** A `flattened` field, key-value representation, strict/false dynamic behavior, or retaining unused values only in `_source`.

## References and further reading

- [Mapping explosion: troubleshooting and prevention](https://www.elastic.co/docs/troubleshoot/elasticsearch/mapping-explosion) — symptoms, causes, and recovery options.
- [Flattened field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/flattened) — map an object with many unknown keys as one field.
- [Dynamic mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/dynamic-mapping) — control creation of new fields.
- [Dynamic templates](https://www.elastic.co/docs/manage-data/data-store/mapping/dynamic-templates) — map fields based on bounded patterns.
- [Index field capabilities API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-field-caps) — inspect field types across indices.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

