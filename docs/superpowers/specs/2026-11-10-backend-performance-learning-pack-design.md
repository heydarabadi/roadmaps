# Backend Performance Learning Pack Design

> **Current repository location:** the Persian edition is maintained under `fa/backend-performance/` and the English edition under `en/backend-performance/`. The historical `Backend Performace` path below records the original folder request and source context.

## Intent

Create a Persian-first, topic-by-topic study pack in `D:\Learn\Roadmap\Backend Performace` based on roadmap.sh's **Backend Performance** best-practices roadmap. The material should turn the roadmap checklist into a navigable learning resource a backend developer can study, practice, and review without needing a single programming language or vendor stack.

The user supplied `https://roadmap.sh/backend-performance-best-practices` and also mentioned `roadmap.sh/system-design`. The supplied full URL is the backend-performance checklist, so it is the source of scope. The System Design roadmap is a related reading link in the checklist and may be linked as further study, but its separate topics are out of scope.

## Goals

- Preserve all ten top-level roadmap sections and every checklist item in a traceable chapter/topic structure.
- Create a root `README.md`, one chapter `README.md` in each chapter directory, and one `README.md` in each individual topic directory.
- Teach each topic in Persian, retaining standard English technical terms and copyable left-to-right code/commands.
- Include a language-neutral worked example, a small exercise/lab, practical trade-offs and failure modes, a quiz with an explained answer key, and relevant Persian- and English-language reading links for each topic.
- For every topic, research a public, documented real-world experience or production example and link it. Distinguish documented facts from illustrative scenarios; if no direct public case can be found for a narrow topic, state that limitation and do not invent company results or imply that a hypothetical example is a reported incident.
- Keep the source roadmap linked and record the research verification date so the material can be refreshed later.

## Non-goals

- Reproduce or translate third-party articles wholesale; use original explanations and short examples with direct links to sources.
- Cover all of System Design, all Backend development, or framework-specific implementation guides.
- Claim that literally every page on the internet was searched. Research will be broad and curated, prioritizing primary documentation, standards, and first-party engineering case studies, with suitable Persian learning references where available.
- Optimize one particular production application or declare universal numeric latency/capacity targets.
- Choose a language, cloud provider, database, queue, or monitoring vendor as the user's required stack.

## Constraints and decisions

- Workspace root: `D:\Learn\Roadmap`.
- Requested output folder spelling is kept exactly as supplied: `Backend Performace`.
- Main prose is Persian and right-to-left in intent; identifiers, commands, URLs, and code remain English/LTR and easy to copy.
- Examples are language-independent by default. SQL, HTTP headers, pseudocode, shell snippets, and small Go/Node.js examples may appear when they make a concept concrete, without assuming that stack.
- Each topic page will be self-contained but link back to its chapter and related topics.
- Each quiz will have 5–8 questions of mixed recall, interpretation, and scenario-based difficulty, followed by answers and brief rationales.
- Each topic page should include at least one Persian resource and one English primary/authoritative resource when a suitable page is available. If no trustworthy Persian article exists for a narrow topic, state that plainly and provide a Persian explanation in the README plus the best English source; do not substitute an unrelated link merely to satisfy a count.
- Every topic will have a dedicated real-world evidence callout sourced from a public engineering write-up, case study, or authoritative operational documentation. Sources will be matched as closely as possible to the topic; where no directly comparable public case exists, the README will say so and separate a hypothetical teaching scenario from the documented evidence.
- Avoid duplicated content across topics: explain the topic's own angle and link to its neighboring chapter when the same mechanism appears at another layer.

## Proposed folder structure

```text
Backend Performace/
  README.md
  01-caching/
    README.md
    01-cache-layers/README.md
    02-cache-patterns/README.md
    03-multi-level-caching/README.md
    04-invalidation-and-freshness/README.md
  02-api-response/
    README.md
    01-payload-size/README.md
    02-response-compression/README.md
    03-efficient-pagination/README.md
    04-avoid-unnecessary-server-work/README.md
  03-asynchronism/
    README.md
    01-background-jobs/README.md
    02-message-brokers/README.md
  04-databases/
    README.md
    01-connection-pooling/README.md
    02-indexes/README.md
    03-orm-fetch-strategies/README.md
    04-efficient-database-pagination/README.md
    05-select-only-needed-columns/README.md
    06-denormalization-for-read-heavy-workloads/README.md
    07-join-optimization/README.md
    08-database-maintenance/README.md
    09-slow-query-logging/README.md
    10-replication/README.md
    11-sharding/README.md
    12-database-profiling/README.md
  05-load-balancing-and-scaling/
    README.md
    01-horizontal-and-vertical-scaling/README.md
    02-load-balancing/README.md
  06-code-optimization/
    README.md
    01-streaming-large-bodies/README.md
    02-application-profiling/README.md
    03-algorithms-and-data-structures/README.md
    04-critical-paths/README.md
    05-language-and-runtime-choices/README.md
    06-service-decomposition/README.md
    07-timeouts-and-retries/README.md
    08-batching-and-round-trips/README.md
  07-monitoring-and-logging/
    README.md
    01-metrics-logs-and-traces/README.md
    02-monitoring-toolchain/README.md
    03-asynchronous-logging/README.md
  08-security/
    README.md
    01-dependency-hygiene/README.md
    02-authentication-and-authorization/README.md
    03-throttling-and-rate-limiting/README.md
    04-security-review-and-updates/README.md
  09-performance-testing/
    README.md
    01-load-testing-and-regression-benchmarks/README.md
  10-network/
    README.md
    01-region-and-network-latency/README.md
    02-connection-reuse/README.md
    03-cdn-for-static-and-frequent-content/README.md
    04-prefetch-and-preload/README.md
```

