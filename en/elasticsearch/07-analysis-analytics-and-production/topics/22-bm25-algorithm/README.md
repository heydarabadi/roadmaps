# BM25 Algorithm

> Chapter 07: Analysis, Analytics, and Production · Lesson 22

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/22-bm25-algorithm/README.md)

## Learning goals

- Explain term frequency, inverse document frequency, and document-length normalization.
- Understand why term frequency has diminishing returns.
- Avoid interpreting `_score` as probability or comparing unrelated queries directly.

## The main BM25 signals

BM25 is a lexical ranking function used by Elasticsearch by default for text fields. It considers whether query terms match, how often a term appears in a document with saturation, how rare the term is across the corpus, and how document length compares with typical field length. These signals help order matching documents; they do not understand semantic intent in the way an embedding model might.

~~~http
POST /products-v1/_search
{"query":{"match":{"description":"waterproof lightweight travel"}},
 "explain":true}
~~~

The BM25 parameters `k1` and `b` influence term-frequency saturation and length normalization. Do not tune them in isolation without relevance labels. Start by validating the mapping and analyzer, then synonyms, field boosts, and query composition. Compare results using the same query set and relevance judgments. A score's scale depends on the query and index statistics, so `8` is not an eight-out-of-ten rating.

## Exercise

Create three documents: a short exact product description, a long unrelated description containing one query term, and a document repeating one query term many times. Use Explain to inspect score factors and see why repetition does not grow score indefinitely.

## Quiz with answers

1. **Which signals influence BM25?** Term match and frequency, term rarity, and document-length normalization.
2. **Does repeated term frequency grow score linearly forever?** No; BM25 applies saturation.
3. **What is the role of `b`?** It controls the degree of document-length normalization.
4. **Is `_score` a probability?** No; it is a relative ranking score.

## References and further reading

- [BM25 similarity in Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/index-settings/similarity) — implementation and parameters.
- [Okapi BM25 paper](https://doi.org/10.1561/1500000019) — foundational probabilistic ranking model overview.
- [Information retrieval evaluation](https://trec.nist.gov/) — test collections and ranked retrieval evaluation context.
- [Explain API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-explain) — inspect scoring components.
- [Boolean search relevance article](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries) — practical BM25 ranking examples.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

