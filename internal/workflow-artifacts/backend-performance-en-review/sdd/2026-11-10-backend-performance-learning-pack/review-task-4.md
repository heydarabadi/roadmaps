# Read-only Task 4 review package

## Implementer report

# Task 4 report — Chapter 03: Asynchronism

Status: completed within assigned chapter scope. No Git repository was initialized and no commit was created.

## Files created

- `Backend Performace/03-asynchronism/README.md` — chapter purpose, prerequisites, two-topic sequence, request/reply boundary, shared report-export scenario, queue growth model, related chapters, and review checklist.
- `Backend Performace/03-asynchronism/01-background-jobs/README.md` — independently readable Persian lesson on heavy-work offloading; durable acceptance; API/result latency; status and job ownership; atomic intake/idempotency; leases and stale workers; transactional outbox boundary; backlog, age, deadlines, back pressure, retry and dependency capacity; worked example; calculation/failure exercise; Meta production evidence; operational signals/checklist; seven quiz questions with explained answers; Persian and English sources; relative navigation.
- `Backend Performace/03-asynchronism/02-message-brokers/README.md` — independently readable Persian lesson on service communication through brokers; work queue, pub/sub and logs; confirms versus acknowledges; delivery guarantees and their scope; durability; atomic local effects/deduplication; external effects; bounded intake, prefetch, retries/DLQ, ordering and schema contracts; worked example; duplicate-delivery/prefetch exercise; Slack production evidence; operational signals/checklist; seven quiz questions with explained answers; Persian and English sources; relative navigation.

## Coverage and evidence

Both Asynchronism roadmap bullets are separate lessons. The first is about removing eligible heavy work from the request critical path; a broker is explicitly optional. The second is about message-mediated communication and its failure boundaries. All numerical examples are explicitly educational, and neither case study is used as a universal performance promise.

Sources checked with the built-in web tool on 2026-11-10:

| Source | Use and verification result
| --- | --- |
| https://engineering.fb.com/2020/08/17/production-engineering/async/ | Loaded first-party engineering account; verified fairness/scheduling limitations, delay tolerance, quotas and intake rate limits. Used for background-jobs evidence. |
| https://slack.engineering/scaling-slacks-job-queue/ | Loaded first-party account with 2017 publication and 2020 update; verified Redis backlog/memory issue, Kafka-before-Redis design, relay rate limits and historical leader-only acknowledgment trade-off. Used for broker evidence. |
| https://www.rabbitmq.com/docs/reliability | Loaded official documents; checked duplicate delivery, publisher recovery, idempotency and mandatory routing behavior. |
| https://www.rabbitmq.com/docs/confirms | Loaded official documents; checked independence of publisher confirms and consumer acknowledges and failure/redelivery boundary. |
| https://www.rabbitmq.com/docs/consumer-prefetch | Loaded official documents; checked per-consumer scope, unchecked limit and zero/unlimited semantics. || https://www.rabbitmq.com/docs/queues | Loaded official documents; checked ordering caveats, queue durability and alternative stream structure. |
| https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html | Loaded official documents; checked dual-write problem and duplicate-event caveat. |
| https://docs.aws.amazon.com/wellarchitected/2023-04-10/framework/rel_mitigate_interaction_failure_fail_fast.html | Loaded official guidance; checked bounded queues and stale backlog issue. |
| https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/202 | Loaded; checked accepted-versus-completed semantics. Linked at chapter level. |
| https://alixsabet.com/fa/posts/2025/02/rabbitmq/ | Loaded directly relevant Persian practical explanation with PDF background processing and broker routing. Supplemental, not produced evidence. |
| https://sakoocloud.ir/databases/rabbitmq/ | Loaded Persian managed-service page. Clearly labeled commercial introduction rather than authoritative delivery/performance proof. |

The suggested DNTips design article was discovered through search, but `https://www.dntips.ir/news/details/16695` redirected to a URL the built-in tool could not fetch (500/non-retryable). It was not included in the chapter; The checked Persian practical article above supplies a closer accessible learning reference. Firecrawl was not called or retried.

## Checks performed

Manual content and quiz review, aided by a read-only file/link inventory: all three expected files exist; UTF-8 Persian text is readable; RTL containers close correctly; code examples are outside RTL containers; two topic answer keys have seven matching explained answers each; the numerical examples were recalculated; all in-chapter relative links and root/previous-chapter links resolve. No software tests or external services were run.

At inspection time the following six unique related-topic targets were not yet present because the other chapters are authored separately. Relative paths match the approved design and must be checked again at pack integration:

- `04-databases/README.md`
- `05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md`
- `06-code-optimization/04-critical-paths/README.md`
- `06-code-optimization/07-timeouts-and-retries/README.md`
- `07-monitoring-and-logging/01-metrics-logs-and-traces/README.md`
- `08-security/03-throttling-and-rate-limiting/README.md`

No root index or other chapter was edited. The report is the only authorized file written outside chapter 03. The chapter was inspected as Markdown source; no separate Markdown renderer or live RabbitMQ experiment was used. Exercises are explicitly paper/model exercises with stated expected observations.

## Concerns for integration

