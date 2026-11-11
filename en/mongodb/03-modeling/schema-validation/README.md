# Schema Validation and Versioning

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/03-modeling/schema-validation/README.md).

> **Learning goal:** Enforce document shape at the database boundary and migrate schemas without breaking active readers and writers.

## What validation can enforce

MongoDB validation can require fields, check BSON types, constrain values, and validate nested objects and arrays. It is a guardrail for application services, scripts, administrative tools, and future writers. Validation cannot decide every business rule, especially one that depends on another collection or an external system.

## JSON Schema validator example

~~~javascript
db.createCollection("orders", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["customerId", "status", "createdAt", "items"],
      properties: {
        customerId: { bsonType: "objectId" },
        status: { enum: ["open", "paid", "shipped", "cancelled"] },
        createdAt: { bsonType: "date" },
        items: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["sku", "quantity"],
            properties: {
              sku: { bsonType: "string" },
              quantity: { bsonType: "int", minimum: 1 }
            }
          }
        }
      }
    }
  },
  validationAction: "error"
})
~~~

The exact BSON type emitted by a driver matters. A value that prints as `2` might be Int32, Int64, or Double depending on encoding and value range. Check representative stored documents before making the validator strict.

## `validationAction` and validation level

An `error` action rejects invalid inserts and updates. A `warn` action logs violations while allowing writes, which can help identify existing writer problems before enforcement. Validation level controls whether rules apply to all documents or only new/modified documents. These options are migration tools, not a substitute for understanding current data.

## Evolve a schema: expand, migrate, contract

1. **Inventory:** measure old document shapes and all writers.
2. **Expand:** introduce a new field or accept both formats.
3. **Read compatibly:** deploy readers that can handle the old and new shape.
4. **Write the new format:** update writers and observe errors.
5. **Migrate:** update old documents in bounded, resumable batches.
6. **Verify:** compare counts, sampled records, and application behavior.
7. **Contract:** reject/remove the old format after old clients and data are gone.

This sequence reduces the chance that a deployment or validator blocks valid traffic halfway through a rollout.

## Exercise

Write a validator requiring `status` to be one of three allowed values, `createdAt` to be Date, and `items` to be a non-empty array. Then plan how to discover and migrate existing records that violate it.

## Common mistakes

- Assuming schema validation discovers or repairs existing bad data automatically.
- Requiring an Int32 when a driver writes an Int64.
- Enabling strict validation before old writers and records are understood.
- Enforcing cross-collection rules with a validator that can only inspect one document.
- Running an unbounded migration update during peak traffic.

## Quiz and answer key

1. **What can a JSON Schema validator check?** Required fields, BSON types, value constraints, and nested document/array structure.
2. **Does validation repair old documents?** No. It governs writes; audit and migrate existing data separately.
3. **What does `validationAction: "error"` do?** Rejects writes that fail validation.
4. **Why avoid strict validation before auditing current data?** Valid existing write paths may fail because old records or writers use another shape or type.
5. **Applied task: validate orders.** Require `status`, Date-valued `createdAt`, and a non-empty items array with typed SKU and positive quantity.
6. **Why inspect the BSON type emitted by a driver?** The printed value may hide a difference between Int32, Int64, and Double.
7. **How can `warn` help?** It records violations while allowing writes during an observation period.
8. **What is the purpose of expand–migrate–contract?** Let old and new readers/writers coexist safely while data is moved.
9. **Can a collection validator prove a field exists in another collection?** No; it validates the current document only.
10. **Why migrate in bounded batches?** To control load, allow checkpoints, and resume safely after errors.

## Further reading

- [Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/)
- [Specify JSON Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/specify-json-schema/)
- [Handle Invalid Documents](https://www.mongodb.com/docs/manual/core/schema-validation/handle-invalid-documents/)
- [Schema Versioning Pattern](https://www.mongodb.com/docs/manual/data-modeling/design-patterns/data-versioning/schema-versioning/)
- [Data Modeling Concepts — MongoDB](https://www.mongodb.com/resources/basics/databases/data-modeling)
- [Persian MongoDB learning series — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [Curated reference library: schema evolution](../../reference-library.md#modeling-schema)

---
Sources reviewed: 2026-11-11. Check the BSON type and validation behavior of the target server and driver.
