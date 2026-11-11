# 10.2 — Connection Reuse Across HTTP Versions

**Language:** English · [فارسی](README.md)

**Learning goal:** Separate connection-establishment cost from per-request work, design a bounded client/pool with an appropriate lifetime, and avoid confusing HTTP/1.1 persistence with multiplexing. Prerequisites: TCP, TLS, and HTTP. Sources reviewed: **2026-11-11**; pseudocode and calculations are educational.

## Mental model and protocol differences

Reuse means sending multiple requests over an existing reusable connection. DNS, connection establishment, and TLS may cost time on a cold connection; the exact number of RTTs depends on protocol, resumption, and network. TCP keepalive, a header named Keep-Alive, and an HTTP persistent connection are different concepts.

| Version | Reuse behavior | Important limitation |
| --- | --- | --- |
| HTTP/1.1 | Persistence is the default unless connection closure is signaled or occurs | Without pipelining, one active exchange per connection; a pool can hold multiple connections |
| HTTP/2 | Multiple concurrent streams on one TCP connection | Stream/flow-control limits and TCP loss effects remain |
| HTTP/3 | Multiple streams on a QUIC connection | Capacity, congestion, stream limits, and path support still matter |

[RFC 9112 §9.3](https://www.rfc-editor.org/rfc/rfc9112.html#section-9.3) defines persistence for HTTP/1.1; adding `Connection: keep-alive` is not normally required to enable it. **In HTTP/2 and HTTP/3, connection-specific fields such as `Connection`, `Keep-Alive`, `Proxy-Connection`, `Transfer-Encoding`, and `Upgrade` are prohibited.** Reuse is configured in the transport/client. The sole exception in both protocols is the request field `TE` with the value `trailers` only (`TE: trailers`); it is not allowed in a response or with a different value. [RFC 9113 §8.2.2](https://www.rfc-editor.org/rfc/rfc9113.html#section-8.2.2) and [RFC 9114 §4.2](https://www.rfc-editor.org/rfc/rfc9114.html#section-4.2) specify the rule and exception. The client-facing version and the origin-facing version behind a proxy may differ; inspect each hop separately.

### Cold and warm connection lifecycle

On a cold connection, the client must resolve the destination, establish the transport, and, when needed, perform TLS and version negotiation; then requests and responses are exchanged. The number of round trips depends on protocol version, resumption, and network, so there is no fixed value for all connections. On a warm connection, setup is not repeated and a new exchange uses the existing transport. Reuse amortizes setup cost across requests; it does not automatically remove response size, application queries, or API execution time.

HTTP/1.1 generally needs a separate connection for each active exchange, so clients use pools with multiple connections. HTTP/2 and HTTP/3 can carry multiple streams on one connection, but stream limits, flow control, server capacity, and network limits remain. “One connection” does not mean “unlimited capacity.”

## Method and worked example

Reuse the client and transport according to the library documentation. A new wrapper does not necessarily mean a new transport, but creating an independent pool for every request can defeat reuse. Fully consume the response and release its resources; an unfinished body can prevent reuse in HTTP/1.1. On cancellation, close the response/stream using the library’s safe API; do not drain an unbounded body solely to preserve reuse.

Little’s Law gives a first approximation for pool sizing: if the steady arrival rate is `λ` requests per second and connection occupancy time is `W` seconds, average concurrent requests are `L≈λ×W`. For example, `120 requests/s × 0.05 s = 6` active exchanges on average. This is **not the final pool size**: bursts, p95/p99, acquire wait, replica count, and downstream capacity matter. A very large pool can increase DB or origin concurrency and make a problem worse; choose the final limit using measurements and the destination’s capacity.

```text
# Create once per configured destination and policy, not per incoming request:
client = shared_client(bounded_pool, bounded_pending_queue, idle_policy)

on_request(deadline):
    response = client.send(request, deadline, cancellation)
    try:
        return read_bounded_response(response)
    finally:
        response.close_according_to_client_contract()
```

The **hypothetical** model has ten serial requests: cold connection setup takes 60 ms, and each exchange on an established connection takes 25 ms. Without reuse: `10*(60+25)=850 ms`; with one persistent connection: `60+10*25=310 ms`. The modeled saving is 540 ms; it is not a fixed RTT count or a guaranteed TLS/HTTP/2 benefit. Multiplexing independent requests can add overlap, but server capacity and queues must be modeled again. Reuse does not automatically reduce query count or response bytes.

## Use, cost, and exercise

Reuse helps with repeated calls to a fixed destination. An idle connection still consumes file descriptors, memory, and state. Bound connections, acquire queues, deadlines, and, for HTTP/2/3, stream counts. An idle timeout that conflicts with a load balancer can cause resets. A very long-lived connection may reflect DNS changes or destination movement late; refresh/lifetime policy depends on the client. A dropped connection does not prove a write did not happen; retries must be [safe and bounded](../../06-code-optimization/07-timeouts-and-retries/README.en.md).

**Exercise:** In the model above, change setup time to 120 ms and calculate the before/after times and number of new connections. Then assume the peer closes the connection after request five. **Expected:** without reuse, 1,450 ms; with one connection, 370 ms; with one additional reconnect, 490 ms. This assumes the failed request/retry adds no other cost. In your chosen tool, inspect connection count, acquire wait, TLS, and p99 separately; this lesson did not run an experiment.

## Operational evidence and limits

The [official MDN guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Connection_management_in_HTTP_1.x) documents short-lived/persistent connection models and the difference with multiplexing. It is operational documentation, not a company benchmark report. The references here do not include an independent production study using this same ten-request model; the numbers are hypothetical. Read header compatibility in the RFCs and the [Keep-Alive reference](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Keep-Alive).

## Data-driven troubleshooting path

Capture one trace from a cold request and one from warm requests to the same destination, then follow this order:

| Signal | Possibility | Next step |
| --- | --- | --- |
| A new connection is created for nearly every request | Client/transport is constructed per request, or response handling prevents reuse | Inspect client lifetime and body consumption/closure |
| `connect/TLS` is low but latency remains high | Cost is in server, DB, payload, or network after connection setup | Follow the trace to API/dependency boundaries; reuse does not fix these |
| Acquire wait and pool queue rise | Pool too small, destination slow, or arrivals excessive | Compare rate and occupancy time with downstream limits |
| Resets increase after idle time | Peer idle timeouts conflict or a stale connection is used | Inspect idle/lifetime policy and the library’s safe retry behavior |
| One HTTP/2 connection has rising latency | Stream/server capacity is limited or TCP/path is the bottleneck | Inspect active streams, flow control, server queue, and loss |

Measurements belong to a specific hop. If the client connects to a CDN while the CDN creates a separate connection to the origin, client-side reuse does not establish origin-side behavior.

## Failure modes and checklist

More new connections/TLS per call, response leaks, pool saturation, resets after idle periods, and many reconnects during failover are symptoms to investigate. Increasing the pool without checking destination capacity can worsen overload.

- [ ] HTTP version and reuse are observed on every hop.
- [ ] Client/transport lifetime is clear; pool and queue are bounded.
- [ ] Responses are released according to contract on success, failure, and cancellation.
- [ ] Idle/lifetime, DNS, and shutdown are coordinated; reconnects do not create a surge.
- [ ] Connection count, reuse, acquire wait, errors, and active streams are monitored.
- [ ] HTTP/2/3 forbid connection-specific fields; the only exception is `TE: trailers` in a request, not a response or another TE value.

## Self-check

1. Does HTTP/1.1 usually need a Keep-Alive header for persistence?
2. What is the difference between reuse and multiplexing?
3. Why is adding `Connection` to an HTTP/2 response wrong?
4. Why can an unread response disrupt a pool?
5. Does reuse automatically solve N+1?
6. If a connection drops after a write, is an unrestricted retry safe?

### Answers with reasoning

1. No. Persistence is the default; peer policy and connection closure still determine the outcome.
2. Reuse sends multiple requests over an existing connection; multiplexing carries exchanges on multiple streams at the same time.
3. A connection-specific field is prohibited in that protocol; the protocol manages the connection itself.
4. Resources/connection capacity can remain occupied. In HTTP/1.1, body consumption matters for reuse, and the client library defines how to release it.
5. No. Connection setup is cheaper, but the N requests still exist; fix the application fetch plan or batch them.
6. No. The write may have been applied. Idempotency or checking the result and a retry budget are needed.

## Further reading

- **Persian:** [Networking essentials for system design](https://learn.mhkarami97.ir/posts/networking_essentials/): introduction to handshake, reuse, and multiplexing; it is a broad simplified overview, not a normative reference for headers or versions.
- **English:** [MDN Connection Management](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Connection_management_in_HTTP_1.x): HTTP/1.x models and connection cost.
- **English, standard:** [RFC 9113 — HTTP/2, §9](https://www.rfc-editor.org/rfc/rfc9113.html#section-9): HTTP/2 connection lifecycle and reuse.
- **English, standard:** [RFC 9114 — HTTP/3, §4](https://www.rfc-editor.org/rfc/rfc9114.html#section-4): HTTP/3 connection setup/management and prohibited connection fields.
- **English:** [Overview of HTTP — MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Overview): HTTP exchange steps and difference between reuse and a new connection.
- **English, standard:** [RFC 9110 §7.6.1](https://www.rfc-editor.org/rfc/rfc9110.html#section-7.6.1): connection-specific meaning and forwarding; HTTP/2/3-specific rules are in the RFCs above.

**Navigation:** [Chapter index](../README.en.md) · [Package index](../../README.en.md) · [Previous: Regions](../01-region-and-network-latency/README.en.md) · [Next: CDN](../03-cdn-for-static-and-frequent-content/README.en.md)

**Related:** [Database connection pools](../../04-databases/01-connection-pooling/README.en.md) · [Batching](../../06-code-optimization/08-batching-and-round-trips/README.en.md)
