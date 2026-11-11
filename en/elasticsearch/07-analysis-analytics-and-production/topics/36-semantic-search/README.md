# Semantic Search

> Chapter 07: Analysis, Analytics, and Production · Lesson 36

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/36-semantic-search/README.md)

## Learning goals

- Explain how semantic search retrieves by meaning rather than exact word overlap.
- Choose and evaluate a model for the target language and domain.
- Account for inference cost, model versioning, and exact-term behavior.

## Retrieve by intent

Semantic search uses a model to represent queries and documents in a learned space. It can retrieve conceptually related content even without shared words: “something to use in heavy rain” might retrieve umbrellas or raincoats. It depends on the embedding or semantic model, language coverage, domain fit, and consistent preprocessing. Exact model names, part numbers, or rare terms may still work better with lexical search.

~~~text
Query intent: “something to use in heavy rain”
Possible semantic matches: umbrella, waterproof jacket, rain cover
~~~

For Persian, validate real Persian queries and documents rather than assuming English benchmarks transfer. Measure recall@k, precision or NDCG, latency, inference cost, and behavior for ambiguous queries. Version models and record how vectors were generated; changing the model can require re-embedding documents. Semantic retrieval should be compared with a lexical baseline.

## Exercise

Prepare 20 Persian product queries with relevant, borderline, and irrelevant product judgments. Compare semantic and BM25 results. Include identifiers and exact model names to find where lexical search remains necessary.

## Quiz with answers

1. **How does semantic search differ from lexical matching?** It retrieves based on model-derived meaning or similarity, not only matching indexed words.
2. **Why can a semantic result be irrelevant?** Model, language, domain, or query context may not fit the dataset.
3. **Why keep a lexical baseline?** Exact terms and rare identifiers can be better handled by keyword retrieval.
4. **What is needed after changing embedding models?** Re-embedding or a compatible migration plan, followed by relevance re-evaluation.

## References and further reading

- [Semantic search quickstart](https://www.elastic.co/docs/solutions/search/get-started/semantic-search) — build a semantic search workflow.
- [Semantic text field](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/semantic-text) — managed semantic indexing options.
- [Semantic search concepts](https://www.elastic.co/docs/solutions/search/semantic-search) — models and workflows.
- [BEIR benchmark paper](https://arxiv.org/abs/2104.08663) — retrieval comparisons across tasks.
- [Canals customer story](https://www.elastic.co/customers/canals) — real catalog matching with hybrid and learned retrieval; vendor-reported results are task-specific.
- Persian discovery search (not a verified article): [Persian articles about semantic search and Persian embeddings](https://www.google.com/search?q=semantic+search+Persian+embedding+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

