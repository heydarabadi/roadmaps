# Chapter 2 Lab — Operations and Queries

> **Persian edition:** [Read the Persian version](../../../labs/02-operations/readme.md).

The seed script deletes and recreates only the `products`, `customers`, and `orders` collections in the `learning` database. Use a disposable local environment. **Do not connect it to production.** Persian product names and tags are intentional so you can test Unicode and Persian text queries.

## Run the lab

From the course root:

~~~bash
mongosh "mongodb://localhost:27017" en/labs/02-operations/seed.mongosh.js
~~~

## Exercises

1. List active products with only title and price.
2. Find the out-of-stock product and compare it with the inactive product.
3. Query orders with status `paid` or `shipped`, sorted newest first.
4. Find orders where `note` is missing and compare them with `note: null`.
5. Update order `O-100` to `shipped` with `$set`, then inspect `matchedCount`.
6. Decrement `KB-01` stock by one only if at least one unit remains.
7. Count open orders with `countDocuments()`.
8. Design keyset pagination for customer `C-200` using `createdAt` and `_id`.
9. Add a tag to `KB-01` without duplicates.
10. Return an order projection without `_id` and cap the returned items array.

## Answer guide

1. Filter with `{active: true}` and project `title` and `price`.
2. `MS-01` is active but has zero stock; `OLD-01` is inactive. These are separate states and need separate filters.
3. Use `status: {$in: ["paid", "shipped"]}` and sort `{createdAt: -1, _id: -1}`.
4. Missing: `{note: {$exists: false}}`. Null equality can also match a missing field; add `$exists: true` to isolate explicit null.
5. Filter on the unique `_id`. If the order exists, `matchedCount` is 1.
6. Filter on `sku` and `stock: {$gte: 1}`, then update with `$inc: {stock: -1}`.
7. Run `countDocuments({status: "open"})`.
8. Use a deterministic descending sort and a `$or` boundary based on the last page's timestamp and `_id`.
9. Use `$addToSet: {tags: "new-tag"}`.
10. Use an inclusion projection with `_id: 0`; use `{items: {$slice: 5}}` to cap the array output.
