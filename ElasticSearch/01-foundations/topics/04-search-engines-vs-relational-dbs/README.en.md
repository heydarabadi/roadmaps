# Search Engines vs. Relational Databases

> Chapter 01: Foundations · Lesson 04

[Read the Persian version](README.md)

## Learning goals

- Compare the primary jobs of a relational database and a search engine.
- Choose a system by access pattern and correctness needs rather than by record count alone.
- Explain why many systems keep a database of record and a separately maintained search index.

## The difference is the workload

A relational database is built for structured data, relationships, transactions, constraints, and authoritative updates. It is usually the right place to enforce that an order is paid once or that a customer's balance follows a business invariant. A search engine such as Elasticsearch builds data structures that make full-text retrieval, relevance ranking, faceting, and aggregations efficient. Both systems can filter and sort, but they optimize for different patterns and offer different consistency and operational trade-offs.

For example, a product page can read its canonical price from the commerce database while a catalog search uses Elasticsearch to find products by title, brand, features, and synonyms. Elasticsearch can return an ordered set of candidates; the application can then check live inventory or authorization against the authoritative service before making a consequential decision.

## A common dual-system design

~~~text
Product service / relational database
             |
     outbox, CDC, or events
             v
       indexer / pipeline
             |
             v
Elasticsearch search projection -> search UI
~~~

An outbox or change-data-capture pipeline reduces the risk of independent dual writes. Stable IDs, retries, version checks, a reconciliation process, and a rebuild plan make the projection maintainable. The trade-off is eventual propagation: a changed record may not appear in search instantly. If that delay is unacceptable for a decision, read from the source of truth or design a stronger coordination mechanism.

Do not migrate data to Elasticsearch simply because the dataset is large. Compare query shape, transaction requirements, relevance needs, update patterns, cost, and the team's ability to operate another stateful system. Elasticsearch can support structured and analytical workloads, but it does not automatically replace relational constraints and transaction workflows.

## Exercise and discussion

For an online store, classify these operations as database, search index, or both: charge a payment; find products matching a phrase; show a facet count by brand; reserve the last unit; retrieve products similar to a text description. Explain how you keep the index fresh and how the final checkout checks correctness.

## Quiz with answers

1. **Why not use Elasticsearch as the only source for an order payment?** A payment requires authoritative state and transaction/invariant handling; search indexing and retrieval serve a different role.
2. **Why might an application use both systems?** The database owns canonical transactional data while Elasticsearch provides relevance-oriented retrieval and aggregation.
3. **What is the risk in writing independently to both systems?** One write may succeed while the other fails, creating divergence unless recovery and reconciliation exist.
4. **Does a large dataset automatically justify Elasticsearch?** No. Query and consistency needs, indexing cost, operations, and measured performance determine fit.

## References and further reading

- [Search with Elasticsearch](https://www.elastic.co/docs/solutions/search) — search patterns and application use cases.
- [Elasticsearch index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics) — storage and index design concepts.
- [Reading and writing documents](https://www.elastic.co/docs/deploy-manage/distributed-architecture/reading-and-writing-documents) — distributed write and read behavior.
- [Anyone.com case study](https://www.elastic.co/customers/anyone) — an example of a company moving a search backend from PostgreSQL; the case is vendor-published and workload-specific.
- [Canals case study](https://www.elastic.co/customers/canals) — a vendor-published example of combining keyword and vector retrieval for catalog search.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

