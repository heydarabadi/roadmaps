# Index (Database Analogy)

> Chapter 02: Mappings and Data Modeling · Lesson 07

[Read the Persian version](../../../../../fa/elasticsearch/02-mappings-and-data-model/topics/07-index-database/README.md)

## Learning goals

- Understand an index as a logical collection of similarly modeled documents.
- Use aliases to give applications a stable name while physical indices change.
- Recognize when a data stream fits append-oriented, time-based data.

## What an index is

An index is a named collection of documents with shared mapping and settings. It may feel similar to a relational table at first, but it is not a transactional database table with the same joins, constraints, and update semantics. Elasticsearch divides an index into primary shards, and shard count influences parallelism, overhead, and recovery. Choose the index layout from data lifecycle and query patterns.

~~~http
PUT /products-v1
{"mappings":{"properties":{"sku":{"type":"keyword"},"title":{"type":"text"}}}}

POST /_aliases
{"actions":[{"add":{"index":"products-v1","alias":"products"}}]}
~~~

The application can target the stable alias `products` while operators prepare `products-v2`. Aliases can switch reads, and carefully configured write aliases support controlled cutovers. This makes rebuilds and schema migrations easier without teaching every client about physical index names. For append-oriented time-series records, data streams manage a sequence of backing indices and can work with lifecycle policies.

Deleting an index deletes its documents and metadata. Before destructive actions, verify the cluster and exact target, and ensure the data is recoverable. A search index should be rebuildable from a durable source unless the architecture explicitly makes it authoritative.

## Exercise

Create a `catalog-v1` index and a `catalog` alias. Create `catalog-v2`, compare mappings, and perform an atomic alias action that switches the alias. Explain how you would prevent writes from being lost during the rebuild.

## Quiz with answers

1. **Is an Elasticsearch index a relational database?** No. It is a logical search collection with mappings and shards, not a full transaction-and-constraint model.
2. **Why use aliases?** They decouple application names from physical index versions and support controlled cutover or reindexing.
3. **When might a data stream be useful?** For append-oriented time-series data managed as rolling backing indices.
4. **What must be checked before deleting an index?** Exact target and environment, dependencies, recovery source, and backup/rebuild plan.

## References and further reading

- [Elasticsearch index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics) — what an index contains.
- [Aliases](https://www.elastic.co/docs/manage-data/data-store/aliases) — stable names and cutover operations.
- [Create index API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-create) — create settings and mappings.
- [Data streams](https://www.elastic.co/docs/manage-data/data-store/data-streams) — append-oriented time-series indices.
- [Anyone.com case study](https://www.elastic.co/customers/anyone) — an example of a large production search index and a search migration.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

