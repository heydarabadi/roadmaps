# Background Jobs

[فارسی](../../../../fa/system-design/06-async-and-messaging/19-background-jobs/README.md)

## Learning goals

- Decide which work should leave an interactive request path.
- Design job acceptance, state, progress, and result delivery.
- Make workers recoverable, retryable, and safe under duplicate execution.
- Monitor backlog and manage priority, cancellation, and retention.

## Central idea

Background processing separates a long-running task from an interactive request. Acceptance, execution, and delivery of the result are separate stages.

## Concept map

Request/event/schedule → durable job acceptance → worker lease and execution → result state → polling, webhook, or notification.

## Detailed lesson

### What belongs in the background?

Move work out of a synchronous request when it is long-running, bursty, retryable, or does not need to finish before the user receives a response. Examples include generating a report, transcoding video, sending a large notification campaign, importing a file, or processing a business event.

If the work takes 20 ms and the caller needs its result immediately, a queue may add needless complexity. If a client waits for a 60-second response, network timeouts and user experience may be poor.

### Event-triggered and scheduled jobs

An event-triggered job starts after a business event: OrderPaid may trigger invoice generation. The event should be durable and deduplicatable.

A scheduled job runs at a defined time or interval, such as daily invoice closing. System clocks, multiple scheduler instances, and daylight-saving changes can alter behavior. Store the intended timezone and make the job idempotent so overlapping or repeated schedules are safe.

### Lifecycle and result contract

Give each job explicit states such as accepted, queued, running, succeeded, failed, cancelled, or needs_attention. HTTP 202 Accepted means the request was accepted; it does not mean the result is complete or successful.

Return a job ID, creation time, owner, progress, safe user-facing error, and status endpoint. Do not expose internal stack traces or secrets to the client.

The result can arrive through polling, webhook, event, or notification. Polling is simple, but frequent polling creates load; use backoff and Retry-After. A webhook needs authentication/signatures, retries, and deduplication. Large results can live in object storage behind a limited, time-bound link.

### Build a recoverable worker

Keep job payloads small and versioned. Put large data in storage and pass a reference. A worker should check capacity and dependency health, use a deadline, record checkpoints when needed, and be safe to rerun after a crash.

Record attempt number, time, error category, and correlation ID. Retry transient errors with backoff, jitter, and a limit. A permanent error such as invalid input should not retry forever.

### Concurrency and cancellation

A scheduler and a retry can deliver the same job at nearly the same time. A lock or lease can help, but does not provide exactly-once business effects. Make the effect idempotent.

Cancellation means a worker observes the signal and stops at a safe point. If a payment has already happened, changing the job state to cancelled is not enough; define a compensating business action.

### Operations and cost

A queue must not grow without limit. Monitor oldest-job age, backlog, arrival and completion rates, retries, dead-letter work, and runtime by job type.

Separate capacity or priority for tenants and workload classes so a long import cannot delay urgent notifications. Set retention for payloads and results according to privacy and audit needs.

## Worked example

A monthly report request returns a job ID quickly. The user follows its status and receives a time-limited download link after generation completes.

## Example response

~~~http
HTTP/1.1 202 Accepted
Content-Type: application/json

{"job_id":"rpt-8f2","status_url":"/jobs/rpt-8f2"}
~~~

The job status endpoint should distinguish queued, running, successful, failed, and expired results.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Durable queue | Work must survive process restarts | Duplicate delivery and retention need design |
| In-memory task | Short, noncritical work may be discarded safely | Restart loses work |
| Polling for results | Clients can check occasionally | Excess polling creates load |
| Webhook result | Clients need an event when work completes | Authentication, retries, and duplicate callbacks |

## Common pitfalls

- Returning 202 but losing the job before it becomes durable.
- Retrying without a maximum or classifying permanent errors.
- Returning success before the worker finishes.
- Sending duplicate emails or payments on retry.
- Retaining sensitive results indefinitely.
- Letting one tenant or job type consume all worker capacity.

## Short quiz

1. What does 202 Accepted not guarantee?
2. Why should a background job be idempotent?
3. Name three ways to deliver a later result.
4. How should a scheduler handle daylight-saving or repeated runs?

### Answer key

1. It means accepted for processing, not completed successfully.
2. A scheduler, broker, or worker may execute the same job more than once.
3. Polling a status endpoint, webhook, event/notification, or email.
4. Define a timezone and execution policy, persist job identity, and make repeated execution safe.

## Exercise

Design an image-import job for a store. Define the acceptance response, job states, result delivery, retry rules, cancellation points, idempotency key, progress metric, payload retention, and dead-letter repair process.

## Summary

A background job has its own lifecycle and user-facing contract. Persist the work, make retries safe, define result and cancellation behavior, and use queue-age signals to protect deadlines.

## Further reading

- [Azure: Background jobs best practices](https://learn.microsoft.com/en-us/azure/architecture/best-practices/background-jobs) — choosing, scaling, and operating background work.
- [Azure Well-Architected: Developing background jobs](https://learn.microsoft.com/en-us/azure/well-architected/design-guides/background-jobs) — operational implementation guidance.
- [Amazon SQS best practices](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-best-practices.html) — queue and worker practices.
- [Azure Queue-Based Load Leveling](https://learn.microsoft.com/en-us/azure/architecture/patterns/queue-based-load-leveling) — buffering work between producers and consumers.
- [AWS Builders’ Library: Avoiding insurmountable queue backlogs](https://aws.amazon.com/builders-library/avoiding-insurmountable-queue-backlogs/) — backlog and recovery behavior.
