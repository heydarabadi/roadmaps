# Chapter 07: Analysis, Analytics, and Production

[Read the Persian chapter guide](../../../fa/elasticsearch/07-analysis-analytics-and-production/README.md)

## Learning goals

- Explain analyzer pipelines, inverted indexes, doc values, and fielddata.
- Design metric, bucket, nested, and pipeline aggregations with correct populations.
- Use transforms for derived, entity-centric views.
- Tune lexical relevance and evaluate BM25, semantic, vector, and hybrid search.
- Operate clusters with monitoring, lifecycle policies, data tiers, CCR, snapshots, and SLM.
- Secure Elasticsearch with authenticated, least-privilege users and API keys.

## Chapter thesis

Production search joins several concerns that must be designed together: how text becomes terms, how fields support retrieval and aggregation, how results are ranked and evaluated, how data is retained and recovered, and how access is controlled. A successful API response does not prove that search quality is good, a green health status does not prove that latency meets an SLO, and a successful snapshot does not prove that recovery works. Measure each property against a representative dataset and rehearse the operating procedure.

## Concept map

~~~text
raw text -> analyzer -> terms -> inverted index -> lexical retrieval / BM25
typed fields -> doc values -> sort / aggregation / metrics
events -> bucket + metric aggregations -> pivot/latest transforms -> derived view
text + embeddings -> lexical + semantic retrieval -> rank fusion / reranking
indices -> rollover + ILM + data tiers -> retention and cost control
repository -> snapshots + SLM -> restore drill and RPO/RTO
identity -> authentication -> roles/privileges -> scoped API keys
~~~

## Part A: Analysis and index structures

1. [Search Analyzer](topics/01-search-analyzer/README.en.md)
2. [Doc Values](topics/02-doc-values/README.en.md)
3. [Fielddata](topics/03-fielddata/README.en.md)
4. [The Inverted Index](topics/04-the-inverted-index/README.en.md)
5. [Analyze API](topics/05-the-analyze-api/README.en.md)
6. [Standard Analyzer](topics/06-standard-analyzer/README.en.md)
7. [Custom Analyzers](topics/07-custom-analyzers/README.en.md)

Use Analyze API to inspect tokens, positions, and offsets before indexing representative multilingual data. For Persian, test half-space, Arabic/Persian yeh and kaf, digits, punctuation, transliteration, and names from the real catalog. Keep full-text analysis separate from exact values. Use keyword multi-fields for sorting and facets instead of fielddata on text unless token-level operations are deliberately required and measured.

## Part B: Aggregations and transforms

8. [Value Count](topics/08-value-count/README.en.md)
9. [Average, Sum, Min, and Max](topics/09-avg-sum-min-max/README.en.md)
10. [Cardinality](topics/10-cardinality/README.en.md)
11. [Stats and Extended Stats](topics/11-stats-extended-stats/README.en.md)
12. [Terms](topics/12-terms/README.en.md)
13. [Range and Date Range](topics/13-range-date-range/README.en.md)
14. [Histograms](topics/14-histogram/README.en.md)
15. [Filter Aggregations](topics/15-filter-aggregations/README.en.md)
16. [Pivot Transforms](topics/16-pivot/README.en.md)
17. [Latest Transforms](topics/17-latest/README.en.md)
18. [Transform API](topics/18-transform-api/README.en.md)
19. [Nested Aggregations](topics/19-nested-aggregations/README.en.md)
20. [Pipeline Aggregations](topics/20-pipeline-aggregations/README.en.md)

Before interpreting any metric, define the query population, field units, missing-value behavior, and whether arrays contribute multiple values. Cardinality is approximate, so it is useful for dashboards but not an exact financial ledger. Terms aggregation returns top buckets, not an unbounded enumeration. Use composite aggregation to page through many buckets. Transforms create derived indices; keep the source, monitor checkpoint lag, and validate the destination.

## Part C: Relevance and runtime operations

21. [Understanding Similarity](topics/21-understanding-similarity/README.en.md)
22. [BM25 Algorithm](topics/22-bm25-algorithm/README.en.md)
23. [CAT APIs](topics/23-cat-api/README.en.md)
24. [Segment Merging](topics/24-segment-merging/README.en.md)
25. [Cluster Monitoring](topics/25-cluster-monitoring/README.en.md)
26. [Cross-Cluster Replication](topics/26-cross-cluster-replication/README.en.md)
27. [Autoscaling](topics/27-autoscaling/README.en.md)
28. [Boosting](topics/28-boosting-queries/README.en.md)
29. [Function Score](topics/29-function-score-query/README.en.md)
30. [Match Phrase](topics/30-match-phrase-query/README.en.md)
31. [Synonym Graphs](topics/31-synonyms-graph/README.en.md)

