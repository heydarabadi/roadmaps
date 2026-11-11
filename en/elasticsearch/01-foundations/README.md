# Chapter 01: Foundations and Orientation

[Read the Persian chapter guide](../../../fa/elasticsearch/01-foundations/README.md)

## Learning goals

By the end of this chapter, you should be able to explain the role of Elasticsearch, read its JSON-based REST requests, distinguish search retrieval from transactional database operations, describe the Elastic Stack at a high level, and decide whether a use case needs a search index.

## Chapter thesis

Elasticsearch is a distributed, Lucene-based search and analytics engine. Applications send JSON documents through APIs; mappings describe how fields should be indexed; shards distribute the index; refresh makes recent writes searchable; and queries retrieve and rank matches. In many architectures Elasticsearch is a derived search projection beside a transactional source of truth. That architecture is useful only when the search and analytics capabilities justify the work of synchronizing, monitoring, backing up, and rebuilding the projection.

## Concept map

~~~text
Business source of truth -> event/CDC/outbox -> Elasticsearch index
                                                   |
              JSON + mapping -> shards/Lucene -> refresh -> query/rank
                                                   |
                                               REST response -> app/UI

Elastic Stack: Elasticsearch (store/search) + Kibana (explore/manage)
               + optional Elastic Agent, Logstash, ingest pipelines, etc.
~~~

## Study sequence

1. [Introduction](topics/01-introduction/README.en.md) — the engine, index/document/shard/node vocabulary, and document lifecycle.
2. [JSON](topics/02-json/README.en.md) — payload types, arrays, nulls, and the role of mappings.
3. [REST API Basics](topics/03-rest-api-basics/README.en.md) — methods, endpoint paths, request bodies, and error handling.
4. [Search Engines vs. Relational Databases](topics/04-search-engines-vs-relational-dbs/README.en.md) — workload fit and the derived-index pattern.
5. [The Elastic Stack](topics/05-the-elk-stack/README.en.md) — ingestion, storage, exploration, and visualization components.
6. [Elasticsearch Use Cases](topics/06-elasticsearch-usecases/README.en.md) — choosing and measuring a search workload.

## End-to-end practice

Build a disposable catalog index with explicit field types. Add three products with stable IDs, retrieve one by ID, then run full-text search with a structured availability filter. Change a product in a separate source-of-truth model and sketch how an outbox or CDC event updates the search projection. Record one freshness objective and one search-quality metric. Do not use the example index for real customer or payment decisions.

## Architecture decisions and common traps

| Decision | Good fit | Main risk |
| --- | --- | --- |
| Keep a database as source of truth and Elasticsearch as a projection | Search relevance is needed while transactional invariants remain in the database | Stale or divergent projection without retries and reconciliation |
| Use an explicit mapping | Stable production fields and predictable query semantics | Up-front design and reindexing when a field's type is wrong |
| Send direct writes to Elasticsearch | Small, controlled workflows or a deliberately authoritative search store | Uncoordinated dual writes and unsafe retry behavior |
| Add Logstash or another ingestion layer | Many source formats, enrichment, routing, or buffering needs | Extra moving parts and another system to monitor |

Common mistakes include treating an index as a relational table, assuming valid JSON guarantees a good schema, relying on an immediate search after every write, putting exact filters in relevance-scoring clauses, and installing every Elastic component by default.

## Chapter quiz

1. Why is a search index usually treated as a projection rather than the source of truth?
2. What does a refresh change, and why does it have a cost?
3. Why is a stable mapping important when fields are queried, sorted, or aggregated?
4. How does a bulk request response differ from a simple all-or-nothing transaction?
5. For a catalog, which conditions normally influence relevance and which define eligibility?

**Answer key:** (1) The transactional system owns canonical updates and invariants; the index can be rebuilt. (2) It exposes recent writes to search and creates searchable segments; frequent forced refreshes can harm indexing and search efficiency. (3) Field type controls indexing and query semantics. (4) Individual bulk items can succeed or fail independently. (5) Text matching can affect score; availability, permissions, and hard price limits usually belong in filters.

## References

- [Elasticsearch product documentation](https://www.elastic.co/docs/products/elasticsearch)
- [The Elastic Stack](https://www.elastic.co/docs/get-started/the-stack)
- [Elasticsearch index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics)
- [Search with Elasticsearch](https://www.elastic.co/docs/solutions/search)
- [Apache Lucene](https://lucene.apache.org/)
- [Anyone.com customer story](https://www.elastic.co/customers/anyone) — vendor-published case study; reported figures are workload-specific.