This yields 44 topic pages, 10 chapter indexes, and one root index. Closely related bullets are grouped only where the roadmap itself names them as one learning item; the two pagination pages separate API contract choices from database query mechanics.

## README content contract

### Root README

- Purpose, source roadmap link, research date, and a brief note that this is a curated study pack rather than an exhaustive copy of the web.
- Ordered learning route through the ten chapters, prerequisites, links to chapter indexes, and a roadmap-to-folder traceability table.
- Glossary/index of recurring concepts and a short note on how to use the quizzes and exercises.

### Chapter README

- What the chapter teaches and why it affects user-visible backend performance.
- Prerequisites, recommended sequence, links to every topic, and relationships to other chapters.
- A small chapter-level scenario tying the topic pages together and a chapter review checklist.

### Topic README

1. Learning outcomes and concise definition.
2. Mental model and step-by-step explanation, with a small Mermaid diagram or table where it clarifies flow.
3. When to use it, when it is a poor fit, and the key trade-offs.
4. Worked, language-neutral example and a small exercise with an expected observation/result.
5. Real-world case study with source attribution, or a clearly labeled hypothetical production scenario when a direct public case is unavailable.
6. Common failure modes, operational signals, and a practical review checklist.
7. A 5–8 question quiz with an explained answer key.
8. Curated Persian and English resources. Prefer official docs/specifications for technical behavior; annotate what each link is useful for.
9. Links to the chapter index, parent index, and related topic pages.

## Chapter and topic inventory

1. **Caching (4 topics):** cache layers (HTTP/client/server/CDN); cache patterns (cache-aside/read-through/write-through); multi-level caching; invalidation, freshness, TTL, and stampede prevention.
2. **API Response (4):** payload limits; compression; efficient pagination; avoiding unnecessary server-side work.
3. **Asynchronism (2):** background jobs; message brokers and async communication.
4. **Databases (12):** connection pooling; indexes; ORM fetch strategies (lazy/eager/batch); database pagination; selecting needed columns; read-heavy denormalization; join optimization; maintenance; slow-query logging; replication; sharding; database profiling tools.
5. **Load Balancing & Scaling (2):** horizontal vs. vertical scaling; load balancing.
6. **Code Optimization (8):** streaming; application profiling; algorithms/data structures; critical paths; language/runtime choices; service decomposition; timeouts/retries; batching and network round trips.
7. **Monitoring & Logging (3):** metrics/logs/traces and instrumentation; monitoring toolchain; asynchronous logging.
8. **Security (4):** dependency hygiene; authentication/authorization; throttling/rate limiting; security reviews and updates.
9. **Performance Testing (1):** load testing, benchmarking, baselines, and regression tracking, including load/stress/spike/soak distinctions.
10. **Network (4):** region/locality and latency; connection reuse; CDN delivery; prefetch/preload.

## Research basis gathered for the pack

- User-supplied roadmap page and its linked best-practices PDF; these define scope.
- Primary references discovered include PostgreSQL documentation, Redis documentation, MDN HTTP guides, Microsoft/Azure Well-Architected guidance, AWS Builders' Library/Prescriptive Guidance, Prometheus, OpenTelemetry, and Grafana k6 documentation.
- First-party production stories identified include Netflix's interval-aware Druid caching, Meta's memcache and data-locality work, and Discord's message storage/data-service experience.
- Persian learning references identified include DevNA's Redis caching and SQL/EXPLAIN material, Net Paradis's REST pagination guide, Persian Prometheus/Grafana lessons, and Persian connection-pooling explanations. Each link will be checked against its specific topic before inclusion.

## Review focus

- Roadmap coverage: every one of the ten sections and every listed checklist item must map to at least one topic README.
- Source quality: technical claims should be supported by primary/official sources wherever possible; Persian links are supplemental learning resources and must actually match the topic.
- Evidence integrity: distinguish a documented production result from a local teaching scenario, and include dates/context for company case studies.
- Performance trade-offs: do not present caching, replication, sharding, compiled languages, microservices, prefetching, or retries as automatic improvements; explain their costs and failure modes.
- Quiz correctness: each answer must be present in the page, technically unambiguous, and include a short rationale.

