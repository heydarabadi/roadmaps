<div dir="ltr" align="left">

[فارسی](README.md) | **English**

# Chapter 01 — Caching and Reusing Results

A cache stores a rebuildable copy of a response, data item, or computation for reuse. The central question is not “Where should we install Redis?” It is which repeated work we want to remove, how long a result remains acceptable, and what may happen when copies disagree. Users may wait less; the system may do less database and network work, provided we also account for cache maintenance and misses.

This chapter covers the four Caching topics in the [Backend Performance roadmap](https://roadmap.sh/backend-performance-best-practices). **Sources reviewed: 2026-11-10.** Examples are language-independent and illustrative; their numbers are neither company measurements nor universal capacity targets.

## Prerequisites and study path

Be familiar with HTTP requests and responses, database reads and writes, latency, percentiles, and running multiple instances of a service. Basic key/value knowledge is enough; installing Redis or having a cloud account is not required. Each lesson also defines its own essential terms and can be studied independently; topic links and external references are optional.

The lessons include self-contained explanations and examples. No service is needed for their exercises unless a page explicitly says otherwise.

| Order | Lesson | Question to answer |
| --- | --- | --- |
| 1 | [Cache layers: HTTP, client, server, and CDN](01-cache-layers/README.en.md) | Which part of the request can each layer remove? |
| 2 | [Cache-aside, read-through, and write-through patterns](02-cache-patterns/README.en.md) | Who populates the cache, and who coordinates with the source? |
| 3 | [Multi-level caching](03-multi-level-caching/README.en.md) | How do local and shared caches work together without losing track of versions? |
| 4 | [Invalidation, freshness, TTL, and preventing stampedes](04-invalidation-and-freshness/README.en.md) | How much staleness is acceptable, and what happens on expiry? |

In each lesson, read the model and example, do the exercise on paper or with a tool of your choice, then answer the quiz before viewing its answer key. Exercises are proposals; no execution in your environment is claimed.

## A chapter-long scenario

An educational catalog has three types of data: a versioned product image, a public product description, and a final order price. An image with a content-hash URL can be reused in a browser and CDN. A public description may use response and data caching with an explicit staleness budget. A final price requires source validation and transaction rules; a cached display copy alone does not authorize placing an order.

1. In Lesson 1, draw the request path and identify the owner of each cache.
2. In Lesson 2, choose Cache-aside for the product description and specify commit and invalidation.
3. In Lesson 3, add local L1 only if access to the shared cache is measurably costly, then simulate a lost invalidation message.
4. In Lesson 4, analyze simultaneous expiry of a popular product and a price update.

These choices are not a final architecture; evaluate them against your traffic, freshness needs, and source capacity. [Amazon’s caching challenges](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) provides operational examples of the risk of depending on a warm cache.

## Connections to other chapters

- [API responses](../02-api-response/README.en.md): response caching differs from reducing payload size; even a cache hit for a large response still transfers bytes.
- [Avoiding unnecessary server work](../02-api-response/04-avoid-unnecessary-server-work/README.en.md): conditional responses and reuse remove only some repeated work.
- [CDNs and frequent content](../10-network/03-cdn-for-static-and-frequent-content/README.en.md): study delivery location and CDN rules after learning the cache layers.
- [Regions and network latency](../10-network/01-region-and-network-latency/README.en.md): a closer cache is not necessarily a fresher cache; distance and freshness are separate concerns.
- [Monitoring](../07-monitoring-and-logging/01-metrics-logs-and-traces/README.en.md) and [performance testing](../09-performance-testing/01-load-testing-and-regression-benchmarks/README.en.md): measure hit ratio, data age, and cold/warm behavior alongside end-to-end latency.

## Chapter review checklist

- [ ] I can explain private browser caching, shared HTTP caching, and server data caching with examples.
- [ ] I know that `no-cache`, `no-store`, and `private` do not mean the same thing.
- [ ] The loader owner and write path are clear for each cache pattern.
- [ ] Cache keys account for every result-changing dimension and tenant separation.
- [ ] I measure hit/miss at every layer and actual requests to the source.
- [ ] The staleness budget, commit/invalidation path, and behavior during message loss are specified.
- [ ] I distinguish expiration, eviction, refresh, and manual invalidation.
- [ ] Hot keys, cold starts, cache failures, and concurrent load are bounded and observable.

[Back to course contents](../README.en.md) · [Start Lesson 1](01-cache-layers/README.en.md)

</div>
