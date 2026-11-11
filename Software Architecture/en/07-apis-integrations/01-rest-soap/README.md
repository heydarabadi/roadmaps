# REST and SOAP

## Learning goals

- Distinguish resource-oriented HTTP APIs from SOAP web services.
- Design stable contracts, status/error behavior, validation, and compatibility rules.
- Choose based on ecosystem, governance, interoperability, and operational constraints.

## REST as a resource-oriented style

REST is an architectural style, not merely JSON over HTTP. A REST API models resources and uses the uniform HTTP interface: methods, status codes, headers, caching, and representations. In everyday APIs, the practical goal is usually to follow HTTP semantics consistently even when the API is not fully hypermedia-driven REST.

Represent stable nouns such as orders and payments. GET reads, POST commonly creates or invokes a subordinate operation, PUT replaces a representation, PATCH applies a partial update, and DELETE removes or deactivates a resource. Do not assume every method is safe or idempotent: GET is safe; PUT and DELETE are idempotent by intended effect; POST is not automatically idempotent. Payment creation often needs an idempotency key so a retry does not charge twice.

Use status codes to communicate outcome: 200/201 for success, 204 when no body is returned, 400 for invalid input, 401 for missing/invalid authentication, 403 for denied permission, 404 for absent or intentionally concealed resources, 409 for a state conflict, and 429 for rate limits. Return structured errors with a stable machine-readable code, a safe message, and a trace identifier. Do not expose stack traces or secrets.

## SOAP and contract governance

SOAP defines a structured XML messaging protocol with envelopes, headers, and bodies. WSDL describes operations and messages; XML Schema defines shapes. WS-* specifications can address enterprise concerns such as security and reliable messaging, at the cost of complexity and tooling requirements. SOAP remains useful where established partner contracts and governance depend on it.

Regardless of style, version contracts intentionally. Prefer additive optional fields; consumers should ignore unknown fields where the format permits. Validate compatibility in CI, publish examples, set timeouts, and define pagination and rate limits. A synchronous API call couples caller availability and latency to the callee; avoid long workflows that span multiple services as one request.

## Worked example: order API

POST /orders accepts a client request and an idempotency key. The server validates address and item limits, creates an order in PENDING state, and returns 201 with a resource URL. A later GET returns the current state. Payment processing is a separate asynchronous step; the HTTP request does not wait indefinitely on a payment provider.

## Self-check quiz

1. Is REST synonymous with JSON over HTTP? No; it is an architectural style using a uniform interface and other constraints.
2. Why does a payment endpoint need idempotency? Network timeouts can cause safe retries after the first request already succeeded.
3. What is the distinction between 401 and 403? 401 means valid authentication is absent; 403 means the authenticated caller lacks permission.
4. Why are status codes part of the contract? Clients use them to make reliable retry, correction, and user-interface decisions.
5. When can SOAP be a sensible choice? When partner or regulatory ecosystems already rely on WSDL, XML schema, and WS-* contracts.

## Exercise

Design create-order and get-order endpoints. Specify method, path, success/error responses, retry behavior, and one compatibility rule.

### Sample answer

POST /orders takes a request body and Idempotency-Key; 201 returns order ID, status, and Location. Repeating the same key and payload returns the original result; reusing it with a different payload is rejected. GET /orders/{id} returns the order or a safe 404. Add optional response fields without changing existing field meanings, and publish a versioned OpenAPI contract.

## Further reading

- English: [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html), [OpenAPI Specification](https://spec.openapis.org/oas/latest.html), [Google API Design Guide](https://cloud.google.com/apis/design), [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines), [W3C SOAP 1.2](https://www.w3.org/TR/soap12/), [OWASP REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html)
- Persian: [Microsoft REST API guidelines, Persian overview](https://learn.microsoft.com/fa-ir/azure/architecture/best-practices/api-design), [DNTips](https://www.dntips.ir/)
