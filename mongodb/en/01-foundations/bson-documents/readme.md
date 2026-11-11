# Documents, BSON, and Data Types

> **Persian edition:** [Read this lesson in Persian](../../../01-foundations/bson-documents/readme.md).

> **Learning goal:** Choose BSON types deliberately, understand document boundaries, and avoid confusing missing values with `null`.

## JSON and BSON

JSON is a readable text format commonly used for APIs. BSON is MongoDB's binary document representation. BSON adds explicit types such as ObjectId, Date, Binary, Decimal128, Timestamp, and fixed-width integers. Drivers convert language values to BSON when sending commands and map returned BSON values back to language values. A value that looks like a JavaScript number may not have the same type after encoding, so know how your driver represents large integers and decimals.

## Common BSON types and when to use them

| BSON type | Typical use and caution |
|---|---|
| String | Names, labels, codes, and text; define normalization and length rules. |
| Boolean | A true/false flag. |
| Int32 / Int64 (`long`) | Whole-number counts within a chosen range; verify driver mappings. |
| Double | Approximate floating-point measurement; not the default for exact currency. |
| Decimal128 | Base-10 decimal values with finite precision, useful for money when paired with currency and rounding rules. |
| Date | A UTC instant stored in milliseconds since the Unix epoch. |
| Timestamp | An internal MongoDB type with an ordinal; use Date for application time. |
| ObjectId | A common unique identifier; approximately time ordered, not a business key or precise clock. |
| Binary / UUID | Bytes and binary identifiers; agree on UUID representation across drivers. |
| Object / Array | Nested structures and bounded lists; guard against unbounded growth. |
| Null / missing field | Distinct states that affect filters and validation. |
| Regular expression | A BSON type; a query pattern using `$regex` is a separate query feature. |
| MinKey / MaxKey | Comparison sentinels; rarely ordinary application values. |
| JavaScript | A legacy BSON type for code; do not use it for application logic. |
| Undefined, Symbol, DBPointer, JavaScript-with-scope | Deprecated legacy types; avoid them in new schemas. |

For everyday application data, focus on String, Boolean, Object, Array, Binary/UUID, ObjectId, Date, Null, Int32, Int64, Double, and Decimal128. The official BSON type reference lists every type and its numeric identifier.

## Example: a measurement document

~~~javascript
use learning

db.measurements.insertOne({
  sensorId: "S-17",
  observedAt: ISODate("2026-11-11T08:00:00Z"),
  temperature: 22.75,
  price: NumberDecimal("12.40"),
  labels: ["pump", "north"],
  location: { building: "A", floor: 2 },
  active: true
})

db.measurements.find({
  observedAt: { $gte: ISODate("2026-11-01T00:00:00Z") },
  "location.building": "A"
})
~~~

Store application timestamps as Date values, not strings. String sorting depends on consistently formatted text and does not provide date operators naturally. Use Decimal128 or integer minor units for exact monetary values; define currency and rounding behavior. Do not mix numeric types for the same field.

## `_id` and ObjectId

Each document in a standard collection has a unique `_id`. When omitted, a driver normally creates an ObjectId. An ObjectId is 12 bytes: a seconds-resolution timestamp, a random process value, and an incrementing counter. ObjectIds are roughly time ordered, but values generated in the same second are not guaranteed to sort exactly by creation time, and different client clocks may disagree. Use a separate business identifier such as `invoiceNumber` when the domain needs one.

## Document size and growth

The maximum BSON document size is 16 MiB. Large documents and unbounded arrays increase read, write, and index costs; they can eventually hit the size limit. Do not keep an unlimited comment history inside a user document. Store unbounded events in another collection and query them by a stable parent identifier. For large files, consider object storage or a streaming design; use GridFS only when its behavior fits the application.

## Null and missing are different

`{ field: null }` matches documents where `field` is `null` **and** documents where the field is missing. To request an explicit null, combine `$exists: true` with `$eq: null`. To request a missing field, use `$exists: false`. Decide whether “unknown,” “not configured,” and “removed” are distinct states, then enforce one representation consistently.

## UUID and special values

UUID values are stored as Binary with a UUID subtype. Driver settings and historical UUID representations can affect byte order, so configure all services consistently before exchanging identifiers. MinKey and MaxKey are comparison sentinels, not replacements for `null` or an ordinary application value.

## Exercise: model an invoice

Choose types for an internal ID, a customer-facing invoice number, issue time, line-item quantity, exact amount, currency, and status. Keep the line-item array bounded. Explain how the design preserves historical prices when the product catalog changes.

## Common mistakes

- Storing dates as strings and relying on string sorting.
- Using Double for exact monetary values without understanding rounding.
- Putting an unbounded history array inside one document.
- Treating ObjectId as a business identifier or a precise timestamp.
- Mixing null and missing fields without an explicit policy.

## Quiz and answer key

1. **How does BSON differ from JSON?** BSON is a binary encoding with additional explicit data types.
2. **Why can Decimal128 help with prices?** It represents decimal values without the usual binary floating-point approximation, within its finite precision.
3. **What is the document-size limit?** 16 MiB.
4. **Why store an application timestamp as Date instead of a string?** Date supports time comparisons and date operations without relying on text formatting.
5. **Applied task: choose invoice field types.** Use a stable ID, a separate business number, Date, integer quantity, Decimal128 or bounded integer minor units, a currency code, and a controlled status.
6. **Why use Date?** It provides a typed UTC instant for comparison, sorting, and date expressions.
7. **Is an ObjectId an exact clock?** No. Its time component has seconds resolution and generation occurs on clients.
8. **What is the risk of an unbounded array?** It can enlarge a document, add write and index work, and exceed the document limit.
9. **How can an explicit null be distinguished from a missing field?** Require existence and equality to null; use `$exists: false` for absence.
10. **What should services agree on when using UUID values?** The BSON UUID representation and driver codec settings.

## Further reading

- [BSON Types](https://www.mongodb.com/docs/manual/reference/bson-types/)
- [Documents](https://www.mongodb.com/docs/manual/core/document/)
- [Limits and Thresholds](https://www.mongodb.com/docs/manual/reference/limits/)
- [Extended JSON](https://www.mongodb.com/docs/manual/reference/mongodb-extended-json/)
- [BSON specification](https://bsonspec.org/spec.html)
- [Persian BSON guide — Urhoba](https://www.urhoba.net/fa/post/mongodb-11)
- [Curated reference library: BSON and documents](../../reference-library.md#foundations-bson)

---
Sources reviewed: 2026-11-11. Check driver-specific BSON mappings in the official driver manual.
