# 10.3 — CDN for Shareable Static and Frequently Used Content

**Language:** English · [فارسی](README.md)

**Learning goal:** Analyze cache Hit/Miss and the Origin path, define edge-cache keys and freshness, and separate public responses from personalized ones. Prerequisites: HTTP caching and access control. Sources reviewed: **2026-11-11**; examples are hypothetical and were not run.

## Mental model and content selection

A CDN has edge delivery points. A cacheable response may be delivered by an edge; on a Miss it may go to the Origin. Edge selection depends on network and provider; the geographically nearest point is not guaranteed. Even uncacheable traffic may pass through an edge proxy, but do not confuse that benefit with a cache hit.

| Response | Policy to consider | Risk |
| --- | --- | --- |
| Public, versioned image/CSS URL | Long TTL and a new URL when content changes | Changed content served under the same versioned URL |
| Identical public catalog | Limited TTL, validation, and invalidation | Stale price/stock or locale/currency mismatch |
| Order, account, and personal data | Exclude from shared cache; use an explicit private policy | Leakage across users/tenants |
| Download requiring permission | Reviewed access control and dedicated policy | Cache Hit without required authorization |

For each route, identify the inputs that affect its response: host/path, query, language, currency, tenant, and identity. Omitting an effective input from the cache key can produce the wrong response; adding every Cookie to the key can destroy hit rate and expose more sensitive metadata. For personal data, a clear secure bypass is often simpler than an identity-aware shared cache. Being frequently requested does not grant permission to share the response.

## Design the cache key step by step

Answer these questions in order for each response:

1. **Is this response the same and authorized for more than one user?** If it depends on identity, order ownership, permission, or a secret, do not treat it as public. Enable shared caching only under clear, tested rules.
2. **Which inputs change the body or headers?** Check path, query, language, currency, encoding, tenant, and product variant. Derive the list from endpoint logic and actual responses, not from how the URL looks.
3. **Represent those differences in the cache mechanism.** For HTTP, `Vary` makes the named request headers part of matching; a CDN may also have a separate custom cache key. An origin `Vary` header does not prove that a custom CDN rule honors it.
4. **Model freshness and change.** How long may the response be stale? Is there a validator? When do you use a versioned URL or purge? A longer TTL can reduce Origin load but weakens freshness.
5. **Check the real path with two identities/two variants.** First cause a Miss, then send equivalent and different requests. Compare status, headers, body, effective cache key, `Age`/hit headers, and Origin calls.

Mental example: if `/catalog/42` has different bodies by language and currency, a `fa/IRR` request after a Miss can create the Persian/rial variant; `en/USD` must not receive that variant. A later `fa/IRR` request is a correct Hit only if the content is fresh and sharing is allowed. If `/account/orders/81` depends on identity, putting the user ID into a shared key and hoping the rule is safe does not replace a private/bypass policy and authorization.

## Freshness and header example

