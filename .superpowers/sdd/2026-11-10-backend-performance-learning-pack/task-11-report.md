# Task 11 report — Chapter 10: Network

Status: authoring complete within the assigned Chapter 10 scope; ready for independent review. Date: 2026-11-10.

No software tests, benchmarks, network experiments, browser rendering, infrastructure changes or Git operations were performed. Verification was manual content review and a read-only local-file/link inventory.

## Delivered files

Created exactly five README files under `Backend Performace/10-network/`:

| File | Coverage |
| --- | --- |
| `README.md` | Timing vocabulary, four-topic learning route, diagnostic measurement sequence, hypothetical shop scenario, cross-links to compression/cache/batching, chapter checklist. |
| `01-region-and-network-latency/README.md` | RTT versus bandwidth/throughput/TTFB, routing and peering, user/API/DB placement, serial dependency arithmetic, multi-region consistency/operational costs, Discord evidence. |
| `02-connection-reuse/README.md` | HTTP/1.1 default persistence, HTTP/2 and HTTP/3 multiplexing, explicit prohibition on Connection/Keep-Alive fields in HTTP/2/3, per-hop protocol differences, client/transport lifetime, bounded pool/queue, response cleanup, idle/DNS/retry caveats. |
| `03-cdn-for-static-and-frequent-content/README.md` | Edge hit/miss versus routing gains, public/personalized response policy, cache keys and variants, Cookie/Authorization/Set-Cookie caveats, no-cache/no-store/private, versioning/TTL/validation/purge, eligible-hit denominator and cold-origin capacity, bounded VSCO attribution. |
| `04-prefetch-and-preload/README.md` | Current-page preload versus speculative future-navigation prefetch, preconnect distinction, as/CORS/consumer matching, browser/cache limits, useful versus wasted bytes, bounded authorized backend-read example, capacity/freshness/side-effect rules. |

Each topic has Persian explanations with RTL prose containers, LTR code outside those containers, outcomes, a comparison table, a worked example, exercise with expected observation, evidence/limits, failure signals, operational checklist, six questions with explained answers, annotated Persian and English references, and chapter/root/related navigation. Total quiz questions and explained answers: **24** each.

Only these five chapter files and this authorized report were created. Root README, other chapters and the shared progress ledger were not edited.

## Research and source boundaries

Used built-in web open/find during this authoring task. Successfully opened primary/authoritative references:

- RFC 9110, especially connection-specific forwarding semantics: https://www.rfc-editor.org/rfc/rfc9110.html
- RFC 9112 §9.3, HTTP/1.1 persistence: https://www.rfc-editor.org/rfc/rfc9112.html#section-9.3
- RFC 9113 §8.2.2, prohibited HTTP/2 connection-specific fields: https://www.rfc-editor.org/rfc/rfc9113.html#section-8.2.2
- RFC 9114 §4.2, HTTP/3 field restrictions and multiplexed QUIC context: https://www.rfc-editor.org/rfc/rfc9114.html#section-4.2
- RFC 9111, HTTP caching, including authenticated requests and the fact Set-Cookie alone does not prevent caching: https://www.rfc-editor.org/rfc/rfc9111.html
- MDN connection management and Keep-Alive references: https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Connection_management_in_HTTP_1.x and https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Keep-Alive
- MDN preload: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/rel/preload
- web.dev resource hints and prefetch: https://web.dev/learn/performance/resource-hints and https://web.dev/articles/link-prefetch
- Discord Voice at the Edge, June 9, 2026: https://discord.com/blog/how-we-moved-discord-voice-to-the-edge — independently opened during the preceding review work in this agent context; matched the chapter's limited geography/routing/scheduling account.
- Cloudflare VSCO customer story: https://www.cloudflare.com/en-au/case-studies/vsco/ — verified the CTO attribution of a 6x network performance gain in the poorest-performing markets and over-three-second to under-500ms delays after placing Cloudflare in front of APIs. The guide explicitly labels this vendor-hosted customer claim, lacks an asserted publication date, and does not claim independently reproduced results or isolate caching from routing/other changes.

