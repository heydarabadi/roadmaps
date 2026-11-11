# Boolean Fields

> Chapter 03: Data Types and Node Roles · Lesson 06

[Read the Persian version](../../../../../fa/elasticsearch/03-data-types-and-node-roles/topics/06-boolean/README.md)

## Learning goals

- Map a genuine two-state property as boolean.
- Distinguish false from missing or unknown.
- Use a term filter for a non-scoring eligibility condition.

## Model the meaning, not just the label

A boolean field represents a true-or-false value, such as whether an item is published. It should not be used to collapse a richer workflow into two values if states such as pending, unknown, or not applicable matter. A missing field has no indexed boolean value and can mean the producer did not send it or the state is unknown. That is different from `false`.

~~~http
PUT /products-v1/_doc/sku-100
{"title":"Keyboard","available":false}

POST /products-v1/_search
{"query":{"term":{"available":true}}}
~~~

For a hard eligibility condition, place a boolean term query in `bool.filter`; it does not need relevance scoring. Define how producers serialize the value and validate it. If a missing value should count as false in a business rule, express that rule explicitly in the query or normalize the data at ingest instead of assuming missing and false are the same.

## Exercise

Model whether an article is published, but also consider draft, scheduled, and archived states. Decide if a boolean is enough. Then query only products that are both available and in a selected category.

## Quiz with answers

1. **Does `available: false` mean the same thing as an absent field?** No. False is an explicit state; absence may mean unknown or not supplied.
2. **How should a true boolean eligibility condition usually be queried?** As a term filter in `bool.filter`.
3. **When is a boolean inadequate?** When the domain has more than two meaningful states.
4. **How can a producer typo be prevented?** Validate and normalize the field contract before indexing.

## References and further reading

- [Boolean field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/boolean) — accepted representations and mapping behavior.
- [Term query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-term-query) — exact-value matching.
- [Boolean query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query) — scoring and filter clauses.
- [Exists query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-exists-query) — detect indexed values.
- Persian discovery search (not a verified article): [Persian articles on Elasticsearch boolean fields](https://www.google.com/search?q=Elasticsearch+boolean+field+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

