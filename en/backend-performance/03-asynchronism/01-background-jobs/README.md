<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/03-asynchronism/01-background-jobs/README.md) | **English**

# 3.1 — Background Jobs

A background job is a task whose execution is separated from the lifetime of its original request and later reaches a final success or failure under a defined contract. **Offloading** can reduce waiting in the request path; it does not automatically reduce the total work.

**Sources reviewed: <span dir="ltr">2026-11-10</span>.** Numbers and the reporting system in this lesson are educational examples. Meta’s story in the evidence section is documented public experience.

## Terms used in this lesson

A **Job** is a recorded task with an ID and status. A **Worker** is a process that claims ready tasks. **Durable** means the job record survives an application restart. **Idempotency** means repeating the same request/effect does not create a second business result. These definitions are sufficient for the lesson.

## Learning outcomes

After this lesson, you can:

- Separate work required for a response from work that can be deferred.
- Measure acceptance time separately from result-completion time.
- Design a Job with status, deadline, retries, and safe behavior under duplicate execution.
- Explain queue growth as the difference between arrival and completion rates, and limit intake.
- Choose between a simple Job Store, separate Worker, and standalone Broker.

## Mental model: shortening the latency-sensitive path

Suppose an export request requires validation, recording the request, reading data, generating a file, and sending a notification. If the product allows the file to arrive later, the initial response path ends after the request is recorded durably. Required authentication and access checks for acceptance cannot be deferred to the Worker.

| Model | Initial response time | Time until result | New responsibility |
| --- | --- | --- | --- |
| Synchronous execution | Validation + data read + file generation | Approximately the same as request completion | Managing request timeout |
| Asynchronous Job | Validation + durable Job record | Acceptance + queue wait + execution + result publication | Status, recovery, retries, and notification |

These are different concepts: nonblocking I/O within a request, running several tasks in parallel, and submitting work to an independent Job. An async function you await before responding is still on the response path. A thread or task in memory can be lost when the process stops; important work must be tied to durable, recoverable acceptance.

A typical lifecycle is queued → running → succeeded; a temporary failure may move it to retry_wait, then back to the queue. A permanent error or exhausted budget creates failed; an expired task becomes expired. These are suggested teaching states, not mandatory names for a particular tool.

## Worked example: a report with a clear contract

In this educational example, validation takes 20 ms, persisting the Job takes 10 ms, report generation takes 4,000 ms, and publishing the result takes 30 ms. We ignore network overhead and resource contention for now. Synchronous execution takes about 4,060 ms. The Job version can return acceptance after about 30 ms, but with an empty queue the result is still ready around 4,060 ms after the request started. If queue wait is two seconds, the result takes about 6,060 ms. This separates the initial-response improvement from result time.

Keep the response and message small; store identifiers and data-version metadata instead of copying all customer data into the Job. Specify whether the report uses a snapshot or data at execution time, since data can change between acceptance and execution.

```http
POST /exports
Idempotency-Key: export-request-42
Content-Type: application/json

{"report":"monthly-sales","month":"2026-10"}

HTTP/1.1 202 Accepted
Location: /jobs/job-42
Content-Type: application/json

{"job_id":"job-42","state":"queued","status_url":"/jobs/job-42"}
```

```text
accept(request, user, idempotency_key):
    authenticate_and_validate(request, user)
    transaction:
        return_existing_job_if_same_key_and_same_payload(user, idempotency_key)
        reject_key_reuse_with_different_payload()
        reserve_bounded_intake_slot_or_reject()
        insert_job(job_id, owner_id, state="queued", deadline, payload_version)
        commit
    return 202, job_status_url

worker():
    job = atomically_claim_due_job_with_expiring_lease()
    if now > job.deadline:
        mark_expired_if_current_unexpired_lease(job.id, job.lease_token)
        return
    result = generate_report_with_attempt_timeout(job)
    artifact_key = unique_key(job.id, job.lease_token, new_artifact_id())
    create_immutable_artifact_if_absent(artifact_key, result)
    published = atomically_update_job(
        where id=job.id and state="running"
              and lease_token=job.lease_token and lease_expires_at > database_now(),
        set state="succeeded", result_key=artifact_key)
    if not published:
        leave_unpublished_artifact_for_safe_garbage_collection()
```

