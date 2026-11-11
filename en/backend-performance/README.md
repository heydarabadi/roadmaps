[فارسی](../../fa/backend-performance/README.md) | **English**

# Backend Performance Learning Path

This course is for a developer who wants to find why a service is slow, choose a suitable change, and measure its effect. Its scope follows the user-provided [Backend Performance roadmap](https://roadmap.sh/backend-performance-best-practices) and its [best-practices checklist PDF](https://roadmap.sh/pdfs/best-practices/backend-performance.pdf). Ten chapters and 44 lessons turn that checklist into a study, practice, and review path. The requested folder spelling `Backend Performace` is preserved.

**Initial research: 2026-11-10; educational completion and checks of added references: 2026-11-11.** Research is curated: it gathers original explanations in Persian and relevant references, and does not claim to cover everything on the internet. Official sources and published engineering experience take priority over unsupported recommendations. Each lesson distinguishes documented evidence, teaching examples, and evidence limits.

**Language editions:** This is the full English course index. Every chapter and lesson also has a sibling `README.en.md` in its folder. Both editions teach the topic in-page, including its concepts, examples, exercises, and answer key. External links are optional further reading and technical references, not prerequisites for understanding the lessons.

**Source-access note:** The live roadmap page exposes only the title and a short description. The checklist text was read from the indexed PDF in a search result, but direct retrieval of that PDF returned HTTP 404 during the original review. The original link is retained for provenance; the coverage table below was checked against the indexed text and does not reproduce the source wholesale.

This pack focuses on **Backend Performance**. The [System Design roadmap](https://roadmap.sh/system-design) is related further study for architecture decisions; its separate topics are outside this course. Examples are language-, framework-, and vendor-independent where possible. Mentioning a tool does not make it mandatory.

## Prerequisites and where to start

Basic familiarity with HTTP requests and responses, an API, a relational database and SQL, running a program, and reading logs is enough. You do not need to be an expert in a cloud service or a particular monitoring tool. If a term is unfamiliar, use the [glossary and concept index](#glossary), then return to the linked lesson.

Follow the numbered chapter order. Before the first exercise, briefly review [measurement and signals](07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) and [performance baselines and testing](09-performance-testing/01-load-testing-and-regression-benchmarks/README.md) so you know how to record a result. This preview does not replace studying those chapters in sequence.

## Study path and ten chapters

| Step | Chapter | Lessons | Guiding question |
| --- | --- | ---: | --- |
| 1 | [Caching](01-caching/README.md) | 4 | What should we keep, where, and how do we manage freshness? |
| 2 | [API response](02-api-response/README.md) | 4 | What data and work does this response really need? |
| 3 | [Asynchronism](03-asynchronism/README.md) | 2 | Which work can be moved to the background with a clear contract? |
| 4 | [Databases](04-databases/README.md) | 12 | Where do connection, fetch, and query costs occur? |
| 5 | [Load balancing and scaling](05-load-balancing-and-scaling/README.md) | 2 | Which constraint and cost should guide capacity growth? |
| 6 | [Code optimization](06-code-optimization/README.md) | 8 | Which measured part of program execution affects the result? |
| 7 | [Monitoring and logging](07-monitoring-and-logging/README.md) | 3 | What evidence do we collect to understand service behavior? |
| 8 | [Security](08-security/README.md) | 4 | How should access and resource-consumption controls be designed and reviewed? |
| 9 | [Performance testing](09-performance-testing/README.md) | 1 | How do we evaluate behavior under load and change from a baseline? |
| 10 | [Network](10-network/README.md) | 4 | How much do distance, connections, and content delivery affect response time? |

In each chapter, read the chapter index and its shared scenario first, then study the lessons in order. Afterward, explain the chapter review checklist in your own words. When a decision appears at multiple layers, follow the related lesson: API pagination and database pagination, for example, are two views of the same request path.

## How to use lessons, exercises, and quizzes

1. Read the learning outcomes and mental model. Then write down one suitable use case and one unsuitable case.
2. Follow the worked example and record its assumptions. Do not report teaching numbers as measurements from a real system; use each lesson's evidence section for documented experience.
3. Do the small exercise in a learning environment. Record the workload, data size, configuration, before-and-after result, and side effects. If your observation differs from the lesson's expectation, revisit the assumptions and measurement method.
4. Answer each lesson's questions before opening the answer key. Topic quizzes contain 5–8 questions; reasoning matters more than memorizing the right option. Read the explanations and return to the relevant section for any missed answer.
5. For a final review, write a decision that can be acted on: “Given this workload and constraint, I choose this change because I observed this evidence; this is its cost and the condition that would make me revisit it.” Do not set one universal performance target for every service.

## Roadmap checklist traceability

The English section names follow the roadmap. The middle column summarizes the checklist scope, and the final column links to the specific lesson. Related details—such as connection-pool settings or ORM fetch strategies—are combined in one lesson. Additional teaching topics, including multi-level caching, stampede prevention, and load-test types, deepen the listed items without adding chapters outside Backend Performance.

| Roadmap section | Checklist coverage | Lesson |
| --- | --- | --- |
| Caching | HTTP, server, client, and CDN caches; distinguish cache location from policy | [1.1 Cache layers](01-caching/01-cache-layers/README.md) |
| Caching | Choose Cache-aside, Read-through, and Write-through for the application | [1.2 Cache patterns](01-caching/02-cache-patterns/README.md) |
| Caching | Combine cache layers and account for coordination cost; deepen the roadmap's layer topic | [1.3 Multi-level caching](01-caching/03-multi-level-caching/README.md) |
| Caching | Invalidation, consistency, stale content; freshness, TTL, and stampede prevention | [1.4 Invalidation and freshness](01-caching/04-invalidation-and-freshness/README.md) |
| Optimize API Response | Reasonable request/response body-size limits and data-size contracts | [2.1 Payload size](02-api-response/01-payload-size/README.md) |
| Optimize API Response | Compress responses and weigh compute cost against transfer size | [2.2 Response compression](02-api-response/02-response-compression/README.md) |
| Optimize API Response | Efficient pagination of large collections as an API contract | [2.3 API pagination](02-api-response/03-efficient-pagination/README.md) |
| Optimize API Response | Remove unnecessary server processing and expensive calculations | [2.4 Avoiding unnecessary server work](02-api-response/04-avoid-unnecessary-server-work/README.md) |
| Asynchronism | Move heavy work to a background job or queue | [3.1 Background jobs](03-asynchronism/01-background-jobs/README.md) |
| Asynchronism | Use a message broker for asynchronous service communication | [3.2 Message brokers](03-asynchronism/02-message-brokers/README.md) |
| Databases | Reuse connections; configure maximum connections, idle time, and reuse; prevent exhaustion | [4.1 Connection pooling](04-databases/01-connection-pooling/README.md) |
| Databases | Build and choose indexes to match query patterns | [4.2 Indexes](04-databases/02-indexes/README.md) |
| Databases | Review and tune ORM queries: lazy, eager, and batched fetching | [4.3 ORM fetch strategies](04-databases/03-orm-fetch-strategies/README.md) |
| Databases | Efficient query-side pagination and stable ordering | [4.4 Database pagination](04-databases/04-efficient-database-pagination/README.md) |
| Databases | Avoid `SELECT *`; fetch only required columns | [4.5 Selecting required columns](04-databases/05-select-only-needed-columns/README.md) |
| Databases | Consider denormalization for read-heavy workloads and fewer joins | [4.6 Denormalization](04-databases/06-denormalization-for-read-heavy-workloads/README.md) |
| Databases | Optimize joins and remove unnecessary table joins | [4.7 Join optimization](04-databases/07-join-optimization/README.md) |
| Databases | Clean unused data; perform routine maintenance, vacuum, index care, and query review | [4.8 Database maintenance](04-databases/08-database-maintenance/README.md) |
| Databases | Enable and monitor slow-query logging | [4.9 Slow-query logging](04-databases/09-slow-query-logging/README.md) |
| Databases | Replicate data for redundancy and read capacity; understand limitations | [4.10 Replication](04-databases/10-replication/README.md) |
| Databases | Distribute data with sharding when needed and account for its cost | [4.11 Sharding](04-databases/11-sharding/README.md) |
| Databases | Use profiling tools and the database's execution plan | [4.12 Database profiling](04-databases/12-database-profiling/README.md) |
| Load Balancing & Scaling | Choose horizontal or vertical scaling for the limiting constraint | [5.1 Horizontal and vertical scaling](05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md) |
| Load Balancing & Scaling | Distribute traffic among servers with load balancing | [5.2 Load balancing](05-load-balancing-and-scaling/02-load-balancing/README.md) |
| Code Optimization | Stream large request and response bodies | [6.1 Streaming](06-code-optimization/01-streaming-large-bodies/README.md) |
| Code Optimization | Profile code to find application bottlenecks | [6.2 Application profiling](06-code-optimization/02-application-profiling/README.md) |
| Code Optimization | Improve algorithms and data structures | [6.3 Algorithms and data structures](06-code-optimization/03-algorithms-and-data-structures/README.md) |
| Code Optimization | Identify and improve critical paths and frequently used endpoints | [6.4 Critical paths](06-code-optimization/04-critical-paths/README.md) |
| Code Optimization | Consider compiled languages such as Go and Rust for measured hot paths; assess language/runtime choice | [6.5 Language and runtime choices](06-code-optimization/05-language-and-runtime-choices/README.md) |
| Code Optimization | Consider SOA and microservices; split services only when needed | [6.6 Service decomposition](06-code-optimization/06-service-decomposition/README.md) |
| Code Optimization | Set appropriate connection timeouts and efficient retries for network failures | [6.7 Timeouts and retries](06-code-optimization/07-timeouts-and-retries/README.md) |
| Code Optimization | Batch similar requests to reduce overhead and round trips | [6.8 Batching and round trips](06-code-optimization/08-batching-and-round-trips/README.md) |
| Monitoring and Logging | Monitor and diagnose performance using events and metrics; deepen with traces and instrumentation | [7.1 Metrics, logs, and traces](07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) |
| Monitoring and Logging | Learn the toolchain; roadmap examples include Prometheus, Grafana, and the ELK Stack | [7.2 Monitoring toolchain](07-monitoring-and-logging/02-monitoring-toolchain/README.md) |
| Monitoring and Logging | Record events asynchronously and control logging overhead | [7.3 Asynchronous logging](07-monitoring-and-logging/03-asynchronous-logging/README.md) |
| Security | Keep and review dependencies and packages up to date | [8.1 Dependency hygiene](08-security/01-dependency-hygiene/README.md) |
| Security | Use suitable authentication and authorization to prevent unauthorized access | [8.2 Authentication and authorization](08-security/02-authentication-and-authorization/README.md) |
| Security | Throttle and rate-limit requests | [8.3 Request rate controls](08-security/03-throttling-and-rate-limiting/README.md) |
| Security | Periodically audit, review, and update security measures | [8.4 Security review and updates](08-security/04-security-review-and-updates/README.md) |
| Performance Testing | Test and benchmark regularly, find regressions, track improvement, and tune decisions; deepen with baselines and Load/Stress/Spike/Soak distinctions | [9.1 Load testing and performance regression](09-performance-testing/01-load-testing-and-regression-benchmarks/README.md) |
| Network | Reduce latency by assessing hosting location relative to users and service regions | [10.1 Region and network latency](10-network/01-region-and-network-latency/README.md) |
| Network | Reuse connections and HTTP keep-alive to reduce connection overhead | [10.2 Connection reuse](10-network/02-connection-reuse/README.md) |
| Network | Use a CDN for static and frequently requested content | [10.3 CDN content delivery](10-network/03-cdn-for-static-and-frequent-content/README.md) |
| Network | Prefetch or preload resources, data, or dependencies likely to be needed next | [10.4 Prefetch and preload](10-network/04-prefetch-and-preload/README.md) |

## Glossary and concept index

These brief definitions help locate a lesson. The detailed explanations, limits, and examples live on the topic pages.

| Term | Practical meaning in this course | Continue with |
| --- | --- | --- |
| Latency / response time | Time waiting for an operation to finish; define start and end points when recording it | [Region and latency](10-network/01-region-and-network-latency/README.md) |
| Throughput | Number of operations completed per unit time; report operation type and workload | [Load testing](09-performance-testing/01-load-testing-and-regression-benchmarks/README.md) |
| Percentile | A position in the observations' distribution, such as p95 for the slower tail | [Performance metrics](07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) |
| Baseline | A reference result under recorded conditions for comparison with a later run | [Benchmark and regression](09-performance-testing/01-load-testing-and-regression-benchmarks/README.md) |
| Bottleneck | A constraint that limits further improvement under the tested workload | [Application profiling](06-code-optimization/02-application-profiling/README.md) |
| Cache hit / miss | Whether the requested value was found in a cache | [Cache layers](01-caching/01-cache-layers/README.md) |
| Freshness / TTL | The freshness policy and valid time window of cached data | [Freshness and invalidation](01-caching/04-invalidation-and-freshness/README.md) |
| Cache stampede | Concurrent requests all rebuilding an expired/missing value | [Stampede prevention](01-caching/04-invalidation-and-freshness/README.md) |
| Pagination / cursor | Dividing results into pages and the continuation marker used by the contract | [API pagination](02-api-response/03-efficient-pagination/README.md) and [database pagination](04-databases/04-efficient-database-pagination/README.md) |
| Connection pool | A set of connections managed and reused by the program | [Database connection pooling](04-databases/01-connection-pooling/README.md) |
| Query plan | The plan a database selects to execute a query | [Database profiling](04-databases/12-database-profiling/README.md) |
| Replication / sharding | Copying data across instances / splitting data into partitions | [Replication](04-databases/10-replication/README.md) and [sharding](04-databases/11-sharding/README.md) |
| Critical path | A chain of dependent operations that determines response completion | [Critical paths](06-code-optimization/04-critical-paths/README.md) |
| Timeout / retry | An operation's wait limit / another attempt after failure; both must match cost and semantics | [Timeouts and retries](06-code-optimization/07-timeouts-and-retries/README.md) |
| Metrics / logs / traces | Aggregatable measurements / recorded events / a request's execution path | [Signals and instrumentation](07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) |
| Rate limit / throttling | Rules that cap or regulate the rate of accepted work | [Rate controls](08-security/03-throttling-and-rate-limiting/README.md) |
| CDN / keep-alive | Content delivery network / reuse of an HTTP connection | [CDN](10-network/03-cdn-for-static-and-frequent-content/README.md) and [connection reuse](10-network/02-connection-reuse/README.md) |

## Foundational references and citation approach

Scope and checklist themes come from the [Backend Performance roadmap](https://roadmap.sh/backend-performance-best-practices). These references were used for an initial review of common concepts; Persian materials, topic-specific sources, and real-world accounts are listed in the relevant lessons:

- [MDN HTTP Caching guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching): private/shared caches, freshness, and response validation; complements the caching chapter.
- [PostgreSQL EXPLAIN guide](https://www.postgresql.org/docs/current/using-explain.html): reading query plans; details vary by database version.
- [OpenTelemetry Signals](https://opentelemetry.io/docs/concepts/signals/): concepts for signals such as metrics, logs, and traces.
- [AWS: Timeouts, retries, and backoff with jitter](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/): a documented discussion of timeouts, retries, and controlling their load; the original article was published 2019-12-05 and its current destination was reviewed in AWS Builder Center.

When reading an external source, note its date, tool version, workload assumptions, and result scope. A published account is evidence for its own context; deciding what to do in your service still requires practice and measurement. If a source moves or disappears, its title, original link, and review date provide a starting point for refreshing the course.
