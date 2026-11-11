# Query Context

> Chapter 04: Indexing and Query Languages · Lesson 21

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/21-query/README.md)

## Learning goals

- Explain how query context tests matches and can calculate relevance scores.
- Interpret a score as a ranking signal rather than a probability.
- Keep relevance clauses separate from eligibility filters.

## Match and score

In query context, Elasticsearch evaluates whether a document matches and may calculate a score describing how well it matches. Full-text queries such as `match` commonly contribute to relevance. The score is useful for ordering candidates; it is not a probability that the document is correct. The default similarity for text is BM25, but application relevance still depends on field choices, analyzers, query composition, boosts, and data.

~~~http
POST /products-v1/_search
{"query":{"match":{"description":{"query":"lightweight for travel","boost":1.5}}}}
~~~

Boosts influence relative contribution but do not guarantee a better user experience. Evaluate a representative query set and compare ranking outcomes. Put conditions such as tenant, availability, legal visibility, or a hard price limit in filter context when they define eligibility rather than textual relevance. Use Explain to understand why a specific document received its score.

## Exercise

Search titles and descriptions with different boosts. Record the top results for a small judged query set. Compare a text query with a filter-only condition and explain why the returned score does not express a probability.

## Quiz with answers

1. **What does query context do?** It evaluates a query for matching documents and can calculate relevance scores.
2. **Is `_score` a probability?** No. It is a ranking signal whose value depends on the query and similarity.
3. **Where should a hard eligibility condition go?** Usually in a filter clause.
4. **How can a score be investigated for one document?** Use the Explain API with the same query.

## References and further reading

- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context) — scoring and boolean matching.
- [Similarity settings](https://www.elastic.co/docs/reference/elasticsearch/index-settings/similarity) — BM25 and alternatives.
- [Explain API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-explain) — inspect score calculation.
- [Ranking and reranking](https://www.elastic.co/docs/solutions/search/ranking) — multi-stage ranking approaches.
- [Improve relevance with boolean queries](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries) — practical score tuning.
- Persian discovery search (not a verified article): [Persian tutorials about Elasticsearch relevance and scoring](https://www.google.com/search?q=Elasticsearch+relevance+score+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

