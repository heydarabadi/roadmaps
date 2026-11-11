# Elasticsearch Use Cases

> Chapter 01: Foundations · Lesson 06

[Read the Persian version](../../../../../fa/elasticsearch/01-foundations/topics/06-elasticsearch-usecases/README.md)

## Learning goals

- Recognize workloads where search and analytics capabilities add value.
- Map a product requirement to lexical, structured, geospatial, vector, or time-series retrieval.
- Evaluate operational costs, freshness, and quality with a representative benchmark.

## Where it fits

Elasticsearch can power website and documentation search, ecommerce catalogs, log investigation, security analytics, observability tools, geospatial search, recommendations, and retrieval for question-answering systems. These use cases share a need to find and explore records quickly, but they do not all use the same schema or query technique.

For a catalog, an analyzed `title` can support full-text relevance, a `brand` keyword can support exact filters and facets, a numeric `price` can support ranges, and `location` can support distance queries. For logs, timestamp and service fields support time filtering and aggregations. For semantic retrieval, an embedding field can find conceptually similar content. Hybrid search combines lexical and vector signals when each contributes useful matches.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"quiet wireless headphones"}}],
  "filter":[{"term":{"available":true}},{"range":{"price":{"lte":150}}}]}}}
~~~

The text clause can influence relevance; availability and budget usually define eligibility. Search quality still needs measurement. Build a set of representative queries and judged relevant results. Track metrics such as recall@k, precision@k, NDCG, zero-result rate, latency percentiles, and index freshness. A demo that looks good on a few hand-picked queries is not evidence of production quality.

## Choose and validate a use case

Start with user intent, data volume and change rate, query distribution, latency and freshness targets, access-control rules, and retention needs. Estimate the extra ingestion pipeline, mappings, monitoring, backups, upgrades, and cost of maintaining a derived index. Test on representative data and hardware. A search engine is useful when its search capabilities justify that lifecycle.

## Exercise

Choose one: documentation search, product catalog, application logs, or nearby services. Define one mapping field for each important requirement, write three realistic queries, and choose two quality and two operational metrics. Explain which system remains authoritative for updates.

## Quiz with answers

1. **Which field type usually supports exact brand filters and terms facets?** A keyword-like exact-value field.
2. **Which clause should usually express whether a product is in stock?** A filter clause, because stock is eligibility rather than a relevance signal.
3. **How do you know whether a search design is good?** Evaluate representative judged queries and operational metrics such as relevance, latency, and freshness.
4. **Does semantic search eliminate lexical search?** No. Exact identifiers, names, and rare terms can work better lexically; hybrid retrieval can combine complementary signals.

## References and real-world examples

- [Search with Elasticsearch](https://www.elastic.co/docs/solutions/search) — supported search application patterns.
- [Search approaches](https://www.elastic.co/docs/solutions/search/search-approaches) — full-text, vector, semantic, and hybrid options.
- [Canals customer story](https://www.elastic.co/customers/canals) — reported improvement in top-three product-search accuracy using keyword and vector retrieval; results are specific to that dataset and evaluation.
- [Anyone.com customer story](https://www.elastic.co/customers/anyone) — migration of a large property-listing search workload.
- [Elastic customer stories](https://www.elastic.co/customers/) — additional vendor-published deployment examples.
- [Lucene](https://lucene.apache.org/) — foundational search library and resources.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

