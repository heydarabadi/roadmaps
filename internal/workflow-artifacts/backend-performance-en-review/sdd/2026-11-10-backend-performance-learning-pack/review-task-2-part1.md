# Read-only Task 2 review supplement

## Snapshot: Backend Performance/01-caching/01-cache-layers/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: #01.1 — Caching layers: HTTP, client, server and CDN
   4: 
   5: **Resource review date: 2026-11-10** · Prerequisite: path of an HTTP request and database concept · Suggested time: a study and practice session.
   6: 
   7: ## learning objective and definition
   8: 
   9: After this lesson, you can specify the storage location of the result in the request path, explain the difference between the response cache and the data cache, and write different policies for public and private responses. **Layer** is the place to store and reuse the result; **HTTP caching** is a convention of reusing the HTTP response and can be implemented in multiple locations. Therefore, HTTP, browser and CDN are not three independent technologies: browser and CDN can execute the same contract.
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