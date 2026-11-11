<div dir="ltr" align="left">

[فارسی](README.md) | **English**

# Chapter 02 — API Responses: The Needed Data, Work, and Transfer Size

When a user opens an order list, a fast query is not enough. Building thousands of objects, computing unused fields, serializing them to JSON, transferring megabytes, and parsing them on a phone all have a cost. This chapter connects four decisions: what data to return, how many items, with which encoding, and after how much processing.

This chapter is part of the [Backend Performance course](../README.en.md) and corresponds to the API Response section of the [source roadmap](https://roadmap.sh/backend-performance-best-practices). **Sources reviewed: 2026-11-10.** Numerical examples are educational, not universal performance targets.

## Prerequisites and learning outcomes

Be familiar with HTTP requests/responses, JSON, headers, status codes, and a list endpoint. A basic understanding of queries and indexes is enough; no particular language or cloud platform is required. Each lesson explains its specialized terms on the page, so you can follow it without reading other links. External sources are optional, for further reading and verification. After studying, you can set a response-size budget for an endpoint, inspect compression negotiation, design a pagination contract, and remove work before it runs.

## Suggested study order

Each page contains its own definitions, example, solved exercise, and answer key; links are for further reading and reference only.

| Order | Lesson | Main question | Practical outcome |
| --- | --- | --- | --- |
| 1 | [Payload size and limits](01-payload-size/README.en.md) | Does this data need to be in the response at all? | Field contract, item/byte limits, and overflow behavior |
| 2 | [Response compression](02-response-compression/README.en.md) | How can the required bytes be transferred more cheaply? | Correct headers, compression ratio, and CPU cost |
| 3 | [Efficient API pagination](03-efficient-pagination/README.en.md) | How can a client traverse a collection in steps? | Page size, ordering, token, and end-of-traversal contract |
| 4 | [Avoiding unnecessary processing](04-avoid-unnecessary-server-work/README.en.md) | Which computation can be skipped? | Field-driven execution plan and inexpensive revalidation |

Size and pagination are related: a limit of 50 records does not create a byte limit when a record can contain a large file. Compression is not a substitute for either one; the client still has to hold the decompressed data in memory. Define the response contract first, then measure each layer.

## Shared scenario for the chapter

**Illustrative scenario:** Every visit to a store’s order list returns all history, line items, embedded photos, and a computed customer score; the interface displays only the order ID, date, status, and amount.

1. Define a summary view, with a separate path for details and files. Measure decompressed and transferred size separately.
2. Limit the number of results and provide a continuation link; specify ordering and behavior when data changes between pages.
3. Compress sufficiently large JSON at the responsible layer using an encoding the client accepts; inspect the result from the client’s perspective.
4. Compute the score and fetch line items only for the detail request. If the summary has not changed, check its validity before building the full representation.

Success is not merely “smaller JSON.” Compare query and dependency call counts, CPU per request, memory, time to first byte, total response time, p95/p99, and client errors. A percentage without a baseline and equal test conditions has little practical meaning.

## Chapter boundary and related chapters

| Related topic | This chapter’s responsibility | Further study |
| --- | --- | --- |
| Database pagination | External page contract, token, and client behavior | [Query execution, Offset/Keyset, and indexes](../04-databases/04-efficient-database-pagination/README.en.md) |
| Column selection | External field needs and summary view | [Database projection](../04-databases/05-select-only-needed-columns/README.en.md) |
| HTTP caching | Inexpensive detection that a representation is unchanged | [Cache layers](../01-caching/01-cache-layers/README.en.md) and [freshness/invalidation](../01-caching/04-invalidation-and-freshness/README.en.md) |
| Large files | Limits for interactive responses and a separate export path | [Streaming](../06-code-optimization/01-streaming-large-bodies/README.en.md) and [background jobs](../03-asynchronism/01-background-jobs/README.en.md) |
| Network delivery | Encoding and response-body size | [Latency and regions](../10-network/01-region-and-network-latency/README.en.md) and [CDNs](../10-network/03-cdn-for-static-and-frequent-content/README.en.md) |

## Chapter review checklist

- [ ] The consumer and required fields are known; list and detail responses differ.
- [ ] Item, byte, and expansion-depth limits and overflow behavior are documented.
- [ ] Decompressed JSON size and transferred body size are measured separately.
- [ ] Encoding, `Vary`, and reverse-proxy/CDN behavior are checked from the client’s perspective.
- [ ] Pagination is defined from first page to completion, including empty sets and changing data.
- [ ] An unselected field does not run its query or expensive computation.
- [ ] Removing unnecessary work does not remove authorization, data correctness, or required audit events.
- [ ] Every change has a baseline, expected observation, and rollback path.

## Optional guide references

- [Persian: REST design, pagination, and field selection — Net Paradis](https://netparadis.com/rest-design-pagination-filtering-versioning/): links API contract decisions; adapt recommendations to the actual need.
- [Google API Design Guide](https://docs.cloud.google.com/apis/design): a contract-design framework; Lesson 3 points to AIP-158 for pagination details.
- [Microsoft Well-Architected: Optimize code and infrastructure](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure): reducing unnecessary resource use through measurement.

[Continue](01-payload-size/README.en.md) · [Course contents](../README.en.md)

</div>
