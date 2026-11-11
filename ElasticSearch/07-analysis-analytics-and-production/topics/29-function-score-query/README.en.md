# Function Score Query

> Chapter 07: Analysis, Analytics, and Production · Lesson 29

[Read the Persian version](README.md)

## Learning goals

- Combine text relevance with business signals such as popularity or recency.
- Understand `score_mode`, `boost_mode`, and score caps.
- Prevent business signals from overwhelming textual relevance.

## Combine relevance and business features

`function_score` modifies scores from an underlying query using functions such as `field_value_factor`, decay functions, or random scoring. `score_mode` combines multiple functions; `boost_mode` combines the function result with the original query score. `max_boost` and other controls can bound effects. A popularity value may help rank products, but a highly popular item should not automatically outrank a completely irrelevant result.

~~~http
POST /products-v1/_search
{"query":{"function_score":{
  "query":{"match":{"title":"wireless headphones"}},
  "field_value_factor":{"field":"popularity","modifier":"log1p","missing":0},
  "boost_mode":"sum","max_boost":5
}}}
~~~

Normalize business signals, handle missing values, and evaluate using offline relevance judgments or controlled experiments. Choose decay scale and origin for freshness or distance based on product expectations. Use Explain to inspect individual outcomes and record regressions where popular but unrelated records rise too high.

## Exercise

Create a low-relevance product with very high popularity and a highly relevant product with low popularity. Test different score modes and caps. Decide how much popularity should change their ordering and validate with a judged query set.

## Quiz with answers

1. **When is function score useful?** When ranking should combine text relevance with controlled business signals.
2. **What does `boost_mode` control?** How the function output combines with the original query score.
3. **Why set missing-value behavior?** A missing field can otherwise have an unintended effect on ranking.
4. **How do you prevent popularity from dominating?** Normalize or cap its contribution and evaluate the result.

## References and further reading

- [Function score query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-function-score-query) — score functions and combination modes.
- [Decay functions](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-function-score-query#function-decay) — recency, distance, and numeric decay.
- [Rank evaluation API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search-rank-eval) — evaluate relevance judgments.
- [Explain API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-explain) — inspect a document score.
- [Canals case study](https://www.elastic.co/customers/canals) — real-world search quality evaluation example; reported figures are workload-specific.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

