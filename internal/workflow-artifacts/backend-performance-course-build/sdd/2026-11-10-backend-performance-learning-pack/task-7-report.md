# Task 7 report — Chapter 06: Code Optimization

Status: complete within the assigned Chapter 06 authoring scope. Date: 2026-11-10.

No Git repository was initialized; no commit or push was made. No software tests, benchmarks, production changes, or exercise execution were performed. Verification was manual document review plus a read-only inventory of relative Markdown link targets.

## Deliverables

Created all nine requested README files under `Backend Performace/06-code-optimization/`:

| File | Content and review focus |
| --- | --- |
| `README.md` | Chapter goals, prerequisites, eight-topic navigation, evidence-first sequence starting with profiling and critical paths, hypothetical report-service scenario, chapter checklist, links to network and performance testing. |
| `01-streaming-large-bodies/README.md` | Incremental data flow, bounded buffering, backpressure, cancellation, incremental parsing/UTF-8 boundaries, completion versus partial output, proxy buffering, resource lifetime and memory arithmetic. Pseudocode explicitly flushes transformation state and aborts output on failure. |
| `02-application-profiling/README.md` | CPU/heap/allocation/wait profiles versus traces, self/cumulative cost, sampling interpretation and flame graphs, representative build/load, profiler overhead, latency-versus-CPU worked example. |
| `03-algorithms-and-data-structures/README.md` | Big-O and constants, repeated scans versus one map build, Top-k, ordering and duplicates, memory/resize costs, input skew and bounded lifecycle. |
| `04-critical-paths/README.md` | Hot path versus latency critical path, dependencies and bounded concurrency, Mermaid fork/join example, Amdahl-style illustrative bounds, route frequency versus per-request cost. |
| `05-language-and-runtime-choices/README.md` | Runtime attribution after profiling, fair measurements, GC/ownership, warmup/build differences, limited migration experiment, team/library/on-call costs. Go and Rust are explicitly options, never blanket recommendations. |
| `06-service-decomposition/README.md` | Module, worker and separate-service alternatives, independent scaling versus network/serialization/operational cost, resource-isolation calculation, data ownership and rollback. Microservices are explicitly not the default performance fix. |
| `07-timeouts-and-retries/README.md` | End-to-end deadline, connection and per-attempt timeout, queue and response reserves, bounded attempts, jitter/backoff, multilayer amplification, idempotency and unknown outcomes. |
| `08-batching-and-round-trips/README.md` | Batching versus concurrency/coalescing/connection reuse, round-trip arithmetic, count/byte/wait/deadline limits, per-item identity and partial errors, safe retries and tenant context. |

All eight topic pages are Persian-first, with RTL prose wrappers, LTR code/pseudocode where applicable, learning outcomes, explanation, measured trade-offs, a worked example, a small exercise and expected observation, evidence or a stated evidence gap, failure modes, operational checklist, six questions with six explained answers, annotated Persian and English resources, and relative chapter/root/related navigation. Total quiz questions: **48**.

## Research and evidence decisions

Used built-in web search/open. Firecrawl was not called or retried.

Primary/official sources checked:

- Azure Well-Architected, optimize code and infrastructure: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure
- AWS Builders’ Library, timeouts/retries/backoff/jitter (redirects to AWS Builder Center): https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/
- Discord Voice at the Edge, June 9, 2026: https://discord.com/blog/how-we-moved-discord-voice-to-the-edge — checked CPU sampling, application receive-loop starvation, subsequent softirq contention, and the fact that the first fix was incomplete.
- Discord message storage, March 6, 2023: https://discord.com/blog/how-discord-stores-trillions-of-messages — checked intermediary data services, Rust selection, same-row request coalescing, routing keys and concurrent database migration context.
- Meta Async, August 17, 2020: https://engineering.fb.com/2020/08/17/production-engineering/async/ — checked batching multiple jobs, retained worker work, reduced dispatcher/queue round-trips and delay tolerance.
- Go diagnostics: https://go.dev/doc/diagnostics
- Go GC guide: https://go.dev/doc/gc-guide
- Node profiling: https://nodejs.org/en/learn/getting-started/profiling
- Node stream backpressure: https://nodejs.org/en/learn/modules/backpressuring-in-streams
- Rust Ownership: https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html
- MDN Streams concepts: https://developer.mozilla.org/en-US/docs/Web/API/Streams_API/Concepts
- OpenTelemetry traces: https://opentelemetry.io/docs/concepts/signals/traces/
- Redis sorted sets: https://redis.io/docs/latest/develop/data-types/sorted-sets/
- Azure microservices style: https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices
- Azure chatty I/O: https://learn.microsoft.com/en-us/azure/architecture/antipatterns/chatty-io/
- gRPC deadlines: https://grpc.io/docs/guides/deadlines/

