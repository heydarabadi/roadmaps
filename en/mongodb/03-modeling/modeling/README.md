# Data Modeling: Embed or Reference

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/03-modeling/modeling/README.md).

> **Learning goal:** Design document shape from application access patterns, consistency needs, and bounded growth.

## Begin with the queries

MongoDB data modeling should start with the questions the application asks. List its common reads, writes, filters, sorts, and consistency rules before choosing collections. “Normalize everything” and “embed everything” are both poor universal rules.

For each access pattern, ask:

1. Which documents must be read together?
2. How many related records exist, and can that number grow without a bound?
3. Do they share a lifecycle and update frequency?
4. Must related values be changed atomically?
5. Will the query be targeted by a stable key or require many collection lookups?

## Embedding

Embedding places related fields or documents inside one parent document. It is useful when the child data is bounded, usually read with the parent, and shares its lifecycle. A single-document write is atomic, so embedding can simplify updates that must preserve one-document invariants.

Examples include a product's small set of attributes, a shipping-address snapshot on an order, or a bounded list of a few recent events. Embedded snapshots are often intentional duplication: an order should preserve the product title and price at purchase time, even if the current product changes later.

Do not embed an unlimited number of comments, transactions, or historical events in a user. That creates large documents, expensive updates, and a path to the 16 MiB limit.

## Referencing

Store related data in another collection and keep an identifier when it has an independent lifecycle, can grow without a limit, or is queried/paginated separately. References avoid unbounded parent growth and can prevent repeatedly copying mutable data.

The trade-off is more reads or a `$lookup`, and the application may need to coordinate changes across documents. A reference by itself does not enforce a foreign-key constraint; the application, unique indexes, transactions, or reconciliation process must preserve the needed rule.

## Patterns for deliberate duplication

- **Extended reference:** copy a small stable subset of a referenced document to avoid a frequent lookup.
- **Subset:** embed the most recently used bounded subset and keep full history in another collection.
- **Bucket:** group a bounded number or time interval of related events into one document.
- **Computed:** store a derived value that is expensive to calculate repeatedly, with a clear refresh rule.
- **Polymorphic:** use one collection for related document shapes when they share important queries and indexes; validate the variants.

Every pattern needs a source-of-truth rule and a way to repair stale duplicated data.

## Worked design: orders

Keep an order in its own collection if users paginate through many orders. Store a `customerId` reference and snapshots of the shipping address and purchased item names/prices. Keep a bounded `items` array for the line items of that one order. Do not store the customer's unbounded order history inside the customer document.

## Practical case: Victoria’s Secret

MongoDB's published customer story describes a schema-aware replication approach during a large data migration. It is useful as a reminder to inventory data shape and move it in stages. The story is vendor/customer-authored and its numbers are not an independent benchmark. [Victoria’s Secret story](https://www.mongodb.com/solutions/customer-case-studies/victorias-secret)

## Common mistakes

- Modeling from an entity diagram while ignoring real queries.
- Embedding an unbounded array.
- Duplicating mutable data without choosing a source of truth.
- Treating references as enforced foreign keys.
- Using `$lookup` for every read without measuring cost.

## Exercises

1. Model a customer and order history for a page that shows the latest 20 orders.
2. Choose what to snapshot on an order and what to reference.
3. For a telemetry stream, compare one ever-growing array with time buckets and a separate event collection.
4. State the repair process for a duplicated customer display name.

## Quiz and answer key

1. **What should drive MongoDB schema design?** Access patterns, invariants, relationship cardinality, and growth.
2. **When is embedding a good fit?** Related bounded data is usually read together and shares a lifecycle.
3. **When is a reference a better fit?** The related set is unbounded or independently queried/updated.
4. **Why avoid putting every user event in one document?** The document grows without a bound, creating write/read cost and a risk of exceeding the size limit.
5. **Applied task: model order history.** Keep orders in a separate collection, reference the customer, and store purchase-time snapshots inside each bounded order.
6. **Why snapshot an address on an order?** To preserve the address used at purchase even if the customer's current address changes.
7. **Does a reference enforce a foreign key?** No. Application and database design must preserve the invariant.
8. **What is an extended reference pattern?** Copy a small frequently used subset of a related document.
9. **What does a bucket pattern do?** Groups a bounded set or time range of events into one document.
10. **What must every duplicated field have?** A source-of-truth rule and a way to refresh or repair copies.

## Further reading

- [MongoDB Data Modeling](https://www.mongodb.com/docs/manual/data-modeling/)
- [Embedded Data](https://www.mongodb.com/docs/manual/data-modeling/embedding/)
- [References](https://www.mongodb.com/docs/manual/data-modeling/referencing/)
- [Data Modeling Concepts — MongoDB](https://www.mongodb.com/resources/basics/databases/data-modeling)
- [Schema Design Patterns — MongoDB University](https://learn.mongodb.com/courses/schema-design-patterns)
- [Advanced Schema Design Patterns — MongoDB University](https://learn.mongodb.com/courses/advanced-schema-design-patterns)
- [Persian modeling guide — Urhoba](https://www.urhoba.net/fa/post/mongodb-7)
- [Victoria’s Secret customer story](https://www.mongodb.com/solutions/customer-case-studies/victorias-secret)
- [Curated reference library: modeling](../../reference-library.md#modeling-schema)

---
Sources reviewed: 2026-11-11.
