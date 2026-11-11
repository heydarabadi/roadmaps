# GraphQL and gRPC

## Learning goals

- Explain how GraphQL and gRPC differ from conventional REST APIs.
- Evaluate schema evolution, client needs, transport, performance, and security implications.
- Select an API shape from interaction patterns rather than fashion.

## GraphQL

GraphQL exposes a typed schema and lets a client request a selection of fields, often reducing over-fetching across complex screens. Queries read data; mutations request changes; subscriptions can deliver updates. A GraphQL endpoint does not automatically eliminate backend inefficiency: poorly bounded nested queries can cause N+1 database calls, expensive fan-out, or denial of service.

Use query depth/complexity limits, pagination, field-level authorization, request timeouts, and batching/caching strategies such as data loaders where appropriate. Authorization must be enforced by the server for each relevant object and field; hiding a field in the client is not a control. Schema changes need compatibility policy and deprecation periods. GraphQL's flexibility can make caching and observability less straightforward than resource URLs, so instrument operation names and cost.

## gRPC

gRPC uses Protocol Buffers interface definitions and generated client/server code. It supports unary and streaming RPCs over HTTP/2 in common deployments. Strong schemas and efficient binary encoding suit service-to-service calls, especially when teams control both ends. Browser support often needs a gateway or gRPC-Web. Proxies, load balancers, tracing, deadlines, and retries must be configured to respect streaming and HTTP/2 behavior.

RPC still creates temporal coupling: callers depend on service availability and response latency. Set deadlines, propagate cancellation, classify retryable failures, and use backoff with jitter. A retry of a non-idempotent operation can duplicate side effects unless the method and storage design prevent it.

## Choosing a contract

Choose GraphQL when clients need flexible field selection across a graph and the team can govern query cost and schema ownership. Choose gRPC for typed internal RPC and streaming between services where network and client tooling support it. Choose REST when resources and HTTP caching/interoperability provide a simpler public contract. These approaches can coexist behind clear boundaries.

## Worked example

A storefront may expose a GraphQL query for product page composition, calling catalog and review services through bounded resolvers. Inventory reservation can remain an explicit command API with idempotency. Internal high-volume inventory updates may use gRPC with deadlines and generated contracts. Establish tracing across all hops so one screen does not conceal dozens of slow downstream calls.

## Self-check quiz

1. What does GraphQL let the client choose? The fields and shape of a response from a typed schema.
2. Why can GraphQL still suffer N+1 queries? Resolver execution may issue one backend call per returned parent object.
3. What is a gRPC deadline? A bound on how long a caller waits before cancellation.
4. Why are protobuf field numbers important? They are part of the encoded wire contract and must not be casually reused.
5. Does generated gRPC code remove distributed-systems failure modes? No; timeouts, partial failure, retries, and compatibility still apply.

## Exercise

For a product detail page and an inventory reservation command, choose an API style for each and list authorization, load, retry, and versioning safeguards.

### Sample answer

Use GraphQL for a bounded product page query if clients benefit from selecting product, reviews, and recommendations together. Enforce ownership/visibility in resolvers, pagination, complexity limits, and tracing. Use a command-oriented REST or gRPC operation for reservation with quantity validation, caller authorization, deadline, idempotency token, and conflict response. Evolve schemas additively and test old clients.

## Further reading

- First-hand case: [Meta's GraphQL origin story](https://engineering.fb.com/2015/09/14/core-infra/graphql-a-data-query-language/) explains the mobile product needs behind the API design.
- English: [GraphQL specification](https://spec.graphql.org/), [GraphQL best practices](https://graphql.org/learn/best-practices/), [Apollo: GraphQL security](https://www.apollographql.com/docs/graphos/platform/security/overview), [gRPC documentation](https://grpc.io/docs/), [Protocol Buffers: Updating a message type](https://protobuf.dev/programming-guides/proto3/#updating), [Google SRE: Addressing cascading failures](https://sre.google/sre-book/addressing-cascading-failures/)
- Persian: [DNTips technical articles](https://www.dntips.ir/), [Quera software engineering resources](https://quera.org/college)
