# Dynamic Mapping

> Chapter 02: Mappings and Data Modeling · Lesson 03

[Read the Persian version](../../../../../fa/elasticsearch/02-mappings-and-data-model/topics/03-dynamic/README.md)

## Learning goals

- Explain how Elasticsearch infers mappings for newly observed fields.
- Compare `true`, `false`, and `strict` dynamic behavior.
- Contain dynamic mapping to the fields where it is useful.

## How inference works

When Elasticsearch sees a field that is not in the current mapping, dynamic mapping can infer a type and add the field. That is convenient while exploring a new dataset, but it makes the first observed value important. If the first price arrives as the string `"4200000"`, the field may be mapped as text or keyword rather than numeric. A later numeric value can then conflict with the established mapping. Date detection can also classify a string based on a format that other producers do not follow.

The common dynamic settings are:

- `true`: add mappings for new fields.
- `false`: do not add new fields to the mapping; values can still appear in `_source`.
- `strict`: reject documents with fields that are not declared.

~~~http
PUT /events-v1
{"mappings":{"dynamic":"false","properties":{
  "@timestamp":{"type":"date"},"message":{"type":"text"}
}}}
~~~

Dynamic mapping is not inherently wrong. It is useful for controlled exploration and semi-structured data. Production systems often explicitly map core fields and constrain dynamic behavior for optional metadata. Use dynamic templates where predictable field-name patterns need predefined types. Validate the mapping produced from representative documents before relying on it.

## Exercise

Index two event examples where one producer sends `duration_ms` as a number and another sends it as a quoted string. Inspect what the initial mapping does. Recreate the index with an explicit numeric mapping and decide whether unknown fields should be rejected, ignored by mapping, or handled through a template.

## Quiz with answers

1. **What is the risk of dynamic mapping?** Initial payloads can cause unintended field types, while unbounded field names can grow the mapping.
2. **What does `dynamic: false` mean?** New fields do not become mapped fields; their values may remain in `_source`.
3. **What does `dynamic: strict` mean?** A document with an undeclared field is rejected.
4. **When can dynamic mapping be useful?** During exploration or for controlled optional fields with a deliberate policy and limited schema growth.

## References and further reading

- [Dynamic mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/dynamic-mapping) — behavior and configuration.
- [Dynamic field mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/dynamic-field-mapping) — inferred types and templates.
- [Mapping explosion troubleshooting](https://www.elastic.co/docs/troubleshoot/elasticsearch/mapping-explosion) — symptoms and prevention.
- [Date detection](https://www.elastic.co/docs/manage-data/data-store/mapping/dynamic-field-mapping#date-detection) — inferred date behavior.
- [Mapping in Elasticsearch](https://www.elastic.co/docs/manage-data/data-store/mapping) — combine explicit and dynamic mapping.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

