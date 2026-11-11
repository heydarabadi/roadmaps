# Chapter 10 — Network and Response Delivery Path

**Language:** English · [فارسی](../../../fa/backend-performance/10-network/README.md)

Network performance is more than link speed: round trips, dependency placement, connection setup, transfer size, and correct cache responses all affect user time. This chapter covers the four Network topics in the [Backend Performance roadmap](https://roadmap.sh/backend-performance-best-practices). **Sources reviewed: 2026-11-11; educational completion: 2026-11-11.** Terms and calculation methods are included in the lessons; external links are optional reading or technical references, not required to understand the exercises. All exercise numbers are hypothetical; no network experiment or infrastructure change was performed for this course.

## Prerequisites and study path

Basic familiarity with web requests and responses is enough. **RTT** is round-trip time, **bandwidth** is transfer capacity, and **throughput** is the observed rate; **TLS** secures the communication channel, and **DNS** maps a hostname to a connectable destination. Each term and protocol-version limit is explained in its lesson. TTFB can include server queueing and processing as well as network time; Ping alone does not establish API quality.

| Lesson | Diagnostic question | Learning outcome |
| --- | --- | --- |
| [10.1 Regions and latency](01-region-and-network-latency/README.md) | Which regional boundary is crossed repeatedly? | Place users, application, and data based on the real request path |
| [10.2 Connection reuse](02-connection-reuse/README.md) | How many DNS lookups, handshakes, and new connections occur? | Distinguish HTTP/1.1 persistence from multiplexing in HTTP/2 and HTTP/3 |
| [10.3 CDN](03-cdn-for-static-and-frequent-content/README.md) | Which responses can be shared and kept near users? | Edge delivery with correct keys, freshness, and personal-data protection |
| [10.4 Prefetch and Preload](04-prefetch-and-preload/README.md) | Is starting this work early necessary or likely to help? | Reduce discovery delay with a measured budget and waste accounting |

First establish a user-view baseline by region/ISP, route, and response size. Separate DNS, connection/TLS, TTFB, and body transfer, then compare application and dependency traces. Change one thing at a time and compare with representative traffic, errors, cost, and tail latency. Do not choose a region, protocol, or CDN from one average.

## Connecting scenario

In a **hypothetical** store, photos and fonts are public but orders are personal. Moving the API closer to users might add three round trips to a distant database. First analyze data placement and the checkout path; then use a client with a suitable lifetime and a bounded pool. Put versioned photos on a CDN and keep order responses out of shared caches. Preload only a font critical to the current page and prefetch one likely public resource for the next page under a limited budget. Success means correct responses, lower latency, and acceptable cost; more cache hits or fewer connections alone are not enough.

## Connections to other chapters

- [Cache layers](../01-caching/01-cache-layers/README.md) and [freshness and invalidation](../01-caching/04-invalidation-and-freshness/README.md): this chapter focuses on CDN paths; data ownership and invalidation still matter.
- [Response compression](../02-api-response/02-response-compression/README.md): weigh fewer bytes, CPU cost, and variation across compressed versions together.
- [Batching](../06-code-optimization/08-batching-and-round-trips/README.md): reuse reduces connection setup; batching targets call count.
- [Critical paths](../06-code-optimization/04-critical-paths/README.md): count only round trips required on the response chain.
- [Monitoring](../07-monitoring-and-logging/README.md): break down timings and diagnose a slow region or dependency.

## Chapter-end checklist

- [ ] RTT, TTFB, body time, and queue/processing are measured with clear boundaries.
- [ ] User, API, and dependency locations and cross-region transfer costs are known.
- [ ] HTTP version on each hop and pool/stream limits are understood.
- [ ] Personal responses, cache keys, TTL, and CDN invalidation have explicit rules.
- [ ] Prefetch has a likelihood of use, byte budget, and behavior under saturation.
- [ ] Changes are checked for p99, errors, traffic, and correctness.

**Navigation:** [Package index](../README.md) · [Previous chapter: Performance Testing](../09-performance-testing/README.md) · [Start with lesson 1](01-region-and-network-latency/README.md)