- Recheck the six sibling paths when the full pack exists.
- RabbitMQ source pages currently show version 4.4. The lesson avoids a version-pinned client implementation and labels its RabbitMQ/AMQP 0-9-1 scope; Later refreshes should recheck behavior against the user's installed broker/client version.
- Persian resources are supplementary tutorials/service introductions. Production claims come only from first-party Meta/Slack sources, and delivery-behavior claims from official documentation.

Report path: `D:\Learn\Roadmap\.superpowers\sdd\2026-11-10-backend-performance-learning-pack\task-4-report.md`.


## Snapshot: Backend Performance/03-asynchronism/README.md

   1: <div dir="ltr" align="left">
   2:3: # Chapter 3 — Asynchronous Processing | Asynchronism
   4: 
   5: The user does not have to wait for everything the server does. Creating a report, converting an image or sending a notification can be done after the request is accepted; Provided that acceptance, durability of work, final result and error have a clear contract. This chapter teaches two separate decisions: **What task to remove from the response path?** and **How should services communicate that task or event with messages?**
   6: 
   7: **Source check date: <span dir="ltr">2026-11-10</span>.** The chapter scope is taken from the Asynchronism section of the [Backend Performance Roadmap](https://roadmap.sh/backend-performance-best-practices). Numerical examples are educational and are not the result of measuring the real system.
   8: 
   9: ## Prerequisites and order of study
  10: 
  11: Familiarize yourself with the HTTP request/response cycle, the concept of a database transaction, and the difference between response time and throughput. First, read [Background Tasks](01-background-jobs/README.md) to determine the boundary of accepting and completing the task; Then read [Message Interfaces](02-message-brokers/README.md) to design message delivery, verification, and replication.
  12: 
  13: Subject | The main issue Checkable output
  14: --- | --- | --- |
  15: [3.1 Background Jobs] (01-background-jobs/README.md) | Transferring heavy work from a delay-sensitive path Status contract, delay budget and work recovery plan
  16: [3.2 Message Brokers] (02-message-brokers/README.md) | Asynchronous communication between producer and consumer Message contract, delivery guarantee and pressure control
  17: 
  18: `async/await` in a request does not necessarily commit work to the persistent queue. Also, a Job table with a Worker can create background work, without the need for an independent Broker. Choosing a broker also brings the issue of communication and system operation into the decision.
  19: 
  20: ## request/response boundary and shared scenario
  21: 
  22: Suppose it takes 4 seconds to create a sales report. The user first applies, gets the job ID, and then reads its status. The response `202 Accepted` means that the request for processing is accepted; Does not guarantee a successful outcome. This distinction is explained in [HTTP 202 Manual on MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/202).
  23: 
  24: </div>
  25: 
  26:```mermaid
  27: flowchart LR
  28:     U[Client] --> A[API: validate and persist job]
  29:     A --> R[202 + job status URL]
  30:     A --> Q[Bounded durable queue]
  31:     Q --> W[Worker]
  32:     W --> S[Result and job status]
  33:     U --> P[GET job status]
  34:     P --> S
  35: ```36: 
  37: <div dir="ltr" align="left">
  38: 
  39: The initial response becomes faster, but the time to get to the file still includes queue waiting and execution. If the input is 30 jobs per second and the actual capacity of workers is 20 jobs per second, about 10 jobs are added to the backlog every second. Queuing buys time; It does not create processing capacity. So record the number of jobs waiting, the age of the oldest job, the completion rate, and the end-to-end time of the result, along with the API response time.
  40: 
  41: In this scenario, the first lesson determines what should be stored before the response and how the user sees the failure. The second lesson shows why disconnection after Publish or after commit can lead to duplicate delivery. Even if the `API` response is fast, the continuous growth of the queue age indicates a breach of the product promise.
  42: 
  43: ## Connection with other chapters
  44: 
  45: - [Remove unnecessary server work](../02-api-response/04-avoid-unnecessary-server-work/README.md): Before moving work, check if it is necessary at all.
  46: - [Critical Paths](../06-code-optimization/04-critical-paths/README.md): Which step is actually required to answer this request?
  47: - [Timeout and Retry](../06-code-optimization/07-timeouts-and-retries/README.md): Coordinate the time limit of each attempt, the total task deadline and the retry budget.
  48: - [horizontal and vertical scaling](../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md): Worker scaling is only useful when the database or downstream service has capacity.
  49: - [Metric, Log and Trace](../07-monitoring-and-logging/01-metrics-logs-and-traces/README.md): Track the job ID from request to result.
  50: - [Rate Control](../08-security/03-throttling-and-rate-limiting/README.md): Acceptance limit is a means of preventing the accumulation of work outside the budget.
  51: 
  52: ## Chapter Review Checklist
  53: 
  54: - [ ] I can explain the difference between the initial response, the start of execution and the successful completion of the task.
  55:- [ ] For each type of work, I have specified the deadline, acceptance capacity and final status.
  56:- [ ] I measure Backlog and Queue Age and not just look at CPU or API response time.
  57: - [ ] I know what different failure bounds the Job, Publish and Ack stores have.
  58:- [ ] I have actionable response for message replay, concurrent execution, permanent error and worker termination.
  59: - [ ] I can explain with evidence that an independent Broker is necessary or a simple Job Store is sufficient.
  60: 
  61: **Study Path:** [Previous Chapter: API Response](../02-api-response/README.md) · [Package List](../README.md) · [Next Chapter: Database](../04-databases/README.md)
  62: 
  63: </div>

## Snapshot: Backend Performance/03-asynchronism/01-background-jobs/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: #3.1 — Background Tasks | Background Jobs
   4: 
   5: A background job is a task whose execution is separated from the life of the original request and, with a specified contract, will eventually reach the final result or failure later. **Offloading** is suitable for reducing request waiting; It does not automatically reduce the total amount of work.
   6: 
   7: **Resource review date: <span dir="ltr">2026-11-10</span>.** The numbers and reporting system on this page are educational examples. Meta-narrative in the evidence section is documented public experience.
   8: 
   9: ## Learning outcomes
  10: 
  11: After this lesson you can:
  12: 
  13:- Separate work necessary for response from work that can be postponed.14: - Measure the difference between the acceptance time and the time to reach the result.
  15:- Design a Job with Status, Timeout, Retry and Retry Safe Execution.
  16:- Explain the growth of the queue from the difference of entry and completion rates and limit acceptance.
  17:- Decide on Simple Job Store, Separate Worker and Independent Broker.
  18: 
  19: ## Mental model: delay-sensitive path shortening
  20: 
  21: Suppose the output build request includes validation, request registration, data reading, file creation and notification. If the product allows the file to be prepared later, the delay-sensitive path to the initial response only lasts until the persistent registration of the request. The authentication and access control required for admission cannot be removed in hopes of running the Worker.
  22: 
  23: Model | Initial response time Time to achieve the result New responsibility
  24: --- | --- | --- | --- |
  25: Synchronous execution Validation + data reading + file creation Almost the same as the end of the application Request Timeout Management |
  26: Asynchronous Job Validation + permanent registration Job | Acceptance + queue waiting + execution + publication of the result Status, recovery, repetition and notification
  27: 
  28: These three concepts are different: non-blocking execution of `I/O` in the same request, execution of multiple tasks in parallel, and delegation of work to independent Job. A `async` function that you are waiting for before responding is still in the process of responding. A separate thread or task in the memory may also be lost when the process is stopped; For important work, acceptance must be attached to a stable and retrievable record.
  29: 
  30: The usual work cycle is: `queued → running → succeeded`; A temporary error can push the job to `retry_wait` and then requeue. Permanent error or end of budget, status `failed`; Expired work also becomes `expired`. These statuses are suggested training contracts, not the mandatory designation of a tool.
  31: 
  32: ## Solved example: Creating a report with a clear contract
  33: 
  34: In the training assumption, validating 20, registering Job in database 10, generating report 4000 and publishing the result takes 30 milliseconds. We leave aside network overhead and resource competition for now. The synchronized version takes about 4060 milliseconds; The Job version declares acceptance after about 30ms, but the result is ready with an empty queue about 4060ms after the request starts. If the queue wait is 2 seconds, the result time is about 6060 milliseconds. This calculation separates the initial response time reduction from the result time improvement.
  35: 
  36: Keep the answer and message small; Instead of pasting all the customer data into the Job, save the data version ID and specification. The Snapshot or "runtime data" option must be turned on in the reporting contract, because data changes between acceptance and execution affect the result.
  37: 
  38: </div>
  39: 
  40:```http
  41: POST /exports
  42: Idempotency-Key: export-request-42
  43: Content-Type: application/json
  44: 
  45: {"report":"monthly-sales","month":"2026-10"}
  46: 
  47: HTTP/1.1 202 Accepted
  48: Location: /jobs/job-42
  49: Content-Type: application/json
  50: 
  51: {"job_id":"job-42","state":"queued","status_url":"/jobs/job-42"}
  52: ```53: 
  54:```text
  55: accept(request, user, idempotency_key):
  56:     authenticate_and_validate(request, user)
  57:     transaction:
  58:         return_existing_job_if_same_key_and_same_payload(user, idempotency_key)
  59:         reject_key_reuse_with_different_payload()
  60:         reserve_bounded_intake_slot_or_reject()
  61:         insert_job(job_id, owner_id, state="queued", deadline, payload_version)
  62:         commit
  63:     return 202, job_status_url
  64: 
  65: worker():
  66:     job = atomically_claim_due_job_with_expiring_lease()
  67:     if now > job.deadline: mark_expired(); return
  68:     result = generate_report_with_attempt_timeout(job)
  69:     write_result_to_deterministic_key(job.id, result)
  70:     mark_success_if_current_lease_owner(job.id, result.key)
  71: ```72: 
  73: <div dir="ltr" align="left">
  74: 
  75: This pseudocode assumes the database Job Store is directly the source of the Worker; Broker is not a condition for it. The acceptance key must be scoped with the user/tenant and its uniqueness enforced by the database itself. Capacity control should also be against accepting atomic concurrency; Simple counting before insertion is not enough. The Status Endpoint should control the ownership of the work and not hide `failed` behind a vague "in processing" status.
  76: 
  77: Lease makes work recoverable after death of Worker. If the execution time exceeds the Lease, the Worker must renew it; The final update depends on the lease ownership and version so that the old Worker does not overwrite the state of the new Worker. For an external effect such as sending an email, the static file name alone is not sufficient: use the provider's Idempotency key, the sending atomic record, or the unknown result matching process.
  78: 
  79: If you want to publish to Broker in addition to Job registration, two independent Writes have a failure gap: registration may succeed and sending may fail. In **Transactional Outbox**, you store the Job and the sending intent record in a transaction and send it later; The relay may resend, so the consumer still has to endure the replay. [AWS Official Guide to Transactional Outbox](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html) explains this boundary.
  80: 
  81: ## Capacity, queue age and backpressure
  82: 
  83: If each worker executes a four-second job, the theoretical capacity of 4 workers is equal to one job per second. This number is obtained assuming no competition on CPU, disk and database; The actual capacity must be measured. For arrival rate `λ` and completion rate `μ`, in the interval when the queue is not empty, the approximate backlog growth is `λ − μ`.
  84: 
  85: When logging in for 30 seconds, 3 tasks per second and completing one task per second, about 60 additional tasks remain. After the input stops completely, it takes about 60 seconds to empty. If the inflow is reduced to 0.5, the net discharge capacity is 0.5 and approximately 120 seconds are required. This approximation simplifies the resizing of jobs and the completion time of running jobs.
  86: 
  87: **Queue Age** means the age of waiting work; Calculate the age of the oldest pending job separately from the Job execution time. Two queues of the same length may have different waiting times. The limit of the number and bytes of accepted jobs, the quota of each tenant, the work deadline and the worker concurrency limit together create Backpressure. In accepting more than the budget, give an answer according to the contract, such as `429` for quota or `503` for temporary disability; Accepting the appearance and forgetting the work is not an alternative. [AWS: Fail fast and limit queues](https://docs.aws.amazon.com/wellarchitected/2023-04-10/framework/rel_mitigate_interaction_failure_fail_fast.html) warns Long backlog can lead to execution of stale requests.
  88: 
  89: ## When is it appropriate? What is the cost of the decision?
  90:91: Output generation, media conversion, indexing, and notifications with acceptable latency are good options. The result that this page needs to continue working or the inventory control that must be finalized before accepting the order cannot be postponed without changing the product contract. "Later" output requires UX status and failure. Running a Worker on the same API machine may saturate the shared CPU; Runtime isolation does not mean resource isolation.
  92: 
  93: Retry is useful for temporary error with backoff, jitter, retry limit and total timeout. Invalid input is not fixed with Retry. Continuously repeating a failed Job or increasing Worker when the database is slow can aggravate the incident. The time budget details are in [Timeout and Retry lesson](../../06-code-optimization/07-timeouts-and-retries/README.md).
  94: 
  95: ## Small exercise and expected observation
  96: 
  97: This is a computational exercise and does not require service installation. In a table, enter 12 four-second jobs at the same time in zero time. Assume a Worker and a FIFO queue. For each Job, write the start, wait and end time. Then rebuild the same table for 3 workers and then assume that the database does not have the capacity to run more than 2 jobs at the same time.
  98: 
  99: **Waiting:** With a Worker, the 12th Job finishes in 48 seconds and waits 44 seconds. With 3 independent workers and no bottleneck, the last batch starts in 12 seconds and finishes in 16 seconds. The assumption of database limitation indicates that the number 16 is no longer guaranteed; Queuing and contention should also be modeled in the same dependency. A default response of 30 ms does not eliminate any of these result times.
 100: 
 101: To check for crashes, stop the Worker on the model just after writing the file and before registering `succeeded`. When the lease expires, the job is re-run. The desired observation is a logical conclusion with the same key; If a duplicate notification is generated, the design of the outer effect is not yet complete.
 102: 
 103: ## Real evidence: Meta Async, 2020
 104: 
 105: Meta explains in [Async Engineering Narrative](https://engineering.fb.com/2020/08/17/production-engineering/async/) that shared queuing and simple scheduling would cause one large or stalled use case to affect others; Adding Worker alone would not solve the problem. The evolved design used latency tolerance, priority, and separate queues for use cases. The team also added resource quotas and acceptance rate limits to reduce the effect of input spikes and errors.
 106: 
 107: **Educational observation:** Capacity, justice between tasks and deadline are part of job design. This report is a public witness to the importance of timing and admission control; The example numbers reported on this page did not come from Meta, and its architecture is not a small system requirement.
 108: 
 109: ## Common errors and operation signal
 110: 
 111: Error What is seen? | Review action
 112: --- | --- | --- |
 113: Answer before saving stable work | Accepted ID without Job after Restart | Commit boundary check and response |
 114: Unlimited Queue Age growth, storage space and result time | Acceptance limit, priority and evacuation plan
 115: Long work without Lease renewal Simultaneous execution of a Job Extension, Fencing and Idempotency116: Retry permanent error High effort with constant or zero success rate Classification of errors and stops in the budget
 117: API tracking only `p95` Good answer, results hours behind | End-to-end time and the oldest Job
 118: Mixing urgent and bulky work Hunger of small work Separate queue/quota and resource budget
 119: 
 120: ## operational checklist
 121: 
 122:- [ ] The boundary of stable acceptance, the observable states and the result maintenance policy are clear.
 123: - [ ] Deadline of the whole job, Timeout of each attempt and Retry ceiling are independent and coordinated.
 124: - [ ] Process stop before/after side effect, Lease and task retry reviewed.
 125: - [ ] Job ID and Trace ID are searchable in API, Scheduler and Worker.
 126:- [ ] Login/Completion Rate, Waiting/Running Count, Queue Age and Final Error are seen.
 127: - [ ] The ceiling of the acceptance capacity, the quota of the tenant and the method of returning the pressure to the client are known.
 128: - [ ] Increase Worker does not deny dependency capacity; The Drain method exists when deploying.
 129:- [ ] Final failure, expiration, result cleanup and operational handling owner are defined.
 130: 
 131: ## short test
 132: 
 133: 1. What is the difference between `async/await` inside a request and a persistent Job?
 134: 
 135:2. In the example of 30 milliseconds of acceptance and 4030 milliseconds of subsequent work, what effect does a two-second queue wait have on the initial response and the result?
 136: 
 137: 3. How much backlog is added in 20 seconds with an entry rate of 5 and completion of 3 tasks per second?
 138: 
 139: 4. Why is "first check Job does not exist with this key, then insert" not enough for Idempotency?
 140: 
 141:5. Why is Retry risky if the Worker dies after sending the notification and before registering success?
 142: 
 143: 6. Why does increasing the Worker not always solve the problem when the database is slow?
 144: 
 145:7. How do you handle a persistent validation error in a Job?
 146: 
 147: <details>
 148: <summary> explanatory reply letter </summary>
 149: 
 150:1. The former usually has the same lifetime as the request and just waits for non-blocking I/O. Job requires independent history, state, and recovery after Process stop; The key difference is the separation of life cycle and durability.
 151: 
 152: 2. Assuming constant reception, the initial answer is still about 30 ms, but the result goes from about 4060 to 6060 ms. The wait is not removed and moved to the queue.
 153: 
 154: 3. About 40 works: the rate difference is 2 multiplied by 20. The assumption is that the queue is not empty and the rates and capacity are constant.
 155: 
 156: 4. Two requests at the same time can both see that the record is missing. Atomic Uniqueness clause, Key Scope and Payload matching check are required; Duplicate key with different content should be rejected.
 157: 
 158: 5. The external effect may have been done, but its local registration is not known. Reruns can send a second notification; The key is reproducibility in the destination or state matching and side effect policy is required.
 159: 
 160: 6. More workers may consume more connections, locks, and I/O on the bottleneck. The concurrency ceiling should be aligned with the dependency capacity and the impact of the change measure.
 161:162: 7. Without automatic retry, the final failure is logged with a safe cause and the user/operation has a way to modify the data or control resend. Repeating the same entry is not a permanent error treatment.
 163: 
 164: </details>
 165: 
 166: ## Selected sources
 167: 
 168: - **Persian, educational supplement:** [Working with RabbitMQ — Ali Thabit](https://alixsabet.com/fa/posts/2025/02/rabbitmq/); An understandable explanation of the PDF generation scenario in the producer/consumer background and vocabulary. It is training, not production witness; This lesson describes Job independently of the requirement to RabbitMQ.
 169: - **English, practical experience:** [Meta Async](https://engineering.fb.com/2020/08/17/production-engineering/async/); Studying the sections of scheduling, delay tolerance and quota.
 170: - **English, official reference:** [AWS Transactional Outbox](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html); Investigating the database write gap and message propagation.
 171: - **English, operational guide:** [AWS Fail fast and limit queues](https://docs.aws.amazon.com/wellarchitected/2023-04-10/framework/rel_mitigate_interaction_failure_fail_fast.html); Backlog cost and old work.
 172: 
 173: **Navigation:** [Chapter List](../README.md) · [Case List](../../README.md) · [Next Topic: Message Brokers](../02-message-brokers/README.md) · [Related: Scaling](../../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md) · [Related: Critical Path](../../06-code-optimization/04-critical-paths/README.md)
 174: 
 175: </div>

## Snapshot: Backend Performance/03-asynchronism/02-message-brokers/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: #3.2 — Message intermediaries Message Brokers
   4: 
   5: Message Broker is an intermediary for receiving, routing and delivering messages between producers and consumers. A message can be an order to do something or a news about an event. Broker provides time separation and flow control; Guaranteed end result and business rules still depend on the application.
   6: 
   7: **Source review date: <span dir="ltr">2026-11-10</span>.** General concepts are vendor independent; `Exchange`, `Ack`, and `Prefetch` details are illustrated on this page with RabbitMQ and AMQP 0-9-1. Do not generalize these behaviors to all brokers and protocols without checking.
   8: 
   9: ## Learning outcomes
  10: 
  11:- Explain the difference between Work Queue, publishing to multiple subscribers and readable Log.
  12:- You separate the boundary of Publish, Broker Confirmation, Delivery and Processing Completion.
  13:- You will analyze the repeated message, order, Idempotency and Retry with failure example.
  14:- You apply backpressure in both producer acceptance and worker consumption.
  15:- You decide on the operating cost of the Broker versus direct call or Job Store.
  16: 
  17: ## Mental model: boundaries and patterns
  18: 
  19: In direct communication, the recipient must usually be available when requested. The broker can retain the message according to the retention policy for later processing by the consumer; This separation increases the need for data contracts and observability. If the producer immediately waits for the consumer's final response, the delay-sensitive path still depends on that processing; Just going through the Broker doesn't cut it.
  20: 
  21: Pattern | Division of work Suitable for | Cost/Limit |
  22: --- | --- | --- | --- |23: Work Queue | several workers on a queue; Each delivery to a consumer Division of implementation of independent works Repetition after failure and order of completion
  24: Pub/Sub with separate queues | Each service has its own queue/subscription Inform the announcement and analysis at the same time Separate capacity, error and delay for each subscriber
  25: Log with Offset and Retention The reader holds the reading position Replay and event flow Lag management, maintenance and contract arrangement
  26: 
  27: A shared queue for two independent services usually splits the message between them; Both do not necessarily see all events. Create separate queues/shares for two independent reactions. In addition to Queue, RabbitMQ also has a Stream structure; Choosing a product name alone does not determine the consumption and reading model. [Queues official document](https://www.rabbitmq.com/docs/queues) introduces the difference between structures and the effect of Priority and Requeue on order.
  28: 
  29: </div>
  30: 
  31:```mermaid
  32: flowchart LR
  33:     P[Producer] --> X[Exchange: order events]
  34:     X --> N[Notification queue]
  35:     X --> A[Analytics queue]
  36:     N --> W1[Notification worker 1]
  37:     N --> W2[Notification worker 2]
  38:     A --> W3[Analytics worker]
  39: ```40: 
  41: <div dir="ltr" align="left">
  42: 
  43: In RabbitMQ, this route is defined by Binding and Routing Key. Lack of proper binding can make the message pointless. Check the behavior of `mandatory` and the return message for a flow that is sensitive to the message reaching at least one queue; Don't confuse receiving Publisher Confirm with correct destination. [RabbitMQ Reliability Guide](https://www.rabbitmq.com/docs/reliability) describes this mode in detail.
  44: 
  45: ## DELIVERY, CONFIRMATION AND WARRANTIES
  46: 
  47: Record three points separately: message acceptance at the Broker, delivery to the consumer, and recording of the successful effect of the consumer. **Publisher Confirm** is about the producer's interaction with the Broker; **Consumer Ack** About Broker's interaction with the consumer. The first one does not indicate that the final task is successful. In manual confirmation, send Ack after defined success point; An early Ack and then the death of the Worker can lead to the deletion of a task that has not completed. This separation is contained in the [Official Confirmations and Acknowledgments document](https://www.rabbitmq.com/docs/confirms).
  48: 
  49: Guarantee Meaning in the defined border Consequences for the program
  50: --- | --- | --- |
  51: At-most-once | The message may not arrive, but redelivery is not done in the same contract Can be checked for missing data
  52: At-least-once Redelivery is possible for an unconfirmed message, assuming durability, recovery and retention policies are met The repeated effect should be controlled
  53: Exactly-once in a range | A tool may inhibit replication within its specified range Analyze the external effect outside that range separately
  54: 
  55: Exactly-once alone does not guarantee "one email, one withdrawal and one write per system". If the Worker commits the work and is interrupted before the Ack, the Broker does not know about the completion of the work. This gap explains the need for Idempotency.
  56: 
  57: Persistent Queue, Message Persistence, Replication and Confirm policy are different components of persistence. Just don't take `durable=true` to mean that all messages are preserved in all crashes; Review Queue Type, Message, Acknowledgment, Maintenance, and Failover Behavior with [Queues Guide](https://www.rabbitmq.com/docs/queues) and the selected version contract.
  58: 
  59: ## Solved example: Order confirmation event
  60: 
  61: The following training example is an event that is published after an order is placed. The event ID remains constant for all attempts to publish the same event. `correlation_id` is for tracking and does not replace the repeatability identifier. The Schema version number helps the consumer to reject or quarantine an unknown message knowingly.
  62: 
  63: </div>
  64: 
  65:```json
  66: {
  67:   "event_id": "evt-204",
  68:   "type": "order.confirmed",
  69:   "schema_version": 1,
  70:   "occurred_at": "2026-11-10T08:00:00Z",
  71:   "correlation_id": "request-91",
  72:   "order_id": "order-204",
  73:   "order_version": 3
  74: }
  75: ```76: 
  77:```text
  78: consume(event):
  79:     validate_supported_schema(event)
  80:     transaction:
  81:         inserted = insert_processed_id_if_absent(
  82:             consumer="analytics-v1", event_id=event.event_id)
  83:         if inserted:
  84:             apply_local_analytics_update(event)
  85:         commit
  86:     ack_delivery()
  87: ```88: 
  89: <div dir="ltr" align="left">
  90: 
  91: The table of processed identifiers must have a unique clause on the consumer and event pair, and its registration must be accompanied by a local effect in a transaction. Otherwise, "id was registered but the effect failed" or the effect occurs again. Retention of identifiers must be coordinated with the replay horizon and possible latency; Early removal opens the door to repeat the effect. For email or an external API, this local transaction does not atomicize the destination effect; Idempotency key is required for destination or unknown result retrieval process.
  92: 
  93: Now see the error step by step:
  94: 
  95:1. Producer publishes, Broker accepts, but Confirm is lost in the network. The producer does not know whether the message has been received or not and may resend with the same `event_id`.
  96: 
  97:2. Consumer commits and dies before Ack. The message is delivered again; A single insert is not performed on the second run, the effect is not repeated, and then an Ack is sent.
  98: 
  99: 3. If the Ack was sent before the Commit, the death of the Worker could destroy the effect. So the arrangement of the boundaries makes the real contract.
 100: 
 101: [RabbitMQ Reliability Guide](https://www.rabbitmq.com/docs/reliability) explicitly explains the possibility of replication in recovery and the need for an Idempotent consumer. This example only covers transactional local effect. See [Outbox explanation in the Background Tasks lesson](../01-background-jobs/README.md) for the order entry and event release slot.
 102: 
 103: ## Backpressure, Retry and order
 104: 
 105: **Prefetch** limits the number of delivered but unacknowledged messages. For a RabbitMQ consumer with a cap of 10, after 10 unacknowledged messages the new delivery waits for capacity to be released; Zero value means infinite. Do not confuse this ceiling with the actual execution concurrency: a worker with a single thread may have 10 messages in memory but execute only one. [Consumer Prefetch Document](https://www.rabbitmq.com/docs/consumer-prefetch) Scope explains each consumer; Check the Channel and Version settings.
 106: 
 107: Prefetch only limits delivery pressure to the consumer; It does not prevent unlimited access to Broker. Also specify the message/byte limit, Publish rate limit, Outbox capacity, and reject or stop acceptance policy on the input. In filling mode, the behavior of Drop, Reject or Dead-letter should be according to the importance of the message and remain visible. Increasing disk space only pushes back the saturation time horizon, unless the completion capacity also reaches the input.
 108: 
 109: Define for temporary error, delayed retry, backoff, jitter and budget cap. Bad message immediate requeue can create hot loop and consume CPU and network. Schema error or persistent data goes to a quarantine location such as a **Dead-letter Queue (DLQ)**, if such a route is configured. DLQ not success: owner, warning, cause and controlled return method required. Transfer to DLQ and its durability should also be checked according to the tool and Queue type.
 110:111: The order of entering the queue is not the same as the order of completing the works. Two workers can finish version 4 of the order before version 3; Requeue and Priority also change the viewing order. If the order of each order is important, use order key for partitioning/serialization and `order_version` for stale message detection. This limits the parallelization of a hotkey. Ensuring global ordering usually costs more than ordering per entity.
 112: 
 113: ## When is Broker appropriate?
 114: 
 115: Broker is valuable when the producer and consumer must be independent at runtime or deployment, you have multiple independent reactions to an event, or you want to absorb short-term input volatility. The cost is service maintenance, capacity and storage, Schema contract, delivery error, security and multi-step troubleshooting. For a simple task in the same application, the persistent Job Store may be sufficient. For a response that is needed right now, it may be easier to make a direct request with Timeout on. Make the choice based on the need and measurement.
 116: 
 117: ## Small exercise and expected observation
 118: 
 119: Do a paper test with the message `evt-204`. Create a table with three columns "processed history", "order count" and "Ack sent". First get all empty/zero. Disconnect the consumer just after the Commit instance and before the Ack; Then deliver the same message again.
 120: 
 121: **Waiting:** After the first attempt, an ID has been registered and the count is 1, but you have no Ack. In the second attempt, the single adverb does not allow the re-effect; The count remains at one and an Ack is sent. If you put ID registration and count in two separate transactions, find the break point between them and show what data is missing or recalculated.
 122: 
 123: Now, assuming one consumer and Prefetch equal to 2, send five messages and hold Ack. A maximum of two messages being delivered/unacknowledged and three ready messages must remain; After the Ack one, another message is delivered. This observation is related to the Push model and the manual verification of this example. A low ready message count without checking Unacknowledged messages and Age is not a reason for health.
 124: 
 125: ## Real evidence: Slack job queue
 126: 
 127: Slack explains in [Scaling Slack's Job Queue](https://slack.engineering/scaling-slacks-job-queue/) with initial release 2017 and update 2020 that Redis could run out of memory and interrupt job acceptance when the Enqueue rate exceeded Dequeue. The team added Kafka before Redis and throttled Relay to decouple execution pressure from reception. The narrative also explains the historical choice of Leader verification, which accepted the risk of losing some work during a pre-replication failure for lower latency.
 128: 
 129: **Educational Note:** Broker name alone does not determine durability; Ack policy, storage and capacity of each stage should be aligned with the business sense. This historical Slack selection is not a financial order recommendation. The `evt-204` example and exercise on this data page are not Production Slack.
 130: 
 131: ## Common errors, signals and revisions
 132: 
 133: Error signal Practical review
 134: --- | --- | --- |135: Wrong binding Message return/no destination, Publish interval and consumption | Routing contract and return warning
 136: Consider Confirm as business success Successful producer, absent result | Result Status and Consumer Ack
 137: Prefetch or unlimited synchronization A lot of RAM and Acks, slow consumer Delivery ceiling and execution ceiling
 138: Requeue loop High delivery rate, low completion | Retry with delay and quarantine
 139: Incompatible Schema DLQ or Reject after deployment Version compatibility and gradual release
 140: Common queue for two independent services Each service has only part of the messages Separate subscription for each responsibility
 141: 
 142: ## operational checklist
 143: 
 144:- [ ] The meaning of each message, Schema, owner and compatibility policy are defined.
 145: - [ ] Publish policy failed/unknown, Confirm and untargeted message is documented.
 146:- [ ] Ack is intended after the effect and doesn't break repeating/simultaneous execution of the effect.
 147: - [ ] Message duration, Queue type, Replication and Retention limit are compatible with the requirement.
 148: - [ ] Publish/Delivery/Completion, Ready, Unacked, Age/Lag and Disk Space rates are visible.
 149: - [ ] Acceptance capacity, Prefetch and Worker concurrency are limited.
 150:- [ ] Retry has a budget; DLQ has a proprietary, warning and secure replay method.
 151: - [ ] Network interruption and Worker death are analyzed on both Commit and Ack sides.
 152:- [ ] The order required at entity level is clear and is not violated by increasing Consumer.
 153: - [ ] Publish/Consume access is minimal; Sensitive information is only included in the message as needed.
 154: 
 155: ## short test
 156: 
 157:1. If notification and analysis both need to catch all events, is a queue with two consumers sufficient?
 158: 
 159: 2. What exactly doesn't Publisher Confirm tell us?
 160: 
 161:3. How does Commit succeed and interrupt before Ack lead to a duplicate message and how does the example suppress its effect?
 162: 
 163: 4. Does Prefetch equal to 10 means 10 tasks are executed simultaneously? Does it stop the growth of the Broker queue?
 164: 
 165:5. Why is `durable=true` alone not a full guarantee of message durability?
 166: 
 167: 6. With two workers, does the FIFO queue guarantee that version 3 will finish before version 4?
 168: 
 169: 7. Requeue a message with an unsupported Schema version multiple times immediately or is another policy required?
 170: 
 171: <details>
 172: <summary> explanatory reply letter </summary>
 173: 
 174:1. no Consumers of a Work Queue compete to share the work. Each responsibility requires its own queue/subscription to receive all events independently.
 175: 
 176: 2. It does not tell the success of consumer processing or the bottom line of the business. Confirm covers the producer and broker boundary and is separate from Consumer Ack.
 177: 
 178: 3. Broker Ack is not received and may re-deliver the message. A unique clause combined with a local effect in a transaction stops the execution of the second effect; Then Ack is repeated.
 179:180: 4. No to both. Prefetch is the ceiling of the unacknowledged message in the scope; The execution concurrency is determined by the Worker and the input capacity of the Broker requires a separate limit.
 181: 
 182: 5. Queue durability, message durability, replication, release confirmation and retention policy are different. The set of settings and failure scenario should be checked, not just one flag.
 183: 
 184: 6. no The execution time of two workers can be different and the order of completion can be changed. Each order sequence requires serialization/partitioning and copy checking.
 185: 
 186: 7. An incompatibility error is often not treated with the same binary and message. Quarantine is more appropriate with Cause, Warning, Contract Modification and Controlled Replay; Immediate requeue creates an expensive loop.
 187: 
 188: </details>
 189: 
 190: ## Selected sources
 191: 
 192: - **Persian, practical training:** [Working with RabbitMQ — Ali Thabit](https://alixsabet.com/fa/posts/2025/02/rabbitmq/); Vocabulary and flow of Producer, Exchange and Consumer. For operational guarantees, refer to the official authority.
 193: - **Persian, introduction of services and applications:** [RabbitMQ Managed — Cloud Platform] (https://sakoocloud.ir/databases/rabbitmq/); Getting to know the use of message queues in a managed service. This page is a commercial introduction, not a proof of performance criterion or a provider selection requirement.
 194: - **English, official reference:** [RabbitMQ Reliability](https://www.rabbitmq.com/docs/reliability); Redelivery, Recovery, Idempotency and Routing.
 195: - **English, official reference:** [Confirms and Consumer Acknowledgments](https://www.rabbitmq.com/docs/confirms); The boundary of approvals and failure behavior.
 196: - **English, official reference:** [Consumer Prefetch](https://www.rabbitmq.com/docs/consumer-prefetch) and [Queues](https://www.rabbitmq.com/docs/queues); Delivery limit, type and duration of order.
 197: - **English, practical experience:** [Scaling Slack’s Job Queue](https://slack.engineering/scaling-slacks-job-queue/); Capacity decisions, flow control and delivery guarantee in real system.
 198: 
 199: **Navigation:** [Previous Topic: Background Tasks](../01-background-jobs/README.md) · [Chapter List](../README.md) · [Closed List](../../README.md) · [Related: Timeout and Retry](../../06-code-optimization/07-timeouts-and-retries/README.md) · [Related: Monitoring](../../07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) · [Next Chapter: Database data](../../04-databases/README.md)
 200: 
 201: </div>