# HTTP, TCP, UDP, RPC, gRPC, REST, and GraphQL

[فارسی](../../../../fa/system-design/03-network-edge-communication/13-protocols/README.md)

## Learning goals

- Separate network transport from application protocol and API contract.
- Compare TCP and UDP, REST and RPC, and common API shapes.
- Design timeouts, deadlines, and retries as part of a contract.
- Recognize the operational cost of unbounded query or streaming behavior.

## Central idea

Choose communication protocols to fit discoverability, versioning, streaming, latency, browsers, and service independence. A remote call can fail even when it looks like a local function call.

## Concept map

Name resolution → transport → TLS → application protocol → API contract → deadlines and failure behavior.

## Detailed lesson

### Separate the layers

IP routes packets to a host. TCP or UDP provides transport between processes. TLS adds confidentiality, integrity, and server authentication. HTTP defines methods, headers, and status codes. An API defines the business operations and data contract.

When “the connection is broken,” determine whether the issue is DNS, TCP setup, TLS negotiation, HTTP behavior, or endpoint logic. Logs from one layer cannot explain every failure in another.

### TCP and UDP

TCP provides an ordered, reliable byte stream. It retransmits lost data, so application code does not manage packet ordering. The costs include connection setup, congestion behavior, and possible head-of-line delay. TCP does not preserve application message boundaries; the program needs framing such as a length prefix or delimiter.

UDP sends datagrams without guaranteeing delivery or order. It is used for cases such as voice, games, DNS, or protocols that implement the needed reliability themselves. UDP should not simply be called “faster”; the application must account for loss, congestion, and any required ordering.

HTTP/3 runs over QUIC, which uses UDP while implementing its own transport behavior. This is different from saying HTTP/3 is an unreliable application protocol.

### HTTP methods and semantics

HTTP connects a method, target URI, headers, and optional body to a response with status and headers. Semantics matter for caching, safe retry, and intermediaries.

GET is intended to retrieve data and is safe and idempotent by definition. PUT replaces or creates a resource representation and is generally idempotent. DELETE is also defined as idempotent in effect, even if repeated responses differ. POST often creates or initiates an operation and is not automatically idempotent; the API can define an idempotency key.

A 429 response commonly indicates rate limiting. A 5xx response indicates a server-side failure, but does not prove no side effect occurred. TLS protects the connection; it does not replace authorization or input validation.

### REST, RPC/gRPC, and GraphQL

REST is resource-oriented and uses HTTP semantics, caching, and status codes. Calling an API “REST” does not make the contract clear by itself. Resource naming, pagination, versioning, error shape, and idempotency still need design.

RPC models operations across a process boundary. It should expose network failure and deadlines rather than pretending a remote call is a local function. gRPC uses a typed schema and Protocol Buffers and supports unary calls and streaming. Consider browser support, gateways, debugging, and schema evolution.

GraphQL lets clients request a particular data shape through a query language. This can reduce over-fetching, but deep or broad queries may fan out into many backend calls. Query cost limits, per-field authorization, and caching need explicit design.

### Timeouts, deadlines, and retries

A timeout limits how long one operation waits. A deadline limits the total time budget of the request path. If a gateway gives a request one second, a backend should not continue for three seconds after the client has already abandoned it. Propagate remaining deadline to downstream calls.

A timeout does not mean the server canceled the work. The operation may have completed while its response was lost. Retry only when the failure is likely transient and repeating the operation is safe. Use backoff, jitter, a maximum attempt count, and idempotency where necessary.

### Example API contract

A create-order API should define authentication, validation, error shape, versioning, replay behavior, and how a client follows asynchronous completion.

~~~http
POST /v1/orders
Authorization: Bearer <token>
Idempotency-Key: 41ab...
Content-Type: application/json

{"sku":"A7","quantity":1}
~~~

A successful response can return an order ID and initial state. If payment continues asynchronously, provide a status endpoint or event contract.

## Worked example

A public mobile API may favor REST and JSON for broad client support. High-volume service-to-service calls may use gRPC when typed contracts and streaming are useful. The gateway, monitoring tools, client capabilities, and failure semantics are part of the choice.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| REST/JSON | Broad interoperability and HTTP caching matter | Large or chatty payloads can waste bandwidth |
| gRPC | Typed internal contracts and streaming fit the clients | Browser, gateway, and debugging support need review |
| GraphQL | Clients need flexible selection of related data | Expensive queries and authorization can be hard to bound |
| TCP | Reliable ordered byte stream is needed | Application framing and connection lifecycle remain your responsibility |
| UDP/QUIC-based protocol | Low setup latency or transport behavior requires it | Loss, congestion, and protocol behavior still need understanding |

## Common pitfalls

- Retrying every POST as if it were safe.
- Using independent per-call timeouts instead of a total deadline.
- Assuming TCP preserves application messages.
- Allowing unbounded GraphQL query depth or resolver fan-out.
- Treating gRPC or RPC as if network calls cannot partially fail.
- Assuming TLS solves authorization and business validation.

## Short quiz

1. What is the core transport difference between TCP and UDP?
2. What makes gRPC useful for some service-to-service systems?
3. What operational risk can a deep GraphQL query create?
4. Why is a timeout not proof that an operation did not execute?
5. What does an idempotency key add to a create-order API?

### Answer key

1. TCP gives an ordered reliable byte stream; UDP sends datagrams without built-in delivery or ordering guarantees.
2. Typed contracts, compact serialization, and unary or streaming calls when the client ecosystem supports them.
3. It can cause expensive resolver fan-out and database work; query depth or complexity limits help.
4. The server may have completed the side effect while the response was delayed or lost.
5. It lets a repeated request resolve to the same logical operation instead of applying the business effect again.

## Exercise

Define an API contract for order creation and order-status retrieval. Specify protocol, method semantics, authentication, versioning, deadlines, retry safety, duplicate handling, error behavior, and how the client receives a later payment result.

## Summary

Protocols define different layers of communication; the API contract defines business behavior. Include deadlines, idempotency, authorization, and error semantics so a remote call remains safe when responses are delayed or lost.

## Further reading

- [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110) — methods, status codes, and HTTP behavior.
- [RFC 9113: HTTP/2](https://www.rfc-editor.org/rfc/rfc9113) — framing and multiplexed streams.
- [RFC 9114: HTTP/3](https://www.rfc-editor.org/rfc/rfc9114) — HTTP/3 over QUIC.
- [RFC 8446: TLS 1.3](https://www.rfc-editor.org/rfc/rfc8446) — secure channel protocol.
- [MDN: HTTP overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Overview) — practical HTTP concepts.
- [gRPC: Core concepts](https://grpc.io/docs/what-is-grpc/core-concepts/) — RPC, deadlines, and streaming.
- [GraphQL specification](https://spec.graphql.org/) — GraphQL language and execution semantics.
- [AWS Builders’ Library: Timeouts, retries, and backoff with jitter](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/) — safe interaction patterns.
