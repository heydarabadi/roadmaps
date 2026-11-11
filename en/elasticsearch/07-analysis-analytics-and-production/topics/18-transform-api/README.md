# Transform API

> Chapter 07: Analysis, Analytics, and Production · Lesson 18

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/18-transform-api/README.md)

## Learning goals

- Create entity-centric summary indices from event or transaction data.
- Choose pivot or latest transform semantics.
- Monitor checkpoints, lag, errors, and destination health.

## Maintain a derived view

The Transform API creates and maintains a destination index that reorganizes source documents. Pivot transforms group records and calculate metrics; latest transforms retain the most recent record per key. Continuous transforms process new changes through checkpoints. This can simplify dashboards and entity-oriented queries, but the destination is a derived view, not a replacement for raw source data.

~~~http
GET /_transform/_stats
~~~

Review checkpoints, documents processed and indexed, failures, and sync delay. Define a freshness objective and compare the destination with source-level queries. Plan destination mappings, access, lifecycle, and recovery. Before changing or stopping a transform, understand the operational impact and whether a restart or reset is required for the intended result.

## Exercise

Create a continuous pivot or latest transform for a small event stream. Observe its checkpoints and destination lag while adding data. Compare output with a direct aggregation and document acceptable freshness and failure handling.

## Quiz with answers

1. **What is the purpose of a transform?** Build and maintain an entity-centric derived index from source data.
2. **How does continuous mode progress?** It processes updates through repeated checkpoints.
3. **Which operational signals matter?** Lag, checkpoint progress, failures, documents processed, and destination correctness.
4. **Should raw source data be deleted after a transform?** Not by default; preserve it according to replay, audit, and retention requirements.

## References and further reading

- [Transforms overview](https://www.elastic.co/docs/explore-analyze/transforms/transform-overview) — supported transform types.
- [Transform APIs](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-transform) — create, start, stop, and manage transforms.
- [Transform stats API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-transform-get-transform-stats) — progress and checkpoint data.
- [Pivot transform](https://www.elastic.co/docs/explore-analyze/transforms/transform-pivot) — grouped summaries.
- [Latest transform](https://www.elastic.co/docs/explore-analyze/transforms/transform-latest) — latest state per entity.
- Persian discovery search (not a verified article): [Persian Elasticsearch Transform API articles](https://www.google.com/search?q=Elasticsearch+transform+API+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

