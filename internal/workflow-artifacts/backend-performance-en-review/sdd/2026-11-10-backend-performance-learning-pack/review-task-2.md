# Read-only Task 2 review package

## Implementer report

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
- Checked quiz key pairing: layers 6/6, patterns 6/6, multi-level 6/6, freshness 7/7. Answers are supported in the corresponding text.- Checked example arithmetic: L1 800/1000 and L2 150/200 produce overall hit 95%; L1 600/1000 and L2 320/400 produce 92%, with 80 source readings. Checked that local single flight across five replicas can still yield five loaders.
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

Cloudflare and Redis evidence is explicitly characterized as authoritative product/operational documentation, without an invented customer benchmark. Meta is used only for the history and workload described directly in its public engineering post. Netflix is ​​described as an experimental cache layer, matching its article, and its five-second trade-off is not generalized to payments or authorization. No company performance metrics have been invented or copied into educational examples.

## Issues and concerns for integration

1. The USENIX page/PDF linked by Meta returned HTTP 403. The chapter states this limitation and makes no detailed claims from the unread paper.
2. The legacy Redis distributed-lock URL redirects to the current `/develop/clients/patterns/distributed-locks/`; the chapter uses the verified current URL.3. A Persian L1/L2 article was discoverable in search but its direct page could not be read reliably. It was not used. The multi-level guide explicitly states the narrow Persian coverage gap and uses the verified Net Paradis Redis/TTL page as prerequisite reading rather than claiming it covers the whole coherence protocol.
4. At the local-link check, the following design-spec targets were still absent outside this task's ownership:
   - `02-api-response/04-avoid-unnecessary-server-work/README.md`
   - `03-asynchronism/01-background-jobs/README.md`
   - `05-load-balancing-and-scaling/02-load-balancing/README.md`
   - `06-code-optimization/07-timeouts-and-retries/README.md`
   - `07-monitoring-and-logging/01-metrics-logs-and-traces/README.md`
   - `09-performance-testing/01-load-testing-and-regression-benchmarks/README.md`
   - `10-network/01-region-and-network-latency/README.md`
   - `10-network/03-cdn-for-static-and-frequent-content/README.md`
   The parent agent has been notified to include these in the final global link validation after other chapters land. No chapter-internal links were unresolved.
5. No rendered browser/PDF appearance was claimed. RTL/LTR structure and paragraph/fence balance were inspected as Markdown; actual viewer support may vary.

No implementation blocker remains within Chapter 01's scope.


