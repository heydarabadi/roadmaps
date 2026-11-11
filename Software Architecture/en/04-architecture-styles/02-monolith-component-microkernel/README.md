# Monoliths, Components, and Microkernels

## Learning goals

- Distinguish a deployable monolith from a modular monolith.
- Explain component boundaries and the microkernel/plugin model.
- Select a structure based on deployment, extension, and team constraints.

A monolith is one main build/deployment unit and may still be modular. A modular monolith has explicit module contracts, ownership, and dependency rules while remaining in one deployment. Component-based design organizes around independent components. A microkernel keeps a stable core and adds optional capabilities through plugins or extensions; it can suit extensible products.

A monolith is not inherently poorly designed. Starting with a monolith can help a team discover the domain and real boundaries. Splitting too early turns assumed boundaries into expensive network commitments.

## Example: accounting product

The core owns ledger and tax rules; plugins add bank connections and report formats. A plugin that directly changes core tables is not independent. Its contract must define versioning, permissions, sandboxing, and failure behavior.

| Structure | Benefit | Cost |
| --- | --- | --- |
| Monolith | Simple build and debugging | A change may affect the whole product |
| Modular monolith | Simple operations with internal boundaries | Requires enforcement and discipline |
| Microkernel | Extensions and customer variation | Plugin compatibility and security |
| Separate service | Independent release or scale | Network, telemetry, and consistency |

Enforce boundaries within the process first. Add a network boundary only when independent scaling, release, ownership, or fault isolation has real value.

## Step-by-step: building a modular monolith

Imagine modules for catalog, orders, inventory, and payments:

1. **Who owns each rule?** Inventory owns reservation rules. Orders can request a reservation but must not directly mutate inventory.
2. **Who writes each data set?** Each module owns its tables and migrations. Reading an internal projection differs from writing a neighbor’s tables.
3. **What is the contract?** ReserveStock accepts an order ID and items and returns Reserved, InsufficientStock, or Unavailable. It distinguishes business failure from infrastructure failure.
4. **Which way do dependencies point?** Orders depends on the inventory contract; inventory should not import internal order types. Remove dependency cycles with a small shared contract or by rethinking call direction.
5. **How is the boundary enforced?** Package visibility, internal APIs, namespace checks, architecture lint, and review make violations measurable.

This is still one build and deployment, so schema or memory failures can affect the whole program. Tracing, debugging, and local transactions are simpler. The module boundary should be independently meaningful and testable even if it never becomes a service.

## When is service extraction justified?

Collect evidence: Is independent release required? Does load differ from the rest of the application? Is there an owning on-call team? Is fault isolation or a security requirement important? Can the data be separated through a clear contract? Does the value exceed the cost of network calls, tracing, deployment, monitoring, incidents, and data consistency?

If the evidence is unclear, first measure the internal boundary. Extract gradually: identify contract consumers, stabilize an internal API, move data ownership, manage old/new paths with an explicit coexistence plan, add comparison telemetry, then retire the old path. Do not create uncontrolled dual writes; they make two sources of truth disagree.

## Microkernel: core and plugins

The core defines essential capabilities and the plugin contract. A reporting plugin may implement ReportProvider. Define contract version, timeout, quota, permission per capability, install/removal, errors, and compatibility policy. A plugin in the same process may access memory and credentials; untrusted plugins need a real sandbox or separate process. The word “plugin” is not a security boundary.

## Worked decision

For a store with one team and a changing domain, a modular monolith with four modules and one database is practical. If the inventory team later needs independent release and scaling and accepts data ownership, that boundary is a candidate for extraction. Revisit using latency, error rate, release cadence, team load, and on-call cost.

## Common pitfalls

- Naming folders instead of enforcing boundaries.
- Giving plugins full access to core tables.
- Splitting by table or technical layer.
- Big-bang migration that changes everything at once.

## Self-check quiz

1. **What makes a modular monolith different from tangled code?** Its modules have contracts and dependency rules that can be enforced and measured.
2. **What problem fits a microkernel?** A stable core with optional extensible capabilities.
3. **What justifies splitting a service?** Independent release, scale, ownership, or fault isolation plus operational ability.
4. **Why is “maybe it will be a service later” insufficient?** Network and operating costs are certain today; the future benefit is only assumed.

## Exercise

Split a store into catalog, order, inventory, and billing modules. State each owner, contract, and dependency rule.

### Sample answer

Catalog owns product and list-price data; order owns the order lifecycle; inventory owns quantity and reservation; billing owns payment attempts and refunds. Each exposes an internal API. Orders may call the inventory contract but may not write its tables. Enforce dependency direction with an import check or architecture test; keep the modules in one deployment initially.

## Further reading

- Persian: [Monolithic architecture](https://pro-nee.net/terms/monolithic-architecture/), [Software architecture fundamentals](https://www.alirostami.com/software-architecture/)
- English: [Martin Fowler: Monolith First](https://martinfowler.com/bliki/MonolithFirst.html), [Microsoft Architecture Styles](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/), [Martin Fowler: Modular Monolith](https://martinfowler.com/articles/modular-monolith.html), [Microsoft microkernel pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
