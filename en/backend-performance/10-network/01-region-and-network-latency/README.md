# 10.1 — Region Selection and Network Latency

**Language:** English · [فارسی](../../../../fa/backend-performance/10-network/01-region-and-network-latency/README.md)

**Learning goal:** Separate RTT from link capacity and server time, calculate dependency paths, and evaluate application/data placement against the actual user distribution. Prerequisites: HTTP and traces. Sources reviewed: **2026-11-11**; numbers are educational and have not been run.

## Mental model and method

A request travels from the user to the API and then to a database, cache, or another service. Geographic proximity can reduce propagation time, but routing, peering, congestion, and queues also matter. The nearest region on a map is not necessarily the best network path. RTT is not one-way time; without assuming symmetry, dividing it by two does not yield a precise one-way measurement.

| Measurement | What it tells you | Limitation |
| --- | --- | --- |
| Path RTT | A round trip under sampled conditions | Ping/ICMP may not represent HTTP behavior |
| DNS/Connect/TLS | Discovery and connection-setup cost | A warm connection does not repeat this for every request |
| User-observed TTFB | Time until the first response byte | Network, queues, and processing can be combined |
| Body time and throughput | Cost of delivering a response body | Loss, capacity, and slow consumers matter |
| Dependency trace | Serial hops and downstream waiting | Check instrumentation boundaries and time outside the trace |

1. Identify user shares, ISP/region, and sensitive routes. 2. Sample several windows, including peak periods and disruptions. 3. Draw the API, database, and cross-region calls on the response path. 4. Compare co-location, fewer calls, and permitted caching before replicating globally. 5. With limited traffic, measure p95/p99, errors, and cost; do not average regional percentiles and call the result an overall p95.

## Fundamentals: what contributes to latency?

A simple response path can be decomposed as follows:

```text
user
  -> [DNS, if needed]
  -> [TCP/TLS setup, if a new connection is needed]
  -> network to API
  -> API queue + processing
  -> serial calls to DB/cache/other services
  -> response transfer to user
```

Bracketed steps may not recur with a warm connection or cached DNS. **Propagation** is signal travel time along the path; **queueing** is waiting behind other work; **processing** is application/database work; **serialization** is the time to convert and send bytes. Dependent branches add their times along the critical path. For two truly independent branches started concurrently, completion time is approximately the slower branch, not their full sum.

RTT and bandwidth describe different problems. High RTT creates round-trip cost for small serial calls. Limited bandwidth increases transmission time for a large body. A rough transfer estimate is `body_bytes / effective_bytes_per_second`; for example, 512 KiB at an effective 10 MiB/s takes about 50 ms, apart from startup delay and network waiting. Increasing bandwidth therefore does not necessarily remove a serial database call.

Even before congestion, distance creates an approximate floor: signals travel through fiber much more slowly than through a vacuum, and cable routes are longer than straight lines. Shortening the path by hundreds or thousands of kilometers can affect RTT. This is only a conceptual physical lower bound; routes, equipment, queues, peering, and the return path determine the actual number. Measure “same region”; do not infer it from a map.

## Worked example: nearby API, distant database

The **hypothetical** model uses a warm connection, small body, and three serial DB calls. Total processing is fixed at 20 ms; there are no queues, handshakes, or overlaps:

```text
Layout A: user -> API RTT 80 ms; API -> DB RTT 2 ms
response = 80 + 3*2 + 20 = 106 ms

Layout B: user -> API RTT 20 ms; API -> DB RTT 70 ms
response = 20 + 3*70 + 20 = 250 ms
```

In this model, moving only the API closer makes the response 144 ms slower; the distant database is visited three times. This simple sum is not an exact prediction of the Internet. If dependencies are independent and overlap, model them differently using the [critical path](../../06-code-optimization/04-critical-paths/README.en.md). A large response also adds transfer time; 1 MiB at a fixed effective rate of 2 MiB/s needs about 0.5 seconds for the body alone, apart from startup wait.

**How to read the calculation:** Layout A has 80 ms of user-network time, `3×2=6 ms` for the DB round trips, and 20 ms of processing, totaling `106 ms`. Layout B spends 20 ms on the user path, but the DB takes `3×70=210 ms`; adding 20 ms of processing gives `250 ms`. The 60 ms saved by moving closer to the user is smaller than the extra 204 ms from three DB calls, so user/API location alone is not a region-selection criterion.

## Use and trade-offs

