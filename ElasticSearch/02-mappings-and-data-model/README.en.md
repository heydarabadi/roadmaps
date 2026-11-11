# Chapter 02: Mappings and Data Modeling

[Read the Persian chapter guide](README.md)

## Learning goals

- Design mappings from search and analytics requirements before ingesting production data.
- Control how known, unknown, and dynamic fields are handled.
- Model indices, documents, IDs, nodes, and clusters accurately.
- Run a safe learning environment and use Kibana Console to inspect API behavior.

## Chapter thesis

A mapping is an operational contract: it determines how each document field is interpreted and which retrieval operations are efficient and meaningful. Dynamic mapping can accelerate discovery, but unrestricted inferred fields and unstable producer types can damage the schema. Explicit mapping, constrained dynamic templates, deliberate index versioning, and bounded representations for arbitrary metadata make behavior easier to review. Elasticsearch's index and node vocabulary has useful analogies to relational systems, but those analogies are not identity: an index is not a transactional database, a document is not a relational row, and an `_id` is not a universally unique business key.

## Concept map

~~~text
Search requirements -> field types + analysis -> mapping contract
       |                                      |
explicit / dynamic / templates      nested / flattened / multi-fields
       |                                      |
versioned index <- reindex + alias cutover <- schema evolution

cluster = coordinated nodes; node hosts shards; document has an _id
~~~

## Study sequence

1. [Mappings](topics/01-mappings/README.en.md) — field behavior and query requirements.
2. [Explicit Mapping](topics/02-explicit/README.en.md) — declare types and reject or constrain drift.
3. [Dynamic Mapping](topics/03-dynamic/README.en.md) — understand inference and select a policy.
4. [Mapping Explosion](topics/04-mapping-explosion/README.en.md) — diagnose and prevent unbounded field growth.
5. [Cluster](topics/05-cluster-system/README.en.md) — shared state, health, and shard allocation.
6. [Node](topics/06-node-instance/README.en.md) — roles, resources, and bottleneck diagnosis.
7. [Index](topics/07-index-database/README.en.md) — logical collections, aliases, and data streams.
8. [Document](topics/08-document-row/README.en.md) — retrieval-oriented shape and denormalization.
9. [Document ID](topics/09-id-primary-key/README.en.md) — stable identity and retry semantics.
10. [Docker](topics/10-running-with-docker/README.en.md) — version-pinned local lab and persistence.
11. [Elastic Cloud](topics/11-elastic-cloud/README.en.md) — managed deployments and continuing application responsibilities.
12. [Kibana Console](topics/12-kibana-console/README.en.md) — interactive API practice.

## Applied lab: evolve a catalog mapping

Start with an explicit mapping for SKU, title, price, availability, brand, and seller attributes. Use a title multi-field if both text search and exact sorting are required. Decide how unknown top-level fields behave. Add a product with stable ID. Then introduce a versioned mapping change by creating `products-v2`, replaying source data, validating document counts and representative queries, and switching a stable alias. During reindexing, define how concurrent changes will be replayed so the new index does not miss updates.

## Design decisions and pitfalls

| Choice | Use it when | Watch for |
| --- | --- | --- |
| Explicit mapping | Field semantics are known and production behavior must be stable | Incorrect existing field types require a new index and data migration |
| Dynamic mapping | Exploring or handling a controlled, limited set of optional fields | First-value inference and unbounded field creation |
| `nested` | Correlated conditions must match the same object in an array | More internal documents, query cost, and aggregation complexity |
| `flattened` | Arbitrary object keys need bounded indexing for simple lookups | It does not behave exactly like independently typed fields |
| Alias cutover | Applications need a stable name during rebuilds | Write continuity and replay must be planned |
| Single-node Docker | Local learning and disposable examples | No high availability; volume is not a backup |

## Chapter quiz

1. Your first product document sends `price` as a string. What could dynamic mapping do, and why does this matter?
2. A nested array query requires `color=red` and `size=large` on the same variant. Which mapping behavior preserves that relationship?
3. Why should an application use a stable alias rather than hard-code each versioned index name?
4. What does yellow cluster health mean, and how should an operator diagnose it?
5. Why does reindexing require a plan for writes that happen during the copy?
6. What is the difference between `_source` and a field's indexed representation?

**Answer key:** (1) It may infer a nonnumeric type from the first value, making range and aggregation behavior wrong or incompatible. (2) Use `nested` queries for same-object correlation. (3) Alias switching decouples clients from physical index versions. (4) Primaries are assigned but some replicas are not; inspect allocation explanations and capacity. (5) A plain copy can miss concurrent updates unless writes are paused, dual-written carefully, or replayed. (6) `_source` preserves original JSON by default; index structures are built for query, sort, or aggregation behavior.

## References

- [Mapping in Elasticsearch](https://www.elastic.co/docs/manage-data/data-store/mapping)
- [Mapping explosion troubleshooting](https://www.elastic.co/docs/troubleshoot/elasticsearch/mapping-explosion)
- [Elasticsearch index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics)
- [Aliases](https://www.elastic.co/docs/manage-data/data-store/aliases)
- [Cluster architecture](https://www.elastic.co/docs/deploy-manage/distributed-architecture)
- [Elasticsearch with Docker](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-with-docker)
