# Task 2 report — Chapter 01: Caching

Status: implemented. Research date: 2026-11-10. No Git repository was initialized and no commits were made. No software tests or example/lab executions were performed; this task is educational Markdown authoring with manual inspection.

## Implemented files

1. `Backend Performace/01-caching/README.md` — chapter purpose, prerequisites, ordered route, all four topic links, a shared catalog scenario, relationships to API/network/monitoring/testing chapters, and chapter review checklist.
2. `Backend Performace/01-caching/01-cache-layers/README.md` — HTTP/private/shared semantics; browser/client application/server/CDN distinctions; cache keys and Vary; max-age/s-maxage/private/no-cache/no-store; a bilingual public HTTP response example; revalidation exercise; Cloudflare ETag operational evidence; failure signals, checklist and six explained quiz answers.
3. `Backend Performace/01-caching/02-cache-patterns/README.md` — ownership of cache-aside/read-through/write-through, independent read/write axes, failure contracts, source-then-invalidate pseudo-flow, stale-fill race, bounded fallback, exercise, directly supported Meta memcache history, checklist and six explained quiz answers.
4. `Backend Performace/01-caching/03-multi-level-caching/README.md` — per-process L1/shared L2, conditional hit ratios, lifetime preservation across promotions, invalidation/reconnect/fill races, Redis Pub/Sub delivery semantics, a two-replica exercise, Redis client-side tracking operational evidence, checklist and six explained quiz answers.
5. `Backend Performace/01-caching/04-invalidation-and-freshness/README.md` — freshness/expiry/eviction/invalidation distinctions, dependency invalidation, bounded stale windows, coalescing/jitter/cold starts, soft/hard deadline example, lease ownership and late-fill caveats, Netflix interval-aware TTL evidence, checklist and seven explained quiz answers.

All files are Persian-first UTF-8 Markdown. Prose is enclosed in an RTL/right-aligned wrapper; code and diagrams have nested LTR/left-aligned wrappers. Persian numbered questions/answers and steps have blank paragraph separation for Markdown readability. Examples are language-neutral HTTP, pseudocode, diagrams and arithmetic, and are explicitly labeled educational/unexecuted.

## Manual and structural checks

- Confirmed exactly five README files at the five required paths.
- Inspected chapter/topic headings against every element of the topic-page contract: outcomes/definition, model, trade-offs, worked example, exercise and expected observation, evidence or explicit gap, failures/signals, checklist, quiz, explained key, resources and navigation.
- Checked quiz key pairing: layers 6/6, patterns 6/6, multi-level 6/6, freshness 7/7. Answers are supported in the corresponding text.
- Checked example arithmetic: L1 800/1000 and L2 150/200 produce overall hit 95%; L1 600/1000 and L2 320/400 produce 92%, with 80 source reads. Checked that local singleflight across five replicas can still yield five loaders.
- Checked freshness timelines: HTTP max-age 30 versus shared s-maxage 120; promotion at t=55 preserves only five remaining seconds of a t=60 deadline; soft=30/hard=45 rejects the old example entry at t=46.
- Checked balanced HTML divs and even fenced-block markers in every file.
- Checked all relative Markdown links by resolving them from each file. Every chapter-internal link and the parent index link resolved. Some cross-chapter targets were absent during concurrent authoring; their paths match the design spec exactly and are listed below for the final global check.
- No unrelated chapter/root-index files were edited.

## Verified public sources and evidence boundaries

The web reader returned readable content for RFC 9111, RFC 5861, MDN HTTP caching, Cloudflare ETag documentation, Microsoft Cache-aside, AWS ElastiCache caching strategies, AWS caching best practices, the Amazon caching challenges/strategies article, Redis client-side caching, Redis Pub/Sub, Redis EXPIRE, SET, eviction and distributed-lock documentation, Meta's 2013 memcache story, Netflix's 2026 interval-aware Druid story, and the Persian DevNA/Net Paradis/nsin links used in the chapter.

Important URLs used:

- https://www.rfc-editor.org/rfc/rfc9111.html
- https://www.rfc-editor.org/rfc/rfc5861.html
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching
- https://developers.cloudflare.com/cache/reference/etag-headers/
- https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside
- https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Strategies.html
- https://aws.amazon.com/builders-library/caching-challenges-and-strategies/ (currently redirects to AWS Builder Center)
- https://redis.io/docs/latest/develop/clients/client-side-caching/
- https://redis.io/docs/latest/develop/pubsub/
- https://redis.io/docs/latest/commands/expire/
- https://redis.io/docs/latest/commands/set/
- https://redis.io/docs/latest/develop/reference/eviction/
- https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/
- https://engineering.fb.com/2013/04/15/core-infra/scaling-memcache-at-facebook/
- https://netflixtechblog.com/stop-answering-the-same-question-twice-interval-aware-caching-for-druid-at-netflix-scale-22fadc9b840e
- https://devna.ir/articles/redis-caching-guide
- https://netparadis.com/redis-data-types-caching-strategy/
- https://nsin.ir/blog/how-cdn-caching-works/

Cloudflare and Redis evidence is explicitly characterized as authoritative product/operational documentation, without an invented customer benchmark. Meta is used only for the history and workload described directly in its public engineering post. Netflix is described as an experimental cache layer, matching its article, and its five-second trade-off is not generalized to payments or authorization. No company performance metrics have been invented or copied into educational examples.

## Issues and concerns for integration

1. The USENIX page/PDF linked by Meta returned HTTP 403. The chapter states this limitation and makes no detailed claims from the unread paper.
2. The legacy Redis distributed-lock URL redirects to the current `/develop/clients/patterns/distributed-locks/`; the chapter uses the verified current URL.
3. A Persian L1/L2 article was discoverable in search but its direct page could not be read reliably. It was not used. The multi-level guide explicitly states the narrow Persian coverage gap and uses the verified Net Paradis Redis/TTL page as prerequisite reading rather than claiming it covers the whole coherence protocol.
4. At the local-link check, the following design-spec targets were still absent outside this task's ownership:
   - `02-api-response/04-avoid-unnecessary-server-work/README.md`
   - `03-asynchronism/01-background-jobs/README.md`
   - `05-load-balancing-and-scaling/02-load-balancing/README.md`
   - `06-code-optimization/07-timeouts-and-retries/README.md`
   - `07-monitoring-and-logging/01-metrics-logs-and-traces/README.md`
   - `09-performance-testing/01-load-testing-and-regression-benchmarks/README.md`
   - `10-network/01-region-and-network-latency/README.md`
   - `10-network/03-cdn-for-static-and-frequent-content/README.md`
   The parent agent has been notified to include these in final global link validation after other chapters land. No chapter-internal links were unresolved.
5. No rendered browser/PDF appearance was claimed. RTL/LTR structure and paragraph/fence balance were inspected as Markdown; actual viewer support can vary.

No implementation blocker remains within Chapter 01's scope.
