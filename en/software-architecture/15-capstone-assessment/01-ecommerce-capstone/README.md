# Capstone: Design an Online Store

This capstone applies the course to a realistic system. The reference design is a worked example, not a universal template. Replace all illustrative assumptions with measured product, legal, financial, and operational requirements.

## Problem statement

Build a store with catalog, cart, checkout, orders, payment, inventory, shipping, invoices, customer support, and reporting. A small team is launching an evolving product. Campaign traffic can spike; payment providers can time out or send duplicate callbacks; customers expect clear order status; personal data needs protection; reports must not slow checkout.

## Step 1: Discover needs and boundaries

Identify customers, support, finance, warehouse, marketing, security, operations, and payment/shipping partners. Ask what decisions each group needs and who owns each business fact. Convert vague goals into scenarios with actor, trigger, expected result, workload, failure, and measure.

Example quality scenarios:

| Scenario | Measure to agree | Failure and recovery question |
| --- | --- | --- |
| Customer submits checkout | Response and completion time; success rate | What if the provider result is unknown? |
| Campaign opens | Peak requests, p95/p99 latency, error rate | Which workload is shed or degraded first? |
| Inventory reservation | No oversell; reservation expiry time | How does a stuck reservation get released? |
| Finance views daily sales | Freshness, reconciliation, access | How is a late refund represented? |
| Operator restores data | RTO and RPO | Has restore been rehearsed with keys and runbooks? |

Do not adopt targets such as “99.99%” or “400 ms” without asking which user-visible operation, time window, and error population the number covers.

## Step 2: Model domain and ownership

Use domain workshops to identify concepts and boundaries. A useful starting ownership map is:

| Context | Owns | Does not own |
| --- | --- | --- |
| Catalog | Product description, category, published price list | Historical order price |
| Checkout/Order | Order intent, order lifecycle, customer-facing status | Provider settlement ledger |
| Inventory | Available quantity, reservation, release | Catalog descriptions |
| Payment | Payment attempt, provider reference, refund state | Shipping state |
| Fulfillment | Shipment, carrier reference, delivery state | Payment authorization |
| Reporting | Derived measures and historical views | Operational write authority |

Use a modular monolith initially if the team is small and independent scaling, release, or failure isolation has not been proven necessary. Enforce module boundaries in code and data access. Extract a service only when ownership and operational responsibility can also move.

## Step 3: Draw useful views

### Context view

    Customer / Staff -> Storefront -> Store Platform
    Store Platform -> Payment Provider
    Store Platform -> Carrier / Fulfillment
    Store Platform -> Email or SMS Provider
    Store Platform -> Analytics Warehouse

### Container view

    Browser or Mobile App
       -> Edge / API
       -> Application modules: Catalog | Checkout | Inventory | Payment | Fulfillment
          -> PostgreSQL (transactional records)
          -> Object storage (product media and documents)
          -> Durable broker (outbox events and background jobs)
       -> Reporting pipeline -> Warehouse / read model

Show trust boundaries, data ownership, and asynchronous paths. A sequence diagram should show the order of writes and events for normal payment, provider timeout, duplicate callback, and refund.

## Step 4: Write decision records

### ADR: begin with modular monolith

**Context:** small team, uncertain domain boundaries, several modules change together.

**Options:** modular monolith; separate services immediately; use a commercial commerce platform.

**Decision:** start with enforced internal modules and stable interfaces; measure bottlenecks and extraction signals.

**Consequences:** simpler deployment and transactions, but one process/deployment and shared failure domain. Team owns dependency rules, module tests, and a migration path.

**Review trigger:** a module needs materially different scaling, release cadence, security boundary, or reliability target and has a team able to operate it.

### ADR: transactional outbox for events

Commit the business update and outbox row in one database transaction. A relay publishes at least once; consumers deduplicate by event ID and update their own state atomically. This avoids losing publication intent in a crash between database commit and broker publish.

## Step 5: Design checkout and payment

1. Validate cart lines and current price/availability on the server.
2. Create an order in PENDING_PAYMENT with a stable order and payment-attempt ID.
3. Record an idempotency key for the provider operation; store the provider reference without exposing credentials.
4. Keep provider calls outside long-held database transactions.
5. If response is successful, apply an allowed state transition. If it times out, record UNKNOWN/PENDING and reconcile; a timeout does not prove failure.
6. Verify callback signature, merchant/audience, freshness, and provider event ID. Deduplicate callbacks and reject invalid state transitions.
7. Reserve inventory with an invariant that prevents negative available quantity. Use expiry and an explicit release/commit policy.
8. Give the customer a trackable pending state instead of suggesting a second payment.
9. Reconcile uncertain attempts against provider records and expose an operator queue for unresolved cases.

