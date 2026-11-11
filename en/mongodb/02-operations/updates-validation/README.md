# Updates, Arrays, bulkWrite, and Validation

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/02-operations/updates-validation/README.md).

> **Learning goal:** Choose a safe update operator, handle array changes, and validate document shape at the database boundary.

## Update operator families

Use `$set` to assign a value, `$unset` to remove a field, `$inc` to change a numeric value atomically, and `$currentDate` to record server time. `$min` and `$max` change a value only when the proposed value crosses a bound. `$rename` changes a field name. Operators preserve unspecified document fields; replacement writes replace the whole document.

~~~javascript
db.products.updateOne(
  { sku: "KB-01", stock: { $gte: 1 } },
  { $inc: { stock: -1 }, $currentDate: { updatedAt: true } }
)
~~~

Put critical preconditions in the filter. A separate read followed by a non-conditional write can race with another request.

## Arrays

- `$push` appends an element; `$each` adds multiple values and can be combined with `$sort` and `$slice` to bound a list.
- `$addToSet` prevents adding an equal value twice; it does not clean duplicates that already exist.
- `$pull` removes elements that match a predicate.
- Positional update operators change a matched array element. `arrayFilters` can target matching elements in nested or multi-element arrays.

Use these operators only when the array is bounded and belongs in the parent document. If a list grows indefinitely or needs independent pagination, consider a separate collection.

## Upsert

`upsert: true` inserts a document when the filter matches nothing. This is useful for deliberate insert-or-update operations, but a weak filter may create duplicate or incomplete data. Use a natural key and a unique index where the domain requires one, and construct inserted fields carefully with `$setOnInsert`.

## bulkWrite

`bulkWrite()` groups `insertOne`, `updateOne`, `updateMany`, `replaceOne`, and delete models. Ordered mode stops at an error; unordered mode can continue. Neither mode automatically provides one atomic transaction across all documents. Keep operations independent where possible, make retries idempotent, and inspect bulk error details.

## Schema validation

Schema validation can require fields and BSON types, constrain values, and reject or warn about invalid writes. Application validation gives a friendly early error; database validation protects against other writers, scripts, and future services. Neither replaces domain rules that depend on external state.

When changing a schema, use **expand → migrate → contract**:

1. Add a backward-compatible field or representation.
2. Update readers to understand old and new shapes.
3. Deploy writers that produce the new shape.
4. Migrate existing data in bounded batches.
5. Verify counts and application behavior.
6. Tighten validation and remove the old shape only after all writers are upgraded.

## Exercise

1. Add a tag without duplicating an existing value.
2. Update all matching line items using `arrayFilters`.
3. Write a validator requiring `status` and a Date-valued `createdAt`.
4. Explain which stage of expand–migrate–contract comes before strict validation.

## Common mistakes

- Enabling upsert without thinking about the insert case.
- Replacing an entire document when only one field should change.
- Assuming `$addToSet` repairs old duplicates.
- Using `updateMany()` without previewing the filter.
- Tightening validation before existing documents and writers are compatible.
- Treating a bulk write as a transaction.

## Quiz and answer key

1. **What does `$inc` do?** Atomically adds a numeric amount to a field.
2. **How does `$addToSet` differ from `$push`?** It avoids adding an equal value that is already present; `$push` appends regardless.
3. **When does an upsert insert?** When no document matches and `upsert` is enabled.
4. **Why can an unintended upsert be harmful?** A miss creates a new document; an incomplete filter can create an unwanted record rather than updating the intended one.
5. **Applied task: add a unique tag.** Use `$addToSet`, then validate the field and old data separately.
6. **What is `arrayFilters` for?** Targeting array elements that meet conditions during an update.
7. **What does a replacement update do?** Replaces the document's content, except for `_id` handling.
8. **Why use database schema validation as well as application checks?** It protects writes from every client, including scripts and services that bypass one application path.
9. **What does expand–migrate–contract reduce?** Risk while old and new application/data shapes coexist.
10. **Does unordered bulkWrite guarantee execution order?** No; operations can proceed in any order and errors must be collected.

## Further reading

- [Update Documents](https://www.mongodb.com/docs/manual/tutorial/update-documents/)
- [Update Operators](https://www.mongodb.com/docs/manual/reference/operator/update/)
- [Update Arrays in a Document](https://www.mongodb.com/docs/manual/reference/operator/update-array/)
- [Bulk Write Operations](https://www.mongodb.com/docs/manual/core/bulk-write-operations/)
- [Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/)
- [Persian CRUD/update series — Urhoba](https://www.urhoba.net/fa/post/mongodb-9)
- [Curated reference library: CRUD and validation](../../reference-library.md#operations-crud)

---
Sources reviewed: 2026-11-11.
