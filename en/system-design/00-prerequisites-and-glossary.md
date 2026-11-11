# Prerequisites, Glossary, and Core Equations

[فارسی](../../fa/system-design/00-prerequisites-and-glossary.md)

This page prepares you to study the ten chapters without relying on another course. Prior experience designing distributed systems is not required. Basic programming, HTTP, and SQL knowledge is helpful.

## Minimum prerequisites

### Programs and processes

A program is code plus configuration; a process is a running instance of that program managed by an operating system. Several processes can run the same service. State kept only in a process’s memory disappears on restart and cannot be read by another process unless it is explicitly shared.

### Requests and responses

A client sends a request and a server returns a response. A typical web request has a method, path, headers, and body; a response has a status, headers, and body. Broadly, 2xx indicates protocol-level success, 4xx a request or authorization problem, and 5xx a server or dependency failure. An endpoint must define its exact semantics. A timeout means the response did not arrive before a deadline; it does not prove the operation did not execute.

### Databases and transactions

A table contains rows and columns. A primary key identifies a row; an index provides an access path for queries. A transaction groups changes within a database so they commit together or not at all. A unique constraint prevents duplicate values even under concurrent writes. A backup is a recoverable copy. A replica is a live copy used for durability, read capacity, or recovery, and it can lag behind the writer.

### Networks are unreliable

Connections can be delayed; packets or responses can be lost; and parts of a service can become unreachable while others remain healthy. Every network call needs a timeout or deadline and a defined failure behavior. Retry only when repeating the operation is safe, and use a bounded policy with backoff.

## Core glossary

| Term | Meaning |
| --- | --- |
| Availability | The fraction of time or eligible requests for which a service meets its response contract |
| Backpressure | Slowing or limiting producers when consumers cannot keep up |
| Cache | A faster, temporary copy used to reduce latency or load on a source |
| Consistency | The contract for how and when readers observe data changes |
| Consumer / producer | A message receiver / sender |
| Dependency | A service, database, or infrastructure component needed by a request path |
| Idempotency | Repeating the same intent does not repeat its business effect |
| Latency | Time taken to complete a request or unit of work |
| Load shedding | Deliberately rejecting lower-priority work to protect a service’s core function |
| Partition | Depending on context, a communication split between nodes or a slice of distributed data |
| p95 / p99 | Percentiles: 95% / 99% of observations are no slower than the stated value |
| Queue | Temporary storage for work waiting to be processed |
| Replication lag | The time or amount of data by which a replica trails its writer |
| RPO | Recovery point objective: the maximum targeted amount of data loss after a failure |
| RTO | Recovery time objective: the target maximum time to restore a service |
| Scalability | The ability to maintain acceptable quality as workload, data, or users grow |
| SLI / SLO / SLA | Service level indicator / internal objective / external agreement |
| Throughput | Units of work completed per unit of time |
| Timeout / deadline | Maximum wait for one operation / total time budget for a request path |
| Source of truth | The authoritative store that determines the business value of data |
| Hot key | A disproportionately popular key that concentrates load on one partition or node |
| Blast radius | The set of components or users affected by one failure |
| Graceful degradation | Serving a reduced but honest experience instead of failing completely |

## Equations used in the lessons

### Rate and capacity

Average request rate is requests divided by seconds in the interval. An estimated peak rate adds an assumed peak factor; validate that assumption with measured traffic. End-to-end capacity is constrained by the weakest required component. The capacity of an API alone is not the capacity of the complete system.

### Little’s Law

In a stable system, L = λ × W, where L is the average work in the system, λ is the arrival rate, and W is average time in the system. At 200 requests per second and 0.3 seconds of average residence time, about 60 requests are in flight on average. If arrivals remain above completions, the queue grows and the stability assumption no longer holds.

### Serial and parallel availability

For two independent components that are both required in series: A = A1 × A2. For two independent alternative paths where either one suffices: A = 1 - (1-A1)(1-A2). These formulas do not account for common-cause failures, shared routing, or corrupted shared data.

### Downtime and error budget

Allowed downtime = (1 - availability target) × interval. Over 30 days, 99.9% permits about 43.2 minutes; 99.99% permits about 4.32 minutes. If an SLI is based on eligible requests, do not directly convert it to a time-based uptime percentage.

## How to use each lesson

1. Explain the central idea in your own words.
2. Extract the example’s assumptions and recalculate its numbers.
3. Answer the quiz before reading the key; identify any assumption you missed.
4. Apply the exercise to a system you know: a store, booking service, or content platform.
5. For each decision, ask: Which need does this serve? What trade-off does it add? How will we know it works? What happens during failure?