This pseudocode assumes a database Job Store that Workers poll directly; a Broker is not required. Scope the intake key by user/tenant and enforce uniqueness in the database. Capacity reservation must also be atomic under concurrent requests; checking a count before inserting is not sufficient. The status endpoint must check ownership and must not hide failed behind a vague “processing” state.

A lease makes work recoverable after a Worker dies. Every claim gets a fresh, non-reusable lease_token. If execution outlasts the lease, the Worker must extend it conditionally using the same token. Updating Job status and result pointer is allowed atomically only for the current token, running state, and unexpired lease according to database time. An old Worker may not publish a result or change status; the token condition is needed for failure, expiry, and extension too.

**Fencing only the status is not enough.** If every Worker writes to one shared file key, an old Worker can corrupt the new Worker’s result even when its status update is rejected. In this example, each attempt creates an immutable file under its own unique key; the storage layer must reject writes to an existing key. Only that conditional Job update can publish the result_key pointer together with succeeded. The result endpoint follows only the pointer recorded in the Job; unpublished files must not be exposed through a directory listing or guessable names.

An old Worker may still write its own separate file, but it cannot change the winning file or Job pointer. Files without a pointer can remain after a failure; cleanup needs a safe delay and a check of current references so it does not delete a published file or a still-valid attempt. This pattern creates one logically visible result, not necessarily one physical file. For an external effect such as email, use the provider’s idempotency key, an atomic send record, or reconciliation for an unknown outcome; a file pointer does not make email atomic.

If you also Publish to a Broker after inserting the Job, there are two independent writes and a failure gap: the Job may persist while Publish fails. A **Transactional Outbox** stores the Job and intended message in one transaction, then sends it later; the relay may send duplicates, so the consumer must still tolerate repetition. [AWS Transactional Outbox guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html) explains this boundary.

## Capacity, queue age, and backpressure

If one Worker runs a four-second Job, four Workers have a theoretical capacity of one Job per second. This assumes no contention on CPU, disk, or database; measure actual capacity. For arrival rate λ and completion rate μ, when the queue is non-empty, approximate backlog growth is λ − μ.

If arrivals are 3 jobs/second and completions 1 job/second for 30 seconds, about 60 extra jobs remain. Once arrivals stop, draining takes about 60 seconds. If arrivals instead fall to 0.5 per second, net drain capacity is 0.5 per second and it takes about 120 seconds. This approximation simplifies variable Job sizes and completion of in-flight work.

