# Client-Server and Layered Architecture

## Learning goals

- Explain client-server responsibilities and common request lifecycles.
- Compare layered separation with the risks of accidental coupling.
- Trace latency, trust, and failure across a request path.

## Core idea

These styles organize responsibility and dependencies. A client requests work from a server; a layered design separates presentation, application/domain, and infrastructure/data. The split is useful when it creates clear behavior boundaries and enforceable dependency rules.

## Concepts and example

A client sends a request through a contract and receives a response or error. A browser and API, mobile client and backend, or billing service and identity service are examples. A server may be stateful or stateless; a network boundary adds latency and failure, so timeouts, bounded retries, idempotency, authentication, and versioning matter.

The UI layer receives input; an application service coordinates a use case; the domain owns business rules; infrastructure handles storage and external connections. A layer is a logical division; a tier is a deployment boundary. In an appointment system, the controller turns input into a command, the application service coordinates booking, the domain rejects schedule conflicts, and a repository persists the result.

~~~text
Browser -> HTTPS -> Web/API -> Use cases -> Domain rules
                                           ^ interface
                                      SQL adapter
~~~

| Style | Fits when | Risk |
| --- | --- | --- |
| Layered | Traditional domain and moderate change | Pass-through CRUD and database coupling |
| Client-server | Multiple client types or separate ownership | Round trips and network dependence |
| Separate tiers | Independent security or scaling boundary is valuable | Network cost and consistency issues |

## Step-by-step: from browser request to data

Suppose a customer selects “Place order.” Each step has a specific responsibility:

1. **Browser:** validates input for usability. This is not a security boundary because a user can construct the HTTP request manually.
2. **API:** derives identity from a valid session or token, validates message shape, and maps input errors to the public contract.
3. **Application service:** coordinates the use case, loads the cart, calls domain rules, and manages the local transaction.
4. **Domain:** enforces rules such as “an order has at least one line” and “the server computes the amount from an authoritative price.”
5. **Repository/adapter:** connects an internal contract to SQL or an external service. The domain should not depend on a database type or provider SDK.
6. **Response mapping:** returns a contract-compliant success or error; never send a stack trace or query to the customer.

This flow does not make the whole business operation atomic. If inventory reservation and payment happen in independent systems, one SQL transaction cannot commit both. Use a multi-step process with idempotency and compensation.

## Layer versus tier

A layer is a boundary of **code and responsibility**; a tier is a boundary of **process, machine, or network**. Several layers can run in one process, or an API and database can run in separate tiers. A deployment split adds latency, credentials, connections that can break, and operational responsibilities. Accept that cost when security, scaling, ownership, or availability benefits are measurable.

## Dependency rules that make real layers

- A use case calls the domain to apply a rule; the domain depends on abstractions rather than a specific adapter.
- Adapters belong at the edge: HTTP, database, queue, and payment provider connect to internal contracts.
- If every layer can bypass every other layer, the structure is only folder naming. Enforce dependency rules with architecture checks, lint, or review.
- More layers do not automatically improve quality; keep a layer when it limits change or owns a meaningful responsibility.

## Handling client-server failures

A network result can be ambiguous: a timeout means “no response arrived in time,” not “the server definitely did nothing.” A bounded retry with backoff may be acceptable for a query. For a command, determine what a repeat does first. The client can send an idempotency key; the server returns the prior result for the same identity and payload. Define the key’s uniqueness scope, result storage, and retention. Reject a different payload using the same key.

Retries at several layers can multiply and amplify an outage. Budget an overall deadline, retry count, backoff with jitter, and concurrency limit against latency. For cached reads, define how stale the data may be.

## Store example

For a product image, the browser could upload directly to storage using a short-lived signed URL, avoiding a data path through the application server. For order creation, the server must calculate price and permissions from authoritative data. Keeping API and database in one deployment simplifies operation; a separate tier is justified if network separation or independent scaling has measured value.

## Common pitfalls

- Assuming a separate deployment automatically reduces coupling.
- Putting business rules in controllers.
- Ignoring timeouts and partial failure.
- Creating layers that only pass data through.

## Self-check quiz

1. **How does a layer differ from a tier?** A layer is a logical responsibility division; a tier is an execution/deployment boundary.
2. **Why are unconditional retries dangerous?** They may repeat side effects or create retry storms; use idempotency and limits.
3. **When is layering useful?** When it controls dependencies and makes responsibilities understandable.
4. **When does a layer become ceremony?** When it protects no boundary or policy and only forwards data.
5. **What does a timeout prove?** Only that no response arrived before the deadline.

## Exercise

Trace appointment cancellation from HTTP to the database and identify where refund rules belong.

### Sample answer

An HTTP adapter passes the request to an application use case. The domain checks the appointment window and cancellation/penalty policy. A repository stores the state atomically. Any refund occurs through a payment adapter and separate workflow, not inside the controller. The API responds after its local commit; refund and notification effects use explicit state and idempotency.

## Further reading

- Persian: [Software architecture fundamentals](https://www.alirostami.com/software-architecture/), [What is software architecture?](https://www.amatistech.com/software-architecture/)
- English: [Microsoft Azure Architecture Styles](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/), [Microsoft common web application architectures](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures), [AWS application architecture](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html), [Martin Fowler: Presentation Domain Data Layering](https://martinfowler.com/bliki/PresentationDomainDataLayering.html)
