# Read-only Task 2 review supplement

## Snapshot: Backend Performance/01-caching/03-multi-level-caching/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: #01.3 — Multilevel caching and version coordination
   4: 
   5: **Resource check date: 2026-11-10** · Prerequisite: [cache patterns] (../02-cache-patterns/README.md), some sample programs and the difference between local and network memory.
   6: 
   7: ## learning objective and definition
   8: 
   9: After this lesson you can design the route `L1 → L2 → source`, calculate the hit of each level with the correct denominator and show why clearing the shared cache does not clear the memory of all processes. **multilevel cache** means multiple reuse locations in a row with different speed, size and scope of sharing. In this lesson, L1 is the local memory of the program and L2 is the shared cache on the network; These names do not refer to the CPU hardware cache.
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