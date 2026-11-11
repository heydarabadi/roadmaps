# Cursors, Counts, and Read/Write Concerns

> **Persian edition:** [Read this lesson in Persian](../../../02-operations/cursor-count-concerns/readme.md).

> **Learning goal:** Distinguish result iteration and count semantics from the consistency settings that govern reads and writes.

## A cursor is an iterator

`find()` returns a cursor. The driver obtains results in batches rather than requiring every matching document in memory at once. Consume the cursor incrementally, project only fields you need, and set a suitable limit. A cursor has a lifecycle: exhaust or close it, and do not assume it is a reusable array.

## Count methods answer different questions

- `countDocuments(filter)` counts documents matching the filter. It is appropriate when the application needs a filtered count, though the query may cost work.
- `estimatedDocumentCount()` estimates the total collection size from metadata and does not accept a filter.
- Avoid old count APIs whose behavior may not match the intended meaning. Choose based on whether exact filtered results or a fast total estimate is required.

Do not calculate a count by downloading all matching records to the application. If an interface displays a total on every page, consider whether an exact count is necessary and whether its latency is acceptable.

## Offset and keyset pagination

`skip(n)` discards the first `n` results. It can be fine for small offsets but becomes expensive at high offsets. Keyset pagination uses a stable sort and a boundary from the last item in the previous page.

~~~javascript
// Sort newest first, with _id as a unique tie-breaker.
db.orders.find({ customerId: "C-200" })
  .sort({ createdAt: -1, _id: -1 })
  .limit(50)

// For the next page, use the last page's createdAt and _id values.
db.orders.find({
  customerId: "C-200",
  $or: [
    { createdAt: { $lt: lastCreatedAt } },
    { createdAt: lastCreatedAt, _id: { $lt: lastId } }
  ]
}).sort({ createdAt: -1, _id: -1 }).limit(50)
~~~

Create an index that supports the equality filter and ordering, then test it with `explain()`.

## Three separate consistency choices

- **Read preference** selects the member or members that may serve a read, such as the primary or a secondary.
- **Read concern** controls the consistency/visibility level of data returned. `local`, `majority`, and `snapshot` have distinct semantics.
- **Write concern** controls the acknowledgment requested for a write, such as `w: 1` or `w: "majority"`.

These settings solve different problems. Reading from a secondary may return stale data; stronger read concern does not change which member the driver chooses. Write concern and journaling/topology affect durability behavior, so reason about the full deployment rather than the option's name alone.

## Retryable operations and application idempotency

Drivers can retry some eligible reads and writes after transient network or server-selection errors. This is not a guarantee of exactly-once business behavior for every operation. A request that creates an order, charges a payment, or decrements stock needs a durable idempotency key or unique request identifier. After an unknown outcome, query the operation's status rather than blindly performing a second business action.

## Exercise

1. Choose `countDocuments` or `estimatedDocumentCount` for three UI needs.
2. Write the next-page filter for descending `{createdAt, _id}`.
3. Pick read preference, read concern, and write concern separately for a product feed and checkout.

## Common mistakes

- Treating a cursor as an in-memory list.
- Using deep `skip()` for a high-volume feed.
- Using estimated metadata as an exact filtered count.
- Confusing read preference with read concern.
- Blindly retrying an operation with an unknown result.

## Quiz and answer key

1. **What is a cursor?** An iterator over query results, fetched in batches.
2. **Which count accepts a filter?** `countDocuments(filter)`.
3. **Which method estimates total collection size?** `estimatedDocumentCount()`.
4. **Why are read preference and read concern separate?** Preference chooses where to read; concern describes what visibility/consistency level is accepted.
5. **Applied task: paginate a customer’s orders.** Sort by `{createdAt: -1, _id: -1}`, then query the next page using a boundary on both values.
6. **Why use a unique tie-breaker in a page sort?** It makes ordering deterministic when timestamps are equal.
7. **Why can deep `skip()` become slow?** Earlier results still must be traversed before later ones are returned.
8. **What does write concern control?** The acknowledgment level requested for a write.
9. **Does retryable write mean exactly-once business behavior?** No. Use idempotency for business operations.
10. **What should the application do after an unknown payment outcome?** Query durable payment/order state with its idempotency key and reconcile before retrying the business action.

## Further reading

- [Cursors](https://www.mongodb.com/docs/manual/core/cursors/)
- [Count Documents](https://www.mongodb.com/docs/manual/reference/method/db.collection.countDocuments/)
- [Estimated Document Count](https://www.mongodb.com/docs/manual/reference/method/db.collection.estimatedDocumentCount/)
- [Read Concern](https://www.mongodb.com/docs/manual/reference/read-concern/)
- [Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)
- [Read Preference](https://www.mongodb.com/docs/manual/core/read-preference/)
- [Retryable Reads and Writes](https://www.mongodb.com/docs/manual/core/retryable-reads/)
- [Persian cursor guide — Urhoba](https://www.urhoba.net/fa/post/mongodb-11)
- [Curated reference library: cursor and concerns](../../reference-library.md#operations-concerns)

---
Sources reviewed: 2026-11-11. Check the matching driver manual for API-specific behavior.
