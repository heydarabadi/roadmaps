# HTTP and HTTPS

## Learning goals

- Explain HTTP requests, responses, methods, status codes, headers, caching, and connection versions.
- Describe TLS's role in HTTPS and the limits of encryption.
- Design secure and observable communication between clients and services.

## HTTP contract

An HTTP request contains a method, target, headers, and optional body; a response contains a status code, headers, and optional body. HTTP semantics define safe and idempotent methods, caching controls, content negotiation, and status meanings. HTTP/1.1 commonly uses persistent connections, HTTP/2 multiplexes streams over a connection, and HTTP/3 maps HTTP semantics over QUIC. These versions change transport behavior but do not replace API design or authorization.

Use Cache-Control deliberately. Public static assets can use long-lived immutable caching with versioned filenames. Private or sensitive responses need directives that prevent unsafe shared caching. ETags and conditional requests can reduce transfer, but must reflect the representation and authorization context correctly.

## HTTPS and TLS

HTTPS is HTTP protected by TLS. TLS encrypts traffic in transit, helps detect tampering, and authenticates the server through certificate validation. It does not prove the application itself is trustworthy, protect data after it reaches a compromised endpoint, or provide authorization. Avoid disabling certificate verification. Manage certificate renewal, key custody, protocol versions, and secure redirects.

Terminate TLS at a trusted edge only when the network path from edge to service is protected and service identity is validated. Forwarded headers are trustworthy only when untrusted clients cannot spoof them and proxies overwrite or sanitize them. Do not log bearer tokens, cookies, passwords, or unnecessary personal data.

## Failure and resilience

Set timeouts for connection and response phases. Retry only when the operation is safe or idempotent and the failure is transient. Apply exponential backoff with jitter and an overall deadline to avoid retry storms. Make observability useful through request IDs, trace context, status distribution, latency percentiles, and carefully redacted logs.

## Worked example

A browser sends POST /payments with HTTPS and an idempotency key. The edge enforces a current TLS configuration, strips spoofed forwarding headers, and routes the request. The application authenticates the caller, authorizes the action, validates the body, and records a safe audit event. TLS protects the path; the application still needs identity, authorization, and replay protection.

## Self-check quiz

1. What does HTTPS protect? Data in transit confidentiality and integrity, plus server authentication when certificate validation succeeds.
2. Does TLS authorize a user to refund an order? No; authorization is an application policy decision.
3. Why should retries have a total deadline? To bound resource use and prevent unending work or cascading overload.
4. What does a cache validator such as ETag support? Conditional requests that can avoid transferring an unchanged representation.
5. Why sanitize forwarded headers? A direct client could spoof proxy metadata such as source IP or original scheme.

## Exercise

Set transport and application safeguards for a public order API behind a reverse proxy. Include TLS, headers, logging, timeouts, retries, and privacy-aware caching.

### Sample answer

Use maintained TLS at the edge, validate upstream identity, redirect or reject insecure traffic, and sanitize forwarding headers. Set bounded connection/response deadlines, propagate trace IDs, redact credentials and payment data, and disable shared caching for private order responses. Retry idempotent reads with backoff; retry order creation only with an idempotency key and a bounded total deadline.

## Further reading

- Industry deployment reference: [Cloudflare HTTP/3 documentation](https://developers.cloudflare.com/speed/optimization/protocol/http3/) describes enabling HTTP/3 at a large edge network.
- English: [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html), [RFC 9111: HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111.html), [RFC 8446: TLS 1.3](https://www.rfc-editor.org/rfc/rfc8446.html), [MDN: HTTP overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview), [OWASP Transport Layer Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Transport_Layer_Security_Cheat_Sheet.html), [Let's Encrypt documentation](https://letsencrypt.org/docs/)
- Persian: [MDN HTTP فارسی](https://developer.mozilla.org/fa/docs/Web/HTTP), [OWASP Persian project resources](https://owasp.org/)