Build a representative judged query set before tuning relevance. Use Explain for one document and Profile for targeted diagnostics; do not treat either as a quality metric. CAT APIs support human triage, while monitoring should use structured metrics over time. Watch user-facing p95/p99 latency and errors along with heap/GC, disk, rejections, shard movement, freshness, snapshot status, and replication lag. CCR, local replicas, and snapshots solve different problems.

## Part D: Lifecycle, retrieval, and security

32. [Index Lifecycle Management](topics/32-ilm/README.en.md)
33. [Rollover Policies](topics/33-rollover-policies/README.en.md)
34. [Data Tiers](topics/34-data-tiers/README.en.md)
35. [Vector Search](topics/35-vector-search/README.en.md)
36. [Semantic Search](topics/36-semantic-search/README.en.md)
37. [Hybrid Search](topics/37-hybrid-search/README.en.md)
38. [Snapshots and Restore](topics/38-snapshots-and-restore/README.en.md)
39. [Snapshot Lifecycle Management](topics/39-slm/README.en.md)
40. [Authentication](topics/40-authentication/README.en.md)
41. [Roles and Users](topics/41-roles-and-users/README.en.md)
42. [API Keys](topics/42-api-keys/README.en.md)

Use lifecycle policy to express retention and tier transitions, but verify it is attached and progressing through explain APIs. Vector model, dimensions, preprocessing, language, and similarity must be compatible. Compare BM25, vector, and hybrid retrieval on the same judged query set; RRF helps combine rankings whose raw score distributions differ. Store snapshots in a registered off-cluster repository and prove recovery through restore drills. Enforce authentication, least privilege, TLS, and key rotation across every application path.

## Final workshop

1. Analyze a set of real Persian and mixed-language product names; record token expectations.
2. Map title as text plus keyword, price as numeric, brand as keyword, and embedding using the correct model dimension.
3. Build a `size: 0` report with terms, stats, ranges, and cardinality; label approximate metrics.
4. Compare BM25, vector, and hybrid retrieval using relevance judgments and latency metrics.
5. Define rollover, ILM, tiers, and retention for event data.
6. Configure snapshot repository and SLM policy, then restore into a safe test target.
7. Create a read-only role and scoped API key, rotate it, and test denied operations.

## Chapter quiz

1. Why use a keyword multi-field rather than fielddata for a common brand facet?
2. Which aggregation is approximate, and why is that relevant to billing?
3. How should lexical, vector, and hybrid approaches be compared?
4. What does SLM provide that ILM does not?
5. Why are snapshots and CCR not interchangeable?
6. What is the difference between authentication and authorization?
7. What must be verified after defining an ILM policy?

**Answer key:** (1) Keyword fields support exact-value aggregation with doc values and avoid loading text terms into heap. (2) Cardinality estimates unique counts and can have error, so it is not an authoritative exact billable count. (3) On the same representative judged queries using ranking and operational metrics. (4) SLM schedules and retains snapshots; ILM manages index lifecycle. (5) CCR asynchronously replicates across clusters; snapshots are recoverable backup artifacts in a repository. (6) Authentication verifies identity; authorization defines allowed actions and data. (7) Association with the target index/template/data stream and phase/action progress through explain APIs.

## References and case studies

- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis)
- [Aggregations](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- [Similarity settings](https://www.elastic.co/docs/reference/elasticsearch/index-settings/similarity)
- [Vector search](https://www.elastic.co/docs/solutions/search/vector)
- [Hybrid search](https://www.elastic.co/docs/solutions/search/hybrid-search)
- [Index lifecycle management](https://www.elastic.co/docs/manage-data/lifecycle/index-lifecycle-management)
- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore)
- [Anyone.com case study](https://www.elastic.co/customers/anyone) — vendor-reported migration and lexical search at scale.
- [Canals case study](https://www.elastic.co/customers/canals) — vendor-reported hybrid product search and relevance improvement.
- [BEIR retrieval benchmark](https://arxiv.org/abs/2104.08663) — academic retrieval evaluation across diverse tasks.
- [Persian analyzer implementation article](https://virgool.io/@technotesai/%DA%86%D8%B1%D8%A7-%D8%AC%D8%B3%D8%AA%D8%AC%D9%88%DB%8C-%D9%81%D8%A7%D8%B1%D8%B3%DB%8C-%D8%AF%D8%B1-elasticsearch-%D8%AF%D8%B1%D8%B3%D8%AA-%DA%A9%D8%A7%D8%B1-%D9%86%D9%85%DB%8C-%DA%A9%D9%86%D8%AF-%D9%88-%DA%86%D8%B7%D9%88%D8%B1-%D8%AF%D8%B1%D8%B3%D8%AA%D8%B4-%DA%A9%D9%86%DB%8C%D9%85-dfsaaev7zebh) · [ParsiAnalyzer](https://github.com/NarimanN2/ParsiAnalyzer).
