# Aggregation Pipelines

> **Persian edition:** [Read this lesson in Persian](../../../04-performance/aggregation/readme.md).

> **Learning goal:** Transform, join, and summarize documents through ordered stages while controlling work and output size.

## Pipeline mental model

An aggregation pipeline passes documents through ordered stages. Each stage receives the previous stage's output and can filter, reshape, group, sort, or join. Keep the input and intermediate result sizes in mind: `$unwind` can multiply records, and a late filter may force the server to process far more data than needed.

## Common stages

- `$match`: filter documents; an early match may use indexes.
- `$project` / `$set`: select, compute, or reshape fields.
- `$unwind`: emit one pipeline document per array element.
- `$group`: group by a key and compute values such as `$sum`, `$avg`, `$min`, or `$max`.
- `$sort`, `$skip`, `$limit`: order and bound the result.
- `$lookup`: combine documents from another collection.
- `$count`: count the documents reaching that stage.

## Worked example: revenue by product

~~~javascript
db.orders.aggregate([
  { $match: {
      status: { $in: ["paid", "shipped"] },
      createdAt: { $gte: ISODate("2026-11-01T00:00:00Z") }
  } },
  { $unwind: "$items" },
  { $group: {
      _id: "$items.sku",
      units: { $sum: "$items.quantity" },
      revenue: { $sum: { $multiply: ["$items.quantity", "$items.unitPrice"] } }
  } },
  { $sort: { revenue: -1 } },
  { $limit: 10 }
])
~~~

The early `$match` bounds the time window and status. `$unwind` turns line items into individual pipeline records. `$group` combines them by SKU. Verify that quantity and price use compatible numeric BSON types and that orders preserve the price at purchase time.

## Stage order and performance

Start with selective `$match` and sort stages that can use an index when semantics allow. MongoDB can optimize some pipelines automatically, so a `$project` added only to remove unused fields early may not improve execution. Use `explain()` and representative data rather than rewriting stages by habit.

`$lookup` can be useful but may multiply work if the join key is unindexed or the input is large. `$unwind` can dramatically increase intermediate cardinality. Consider pre-aggregation or a computed field when a very expensive report runs constantly and the accepted staleness is explicit.

## Exercise

1. Group paid orders by status and sum their totals.
2. Build a top-10 item report for a bounded date range.
3. Count orders per customer, then sort by count descending.
4. Identify which pipeline stage can multiply the number of documents and how to observe it.

## Common mistakes

- Forgetting to filter early enough.
- Unwinding a large array without estimating the resulting cardinality.
- Grouping values with inconsistent types or missing fields.
- Joining on an unindexed key without measuring the cost.
- Assuming a `$project` at the start always makes the pipeline faster.

## Quiz and answer key

1. **What does `$match` do?** Filters documents that pass to later stages.
2. **What does `$group` do?** Groups records by an expression and computes aggregate values.
3. **Why can `$unwind` be expensive?** One input document may produce many pipeline records.
4. **Why put a selective `$match` early when semantics allow?** It reduces the amount of data later stages need to process.
5. **Applied task: group revenue by status.** Match the required date range and statuses, group by `$status`, and sum a consistent numeric `total` field.
6. **What does `$lookup` do?** Joins matching documents from another collection into the pipeline result.
7. **What does `$limit` do?** Restricts how many pipeline documents continue or are returned.
8. **Why store purchase-time price in an order?** A report should use the historical price, not a product's current catalog price.
9. **When might a computed/pre-aggregated result help?** A repeated expensive report can tolerate a defined refresh delay.
10. **How should a pipeline be tuned?** Inspect explain and stage cardinality on representative data, change one hypothesis, and remeasure.

## Further reading

- [Aggregation Operations](https://www.mongodb.com/docs/manual/aggregation/)
- [Aggregation Pipeline Stages](https://www.mongodb.com/docs/manual/reference/operator/aggregation-pipeline/)
- [Aggregation Pipeline Optimization](https://www.mongodb.com/docs/manual/core/aggregation-pipeline-optimization/)
- [Aggregation Accumulators](https://www.mongodb.com/docs/manual/reference/operator/aggregation/)
- [Persian aggregation course — Darsman](https://darsman.com/course/aggregation-operations-in-mongodb/)
- [MongoDB aggregation articles — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [Curated reference library: aggregation](../../reference-library.md#performance-aggregation)

---
Sources reviewed: 2026-11-11.