[RFC 9111](https://www.rfc-editor.org/rfc/rfc9111.html) defines storage and reuse rules: `private` restricts shared caches, `no-store` prevents storage, and `no-cache` means validation is required before reuse, not “never store.” Requests with Authorization have special shared-cache conditions; do not rely on default rules or the presence of a Cookie as a confidentiality guarantee. The `Set-Cookie` field alone does not prohibit caching under the standard; inspect the actual CDN configuration too.

The following **educational** snippet shows response fields; the status line is intentionally omitted so it does not imply a particular HTTP wire format:

```text
# Public, content-versioned asset: /assets/catalog.a1b2c3.css
Cache-Control: public, max-age=31536000
Content-Type: text/css

# Personalized order response: /account/orders/81
Cache-Control: private, no-store
Content-Type: application/json
```

These are two different responses, not two policies for one response. An edge policy must not bypass `no-store` with a general “cache everything” rule. For compressed or language-specific public content, configured `Vary` and cache keys must distinguish the actual variants; verify support in the CDN you use. ETag/Last-Modified help with validation; a 304 still takes a round trip. TTL is not a promise of permanent retention; eviction can cause an earlier Miss. Purging an edge does not automatically remove a fresh browser copy; coordinate versioned URLs with rollout and old-version retention.

## Numerical example and exercise

The **hypothetical** model has 1,000 requests/s: 800 requests for public assets and 200 personal requests that bypass cache. Hit ratio is 90% only among cache-eligible requests. Origin load is `800*0.1+200=280 requests/s`; 720 requests do not reach Origin, not 900. Revalidation, background refresh, and retries are omitted. Byte-hit and request-hit ratios are also different metrics.

**Exercise:** Reduce eligible-request Hits to 50% and analyze a broad purge during a deployment. **Expected:** the simple Origin load becomes `800*0.5+200=600 requests/s`, and it can reach 1,000 when cold. Check TTL, refresh/collapse controls, and Origin capacity. On paper, follow two users and two currencies through Miss and then Hit; no user’s account response may reach another. What freshness budget does a mid-TTL price change require?

**Exercise solution:** At a 50% hit ratio, 400 of the 800 public requests are Hits and 400 are Misses; plus 200 personal bypasses, Origin gets `400+200=600 requests/s`. After purge, all 800 public requests may reach Origin for a time; if they arrive together, check burst capacity or refresh/collapse behavior. Each currency needs an independent variant. The two users must never see each other’s private order response in any Miss/Hit sequence. A public price needs a product freshness policy; choose TTL from the need and tolerated staleness, not a universal number.

## Public evidence and its limits

The [Cloudflare VSCO customer story](https://www.cloudflare.com/en-au/case-studies/vsco/) reports, quoting its CTO, a **sixfold improvement in network performance in the weakest markets** and latency falling from over three seconds to under 500 ms after Cloudflare was placed in front of its APIs. This is a customer claim on the provider’s site; it does not fully present a controlled benchmark method or separate the contributions of routing, caching, and other changes, and it has not been independently reproduced here. Do not generalize it to every market, API, or static cache hit. The exact publication date was not clear; access was checked on 2026-11-11. The hypothetical 280 requests/s model above is independent of this report.

## Failures and operational checklist

A high hit ratio with wrong responses is not success. Sudden Misses, increased Origin load, variant errors, stale content after deployment, and shared personal responses are signals to investigate. Also assess transfer cost, invalidation, and fallback behavior during CDN disruption; a sudden fallback must have capacity.

- [ ] Public/personal routes and inputs affecting responses are identified.
- [ ] Real cache key, query, Vary, Cookie, and Authorization behavior is checked.
- [ ] TTL, validation, purge, versioned URLs, and rollout owner are defined.
- [ ] Requests for two users/tenants/languages/currencies take correct Hit and Miss paths.
- [ ] Request-hit, byte-hit, age, Origin latency/traffic, and errors are recorded separately.
- [ ] Cold-cache capacity, concurrent refresh, and fallback have been analyzed.

## Self-check

1. Is a frequently requested personal response safe for shared caching just because it repeats?
2. What is the difference between `no-cache` and `no-store`?
3. In the model, why is Origin load not 100 requests/s?
4. What can happen if currency changes the response but is absent from the key?
5. Why might purging a CDN fail to refresh the browser’s copy?
6. What cannot be inferred from VSCO’s sixfold result?

### Answers with reasoning

1. No. Sharing requires an authorization and isolation contract; repetition does not change confidentiality.
2. The first does not necessarily prohibit storage but requires validation before reuse; the second directs caches not to store.
3. There are 200 personal bypass requests and 80 public misses; 90% applies only to the 800 cache-eligible requests.
4. One currency’s version could be delivered to a consumer using another; key correctness is part of response correctness.
5. The browser has an independent cache; a still-fresh version is not removed by an edge purge, so URL and rollout policy must be coordinated.
6. A fixed improvement for all APIs or the independent contribution of caching. Workload, market, and simultaneous changes matter.

## Further reading

- **Persian:** [CDN in architecture notes](https://github.com/OmidHaqi/software-architecture-course-notes/blob/main/05-architectural-building-blocks/04-cdn.md): introduction to Edge, Pull/Push, and TTL; educational notes do not guarantee the nearest edge or confidentiality.
- **Persian, supplementary:** [CDN versus hosting](https://wordpresskar.ir/post/cdn-vs-hosting-for-site-speed/): separates Origin cost from edge delivery; the author’s experience has not been independently reproduced.
- **English, standard:** [RFC 9111](https://www.rfc-editor.org/rfc/rfc9111.html): normative HTTP caching reference; read product-specific rules separately.
- **English, official:** [Cloudflare Cache Rules](https://developers.cloudflare.com/cache/how-to/cache-rules/): example of eligibility, TTL, custom keys, and rules for one CDN product; Cloudflare-specific.
- **English, official:** [Cloudflare CDN-Cache-Control](https://developers.cloudflare.com/cache/concepts/cdn-cache-control/): distinguishes Cache-Control for browsers/intermediaries from the CDN-specific field and describes that service’s rule priorities.
- **English:** [HTTP caching guide — MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching): educational model for private/shared cache, validation, and freshness.
- **English, customer evidence:** [VSCO customer story](https://www.cloudflare.com/en-au/case-studies/vsco/): attributed claim limited to the reported context, not a general benchmark.

**Navigation:** [Chapter index](../README.en.md) · [Package index](../../README.en.md) · [Previous: Connection reuse](../02-connection-reuse/README.en.md) · [Next: Prefetch/Preload](../04-prefetch-and-preload/README.en.md)

**Related:** [Cache layers](../../01-caching/01-cache-layers/README.en.md) · [Freshness and invalidation](../../01-caching/04-invalidation-and-freshness/README.en.md) · [Compression](../../02-api-response/02-response-compression/README.en.md)