For a concentrated user base, co-locating application and data is often worth evaluating. Global users may need an edge, local reads, or multiple regions, with costs for replication, staleness, operations, and failover. Do not replicate data only to reduce RTT; define data-residency, permission, consistency, and recovery requirements. Cross-region calls and egress can also cost money. A regional failure must not route requests to unhealthy nodes or cause a sudden flood to the remaining destination.

## Exercise and expected result

In Layout B, move the DB to the same region so its RTT is 2 ms; then add a serial payment service with 90 ms RTT. **Expected:** the first model is `20+6+20=46 ms`, and with payment it is `136 ms`. Identify the new bottleneck. For a real decision, compare at least two user groups and two load windows; the exercise result is not a service guarantee.

**Exercise solution:** After moving the DB, the three database calls total `3×2=6 ms`; with 20 ms for the user network and 20 ms of processing, the result is `46 ms`. The serial payment call adds 90 ms to the critical path, so `46+90=136 ms`. Payment is now the largest component; further DB RTT reduction is less valuable than measuring or reducing payment wait. If payment and DB were truly independent and started concurrently, we would model the 90 ms in a parallel branch instead of adding it after the DB.

## Public evidence and its limits

The **June 9, 2026** report [Discord Voice at the Edge](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge) shows that greater geographic coverage alone was not enough: call routing and application/infrastructure scheduling problems also affected the result. This experience concerns real-time media over UDP and a specific infrastructure; its numbers are not targets for our HTTP API. The database scenario above is hypothetical and independent of that report.

## Failures, symptoms, and checklist

Poor TTFB for one ISP, cross-region calls in traces, higher egress, and worse tail latency at peak are investigation paths. A healthy average can hide a small group of distant users; a test from the author’s laptop does not replace the user distribution.

- [ ] User, API, database, and serial dependencies have known locations and RTTs.
- [ ] Cold/warm connections and small/large responses are examined separately.
- [ ] Peak samples and region/ISP breakdowns are recorded alongside cost.
- [ ] Consistency, data location, failover, and replacement-destination capacity are defined.
- [ ] User-facing metrics are compared with internal traces and time outside the trace.

## Self-check

1. Is RTT the same as one-way time?
2. Why did the closer API make the example slower?
3. Why does more bandwidth not necessarily speed up three small serial calls?
4. Does a good Ping prove good TTFB?
5. What obligations come with replicating data across regions?
6. Why should we trace again after co-locating the database?

### Answers with reasoning

1. No. It is round-trip time, and the two directions need not have the same path or delay.
2. A 60 ms reduction on the user side was outweighed by `3*(70-2)=204 ms` of additional DB RTT.
3. For a small message, round-trip waiting can dominate; more byte capacity does not remove serial dependencies.
4. No. Protocol, queues, handshake, and API processing also matter, and ICMP routing/priority may differ.
5. Replication, freshness, write conflicts/ownership, cost, and recovery. Local reads need a correctness contract.
6. The bottleneck may have moved to another dependency, such as payment; take a new baseline after the change.

## Further reading

- **Persian:** [Server location impact — Azarsys](https://azarsys.com/blog/server-location-impact-on-site-speed/): introduction to RTT, routing, and peering. It is a hosting-company article, not a purchase recommendation or region guarantee.
- **English:** [Understanding latency — MDN](https://developer.mozilla.org/en-US/docs/Web/Performance/Guides/Understanding_latency): separates network and browser time and explains timing; it focuses mainly on the client web experience.
- **English:** [Round-trip time (RTT) — Cloudflare Learning Center](https://www.cloudflare.com/learning/cdn/glossary/round-trip-time-rtt/): defines RTT and path variability; it is an estimate, not a destination guarantee.
- **English, official:** [Latency-based routing — Amazon Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-latency.html): an example of multi-region routing and provider measurement limits; vendor-specific.
- **English, official:** [Azure region selection](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-setup-guide/regions): region-selection checklist for latency, cost, availability, and data location; Azure-specific.
- **English, firsthand:** [Discord Voice at the Edge](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge): evidence about geography, routing, and latency diagnosis; specific to its reported workload.
- **English, standard:** [HTTP Semantics, RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html): terminology for Client, Proxy, and Origin to clarify path boundaries; it does not provide a latency formula.

**Navigation:** [Chapter index](../README.en.md) · [Package index](../../README.en.md) · [Next: Connection reuse](../02-connection-reuse/README.en.md)

**Related:** [Replication](../../04-databases/10-replication/README.en.md) · [Batching](../../06-code-optimization/08-batching-and-round-trips/README.en.md)
