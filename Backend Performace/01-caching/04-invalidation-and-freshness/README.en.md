<div dir="ltr" align="left">

[فارسی](README.md) | **English**

# 01.4 — Invalidation, Freshness, TTL, and Preventing Cache Stampedes

**Sources reviewed: 2026-11-10** · Prerequisites: [Cache-aside](../02-cache-patterns/README.en.md), [multi-level caching](../03-multi-level-caching/README.en.md), deadlines, and concurrency.

## Learning objective and definition

After this lesson, you can separate a staleness budget from physical retention, combine TTL with event-driven invalidation, and limit a burst of concurrent reads after expiry. **Freshness** means the result is within the product’s freshness contract; **invalidation** declares a version invalid; **TTL** is the retention/validity period defined by the cache contract. TTL in a key/value cache is not exactly the same as HTTP response freshness; make the intended meaning explicit.

## Terms used in this lesson

A **deadline** is the latest time an operation or result remains acceptable under its contract. **Concurrency** is the number of loader operations active at once. **Stale** is a copy outside the fresh interval that may still be permitted for limited use. This lesson separates permission to serve stale data from whether the bytes still physically exist.

## Mental model: three clocks and four events

For an entry, distinguish `sourceVersion` or source-change time, `fetchedAt`, and the deadline for using the copy. If data was fetched from a lagging read replica, `fetchedAt=now` does not prove it includes the latest commit. Also, “still in memory” does not mean “allowed to serve.”

| Event | What changes? | Correct meaning |
| --- | --- | --- |
| Expiration | The defined lifetime has ended | A later read may miss or require refresh |
| Eviction | Memory is reclaimed under capacity policy | It may happen before TTL ends |
| Invalidation | A version or dependent set is declared invalid | Usually after a source update or content publication |
| Refresh | Data is fetched/validated again | Success, failure, and cost must be observable |

