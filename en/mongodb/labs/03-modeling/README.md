# Data Modeling Workshop

> **Persian edition:** [Read the Persian version](../../../../fa/mongodb/labs/03-modeling/README.md).

## Requirements

A store needs a product page, shopping cart, checkout, customer order list, and historical invoice.

## Proposed design and rationale

- **products:** embed a small variable attribute object and keep a unique index on SKU.
- **customers:** keep profile and current address; do not embed an unbounded order history.
- **carts:** one bounded document for the active cart, with a limit or growth policy for items.
- **orders:** reference `customerId`; snapshot the purchase-time address and price; keep the line-item array bounded.
- **events:** put high-volume or unbounded history in a separate collection keyed by entity ID and time.

## Review questions

1. Which fields are read together on a product page?
2. Do product categories share a shape, and what validation do they need?
3. How can an old invoice keep its data after a product is removed?
4. Do order and inventory writes need a transaction, or would a reservation workflow fit?
5. Which query shapes need compound indexes?

## Guided answer

- Start from queries and lifecycle, not from an entity diagram alone.
- Snapshot purchase-time price and title inside the order.
- Keep unbounded history outside parent arrays.
- Analyze inventory consistency and concurrency separately.
- Define indexes after recording filter and sort shapes, then measure them.

## Extension exercise

Write an order validator that requires `status`, `createdAt`, and `items`. Define a safe migration if old orders do not have the new field. Include a plan for verifying migrated counts.
