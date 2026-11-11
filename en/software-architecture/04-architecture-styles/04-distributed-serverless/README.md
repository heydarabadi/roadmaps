# Distributed Systems, Actors, and Serverless

## Learning goals

- Reason about partial failure, message delivery, and distributed state.
- Explain event-driven and serverless execution trade-offs.
- Design bounded retries, idempotency, observability, and recovery.

A distributed system runs across multiple processes and is affected by latency, partial failure, clock differences, repeated or reordered messages, and asynchronous replicas. Serverless is a consumption model for execution, not the absence of infrastructure. An Actor owns its state and communicates through messages.

Set timeouts at network boundaries. Retries should be bounded, use backoff and jitter, and mutations should define idempotency. Circuit breakers, bulkheads, correlation IDs, dead-letter queues, and telemetry help contain failures; none of them automatically creates correct domain behavior.

## Example: processing product images

Image upload creates a durable event. A serverless worker resizes the image. A message can arrive again, so output should be versioned and processing idempotent. A queue absorbs bursts; a DLQ retains problematic messages for analysis. Consider a container worker if execution is long-running or needs a special runtime.

| Option | Benefit | Cost |
| --- | --- | --- |
| Managed function | Scales with usage | Runtime limits, cold starts, provider dependency |
| Actor runtime | State ownership and message-based concurrency | Persistence and distribution behavior |
| Long-running service | Runtime control and long tasks | Capacity, deployment, and patching |

## Step-by-step: a resilient consumer

Suppose ProductImageUploaded is delivered twice and the worker crashes while saving output:

1. **Define delivery semantics.** Many queues provide at-least-once delivery; duplicates are possible. Do not assume end-to-end exactly-once without a real guarantee.
2. **Use stable IDs.** Keep the event ID and image ID; determine whether this event already completed.
3. **Make effects idempotent.** Write output to a deterministic path based on ID and version, or atomically save result and processing status. Analyze a crash between separate writes.
4. **Bound time and retries.** Set function timeout, retry count, and backoff. Repeating a permanent error such as a corrupt file will not fix it.
5. **Operate the DLQ.** Give it an alert, owner, safe replay procedure, and retention/removal policy.
6. **Make it observable.** Preserve event ID in logs and traces; measure message age, queue depth, retries, and DLQ count.

Payment has the same concern for external side effects: the provider must support an idempotency key, or the current status must be queried before retry. Idempotent function code is insufficient if the provider charges twice.

## Actors versus queues and functions

An Actor mailbox and ownership of state serialize access to that Actor’s state. They do not automatically solve message loss, restart, partition, persistence, or migration. A queue buffers work between producers and consumers; a serverless function suits short-lived event work; a long-running service may suit persistent connections or long processing. Choose based on need rather than fashion.

## Estimating serverless cost

Cost includes more than execution duration: invocation count, time and memory, network egress, queue and storage, logging and tracing, cold starts, quotas, and dependent services. A continuously busy workload may be cheaper and more predictable in a long-running container; bursty workloads with long idle periods may benefit from usage-based billing. Check current execution, memory, concurrency, and region limits in the selected provider’s documentation.

## Availability and consistency

With multiple replicas, reads may lag behind writes. Define where read-after-write is required and where lag is acceptable. A circuit breaker temporarily stops useless calls; a fallback must still be valid for the business. Marking an order “complete” while payment is unknown is not a valid fallback.

## Self-check quiz

1. **Why does a timeout not prove the operation failed?** The response can be lost after the server commits the operation.
2. **What does idempotency provide?** Repeated execution becomes one logical effect.
3. **What does serverless not eliminate?** Security, network, failure, telemetry, and cost design.
4. **Does the Actor model itself provide durability?** No; persistence is separate.
5. **Why use a dead-letter queue?** To isolate messages after a retry policy and support owned investigation and recovery.

## Exercise

Compare a function and a container worker for invoice delivery by burst size, execution length, cost, network access, and observability.

### Sample answer

A function offers usage-based cost and automatic scaling for short bursts and long idle periods; check execution limits, cold starts, observability, and provider constraints. A container worker provides more control for long tasks, special dependencies, or sustained load, but needs capacity and patching. Both should use invoice ID as an idempotency key, bounded retries, and observable failures.

## Further reading

- Persian: [Persian Event-Driven Architecture notes](https://github.com/gloonch/eventdrivenfarsi), [Software architecture fundamentals](https://www.alirostami.com/software-architecture/)
- English: [AWS Event-Driven Architecture](https://aws.amazon.com/event-driven-architecture/), [Azure Serverless architecture style](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/serverless), [Akka typed actors](https://doc.akka.io/libraries/akka-core/current/typed/actors.html), [AWS Lambda best practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html), [Martin Fowler: Serverless architectures](https://martinfowler.com/articles/serverless.html)
