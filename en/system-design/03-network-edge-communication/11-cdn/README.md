# Content Delivery Networks

[فارسی](../../../../fa/system-design/03-network-edge-communication/11-cdn/README.md)

## Learning goals

- Explain how an edge cache reduces distance to a user and origin load.
- Compare pull caching with pre-positioned or pushed content.
- Design cache keys and freshness rules that protect user data.
- Recognize cache misses, expiry storms, and origin protection needs.

## Central idea

A CDN serves cacheable content near users to reduce round-trip time and origin load. Cache policy, invalidation, and isolation of private data are core parts of the design.

## Concept map

Client request → nearby point of presence → cache hit or miss → origin fetch → freshness, revalidation, and invalidation.

## Detailed lesson

### What a CDN places near the user

A CDN operates points of presence (PoPs) around the network. A request is routed to an edge location that can serve a cached response. On a cache hit, the origin is not contacted. On a miss, the edge fetches from the origin and may store the response according to its policy.

This can reduce latency and origin bandwidth, and can protect the origin from some repeated traffic. Dynamic or personalized responses are not automatically cacheable; they need explicit correctness and privacy rules.

### Pull versus push

With a pull CDN, the edge fetches content from the origin on the first miss and fetches again after expiry or purge. This suits content whose URL and change cadence are known but which does not need to be preloaded everywhere.

With push or pre-positioning, content is uploaded or distributed before a user requests it. This can reduce the first-request miss for a planned video launch or campaign. It creates more work to manage updates, deletions, and older versions.

### Design the cache key

A cache key can include host, path, selected query parameters, and selected headers. If the response changes by language, compression, tenant, or cookie, that dimension must be included safely or the response should not be shared.

A key with too many dimensions reduces cache hit ratio. A key that omits an important dimension can serve one user's response to another. Normalize irrelevant query parameters and use vary rules only for headers that truly change the response.

### Define freshness and revalidation

Cache-Control directives describe how caches may reuse a response. A long lifetime can work for a versioned public asset such as app.a83f.js: a new release uses a new URL. A price or inventory page needs a shorter freshness window or revalidation.

ETag and Last-Modified support conditional revalidation. A cache can ask whether content changed and avoid downloading an unchanged body. For a user's cart or a response protected by authorization, use private or no-store behavior as required by the data contract.

### Protect the origin from miss storms

When a popular key expires, many requests may reach the origin at once. Request collapsing, stale-while-revalidate behavior, expiry jitter, and an origin shield can reduce that burst. For large files, check range requests, object-size limits, and whether partial responses are cached as intended.

Restrict direct public access to the origin when appropriate; otherwise an attacker can bypass the CDN and exhaust the backend.

### Security and observability

Cache behavior must match identity and authorization rules. Do not cache a private response based on a shared key that ignores its user or tenant context. Signed URLs and authorization headers need careful cache policy.

Hit ratio alone is not success. Measure stale response rates, origin errors, purge delay, egress cost, and privacy correctness. Test with two users or tenants to verify that one cannot receive the other's cached response.

## Worked example

Cache a public product image with a versioned URL for a long time. Do not publicly cache a shopping cart keyed only by its path if the response varies by the shopper's cookie.

## Example policy

~~~http
Cache-Control: public, max-age=31536000, immutable
~~~

Use a year-long immutable policy only for public assets whose URL changes when their contents change.

## Public engineering case study

[Cloudflare: Cache Response Rules](https://blog.cloudflare.com/introducing-cache-response-rules/) describes control over cache policy using origin responses. Compare the article’s context with your own rules for freshness, privacy, and invalidation.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Pull cache | Content can be fetched on demand from a reliable origin | First miss and expiry can send a burst to the origin |
| Pre-position content | A launch or campaign has a known audience and timing | Update and deletion must reach every relevant location |
| Long TTL with versioned URLs | Public static content changes by release | Old versions may remain available until clients refresh |
| Cache API responses | The response is repeatable and freshness is explicit | Personalization or authorization may be leaked by an unsafe key |

## Common pitfalls

- Omitting a user or tenant dimension from the cache key.
- Caching private responses as public.
- Using purge as the only release mechanism when versioned URLs would be simpler.
- Allowing every concurrent miss to reach the origin.
- Exposing an unprotected origin that bypasses the CDN.
- Treating a high cache hit ratio as proof of correctness.

## Short quiz

1. How does pull caching differ from pre-positioning?
2. What belongs in a cache key?
3. Why can cookies create a privacy problem for shared caching?
4. What happens when many clients request the same expired hot key?

### Answer key

1. Pull fetches from the origin after a miss; pre-positioning distributes content before requests arrive.
2. Every request property that can change the response, such as host, path, selected query, or relevant headers.
3. A response personalized by a cookie can be served to another user if the cache key or policy ignores that identity.
4. The origin can receive a miss storm; request collapsing, stale serving, jitter, or an origin shield can reduce it.

## Exercise

Set cache policies for a product image, public item description, stock count, and private cart. For each, define cache key, TTL, revalidation or purge method, origin protection, and how you will test cross-user isolation.

## Summary

A CDN can lower request distance and reduce repeated origin work, but only when cache keys, freshness, invalidation, and privacy rules are correct. Cache the response contract, not merely the URL.

## Further reading

- [Cloudflare Learning: What is a CDN?](https://www.cloudflare.com/learning/cdn/what-is-a-cdn/) — CDN fundamentals.
- [Cloudflare Cache documentation](https://developers.cloudflare.com/cache/) — cache keys, TTL, and controls.
- [MDN: HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching) — HTTP cache semantics.
- [RFC 9111: HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111) — normative cache behavior.
- [Cloudflare: Cache response rules](https://blog.cloudflare.com/introducing-cache-response-rules/) — public engineering article.