**Queue Age** is the age of waiting work; measure the oldest waiting Job separately from execution duration. Two queues of equal length may have different wait times. Backpressure combines limits on accepted job count/bytes, per-tenant quotas, job deadlines, and Worker concurrency caps. When over budget, respond according to contract, such as HTTP 429 for a quota or 503 for temporary unavailability; silently accepting and forgetting the job is not an alternative. [AWS: Fail fast and limit queues](https://docs.aws.amazon.com/wellarchitected/2023-04-10/framework/rel_mitigate_interaction_failure_fail_fast.html) warns that long backlogs can lead to execution of stale requests.

## When is this suitable? What does it cost?

Report generation, media conversion, indexing, and notifications whose delay is acceptable are good candidates. A result needed immediately by the current page or inventory validation that must complete before order acceptance cannot be deferred without changing the product contract. A “later” result needs status and failure UX. Running Workers on the API host may saturate the same CPU; separating execution time does not separate resources.

Retries with backoff, jitter, a maximum attempt count, and an overall deadline help with temporary errors. Invalid input is not fixed by retry. Endless retries of a broken Job or adding Workers while the database is slow can worsen an incident. Detailed time budgets are in the [Timeouts and retries lesson](../../06-code-optimization/07-timeouts-and-retries/README.en.md).

## Exercise and worked solution

This is a calculation exercise; no service installation is needed. Put 12 four-second Jobs into a table at time zero. Assume one FIFO Worker. Record each Job’s start, wait, and finish. Repeat with three Workers, then assume the database cannot run more than two Jobs concurrently.

**Expected:** With one Worker, Job 12 finishes at 48 seconds and waits 44 seconds. With three independent Workers and no bottleneck, the last group starts at second 12 and finishes at 16. If the database caps concurrency at two, 16 seconds is no longer guaranteed; model the queue and contention at that dependency too.

Now examine a failure. Stop Worker 1 with token L1 after report generation, either before writing a file or after writing it but before publishing its pointer. Let its lease expire; Worker 2 with L2 writes its own file and records its pointer with succeeded. Then resume Worker 1 and let it try to write and publish its own pointer.

**Expected failure behavior:** The attempts use different file keys, so a late write from Worker 1 cannot replace Worker 2’s file. The conditional update for L1 must be rejected, and the result endpoint still returns the L2 file. The unpublished L1 file may remain for safe cleanup. This remains true if Worker 1 never resumes. If the notification is duplicated, the external-effect design is still incomplete.

### Step-by-step solution

With one Worker, Jobs 1 through 12 start at 0, 4, 8, …, 44 seconds; wait times are 0, 4, 8, …, 44 seconds, and the last finishes at second 48. With three Workers, each group of three starts together; the last group starts at 12 and completes at 16 seconds. If the source can handle only two heavy queries concurrently, the effective capacity in this exercise is two Jobs: six pairs start at 0, 4, 8, 12, 16, and 20 seconds, and the last pair finishes at second 24.

Under the failure, once L2 records its result with the valid token, L1 has no right to publish. Its unique file is only an orphan. After succeeded, the API follows the L2 pointer. This measures wait and completion, not the 202 response time.

## Real evidence: Meta Async, 2020

In [Meta’s engineering account of Async](https://engineering.fb.com/2020/08/17/production-engineering/async/), a shared queue and simple scheduling let one large or stalled use case affect others; adding Workers alone did not solve the problem. The evolved design used tolerated delay, priorities, and separate queues for different use cases. The team also added resource quotas and intake-rate limits to reduce the effect of failures and traffic spikes.

**Teaching takeaway:** capacity, fairness between jobs, and deadlines are part of Job design. This is public evidence for scheduling and intake control; the report-generation numbers in this lesson did not come from Meta, and its architecture is not mandatory for a small system.

## Common errors and operational signals

| Error | What is visible? | Inspection action |
| --- | --- | --- |
| Respond before durable job storage | Accepted ID without a Job after restart | Inspect commit/response boundary |
| Unbounded queue | Queue age, storage, and result time grow | Intake caps, priority, and drain plan |
| Long work without lease renewal | Same Job runs concurrently | Renewal, fencing, and idempotency |
| Shared result file with fencing only on status | Late old Worker changes the file | Immutable per-attempt file and atomic pointer publication with current token |
| Retry of permanent error | Many attempts, unchanged or zero success rate | Classify error and stop at budget |
| Monitor only the API | Good response p95, results hours behind | End-to-end time and oldest Job |
| Mix immediate and large jobs | Small work starves | Separate queue/quota and resource budget |

## Operational checklist

- [ ] Durable acceptance boundary, visible statuses, and result retention are defined.
- [ ] Total Job deadline, per-attempt timeout, and retry cap are independent and coordinated.
- [ ] Process stops before/after side effects, leases, and retries are reviewed.
- [ ] Every attempt writes an immutable unique file; pointer publication is atomic with status under a valid token/lease, so an old Worker cannot corrupt it.
- [ ] Job ID and Trace ID can be found across API, scheduler, and Worker.
- [ ] Arrival/completion rates, waiting/running count, queue age, and final errors are visible.
- [ ] Intake cap, tenant quota, and a way to return pressure to the client are known.
- [ ] More Workers cannot exceed dependency capacity; deployment has a drain process.
- [ ] Permanent failure, expiry, result cleanup, and operational ownership are defined.

## Quiz

1. How does async/await within a request differ from a durable Job?
2. In the example with 30 ms to accept and 4,030 ms of later work, what does two seconds of queue wait do to initial response and result time?
3. With arrivals of 5 and completions of 3 Jobs per second, how much backlog is added in 20 seconds?
4. Why is “check that no Job exists with this key, then insert” insufficient for idempotency?
5. If a Worker sends a notification and dies before recording success, why is retry risky?
6. Why does adding Workers not always fix a slow database?
7. How should a permanent validation error in a Job be handled?
8. Why does a token condition on recording succeeded alone fail to protect a shared result file, and how does this example fix it?

### Explained answers

1. The first generally lives within the same request and only makes I/O waiting nonblocking. A Job needs an independent record, status, and recovery after process stop; lifecycle separation and durability are key.
2. Assuming acceptance itself stays the same, the response is still about 30 ms, while result time rises from about 4,060 to 6,060 ms. Waiting moved into the queue; it did not disappear.
3. About 40 Jobs: the rate difference is 2 per second × 20 seconds. This assumes a nonempty queue and fixed rates/capacity.
4. Two concurrent requests can both observe no record. An atomic unique constraint, scoped key, and payload-match check are needed; reject reuse of the same key with different content.
5. The external effect may have happened while local status is unknown. A retry may send a second notification; use the destination’s idempotency key or reconcile uncertain outcomes.
6. More Workers can consume more connections, locks, and I/O on the bottleneck. Set concurrency against dependency capacity and measure the effect.
7. Do not retry automatically. Record a final failure with a safe cause and give the user/operator a way to correct data or deliberately resubmit; repeating the same input does not fix a permanent error.
8. The old Worker might overwrite the shared file before its status update is rejected. Each attempt must write a unique immutable file; publish its pointer only with an atomic status update conditioned on the current token and valid lease. A losing file is not exposed and can later be safely cleaned up.

## Summary

A durable Job needs its own lifecycle, visible status, and recovery; HTTP 202 reports acceptance only. A queue moves waiting time but creates no capacity. Measure arrival/completion and queue age, and bound intake, leases, retries, and side effects with safe duplicate handling.

## Optional references and further reading

The Job contract and example path are explained on this page. These links are optional further reading and operational/first-party references.

- Persian, supplementary tutorial: [Working with RabbitMQ — Ali Sabet](https://alixsabet.com/fa/posts/2025/02/rabbitmq/), explaining PDF generation in the background and producer/consumer terms. It is a tutorial, not production evidence; this lesson does not require RabbitMQ.
- English, first-hand engineering: [Meta Async](https://engineering.fb.com/2020/08/17/production-engineering/async/), scheduling, tolerated delay, and quotas.
- English, official architecture guidance: [AWS Transactional Outbox](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html), the gap between database writes and message publication.
- English, official operational guidance: [AWS Fail fast and limit queues](https://docs.aws.amazon.com/wellarchitected/2023-04-10/framework/rel_mitigate_interaction_failure_fail_fast.html), backlog cost and stale work.
- English, official architecture guidance: [Azure background job recommendations](https://learn.microsoft.com/en-us/azure/architecture/best-practices/background-jobs), selecting and operating asynchronous jobs; the guidance is Azure-oriented, while this lesson’s Job Store model is vendor-neutral.
- English, official architecture pattern: [Azure queue-based load leveling](https://learn.microsoft.com/en-us/azure/architecture/patterns/queue-based-load-leveling), buffering variable arrival rates; apply its capacity trade-offs independently of the specific Azure service.

[Chapter contents](../README.en.md) · [Course contents](../../README.en.md) · [Next: Message brokers](../02-message-brokers/README.en.md) · [Related: Scaling](../../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.en.md) · [Related: Critical paths](../../06-code-optimization/04-critical-paths/README.en.md)

</div>