### Minimal contract sketch

    POST /orders
    Idempotency-Key: stable-client-or-checkout-key

    Response: 201 Created
    { orderId, status: PENDING_PAYMENT, statusUrl }

Do not copy this sketch as a complete API specification. Define authentication, authorization, request validation, replay handling, error schema, versioning, rate limits, and privacy requirements.

## Step 6: Security and privacy

Threat-model assets and abuse cases: account takeover, IDOR on orders, coupon abuse, inventory manipulation, payment replay, forged webhooks, admin misuse, leaked secrets, log exposure, and denial of service. Require server-side authorization per order and action. Apply MFA to privileged users, least privilege to workloads, secret rotation, TLS, input validation, rate limits, audit logging, retention/deletion policy, and tested backups.

For every mitigation, name an owner and evidence such as a negative authorization test, callback replay test, restore drill, or access review. A clean scanner report does not prove the system secure.

## Step 7: Data and analytics

Use a transactional relational database for order and payment invariants at this stage. Store media in object storage. Publish reporting changes through the outbox or carefully governed change capture. State fact grain and metric definitions: for example, one row per order line versus one row per payment settlement. Reconcile analytics totals to finance records, include currency/time-zone rules, expose freshness, and handle late refunds.

## Step 8: Production, reliability, and delivery

- Build immutable artifacts; scan and record provenance.
- Use CI for unit, API contract, migration, security, and integration checks.
- Use progressive rollout and backward-compatible schema expansion/contraction.
- Define checkout SLIs for response and final outcome separately.
- Set RTO/RPO with business owners and rehearse restore, including access to encryption keys.
- Track latency, error rate, saturation, payment ambiguity, inventory conflicts, queue age, and reporting freshness.
- Define runbooks for provider outage, queue backlog, inventory mismatch, credential compromise, and restore.
- Conduct blameless incident reviews and assign actions with owners and due dates.

## Required deliverables

1. Stakeholder map and measurable quality scenarios.
2. Context, container/deployment, and payment sequence diagrams.
3. Domain/context map and data-ownership table.
4. At least three ADRs with alternatives and review triggers.
5. Threat model prioritized by risk with controls and verification evidence.
6. API/event contract and migration-compatibility plan.
7. Deployment, SLO, backup/restore, and incident runbook.
8. A short executive summary explaining cost, risk, and trade-offs.

## Defense questions

- Which invariant requires a transaction, and which crosses a service boundary?
- If the provider charges successfully but the response is lost, what prevents a duplicate charge?
- If an outbox relay publishes twice, what exactly makes the consumer safe?
- What may be stale, and how stale can it be before a user or regulator is harmed?
- Which part of the system fails first during a campaign spike, and what is degraded?
- What evidence would convince you to extract one module into a service?
- Which decision is most uncertain, who owns it, and when will it be revisited?

## Sample evaluation rubric

Score each from 0 to 2: needs and measures; boundaries and ownership; failure/recovery; security/privacy; delivery and operations; evidence and trade-offs. A strong design scores 10–12 and can explain at least one credible alternative. A diagram with many services but no owner, failure behavior, or verification is not a strong architecture.

## Real-world reading and case studies

- [Shopify Engineering: Deconstructing the Monolith](https://shopify.engineering/deconstructing-monolith-designing-software-maximizes-developer-productivity) — firsthand discussion of modularity and developer productivity.
- [Amazon Builders’ Library: Making retries safe with idempotent APIs](https://aws.amazon.com/builders-library/making-retries-safe-with-idempotent-APIs/) — payment-like retry concerns.
- [Stripe Engineering](https://stripe.com/blog/engineering) — payment, API, reliability, and developer-platform articles.
- [Netflix TechBlog](https://netflixtechblog.com/) — large-scale delivery and operational case studies; context differs from a small store.
- [Google SRE: Addressing Cascading Failures](https://sre.google/sre-book/addressing-cascading-failures/)
- [AWS transactional outbox guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html)
- [OWASP API Security Top 10](https://owasp.org/www-project-api-security/)
- Persian: [Microservices in Practice workshop](https://hadi-ahmadi.com/training/2024/microservices-in-practice-service-design-and-integration/), [Persian DDD learning repository](https://github.com/hheydarian/Understanding-Domain-Driven-Design), [Persian Event-Driven Architecture notes](https://github.com/gloonch/eventdrivenfarsi)
