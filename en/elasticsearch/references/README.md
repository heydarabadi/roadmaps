# Elasticsearch Reference Library

[Read the Persian version](../../../fa/elasticsearch/references/README.md) · [Return to the course](../README.md)

This library collects direct references alongside the lessons. Current official English documentation is the source of truth for version-specific syntax and behavior. Persian articles and courses can help explain ideas, but check their publication date and Elasticsearch version. Customer metrics are publisher-reported results for a particular workload, not guarantees for another system.

## Persian-language references

| Resource | Coverage and use | Limitation |
|---|---|---|
| [Advanced Elasticsearch search on Codity](https://codity.ir/advanced-search-training-with-elasticsearch/) | Persian introduction to Query DSL, `match`, and combining `bool` and `filter` | A short secondary introduction; verify JSON and query semantics against current official docs. |
| [Why Persian search can fail in Elasticsearch](https://virgool.io/@technotesai/%DA%86%D8%B1%D8%A7-%D8%AC%D8%B3%D8%AA%D8%AC%D9%88%DB%8C-%D9%81%D8%A7%D8%B1%D8%B3%DB%8C-%D8%AF%D8%B1-elasticsearch-%D8%AF%D8%B1%D8%B3%D8%AA-%DA%A9%D8%A7%D8%B1-%D9%86%D9%85%DB%8C-%DA%A9%D9%86%D8%AF-%D9%88-%DA%86%D8%B7%D9%88%D8%B1-%D8%AF%D8%B1%D8%B3%D8%AA%D8%B4-%DA%A9%D9%86%DB%8C%D9%85-dfsaaev7zebh) | Practical normalization, Arabic/Persian characters, digits, half-spaces, synonyms, and BM25 for a Persian catalog | The author says the configuration was used in production, but it has not been independently evaluated. Test ZWNJ, stopword, and BM25 choices with judged queries. |
| [Virgool's move from MySQL to Elasticsearch — aggregation story](https://virgool.io/virgool/%D8%A7%D8%B2-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-mysql%D8%A7%DB%8C-%D8%A8%D9%87-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-elasticsearch%D8%A7%DB%8C-%D9%82%D8%B3%D9%85%D8%AA-%DB%B2-%D8%A2%D9%85%D8%A7%D8%B1-bzx5mj16lcqb) | Engineering-team account of moving part of Virgool's analytics/search workload to Elasticsearch | About seven years old; useful for decision context, not current versions, APIs, or design choices. |
| [Virgool's backup follow-up](https://virgool.io/virgool/%D8%A7%D8%B2-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-mysql%D8%A7%DB%8C-%D8%A8%D9%87-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-elasticsearch%D8%A7%DB%8C-%D9%82%D8%B3%D9%85%D8%AA-%DB%B3-%D8%A2%D8%AE%D8%B1%D8%A7%DB%8C-%D8%AF%D8%A7%D8%B3%D8%AA%D8%A7%D9%86-y9ioyntxpjue) | The same experience with a focus on backups | Old; compare it with current snapshot and restore docs and perform a recovery drill. |
| [Basalam's dynamic commission rules with Percolate](https://virgool.io/%D8%B1%D8%A7%D9%87%DA%A9%D8%A7%D8%B1-%D9%81%D9%86%DB%8C-%D9%85%D9%82%DB%8C%D8%A7%D8%B3-%D9%BE%D8%B0%DB%8C%D8%B1-%D8%A8%D8%B1%D8%A7%DB%8C-%D9%BE%D8%B4%D8%AA%DB%8C%D8%A8%D8%A7%D9%86%DB%8C-%D8%A7%D8%B2-%D9%BE%D9%88%DB%8C%D8%A7%DB%8C%DB%8C-%DA%AF%D8%B3%D8%AA%D8%B1%D8%AF%D9%87-%DB%8C-%D8%B3%DB%8C%D8%B3%D8%AA%D9%85-%DA%A9%D9%85%DB%8C%D8%B3%DB%8C%D9%88%D9%86-%D8%A8%D8%A7%D8%B3%D9%84%D8%A7%D9%85-percolate-%D8%AF%D8%B1-elasticsearch-flsw9db3da3l) | Persian engineering account of evaluating stored Percolator rules against order data | Practitioner account; use official Percolator docs for API details and current support. |
| [Persian Docker guide for Elastic Stack](https://virgool.io/%40hadivarposhti/%D8%B1%D8%A7%D9%87%D9%86%D9%85%D8%A7%DB%8C-%D9%86%D8%B5%D8%A8-%D9%88-%D9%BE%DB%8C%D8%A7%D8%AF%D9%87-%D8%B3%D8%A7%D8%B2%DB%8C-%D8%A7%D9%84%D8%B3%D8%AA%DB%8C%DA%A9-%D8%A7%D8%B3%D8%AA%DA%A9-elk-%D8%A8%D8%A7-%DA%A9%D9%85%DA%A9-%D8%AF%D8%A7%DA%A9%D8%B1-qg3gppvfsh3q) | Hands-on account of bringing up ELK with Docker | Several years old; verify image tags, security, and settings against current releases. |
| [Connecting Elasticsearch with Laravel on Virgool](https://virgool.io/%40vahiiiid/%D8%A8%D9%87%D8%AA%D8%B1%DB%8C%D9%86-%D8%B1%D9%88%D8%B4-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D8%A7%D9%84%D8%B3%D8%AA%DB%8C%DA%A9-%D8%B3%D8%B1%DA%86-%D8%AF%D8%B1-%D9%84%D8%A7%D8%B1%D8%A7%D9%88%D9%84-ncuxvjeilqcl) | Client and synchronization approaches for Laravel | Old and framework-specific; recheck client dependencies and compatibility before use. |
| [TopLearn beginner Elasticsearch course](https://toplearn.com/c/6112) | Persian video course; its published feed includes aggregations such as `cardinality` | Availability and lesson access depend on the site/account; it is not a versioned API reference. |
| [EngineDevOps Elasticsearch and ELK course](https://enginedevops.com/product/آموزش-جامع-elasticsearch) | Persian syllabus spans clusters, shards, bulk, analyzers, inverted indexes, and queries | The page marks some lessons private; it is not a versioned manual. |
| [Nadinsoft Persian introduction and installation article](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/) | Historical orientation to Elasticsearch and the Elastic Stack | Published in 2021; its installation instructions are dated. |
| [ParsiAnalyzer project](https://github.com/NarimanN2/ParsiAnalyzer) | Persian tokenization, normalization, half-spaces, digits, and stemming | Its README shows an Elasticsearch 7.13.1 installation. Do not install it on a newer release without a compatible build and tests. |
| [Another Persian analyzer project](https://github.com/mlkmhd/persian-analyzer-elasticsearch) | Small codebase for comparing Persian analyzer approaches | Small, low-activity repository; use as a conceptual sample, not a supported plugin. |
| [Hazm Persian NLP toolkit](https://github.com/roshan-research/hazm) | Persian normalization, tokenization, and language processing for preparing or evaluating text | It is not an Elasticsearch plugin. Apply any external preprocessing consistently at index and query time. |

### Optional Persian videos

- [Elasticsearch introduction by Bit Code](https://www.youtube.com/watch?v=FpNBpBLodXA) — introductory overview; published in 2023.
- [Persian Elasticsearch analyzer lesson](https://www.youtube.com/watch?v=SxI7jPMolKg) — analyzer implementation example; check the version used in the video.
- [Persian Elasticsearch Query DSL lesson](https://www.youtube.com/watch?v=4ylKAaBXHEc) — query practice; compare newer APIs with the current reference.

## Official English documentation by chapter

### Chapter 1 — Foundations

- [Elasticsearch documentation](https://www.elastic.co/docs/products/elasticsearch)
- [Elasticsearch concepts](https://www.elastic.co/guide/en/elasticsearch/reference/current/elasticsearch-intro.html)
- [Distributed nature and architecture](https://www.elastic.co/guide/en/elasticsearch/reference/current/scalability.html)
- [REST API conventions](https://www.elastic.co/guide/en/elasticsearch/reference/current/rest-apis.html)
- [Elastic Stack overview](https://www.elastic.co/what-is/elk-stack)

### Chapter 2 — Mappings and data modeling

- [Mapping](https://www.elastic.co/docs/manage-data/data-store/mapping)
- [Dynamic mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/dynamic-mapping)
- [Explicit mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/explicit-mapping)
- [Field data types](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/field-data-types)
- [Nested field](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/nested)
- [Mapping limit settings](https://www.elastic.co/docs/reference/elasticsearch/index-settings/mapping-limit)

### Chapter 3 — Data and node roles

- [Cluster and node settings](https://www.elastic.co/docs/reference/elasticsearch/configuration-reference/cluster-node-settings)
- [Node roles](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles)
- [Cluster coordination](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery.html)
- [Shard allocation](https://www.elastic.co/guide/en/elasticsearch/reference/current/shards-allocation.html)
- [Numeric field types](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number)
- [Date field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date)
- [Geo-point field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/geo-point)

### Chapter 4 — Indexing and query languages

- [Index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics)
- [Index API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-index)
- [Bulk API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk)
- [Query DSL](https://www.elastic.co/docs/explore-analyze/query-filter/languages/querydsl)
- [ES|QL](https://www.elastic.co/docs/reference/query-languages/esql)
- [EQL](https://www.elastic.co/docs/reference/query-languages/eql)
- [Elasticsearch SQL](https://www.elastic.co/docs/reference/query-languages/sql)
- [Kibana Query Language](https://www.elastic.co/docs/explore-analyze/query-filter/languages/kql)
- [Lucene query syntax in Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html)
- [Bulk indexing performance](https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-indexing-speed.html)

### Chapter 5 — Search results and maintenance

- [Search API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-search)
- [Sort search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/sort-search-results)
- [Paginate search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/paginate-search-results)
- [Highlighting](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/highlighting)
- [Reindex API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-reindex)
- [Update by query](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-update-by-query)
- [Delete by query](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete-by-query)
- [Aliases](https://www.elastic.co/docs/manage-data/data-store/aliases)

### Chapter 6 — Query execution

- [Boolean query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query)
- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context)
- [Query DSL](https://www.elastic.co/docs/explore-analyze/query-filter/languages/querydsl)
- [Lucene documentation](https://lucene.apache.org/core/documentation.html)
- [Tune for search speed](https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-search-speed.html)

### Chapter 7 — Analysis, aggregations, and production

- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis)
- [Language analyzers, including Persian](https://www.elastic.co/docs/reference/text-analysis/analysis-lang-analyzer)
- [Normalization token filters](https://www.elastic.co/docs/reference/text-analysis/analysis-normalization-tokenfilter)
- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze)
- [Doc values](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/doc-values)
- [Fielddata](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/text#fielddata-mapping-param)
- [Aggregations](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- [Transforms](https://www.elastic.co/docs/explore-analyze/transforms/transform-overview)
- [Similarity and BM25 settings](https://www.elastic.co/docs/reference/elasticsearch/index-settings/similarity)
- [Index lifecycle management](https://www.elastic.co/docs/manage-data/lifecycle/index-lifecycle-management)
- [Data tiers](https://www.elastic.co/docs/manage-data/lifecycle/data-tiers)
- [Snapshots and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore)
- [Snapshot lifecycle management](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore/snapshot-lifecycle-management)
- [Security](https://www.elastic.co/docs/deploy-manage/security)
- [Roles and privileges](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/role-management)
- [API keys](https://www.elastic.co/docs/deploy-manage/api-keys)

## Technical articles, research, and real-world cases

- [Elasticsearch from the Top Down](https://www.elastic.co/blog/found-elasticsearch-top-down) — architecture article that follows data and query paths; read it with the reference docs.
- [Improve search relevance with Boolean queries](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries) — practical ranking patterns with Boolean clauses; reevaluate them on your own queries.
- [BEIR: a heterogeneous benchmark for information retrieval](https://arxiv.org/abs/2104.08663) — research paper on retrieval evaluation; benchmark results do not automatically transfer to a product workload.
- [Canals: hybrid product search](https://www.elastic.co/customers/canals) — customer story covering keyword, dense/sparse vectors, and reranking.
- [Anyone.com: migration of 210 million records](https://www.elastic.co/customers/anyone) — customer story about migration and a search index.
- [Tinder: real-time recommendations](https://www.elastic.co/customers/tinder) — multistage retrieval, geo filtering, and ranking.
- [Oak Ridge National Laboratory: institutional knowledge search](https://www.elastic.co/customers/ornl) — federated search and source-linked summaries.
- [HSE: ecommerce search](https://www.elastic.co/customers/hse/) — product discovery and A/B evaluation.
- [Elastic customer story library](https://www.elastic.co/customers/) — browse for more examples; treat metrics as publisher-reported outcomes for each study's workload.

## How to assess a reference

For API syntax and version-specific behavior, use the official documentation for the matching release. For a technical article, record its date, version, and benchmark dataset. For a Persian analyzer plugin, check its target release, plugin API, and installation method before use. Google search links included in some lessons are discovery shortcuts, not citations or verified articles.
