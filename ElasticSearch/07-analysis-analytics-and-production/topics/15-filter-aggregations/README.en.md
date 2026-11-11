# Filter Aggregations

> Chapter 07: Analysis, Analytics, and Production · Lesson 15

[Read the Persian version](README.md)

## Learning goals

- Calculate metrics over a filtered subset while keeping the overall query population.
- Distinguish a query filter from a filter aggregation.
- Compare several fixed cohorts with a filters aggregation.

## Analyze a subpopulation

A filter aggregation creates one bucket containing only documents that match its filter. Child aggregations run over that subset. The outer query can remain broad, allowing one response to compare metrics for different populations. A filters aggregation can create multiple named buckets for separate conditions.

~~~http
POST /products-v1/_search
{"size":0,"aggs":{"available_products":{"filter":{"term":{"available":true}},
  "aggs":{"average_price":{"avg":{"field":"price"}}}}}}
~~~

The top-level query limits the entire search; the filter aggregation narrows only its child aggregation. Be explicit about the population represented by each metric so dashboards do not compare unlike groups. If the only purpose is to reduce all results to one condition, a top-level query filter can be simpler and more efficient.

## Exercise

In one request, calculate average prices for all products, available products, and unavailable products. Use named filter buckets and compare each count with a separate query. Explain which approach is easier to review.

## Quiz with answers

1. **What does a filter aggregation do?** Runs child aggregations over documents matching its condition.
2. **How is it different from the top-level query filter?** A query filter limits the main search population; a filter aggregation creates a separate subset inside the aggregation tree.
3. **When is a filters aggregation useful?** When several named cohorts need metrics in one request.
4. **What should a dashboard label state?** The population and condition represented by each metric.

## References and further reading

- [Filter aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-filter-aggregation) — one filtered bucket.
- [Filters aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-filters-aggregation) — multiple named filters.
- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context) — query-level filtering.
- [Aggregations overview](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations) — combine filters and metrics.
- Persian discovery search (not a verified article): [Persian Elasticsearch filter-aggregation tutorials](https://www.google.com/search?q=Elasticsearch+filter+aggregations+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

