# System Design and Problem-Solving

[فارسی](../../../../fa/system-design/01-foundations/01-approach/README.md)

## Learning goals

By the end of this lesson, you should be able to:

- Turn an ambiguous product request into a bounded system-design problem.
- Separate functional requirements from measurable quality requirements.
- Estimate a first-order workload and label the assumptions behind it.
- Trace a request through its components, including failure and security paths.
- Explain why each architectural component exists and how you will evaluate it.

## Central idea

System design turns product needs and technical constraints into an architecture that can be built, measured, and operated when parts fail. A diagram is a thinking aid, not the answer. The design is only useful when it explains normal behavior, failure behavior, and how success will be observed.

## Concept map

Product goal → user journeys → workload and quality contract → API and data ownership → component choices → failure and threat analysis → operation and evidence.

## Step-by-step lesson

### Step 1: Rewrite the request as observable behavior

A prompt such as “build a store like a large online marketplace” is too broad. Break it into actions: a shopper finds an item, adds it to a cart, submits an order, inventory is reserved, payment is attempted, and the shopper receives a result.

Set boundaries. If the assignment is checkout, the design may depend on catalog and inventory services without redesigning advertising, warehouse robotics, or search. For every action, write the actor, input, output, and possible error. For example, a request to create an order might return an order identifier and a pending state; possible outcomes include insufficient inventory, a declined payment, a timeout, or a duplicate request.

The boundary prevents endless scope growth and makes dependencies visible. Record what the system owns and what it only calls.

### Step 2: Separate functional and quality requirements

A functional requirement describes behavior: “the shopper can cancel an order before it ships.” A quality requirement describes a measurable condition on that behavior: “95% of eligible cancellation requests complete within 300 ms,” or “the cancellation is authorized only for the order owner.”

Words such as fast, secure, and scalable are not yet design constraints. Convert them into a metric, threshold, measurement window, and population. Example values below are illustrative, not prescriptions:

| Vague need | Testable example |
| --- | --- |
| The service should be available | 99.9% of eligible create-order requests succeed over a rolling 30-day window |
| Checkout should be fast | p95 application response under 500 ms, excluding the external payment provider’s time |
| The system should be secure | Only the owner or an authorized support role can read an order; secrets never appear in logs |
| It should handle growth | Sustain a peak of 100 order-creation requests per second with durable acceptance |

A requirement needs context. “99.9% available” is incomplete unless you define which requests count, how failures count, and the measurement interval.

### Step 3: Write assumptions and constraints

If the prompt omits traffic, storage, geography, or budget, state a working assumption instead of pretending to know. Suppose the store receives 100,000 orders per day, has an 8× peak factor, and an average order record of 1 KB.

- Average order rate: 100,000 / 86,400 ≈ 1.16 orders per second.
- Estimated peak: 1.16 × 8 ≈ 9.3 orders per second.
- If each order causes six durable writes, peak write activity is roughly 56 operations per second.
- Raw order records use about 100 MB per day, or 36.5 GB per year before indexes, replicas, logs, and retention.

This is an order-of-magnitude estimate, not a capacity guarantee. If changing one assumption changes the architecture, validate that assumption early with product data or a measurement.

Also record constraints such as a required region, existing database, data-residency rule, maximum monthly spend, or team skills. These are part of the problem, not afterthoughts.

### Step 4: Derive the API and data model from the journey

Define the request and response contract, including duplicate delivery and errors. An order-creation API should consider an idempotency key so a client retry does not create two orders. The response may return an order in a pending state while payment continues asynchronously.

The order record might contain a stable identifier, owner, line items, a price snapshot, status, and important timestamps. Do not rely on a live catalog price to reconstruct an old invoice: the price at purchase time is historical business data.

Write down who owns each piece of data. If two services can independently make authoritative changes to the same fact, the design needs a conflict and reconciliation rule.

### Step 5: Trace one request end to end

Follow the request from client to response: DNS and TLS, gateway, application handler, queue or database, external dependency, and response path. At each hop ask:

- What is the timeout or remaining deadline?
- Which component owns the data?
- Is retry safe, and is it bounded?
- Can the user see a pending state?
- How will tracing continue across the boundary?

A box-only diagram hides important behavior. A useful diagram labels request direction, data ownership, trust boundaries, and failure modes.

### Step 6: Add failure and security paths

Ask what happens if payment times out after the provider has actually charged the card. Ask what happens if the database slows down for two seconds and request queues grow. What if a queue delivers a message twice? Which identity can read or change an order?

For each failure, record the user-visible result, whether data may be lost or duplicated, the recovery action, and how operators detect it. Security belongs in the architecture: identity, authorization, encryption, secret handling, and data retention all affect component boundaries and data flows.

