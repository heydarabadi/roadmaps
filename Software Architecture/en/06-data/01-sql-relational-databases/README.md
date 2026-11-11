# Relational Databases and SQL

## Learning goals

- Model entities, relationships, constraints, and transactions in a relational database.
- Explain how indexes, query plans, isolation, and normalization affect correctness and latency.
- Choose relational storage deliberately and plan safe schema evolution.

## Core idea

A relational database is more than a place to store rows. Its schema and constraints make business invariants explicit, while transactions coordinate changes that must succeed or fail together. SQL is declarative: describe the result, then inspect how the engine obtains it.

## The model in practice

For a shop, customers place orders; an order contains line items; each line references a product snapshot. A primary key identifies a row, a foreign key enforces a relationship, and unique/check constraints protect invariants even when multiple application instances race. Store money as an exact decimal or integer in minor currency units, never binary floating point.

Normalization reduces duplicated facts. If product name is copied into every order row, later catalog edits can create inconsistent history. Conversely, historical order lines often intentionally snapshot the price and product description because an invoice must preserve what was sold at that time. Denormalization is a deliberate read optimization with a defined update strategy.

Indexes accelerate selected access paths but consume space and add work to inserts, updates, and deletes. A composite index is ordered by its leading columns; an index on (tenant_id, created_at) can support tenant-scoped time ranges, while the reverse order may not serve the same query. Use the database's query plan and production-like cardinalities rather than assuming an index helps.

Transactions provide atomicity and isolation, but the chosen isolation level determines which concurrent observations are possible. A checkout that reads inventory and later decrements it can oversell unless the operation uses a guarded update, lock, or reservation protocol. Keep transactions short and do not hold database locks while waiting on an external payment network.

## Worked example: inventory reservation

The invariant is that available inventory never becomes negative. A safe conditional update conceptually decrements stock only where quantity is at least the requested amount, and succeeds only if exactly one row changed. For multi-item orders, use a transaction and a consistent lock order; define retry behavior for deadlocks. The payment call happens outside the database transaction, coordinated with an idempotent workflow or reservation timeout.

## Schema change sequence

1. Add a nullable or backward-compatible field/table.
2. Deploy code that writes the new representation while still reading the old one.
3. Backfill in bounded batches and observe database load.
4. Validate completeness and constraints.
5. Switch reads, then remove the old representation in a later release.

This expand-and-contract approach keeps old and new application versions compatible during rolling deployment.

## Self-check quiz

1. Why do foreign keys and unique constraints belong in the database as well as application validation? They protect invariants under concurrent writes and across every writer.
2. What does a composite index on (tenant_id, created_at) naturally support? Equality or filtering on the leading tenant key followed by a time range or ordering.
3. Why can a long transaction be harmful? It holds locks and resources longer, increases contention, and can delay vacuuming or replication.
4. Does ACID imply every request reads the newest possible value? No; visibility depends on isolation and transaction timing.
5. Why snapshot a price on an order line? The historical sale must remain stable if the catalog price changes.

## Exercise

Design tables for customers, orders, order lines, and inventory. State the primary/foreign keys, constraints, two useful indexes, and how checkout prevents overselling.

### Sample answer

Customers have a primary key and unique normalized email. Orders reference a customer and carry status and timestamps. Order lines reference an order and product, store quantity plus an immutable unit-price snapshot, and enforce quantity greater than zero. Index orders by (customer_id, created_at); index order lines by order_id. Reserve inventory with a conditional decrement in a short transaction and use an idempotent payment workflow outside that transaction.

## Further reading

- First-hand case: [Shopify e-commerce at scale](https://shopify.engineering/e-commerce-at-scale-inside-shopifys-tech-stack) and [MySQL shard balancing](https://shopify.engineering/mysql-database-shard-balancing-terabyte-scale).
- English: [PostgreSQL documentation](https://www.postgresql.org/docs/current/), [PostgreSQL: Indexes](https://www.postgresql.org/docs/current/indexes.html), [PostgreSQL: Transactions](https://www.postgresql.org/docs/current/tutorial-transactions.html), [Use The Index, Luke!](https://use-the-index-luke.com/), [Microsoft: Relational data](https://learn.microsoft.com/en-us/azure/architecture/data-guide/relational-data/), [Martin Fowler: Evolutionary Database Design](https://martinfowler.com/articles/evodb.html)
- Persian: [SQL Server documentation in Persian](https://learn.microsoft.com/fa-ir/sql/), [Quera: SQL learning path](https://quera.org/college/landpage/1116/sql-course)