Persian supplements opened and matched:

- https://azarsys.com/blog/server-location-impact-on-site-speed/ — geography, RTT, routing and peering introduction; hosting-company content, not a buying recommendation or region guarantee.
- https://learn.mhkarami97.ir/posts/networking_essentials/ — general networking/handshake/reuse/multiplexing introduction; its broad simplifications are not used as normative protocol rules.
- https://wordpresskar.ir/post/cdn-vs-hosting-for-site-speed/ — origin versus CDN delivery distinction; author's experience not independently reproduced.
- https://github.com/OmidHaqi/software-architecture-course-notes/blob/main/05-architectural-building-blocks/04-cdn.md — Persian CDN course notes; annotations avoid treating geographic-nearest or push deployment simplifications as guarantees.
- https://web.dev/learn/performance/resource-hints?hl=fa — verified Persian page content; annotation notes awkward terminology and recommends reading English names/original alongside it.

Connection reuse and prefetch/preload use authoritative operational documentation with explicit absence of a directly matched production experiment. Region and CDN use attributed public experiences. All numeric lesson models are clearly hypothetical; no company result, local benchmark or universal target was invented. HTTP/3 restrictions were verified from RFC 9114 rather than inferred solely from HTTP/2.

## Manual content and link review

- Read all five files back from disk, including every question, answer, code block and resource annotation.
- Reviewed assumptions and arithmetic: placement 106/250 ms and 144 ms difference; co-located DB 46 ms and added payment path 136 ms; body transfer 0.5 s; cold/reused connection 850/310 ms, revised 1450/370/490 ms; eligible CDN traffic 280/600/1000 requests/s; speculative bytes 6000 KiB ≈ 5.86 MiB and 16000 KiB = 15.625 MiB; hypothetical average savings 84/24 ms.
- Confirmed six answers per topic match their questions and preceding explanations.
- Added blank lines between Persian-numbered questions/answers so Markdown does not collapse them into one paragraph. Header-field examples are labeled text, with explanatory comments rather than claiming complete wire-format messages.
- Inspected balanced RTL containers and code fences; code blocks sit outside RTL containers.
- Enumerated the five expected README files and resolved every relative Markdown destination against its owning file. All within-chapter links resolve. All cross-chapter targets resolve except one pending target: `Backend Performace/09-performance-testing/README.md`, referenced once from the chapter index's previous-chapter navigation. That matches the approved design and is expected to be created by the other task; no out-of-scope placeholder was created.

## Integration concerns

1. Recheck the Performance Testing index destination after that chapter is authored.
2. The VSCO case is a provider-hosted customer story with limited measurement methodology; preserve its attribution and workload/market limits.
3. Browser implementation, cache partitioning and hint scheduling can evolve. The guide directs readers to check their target browsers instead of promising execution/reuse of every hint.
4. No Markdown renderer, browser acceptance, protocol trace, CDN configuration or runtime exercise was executed. Illustrative snippets express policies; installed client/CDN APIs and privileges require their own documentation.

No other unresolved chapter-content or within-chapter navigation issue was identified during manual author review.

## Review correction — HTTP/2 and HTTP/3 TE exception

Resolved the Minor finding that the connection-reuse explanation/checklist prohibited all connection-specific fields without their standards-defined exception. The guide now explicitly permits only `TE: trailers` on requests in HTTP/2 and HTTP/3, while preserving the prohibition on `Connection`, `Keep-Alive`, `Proxy-Connection`, `Transfer-Encoding`, `Upgrade`, and other connection-specific fields. It excludes TE on responses and TE values other than `trailers`, and cites RFC 9113 §8.2.2 and RFC 9114 §4.2 directly.

Manually inspected only the updated standards explanation, checklist item and this report note. No tests, browser checks, network experiments, Git operations or unrelated edits were performed for the correction.
