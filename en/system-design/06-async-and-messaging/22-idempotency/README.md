# Idempotent Operations

[فارسی](../../../../fa/system-design/06-async-and-messaging/22-idempotency/README.md)

## Learning goals

- Explain why a timeout leaves the result of a remote operation uncertain.
- Design an idempotency-key contract for an API.
- Store the key and business effect safely under concurrency.
- Handle duplicate messages and external side effects.

## Central idea

Repeating the same intent should not repeat its business effect. Idempotency makes safe retries and message redelivery possible.

## Concept map

Client intent → stable idempotency key → atomic claim and result → one business effect → safe replay of prior outcome.

## Detailed lesson

### Why does the network create ambiguity?

A client sends a charge request. The server processes the payment, but the response disappears. The client sees only a timeout and cannot tell whether the charge was never made or the response was lost.

Creating a new request may charge the customer twice. Never retrying may leave the order unresolved. A timeout alone cannot tell the caller whether a side effect happened.

### Define the key contract

For one stable business intent, the client sends a stable key on every retry. The key scope should identify the tenant or account and operation. Use an unpredictable or collision-resistant value.

The server stores a canonical request hash with the key. Repeating the same key and same input returns the prior result or in-progress state. Reusing the same key with a different payload should be rejected with a defined error such as 409 Conflict.

### Atomically record the intent and effect

Store idempotency keys with a unique constraint. Claim the key and create the local business intent in one database transaction. Only the winning request proceeds.

If the effect is in the same database, commit the effect and idempotency result atomically. If the effect is external, such as a payment provider, use the provider’s idempotency key if available, persist the request durably, and reconcile the provider result. A local database cannot make a cross-bank transaction atomic.

### Model concurrent requests and states

Define states such as in_progress, completed, and retryable_failure. A concurrent request with the same key must not perform the effect again; it can receive the in-progress status or the stored result.

If the request owner crashes, use a lease/timeout and recovery process so a key does not remain pending forever. Keep final results for at least the legitimate retry period. Deleting a key too early can let a late duplicate execute again.

### Idempotency for message consumers

Record event ID or business key together with the processing result. Within one transaction, check whether the event was processed and persist the effect. Then acknowledge the broker message.

If the process crashes after database commit but before acknowledgement, the broker can redeliver. The duplicate sees the stored event ID and does not repeat the effect. For external effects, combine an outbox/inbox pattern with the provider’s key.

### What idempotency does not mean

An idempotent operation has the same intended final business state when the same intent is repeated. It does not mean retries are free, that payload differences can be ignored, or that deduplication lasts forever.

PUT /profile/1 with the same full representation is usually idempotent by HTTP semantics. POST /charge is not automatically idempotent unless the API defines it.

Retry policy still needs a transient-failure classification, deadline, backoff, and maximum attempts. Do not place raw idempotency keys in public logs or telemetry.

## Worked example

A payment response times out. The client retries with the same key; the server retrieves the existing charge status rather than applying the payment again.

## Example storage design

~~~text
idempotency_records:
  scope
  key
  canonical_request_hash
  status
  result_reference
  created_at
  expires_at

Unique constraint: (scope, key)
~~~

The business effect and key claim must be transactional when they share a datastore. External providers require their own dedupe and reconciliation behavior.

## Public engineering case study

[AWS Builders’ Library: Making retries safe with idempotent APIs](https://aws.amazon.com/builders-library/making-retries-safe-with-idempotent-APIs/) explains the reasoning behind safe retry behavior in distributed APIs.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Client-supplied stable key | A client may retry after an uncertain response | Key scope, reuse, and retention must be defined |
| Provider-side idempotency | An external provider supports the same business operation | Provider key expiry and status reconciliation still matter |
| Consumer inbox table | Broker redelivery is expected | Inbox retention and transaction boundary must fit the replay window |
| No retry | Operation cannot safely be repeated and no dedupe is available | Uncertain outcomes require manual or provider-side reconciliation |

## Common pitfalls

- Saving the key only after charging the customer.
- Using a key that changes on every retry.
- Reusing one key for different request bodies.
- Expiring keys before late retries become impossible.
- Claiming end-to-end exactly-once across independent databases and providers.
- Logging keys in broadly accessible telemetry.

## Short quiz

1. Why might a server not know whether a timed-out request executed?
2. Where should uniqueness be enforced?
3. What should happen if the same key arrives with a different payload?
4. Does idempotency guarantee exactly-once execution across multiple services?

### Answer key

1. The operation may have completed while the response was lost, or it may not have reached the server.
2. In a durable datastore with a unique constraint, transactionally related to the local business effect.
3. Reject it because one key represents one intent.
4. No. It makes repeated intent safe within the defined boundary; cross-service effects still need coordination, provider keys, and reconciliation.

## Exercise

Define idempotency for order creation and payment. Specify key generation, scope, request hashing, concurrent requests, state transitions, retention, provider behavior, recovery after a worker crash, and one test for a response lost after the effect succeeds.

## Summary

Idempotency turns uncertain retries into repeatable reads of one logical result. Use stable keys, enforce uniqueness durably, connect the key to the business effect, and define reconciliation across external boundaries.

## Further reading

- [AWS Builders’ Library: Making retries safe with idempotent APIs](https://aws.amazon.com/builders-library/making-retries-safe-with-idempotent-APIs/) — idempotency contracts and safe retries.
- [Stripe: Idempotent requests](https://docs.stripe.com/api/idempotent_requests) — API behavior for repeated requests.
- [Azure: Idempotent Consumer pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/competing-consumers) — consumer concurrency and duplicate processing considerations.
- [microservices.io: Transactional Outbox](https://microservices.io/patterns/data/transactional-outbox.html) — reliable event publication with local transactions.
- [AWS: Exponential backoff and jitter](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/) — retry timing under transient failures.