### Step 7: Select components against explicit needs

Every component should answer a named need:

- A cache can help repeated reads when a defined level of staleness is acceptable.
- A queue can absorb bursts and move slow work out of a user request.
- A replica can support read capacity or recovery, subject to lag and failover semantics.
- A separate service can help when ownership, deployment, scaling, or isolation needs are real and independently measurable.

If no requirement and success measure justify the component, it may not belong in the first design. Write a short architecture decision record: context, options, choice, consequences, and a condition that would trigger a review.

### Step 8: Include operations and capacity

A design without metrics, alerts, backups, restore procedures, safe rollout, and rollback is not ready to operate. Choose indicators for the critical user journey and estimate the peak along the whole request path. Capacity needs room for bursts and for traffic shifted after a failure; operating at 100% of a component’s limit leaves no margin for either.

## Worked example

For an online checkout, trace “place order” through validation, inventory reservation, order persistence, payment, and confirmation. If the payment response disappears, the system must be able to find out whether the charge succeeded before it tries again. One possible design records a stable operation identifier, stores a pending order, calls the provider idempotently when supported, and reconciles uncertain outcomes.

Do not claim that one workflow fits every provider. The exact recovery design depends on payment API semantics and business rules for inventory reservation.

## Example contract

~~~text
Operation: create an order
Success response: stable order ID plus current state
Duplicate client retry: same intent resolves to the same order
Peak assumption: 100 requests/second
Quality target: p95 application latency below 500 ms, excluding provider wait
Security: owner-only order access; payment secrets never enter application logs
~~~

## Engineering experience and design choices

Google SRE describes production readiness in terms that include architecture and dependencies, instrumentation, capacity planning, change management, and performance ([SRE engagement model](https://sre.google/sre-book/evolving-sre-engagement-model/)). The practical lesson is that operational ownership should influence the design before deployment.

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| A simple single-deployment design | Scope and load are limited, and the team needs to learn the domain | A real isolation, capacity, or availability need may later require a boundary |
| Distributed services | Independent ownership, deployment, scaling, or failure isolation is required | Network calls, data coordination, and operations may cost more than the isolation is worth |
| A cache | Reads are repeated and freshness rules are explicit | Stale or inconsistent business data can mislead the user |
| A queue | The caller does not need the work completed inline and backlog is managed | A growing backlog can turn “accepted” into delayed or expired work |

## Common pitfalls

- Choosing technologies before defining users, workload, and constraints.
- Estimating capacity without labeling assumptions.
- Treating a timeout as proof that an operation did not happen.
- Designing only the happy path and omitting retries, partial failure, and recovery.
- Adding a cache, queue, replica, or microservice without a stated need.
- Treating availability as 100% or security as a final checklist.
- Forgetting operating cost, migration, rollback, and restore.

## Short quiz

1. Give three functional requirements and three measurable quality requirements for checkout.
2. Why is “make it fast” not yet a useful requirement?
3. If a payment call times out, what facts do you need before retrying?
4. What should an architecture diagram show beyond boxes and arrows?

### Answer key

1. Functional examples: create an order, reserve inventory, cancel before shipment. Quality examples: p95 response threshold, successful-request SLO, owner-only access, or a durable-acceptance peak rate.
2. It has no endpoint, population, threshold, measurement method, or time window. Different teams could claim success while delivering different experiences.
3. Whether the provider could have processed the charge, whether the request is idempotent, the operation identifier, the remaining deadline, and the provider’s query/reconciliation mechanism.
4. Request and data flow, ownership, trust boundaries, timeouts, failure modes, and recovery or observability paths.

## Exercise

Choose a booking, store, or content service. Write five user-visible requirements, three quality targets, and at least four assumptions. Draw a request path. Mark the source of truth, network and trust boundaries, possible partial failures, sensitive data, and how the team will observe and recover from an incident. Then write a test that could disprove one of your architectural assumptions.

## Summary

Begin with user behavior, make quality measurable, and label uncertainty. Trace the normal request and its failure paths before choosing components. A defensible design explains its trade-offs, operating plan, and evidence for success.

## Further reading

- [Google SRE: Production readiness and engagement model](https://sre.google/sre-book/evolving-sre-engagement-model/) — architecture, instrumentation, capacity, and operations.
- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) — questions for reviewing reliability, security, performance, and cost.
- [Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/) — architecture styles, patterns, and design principles.
- [AWS Builders’ Library](https://aws.amazon.com/builders-library/) — operational lessons from large-scale services.
- [Netflix TechBlog](https://netflixtechblog.com/) — public engineering articles and system case studies.
