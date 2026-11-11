# Capstone Project — Online Marketplace

> **Persian edition:** [Read the Persian version](../../../projects/marketplace-capstone/readme.md).

This project combines the course chapters in one design. Use disposable data in a local database named `learning`. Never run destructive examples against production.

## Requirements

- Product catalogue and search.
- Customer profile and order history.
- Checkout with purchase-time price and address snapshots.
- Prevent negative inventory.
- Daily sales and top-10 product reports.
- Update the search index after product changes.
- Preserve data and restore service after a failure.

## Stage 1: write access patterns

Before creating collections, describe the filters, sort, and projection for each request:

| Request | Filter | Sort | Projection |
|---|---|---|---|
| Product page | SKU or active/category | Product-specific | title/price/attributes |
| Customer orders | customerId | createdAt descending, _id descending | id/status/total/date |
| Order state | _id | None | status/items/total |
| Low-stock products | stock and active | stock ascending | sku/title/stock |
| Daily report | createdAt range and status | day/revenue | aggregates |

Use this table to design collections and indexes.

## Stage 2: model the documents

### `products`

- Unique `sku`.
- `title`, Decimal128 `price`, numeric `stock`, and Boolean `active`.
- `attributes` for bounded product-specific details.
- Short, controlled `tags` array.

### `customers`

- Unique `customerId`, `name`, `email`, and current `address`.
- Do not store an unbounded `orders` array.

### `orders`

- `customerId` reference.
- BSON Date `createdAt`.
- `status` from an allowed list.
- Bounded `items` array with `sku`, `titleAtPurchase`, `qty`, and `unitPrice`.
- `shippingAddressAtPurchase` snapshot.
- Decimal128 `total` and explicit `currency`.

Prices and titles in an order are historical snapshots, not the current product source of truth.

## Stage 3: validate the schema

Require `status`, `createdAt`, `customerId`, and `items` on orders. Require `total` to be Decimal128 and `createdAt` to be a Date. Inspect existing documents and writers before enabling strict validation. If old shapes exist, use expand–migrate–contract.

## Stage 4: propose indexes from queries

These are initial candidates, not final answers:

~~~javascript
db.products.createIndex({ sku: 1 }, { unique: true })
db.products.createIndex({ active: 1, category: 1, price: 1 })
db.orders.createIndex({ customerId: 1, createdAt: -1, _id: -1 })
db.orders.createIndex({ status: 1, createdAt: -1 })
~~~

Run explain for each query. An index unused by real query shapes adds cost without helping those requests. Compare compound-key order using representative data.

## Stage 5: implement safe CRUD

Decrement stock conditionally:

~~~javascript
db.products.updateOne(
  { sku: "KB-01", stock: { $gte: 1 }, active: true },
  { $inc: { stock: -1 } }
)
~~~

If `matchedCount` is zero, handle missing, inactive, or out-of-stock products according to the API contract. Do not read stock and then perform an unconditional decrement; concurrent requests could both buy the final unit.

## Stage 6: aggregate sales

Find the ten highest-revenue SKUs from paid or shipped orders:

~~~javascript
db.orders.aggregate([
  { $match: { status: { $in: ["paid", "shipped"] } } },
  { $unwind: "$items" },
  { $group: {
      _id: "$items.sku",
      units: { $sum: "$items.qty" },
      revenue: { $sum: { $multiply: ["$items.qty", "$items.unitPrice"] } }
  } },
  { $sort: { revenue: -1 } },
  { $limit: 10 }
])
~~~

Add a date range to `$match`. Inspect explain and the number of rows after `$unwind`. If the report scans every order every second, evaluate pre-aggregation and define acceptable freshness.

## Stage 7: transactions and external effects

1. Check inventory preconditions and order status.
2. Define which stock, order, and event writes must be atomic.
3. Do not call the payment gateway inside a MongoDB transaction.
4. Record a checkout idempotency key.
5. Publish an outbox event from a worker.
6. Resolve unknown payment outcomes through status lookup and reconciliation.

Decide whether a multi-document transaction is needed or a reservation/state-machine workflow is simpler. Either requires explicit failure states and recovery behavior.

## Stage 8: Change Streams and search

Watch product changes and update the search projection. Consumers may receive events again, so make them idempotent. Persist a resume token after the downstream effect is durable. If the token is outside the oplog window, rebuild the index from the source of truth.

## Stage 9: security and operations

- Give the application user only the permissions it needs.
- Read secrets from a protected runtime source.
- Require TLS and restrict network access.
- Protect audit logs and exclude credentials or sensitive payloads.
- Define RPO/RTO and perform backup restore drills.
- Alert on disk, p95/p99, connections, replication lag, and backup failures.

## Deliverable

Write a design report covering access patterns, schema, indexes, consistency settings, failure modes, recovery, security, and explain evidence. Performance numbers must come from your own measured workload; label sample values as examples, not results.

## Guided design answers

- Keep orders separate from customers for growth and pagination.
- Snapshot address and price in the order for historical correctness.
- Decrement stock with a conditional `$gte: 1` filter.
- Use a unique SKU index and indexes justified by recorded query patterns.
- Use a transaction only for invariants spanning database writes.
- Handle payment APIs with idempotency and reconciliation.
- Validate backup with a restore drill; replication is not a backup.
- Keep search projections rebuildable and consumers idempotent.
