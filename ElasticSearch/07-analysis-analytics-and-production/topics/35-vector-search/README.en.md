# Vector Search

> Chapter 07: Analysis, Analytics, and Production · Lesson 35

[Read the Persian version](README.md)

## Learning goals

- Store dense vectors and search for approximate nearest neighbors.
- Keep embedding model, dimensions, preprocessing, and similarity aligned.
- Tune candidate count using recall and latency measurements.

## Nearest-neighbor retrieval

Vector search compares a query vector with vectors stored on documents using a configured similarity. An embedding model converts text, images, or other data into numeric vectors. The model, version, preprocessing, dimensions, and vector similarity must be compatible between indexing and query time. Approximate kNN can scale better than exact comparison but may trade recall for speed and memory.

~~~http
POST /products-v1/_search
{"knn":{"field":"embedding","query_vector":[0.12,0.08,0.31],
  "k":10,"num_candidates":100}}
~~~

The three-dimensional vector is illustrative; production dimensions come from the model. `k` controls returned neighbors and `num_candidates` controls the initial candidate set used by approximate search. Larger candidate sets may improve recall at higher resource cost. Evaluate recall@k and latency on labeled queries, include filters and access-control requirements, and measure embedding generation cost. A vector database feature does not remove the need for relevance evaluation.

## Exercise

Use an embedding model to index a small set of product descriptions and write query vectors with the same model. Compare recall@10 and p95 latency at several candidate counts. Add a structured availability filter and verify the returned candidates obey it.

## Quiz with answers

1. **Why must vector dimensions match?** The query and indexed vectors must inhabit the same configured vector space and length.
2. **What is the `num_candidates` trade-off?** More candidates can improve recall but increase search work and latency.
3. **What else must remain compatible besides dimensions?** Model/version, preprocessing, and similarity semantics.
4. **How should vector search be evaluated?** With representative labeled queries, recall and ranking metrics, latency, and cost.

## References and further reading

- [Vector search](https://www.elastic.co/docs/solutions/search/vector) — vector capabilities and approaches.
- [Dense vector field](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/dense-vector) — map and index embeddings.
- [kNN search](https://www.elastic.co/docs/solutions/search/vector/knn) — approximate nearest-neighbor queries.
- [Search API kNN](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/knn-search) — `k` and candidate settings.
- [BEIR benchmark paper](https://arxiv.org/abs/2104.08663) — evaluation of heterogeneous retrieval systems.
- [Canals case study](https://www.elastic.co/customers/canals) — vendor-reported hybrid retrieval gains in a product-matching workload.
- Persian discovery search (not a verified article): [Persian Elasticsearch vector-search articles](https://www.google.com/search?q=Elasticsearch+vector+search+%D8%AC%D8%B3%D8%AA%D8%AC%D9%88%DB%8C+برداری+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

