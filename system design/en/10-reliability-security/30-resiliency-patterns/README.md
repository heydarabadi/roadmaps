# Resiliency Patterns

[فارسی](../../../10-reliability-security/30-resiliency-patterns/README.md)

## Learning goals

- Design bounded retries, backoff, and deadlines.
- Explain compensating actions and their limits.
- Understand leader election and fencing.
- Combine patterns into a recoverable workflow.

## Central idea

Resiliency means continuing in a controlled way or recovering safely after partial failure. Retries, compensation, and leader selection must be bounded and observable.

## Concept map

Failure mode → limit and isolate impact → durable progress → recover or compensate → verify end state.

## Detailed lesson

### Retry, timeout, and deadline

Retry only a failure that is likely transient; repeating validation or permission errors will not help. Exponential backoff increases delay between attempts; jitter spreads attempts across time. Set a maximum attempt count and an overall deadline.

If the first call may have caused a side effect, reuse the same idempotency key. Retries layered at several services can multiply a request many times.

### Bulkhead and circuit breaker

A bulkhead limits how many resources a dependency can consume. A circuit breaker opens after repeated failures, quickly rejects new calls, and later allows controlled probes.

Combine them with timeout and admission control. Do not assume a fallback is free: it may use the same failing dependency or return dangerously stale data.

### Compensating transactions and sagas

In a multi-step workflow, each step may create a durable side effect. If a later step fails, compensation is a new business action: release a reservation, issue a refund, or cancel a shipment.

Compensation may fail or be delayed, and it does not always reverse the original effect exactly. Record steps, correlation IDs, workflow state, retries, and a manual path for failed compensation.

### Leader election and fencing

A leader may coordinate a scheduler, partition owner, or single writer. A lease can expire during a network pause even while the old leader continues running.

Generate a monotonically increasing fencing token with each election. The storage system should reject writes carrying an older token. A distributed lock without ownership, expiry, and recovery rules does not guarantee a single writer.

### Health, queue leveling, and scheduler-agent-supervisor

Health endpoints separate readiness from liveness. Queue leveling keeps bursts within a bounded buffer and needs oldest-age monitoring, backpressure, and a dead-letter path.

A scheduler-agent-supervisor workflow coordinates long-running work, workers, and recovery. Checkpoints and idempotency prevent restart from repeating a result incorrectly.

### Resilience design for an order

The API stores an order with a deadline and idempotency key. An outbox records a durable event. A worker calls the payment provider with bounded retry. A breaker and bulkhead limit the effect of provider failure. A status endpoint exposes uncertain outcomes; reconciliation checks the ledger; compensation releases inventory after a final failure.

Give each stage its own metrics and alert.

### Recovery exercises

For every important dependency, list slow response, unavailable endpoint, partial response, duplicate, stale data, and full queue as possible failure modes.

Run a tabletop scenario or controlled failure injection. Record actual recovery, not just whether an exception handler exists. The goal is predictable behavior and a safe recovery path.

## Worked example

An inventory reservation succeeds but payment is definitively rejected. A saga releases the reservation. If release fails, persist the compensation task and alert an owner rather than losing the work.

## Retry example

~~~text
delay = min(cap, base × 2^attempt) + random_jitter
after the maximum attempt count, dead-letter or escalate for review
~~~

This timing rule is still subject to the request deadline and a retry budget.

## Public engineering case study

[AWS Architecture Blog: Exponential Backoff and Jitter](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/) explains how randomized retry timing reduces synchronized load.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Retry | Failure is transient and repeating the intent is safe | Storms, deadline overrun, and duplicate side effects |
| Compensation | A durable workflow must undo or offset earlier steps | Compensation can fail and is not an atomic rollback |
| Leader election | One actor must own a scheduled task or write partition | A stale leader may continue without fencing |
| Queue leveling | Work can wait and backlog is bounded | Queue delay can exceed task validity |

## Common pitfalls

- Retry storms caused by unlimited or synchronized attempts.
- Non-idempotent compensation.
- Split brain after lease expiry.
- Recovery without checkpoints.
- Treating a queue as unlimited durable capacity.

## Short quiz

1. Why is jitter useful?
2. How does compensation differ from a database rollback?
3. What does a fencing token prevent?
4. Why must compensation be durable?

### Answer key

1. It randomizes retry times so clients do not all send a new burst together.
2. Compensation is a new business action, such as refunding a payment; rollback atomically reverses work inside one database transaction.
3. It prevents a delayed former leader from writing with stale ownership.
4. The process may fail while compensating; persisted work allows later retry and audit.

## Exercise

Design a resilient order workflow. Give each call a deadline and retry rule, show idempotency, choose bulkhead and breaker behavior, define saga compensation, and describe how a new leader safely resumes work. Include a controlled failure scenario and recovery measure.

## Summary

Resiliency is controlled continuation and safe recovery, not endless retry. Bound attempts, persist workflow state, fence stale leaders, and make compensation observable and repeatable.

## Further reading

- [Azure: Transient fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults) — bounded retry and circuit-breaking guidance.
- [Azure Circuit Breaker pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker) — failure isolation and recovery probes.
- [Azure Bulkhead pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/bulkhead) — resource isolation.
- [Azure Scheduler-Agent-Supervisor pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/scheduler-agent-supervisor) — long-running task recovery.
- [AWS: Exponential backoff and jitter](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/) — randomized retry timing.
- [AWS Builders’ Library](https://aws.amazon.com/builders-library/) — retries, idempotency, and production resilience.
