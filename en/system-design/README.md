# System Design: Complete Study Path

This English companion is an original, self-contained course organized around the topics in the [roadmap.sh System Design roadmap](https://roadmap.sh/system-design). It explains the concepts in its own words, with worked examples, trade-offs, failure scenarios, quizzes, answer keys, exercises, and references. It is not a line-by-line translation of the roadmap or of any linked article.

> The interactive roadmap and its official [PDF](https://roadmap.sh/pdfs/roadmaps/system-design.pdf) were checked on 2026-11-10. The source roadmap may change over time. This study guide uses its topic map as a scope reference and adds instructional detail.

## How to study

1. Read the prerequisites and glossary first. The course assumes basic programming, HTTP, and SQL familiarity, but it introduces the distributed-systems terms used in its examples.
2. Follow Chapters 01–10 in order. Each topic has its own README with a lesson, examples, design choices, pitfalls, quiz and answer key, practice exercise, and topic-specific readings.
3. Attempt each quiz before opening its answer key. Write down the assumptions behind your answer.
4. Use the capstone project to combine the ideas into a complete design, then revisit the chapters that explain its weakest decisions.
5. Treat external sources as deeper reading and as evidence for specific technical behavior. The material here is designed to teach the core course; vendors’ product details and standards can evolve.

## Course map

- [Prerequisites, glossary, and core equations](00-prerequisites-and-glossary.md)
- [01 — System design foundations](01-foundations/README.md)
- [02 — Fault tolerance and replication](02-fault-tolerance-and-replication/README.md)
- [03 — Networking, edge, and communication](03-network-edge-communication/README.md)
- [04 — Application architecture](04-application-architecture/README.md)
- [05 — Data and caching](05-data-and-caching/README.md)
- [06 — Asynchronous processing and messaging](06-async-and-messaging/README.md)
- [07 — Performance antipatterns](07-performance-antipatterns/README.md)
- [08 — Observability](08-observability/README.md)
- [09 — Cloud design patterns](09-cloud-design-patterns/README.md)
- [10 — Reliability and security](10-reliability-security/README.md)
- [Capstone — Checkout during a major sale](11-capstone-project/README.md)
- [Reference library: standards, official documentation, engineering articles, and case studies](sources.md)

## What this course covers

The topic map includes problem-solving and requirements, performance and scalability, latency and throughput, availability and consistency, consistency patterns, CAP, availability arithmetic, failover and replication, DNS/CDNs/load balancers and application protocols, microservices and service discovery, databases and caching, data-management patterns, background jobs and messaging, queues/streams/backpressure, idempotency, performance antipatterns, monitoring and alerting, cloud design/implementation/data/messaging patterns, and availability, high availability, resiliency, and security patterns.

## Eight-week study plan

| Week | Chapters | Suggested deliverable |
| --- | --- | --- |
| 1 | Foundations | Load estimates and initial SLOs for an order service |
| 2 | Fault tolerance and replication | RTO/RPO, failover policy, and a replication diagram |
| 3 | Networking | End-to-end request path and API contract |
| 4 | Application architecture | Modular monolith versus independently deployed services |
| 5 | Data and caching | Source of truth, read model, and freshness policy |
| 6 | Asynchronous processing | Queue, retry, dead-letter, and idempotency design |
| 7 | Performance and observability | SLI dashboard and a trace-based bottleneck analysis |
| 8 | Cloud patterns, reliability, and security | Architecture review with failure and threat scenarios |

## Language versions

- English: this folder (en/).
- Persian: [نسخهٔ فارسی](../../fa/system-design/README.md).

The Persian topic pages link to their English counterparts, and English pages link back to Persian.