Redis provides TTL using commands such as [EXPIRE](https://redis.io/docs/latest/commands/expire/); memory policy and [eviction](https://redis.io/docs/latest/develop/reference/eviction/) are separate. A long TTL does not guarantee the entry stays in memory that long. In Redis, `SET ... EX ...` can set a value and expiry in one command; two separate commands create a failure gap. A normal replacement using `SET` can also remove an earlier TTL; review the options in the [SET documentation](https://redis.io/docs/latest/commands/set/).

## Choosing freshness and invalidation policy

1. **Ask the product:** Can a product description be stale for a few seconds? Is that acceptable for revoked access or a final price? Define a separate contract for each data category.
2. **Find dependent keys:** A product change may affect the product key, category list, and search result. Deleting one key does not update them all.
3. **Define the update path:** Commit to the source, record a dependable change event if needed, then invalidate/refresh. Publishing before commit can cause a fill from the old version.
4. **Plan for failure:** Use fallback TTL, bounded retries, invalidation-lag tracking, and protection from stale fills. An outbox can coordinate an event with commit, but its consumer and retry behavior also need design.

| Policy | Often better for | Cost/limit |
| --- | --- | --- |
| TTL only | Data with tolerated staleness and simple writers | Old version may be visible until expiry |
| Invalidate after write + TTL | Frequently changed data needing a faster reaction | Message/delete can fail; dependent keys matter |
| Versioned key/URL | Immutable assets or snapshots | Consumers must discover new version; old versions need cleanup |
| Soft expiry with background refresh | Display data that permits bounded stale use | Stale use needs a hard limit; not allowed for all data |
| Authoritative read on the critical path | Decisions where staleness is unacceptable | Higher source/transaction cost; separate display cache may still be possible |

These are trade-offs. Zero or very short TTL may send nearly all load back to the source; long TTL can produce high hit rate and incorrect user experience.

## What is a stampede and how can it be limited?

If many concurrent requests all run the loader when a popular key expires, the cache has multiplied repeated work instead of removing it. This is a **cache stampede**. Simultaneous expiry of many keys or restarting every replica can also create a miss wave.

- **Request coalescing/singleflight:** Concurrent requests for one key share one in-flight load. This differs from a global lock across every key; followers need a deadline.
- **TTL jitter:** Spread expirations across keys. If the maximum freshness budget is 30 seconds, a sample of `random(24,30)` stays within it; adding positive jitter to 40 seconds changes the contract. Jitter alone does not stop a stampede on one hot key.
- **Soft expiry:** Data is fresh until `freshUntil`; until `staleUntil`, return the old value only if stale is permitted and start one refresh. Beyond that cap, wait for a bounded refresh or return a defined error.
- **Source capacity limit:** Apply concurrency and deadlines to loads even when cache is unavailable. Background refresh consumes the same capacity.

[Amazon’s operational discussion of request coalescing and cold caches](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) supports these choices. Local coalescing across ten replicas may still allow ten loads; if that is too many, use cross-replica coordination or another design.

## Worked example: soft and hard deadlines for a public description

**Illustrative scenario, not a universal configuration:** The trusted source provides a public product description at `t=0`. The product permits 30 seconds of fresh reuse and at most 15 additional seconds of stale service during refresh. This contract is not used for a final price or access decision.

<div dir="ltr" align="left">

```text
entry = { value, sourceVersion, freshUntil: 30, staleUntil: 45 }

function getDescription(key, requestDeadline):
    entry = cache.getEnvelope(key)
    if entry.exists and now < entry.freshUntil:
        return entry.value
    if entry.exists and now < entry.staleUntil:
        startRefreshOncePerKey(key)  # bounded, shared inside this process
        return entry.value         # allowed stale, counted separately
    return awaitLoadOncePerKey(key, requestDeadline)
    # If load fails or deadline expires: return a defined error/degraded result.
```

</div>

At `t=32`, twenty simultaneous reads in **one process** can return the old version immediately while starting one refresh. If refresh succeeds at `t=34`, it creates a new envelope from valid data. If refreshes fail, that same version is not permitted under this contract at `t=46`; wait a bounded time or return a defined error. Do not extend `staleUntil` after each refresh failure. To serve stale data, the value must remain in storage until the hard deadline; deleting it at soft expiry makes this impossible.

In HTTP, a related concept is expressed as `Cache-Control: max-age=30, stale-while-revalidate=15`; support and other response directives must be checked. An HTTP header does not by itself implement `startRefreshOncePerKey` for an internal cache. The extension and `stale-if-error` are defined in [RFC 5861](https://www.rfc-editor.org/rfc/rfc5861.html); do not confuse the two windows with permission to serve stale forever.

## Races and leases: why one lock is not enough

Reader A reads version 7; writer B commits version 8 and invalidates the cache; then A fills version 7. TTL limits the effect but does not remove the race. One design uses a comparable generation/version and atomic control over whether a fill may publish. Checking a version and writing in separate operations creates another race; deleting the key can remove the version needed to reject an old fill. This requires a contract among writers and storage, not merely adding a `version` field to JSON.

For cross-replica coalescing, you may acquire a time-limited lease. `SET lock:key token NX PX ...` is a primitive, not proof of complete coordination: the owner needs a unique token; release must atomically verify that the same owner holds the lock; and an old loader must not overwrite newer data after its lease ends. Consider long process pauses and failover. [Redis’s distributed-lock guide](https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/) explains assumptions and limits; use a reviewed design to reduce cache load, not as a substitute for business transaction correctness.

## Exercise and worked solution

1. On the timeline `0, 29, 32, 44, 46`, mark fresh, permitted stale, or load required. Assume every refresh fails.
2. Analyze 20 reads at `t=32` on one process with and without coalescing.
3. Distribute the same 20 requests across five replicas without shared coordination.
4. Compare fixed TTL 30 for 100 keys all filled at `t=0` with TTL randomly selected from 24 to 30. Separately analyze one very popular key.

**Expected:** At 29, data is fresh; at 32 and 44, stale is permitted; at 46, it is outside the window. With coalescing, one process needs one refresh; without it, up to 20 loaders may run. Across five replicas, local coalescing may allow five refreshes. Jitter spreads expiry among many keys but does not consolidate concurrent work for one hot key. These are counts in a model, not production measurements.

### Step-by-step solution

With a failed refresh: at seconds 0 and 29, the value is fresh; at 32 and 44 it is stale but permitted by the contract; at 46 it has passed the hard deadline, so use a bounded loader or controlled response. Singleflight reduces 20 loaders to one in one replica; without it, up to 20 source reads may occur. With five replicas and only local coalescing, the example permits up to five loaders. TTLs from 24 to 30 spread expiry across the 100 keys without exceeding the 30-second freshness limit; one hot key can still receive simultaneous reads and needs coalescing.

## Public engineering evidence: TTL based on data time at Netflix

> [Netflix TechBlog, April 6, 2026](https://netflixtechblog.com/stop-answering-the-same-question-twice-interval-aware-caching-for-druid-at-netflix-scale-22fadc9b840e) describes an **experimental** interval-aware layer for Druid dashboard queries. The team knowingly allowed five seconds of staleness for the newest data and used longer TTLs for older ranges; late-arriving events affected the choice. This is evidence from that dashboard environment, not a rule for payments or access rights. The lesson is that TTL should match data-time semantics and consumer tolerance; do not transfer those numbers without evaluation.

## Failure modes and operational signals

| Failure | Signal | Inspection action |
| --- | --- | --- |
| Expiry wave | Miss, loader concurrency, and p99 spike | Expiry distribution, coalescing, source limits |
| Stale data without limit | Data age grows while hit rate remains high | Hard deadline, stale counter, last successful refresh |
| Delayed invalidation | Event lag and version mismatch | Commit/publish/consume path and retries |
| Cache error treated as not-found | False absence after timeout | Distinguish error, miss, and confirmed absence |
| Eviction before TTL | More misses under memory pressure | Working-set size and eviction policy |
| Expired lease and late fill | Old version returns after a newer refresh | Token, generation control, reject stale writes |

## Operational checklist

- [ ] Freshness budget and stale permission are explicit for each data type.
- [ ] Data age, source version, and last successful refresh time are observable.
- [ ] TTL, soft deadline, and physical retention are consistent.
- [ ] Direct and derived keys are included in invalidation.
- [ ] Failed deletion/event publication after commit has a recovery path.
- [ ] Concurrent loads for one key and simultaneous expiry across keys are analyzed separately.
- [ ] Jitter does not exceed the maximum allowed staleness.
- [ ] Coalescing, deadlines, concurrency caps, and hard-expiry behavior are defined.
- [ ] Cache failure, message loss, and late loaders are included in failure design.

## Quiz

1. What is the difference between expiration and eviction?
2. Why does `fetchedAt=now` not prove that the data is the latest committed version?
3. Does TTL 30 with positive jitter of 15 seconds preserve a 30-second maximum?
4. In the example, if every refresh fails, is the same value permitted at `t=46`?
5. How many loaders does local singleflight across five replicas necessarily create?
6. Why is releasing a lock with `DEL` without checking the token dangerous?
7. What does adding `version` to the value without atomic fill control fail to solve?

### Explained answers

1. Expiration follows the entry’s age; eviction follows memory-capacity policy and may happen earlier. Presence until TTL is not guaranteed.
2. The read source may lag; fetch time, by itself, does not establish the source’s actual version or age.
3. No; the value may be reused until 45 seconds. To keep a 30-second cap, jitter must stay within it or the product contract must change explicitly.
4. No; its hard deadline is 45. Extending on every failure would make staleness unbounded and violate the example contract.
5. Not necessarily one total; up to one per replica, or five, may run. Cross-replica coordination is a separate contract.
6. The old lease may have ended and a new owner may hold the lock; the old owner can delete the new owner’s lock. Ownership check and deletion must be atomic.
7. The race between version check and write remains; an old fill can land after invalidation/newer version. Publication permission and writer behavior must actually be coordinated.

## Summary

TTL, eviction, and invalidation are different events. Measure freshness from source data to its use deadline and provide recovery after failed invalidation. Stampede control needs coalescing and source-load limits; jitter spreads expiration across keys but not one hot key, and stale permission needs a hard cap.

## Optional references and further reading

The time model, stale limits, and exercise answer are explained here. These links are optional technical references and further reading.

- English, official Redis documentation: [EXPIRE](https://redis.io/docs/latest/commands/expire/), [SET](https://redis.io/docs/latest/commands/set/), and [key eviction](https://redis.io/docs/latest/develop/reference/eviction/), for expiry and capacity behavior.
- English, HTTP contract: [RFC 5861](https://www.rfc-editor.org/rfc/rfc5861.html), for stale-while-revalidate and stale-if-error; it is an Informational RFC, and product support must be checked separately.
- English, coordination design: [Redis distributed locks](https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/), for tokens, leases, and safety assumptions.
- English, engineering evidence: [Amazon caching challenges](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) and [Netflix interval-aware caching](https://netflixtechblog.com/stop-answering-the-same-question-twice-interval-aware-caching-for-druid-at-netflix-scale-22fadc9b840e), for cold caches, coalescing, and data-aware freshness.
- Persian, supplementary guide: [Net Paradis: TTL, invalidation, and cache stampede](https://netparadis.com/redis-data-types-caching-strategy/), for terms and examples; do not use sample code as a complete distributed-coordination design.

[Chapter contents](../README.en.md) · [Course contents](../../README.en.md) · [Previous: Multi-level caching](../03-multi-level-caching/README.en.md) · [Related: Background jobs](../../03-asynchronism/01-background-jobs/README.en.md) · [Related: Monitoring](../../07-monitoring-and-logging/01-metrics-logs-and-traces/README.en.md) · [Related: Performance testing](../../09-performance-testing/01-load-testing-and-regression-benchmarks/README.en.md)

</div>
