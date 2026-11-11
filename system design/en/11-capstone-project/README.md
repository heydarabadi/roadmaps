# Capstone: Designing Store Checkout During a Major Sale

[فارسی](../11-capstone-project/README.md)

This project connects the ten chapters in one design. Its numbers are teaching assumptions used to practice estimation, not claims about any company or product capacity.

## Problem statement

An online store has product pages, carts, and order placement. Campaign traffic rises sharply. A customer must not be charged twice after clicking Pay; inventory must not become negative; and the system must show a clear status even if the payment provider responds slowly.

### Functional requirements

- Display products and current prices.
- Create an order with line items and a purchase-time price snapshot.
- Reserve inventory for a limited time.
- Request payment and record a final or pending result.
- Allow safe client retries and order-status checks.
- Send a receipt after successful payment.

### Example quality requirements

- Under normal load, p95 time to initiate checkout is below 500 ms; waiting for the payment provider is not required within that same deadline.
- An accepted request must not disappear after a process crash.
- A duplicate request must not create a second order or charge.
- A notification outage must not stop payment recording.
- Only the owner or an authorized role can access an order.

## Workload assumptions

Assume 200,000 orders per day with a 10× peak factor.

- Average: 200,000 / 86,400 ≈ 2.31 orders per second.
- Estimated peak: about 23 orders per second.
- During an exceptional campaign, assume 5× peak, or about 115 orders per second, for ten minutes.
- At 3 KB of main order data per order, raw order data is about 600 MB per day. Indexes, events, replicas, and retention add to this.

Recalculate the assumptions and identify which workload is read-heavy (catalog), write-critical (orders, inventory, payments), and asynchronous (receipt). Size each component for its own pattern.

## First-version architecture

For a small team, a modular monolith with catalog, order, inventory, and payment modules may be a lower-cost start. A stateless API fronts a SQL database. Orders and the payment ledger use local transactions. An outbox in the same database stores events for a worker. A separate worker sends notifications. A cache accelerates public catalog reads only.

~~~mermaid
flowchart LR
  C[Client] --> G[API Gateway / Rate Limit]
  G --> A[Order API]
  A --> DB[(SQL: orders, inventory, payment ledger, outbox)]
  A --> P[Payment Provider]
  DB --> W[Outbox Worker]
  W --> Q[Durable Queue]
  Q --> N[Notification Worker]
  C --> S[Order Status API]
  S --> DB
  CDN[CDN Cache] --> CAT[Public Catalog]
  C --> CDN
~~~

If workload or team ownership grows, split modules only for a clear independent deployment or scaling need. Splitting too early turns local transactions into sagas and adds network and observability complexity.

## API contract

### Start an order

Send POST /v1/orders with an Idempotency-Key and cart contents. The server authenticates the user, checks item ownership and inventory, reads authoritative prices and promotions, and creates a snapshot.

The response might be 201 Created with state pending_payment, or 202 Accepted if it only starts a durable asynchronous job. State the difference clearly in the API contract.

### Check status

GET /v1/orders/{id} verifies ownership and returns a state such as pending_payment, paid, payment_failed, cancelled, or needs_review.

Do not expose card information or secrets in the response or logs. If the status is uncertain, show pending and a next-check time instead of claiming success.

## Data model and invariants

- **orders:** order ID, owner ID, status, amount and currency snapshot, timestamps.
- **order_items:** SKU, quantity, unit price at purchase time.
- **inventory_reservations:** SKU, order ID, quantity, expiry, status.
- **payments:** provider, provider reference, idempotency key, amount, status, and reconciliation data.
- **outbox:** event ID, aggregate ID/version, type, limited payload, publication time.

Enforce rules such as one intent per idempotency key, unique provider reference, reserved inventory not exceeding sellable inventory, and payment amount matching the order. Store money as decimal or integer minor units, not floating point.

## Normal flow and ambiguous payment

