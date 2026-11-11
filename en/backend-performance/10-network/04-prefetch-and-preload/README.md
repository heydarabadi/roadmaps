# 10.4 — Prefetch and Preload: Start Earlier Within a Budget

**Language:** English · [فارسی](../../../../fa/backend-performance/10-network/04-prefetch-and-preload/README.md)

**Learning goal:** Distinguish early retrieval of a resource needed on this page from a guess about future need, measure potential benefit and wasted bytes, and limit speculative backend work. Prerequisites: HTTP caching, critical path, and deadline. Sources reviewed: **2026-11-11**; examples are educational and were not run.

## Mental model

Starting earlier shifts discovery or waiting time; it does not necessarily reduce the amount of data or work. An unused resource still consumes bandwidth, memory, battery, or Origin capacity. The [web.dev resource hints guide](https://web.dev/learn/performance/resource-hints) explains hints for different purposes:

| Mechanism | Intent | Example | Cost/limit |
| --- | --- | --- | --- |
| preload | A known, critical resource for this page that is discovered late | LCP image referenced from CSS | Competes with other critical resources; actual use should match the request |
| prefetch | A likely resource for a future navigation | Public document for the next guide step | The guess may be wrong; the browser may skip it |
| preconnect | Prepare a connection to an important Origin | Font host | Does not fetch content; the extra connection has a cost |
| Backend data prefetch | Prepare a likely read for the next step | Reconstructible shipping options | Query cost, freshness, permissions, and waste |

Preload does not by itself apply CSS or execute a script; the consumer still needs to request the resource. The URL, request type `as`, and CORS/credentials mode must match later use, or a duplicate download may happen. Fonts need the appropriate CORS pattern and `crossorigin` even when same-origin. JavaScript modules have `modulepreload`; do not assume one hint works for every resource type. Details are in [MDN preload](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/rel/preload).

### Use three checks to decide

1. **Is the resource critical to this page, or only perhaps needed later?** A definite need discovered late may be a `preload` candidate; a likely next path may be a `prefetch` candidate. Preparing a connection to an important origin without fetching content may call for `preconnect`.
2. **How much time is actually hidden?** Starting earlier can overlap part of the download with processing/rendering or the user’s navigation time. If the resource would have been discovered early anyway or downloaded in parallel, the added benefit is smaller. Total work time may not decrease; only time until the user sees content may improve.
3. **Does the speculation cost exceed its budget?** For preload, measure competition with more important page resources; for prefetch, measure probability of use before expiry, wasted bytes, cache pollution, data-use limits, and Origin pressure. Under overload, disable speculative work first.

A simple decision method measures both sides separately: (a) the share of encounters where the speculative resource is actually used and the waiting time hidden, and (b) unused bytes and changes to critical-resource performance. Do not subtract milliseconds from bytes without a product model; compare both with experience goals and network/device budgets.

## Browser example and selection order

Assume the static hero image is important content on this page but is discovered late from CSS; the next guide page is public and has no side effects:

```html
<link rel="preload" href="/assets/hero.a1b2c3.avif"
      as="image" type="image/avif" fetchpriority="high">
<link rel="prefetch" href="/guide/step-2.html">
<style>
  .hero { background-image: url('/assets/hero.a1b2c3.avif'); }
</style>
```

This example does not guarantee browser scheduling; in a real page the CSS might be a separate file. First use the waterfall to identify a critical resource discovered late. If the image is visible in HTML from the start, preload may add no value. For a responsive image, match the source to the viewport and actual request. Then evaluate only high-probability future needs under a separate budget. Browser behavior, cache partitioning, TTL, and data-saving settings can limit reuse; a prefetch download does not guarantee use on the next navigation.

## Numerical example and backend work

The **hypothetical** model prefetches a public 200 KiB resource for 100 users; 70 consume it before expiry. Speculative downloads total 20,000 KiB and unused downloads total 6,000 KiB, about 5.86 MiB. If each actual use hides 120 ms of waiting, the model’s total benefit is `70*120=8400 ms`, or 84 ms averaged across 100 encounters—not 120 ms for every user. This calculation excludes competition with the current page, which could reverse the benefit.

On the backend, after showing a cart, the application might read “shipping options” early; that data does not finalize a price or reserve inventory. This mechanism does not share one API with HTML prefetch. A conceptual policy:

```text
if likely_next_step and spare_capacity and speculative_budget_available:
    data = read_authorized_shipping_options(user_context, short_deadline)
    store_bounded(user_scoped_key(cart_version, address_version), data, short_ttl)

on_actual_checkout:
    recheck_authorization_and_versions()
    use_if_fresh_or_fetch_normally()
    validate_final_price_and_stock_at_commit()
```

Set separate limits for count/bytes, concurrency, and deadline on speculative work, and stop it under overload. Context and keys must retain user/tenant and input versions. If the user abandons the flow, cancel the work when there is no other consumer. Early retrieval must not create an order, payment, or state change; do not call a side-effecting endpoint to guess the next navigation. Permissions and real-operation rules are checked again.

## Use cases, exercise, and expected result

This is suitable for a critical resource discovered late or a predictable next path. It is a poor fit for a large, unlikely video; a personal API without a caching contract; a user with data limits; or a saturated downstream service. **Cache pollution** occurs when low-value speculative data evicts useful data; a higher hit ratio is not enough without measuring consumed bytes.

**Exercise:** Reduce the probability of use in the model from 70% to 20%. **Expected:** 80 unused resources total 16,000 KiB or 15.625 MiB; expected benefit averages only 24 ms per encounter. Then set a TTL shorter than the user’s time to the next page; a second download may erase the benefit. In a hypothetical waterfall, identify one useful preload and one prefetch that interferes with the LCP resource. These numbers are not a real experiment.

**Exercise solution:** Of 100 users, 20 consume the resource, leaving 80 wasted downloads: `80×200=16,000 KiB`, which at `1024 KiB/MiB` is about `15.625 MiB`. Expected time saved in the model is `0.20×120=24 ms` per encounter, not 120 ms for everyone. If TTL expires before navigation or the download competes with the LCP image, the benefit may be smaller; compare before/after waterfall, prefetch-use rate, LCP, and network bytes.

## Operational evidence and evidence limits

The [web.dev prefetch guide](https://web.dev/articles/link-prefetch) documents use for future navigation and the cost of extra bytes; [MDN preload](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/rel/preload) explains fetching before ordinary discovery. These are browser-operational references. This lesson does not provide a direct production study proving the 100-user scenario or backend shipping-options prefetch; examples are hypothetical and improvement is not guaranteed.

## Troubleshooting a real result

- If Network shows two downloads for one URL, compare URL, `as`, credentials/CORS, redirects, and responsive variants between preload and its consumer.
- If a preload is reported as unused, the resource may not be critical or discovered late, or the consuming markup/route may not run in all cases; remove an unnecessary hint rather than keeping it without reason.
- If prefetch is unused, separate actual navigation rate, TTL, cache policy, user choice, and browser limits; starting a download is not the same as using it.
- If LCP or backend p99 worsens, compare priority, competing bandwidth, Origin consumption, speculative concurrency, and real-user load over the same interval. Reduce or stop the hint and establish a new baseline.

## Failure modes and checklist

Duplicate downloads for one URL, unused-preload warnings, egress growth, lower hits for useful data, worse p99 for real requests, and stale data are signals to investigate. Removing a hint must leave the base experience correct; users must not depend on an earlier guess to get the right answer.

- [ ] Preload is for known current-page needs; prefetch is for likely future needs.
- [ ] URL, `as`, CORS, and actual use match; target browsers are checked.
- [ ] Probability of use before expiry and useful/wasted bytes are recorded.
- [ ] Byte/time/concurrency caps and data-saving behavior exist.
- [ ] Speculative work is sacrificed under overload and does not take capacity from real work.
- [ ] Permissions, tenant, data version, and absence of side effects are preserved.
- [ ] LCP/next-step latency, errors, Origin cost, and cache pollution are assessed together.

## Self-check

1. Which hint is a candidate for a critical current-page image discovered late in CSS?
2. Does prefetch promise that the user will visit the next page?
3. Why can a mismatch in `as` or CORS add cost?
4. At 20% probability, how many KiB are wasted in the 100-user model?
5. Why do prefetched shipping options not authorize a final payment?
6. What should happen to speculative work if real-request p99 worsens under load?

### Answers with reasoning

1. `preload`: the need is known for this page, provided discovery delay is measured and the consumed resource matches.
2. No. It is a guess; the browser may not fetch it, and the cache may not be reusable later.
3. The consumer request may not match the initial fetch, causing a second download.
4. `80*200=16,000 KiB`; only 20 users consume it, so 80 resources are unused.
5. Data may be stale or the cart/address may have changed; authorization, price, and inventory rules must be checked during the real operation.
6. Limit or stop speculation and review its budget; speculative benefit must not consume capacity needed by real work.

## Further reading

- **Persian:** [Resource hints guide on web.dev](https://web.dev/learn/performance/resource-hints?hl=fa): Persian version of the same source; some terminology may read awkwardly, so consult the English names and source text alongside it.
- **English:** [web.dev Resource Hints](https://web.dev/learn/performance/resource-hints): distinguishes preload, prefetch, preconnect, and competition costs.
- **English:** [Prefetch future navigations](https://web.dev/articles/link-prefetch): use cases, byte costs, and browser behavior; check support and partitioning for your target version.
- **English:** [MDN preload](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/rel/preload): `as`, CORS, resource type, and request consumption.
- **English:** [Speculative loading — MDN](https://developer.mozilla.org/en-US/docs/Web/Performance/Guides/Speculative_loading): compares preconnect, preload, prefetch, and browser storage behavior.
- **English:** [103 Early Hints — MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/103): relationship between a 103 response and sending a Link preload before the final response.
- **English, standard:** [RFC 8297 — Early Hints](https://www.rfc-editor.org/rfc/rfc8297.html): meaning and protocol limits of status code 103; it does not guarantee browser scheduling decisions.

**Navigation:** [Chapter index](../README.en.md) · [Package index](../../README.en.md) · [Previous: CDN](../03-cdn-for-static-and-frequent-content/README.en.md)

**Related:** [Background jobs](../../03-asynchronism/01-background-jobs/README.en.md) · [Cache freshness](../../01-caching/04-invalidation-and-freshness/README.en.md) · [Critical path](../../06-code-optimization/04-critical-paths/README.en.md)
