# DNS and Service Naming

[فارسی](../../../03-network-edge-communication/10-dns/README.md)

## Learning goals

- Trace a DNS lookup from a client cache to an authoritative answer.
- Recognize common DNS record types and what TTL does.
- Explain why DNS changes and failover are not instantaneous.
- Distinguish DNS-based routing from request-level load balancing.

## Central idea

DNS maps names to network records and participates in routing through cached answers. Changing a record does not immediately replace every answer already held by resolvers or clients.

## Concept map

Application hostname → local cache → recursive resolver → DNS hierarchy → authoritative record → client connection.

## Detailed lesson

### Follow a lookup

A user asks for api.example.com. The browser or operating system checks its local cache. If no valid answer exists, it asks a recursive resolver. That resolver may already have a cached response; otherwise, it follows the DNS hierarchy: a root server points it toward the top-level domain, a .com server identifies authoritative name servers for the domain, and an authoritative server returns the record.

Responses are cached along the way, so every client request does not go to a root server. DNS returns records; it does not proxy an HTTP connection. After learning an IP address, the client still establishes its own TCP or QUIC connection and then TLS. A DNS answer does not guarantee the destination is healthy, authorized, or the nearest possible server.

### Common records

- **A** maps a hostname to an IPv4 address; **AAAA** maps it to IPv6.
- **CNAME** aliases one name to another canonical name. Zone-apex alias behavior is provider-specific because the DNS root of a zone has record constraints.
- **MX** identifies mail exchangers; **TXT** stores text used for verification and policy; **NS** identifies authoritative name servers.
- **SRV** can publish a service target, port, and priority for protocols that use it.

A zone update may be visible immediately from its authoritative server, while recursive resolvers keep the previous value until its TTL expires. Negative caching may also preserve a “name does not exist” response temporarily. Creating a record immediately after a negative lookup may therefore still appear unsuccessful.

### TTL and controlled cutover

TTL is the suggested cache lifetime. It is not an invalidate button for every client. Applications, resolvers, and operating systems may have their own caching behavior.

For an address migration, lower the TTL ahead of time, prepare the new destination, validate health and TLS, then change the record. Monitor traffic through the transition. After the old value is no longer in use, restore an operationally reasonable TTL.

### GeoDNS and load balancing

GeoDNS can return a regional address based on resolver location or policy. The resolver's location may not match the end user's location; VPNs, public resolvers, and cached answers affect the result.

DNS round-robin also does not provide precise request distribution. Clients cache answers and existing connections continue using their selected address. A network- or HTTP-layer load balancer is better suited to health-aware routing and per-request balancing.

### Security and troubleshooting

DNSSEC validates the origin and integrity of signed DNS data. It does not encrypt the content of later application traffic or replace access control.

For troubleshooting, compare the authoritative answer with recursive answers from several networks. Check record type, TTL, negative caching, and whether the client has an internal cache. Private or split-horizon DNS can help with internal naming, but avoid publishing internal addresses to public zones.

## Worked example

For an API cutover, lower the TTL in advance, confirm the new target can serve traffic, then change the record. Keep the old endpoint available during the transition. Remember that the lowered TTL does not erase cache entries already obtained under the previous TTL.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| DNS regional routing | Coarse regional steering and failover are enough | Resolver geography and cache delay reduce precision |
| DNS round-robin | Simple distribution among equivalent endpoints is acceptable | Caching prevents exact balance and instant removal |
| HTTP load balancer | Health-aware, per-request routing is needed | Adds a network component and possible shared failure domain |
| Short TTL | Endpoint changes are relatively frequent | More resolver queries and still no guarantee of immediate change |

## Common pitfalls

- Expecting DNS failover to be immediate.
- Forgetting negative caching.
- Assuming a resolver's location equals the user's location.
- Treating DNS records as a health check or security control.
- Publishing private names or addresses into a public zone without review.

## Short quiz

1. What does a CNAME record do?
2. Why can a DNS change take time to reach users?
3. What IP version does an AAAA record represent?
4. Why is DNS round-robin not equivalent to a per-request load balancer?

### Answer key

1. It aliases one name to another canonical name.
2. Recursive resolvers and clients can keep old positive or negative answers until their cache policy allows them to refresh.
3. IPv6; A records represent IPv4.
4. Clients cache answers and retain existing connections, so DNS cannot rebalance each request or remove a target immediately.

## Exercise

Plan a store API migration to a new regional endpoint. Choose record types and TTL, define the validation window, identify which caches may retain the old answer, and write a rollback step. Include how you will tell whether users are still reaching the old endpoint.

## Summary

DNS is a cached naming system, not a real-time connection switch. Understand the lookup path and TTL, and use a load balancer when precise health-aware request routing is required.

## Further reading

- [RFC 1034: Domain Names — Concepts and Facilities](https://www.rfc-editor.org/rfc/rfc1034) — DNS hierarchy and concepts.
- [RFC 1035: Domain Names — Implementation and Specification](https://www.rfc-editor.org/rfc/rfc1035) — record and message details.
- [Cloudflare Learning: What is DNS?](https://www.cloudflare.com/learning/dns/what-is-dns/) — accessible DNS explanation.
- [Cloudflare: DNS cache memory optimization](https://blog.cloudflare.com/dns-cache-memory-optimization-1111/) — a published DNS cache engineering case.
- [AWS: Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html) — contrasting DNS and load-balancer roles.
