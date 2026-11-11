# Filters, Operators, Projection, and Cursors

> **Persian edition:** [Read this lesson in Persian](../../../02-operations/queries-cursors/readme.md).

> **Learning goal:** Build correct filters for scalar, nested, and array data; constrain result size and pagination cost.

## Equality and comparison

A filter is a document that describes which records match. `{ status: "paid" }` tests equality. Comparison operators include `$eq`, `$gt`, `$gte`, `$lt`, `$lte`, and `$ne`. Conditions on separate fields are ANDed by default. `$in` matches one of a set of values. Use `$or`, `$and`, `$nor`, and `$not` when the logical shape requires them.

~~~javascript
db.orders.find({
  status: { $in: ["paid", "shipped"] },
  createdAt: {
    $gte: ISODate("2026-11-01T00:00:00Z"),
    $lt: ISODate("2026-11-08T00:00:00Z")
  }
})
~~~

Use `$exists` to test whether a field is present and `$type` to inspect its BSON type. Remember that `{field: null}` also matches a missing field. Validate user input before building a filter; do not let an API caller submit arbitrary MongoDB operators.

## Nested documents and arrays

Use dot notation for nested fields, such as `{"shipping.city": "Tehran"}`. Array operators include `$in`, `$all`, `$size`, and `$elemMatch`. When multiple predicates must apply to the **same array element**, put them in `$elemMatch`:

~~~javascript
db.orders.find({
  items: { $elemMatch: { sku: "KB-01", quantity: { $gte: 2 } } }
})
~~~

Without `$elemMatch`, predicates on paths through an array may be satisfied by different elements, which changes the meaning of the query.

## Projection

Projection chooses which fields a query returns. Use `1` to include fields and `0` to exclude them. Inclusion and exclusion are generally not mixed, except that `_id` can commonly be excluded from an inclusion projection.

~~~javascript
db.orders.find(
  { status: "paid" },
  { customerId: 1, createdAt: 1, total: 1, _id: 0 }
)

db.orders.find({}, { items: { $slice: 5 } })
~~~

`$slice` limits the array elements returned by a find projection. Projection reduces transfer and application memory, but does not replace an index that supports the filter or sort.

## Regular expressions and safety

`$regex` can find simple text patterns. A pattern with a leading wildcard, or one supplied without length and complexity limits, can be expensive. Use anchored patterns and suitable indexes where possible. For richer language-aware search, use a search engine such as Atlas Search rather than extending ad hoc regex rules.

API code should allowlist field names and operators, validate types, cap the time range and page size, and avoid passing raw user filter objects to MongoDB. This limits both injection risk and accidental resource consumption.

## Cursor and pagination

`find()` returns a cursor rather than requiring the full collection in memory. Consume it incrementally or apply a sensible limit. Large `skip()` values require scanning past earlier results and become costly. For a stable page, sort by a unique tie-breaker such as `{createdAt: -1, _id: -1}` and use the last document's values as the next-page boundary.

## Exercise

1. Query paid orders for one customer in a date range.
2. Require that `sku` and `quantity` conditions match the same item.
3. Return a small projection and limit the page size.
4. Design a keyset page boundary using `createdAt` and `_id`.

## Common mistakes

- Applying array conditions to different elements by accident.
- Treating `null` and a missing field as identical.
- Returning every field or consuming every result into memory.
- Using a leading-wildcard regex on a large collection.
- Building filters directly from untrusted client JSON.
- Using deep `skip()` pagination for a high-volume feed.

## Quiz and answer key

1. **What does `$or` require?** At least one listed condition must match.
2. **What does `$elemMatch` guarantee?** Its enclosed conditions apply to one array element.
3. **What does `find()` return?** A cursor that can be iterated.
4. **Why use `$elemMatch` for same-element conditions?** Independent array-path predicates may match different array elements.
5. **Applied task: fetch one week of paid orders.** Filter by status and a half-open Date range, use a stable sort, projection, and bounded keyset pagination.
6. **How does `$exists: false` differ from equality to null?** It asks for a missing field; null equality can also match a missing field.
7. **What does projection reduce?** Returned data size, network transfer, and application memory.
8. **Why can a leading-wildcard regex be expensive?** It often prevents an index from narrowing the search efficiently.
9. **Why limit client-supplied filters?** To prevent unsafe operators and unbounded expensive queries.
10. **What makes keyset pagination stable?** A deterministic sort with a unique tie-breaker and a boundary based on the last result.

## Further reading

- [Query and Projection Operators](https://www.mongodb.com/docs/manual/reference/operator/query/)
- [Query Arrays](https://www.mongodb.com/docs/manual/tutorial/query-arrays/)
- [Project Fields from Query Results](https://www.mongodb.com/docs/manual/tutorial/project-fields-from-query-results/)
- [Cursors](https://www.mongodb.com/docs/manual/core/cursors/)
- [Regex Operator](https://www.mongodb.com/docs/manual/reference/operator/query/regex/)
- [Persian query and cursor guide — Urhoba](https://www.urhoba.net/fa/post/mongodb-11)
- [Curated reference library: filters and cursors](../../reference-library.md#operations-query)

---
Sources reviewed: 2026-11-11.
