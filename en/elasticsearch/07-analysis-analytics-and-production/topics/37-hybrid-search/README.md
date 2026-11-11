# Hybrid Search

> Chapter 07: Analysis, Analytics, and Production · Lesson 37

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/37-hybrid-search/README.md)

## Learning goals

- Combine lexical and vector retrieval in one search experience.
- Understand why raw scores from different retrievers may not share a scale.
- Evaluate reciprocal rank fusion (RRF) and business-level ranking.

## Combine complementary retrieval

Hybrid search combines full-text keyword matching with vector similarity. Lexical search is strong for exact names, part numbers, and rare terms. Vector search can find conceptual or paraphrased matches. Since their scores may have different distributions, summing them directly can be misleading. Reciprocal rank fusion combines ranked lists using rank positions to reduce the need for score calibration.

~~~text
Lexical candidates + vector candidates -> rank fusion / reranking -> final results
~~~

The supported request syntax depends on Elasticsearch version and search workflow; recent docs recommend the `semantic_text` workflow for some use cases. Apply access and eligibility filters consistently across retrieval paths. Evaluate lexical-only, vector-only, and hybrid on the same query set using NDCG@k, recall, latency, and cost. A customer result can be impressive but remains specific to its data and relevance judgments.

## Exercise

Compare BM25, vector retrieval, and RRF hybrid for 30 representative queries. Label top results, record Recall@10 and NDCG@10, and measure p95 latency. Test an exact SKU query and a paraphrased intent query separately.

## Quiz with answers

1. **Which retrieval types does hybrid search combine?** Lexical full-text and vector or semantic retrieval.
2. **Why avoid blindly summing their raw scores?** Their scales and distributions can differ.
3. **What does RRF use?** Rank positions from multiple result lists.
4. **What should be compared before production?** Relevance, latency, filters/security, inference cost, and fallback behavior.

## References and case study

- [Hybrid search](https://www.elastic.co/docs/solutions/search/hybrid-search) — combine keyword and vector retrieval.
- [Reciprocal rank fusion](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/reciprocal-rank-fusion) — fuse ranked lists.
- [Ranking and reranking](https://www.elastic.co/docs/solutions/search/ranking) — multi-stage ranking.
- [Canals hybrid product search](https://www.elastic.co/customers/canals) — reports top-three accuracy from 63% at launch to 96% after iterative tuning; these are vendor-published results on Canals' workload, not a general guarantee.
- [BEIR benchmark paper](https://arxiv.org/abs/2104.08663) — evidence that retrieval performance depends on dataset and task.
- Persian discovery search (not a verified article): [Persian Elasticsearch hybrid-search tutorials](https://www.google.com/search?q=Elasticsearch+hybrid+search+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

