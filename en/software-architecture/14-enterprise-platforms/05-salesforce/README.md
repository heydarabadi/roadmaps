# Salesforce Platform Architecture

## Learning goals

- Explain Salesforce's multitenant, metadata-driven platform and extension model.
- Compare declarative configuration, Apex/custom code, APIs, and external services.
- Plan governor-limit-aware, secure, upgradeable solutions.

## Platform model

Salesforce is a multitenant cloud platform: customers share platform infrastructure while data and metadata are logically isolated by the service. The platform is metadata-driven, enabling an organization to configure objects, fields, access, automation, and user experiences without owning the underlying database implementation.

Declarative configuration can cover many validation, workflow, reporting, and UI needs. Custom code such as Apex is appropriate when logic or performance needs exceed supported configuration, but code must honor governor limits, transaction boundaries, bulk processing, and platform security. Prefer standard features when they meet the requirement; custom behavior creates a long-lived support and test obligation.

Salesforce Objects and APIs provide platform-specific abstractions. Define the source of truth and integration pattern for each entity. Use stable external IDs for upsert and reconciliation, and design around rate and concurrency limits. Bulk APIs suit large data loads; event or change-data-capture patterns can propagate changes asynchronously. Do not poll aggressively or make two systems authoritative for the same field.

## Security and release

Use profiles, permission sets, sharing, field-level security, and object permissions consistently. Enforce authorization in server-side code and APIs. Do not assume a hidden UI control protects a record. Use sandboxes and source-controlled metadata, validate deployments, test representative data volumes, and deploy through reviewed pipelines. Monitor async jobs, platform limits, integration failures, and release impact.

## Worked example: synchronize customer orders

The commerce system owns order lifecycle; Salesforce owns customer service cases and account relationship data. Expose an order read API or controlled event projection to Salesforce. Use an external order ID, least-privilege integration identity, and data minimization. When sync fails, retain a retryable record and reconcile counts; do not create duplicate orders.

## Self-check quiz

1. What does metadata-driven customization mean? Platform metadata describes much of the application schema, behavior, and UI.
2. Why are governor limits important? Shared-platform resource constraints bound per-transaction work.
3. Why use external IDs? They support stable matching and idempotent upsert across systems.
4. Does hiding a field in the UI enforce data access? No; API and server-side permissions must enforce it.
5. When should declarative configuration be preferred? When it satisfies the need with lower complexity and is maintainable by the owning team.

## Exercise

Design a Salesforce integration with an external commerce platform for customer and order visibility. Define ownership, API/event, security, bulk handling, retry, and observability.

### Sample answer

Commerce owns order and payment facts; Salesforce owns support interactions and account relationships. Publish order events or expose a read API using external IDs. Restrict the integration identity to required objects/fields, honor API limits, process bulk jobs asynchronously, deduplicate by order ID, and alert on lag and failed batches. Reconcile totals and document how a customer deletion or consent change propagates.

## Further reading

- English: [Salesforce Architects](https://architect.salesforce.com/), [Salesforce Platform architecture overview](https://help.salesforce.com/s/articleView?id=000392678&language=en_US&type=1), [Salesforce Platform Developer exam guide](https://help.salesforce.com/s/articleView?id=005298965&language=en_US&type=1), [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/), [Salesforce Well-Architected](https://architect.salesforce.com/well-architected/overview), [Salesforce engineering blog](https://engineering.salesforce.com/)
- Persian: [Salesforce Trailhead](https://trailhead.salesforce.com/), [DNTips](https://www.dntips.ir/)
