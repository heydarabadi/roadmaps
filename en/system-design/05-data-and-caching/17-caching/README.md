# Cache Strategies

[فارسی](../../../../fa/system-design/05-data-and-caching/17-caching/README.md)

## Learning goals

- Identify which layer should cache a value and what freshness is allowed.
- Compare cache-aside, write-through, write-behind, and refresh-ahead.
- Prevent stampedes, penetration, and mass-expiration problems.
- Measure cache benefit without overlooking stale or private data.

## Central idea

A cache keeps data closer to the consumer. Its latency benefit must be weighed against stale values, invalidation, misses, and stampedes.

## Concept map

Read request → cache hit/miss → source-of-truth read or write → expiry/invalidation → observed freshness and load.

## Detailed lesson

### Where can a cache live?

A cache may live in a browser, CDN, reverse proxy, application process, or shared datastore such as Redis. Every layer has different latency, capacity, scope, and freshness behavior.

A local cache is very fast but can differ between application instances. A distributed cache is shared but adds a network hop, availability dependency, and cost. Before choosing, measure hit rate, miss penalty, working-set size, and freshness needs.

### Four common patterns

**Cache-aside:** The application checks the cache; on a miss it reads the source and fills the cache. This is simple and suits many read-heavy paths, but concurrent misses can create a stampede and invalidation needs a policy.

**Write-through:** The application updates the source and cache as part of the write path. This can improve read-after-write freshness, but it raises write cost and does not make two stores atomically consistent. A failure after one write needs reconciliation or versioning.

**Write-behind:** The application writes the cache first and flushes to durable storage later. It can reduce write latency, but a crash before the flush can lose accepted data. Do not use this for a critical payment or ledger path without strong durability and replay guarantees.

**Refresh-ahead:** Refresh hot data before it expires. This can keep popular reads fast, but refreshing cold or unnecessary keys wastes resources. Refreshes should be limited and spread over time.

### TTL, invalidation, and eviction

TTL sets the maximum lifetime of an entry. A long TTL can make responses stale; a short TTL can reduce hits and send more reads to the source.

Invalidation removes an old entry after an update; versioned keys can avoid reusing it. Eviction selects entries when memory is full. LRU favors recently used values; LFU favors frequently used values; other policies may account for size or cost.

A hot key, oversized working set, or unbounded object size can make a cache ineffective.

### Stampede, penetration, and avalanche

A **stampede** occurs when many requests miss the same hot key at once. Single-flight or a bounded lock, jittered expiry, and stale-while-revalidate can reduce duplicate source work.

**Cache penetration** is repeated traffic for keys that do not exist. Short-lived negative caching and rate limiting can help.

A **cache avalanche** occurs when many keys expire together. Randomize expiration times and warm caches gradually. Distributed locks also need timeouts and recovery behavior.

### Consistency and security

Do not rely on a cache for a decision that cannot use stale information. A store can cache a product page, then revalidate price and inventory against authoritative workflows before accepting an order.

A cache key must include the tenant, language, or scope needed to separate responses. Serving a private response from a shared cache is a security failure. Encrypt sensitive data where appropriate, keep retention limited, and restrict access.

### Measure whether caching helps

Track hit ratio, hit/miss latency, source load, memory cost, evictions, stale-response rate, and errors. A high hit ratio that serves incorrect data is not a success.

Compare an endpoint with and without caching in cold and warm states. Also test purge, deployment of a new version, and cache unavailability.

## Worked example

Cache catalog details with a short freshness window. At checkout, recheck price and available inventory with the authoritative data path.

## Example cache-aside flow

~~~text
value = cache.get(key)
if value is missing:
    value = source.read(key)
    cache.set(key, value, ttl=60 seconds)
return value
~~~

Production code must also handle simultaneous misses, failed source reads, and invalidation races.

## Public engineering case study

[Cloudflare: Cache Response Rules](https://blog.cloudflare.com/introducing-cache-response-rules/) discusses cache-control decisions at the edge. Relate the policy to your own freshness and privacy contract.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Cache-aside | Repeated reads can tolerate a defined freshness window | Invalidation race or a hot miss can overload the source |
| Write-through | Reads should see recent writes and the added write cost is acceptable | Cache and source may disagree after a partial failure |
| Write-behind | Accepted updates can be delayed and safely replayed | A crash can lose changes not yet persisted |
| Refresh-ahead | A small set of hot keys justifies proactive refresh | Unnecessary refreshes waste capacity |

## Common pitfalls

- Stampedes after popular keys expire.
- Stale write racing with cache invalidation.
- Cache keys that omit tenant or privacy scope.
- Unbounded memory or object size.
- Treating cache availability as guaranteed.
- Using write-behind for data that cannot be reconstructed.

## Short quiz

1. When does cache-aside read the source?
2. What is the main risk of write-behind?
3. Name two ways to reduce a stampede.
4. Why is key design a security concern?

### Answer key

1. On a cache miss; the application loads the value and commonly stores it.
2. A crash before durable flush can lose a value the system already accepted.
3. Single-flight/bounded lock, expiry jitter, stale-while-revalidate, or rate-limited filling.
4. Omitting tenant or user scope can let one person receive another person’s private response.

## Exercise

Set cache policies for a product image, product description, inventory, and private cart. Define key, TTL, invalidation/revalidation, stale behavior, source protection, and a test that proves one tenant cannot see another tenant’s response.

## Summary

Caching improves a measured read path only when freshness, invalidation, privacy, and failure behavior are designed. Define the cache contract as carefully as the source-of-truth contract.

## Further reading

- [Azure Cache-Aside pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside) — cache population and invalidation trade-offs.
- [Redis: Client-side caching](https://redis.io/docs/latest/develop/use/client-side-caching/) — client cache tracking and invalidation behavior.
- [Cloudflare Cache documentation](https://developers.cloudflare.com/cache/) — edge cache controls.
- [RFC 9111: HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111) — normative HTTP cache behavior.
- [Cloudflare: Cache response rules](https://blog.cloudflare.com/introducing-cache-response-rules/) — practical edge-cache article.
