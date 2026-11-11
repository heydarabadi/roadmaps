# What Is MongoDB, and When Should You Choose It?

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/01-foundations/what-is-mongodb/README.md).

> **Learning goal:** Explain the document model and choose a database from workload requirements rather than slogans.

## Start with the role of a database

An application must preserve information between requests, find the right records, and change them safely. A database server stores that state under rules. A client can be `mongosh`, Compass, or an application using an official driver. Atlas is MongoDB's managed cloud database service; self-managed MongoDB is operated by your team.

Relational databases organize data primarily into tables and rows. MongoDB stores BSON documents inside collections. A document can contain fields, nested documents, and arrays. That shape can make it natural to read a bounded set of related data together. It does **not** mean there are no relationships, schemas, joins, or transactions: MongoDB supports references, `$lookup`, validation, and multi-document transactions.

## Vocabulary through a store example

- **Database:** a logical namespace, such as `shop`.
- **Collection:** a group of related documents, such as `products` or `orders`.
- **Document:** one product, customer, or order record.
- **Field/value:** a name and its typed value, such as `price: Decimal128("49.90")`.
- **Index:** a maintained structure that can help the server find or sort matching records without scanning every document.
- **Driver:** a language library that serializes values to BSON, sends commands, and maps results back to language values.

A normal request flows from an API to a driver, then to a MongoDB server. The server evaluates the filter, chooses a query plan, reads or writes documents, and returns a result through the driver. Understanding that path helps distinguish application work, database work, and network latency.

## Choose by access pattern

Before choosing a database or designing a collection, write down the application's operations:

1. What does each screen or API read together?
2. Which filters and sorts are frequent?
3. Which records change together?
4. Which invariants must always hold?
5. How quickly do arrays and documents grow?
6. Who operates backups, security, monitoring, and upgrades?

For example, a product page that reads a bounded set of attributes with the product may fit one document. A financial workload dominated by cross-entity constraints and complex relational reporting may be easier to express in a relational database. Either can be appropriate. Benchmark the same representative data and request mix instead of trusting a universal speed claim.

## Flexible schema still needs a schema

MongoDB permits documents in one collection to have different shapes, but the application still has expectations. If code treats `stock` as a number, one document with `stock: "many"` can break comparisons and updates. Define field names, BSON types, required fields, and allowed values. Enforce important rules in application code and, where useful, with MongoDB schema validation. Evolve the schema in stages so old readers and new writers can overlap during migration.

## Example document

~~~javascript
{
  sku: "KB-42",
  title: "Keyboard",
  price: NumberDecimal("49.90"),
  attributes: { layout: "fa", wireless: true },
  categories: ["accessories", "computers"]
}
~~~

This is a shape, not a finished schema. Decide the currency and rounding policy, whether category values need stable IDs, which queries need indexes, and whether any arrays can grow without a bound.

## Practical example: Forbes

MongoDB's published Forbes story describes a CMS modernization and a move to Atlas, including reported improvements to build and provisioning workflows. It is useful for discussing managed operations and document flexibility, but it is a customer/vendor account and does not prove MongoDB is the right choice for every publishing system. [Forbes customer story](https://www.mongodb.com/solutions/customer-case-studies/forbes)

## Common mistakes

- Choosing MongoDB because “NoSQL always scales better.”
- Treating flexible document shapes as a reason to skip contracts and validation.
- Comparing database speed with different data, indexes, hardware, or request patterns.
- Ignoring reporting, backup, security, and operational ownership until late in the project.

## Exercises

1. Write three common store queries and list the documents, filters, sorts, and fields each needs.
2. For a financial reporting service, compare MongoDB and a relational database using constraints, query shape, consistency, team experience, and operations.
3. Pick one record that should be embedded and one that should be referenced. State the expected growth bound for each.

## Quiz and answer key

1. **What is MongoDB's main storage unit?** A BSON document, stored in a collection.
2. **Does a flexible schema mean there is no schema?** No. Application contracts, validation, and migrations are still needed.
3. **Where should a database choice begin?** With access patterns and invariants, then growth, cost, operations, and team skills.
4. **Why is “NoSQL always scales better” a poor decision rule?** It ignores workload, consistency constraints, and operational cost. Write the queries and invariants, then measure representative data.
5. **Applied task: propose three store queries.** A good answer names each filter, sort, projection, involved records, and expected read/write frequency.
6. **Is MongoDB schema-free?** No. It permits flexible shapes but still benefits from explicit field and type contracts.
7. **Which operations guide document modeling?** Reads, writes, filters, sorts, relationships, and actual growth.
8. **When should a relational database also be evaluated?** When relational constraints and join-heavy reporting dominate the workload.
9. **Does `$lookup` mean MongoDB cannot model relationships?** No. It is one supported way to combine documents across collections.
10. **How should performance claims be compared?** With a controlled benchmark using representative data and the same workload.

## Further reading

- [MongoDB Manual](https://www.mongodb.com/docs/manual/)
- [Data Modeling](https://www.mongodb.com/docs/manual/data-modeling/)
- [MongoDB Development Documentation](https://www.mongodb.com/docs/development/)
- [What is MongoDB? in Persian — Pars.host](https://pars.host/blog/what-is-mongodb/)
- [MongoDB learning series in Persian — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [Curated reference library: foundations](../../reference-library.md#foundations-choice)

---
Sources reviewed: 2026-11-11. Check the documentation for your deployment version before production use.
