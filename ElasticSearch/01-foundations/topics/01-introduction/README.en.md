# Introduction

> Chapter 01: Foundations · Lesson 01

[Read the Persian version](README.md)

## Learning goals

- Explain what Elasticsearch is designed to do and where it belongs in an application.
- Trace a document from JSON ingestion through mapping, shards, refresh, search, scoring, and response reduction.
- Distinguish an index, document, shard, node, and cluster.

## Core idea

Elasticsearch is a distributed search and analytics engine built on Apache Lucene. It prepares documents so applications can retrieve text and structured records quickly, rank likely matches, and aggregate large result sets. It is commonly used as a search-oriented projection beside a transactional system such as PostgreSQL or SQL Server. That separation lets the source database own transactions and authoritative state while Elasticsearch serves retrieval workloads.

An index is a logical collection with settings and a mapping. Documents are JSON records. An index is split into primary shards, each a Lucene index that can live on a node. A cluster is a group of nodes. When a search arrives, Elasticsearch routes it to relevant shards; a coordinating node merges the shard-level results and returns the response.

## Follow one document

Imagine a product catalog. The application sends a product document. Its mapping says the title is analyzed text, price is numeric, and availability is boolean. Elasticsearch routes the write to a primary shard and copies it to configured replicas. Analysis turns title text into searchable terms; Lucene's inverted index maps those terms to documents. A refresh makes the new segment visible to search. A query is analyzed in a compatible way, matching documents are collected and scored, and shard results are merged.

~~~http
PUT /products-v1/_doc/sku-101
{"title":"Lightweight mechanical keyboard","price":89.99,"available":true}

POST /products-v1/_search
{"query":{"match":{"title":"mechanical keyboard"}}}
~~~

The example assumes a suitable mapping. A successful write is not the same as immediate search visibility: Elasticsearch is near real time, and visibility normally follows refresh. A direct GET by ID and a full-text search are separate operations with different access paths.

## Architecture in a real product

Keep prices, orders, permissions, or inventory decisions authoritative in the transactional system when those decisions require transactional guarantees. Publish changes to Elasticsearch through an outbox, change-data-capture pipeline, event stream, or controlled rebuild. Stable document IDs make retries easier to reason about. Reconciliation jobs detect drift, while a versioned index and alias can support a rebuild and cutover. Independent dual writes can leave the two systems inconsistent if one write succeeds and the other fails.

Elasticsearch is useful for catalog search, log and security investigation, observability, geospatial retrieval, aggregations, and semantic or hybrid search. It is not automatically a replacement for every relational database. Choose it when the retrieval and analysis features justify maintaining a search projection and its indexing pipeline.

## Hands-on exercise

1. Create a disposable index named `products-lab` with explicit fields for title, price, and availability.
2. Index three products with stable IDs.
3. Fetch one product with GET by ID, then search titles with a match query.
4. Explain why the two requests are different and when a newly written document becomes searchable.
5. Change a product in the source system and sketch how the change reaches the search index safely.

## Quiz with answers

1. **What is the difference between an index and a node?** An index is a logical collection of documents and settings; a node is a running Elasticsearch instance that can host shards and handle requests.
2. **Why can a successful write be absent from search for a short time?** Search visibility follows refresh, so indexing is near real time rather than immediately searchable by default.
3. **Why keep a transactional source of truth?** It owns authoritative updates and transaction semantics; Elasticsearch is usually a derived retrieval projection that can be rebuilt.
4. **Where should the title match and stock eligibility go?** The title normally contributes relevance in query context; stock eligibility is often a filter because it should constrain candidates without adding relevance score.

## References and further reading

- [Elasticsearch product documentation](https://www.elastic.co/docs/products/elasticsearch) — product concepts and capabilities.
- [Search approaches](https://www.elastic.co/docs/solutions/search/search-approaches) — choose a search pattern for a use case.
- [How Elasticsearch reads and writes documents](https://www.elastic.co/docs/deploy-manage/distributed-architecture/reading-and-writing-documents) — shard routing and distributed operations.
- [Elasticsearch index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics) — documents, mappings, settings, and shards.
- [Anyone.com customer story](https://www.elastic.co/customers/anyone) — a vendor-published account of migrating a search workload with 210 million records; treat the reported performance figures as that company's experience, not a universal benchmark.
- [Apache Lucene](https://lucene.apache.org/) — the search library underneath Elasticsearch.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

