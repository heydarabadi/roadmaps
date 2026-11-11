# Cloud Patterns, Reliability, and Observability

## Learning goals

- Design for partial failure, bounded work, degradation, and recovery.
- Define SLI, SLO, and error-budget concepts.
- Connect logs, metrics, traces, alerts, backups, and incident practice.

## Reliability as a product property

Reliability means the system performs the required function when needed. It depends on architecture, operations, change safety, dependency behavior, and recovery. Availability percentages alone do not explain user impact. Define service-level indicators (SLIs) from user-visible outcomes, such as successful checkout latency; set service-level objectives (SLOs) over a time window; and use error budgets to make release risk visible.

Plan for partial failure. A timeout bounds waiting but does not cancel work unless cancellation propagates. A circuit breaker can stop repeated calls to an unhealthy dependency; bulkheads isolate pools or workloads; rate limits and load shedding protect a system when demand exceeds capacity. Retries should be bounded, jittered, and limited to safe operations. Avoid unbounded queues that turn overload into delayed failure.

## Recovery and data protection

Define recovery time objective (RTO) and recovery point objective (RPO) from business impact. Backups are useful only if restore is tested and their encryption keys and access paths survive the same incident. Replication can replicate corruption or deletion, so it is not a backup. Practice regional or dependency failure where appropriate, with clear stop conditions and learning reviews.

## Observability

Logs record discrete events, metrics summarize values over time, and traces connect work across services. Use stable low-cardinality metric labels; do not put user IDs or arbitrary URLs into metric dimensions. Propagate trace context and request IDs. Alerts should indicate user impact or actionable exhaustion, include an owner and runbook, and avoid pages for every transient blip.

## Worked example: payment dependency outage

Set a short deadline for provider calls, use bounded retry only for idempotent requests, and cap concurrent work. If payment fails, mark the attempt pending/unknown when the result is ambiguous and reconcile by idempotency key rather than charging again. Degrade unrelated catalog and browsing features normally. Alert on payment success SLI and queue age, route traffic or pause risky releases, and execute the provider reconciliation runbook.

## Self-check quiz

1. What is an SLI? A measurable indicator of a service outcome.
2. What is the relationship between SLO and error budget? The SLO sets a target; the budget quantifies tolerated unreliability over its window.
3. Why are backups not proven by successful backup jobs alone? Restore, integrity, keys, and recovery timing must be tested.
4. What is a bulkhead? Isolation that prevents one workload or dependency from consuming all shared capacity.
5. Why should an ambiguous payment result not be blindly retried? The provider may have completed it despite the lost response.

## Exercise

Define a checkout SLI/SLO and outline behavior during a payment-provider timeout, including telemetry and recovery.

### Sample answer

Measure the fraction of valid checkout attempts that reach a confirmed outcome within a stated time window; set a target from customer and business needs. On timeout, record an unknown/pending state and provider idempotency key, cap concurrent requests, and reconcile asynchronously. Dashboard success rate, latency, unknown outcomes, and queue age; test the restore and reconciliation runbook.

## Further reading

- First-hand case: [Netflix prioritized load shedding](https://netflixtechblog.com/enhancing-netflix-reliability-with-service-level-prioritized-load-shedding-e735e6ce8f7d) shows protecting critical requests under overload.
- English: [Google SRE Book](https://sre.google/books/), [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/), [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/), [Microsoft reliability patterns](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/reliability-patterns), [AWS Well-Architected Reliability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html), [OpenTelemetry documentation](https://opentelemetry.io/docs/), [AWS Builders' Library: Timeouts, retries, and backoff](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)
- Persian: [Microsoft Learn فارسی: Reliability](https://learn.microsoft.com/fa-ir/azure/architecture/framework/resiliency/), [DNTips](https://www.dntips.ir/)
