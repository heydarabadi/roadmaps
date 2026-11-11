# CRUD and Bulk Writes

> **Persian edition:** [Read this lesson in Persian](../../../02-operations/crud/readme.md).

> **Learning goal:** Create, read, update, and delete documents with deliberate filters, types, and result checks.

CRUD means **Create, Read, Update, Delete**. Most data access work is a small set of these operations repeated through a language driver or `mongosh`. Before each write, know which records can match and how the application will interpret the result.

## Create documents

`insertOne()` writes one document; `insertMany()` writes a batch. Every document needs a unique `_id`. If omitted, the driver generally generates an ObjectId. Validate types before writing: a date should be a BSON Date, a precise amount should use an intentional numeric representation, and arrays should have known growth behavior.

~~~javascript
db.products.insertOne({
  sku: "KB-01",
  title: "Keyboard",
  price: NumberDecimal("49.90"),
  stock: 12,
  active: true,
  createdAt: new Date()
})
~~~

For a batch, decide what happens if one item fails. Ordered inserts stop at the first error; unordered inserts can continue with other operations. Do not assume the entire batch is one all-or-nothing transaction.

## Read documents

`find(filter, projection)` returns a cursor. An empty filter returns every document, so apply a bounded filter and `limit()` when exploring data. Use projection to return only fields the client needs.

~~~javascript
db.products.find(
  { active: true, stock: { $gt: 0 } },
  { sku: 1, title: 1, price: 1, _id: 0 }
).sort({ price: 1 }).limit(20)
~~~

`findOne()` returns one matching document or `null`; without a sort, which matching document is returned is not a stable business rule. Specify a deterministic sort when selection matters.

## Update documents

An update filter selects the target. An update document uses operators such as `$set`, `$inc`, and `$unset`. A replacement operation replaces the full document, which can remove fields not present in the replacement. Prefer an operator update for a partial change.

~~~javascript
db.products.updateOne(
  { sku: "KB-01" },
  { $set: { active: false }, $currentDate: { updatedAt: true } }
)
~~~

Read `matchedCount` and `modifiedCount` separately. A matched document may have already contained the requested value, so it might not count as modified. For concurrent inventory updates, put the precondition in the filter and change the value atomically:

~~~javascript
db.products.updateOne(
  { sku: "KB-01", stock: { $gte: 1 } },
  { $inc: { stock: -1 } }
)
~~~

If `matchedCount` is zero, the application must handle out of stock, inactive, or unknown product according to its contract.

## Delete documents

`deleteOne()` removes the first match. `deleteMany()` removes all matches and should be treated as a high-impact operation. Before deleting, run the same filter with `find()` and count the matches. In production workflows, add an approval or dry-run step, keep a recovery path, and avoid broad empty filters.

## Bulk write

`bulkWrite()` combines inserts, updates, replacements, and deletes into fewer round trips. Use it to improve throughput for independent operations, not to assume transaction semantics. In unordered mode, operations can be processed out of order; collect per-operation errors and make retries safe.

## Safe write checklist

1. Use a narrow, indexed, business-correct filter.
2. Check the BSON types and update operator.
3. Preview the matched documents for broad or destructive changes.
4. Set `upsert: true` only when insertion on a miss is intended.
5. Inspect the result counts and error details.
6. Ensure a retry cannot create duplicate business effects.

## Exercise

1. Find active products cheaper than 100 and return only `sku`, `title`, and `price`.
2. Deactivate one product and distinguish matched from modified count.
3. Delete a practice record only after previewing the filter matches.
4. Write an update that decrements stock only when stock is at least one.

## Common mistakes

- Running `updateMany()` or `deleteMany()` with a filter broader than intended.
- Confusing update operators with full replacement.
- Ignoring `matchedCount`, `modifiedCount`, and write errors.
- Assuming `insertMany()` or `bulkWrite()` is a transaction.
- Reading stock and then decrementing it with a separate, unconditional write.

## Quiz and answer key

1. **What does CRUD stand for?** Create, Read, Update, and Delete.
2. **What does `find()` return?** A cursor over matching documents.
3. **What is a key difference between `matchedCount` and `modifiedCount`?** The first counts documents selected; the second counts documents whose stored values changed.
4. **Why distinguish an update operator from a replacement?** Replacement overwrites the document shape; `$set` changes only the named fields.
5. **Applied task: decrement inventory safely.** Filter by the product key and `stock: {$gte: 1}`, then use `$inc: {stock: -1}` and inspect the result.
6. **When is `findOne()` nondeterministic for business purposes?** When several documents match and no stable sort specifies which one to choose.
7. **Is bulk write automatically all-or-nothing?** No. It batches operations; use a transaction for a cross-document atomicity requirement.
8. **What should happen before a destructive multi-delete?** Preview the same filter, count its matches, and establish recovery controls.
9. **When should `upsert` be enabled?** When a missing match should intentionally create a document.
10. **Why is a conditional decrement safer than read-then-write?** The filter and update enforce the stock condition atomically under concurrency.

## Further reading

- [CRUD Operations](https://www.mongodb.com/docs/manual/crud/)
- [Insert Documents](https://www.mongodb.com/docs/manual/tutorial/insert-documents/)
- [Update Documents](https://www.mongodb.com/docs/manual/tutorial/update-documents/)
- [Delete Documents](https://www.mongodb.com/docs/manual/tutorial/remove-documents/)
- [Bulk Write Operations](https://www.mongodb.com/docs/manual/core/bulk-write-operations/)
- [Persian CRUD guide — Urhoba](https://www.urhoba.net/fa/post/mongodb-9)
- [Curated reference library: CRUD and updates](../../reference-library.md#operations-crud)

---
Sources reviewed: 2026-11-11. Run destructive examples only against a learning database.
