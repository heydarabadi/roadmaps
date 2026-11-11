# High Availability Patterns

[فارسی](../../../../fa/system-design/10-reliability-security/29-high-availability-patterns/README.md)

## Learning goals

- Use bulkheads and circuit breakers to constrain dependency failures.
- Separate liveness, readiness, and dependency health.
- Explain how regional stamps and geodes support availability.
- Coordinate retry, timeout, and breaker behavior.

## Central idea

Availability improves when single failure points are removed and resources are isolated. Quorum, spare capacity, and practiced recovery are also necessary.

## Concept map

Dependency failure → resource isolation → bounded calls and fast rejection → health and routing → tested recovery.

## Detailed lesson

### Bulkhead

On a ship, partitioned compartments limit how much damage one breach can cause. In a service, separate thread pools, semaphores, connection pools, or quotas serve the same purpose.

If a partner API slows down, only the pool used for that partner should fill—not the checkout pool. A bulkhead does not increase total capacity; it reserves resource limits so one dependency cannot consume everything. Set pool size based on downstream capacity, and make rejection visible with a metric and a clear response.

### Circuit breaker

A common breaker has three states:

- **Closed:** calls proceed and failures are counted.
- **Open:** calls fail quickly without contacting the dependency.
- **Half-open:** a small number of probes test whether the dependency recovered.

Choose failure thresholds, time windows, minimum sample counts, and failure types for the operation. A user validation error should not count as dependency failure.

A breaker does not reveal whether an operation's side effect occurred. If the result is ambiguous, idempotency and reconciliation are still required. A breaker also does not replace per-call deadlines or bounded retries.

### Health monitoring

Readiness controls whether an instance receives new traffic; liveness determines whether it should restart. Using them incorrectly can restart every instance at once.

Separate local health, dependency health, and end-to-end health. An optional dependency may permit a degraded mode and should not necessarily make the whole service unready.

### Stamps and geodes for high availability

Stamps isolate tenants or workloads and reduce blast radius. Geodes spread capacity and routing across regions. Real availability also depends on recovery capacity, data needed at the destination, identity/control-plane dependencies, and DNS/load-balancer behavior.

Multi-region without practiced promotion and restore may add complexity without delivering the recovery objective.

### Combine patterns for a payment call

For a payment provider, set a timeout and overall deadline. Retry only suitable failures and use a bounded attempt count. A circuit breaker limits repeated calls during sustained failure. A dedicated bulkhead prevents the provider from consuming checkout resources. SLI and traces show the impact; an order-status and reconciliation path resolve uncertain outcomes.

Do not enable retries independently at the client, gateway, SDK, and worker without an attempt budget; call counts multiply.

### Select the pattern

Use a bulkhead when one dependency can occupy all service threads or connections. Use a breaker when a dependency remains unhealthy and repeated calls waste resources. Use readiness checks when the routing layer needs to avoid unprepared instances. Use stamps or regional deployment only when the failure model requires them and recovery capacity is tested.

Every pattern needs an SLO, owner, and runbook.

## Worked example

Slow reporting queries should not occupy the payment thread pool. Give those workload classes separate connection and worker limits.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Bulkhead | One dependency or tenant can exhaust shared resources | Over-isolation may waste capacity |
| Circuit breaker | Repeated calls to a failing dependency delay recovery | A bad threshold can reject healthy traffic |
| Readiness checks | A router must avoid unprepared instances | Dependency checks can cause fleet-wide flapping |
| Multi-region | The recovery boundary exceeds one region | Data, routing, and operational complexity |

## Common pitfalls

- Circuit breaker without a timeout.
- Retry policy not coordinated with the breaker.
- Too many half-open probes.
- Separate pools sized without downstream capacity analysis.
- Treating a health endpoint as a guarantee that all business paths work.

## Short quiz

1. What does a bulkhead isolate?
2. What are the common circuit-breaker states?
3. Why coordinate retry policy with a breaker?
4. Should a user validation error open the dependency circuit?

### Answer key

1. A pool of resources such as threads, connections, or concurrent calls.
2. Closed, open, and half-open.
3. Uncoordinated retries can multiply load and prevent a dependency from recovering.
4. No; it is not evidence that the dependency is unhealthy.

## Exercise

For a store, identify the payment, search, and reporting dependencies. Set a bulkhead per workload, a deadline, retry conditions, breaker threshold, readiness policy, and dashboard signal. Describe the user-visible behavior when payment remains unavailable.

## Summary

High availability relies on isolating resources and limiting how failures spread. Bulkheads, circuit breakers, health, and regional deployment complement one another, but none replaces capacity planning and recovery exercises.

## Further reading

- [Azure Bulkhead pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/bulkhead) — isolating pools and blast radius.
- [Azure Circuit Breaker pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker) — stopping calls to a failing dependency.
- [Azure Reliability patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/category/resiliency) — related resilience patterns.
- [AWS Builders’ Library](https://aws.amazon.com/builders-library/) — reliability and operational design lessons.
- [Netflix TechBlog](https://netflixtechblog.com/) — public distributed-systems engineering.
