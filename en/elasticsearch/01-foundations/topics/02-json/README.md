# JSON

> Chapter 01: Foundations · Lesson 02

[Read the Persian version](../../../../../fa/elasticsearch/01-foundations/topics/02-json/README.md)

## Learning goals

- Read JSON objects, arrays, strings, numbers, booleans, and null values.
- Understand that JSON describes a payload while Elasticsearch mappings define indexed field behavior.
- Model missing values and arrays deliberately.

## Core idea

JSON is a data interchange format, not a complete schema or business contract. Elasticsearch accepts JSON documents and API request bodies, but its mapping decides how each field is interpreted, indexed, and made available for sorting or aggregations. A field that looks like a number in one document and a string in another is a data-quality problem even if both payloads are valid JSON.

~~~json
{
  "sku": "A-100",
  "title": "Mechanical keyboard",
  "price": 89.99,
  "available": true,
  "tags": ["mechanical", "USB"],
  "seller": {"name": "Example Store", "city": "Tehran"}
}
~~~

Here, `sku` and `title` are strings, `price` is numeric, `available` is boolean, `tags` is an array, and `seller` is an object. A price range or sum needs a numeric mapping. If the application sometimes sends `"89.99"`, Elasticsearch may reject it under an explicit numeric mapping or coerce it depending on configuration; relying on implicit conversion can hide upstream defects.

## Arrays and nested objects

Arrays of simple values are commonly indexed as multiple values of the same field. Elasticsearch does not require a special array type. Arrays of objects need extra care: ordinary object fields are flattened, so a query for `color=red AND size=large` can match values that came from different objects in the same array. Use the `nested` type only when conditions must apply to the same array member; it has additional indexing and query costs.

Missing, explicit `null`, an empty string, and zero are not interchangeable. For example, an absent `price` can mean “not supplied,” `null` can mean “unknown,” and zero can be a legitimate value. Define those meanings in the producer and use `exists` or application validation accordingly.

## Practical modeling exercise

Design an order document with `order_id`, `customer_id`, `created_at`, `status`, `total`, and `items`. For every field, write down whether the application needs full-text search, exact matching, a numeric/date range, sorting, or aggregation. Those requirements—not merely the JSON shape—should drive the mapping.

## Quiz with answers

1. **Why does valid JSON not guarantee a good Elasticsearch document?** JSON validates syntax; it does not guarantee stable types, meaningful null semantics, or an appropriate mapping.
2. **Why should price be sent as a number?** Numeric values support numeric range queries, sorting, and metrics aggregations; strings have lexical rather than numeric semantics.
3. **When is `nested` useful?** When multiple conditions must match one particular object in an array rather than values scattered across different array elements.
4. **Are missing, null, empty string, and zero equivalent?** No. They have different data and query meanings and should be specified by the application contract.

## References and further reading

- [Elasticsearch field data types](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/field-data-types) — supported field types.
- [Mapping](https://www.elastic.co/docs/manage-data/data-store/mapping) — how JSON fields become indexed fields.
- [Object field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/object) and [nested field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/nested) — array-of-object behavior and its solution.
- [Explicit mapping examples](https://www.elastic.co/docs/manage-data/data-store/mapping/explicit-mapping) — declare field behavior up front.
- [Elasticsearch REST API concepts](https://www.elastic.co/docs/reference/elasticsearch/rest-apis) — JSON request and response patterns.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

