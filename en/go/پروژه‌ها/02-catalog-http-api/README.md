# Project 2 — Catalog HTTP API

<div dir="ltr">

## Problem and contract

Build a small catalog service. Start with in-memory storage so you can focus on HTTP behavior, validation, error contracts, and tests. Add persistence only after the API behavior is stable.

| Method | Path | Behavior |
|---|---|---|
| GET | /healthz | Basic process health |
| GET | /v1/items | Bounded list and pagination |
| GET | /v1/items/{id} | Read one item |
| POST | /v1/items | Create an item |
| PATCH | /v1/items/{id} | Update allowed fields |
| DELETE | /v1/items/{id} | Delete an item |

Define body, status, headers, error JSON, and invalid input behavior for each route before implementation.

## Domain model and DTO

A domain model carries application invariants. A DTO defines an external contract. They may differ to prevent leaking internal fields or coupling API changes to persistence.

~~~go
type Item struct {
    ID         int64     `json:"id"`
    Name       string    `json:"name"`
    PriceCents int64     `json:"price_cents"`
    CreatedAt  time.Time `json:"created_at"`
}

type createItemRequest struct {
    Name       string `json:"name"`
    PriceCents int64  `json:"price_cents"`
}
~~~

Tags document field names but do not validate values.

## Suggested layout

~~~text
catalog-api/
  cmd/catalog/main.go
  internal/catalog/item.go
  internal/catalog/service.go
  internal/catalog/repository.go
  internal/httpapi/handler.go
  internal/httpapi/handler_test.go
  go.mod
~~~

Define a small repository interface only for operations the use case consumes. A concrete implementation can be clearer if no substitution boundary is needed.

## Milestone 1: routes and status

Use http.NewServeMux. Reject unsupported methods with a controlled response and Allow header. Example status contracts: 201 create, 200 JSON response, 204 delete, 400 invalid input, 404 missing item, 405 wrong method, 409 uniqueness conflict, and 500 unexpected failure.

Centralize JSON response writing so content type and encode errors are handled consistently. Write headers before the body.

## Milestone 2: decoding and validation

Limit request-body size. Decode syntax, reject unknown fields when the API contract requires strictness, decode again to detect trailing JSON documents, then validate domain rules and authorization. Successful parsing does not imply valid business input.

Return stable public error codes. Do not expose SQL or internal details to clients. Avoid logging credentials or sensitive payloads. Evaluate encoding/json/v2 only when Go version and compatibility requirements fit.

## Milestone 3: use cases and errors

Keep the handler thin: parse, call application logic, map errors to HTTP. The service owns business rules. The repository wraps storage failures with context. Use errors.Is and errors.As rather than matching text.

A missing record is not the same as a failed database. Returning 404 for storage failure hides the real problem and misleads clients.

## Milestone 4: context and shutdown

Configure ReadHeaderTimeout, ReadTimeout, WriteTimeout, and IdleTimeout. Pass r.Context through services, database queries, and outbound requests. Nested timeouts should fit within the overall request deadline.

On SIGTERM, stop accepting new work and call Server.Shutdown with a bounded deadline. Background workers, transactions, and connection pools also need lifecycle handling.

## Milestone 5: tests

Use httptest.ResponseRecorder for direct handler tests and httptest.Server for client, transport, redirect, and header behavior. Go 1.27 adds httptest.NewTestServer, an in-memory fake network suitable for some testing/synctest cases.

Cover success, malformed JSON, oversized bodies, unknown fields, trailing documents, invalid values, missing IDs, wrong methods, repository errors, cancellation, and response-field privacy. Decode JSON and assert contract fields instead of raw whitespace.

## Milestone 6: real database

Choose a database when persistence requirements justify it. Use parameterized queries, context timeouts, migrations, pool limits, indexes, and transactions aligned with invariants. An ORM does not remove those concerns.

## Security and operations

Authentication verifies identity; authorization determines allowed actions. Depending on the threat model, add TLS termination, rate limits, audit logging, redaction, request IDs, and monitoring. The sample has no identity layer and should not expose administrative routes publicly.

Liveness and readiness answer different questions. A process health route does not prove database readiness.

## Design exercises with answers

**Why distinguish 404 and 500?**  
A missing record is an expected result; storage failure is a service failure.

**Should SQL errors be returned to clients?**  
No. Return a stable public code and keep protected diagnostic detail on the server.

**Why are server-side timeouts needed in addition to outbound timeouts?**  
Slow clients can hold request resources even when dependencies are fast.

## Quiz

### Questions

1. Why define an endpoint contract first?
2. How does a DTO differ from a domain model?
3. What does a body-size limit protect?
4. Does successful JSON parsing prove validity?
5. Why should storage failures not become 404?
6. What is the benefit of machine-readable error codes?
7. Where should request context be passed?
8. What does ReadHeaderTimeout reduce?
9. What tests a handler directly?
10. What tests a real HTTP client exchange?
11. Is listener shutdown alone sufficient?
12. Does an ORM remove SQL safety and transaction design?
13. What is the difference between authentication and authorization?
14. What should a public internal-error response omit?

### Answer key

1. To make status, schema, and failure behavior predictable.
2. The DTO is an external contract; the domain type holds application rules.
3. Unbounded memory and CPU use.
4. No. Business validation and authorization remain.
5. A database failure differs from a missing record.
6. Clients can branch on a stable code while text can vary.
7. Through use cases, database operations, and outbound calls.
8. Slow clients that hold connections while sending headers.
9. httptest.ResponseRecorder.
10. httptest.Server; Go 1.27 also adds NewTestServer for an in-memory fake network.
11. No; active requests and workers also need draining/cancellation.
12. No.
13. Identity verification versus access decision.
14. SQL, stack traces, secrets, internal paths, and sensitive payloads.

## References and further reading

- [net/http package](https://pkg.go.dev/net/http)
- [net/http/httptest package](https://pkg.go.dev/net/http/httptest)
- [Go 1.27 release notes: NewTestServer](https://go.dev/doc/go1.27#net_http_httptest)
- [Go security guidance](https://go.dev/doc/security/)
- [context package](https://pkg.go.dev/context)
- [database/sql package](https://pkg.go.dev/database/sql)
- [Go testing package](https://pkg.go.dev/testing)
- [Go diagnostics](https://go.dev/doc/diagnostics)

[Persian project guide](README.md) · [Next project: concurrent URL checker](../03-concurrent-url-checker/README.en.md)

</div>
