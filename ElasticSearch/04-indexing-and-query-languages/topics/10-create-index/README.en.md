# Create an Index

> Chapter 04: Indexing and Query Languages · Lesson 10

[Read the Persian version](README.md)

## Learning goals

- Create an index with settings and mappings before indexing production data.
- Know which settings are fixed at creation and which can be changed later.
- Use versioned names and templates for reproducible index design.

## Define the container before data arrives

The Create Index API creates a named index and can define settings, mappings, aliases, and analysis components. Declare important field types before ingest so the first document does not accidentally decide the schema. Primary shard count is an architectural choice made at index creation; replica count and some other settings can be adjusted later. For recurring indices, use index templates so each new index starts with the intended mappings and policy.

~~~http
PUT /products-v1
{"settings":{"number_of_shards":1,"number_of_replicas":0},
 "mappings":{"dynamic":"strict","properties":{
   "product_id":{"type":"keyword"},"title":{"type":"text"},"price":{"type":"long"}
 }}}
~~~

The shard and replica values above are appropriate only for a simple local lab. Production settings depend on capacity and failure objectives. A repeatable deployment should check whether the index already exists, apply a known template or migration, and verify the resulting mapping. Do not create a production index using guessed defaults when its ingest and search contract is known.

## Exercise

Extend the example with a keyword brand, boolean availability, and date field. Create a template for future monthly indices and verify it with an index name that matches the template. Record the effective settings and mappings.

## Quiz with answers

1. **What can a Create Index request define?** Settings, mappings, aliases, and analysis configuration.
2. **Why declare a mapping before ingest?** It avoids accidental inference from the first observed document and makes query behavior explicit.
3. **Why are example shard settings not universal?** Data size, hardware, load, availability, and recovery goals differ.
4. **How can recurring indices get consistent schemas?** Use a composable index template that matches their names or data stream.

## References and further reading

- [Create index API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-create) — settings, mapping, and aliases.
- [Mapping](https://www.elastic.co/docs/manage-data/data-store/mapping) — field contract.
- [Index templates](https://www.elastic.co/docs/manage-data/data-store/templates) — apply reusable settings and mappings.
- [Shard sizing guidance](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/size-shards) — choose a shard strategy.
- [Index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics) — index components and design choices.
- Persian discovery search (not a verified article): [Persian create-index articles](https://www.google.com/search?q=Elasticsearch+create+index+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


