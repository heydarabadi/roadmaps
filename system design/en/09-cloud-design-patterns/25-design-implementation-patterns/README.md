# Cloud Design and Implementation Patterns

[فارسی](../../../09-cloud-design-patterns/25-design-implementation-patterns/README.md)

## Learning goals

- Recognize common patterns for routing, deployment, and operational behavior.
- Explain the problem each pattern solves and its cost.
- Choose patterns from workload needs rather than a cloud catalog.

## Central idea

Cloud patterns are reusable responses to recurring design problems. They are useful when their assumptions match the workload and harmful when applied without a measured need.

## Concept map

Workload constraint → candidate pattern → new dependency or behavior → resilience/cost/security review → operating policy.

## Patterns in this group

### Gateway routing

A gateway receives requests and routes them to a destination based on path, host, version, or other metadata. It can simplify client routing and support migrations. It also becomes a critical request-path component and must be secured, scaled, and monitored.

### Gateway aggregation

An aggregation gateway calls several services and combines their results into one response. It can reduce client round trips, but creates fan-out, timeout budgeting, and partial-failure behavior. Parallel calls can lower latency while increasing concurrent dependency load.

### Gateway offloading

Cross-cutting work such as TLS termination, authentication checks, rate limiting, or request logging can be handled at a gateway. Offloading can centralize policy, but the gateway must not become the only security boundary; backend services still need authorization appropriate to their data.

### Strangler Fig

A legacy system is gradually replaced by routing selected capabilities to new services while the old system continues handling the rest. This reduces the risk of a single large rewrite, but routing rules, data ownership, and migration observability must remain clear. Define when the old path can be retired.

### Sidecar

A helper process runs beside an application instance and handles a cross-cutting capability such as proxying or telemetry. It can standardize behavior without embedding every concern in application code. It also consumes resources and can make debugging harder when behavior spans app and sidecar.

### Ambassador

An ambassador proxy helps an application communicate with external services using shared connection, retry, or routing behavior. Keep its retries and timeouts bounded; moving a network policy to a proxy does not remove its failure modes.

### Compute Resource Consolidation

Multiple workloads share compute to use capacity efficiently. Consolidation can reduce idle resources, but noisy-neighbor isolation, resource limits, and failure blast radius need attention.

### Deployment Stamps

A deployment stamp is a repeatable unit of application and infrastructure. Additional stamps can scale capacity or isolate tenants and regions. Stamps need independent deployment, health, routing, and data boundaries; copying the same design does not eliminate shared dependencies.

## Choosing a pattern

Start with a concrete constraint: client complexity, migration risk, isolation, deployment repeatability, or resource utilization. For the candidate, list new dependencies, failure modes, costs, and operational tasks.

| Pattern | Potential benefit | Cost or risk |
| --- | --- | --- |
| Gateway aggregation | Fewer client round trips | Fan-out and partial failure |
| Strangler Fig | Incremental migration | Two paths and data reconciliation during transition |
| Sidecar | Shared proxy/telemetry behavior | Extra process, resources, and debugging surface |
| Deployment stamps | Repeatable scale and isolation unit | More deployments and shared-control risks |
| Compute consolidation | Higher utilization | Noisy neighbor and larger local blast radius |

## Worked example

During a store API migration, route a defined group of read requests to the new service while writes remain on the source of truth. Log the selected route, compare outputs, and create a rollback switch. Do not split writes until ownership and reconciliation are defined.

## Common pitfalls

- Treating a gateway as the only authorization layer.
- Aggregating too many critical dependencies into one client response.
- Running old and new paths indefinitely without retirement criteria.
- Assuming sidecars or stamps eliminate shared failure domains.
- Consolidating workloads without per-tenant limits.

## Short quiz

1. What problem does the Strangler Fig pattern address?
2. Why can gateway aggregation increase risk?
3. What should a deployment stamp represent?
4. Does gateway authentication replace service-level authorization?

### Answer key

1. Incremental replacement of a legacy system without a single risky rewrite.
2. It creates fan-out, new timeouts, partial failures, and a critical aggregation dependency.
3. A repeatable deployment unit with defined application, infrastructure, routing, and isolation behavior.
4. No. Each service still needs authorization for the data or action it owns.

## Exercise

Choose a legacy store endpoint to migrate using the Strangler Fig pattern. Define routing, read comparison, write ownership, rollback, telemetry, and retirement criteria. Identify which gateway patterns are useful and their new failure modes.

## Summary

Cloud design patterns provide reusable shapes, not automatic improvements. Match each pattern to an explicit constraint and account for its new dependencies, security boundaries, and operational cost.

## Further reading

- [Azure Architecture Center: Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/) — broad pattern catalog.
- [Azure: Gateway Aggregation pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/gateway-aggregation) — combining backend responses.
- [Azure: Gateway Routing pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/gateway-routing) — routing through a gateway.
- [Azure: Strangler Fig pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/strangler-fig) — incremental legacy modernization.
- [Azure: Sidecar pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/sidecar) — companion process for cross-cutting capabilities.
- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) — review pattern choices across quality pillars.
