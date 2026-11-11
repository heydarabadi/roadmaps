# The `must_not` Clause

> Chapter 06: How Search Works · Lesson 05

[Read the Persian version](README.md)

## Learning goals

- Exclude documents that match a prohibited condition.
- Understand that `must_not` does not add positive relevance score.
- Handle missing fields separately from explicit values.

## Exclusion logic

`must_not` removes documents matching its clause from the result set. It is useful for excluding hidden products, blocked states, or records outside a permitted category. It does not create a positive relevance signal. Use it together with positive match conditions and filters to express the complete search intent.

~~~http
POST /products-v1/_search
{"query":{"bool":{
  "must":[{"match":{"title":"mobile phone"}}],
  "must_not":[{"term":{"status":"hidden"}}]
}}}
~~~

An absent `status` is not equivalent to `status: active`. If products without a status should be excluded too, add the appropriate existence logic rather than assuming the negative term covers missing values. Broad negative conditions can eliminate more documents than expected; preview the query against controlled examples and inspect mappings.

## Exercise

Create documents with hidden, active, and missing status. Search for phones while excluding hidden products. Then modify the business requirement so missing status is also excluded and add the necessary condition. Compare both result sets.

## Quiz with answers

1. **What does `must_not` do?** Excludes documents that match its clause.
2. **Does it add positive score?** No; it acts as a filter-style exclusion.
3. **Does excluding `status:hidden` exclude documents with no status?** No. Missing-field handling needs its own condition.
4. **How should broad negative logic be tested?** Use representative documents and validate expected results before deployment.

## References and further reading

- [Boolean query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query) — `must_not` semantics.
- [Exists query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-exists-query) — handle missing indexed values.
- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context) — filter-context behavior.
- [Term query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-term-query) — exact status exclusion.
- [Explain API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-explain) — inspect why an individual document did not match.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