Persian sources matched to their actual scope:

- Shahin Sayami Node streams guide: https://shahin.page/persian/article-fa/comprehensive-guide-to-nodejs-streams-nodestream-api-fa — opened; labeled Node-specific supplemental learning.
- Python Persian sampling-profiler documentation: https://docs.python.org/fa/3/library/profiling.sampling.html — opened; page says added in Python 3.15, which the guide explicitly notes.
- University-course Persian hash-table notes: https://www.sauleh.ir/ds98/static_files/notes/Lecture22.pdf — opened and identified as course notes, not production evidence.
- Persian distributed-tracing glossary: https://pro-nee.net/terms/distributed-tracing/ — opened; used only as introductory supplement. Exact Persian material on request critical-path calculation was not found, and that gap is explicit.
- Go Farsi profiling/runtime guide: https://book.gofarsi.ir/chapter-4/profiling/ — opened; used for GC, allocation and scheduler concepts, with a warning against treating example percentages as constants.
- Net Paradis monolith/microservices article: https://netparadis.com/monolith-vs-microservices-clean-architecture/ — opened; architecture trade-off supplement.
- Go Farsi retry-timeout pattern: https://book.gofarsi.ir/chapter-9/concurrency-patterns/go-concurrency-pattern-retry-timeout/ — opened; Go/context-specific supplement.
- Persian batching glossary: https://pro-nee.net/terms/batch-requests/ — relevant text visible in built-in search; full-page retrieval timed out. This limitation is explicitly stated in the lesson and the page is not used for normative behavior.

The older Persian Rust book was inspected but omitted from the final resource list because its 1.41/Edition 2018 basis and untranslated ownership chapter made the Go Farsi runtime explanation more directly useful. A search-visible DNTips Rust article could not be opened and was also omitted. The unavailable old Node profiling path was replaced with the working official getting-started/profiling path.

Evidence boundaries:

- Streaming uses an official documented Node experiment and explicitly states that a directly comparable public production Export case was not found.
- Algorithms uses official Redis operational documentation and explicitly states the repeated-scan-to-map example has no matched public production case.
- Profiling/critical-path stories are attributed to Discord and do not claim that changing language automatically fixes scheduling.
- Language and service decomposition pages explicitly avoid attributing multi-change Discord outcomes solely to Rust or a service boundary.
- Timeout evidence includes the verified AWS post-deployment secure-connection example without copying its numeric timeout into a recommendation.
- Batching distinguishes Meta background-job evidence from interactive-API guarantees and Discord coalescing from multi-key batches.
- Every numeric worked example is marked hypothetical/educational. No invented local benchmark or company improvement percentage is reported.

## Manual review performed

Read all nine final files (the last two individually after a combined output was truncated). Reviewed each quiz and answer against the lesson, all calculations and units, headings, code fences, RTL/LTR boundaries, source context, and relative navigation. Corrected the stream pseudocode to finalize transformation state and abort the sink on failure. Re-read changed snippets and the final runtime-resource section.

Manually checked calculations: 3 × 64 KiB = 192 KiB; 100 such streams ≈ 18.75 MiB of those buffers only; 100 MiB at 2 MiB/s needs at least about 50 s; 10,000 × 5,000 = 50,000,000 scan comparisons; fork/join 180 ms serial versus 140 ms parallel and 80 ms after halving the dominant branch; 20% share doubled gives about 1.11× total speed; runtime example 250→230 or 175 ms; decomposition CPU demand 0.5+2=2.5 CPU-second/s; deadline allocations total 600 ms including outer reserves; five layers of three attempts give 243; batch model 320/35/50 ms.

Read-only relative-link inventory found **all Chapter 06 internal links resolve**. Links to existing root, Chapters 02–05 and Chapter 07 resolve. At the last check, four unique external-to-scope targets were still being authored elsewhere in the pack:

- `Backend Performace/09-performance-testing/README.md`
- `Backend Performace/10-network/README.md`
- `Backend Performace/10-network/02-connection-reuse/README.md`
- `Backend Performace/08-security/03-throttling-and-rate-limiting/README.md`

These four paths match the approved design spec and were reported to the parent for final pack integration. No placeholder files outside the assigned scope were created. No software tests were run.

## Remaining concerns for final integration

1. Recheck the four cross-chapter targets once the other chapters are written; they are integration dependencies, not Chapter 06 path typos.
2. Persian Batching full-fetch availability is uncertain; retain the explicit limitation or replace it only with a verified, equally relevant Persian resource.
3. Exact Persian critical-path-request material and directly comparable Streaming/Map production cases remain explicit evidence gaps; do not upgrade their evidence labels in the final pack.
4. Markdown and Mermaid were manually inspected as text; no rendered browser acceptance or runtime exercise execution is claimed.

No other unresolved content issue was identified within the assigned scope.
