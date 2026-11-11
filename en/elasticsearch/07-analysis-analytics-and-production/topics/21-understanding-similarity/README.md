# Understanding Similarity

> Chapter 07: Analysis, Analytics, and Production · Lesson 21

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/21-understanding-similarity/README.md)

## Learning goals

- Explain how a similarity function assigns scores to matching documents.
- Distinguish query matching and analysis from ranking.
- Compare ranking changes with a judged relevance set.

## Score the matches

A similarity function determines how matching text clauses contribute to a relevance score. Elasticsearch uses BM25 as the default similarity for text. The analyzer and query decide which documents match; similarity then helps rank those matches using term statistics and document characteristics. A document score is not a probability, and scores from unrelated queries should not be compared as though they shared one universal scale.

~~~http
POST /products-v1/_search
{"query":{"match":{"description":"wireless noise cancelling"}},
 "explain":true}
~~~

Explain output helps inspect one document's scoring details. To evaluate a new similarity or parameter, use representative queries with human-judged results and compare ranking metrics such as NDCG@k, MRR, or Recall@k. Changing similarity settings will not fix poor synonyms, incorrect field mapping, irrelevant content, or a broken analyzer.

## Exercise

Create short and long descriptions containing the same terms. Compare scores and Explain output. Change a similarity parameter in a lab and evaluate before and after on a judged query set rather than choosing the configuration from one search.

## Quiz with answers

1. **What does similarity determine?** How matching text documents receive relevance scores.
2. **Does the similarity function determine which terms were indexed?** No; analysis and mapping determine terms, while query logic determines matching.
3. **Is a score of 8 an 80% probability?** No. It is a query- and index-dependent ranking value.
4. **How should similarity changes be evaluated?** Against a representative judged set using ranking metrics and manual review.

## References and further reading

- [Similarity settings](https://www.elastic.co/docs/reference/elasticsearch/index-settings/similarity) — BM25 and other similarities.
- [Ranking and reranking](https://www.elastic.co/docs/solutions/search/ranking) — lexical and multi-stage ranking.
- [Explain API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-explain) — score breakdown for a document.
- [Boolean relevance article](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries) — practical score behavior.
- [Anyone.com case study](https://www.elastic.co/customers/anyone) — customer-reported lexical retrieval using BM25 at production scale.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

