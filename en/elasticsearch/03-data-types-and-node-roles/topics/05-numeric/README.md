# Numeric Fields

> Chapter 03: Data Types and Node Roles · Lesson 05

[Read the Persian version](../../../../../fa/elasticsearch/03-data-types-and-node-roles/topics/05-numeric/README.md)

## Learning goals

- Select a numeric type appropriate to the value range and precision.
- Use numeric mappings for ranges, sorting, and metric aggregations.
- Define a clear unit and precision for money or measurements.

## Range, precision, and units

Elasticsearch supports integer, floating-point, and scaled floating-point types. Choose a type based on the expected range and precision. An integer such as a count or amount in the smallest currency unit avoids binary floating-point representation issues for some monetary models. A `scaled_float` stores values using a configured scaling factor. A floating-point type can be appropriate for measurements where approximate binary precision is acceptable. A numeric field should represent a numeric value, not a string that merely looks numeric.

~~~http
PUT /products-v1
{"mappings":{"properties":{
  "price_minor":{"type":"long"},
  "weight_kg":{"type":"scaled_float","scaling_factor":1000}
}}}

POST /products-v1/_search
{"query":{"range":{"price_minor":{"gte":5000,"lte":15000}}}}
~~~

The example price is in a documented minor currency unit; it is not self-describing without currency and unit metadata. Do not mix cents and dollars across documents. Avoid floating-point equality comparisons for exact business amounts. Use range boundaries and rounding rules that match the business contract. If a value is only displayed but never searched or aggregated, consider whether it needs indexing.

## Exercise

Choose a mapping for product prices in two currencies, item counts, and package weights. State the unit, allowed range, rounding behavior, and whether exact equality, range search, sorting, or sums are needed.

## Quiz with answers

1. **Why should a numeric-looking value not be mapped as text?** Numeric range, sorting, and metric aggregation semantics would not apply correctly.
2. **When can a scaled float be useful?** When a fixed precision scale is appropriate and the factor is documented.
3. **Why does `price_minor` need unit documentation?** The stored number alone does not say which currency or denomination it represents.
4. **Is binary floating point always suitable for exact money comparisons?** No. Use a representation and rounding contract appropriate to exact monetary values.

## References and further reading

- [Number field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number) — numeric mapping types and parameters.
- [Range query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-range-query) — numeric and date intervals.
- [Sum aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-sum-aggregation) — aggregate numeric values.
- [Doc values](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/doc-values) — sorting and aggregation storage.
- Persian discovery search (not a verified article): [Persian tutorials about numeric field mapping](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4+Elasticsearch+numeric+field+mapping+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

