# SPA, Server-Side Rendering, and Static Generation

## Learning goals

- Compare client-side rendering, server-side rendering, static generation, and hybrid rendering.
- Reason about first render, interactivity, caching, personalization, and deployment.
- Avoid hydration, stale data, and privacy mistakes.

## Rendering strategies

A Single Page Application (SPA) serves an application shell and renders most UI in the browser. It can support rich interaction and client navigation, but initial JavaScript download, device capability, and search or sharing needs may affect the first experience.

Server-side rendering (SSR) generates HTML for a request, then often hydrates it so client code can take over interaction. SSR can improve time to useful content, but it adds server execution, cache variation, and hydration complexity. Static site generation (SSG) builds pages ahead of time and serves them through a CDN. It is fast and inexpensive for content that changes predictably, but freshness and personalized data need a separate plan. Incremental or hybrid techniques combine these models by route or data source.

Rendering is not a binary SEO switch: crawlers, social previews, accessibility, latency, and user experience all have distinct requirements. Measure first content, interaction readiness, layout stability, and real-user performance. A fast HTML response can still produce a poor experience if large scripts block interaction.

## Caching and data boundaries

Public product descriptions may be cached broadly; account pages and carts are user-specific. Never put personalized HTML into a shared cache without a correct cache key and privacy review. In SSR, request-scoped credentials and user data must not leak through global mutable state. Define freshness, revalidation, and invalidation behavior; cache invalidation is part of correctness, not only speed.

Hydration requires server and client output to agree. Time-dependent values, random IDs, locale differences, and browser-only APIs can cause mismatch. Make data ownership and loading boundaries explicit and provide graceful loading/error states.

## Worked example: storefront

Generate public category and product descriptions statically or with revalidation. Keep price and inventory freshness requirements explicit; fetch personalized cart and account data after authentication through a private route or client request. Cache public assets at the edge while excluding user-specific responses.

## Self-check quiz

1. What does hydration do? Attaches client-side behavior to server-rendered markup.
2. Why can SSR leak data? Incorrect shared state or cache keys can mix responses across users.
3. When is SSG a strong fit? Content is public and can be built or revalidated within acceptable freshness limits.
4. What does the SPA model trade for interactivity? More work can shift to client JavaScript and affect initial loading.
5. Why measure real-user performance? Lab results may not represent devices, networks, and interaction patterns in production.

## Exercise

Select rendering and caching strategies for public product pages, inventory status, and a signed-in cart.

### Sample answer

Render public product descriptions statically with bounded revalidation. Fetch inventory from a freshness-appropriate endpoint or short-lived cache and display its timestamp/state. Render the cart privately for its authenticated owner with no shared cache. Measure page load and interaction on low-end devices, and verify that CDN cache keys never cross user boundaries.

## Further reading

- First-hand case: [Meta's Facebook.com rebuild](https://engineering.fb.com/2020/05/08/web/facebook-redesign/) discusses server rendering, streamed data, and client interactivity.
- English: [Next.js rendering strategies](https://nextjs.org/docs/app/building-your-application/rendering), [Nuxt rendering modes](https://nuxt.com/docs/guide/concepts/rendering), [web.dev: Rendering on the Web](https://web.dev/articles/rendering-on-the-web), [Google Search: JavaScript SEO basics](https://developers.google.com/search/docs/crawling-indexing/javascript/javascript-seo-basics), [MDN: Client-side versus server-side rendering](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Frameworks_libraries/Client-side_frameworks/Introduction), [OWASP Web Cache Deception guidance](https://owasp.org/www-community/attacks/Web_Cache_Deception)
- Persian: [MDN فارسی](https://developer.mozilla.org/fa/), [DNTips](https://www.dntips.ir/)
