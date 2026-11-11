# OSI and TCP/IP Networking Models

## Learning goals

- Use layered models to reason about addressing, routing, transport, and application protocols.
- Trace a request through DNS, IP routing, TCP or QUIC, TLS, and HTTP.
- Diagnose where a network failure occurs without confusing a model with the deployed stack.

## Layering as a reasoning tool

The OSI model defines seven conceptual layers: physical, data link, network, transport, session, presentation, and application. The Internet protocol suite is commonly explained with link, internet, transport, and application layers. These are teaching and troubleshooting models; real protocols do not always fit neatly into one box.

At the link layer, Ethernet or Wi-Fi moves frames on a local network. IP addresses and routers deliver packets between networks. TCP provides an ordered byte stream with retransmission and congestion control; UDP provides datagrams with fewer built-in guarantees. QUIC runs over UDP and supports secure multiplexed transport for HTTP/3. DNS resolves names through a hierarchy of caches and authoritative servers. TLS protects application communication and authenticates the server when configured correctly.

An HTTP request can fail before it reaches the application: DNS resolution, routing, firewall rules, TCP/QUIC establishment, TLS negotiation, proxy behavior, or service health may be responsible. Observe each step with resolver checks, connection tests, certificate inspection, packet or proxy telemetry, and application traces. Avoid opening broad network access as a diagnostic shortcut.

## Addressing and ports

An IP address identifies a network interface or route destination; a port identifies a transport endpoint on a host. NAT and proxies can change the visible source address. Security policy should account for the actual trust boundary and authenticated identity, not assume an IP alone proves who made a request.

## Worked example: request to a storefront

The browser resolves shop.example through DNS, connects to an edge endpoint, negotiates TLS, sends HTTP, and traverses a load balancer to an application. The application may make separate connections to cache and database. A timeout should be localized: name resolution, connection establishment, TLS, edge queueing, app processing, or dependency latency.

## Self-check quiz

1. What does TCP provide that IP does not? An ordered byte stream with retransmission and congestion behavior.
2. Does DNS always query an authoritative server for every lookup? No; recursive resolvers and clients cache answers according to TTL and policy.
3. Does a port identify a person or service identity securely? No; it identifies a transport endpoint, not authenticated identity.
4. Why is the OSI model still useful if implementations do not match it exactly? It gives teams a shared vocabulary for locating responsibilities and failures.
5. What is the benefit of tracing network stages separately? It narrows fault location and reveals latency contribution at each boundary.

## Exercise

Draw the path from a mobile client to an API and database. Label DNS, transport, TLS, HTTP, proxy/load balancer, and one observable signal at each boundary.

### Sample answer

The client resolves the API hostname and connects to the CDN or gateway, where TLS is terminated or passed through. The gateway routes HTTP to the service, which connects to the database over a private network. Track DNS errors and duration, connection/TLS failures, gateway status and latency, service trace spans, and database connection/query metrics.

## Further reading

- English: [RFC 1122: Internet host requirements](https://www.rfc-editor.org/rfc/rfc1122.html), [RFC 9293: TCP](https://www.rfc-editor.org/rfc/rfc9293.html), [RFC 9000: QUIC](https://www.rfc-editor.org/rfc/rfc9000.html), [Cloudflare: What is DNS?](https://www.cloudflare.com/learning/dns/what-is-dns/), [Cloudflare: What is the OSI model?](https://www.cloudflare.com/learning/ddos/glossary/open-systems-interconnection-model-osi/), [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- Persian: [MDN فارسی: شبکه و اینترنت](https://developer.mozilla.org/fa/docs/Learn/Common_questions/Web_mechanics/How_does_the_Internet_work), [DNTips](https://www.dntips.ir/)