1. In a local transaction, the API creates a pending order, reserves inventory, and writes an outbox event.
2. A worker sends the payment request with the same idempotency key.
3. A successful provider reference is recorded and the order becomes paid.
4. An OrderPaid event is written to the outbox; a separate notifier sends the receipt.

If the provider charges the customer but its response is lost, do not mark the order definitively failed. Query status or retry the same idempotent request. Keep the order pending until the result is known.

If the provider does not support idempotency keys, reconcile using provider statements/references and route unresolved cases to a manual review queue. Inventory-reservation expiry must agree with payment semantics: releasing stock too early and then receiving a late charge can create a business conflict.

## Scale and overload behavior

- CDN/cache can serve public catalog data; checkout revalidates price and inventory against authoritative sources.
- Scale API instances horizontally; do not pin sessions or files to one instance.
- Add up connection pools across all instances and compare them with database limits.
- Use rate limits and queues for secondary campaign work; do not hide critical order intake in an unbounded queue.
- A hot SKU can create inventory contention; use short locks, atomic updates, or explicit partition ownership.
- Notification backlog should not consume payment-worker capacity; use separate queues and pools.
- If database writes reach a limit, first examine query, transaction, and workload shape. A read replica does not increase write capacity.

## Availability, consistency, and recovery

Inventory and the payment ledger need stronger consistency than a page-view counter or sales report, which can converge later.

Use independent backups and test restore. Replicas lag, so status reads immediately after creation should use the primary or a read-your-writes path. Agree RTO/RPO with the business and practice failover.

Notifications should be retryable and idempotent. A notification failure must not roll back a recorded payment.

## Security and privacy

Authentication verifies the user; authorization checks every order read or update against its owner or role. Store payment-provider secrets in a secret manager and rotate them. Limit request rate and payload size.

Do not store card data unless the requirements and responsibilities are fully understood; use provider tokenization. Signed receipt URLs should be short-lived and restricted. Define financial audit, minimum access, and personal-data retention.

## Observability and SLOs

Possible SLIs include successful order creation, completed payments, p95/p99 checkout-start latency, oldest outbox/queue age, payment timeouts and duplicates, inventory conflicts, and monthly error-budget use.

Tracing should connect client request ID, order ID, outbox event ID, and provider call. Do not use personal identifiers as metric labels. Alerts for aging pending payments or old unresolved outcomes are more actionable than CPU alone.

## Architecture failure scenarios

- Send the same request ten times concurrently; only one order/charge should be created.
- Drop the provider response after its charge succeeds; recover the final status without charging twice.
- Stop a worker after commit but before acknowledgement; redelivery must not repeat the effect.
- Slow the database; pools and queues remain bounded and the API respects its deadline.
- Fill the notification queue; checkout continues and a backlog alert fires.
- Lag the replica; the same user does not immediately see stale status after order creation.
- Run failover and measure actual RTO/RPO, reconciliation, and ledger integrity.

## Sample interview answers

### Why not call the payment provider inside a database transaction?

The external provider is not part of the local database transaction and may respond slowly or ambiguously. Keep the database transaction short, persist intent and outbox, call the provider idempotently, then record or reconcile the outcome.

### Why not make every component a microservice?

The first-version team and workload do not yet show a need for independent deployment. A modular monolith keeps domain boundaries while simplifying operations. If payment later needs its own SLO, ownership, or scaling profile, split it gradually behind a stable contract and outbox.

### What if the database fails?

Return a clear failure or bounded acceptance behavior; an in-memory queue is not durable storage. Promote according to RTO/RPO, keep uncertain requests idempotent, and reconcile after recovery. Use a separate backup for logical corruption and test restore.

## Final exercise

Adapt the design for ticket booking: the last seat must not be sold to two users, a payment timeout must be handled safely, a seat must be released after a defined interval, and a second region should take over during a regional outage.

Your answer should include a diagram, invariants, retry contract, SLI/SLO, RTO/RPO, and a failure test.
