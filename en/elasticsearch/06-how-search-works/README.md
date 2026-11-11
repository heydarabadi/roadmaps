# Chapter 06: How Search Works

[Read the Persian chapter guide](../../../fa/elasticsearch/06-how-search-works/README.md)

## Learning goals

- Follow analyzed query text through distributed shard execution and result reduction.
- Explain the behavior of `must`, `should`, `filter`, and `must_not`.
- Debug a match or score and evaluate relevance with a representative query set.

## Chapter thesis

A search request is analyzed and routed to shard copies. Shards search locally and return candidates, scores, and partial aggregations; a coordinating node combines the results. The number of shards, queueing, hardware, network, sorting, and result size all affect latency. A bool query should encode product semantics: `must` imposes required scored clauses, `should` expresses optional preferences or alternatives, `filter` constrains eligibility without scoring, and `must_not` excludes disallowed matches. Relevance score is not probability; evaluate rankings against judged queries.

## Concept map

~~~text
query text -> search analyzer -> coordinator -> shard-local candidates
         -> bool clauses                         -> reduce / sort -> hits

must: required + may score     should: optional preference / alternative
filter: required + no score    must_not: exclusion

measure: representative query set -> judged relevance -> MRR / Recall@k / NDCG@k
~~~

## Study sequence

1. [How Search Works](topics/01-how-search-works/README.en.md)
2. [The `must` Clause](topics/02-must/README.en.md)
3. [The `should` Clause](topics/03-should/README.en.md)
4. [The `filter` Clause](topics/04-filter/README.en.md)
5. [The `must_not` Clause](topics/05-must-not/README.en.md)

## Applied exercise

Create three products with partially overlapping titles, preferred and non-preferred brands, different prices and availability, plus one hidden item. Search with title text in `must`, brand preference in `should`, price and availability in `filter`, and hidden status in `must_not`. Change `minimum_should_match`, inspect a document with Explain, and measure result order over a small judged set.

## Common pitfalls

- Treating `_score` as a probability or business correctness guarantee.
- Putting every structured condition in scoring context.
- Assuming `should` is always optional or always required.
- Treating `false` and missing values as equivalent.
- Turning on Profile for all production traffic instead of a targeted diagnosis.
- Optimizing from `took` alone without measuring end-to-end latency.
- Ignoring analysis differences between indexed text and query text, especially for multilingual and Persian content.

## Chapter quiz

1. What are the two broad stages of a distributed search request?
2. Which bool clause can rank a preferred brand without requiring it?
3. What changes when a price filter is moved into `must`?
4. How does `minimum_should_match` clarify user intent?
5. Which metrics can compare rankings on the same set of judged queries?

**Answer key:** (1) Shards execute local search and the coordinator reduces/merges their results. (2) `should`. (3) The set may remain the same, but the clause enters scoring context and can affect score semantics. (4) It makes the required count of `should` matches explicit. (5) MRR, Recall@k, and NDCG@k are common options.

## References

- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context)
- [Boolean query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query)
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis)
- [Ranking and reranking](https://www.elastic.co/docs/solutions/search/ranking)
- [Elastic relevance article](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries)
