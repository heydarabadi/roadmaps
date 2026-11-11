# Cloud, Infrastructure as Code, and CI/CD

## Learning goals

- Compare cloud service models and shared-responsibility boundaries.
- Describe repeatable infrastructure provisioning and controlled delivery.
- Design deployment, rollback, secrets, and environment strategy.

## Cloud service models

Infrastructure as a Service gives teams control over virtual machines and networks but leaves more operating-system work. Platform services and managed databases shift patching and availability tasks to the provider while imposing service limits and provider-specific behavior. Software as a Service offers a finished capability but requires integration, data governance, and vendor risk management. “Managed” never means “no owner.”

Cloud architecture decisions include region, identity, network isolation, storage durability, backup, service quotas, cost, support, and data residency. Understand the shared-responsibility model for each service: the provider secures the underlying service, while the customer configures identity, data access, and workload behavior.

## Infrastructure as Code

IaC declares infrastructure in versioned files and applies a plan through controlled identities. Review plans before changes, protect state, separate environments safely, and avoid embedding secrets. Modules should capture real reusable policy without obscuring what will be deployed. Drift detection compares declared and observed state; imported manual changes should be reconciled rather than ignored.

## CI/CD and release safety

CI should build, test, scan, and package once. CD promotes that artifact through environments with approvals or policy gates suitable for the risk. Use progressive delivery, canary or blue/green releases, health signals, rollback plans, and database expand-and-contract migrations. A rollback cannot always reverse an irreversible data migration, so plan forward recovery too.

Secrets belong in a secret manager or protected runtime mechanism with rotation and least privilege, not source code or build logs. Pipeline identities should be short-lived and scoped to the deployment target. Audit who changed infrastructure and which artifact is running.

## Worked example

A service pipeline runs unit and contract checks, builds a container, records provenance, scans dependencies, and publishes an immutable artifact. IaC plans a staged network and workload update; a canary receives a small share of traffic. Error rate and latency gates pause rollout. If unhealthy, routing returns to the prior version while compatible database changes remain safe.

## Self-check quiz

1. What is the shared-responsibility model? It assigns security and operations responsibilities between provider and customer for a service.
2. Why use immutable artifacts? To know that the tested artifact is the one promoted to production.
3. What should be protected in IaC workflows? State, credentials, approval paths, and deployment identities.
4. Why may rollback be insufficient after a schema change? The new data may not be readable by the old code or the change may be irreversible.
5. What does a canary release test? A change with limited real traffic before broader exposure.

## Exercise

Design a production pipeline for a checkout API, naming build evidence, infrastructure controls, rollout gates, and rollback/forward-recovery steps.

### Sample answer

Build once from reviewed code; run unit, contract, migration, security, and image checks; record provenance; plan IaC changes for review; use scoped short-lived deployment credentials. Roll out to a small percentage, watch payment errors, latency, and saturation, then expand. On failure revert traffic and application artifact; use backward-compatible schema changes and a documented forward fix if data cannot be rolled back.

## Further reading

- English: [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html), [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/), [Google Cloud Architecture Framework](https://cloud.google.com/architecture/framework), [Terraform documentation](https://developer.hashicorp.com/terraform/docs), [OpenTofu documentation](https://opentofu.org/docs/), [DORA: Capabilities](https://dora.dev/capabilities/), [SLSA framework](https://slsa.dev/)
- Persian: [Microsoft Learn فارسی: Cloud architecture](https://learn.microsoft.com/fa-ir/azure/architecture/), [DNTips](https://www.dntips.ir/)
