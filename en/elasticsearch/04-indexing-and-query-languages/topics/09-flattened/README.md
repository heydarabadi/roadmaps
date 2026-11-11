# Flattened Fields

> Chapter 04: Indexing and Query Languages · Lesson 09

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/09-flattened/README.md)

## Learning goals

- Use `flattened` for objects with a large or unknown set of keyword-like keys.
- Avoid a separate mapping field for every arbitrary metadata key.
- Understand the type and query limitations of a flattened value.

## Bound flexible metadata

The `flattened` type maps an entire object as one field while allowing searches on its leaf keys. It is useful for metadata objects whose keys vary widely, such as vendor attributes or labels from many integrations. Without it, dynamic mapping may add a distinct field for every key and drive field-count growth.

~~~http
PUT /events-v1
{"mappings":{"properties":{"labels":{"type":"flattened"}}}}

POST /events-v1/_search
{"query":{"term":{"labels.environment":"production"}}}
~~~

Flattened leaves behave primarily like keyword values. They do not provide every typed feature of an independently mapped numeric, date, or analyzed text field. Do not store important range fields such as price or timestamp only inside `flattened` if they need numeric or date semantics. Promote frequently queried attributes to explicit fields and retain the long tail in the flexible object.

## Exercise

Index a document with hundreds of arbitrary metadata keys, then compare the mapping field count against an index that dynamically maps every key. Query one exact metadata value. Choose three metadata keys that deserve explicit typed mappings and justify the choice.

## Quiz with answers

1. **What problem does `flattened` address?** It prevents a large object with unknown keys from creating an individual mapping field for every key.
2. **What is a major limitation?** Leaf values do not have the full independent type behavior of explicitly mapped numeric, date, or analyzed fields.
3. **How should frequently used numeric values be modeled?** As explicit numeric fields when range or aggregation behavior is needed.
4. **Does `flattened` preserve arbitrary nested relational semantics?** No; it is a bounded key-value search representation, not a substitute for nested object modeling.

## References and further reading

- [Flattened field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/flattened) — supported searches and limitations.
- [Mapping explosion troubleshooting](https://www.elastic.co/docs/troubleshoot/elasticsearch/mapping-explosion) — when to consider flattened fields.
- [Dynamic mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/dynamic-mapping) — control automatic field creation.
- [Field data types](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/field-data-types) — compare typed fields.
- Persian discovery search (not a verified article): [Persian articles about flattened mapping](https://www.google.com/search?q=Elasticsearch+flattened+mapping+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

