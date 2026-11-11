# Pivot Transforms

> Chapter 07: Analysis, Analytics, and Production · Lesson 16

[Read the Persian version](README.md)

## Learning goals

- Convert event-level data into grouped entity or business summaries.
- Define group-by keys and metrics for a pivot transform.
- Validate transform checkpoints, lag, and destination data.

## Summarize rows into groups

A pivot transform groups source documents by one or more fields and writes summary documents to a destination index. For example, raw sales events can become a daily total per brand. The destination is a derived view that supports downstream dashboards or entity-centric analysis; the source remains the authoritative event history.

~~~json
{"group_by":{"brand":{"terms":{"field":"brand"}}},
 "aggregations":{"total_sales":{"sum":{"field":"price"}}}}
~~~

This illustrates the pivot configuration concept. A production transform also specifies source, destination, and optionally continuous sync behavior. Decide group keys, metrics, retention, and expected update delay. Continuous transforms process changes in checkpoints; monitor checkpoint progress, failures, and lag. Compare a sample destination with direct aggregations over the same source window.

## Exercise

Design a pivot that summarizes sales by day and brand. Run it on sample data, compare its output with a direct query aggregation, and set an acceptable sync delay. Add a late-arriving event and verify how the destination updates.

## Quiz with answers

1. **What does a pivot transform produce?** Summary documents grouped by configured fields and aggregations.
2. **Is the destination a source of truth?** No, it is derived from source data and transform progress.
3. **What should be monitored for continuous mode?** Checkpoints, lag, processing failures, and destination correctness.
4. **How can correctness be checked?** Compare representative groups with direct aggregations over the same source population.

## References and further reading

- [Transforms overview](https://www.elastic.co/docs/explore-analyze/transforms/transform-overview) — pivot and latest transforms.
- [Pivot transform](https://www.elastic.co/docs/explore-analyze/transforms/transform-pivot) — group-by and aggregation settings.
- [Create transform API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-transform-put-transform) — complete request configuration.
- [Transform stats API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-transform-get-transform-stats) — checkpoint and operational status.
- Persian discovery search (not a verified article): [Persian Elasticsearch pivot-transform lessons](https://www.google.com/search?q=Elasticsearch+pivot+transform+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