## Snapshot: Backend Performance/01-caching/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: #Chapter 01 — Caching and reusing the result
   4: 
   5: Cache means keeping a reproducible copy of a response, data or calculation for reuse. The main question of this chapter "Where to install Redis?" is not We need to know which duplicate work to eliminate, how long the result is acceptable, and what behavior is allowed when the versions differ. The result for the user can be less waiting; The result for the system can be the reduction of database and network work, provided that we also measure the cost of cache and miss maintenance.
   6: 
   7: This chapter covers the four subtopics of Caching in [Backend Performance Roadmap](https://roadmap.sh/backend-performance-best-practices). **Resource review date: 2026-11-10**. The examples are instructive and language-independent; Their numbers are not a measure of a company or general purpose of capacity.
   8: 
   9: ## Prerequisites and study path
  10: 
  11: Be familiar with HTTP request/response, the difference between reading and writing to a database, latency, percentiles, and the concept of multiple instances of a service. Basic knowledge of key/value is enough; Running Redis or having a cloud account is not a prerequisite.
  12: 
  13: Order lesson | A question you must answer
  14: --- | --- | --- |
  15: 1 [Cache Layers: HTTP, Client, Server and CDN](01-cache-layers/README.md) | Which layer can remove which part of the request work? |
  16: 2 | [Cache-aside, Read-through and Write-through templates] (02-cache-patterns/README.md) | Who enters the data into the cache and who is responsible for coordinating with the resource? |
  17: 3 [multilevel cache](03-multi-level-caching/README.md) | How to combine local and shared cache, without forgetting versions? |
  18: 4 | [Void, Freshness, TTL and Prevent Stampede](04-invalidation-and-freshness/README.md) | How long is the statute of limitations allowed and what happens when it expires? |
  19: 
  20: In each lesson, first read the model and example, do the exercise with the desired paper or tool, then answer the test without looking at the answer sheet. Exercises are suggested tests; They are not claimed to run in your environment.21: 
  22: ## continuous scenario of the chapter
  23: 
  24: An educational catalog has three types of data: product image, general product description, and final order price. Image with content hashed URL in browser and reusable CDN. A generic description can have a response cache and a data cache with a specified aging budget. The final price requires source validation and transaction rules; A cached demo alone is not a license to place an order.
  25: 
  26:1. In the first lesson, draw the request path and write the owner of each cache.
  27: 
  28:2. In the second lesson, choose Cache-aside to explain the product and specify the path of commit and cancellation.
  29: 
  30:3. In the third lesson, only if the cost of accessing the shared cache becomes an issue, add a local L1 and simulate the failover communication failure.
  31: 
  32:4. In the fourth lesson, analyze the simultaneity of the expiry of a popular product and the price update.
  33: 
  34: These choices are not the final version of the architecture; They should be evaluated by their traffic, freshness and resource capacity. The operational experience of [Amazon on cache challenges] (https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) is useful to see the risk of service capacity dependence on warm cache.
  35: 
  36: ## Connection with other chapters
  37: 
  38: - [API response](../02-api-response/README.md): response cache is different from payload minification; A large response in hit has both bytes and transmission cost.
  39: - [Remove unnecessary server work] (../02-api-response/04-avoid-unnecessary-server-work/README.md): Conditional response and reuse are only part of removing redundant work.
  40:- [CDN and Frequent Content] (../10-network/03-cdn-for-static-and-frequent-content/README.md): Read delivery location selection and CDN rules after knowing the layers.
  41: - [Zone and Network Latency](../10-network/01-region-and-network-latency/README.md): Closer cache is not always newer version; Distance and novelty are two separate issues.
  42: - [monitor](../07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) and [performance test](../09-performance-testing/01-load-testing-and-regression-benchmarks/README.md): check hit ratio, data age and cold/hot behavior along with end-to-end latency.
  43: 
  44: ## Chapter Review Checklist
  45: 
  46: - [ ] I can explain the difference between private browser cache, shared HTTP and server data cache with an example.
  47: - [ ] I know `no-cache`, `no-store` and `private` do not mean the same thing.
  48: - [ ] is responsible for the loader and write path for each cache pattern.
  49: - [ ] The cache key takes into account all dimensions affecting the result and separation of the tenant.
  50:- [ ] I have a separate hit/miss level for each level and the actual number of requests for the resource.
  51: - [ ] Stale budget, commit/abort path, and message abort behavior are specified.
  52: - [ ] I separate expiration, eviction, refresh and manual cancellation.
  53:- [ ] I have limited and visible program for hot key, cold start, cache crash and attack at the same time.
  54: 
  55: [Return to Collection Index](../README.md) · [Start Lesson One](01-cache-layers/README.md)
  56: 
  57: </div>

## Snapshot: Backend Performance/01-caching/01-cache-layers/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: #01.1 — Caching layers: HTTP, client, server and CDN
   4: 
   5: **Resource review date: 2026-11-10** · Prerequisite: path of an HTTP request and database concept · Suggested time: a study and practice session.
   6: 
   7: ## learning objective and definition
   8:9: After this lesson, you can specify the storage location of the result in the request path, explain the difference between the response cache and the data cache, and write different policies for public and private responses. **Layer** is the place to store and reuse the result; **HTTP caching** is a convention of reusing the HTTP response and can be implemented in multiple locations. Therefore, HTTP, browser and CDN are not three independent technologies: browser and CDN can execute the same contract.
  10: 
  11: ## Mental model: What does each hit remove?
  12: 
  13: layer What does it hold? | What path is deleted in hit? | Important limitation
  14: --- | --- | --- | --- |
  15: browser; private HTTP cache | The correct answer is the same user The network request for a response is still fresh The control of clearing all browsers is not available to the server
  16: Client application cache Data or result in program memory, eg list of last search | API call | Its rules are not necessarily HTTP rules; User exit must be managed
  17: CDN or reverse proxy; shared cache | Shared response between authorized requests Refer to origin Key and subscription policy should prevent data leakage
  18: Response cache on the server Built-in endpoint response Part of routing, query and serialization depending on its location The dimensions of identity, language and query should be properly separated
  19: cache data on the server; Local or common Entity, query result or calculation Access or expensive calculation The server must still process the request and the response
  20: 
  21: The division of private and shared and the role of headers are defined in [RFC 9111, Sections 1 and 4] (https://www.rfc-editor.org/rfc/rfc9111.html#section-1). Conventional data caching is not under the control of this RFC; Leaving `Cache-Control` in the response will not expire your internal Redis.
  22: 
  23: <div dir="ltr" align="left">
  24: 
  25:```mermaid
  26: flowchart LR
  27:     B[Browser HTTP cache] -->|miss or revalidate| E[CDN shared cache]
  28:     E -->|miss or revalidate| A[Origin application]
  29:     A --> C[Server data cache]
  30:     C -->|miss| D[Database]
  31: ```32: 
  33: </div>
  34: 
  35: The first step is to determine the "sameness" of the requests: does the URL, query, language, encoding or identity of the result change? The second step is to select shareable data. The third step is determining novelty and validation. `Vary` tells the HTTP cache which request header to compare to choose the cached version; This header does not replace access control. For the language difference in the example, `Vary: Accept-Language` is required; For compressed content, depending on the response producer, `Accept-Encoding` should also be considered. [Technical Basis: RFC 9111, Section 4.1] (https://www.rfc-editor.org/rfc/rfc9111.html#section-4.1).
  36: 
  37: Answer command Practical meaning
  38: --- | --- |
  39: `max-age=60` | We measure freshness by response age and declared duration, not cache installation time
  40: `s-maxage=300` | freshness period for shared cache; For that it has priority over `max-age` |
  41: `private` | The answer should not be stored in the shared cache; Privatization license is not the key
  42: `no-cache` | Reuse requires successful validation; Does not prohibit storage
  43: `no-store` | The cache should not store this exchange; The purge command is not in previous versions
  44: 
  45: The exact definition of commands is given in [RFC 9111, Section 5.2.2](https://www.rfc-editor.org/rfc/rfc9111.html#section-5.2.2). The mere existence of `Set-Cookie` is not a general strategy to avoid cache; Check the express policy and product regulation.
  46: 
  47: ## When is it useful and what is its cost?
  48: 
  49: The generic versioned file, item description, and duplicate search response are reasonable candidates. Before choosing, see if the main cost is network or query/calculation; The data cache may delete the query, but the path around the network remains. A personal reply can have its own private policy, but very sensitive information may require `no-store`. This choice is a function of the product's need; "Cache all GETs" is not a good policy.
  50: 
  51: A large number of key dimensions scatter copies and reduce hits. Eliminating the effective dimension to increase the hit will produce an incorrect answer. A closer cache usually removes more of the path, but it becomes more difficult to invalidate all versions. The topic of PoP selection and network cost continues in [CDN lesson](../../10-network/03-cdn-for-static-and-frequent-content/README.md).
  52: 
  53: ## Solved example: A general bilingual response
  54: 
  55: **Educational scenario; Not implemented or measured.** `/catalog/42` Returns generic description by language without user identity. For simplicity, the initial response age is zero, and we don't have a specific CDN error or override.
  56: 
  57: <div dir="ltr" align="left">
  58: 
  59:```http
  60: GET /catalog/42 HTTP/1.1
  61: Host: example.test
  62: Accept-Language: fa
  63: 
  64: HTTP/1.1 200 OK
  65: Content-Type: application/json
  66: Cache-Control: public, max-age=30, s-maxage=120
  67: Vary: Accept-Language
  68: ETag: "catalog-42-fa-v7"
  69: 
  70: {"id":42,"title":"Example product"}
  71: ```72: 
  73: </div>
  74: 
  75: In 20 seconds the browser can re-consume the fresh response. At 40 seconds, the browser's response is no longer fresh, but the CDN, taking into account the age of the response, may provide its own fresh response; The request does not go to the origin. At age 130, the CDN version also needs to validate or receive a new response. If the validator still matches, the conditional response can be `304 Not Modified` and the body is not sent again; 304 still has a round trip and probably some server work. The tutorial [MDN HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching#validation) demonstrates this conditional flow.
  76: 
  77: Do not copy this same public policy for `/me`. In this scenario, the product's decision is not to save account information, so the answer is `Cache-Control: no-store`. It is also the application's responsibility to separate the users' results in the internal cache.
  78: 
  79: ## Small exercise and expected observation
  80: 
  81:1. With paper, mark the path on the chart to ask for `fa` language at ages 20, 40, and 130; Then add the request `en` in 20 seconds.
  82: 
  83: 2. If you have a test endpoint under your control, set the same headers and reopen the fixed URL in the browser's Network with the Disable cache option turned off. Record transferred, status and `Age` columns if any.
  84: 
  85:3. Just replace public policy with `no-cache`; With a static validator, you expect a conditional request, not a body redownload guarantee.
  86: 
  87: **Expectation:** The English version should not be translated into Farsi because of the Farsi hit. The re-request may be answered from memory/disk, from the edge, or with a 304; Do not write these as a type of hit. Browser reload, CDN settings and actual headers change the behavior. `curl` is not a normal browser cache; Its two implementations alone do not show the private cache behavior.
  88: 
  89: ## Public witness and the limit of conclusion
  90: 
  91: > **Product operational documentation, not a customer benchmark:** [Cloudflare's official ETag documentation](https://developers.cloudflare.com/cache/reference/etag-headers/) shows how a real CDN handles origin and browser validators and differentiates between strong and weak ETags. It sees the use of the HTTP contract in several layers. From that we do not conclude the latency reduction number for our hypothetical system or that all CDNs behave the same.
  92: 
  93: ## Common errors and operational symptoms
  94: 
  95: Failure Sign | Practical review
  96: --- | --- | --- |
  97: Share a personal reply Another user sees the first person's name/basket Check private/no-store policy, bypass and key with two identities |
  98: The key does not have an effective language or query The correct answer is replaced by an unrelated parameter Compare the URL/query/language matrix with the response body |
  99: `no-cache` confused with `no-store` | It was expected not to be saved, but the answer is kept See the actual output header of all proxies
 100: hit, but TTFB is still high DB has calmed down and route delay remains trace to origin and separate serialize/network cost |101: purge only on CDN | Some users still have the previous version Check browser lifetime and URL version
 102: 
 103: ## Operational checklist
 104: 
 105:- [ ] for each endpoint is specified as public, private or unstorable.
 106: - [ ] key and `Vary` cover all effective differences; Independent access control is established.
 107: - [ ] The headers that reach the user are compared with the headers generated by origin.
 108: - [ ] hit/miss/bypass/revalidation is recorded in each separate layer.
 109: - [ ] Both TTFB and transmission bytes, origin and query rates are measured.
 110: - [ ] The 304 response is not considered to mean "the server did nothing".
 111: - [ ] Content change and user exit checked with saved versions.
 112: 
 113: ## test
 114: 
 115:1. Is "HTTP cache" necessarily a separate server next to Redis?
 116: 
 117:2. What is the difference between `no-cache` and `no-store`?
 118: 
 119:3. Why does adding Redis not necessarily eliminate user latency away from the origin?
 120: 
 121:4. In the example with the response age of 40 seconds, which period is the criterion for shared cache?
 122: 
 123:5. How does the HTTP cache separate versions if the language in the header changes the result?
 124: 
 125: 6. Does 304 prove that the request did not reach the origin?
 126: 
 127: ### descriptive answer
 128: 
 129: 1. No; The store and reuse contract is the HTTP response and can be implemented by the browser, proxy or CDN. Redis can be standalone and for internal data.
 130: 
 131:2. The first requires validation before reuse, and the second prohibits saving this exchange; None is the only command to clear all previous versions.
 132: 
 133: 3. A data cache hit can delete the query, but the request still travels through the network to the application and processing the response.
 134: 
 135: 4. `s-maxage=120`; `max-age=30` is in place for the browser. The age of the answer should be included in the calculation.
 136: 
 137:5. In the example `Vary: Accept-Language`; Without separating the effective dimensions, it is possible to choose the wrong version. This does not take the place of authorization.
 138: 
 139: 6. No; Revalidation can reach origin. A 304 prevents the body from being resubmitted and does not necessarily reduce the number of round trips.
 140: 
 141: ## Recommended sources
 142: 
 143: - English, Core Standard: [RFC 9111 — HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111.html), for private/shared, response lifetime and Cache-Control directives.
 144: - English, tutorial: [MDN HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching), for browser model, conditioning and reload diff.
 145: - English, product witness: [Cloudflare ETag headers](https://developers.cloudflare.com/cache/reference/etag-headers/), for limitations of a real CDN implementation.
 146: - Farsi, supplementary study: [CDN cache guide in nsin] (https://nsin.ir/blog/how-cdn-caching-works/), for cache key, TTL and purge terms. Do not assume numerical suggestions or service-specific rules are HTTP rules; In case of dispute, refer to the RFC and documentation of your product.
 147: 
 148: [Chapter List](../README.md) · [Series List](../../README.md) · [Next Lesson: Cache Patterns](../02-cache-patterns/README.md) · [Related: Shrinking Answers](../../02-api-response/01-payload-size/README.md)
 149: 
 150: </div>## Snapshot: Backend Performance/01-caching/02-cache-patterns/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: # 01.2 — Cache-aside, Read-through and Write-through patterns
   4: 
   5: **Source check date: 2026-11-10** · Prerequisite: key/value, original data source and commit · Suggested previous topic: [cache layers](../01-cache-layers/README.md).
   6: 
   7: ## learning objective and definition
   8: 
   9: After reading, you can determine the person responsible for the cache miss, design the write path separately from the read, and explain why "two values were written" does not mean an atomic transaction between the database and the cache. The cache pattern is the contract between **application, cache and main resource**; The name of an instrument does not determine this convention.
  10: 
  11: In this lesson, Cache-aside means that the program itself coordinates cache lookup, loading from the source and cache population. Read-through means the program calls an abstraction with a loader and supplies that miss layer from the source. Write-through means write passes through the specified interface path and is applied to the stable resource and cache before success according to the contract. Implementations are named differently; Read the error and arrangement agreement in the documentation of the same product. [Official introduction to this pattern family: Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside).
  12: 
  13: ## Mental model and comparison
  14: 
  15: Pattern | Responsible for miss in read | The way of writing in this lesson The main cost and risk
  16: --- | --- | --- | --- |
  17: Cache-aside | Program code commit the source, then undo the dependent entry Duplicated code, slower miss and incompatibility window
  18: Read-through loader in the cache/library layer is determined independently; Can be combined with write-through Dependence on the loader contract, error management and revocation outside of it
  19: Write-through | does not specify the read pattern | The write interface synchronizes the source and the cache before committing Increasing the work of the write path and the problem of partial failure
  20: 
  21: Read-through and Write-through are two different axes: the first describes read and the second describes write. A simple wrapper can provide read-through; Regular Redis doesn't automatically know your SQL. Also, write-through is different from write-behind: in write-behind, writing the source is deferred and durability/playback is the main issue; Its implementation is beyond the scope of this lesson. [AWS ElastiCache document about lazy loading and write-through] (https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Strategies.html) is good for seeing the cost of misses and writing data that may never be read.
  22: 
  23: <div dir="ltr" align="left">
  24: 
  25:```mermaid
  26: sequenceDiagram
  27:     participant A as Application
  28:     participant C as Cache
  29:     participant D as Source database
  30:     A->>C: GET product:42
  31:     alt cache hit
  32:         C-->>A: cached value
  33:     else cache miss
  34:         A->>D: READ product 42
  35:         D-->>A: committed value
  36:         A->>C: SET value with expiry
  37:     end
  38: ```39: 
  40: </div>
  41: 
  42: The chart belongs to Cache-aside. For Read-through, the lookup and loader sections are placed inside the abstraction; This shift of responsibility does not eliminate the I/O cost of the resource in the miss.
  43: 
  44: ## When to choose?
  45: 
  46: Cache-aside is a simple starting point for frequent results where not all source data needs to fit in memory. If every request has a new key, the cost of cache lookup and fill is added to the miss and you get little profit. Read-through is useful when the shared loader and error contract is uniform across multiple consumers; The loader should not secretly execute unlimited queries or infinite retries.
  47: 
  48: Write-through can be checked for paths where all writers pass through the interface and more write cost is accepted. A SQL job, migration, or other service that directly modifies the source breaks that assumption. Even in write-through, eviction and restart can empty the cache; miss path is still required for read. For access authorization, final balance, or financial calculations, check the validity condition with valid transaction/resource; Hit cache alone is not a commercial guarantee.
  49: 
  50: ## Solved example: General product description with Cache-aside
  51: 
  52: **Learning Assumption:** The item description can be out of date for a limited time and is the primary source of the database. All configuration numbers are examples. The key contains the tenant and version of the structure; Other dimensions, such as language, should be added if the data is effective.
  53: 
  54: <div dir="ltr" align="left">
  55: 
  56:```text
  57: function readProduct(tenantId, productId):
  58:     authorizeRead(tenantId, productId)
  59:     key = "product:v2:" + tenantId + ":" + productId
  60:     cached = cache.tryGet(key, cacheTimeBudget)
  61:     if cached.found:
  62:         return cached.value
  63: 
  64:     # A cache error is distinct from an ordinary miss in metrics.
  65:     value = source.readCommitted(tenantId, productId, sourceTimeBudget)
  66:     cache.trySet(key, value, ttlSeconds=60)  # bounded best effort
  67:     return value
  68: 
  69: function updateProduct(tenantId, productId, change):
  70:     authorizeWrite(tenantId, productId)
  71:     source.commitChange(tenantId, productId, change)
  72:     cache.tryDelete("product:v2:" + tenantId + ":" + productId)
  73: ```74: 
  75: </div>
  76: 
  77: In the first read, if the cache is empty, the source is read and the result is kept for 60 seconds. The second read before expiration can be a hit. After the author's commit, deleting the entry causes the next read to see the source again. **This pseudocode is intentionally a training base with limited guarantees:** delete failure should be logged and compensated; For reliable deletion, the cancellation event can be recorded in the outbox along with the commit, and the worker can be retried. Read the [background job](../../03-asynchronism/01-background-jobs/README.md) role there.
  78: 
  79: Commit then delete order reduces the risk of cache filling with uncommitted data between delete and commit, but does not resolve all races. Independent example: reader A gets version 7 from source, writer B commits version 8 and deletes the key, then A commits version 7 to the cache. As a result, you can see old data until the next cancellation or expiry. For stronger assurance, version/generation checking, fill write control, and read path revision are required; Details at [revocation and novelty](../04-invalidation-and-freshness/README.md).
  80: 
  81: A cache miss is not the same as a miss: If all requests go directly to the resource on a cache miss, the resource may not have enough capacity. This example should be completed with resource concurrency limit, deadline and service reduction behavior; Policy selection is based on data sensitivity.
  82: 
  83: ## Small exercise and expected observation
  84: 
  85: Create a manual table with columns `source version`, `cache version`, and "Who Answers":
  86: 
  87: 1. The source version is 7 and the cache is empty; Do two consecutive reads.
  88: 
  89: 2. Commit version 8 to the source but assume that delete intentionally failed.
  90: 
  91:3. Do a read before expiry and a read after expiry.
  92: 
  93: 4. Transfer the same reads to the hypothetical abstraction `getOrLoad(key, loader)` and write which responsibility was removed from the caller.
  94: 
  95:5. For write-through, assume that the commit is successful, but the cache write is unsuccessful. Write API response and retry contract.
  96: 
  97: **Expectation:** In the first stage, reading the resource once is enough, in the second stage, staleness appears, and in the third stage, expiry gives a chance to reload. Switching to read-through does not automatically fix the write incompatibility. In the fifth stage, you cannot say "nothing happened"; The source has changed. Retry without idempotency may repeat the business effect. This is a route calculation exercise, not a Redis speed benchmark.
  98: 
  99: ## Documented general experience
 100: 
 101: > [Meta Engineering Report on April 15, 2013] (https://engineering.fb.com/2013/04/15/core-infra/scaling-memcache-at-facebook/) explains that Facebook started using memcached in 2005 in response to growing queries and increasing page load times. The same report mentions the challenges of unbalanced data popularity and fan-out. This shows the practical role of the resource-side cache; From its short text, we cannot conclude the exact type of write-through contract or atomicity guarantee. The linked technical article on USENIX was unreadable with a 403 at the time of this review; Its partial claims are not mentioned in this lesson.
 102:103: Our teaching impression is that template selection should be related to read iteration and resource cost, not just database name or company size.
 104: 
 105: ## Failures, signals and checklist
 106: 
 107: Failure Visible signal Review action
 108: --- | --- | --- |
 109: All misses run several queries Increasing query per request and p95/p99 miss Trace the loader separately
 110: Delete failed after commit | Difference of source/cache version and invalidation error Event registration, limited retry and backup TTL
 111: Key without tenant or schema version Response mix-up or deserialize error | Namespace design and two-tenant scenario
 112: The author is out of the interface Changing the source without changing the cache The list of all writers and the path of publication change
 113: Missing error with temporary failure Save "not found" when resource timeout | negative cache only for not being valid with specified TTL
 114: 
 115: - [ ] source of truth and responsible for lookup/load/write are written for each template.
 116: - [ ] miss, cache error, loader error and write error have separate counters.
 117: - [ ] is the waiting time of the cache and limited resource; The fallback capacity has been checked.
 118: - [ ] cache fill has TTL and size ceiling; The lack of TTL is a conscious decision.
 119:- [ ] All writers and dependent keys, including index/search, are known.
 120: - [ ] Partial write failure and duplicate response consistent with idempotency.
 121: - [ ] Failed override path and concurrent reader are checked in practice.
 122: 
 123: ## test
 124: 
 125:1. What is the defining difference between Cache-aside and Read-through?
 126: 
 127: 2. Does the read-through option specify how to write?
 128: 
 129: 3. Why write-through does not necessarily mean atomic SQL transaction and cache?
 130: 
 131: 4. Which data benefits less from Cache-aside: frequent keys or unique result of each request? why
 132: 
 133:5. Does commit then delete remove all races? Write a breaking sequence.
 134: 
 135: 6. In cache error, why "all requests go directly to source" is not enough decision?
 136: 
 137: ### descriptive answer
 138: 
 139: 1. Owns miss logic: caller in Cache-aside and abstraction/loader in Read-through. The actual I/O count should still be measured.
 140: 
 141:2. No; read and write are two independent contracts and can be combined. Write and cancel behavior should be defined separately.
 142: 
 143: 3. Source and cache may be two independent systems with partial failure; Success of one and failure of another is possible without additional coordination.
 144: 
 145: 4. The unique result of each request; reuse is low and lookup/fill adds overhead.
 146: 
 147:5. No; A reads version 7, B commits and deletes version 8, then A fills version 7. Version control and simultaneous design are necessary.
 148: 
 149: 6. Because sudden load miss may reject the capacity of the source; Concurrency limit, deadline and error behavior/service reduction should be clear.
 150: 
 151: ## Suggested sources
 152:153: - English, official architecture: [Microsoft Cache-aside pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside), for application responsibility, freshness and compatibility constraints.
 154: - English, Product Guide: [AWS ElastiCache caching strategies](https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Strategies.html), for lazy loading, write-through and their costs; Separate the product details from the main pattern.
 155: - English, Engineering experience: [Scaling memcache at Facebook](https://engineering.fb.com/2013/04/15/core-infra/scaling-memcache-at-facebook/), for use case and load pattern.
 156: - Farsi, supplementary tutorial: [DevNA: Guide to cache-aside, TTL and deletion policy] (https://devna.ir/articles/redis-caching-guide), for vocabulary review and sample program; Those test numbers are not a reference to your system capacity.
 157: 
 158: [Chapter List](../README.md) · [Set List](../../README.md) · [Previous Lesson: Layers](../01-cache-layers/README.md) · [Next Lesson: Multilevel Cache](../03-multi-level-caching/README.md) · [Related: Timeout and Retry](../../06-code-optimization/07-timeouts-and-retries/README.md)
 159: 
 160: </div>

## Snapshot: Backend Performance/01-caching/03-multi-level-caching/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: #01.3 — Multilevel caching and version coordination
   4: 
   5: **Resource review date: 2026-11-10** · Prerequisite: [cache patterns] (../02-cache-patterns/README.md), some sample programs and the difference between local and network memory.
   6: 
   7: ## learning objective and definition
   8: 
   9: After this lesson you can design the route `L1 → L2 → source`, count the hits of each level with the correct denominator and show why clearing the shared cache does not clear the memory of all processes. **multilevel cache** means multiple reuse locations in a row with different speed, size and scope of sharing. In this lesson, L1 is the local memory of the program and L2 is the shared cache on the network; These names do not refer to the CPU hardware cache.
  10: 
  11: HTTP and CDN layers were introduced in [layers lesson] (../01-cache-layers/README.md). The focus here is on the local memory of multiple application replicas and the shared data cache, not CDN location selection.
  12: 
  13: ## mental model and reading stages
  14: 
  15: <div dir="ltr" align="left">
  16: 
  17:```mermaid
  18: flowchart LR
  19:     A[Request on replica A] --> L1A[L1 in process A]
  20:     B[Request on replica B] --> L1B[L1 in process B]
  21:     L1A -->|miss| L2[Shared L2]
  22:     L1B -->|miss| L2
  23:     L2 -->|miss| D[Source database]
  24: ```25: 
  26: </div>
  27: 
  28:1. After the access control, the program checks the L1 input along with the version and deadline of freshness.
  29: 
  30:2 in miss it goes to L2; On hit it transfers data to L1 with **remaining life**.
  31: 
  32:3. If L2 is also miss, the resource load path is executed with time budget and concurrency cap; The result is placed in the appropriate layers.
  33: 
  34:4. When the resource is changed, both L2 and all associated L1 versions must be revoked or updated; The order of the commit and the running fills is also important.
  35: 
  36: Having L1 can remove network call in hit. On the other hand, each replica has its own version and memory consumption; Increasing the number of replicas causes duplication of the same data. [Amazon's operational experience about local and external cache] (https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) points to incompatibility between servers and local cold start; Consider these costs before adding a second level.
  37: 
  38: ## trade-off and domain choice
  39: 
  40: Selection Possible advantage Cost/Condition |
  41: --- | --- | --- |
  42: Only common L2 | A common place for reuse between replicas Each read still has a network connection
  43: Small L1 + L2 | Reduce repeated calls to L2 for hot data Duplicate memory consumption, cancellation and local versions
  44: Short-lived L1 without message Simpler implementation for data tolerant | accepting an old window; It does not mean strong coherence
  45: L1 with a cancellation message Faster response to change in healthy state Message delay/lost and race with fill should be managed
  46: 
  47: For each request with a unique result, L1 only adds a maintenance fee. For highly change-sensitive data, removing the local level may be better than adding a coordination protocol. measure the increase of hit with age and p95/p99; hit is not more with the old answer of product success.
  48: 
  49: ## Solved example: Conditional hit and real life
  50: 
  51: **Training model, not company result:** Out of 1000 requests, L1 has 800 hits. Out of the remaining 200 requests, L2 has hits for 150. So 50 reads reach the source.
  52: 
  53: <div dir="ltr" align="left">
  54: 
  55:```text
  56: L1 hit ratio                  = 800 / 1000 = 0.80
  57: L2 conditional hit ratio      = 150 / 200  = 0.75
  58: Overall cache hit ratio       = (800 + 150) / 1000 = 0.95
  59: Source request fraction       = (1 - 0.80) * (1 - 0.75) = 0.05
  60: ```61: 
  62: </div>
  63: 
  64: 80% and 75% cannot be added; Their denominator is different. This model is related to normal read without retry, additional refresh, coalescing or error. In the real system, count the number of queries directly; The cache miss rate is not always equal to the query rate.
  65: 
  66: Now the input at time 0 is taken from the source and has `validUntil=60`. Replica B reads from L2 at 55 seconds. If the L1 again sets a full TTL of 60 seconds, data can remain in local memory for up to 115 seconds, while the model budget was 60. The correct sample rule is:
  67: 
  68: <div dir="ltr" align="left">
  69: 
  70:```text
  71: remaining = entry.validUntil - now
  72: if remaining <= 0:
  73:     doNotPromoteToL1()
  74: else:
  75:     localTtl = min(configuredL1Ttl, remaining)
  76:     putL1(entry.value, entry.version, localTtl)
  77: ```78: 
  79: </div>
  80: 
  81: For real implementations, absolute times between machines require clock synchronization and confidence margins; Or publish remaining life including transit time. Cache expiry does not prove the age of the database version by itself: the replica's read source may be lagging. The above rule only prevents unwanted lifetime extension in the chain of this example.
  82: 
  83: ## Cancellation between replicas and disconnection
  84: 
  85: L2 removal is not automatic message for A and B after source change. You can emit event `product:42 changed to version 8` and clear all L1s. In Redis Pub/Sub delivery is **at-most-once**; A subscriber who was disconnected when the message was received will not replay it later. So just using Pub/Sub does not guarantee you will get all revocations. [Official semantics documentation](https://redis.io/docs/latest/develop/pubsub/#delivery-semantics).
  86: 
  87: Define back-up TTL, L1 clearing on reconnect and link gap detection for a scheme that requires limited aging. For reproducible delivery, you need to design a maintainable event system, cursor, and offset; Just changing the name of the broker is not enough. Even with a healthy message, the old fill may expire after the revocation arrives. The local version/generation and fill release control should prevent the old version from reverting, or you should accept this window explicitly.
  88: 
  89: ## Small exercise and expected observation
  90: 
  91: You can also create two tables `L1-A` and `L1-B` and one table `L2` without tools:
  92: 
  93:1. Fill all with version 7; A and B each have read.
  94: 
  95:2. Make the source version 8, delete L2 and delete only L1-A.
  96: 
  97:3. Send a read to A and a read to B. Then finish the life of L1-B and read again.
  98: 
  99: 4. Add cancel message mode but assume B is interrupted when sending; After reconnecting, first delete its L1.
 100: 
 101:5. Repeat the hit calculation example with L1 equal to 600 out of 1000 and L2 equal to 320 out of 400.
 102: 
 103: **Expectation:** In the second stage, B can still issue version 7; The load balancer may switch the user between versions. Reconnect along with flush takes the possibility to reuse the insecure local version, but creates a warm-up load. In the fifth stage, the overall hit is 92% and the source read is 80. This exercise alone does not prove linear coherence.
 104: 
 105: ## public witness: local cache with the help of a Redis server
 106: 
 107: > **Official operational documentation, no benchmark claims:** [Redis client-side caching](https://redis.io/docs/latest/develop/clients/client-side-caching/) describes a real scheme of Redis server-side client-side caching: the server tracks the keys read and sends invalidations when they change; The client discards invalid input. The same document mentions the behavior of clearing the cache in disconnection and the need to support the library. This "client" can be a library in the backend, not the user's browser. This is witnessing the L1 mechanism close to the consumer; It doesn't replace SQL-to-Redis invalidation or guaranteeing all the concurrency states of your application.
 108:109: Before enabling this feature, check your Redis version, protocol, library and connection pool behavior with the documentation of the same version; One command support alone is not equivalent to full client-side caching support.
 110: 
 111: ## Failures and operational signals
 112: 
 113: Failure Sign | What to check? |
 114: --- | --- | --- |
 115: Return the old data in a replica Version difference in consecutive answers Answer version with replica ID, without recording sensitive information
 116: L1 without size ceiling | Heap growth, GC or OOM pressure | Size/number of entries, memory limit and local eviction
 117: Simultaneous rollout of all replicas Leap miss and L2/source traffic Gradual rollout, cold start and coalescing capacity
 118: Life extension in promotion The age of the data is greater than the budget of the product initial and remaining life metadata
 119: Missing cancellation Stable difference after reconnect Message gap, flush and path compensation
 120: 
 121: ## operational checklist
 122: 
 123: - [ ] There is a measurable reason for adding L1.
 124: - [ ] L1 and L2 each have size limit, eviction policy and TTL.
 125:- [ ] hit ratios are reported with a separate denominator and the actual resource access rate.
 126: - [ ] Edition and life are not extended by passing between levels for no reason.
 127: - [ ] All replicas and writers have been seen in the cancellation plan.
 128: - [ ] The old disconnect, reconnect and fill are checked at the same time as cancellation.
 129: - [ ] cold start and loss of L2 does not convert to resource unlimited burst.
 130: - [ ] data age/version sampling is done next to the delay.
 131: 
 132: ## test
 133: 
 134: 1. What places do L1 and L2 refer to in this lesson?
 135: 
 136: 2. Why does deleting the L2 key not necessarily delete the L1-B key?
 137: 
 138: 3. If L1 hit is 60% and conditional L2 hit is 80%, what percentage of requests reach the resource?
 139: 
 140:4. Why would an input transfer at 55 seconds with a new TTL of 60 be wrong?
 141: 
 142:5. Does normal Redis Pub/Sub replay the interrupted message after reconnect?
 143: 
 144: 6. Does L1's shorter TTL ensure that no stale responses are generated?
 145: 
 146: ### descriptive answer
 147: 
 148: 1. local memory of each process and shared cache on the network; These are not CPU cache names in this text.
 149: 
 150:2. Process B's memory is separate; Without message, expiration or other contract will not be notified of L2 removal.
 151: 
 152:3. `0.40 × 0.20 = 0.08` or 8%; overall hit is equal to 92%. L2 only sees requests passed through L1.
 153: 
 154: 4. because there are 5 seconds left of the designated life; The new TTL can extend the data lifetime up to 115. The remainder and ceiling of L1 should be used.
 155: 
 156: 5. No; is at-most-once. Must have flush, TTL or replayable/compensation scheme for unreliable versions.
 157: 
 158: 6. No; It only reduces the reuse window under specified assumptions. Lagging source, old fill, or cancellation delay are still issues.
 159: 
 160: ## Recommended sources
 161:162: - English, main document: [Redis client-side caching](https://redis.io/docs/latest/develop/clients/client-side-caching/), for tracking, revocation, disconnection and client compatibility.
 163: - English, delivery contract: [Redis Pub/Sub](https://redis.io/docs/latest/develop/pubsub/), to see the at-most-once limit.
 164: - English, operational experience: [Amazon caching challenges] (https://aws.amazon.com/builders-library/caching-challenges-and-strategies/), local and external caches section to understand multi-version and cold start.
 165: - Farsi, related prerequisite: [NetParadise: Redis, cache and expiration patterns](https://netparadis.com/redis-data-types-caching-strategy/), to review shared cache and TTL with a Node.js example. This is not a complete L1/L2 protocol training resource; In the readable Persian sources of this review, no independent reference was found covering all the states of disconnection and fill at the same time. The Farsi explanation of this lesson and the official Redis document are the reference for this section.
 166: 
 167: [Chapter List](../README.md) · [Collection List](../../README.md) · [Previous Lesson: Patterns](../02-cache-patterns/README.md) · [Next Lesson: Revocation and Novelty](../04-invalidation-and-freshness/README.md) · [Related: Load Balancing](../../05-load-balancing-and-scaling/02-load-balancing/README.md)
 168: 
 169: </div>

## Snapshot: Backend Performance/01-caching/04-invalidation-and-freshness/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: #01.4 — Revocation, freshness, TTL and Cache Stampede prevention
   4: 
   5: **Resource check date: 2026-11-10** · Prerequisite: [Cache-aside](../02-cache-patterns/README.md), [Multi-level cache](../03-multi-level-caching/README.md), deadline and synchronization.
   6: 
   7: ## learning objective and definition
   8: 
   9: After this lesson you can separate the aging budget from the physical retention time, combine TTL and event-driven cancellation, and limit the influx of concurrent reads after expiration. **Freshness** means that the result is within the scope of the product freshness contract; **invalidation** declaring the version invalid; **TTL** is the maintenance/validity period specified in the cache contract. The meaning of TTL in a key/value cache is not exactly the same as HTTP response freshness and should be clarified in the design.
  10: 
  11: ## Mental model: three hours and four events
  12: 
  13: Separate `sourceVersion` or resource change time, `fetchedAt` and version usage deadline for one entry. If you are now getting data from a read replica backlog, `fetchedAt=now` does not prove that the data is the most recent commit. Also, "still in memory" is not equivalent to "allowed to consume".
  14: 
  15: Event What does it change? | The correct meaning
  16: --- | --- | --- |
  17: Expiration The designated life will end The next read may miss or require refresh
  18: eviction | Memory is freed under the capacity policy Can occur before TTL |
  19: Invalidation The specified version or dependent assembly becomes invalid Usually after changing the source or publishing the content |
  20: refresh | Data is re-sourced/validated Its success, error and cost should be seen
  21:22: Redis provides TTL through commands like [EXPIRE](https://redis.io/docs/latest/commands/expire/); Memory policy and [eviction](https://redis.io/docs/latest/develop/reference/eviction/) is a separate issue. A long TTL does not guarantee that the input will remain in memory until then. In Redis, you can set the value and expiration in one command with `SET ... EX ...`; Two separate commands have a break distance. A normal overwrite with `SET` can also destroy the previous TTL; Check the options from the [SET doc](https://redis.io/docs/latest/commands/set/).
  23: 
  24: ## Choice of freshness and revocation policy
  25: 
  26:1. **Ask the product:** Can the product description be a few seconds old? Does a revoked license or fixed price have such an opportunity? Write a separate contract for each category.
  27: 
  28:2. **Find Dependent Keys:** Changing the product may affect the product key, category listing and search result. deleting one key does not modify all of them.
  29: 
  30:3. **Define the change path:** commit the source, reliably log the change event if needed, and then undo/refresh. The event before commit can cause fill from the previous version.
  31: 
  32:4. ** Plan to fail:** Backup TTL, limited retry, register cancellation lag and prevent old fill. outbox can coordinate the event with commit, but its consumer and retry must also be designed.
  33: 
  34: Politics More suitable for | Cost/Limit |
  35: --- | --- | --- |
  36: Only TTL | Data with tolerable obsolescence and simple writers It is possible to see the old version until it expires
  37: Abort after write + TTL | Volatile data with the need for faster response message/delete can fail; Dependency of keys is important
  38: Version key/URL | immutable asset or snapshot The consumer must find the new version; The old version must be collected
  39: soft expiry and background refresh A data display that accepts limited stale | stale must have a specific ceiling; Not allowed for any data
  40: Valid reading in sensitive path A decision for which old age is not acceptable higher resource and transaction costs; Display cache is checked separately
  41: 
  42: These choices are trade-offs. A zero or very short TTL may return almost all payload to the source; Long TTL can produce good hit and bad experience.
  43: 
  44: ## What is Stampede and how is it limited?
  45: 
  46: If a popular key entry expires and multiple concurrent requests all execute the loader, the cache duplicates it instead of deleting it. We call this situation Cache Stampede. Simultaneous expiration of many keys or restart of all replicas can also create a miss wave.
  47: 
  48: - **Request coalescing / singleflight:** Simultaneous requests of the same key share a running payload. This work is different from the global lock on all keys, and the expectation of followers must have a deadline.49:- **TTL jitter:** Play the expiration time of different keys. If the freshness budget is at most 30 seconds, the `random(24,30)` instance will not reject it; Adding positive jitter up to 40 seconds changes the contract. Jitter alone will not stop a hot key stampede.
  50: - **Soft expiry:** Data is fresh until `freshUntil`; Until `staleUntil` only if stale is allowed, the previous response is provided and a refresh is initiated. After the ceiling, we wait for a limited refresh or throw a controlled error.
  51: - **resource capacity limit:** concurrency limit and deadline for loading, even if the cache is disconnected. background refresh also consumes the same capacity.
  52: 
  53: Operational experience [Amazon about request coalescing and cold cache behavior] (https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) is a good support for these choices. Local coalescing on ten replicas can produce up to ten simultaneous loads; If this value is high, coordination between replicas or another method is required.
  54: 
  55: ## Solved example: soft and hard deadline for a general explanation
  56: 
  57: **TRAINING SCENARIO, NOT RECOMMENDED SETUP FOR ALL SERVICES:** General description of the item is taken from the official source at `t=0`. The product accepts 30 seconds of fresh reuse and a maximum of 15 seconds of additional stale when refreshing. We have not used this agreement for final pricing or access licenses.
  58: 
  59: <div dir="ltr" align="left">
  60: 
  61:```text
  62: entry = { value, sourceVersion, freshUntil: 30, staleUntil: 45 }
  63: 
  64: function getDescription(key, requestDeadline):
  65:     entry = cache.getEnvelope(key)
  66:     if entry.exists and now < entry.freshUntil:
  67:         return entry.value
  68:     if entry.exists and now < entry.staleUntil:
  69:         startRefreshOncePerKey(key)  # bounded, shared inside this process
  70:         return entry.value         # allowed stale, counted separately
  71:     return awaitLoadOncePerKey(key, requestDeadline)
  72:     # If load fails or deadline expires: return a defined error/degraded result.
  73: ```74: 
  75: </div>
  76: 
  77: In `t=32`, twenty reads at the same time inside **one process** can get the previous version immediately and have a refresh. If refresh succeeds in `t=34`, the new envelope is created from valid data. If the refreshes fail, `t=46` is no longer allowed to provide the same version based on this contract; We should expect bounded or error defined. `staleUntil` does not renew with any refresh errors. In order for stale data to be presented, the value must remain in storage until the hard deadline; Physical deletion in soft expiry eliminates this possibility.
  78: 
  79: In HTTP, the close concept is expressed by `Cache-Control: max-age=30, stale-while-revalidate=15`; Support and other response commands should be checked. The HTTP header does not automatically generate the internal cache logic `startRefreshOncePerKey`. The definition of this extension and `stale-if-error` is in [RFC 5861] (https://www.rfc-editor.org/rfc/rfc5861.html); Don't confuse two independent windows with "allow stale forever".
  80: 
  81: ## race and lease: Why is a lock not enough?
  82: 
  83: Reader A reads version 7, writer B commits version 8 and invalidates the cache, then A fills version 7. TTL limits the effect but does not eliminate the violation. One way to design is a comparable generation/version with data and atomic control of the fill license. Checking the copy and then writing in two independent actions again has race; Deleting the key can also delete the version information needed to reject the old fill. This part requires a specific writer and storage convention, not just adding the `version` field to the JSON.
  84: 
  85: For coalescing between replicas, you may take a time-limited lease. `SET lock:key token NX PX ...` is a primitive, not a full proof of coordination: the owner must have a unique token, the release must be done atomically only with the same owner's token, and the old loader must not be able to overwrite the new data after the lease ends. Consider long process stoppage and failover. [Redis documentation on distributed locks](https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/) describes assumptions and boundaries; Use checked library/scheme to reduce cache load and don't lock to ensure business transaction integrity.
  86: 
  87: ## Small exercise and expected observation
  88: 
  89: 1. Write `0, 29, 32, 44, 46` on the time line, the answer is fresh, stale allowed, or requires loading. Suppose refresh always fails.
  90: 
  91:2. Twenty reads in `t=32` Analyze a process once with coalescing and once without it.
  92: 
  93:3. Distribute the same twenty requests among five replicas without shared coordination.
  94: 
  95: 4. For 100 keys all filled in `t=0`, compare the fixed TTL of 30 with the selected TTL of 24 to 30. Infer about **a** very popular key separately.
  96:97: **Expectation:** Fresh on 29, stale allowed on 32 and 44, and out the window on 46. In a process with coalescing, one refresh is enough; Without it, up to 20 loaders may run. At five replicas, local coalescing allows up to five refreshes. jitter broadcasts the expiration wave of different keys, but does not aggregate the time of a hot key at the same time. These are path counts in the model, not production measurements.
  98: 
  99: ## Documented public experience: TTL proportional to data time in Netflix
 100: 
 101: > [Netflix TechBlog, April 6, 2026] (https://netflixtechblog.com/stop-answering-the-same-question-twice-interval-aware-caching-for-druid-at-netflix-scale-22fadc9b840e) describes an **experimental** interval-aware layer for Druid dashboard queries. The team has consciously adopted a five-second finite aging for the most recent data, and a longer TTL for older ones; late-arriving events play a role in this choice. A witness is related to dashboards in the same environment, not a payment rule or access authorization. Learning Outcome: TTL should be consistent with the meaning of time and consumer tolerance; Do not transfer the numbers of that report to another system without checking.
 102: 
 103: ## failure mode and operation signal
 104: 
 105: Failure Sign | Review action
 106: --- | --- | --- |
 107: Expiration wave Mutation miss, loader concurrency and p99 Expiry dispersion, coalescing and resource limitation
 108: endless stale | The data age grows but the hit remains high hard deadline, stale counter and last successful refresh
 109: Delayed cancellation event lag and version difference The path of commit/release/consume and retry
 110: cache error as not-found No fake data after timeout Differentiation of error, miss and lack of certainty
 111: eviction before TTL | Increase miss in memory pressure Working set size and eviction policy
 112: Expired lease and late fill Back the old version after the new refresh token, generation control and reject old write
 113: 
 114: ## operational checklist
 115: 
 116: - [ ] The budget for the novelty of each type of data and permission for stale is separate and explicit.
 117: - [ ] Data age, source version and the time of the last successful refresh are visible.
 118: - [ ] TTL, soft deadline and physical maintenance are compatible.
 119: - [ ] Direct and derived keys are seen in Abtal.
 120: - [ ] The error of delete/publish event after commit has a compensation path.
 121:- [ ] Simultaneous loading of a key and collective expiration of keys are checked separately.
 122: - [ ] jitter does not exceed the maximum allowable obsolescence.
 123: - [ ] coalescing, deadline, concurrency ceiling and behavior after hard expiry are specified.
 124:- [ ] cache failure, message interrupt and late loader are designed with failure model.
 125: 
 126: ## test
 127: 
 128: 1. What is the difference between expiration and eviction?
 129: 
 130:2. Why doesn't `fetchedAt=now` prove that the data is the latest commit of the source?
 131: 
 132: 3. Does a TTL of 30 with positive jitter of 15 still maintain the 30 second ceiling?
 133: 
 134: 4. In the example, if refresh fails every time, is the same version allowed in `t=46`?
 135: 
 136:5. How many loaders does a local singleflight on five replicas necessarily have in common?
 137:138: 6. Why is it dangerous to release the lock with `DEL` without checking the token?
 139: 
 140:7. What problem does adding `version` to fill's uncontrollable atomic value not solve?
 141: 
 142: ### descriptive answer
 143: 
 144:1. expiration comes from input lifetime and eviction comes from memory/capacity policy; The latter can happen sooner. We do not guarantee attendance until the end of TTL.
 145: 
 146: 2. Maybe the reading resource is lagging; The fetch time alone does not prove the actual age or version of the source.
 147: 
 148: 3. No; The time of use may reach 45. For a ceiling of 30, the jitter range must remain within the same ceiling or the product contract will be explicitly changed.
 149: 
 150:4. No; Hard deadline is equal to 45. Automatic renewal on every failure makes the stale indefinite and is against the example contract.
 151: 
 152:5. Not necessarily one; We may have up to one loader per replica, i.e. five. Coordination between replicas requires another contract.
 153: 
 154: 6. The previous lease may have expired and the new owner has taken the lock; The old owner deletes another lock with DEL. Ownership checking and deletion must be atomic.
 155: 
 156: 7. race remains between version checking and writing; Old fill can come back after cancellation/new version. The license to publish the result and the behavior of the writers should really be coordinated.
 157: 
 158: ## Suggested sources
 159: 
 160: - English, official documentation: [Redis EXPIRE](https://redis.io/docs/latest/commands/expire/), [SET](https://redis.io/docs/latest/commands/set/) and [Key eviction](https://redis.io/docs/latest/develop/reference/eviction/), for the exact meaning of expiration and capacity.
 161: - English, HTTP convention: [RFC 5861](https://www.rfc-editor.org/rfc/rfc5861.html), for stale-while-revalidate and stale-if-error; This RFC is informational and product support should be reviewed separately.
 162: - English, coordination design: [Redis distributed locks](https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/), for token, lease and safety assumptions.
 163: - English, Engineering evidence: [Amazon caching challenges](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) and [Netflix interval-aware caching](https://netflixtechblog.com/stop-answering-the-same-question-twice-interval-aware-caching-for-druid-at-netflix-scale-22fadc9b840e), for cold cache, coalescing and data-dependent recency selection.
 164: - Farsi, educational review: [Net Paradise: TTL, Abtal and Cache Stampede] (https://netparadis.com/redis-data-types-caching-strategy/), to familiarize with vocabulary and examples; Do not replace the sample code with the complete distributed coordination scheme.
 165: 
 166: [Chapter List](../README.md) · [Collection List](../../README.md) · [Previous Lesson: Multilevel Cache](../03-multi-level-caching/README.md) · [Related: Background Work](../../03-asynchronism/01-background-jobs/README.md) · [Related: Monitoring](../../07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) · [Related: Performance Test](../../09-performance-testing/01-load-testing-and-regression-benchmarks/README.md)
 167: 
 168: </div>