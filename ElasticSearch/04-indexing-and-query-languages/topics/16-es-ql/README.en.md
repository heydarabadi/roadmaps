# ES|QL

> Chapter 04: Indexing and Query Languages · Lesson 16

[Read the Persian version](README.md)

## Learning goals

- Read an ES|QL query as a sequence of pipe-connected processing steps.
- Filter, compute, group, and sort tabular results.
- Check version and capability before choosing ES|QL for an application endpoint.

## Think in a pipeline

ES|QL is a piped query language for retrieving and transforming data. A command reads a source; later stages filter rows, calculate derived columns, aggregate, or sort. Since each stage consumes the previous stage's output, the order of operations affects both meaning and cost.

~~~text
FROM products-v1
| WHERE available == true AND price < 5000
| STATS avg_price = AVG(price) BY brand
| SORT avg_price DESC
~~~

The query selects available products under a threshold, groups by brand, computes an average price, and sorts groups by that average. Validate command names, field types, and syntax against the Elasticsearch version and project capabilities in use. ES|QL offers a readable analysis flow, but it is not a complete substitute for every Search API or Query DSL capability. For an interactive analysis workflow it can be convenient; for a relevance-ranked product search API, Query DSL may express the needed query more directly.

## Exercise

Use ES|QL to select orders from a time window, calculate a normalized revenue column, group by region, and sort by revenue. Recreate the equivalent using a Search API query and aggregation. Compare readability, result shape, available operations, and runtime behavior.

## Quiz with answers

1. **What is the visual structure of ES|QL?** A sequence of commands connected with `|`.
2. **Why does command order matter?** Each stage transforms or filters the output from earlier stages.
3. **Does ES|QL replace all Query DSL searches?** No. Feature coverage and query purpose differ, so compare the version-specific capabilities.
4. **What might ES|QL be useful for?** Exploring, filtering, transforming, and aggregating tabular data.

## References and further reading

- [ES|QL reference](https://www.elastic.co/docs/reference/query-languages/esql) — syntax and commands.
- [ES|QL tutorial](https://www.elastic.co/docs/reference/query-languages/esql/esql-tutorial) — progressive examples.
- [ES|QL functions](https://www.elastic.co/docs/reference/query-languages/esql/esql-functions-operators) — supported expressions and operators.
- [ES|QL limitations](https://www.elastic.co/docs/reference/query-languages/esql/esql-limitations) — capability boundaries.
- [Query DSL](https://www.elastic.co/docs/reference/query-languages/query-dsl) — compare JSON-native search composition.
- Persian discovery search (not a verified article): [Persian articles and tutorials about ES|QL](https://www.google.com/search?q=Elasticsearch+ES%7CQL+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

