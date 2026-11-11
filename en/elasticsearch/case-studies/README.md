# Elasticsearch Case Studies and Operational Lessons

[Read the Persian version](../../../fa/elasticsearch/case-studies/README.md)

The first cases below are published by Elastic. Treat reported figures as vendor-published, workload-specific outcomes rather than performance guarantees. The final section adds Persian practitioner accounts; these are not official documentation or independently reproduced benchmarks. Use each case to derive design questions, then validate them on your own data and service objectives.

## Anyone.com: migrating 210 million records

The [Anyone.com story](https://www.elastic.co/customers/anyone) reports that the company moved its search backend from PostgreSQL to one Elasticsearch index, migrating about 210 million records in roughly one and a half weeks. A production migration still needs an explicit mapping, reconciliation of counts and representative documents, capacity estimates, rebuild strategy, cutover plan, and rollback path. A fast copy is not proof that search semantics or operational behavior are correct.

**Study questions:** Which fields need full-text search? Which must support exact filters and aggregations? How would you keep the source database authoritative while rebuilding the search projection? How would you compare result quality before cutover?

## Canals: hybrid retrieval for product matching

The [Canals case study](https://www.elastic.co/customers/canals) reports combining keyword, dense-vector, and sparse-vector retrieval in a product-matching workload, followed by another ranking layer. Elastic reports a rise in top-three accuracy from 63% to 96%, with about 90% of matches auto-selected. The lesson is not that vectors always win: exact part numbers and newly introduced products can still benefit from lexical retrieval, and the final ranking system must be evaluated on judged queries.

**Study questions:** What is the candidate-generation stage? Which queries need exact identifiers? What do Recall@k, MRR, and NDCG@k reveal? How will you monitor drift when product catalogs and user language change?

## Tinder: high-scale candidate retrieval

The [Tinder engineering story](https://www.elastic.co/customers/tinder) describes Elasticsearch supporting the retrieval stage of a multistage recommendation system. The reported architecture applies geo-aware filtering and exclusion logic to reduce a large profile corpus to candidates; richer models then rank a smaller set downstream. It illustrates why retrieval quality, tail latency, and downstream ranking cost must be measured together.

**Study questions:** Which constraints are hard filters and which are ranking signals? How does reducing the candidate pool affect recall? What does a partition or geo-index improve, and what routing or rebalancing complexity does it add?

## Oak Ridge National Laboratory: federated knowledge search

The [ORNL SEEK case study](https://www.elastic.co/customers/ornl) describes a scoped, on-prem federated search platform, with retrieval over selected institutional sources and source-linked AI summaries. The reported adoption and user-experience figures belong to that implementation. The transferable design point is that relevance and trust depend on choosing searchable sources, preserving access boundaries, and keeping answers attributable to source documents.

**Study questions:** Which source systems can be indexed safely? How can source permissions be enforced? How should summaries expose citations? What freshness and reindexing model matches the content-change rate?

## HSE: ecommerce search

The [HSE story](https://www.elastic.co/customers/hse/) discusses product discovery across brand, creator, description, and product identifiers, and reports results from an A/B comparison. It is a useful prompt for designing a search-quality experiment: define a control, segment queries, pick user-centered metrics, and track conversion and abandonment alongside latency.

## Common failure modes to look for

- Unbounded dynamic fields create mapping growth and operational overhead.
- Too many small shards add coordination overhead; very large shards can slow recovery and relocation.
- Deep offset pagination, broad wildcards, and high-cardinality aggregations can consume substantial resources.
- Replicas, snapshots, and cross-cluster replication address different availability and recovery needs.
- Average latency hides tail behavior, rejected requests, and queue saturation.
- A boost that looks plausible can reduce relevance unless checked against representative queries and judgments.

## Persian engineering accounts

These are practitioner or team accounts, not official documentation or independently reproduced benchmarks.

- [Basalam: dynamic commission rules with Percolate](https://virgool.io/%D8%B1%D8%A7%D9%87%DA%A9%D8%A7%D8%B1-%D9%81%D9%86%DB%8C-%D9%85%D9%82%DB%8C%D8%A7%D8%B3-%D9%BE%D8%B0%DB%8C%D8%B1-%D8%A8%D8%B1%D8%A7%DB%8C-%D9%BE%D8%B4%D8%AA%DB%8C%D8%A8%D8%A7%D9%86%DB%8C-%D8%A7%D8%B2-%D9%BE%D9%88%DB%8C%D8%A7%DB%8C%DB%8C-%DA%AF%D8%B3%D8%AA%D8%B1%D8%AF%D9%87-%DB%8C-%D8%B3%DB%8C%D8%B3%D8%AA%D9%85-%DA%A9%D9%85%DB%8C%D8%B3%DB%8C%D9%88%D9%86-%D8%A8%D8%A7%D8%B3%D9%84%D8%A7%D9%85-percolate-%D8%AF%D8%B1-elasticsearch-flsw9db3da3l) — stored queries applied to order events; verify API details against current Percolator docs.
- [Persian analyzer implementation for a product catalog](https://virgool.io/@technotesai/%DA%86%D8%B1%D8%A7-%D8%AC%D8%B3%D8%AA%D8%AC%D9%88%DB%8C-%D9%81%D8%A7%D8%B1%D8%B3%DB%8C-%D8%AF%D8%B1-elasticsearch-%D8%AF%D8%B1%D8%B3%D8%AA-%DA%A9%D8%A7%D8%B1-%D9%86%D9%85%DB%8C-%DA%A9%D9%86%D8%AF-%D9%88-%DA%86%D8%B7%D9%88%D8%B1-%D8%AF%D8%B1%D8%B3%D8%AA%D8%B4-%DA%A9%D9%86%DB%8C%D9%85-dfsaaev7zebh) — normalization and Persian retrieval examples; independently evaluate the proposed configuration on judged queries.
- [Virgool's account of moving analytics from MySQL to Elasticsearch](https://virgool.io/virgool/%D8%A7%D8%B2-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-mysql%D8%A7%DB%8C-%D8%A8%D9%87-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-elasticsearch%D8%A7%DB%8C-%D9%82%D8%B3%D9%85%D8%AA-%DB%B2-%D8%A2%D9%85%D8%A7%D8%B1-bzx5mj16lcqb) — older engineering-team notes about analytics data; read for decision context, not today's implementation details.
- [Virgool's backup follow-up](https://virgool.io/virgool/%D8%A7%D8%B2-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-mysql%D8%A7%DB%8C-%D8%A8%D9%87-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-elasticsearch%D8%A7%DB%8C-%D9%82%D8%B3%D9%85%D8%AA-%DB%B3-%D8%A2%D8%AE%D8%B1%D8%A7%DB%8C-%D8%AF%D8%A7%D8%B3%D8%AA%D8%A7%D9%86-y9ioyntxpjue) — compare the concepts with current snapshot and restore and perform a recovery drill.

## Engineering references

- [Index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics)
- [Tune for search speed](https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-search-speed.html)
- [Tune for indexing speed](https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-indexing-speed.html)
- [Troubleshoot cluster issues](https://www.elastic.co/guide/en/elasticsearch/reference/current/fix-common-cluster-issues.html)
- [Percolator](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/percolator)
- [Search relevance evaluation](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-relevance.html)
- [BEIR retrieval benchmark paper](https://arxiv.org/abs/2104.08663)
- [Curated bilingual bibliography](../references/README.md)
