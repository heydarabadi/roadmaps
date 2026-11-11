<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/02-api-response/01-payload-size/README.md) | **English**

# Payload Size and Limits

A payload is the body of a message; this lesson focuses on API response data. A “small response” contains data proportionate to the consumer’s needs. A “limit” is a contract that prevents unbounded growth in item count, field size, or nested expansion. An infrastructure ceiling is not the same as a good user-experience budget.

**After this lesson, you can:** distinguish decompressed from transferred size; build a summary representation; set item and byte limits together; and design a clear path for oversized results. Prerequisites: JSON and HTTP. **Sources reviewed: 2026-11-10.**

## Basic terms

HTTP exchanges requests and responses with headers and a body; **JSON** is one text format for a body. Here, payload means the body content, and “decompressed size” means the JSON bytes after compression is undone. It can differ from transferred bytes and from memory used while parsing.

## Mental model: cost starts before the network

| Stage | Cost that grows with extra data | Review question |
| --- | --- | --- |
| Fetch | Reading DB columns/relations and transferring from the database | Does the consumer need this field? |
| Build response | Allocation, computation, serialization | Is a list representation separate from details? |
| Transfer | Network bytes and receive time | Is actual transfer size recorded? |
| Consume | Decompression, parsing, memory, rendering | Can a low-end phone consume this response? |

Compression reduces the transfer stage, but item count and decompressed JSON structure remain the same. Choose fields as early as possible, before fetching and computing them; removing a field only in the final serializer saves only part of the cost. Google Drive’s official example documents a `fields` parameter for requesting a subset of data; this is an API contract and does not exist automatically in every API. [Google Drive fields](https://developers.google.com/workspace/drive/api/guides/fields-parameter).

A suggested decision procedure:

1. List the fields each consumer actually needs; an order card, for example, does not need every line-item history.
2. Make a summary response the default and expose large details/relations through an explicit request. Do not omit fields needed to continue, such as a token.
3. Limit item count, free-text field length, expansion count/depth, and decompressed body bytes. Choose numeric limits using real data and product requirements.
4. Measure decompressed size, transferred size, and peak memory separately; `Content-Length` may show the compressed size or may be absent.
5. Define what happens at the limit: a smaller page plus continuation link, a corrected request, or separate export. Never cut JSON in the middle of an object.

### Educational budget and hard limit

| Limit type | Hypothetical example | Designed behavior |
| --- | --- | --- |
| Monitoring budget | p95 decompressed list body below 100 KiB | Alert and review schema changes; not necessarily an error |
| Item-count cap | `page_size <= 50` | Clamp or return a documented parameter error |
| Byte cap | At most 256 KiB per page for this API | Return fewer than the item cap and provide a continuation token |
| One very large field | A 2 MiB description in one item | Return a documented summary and separate detail/file path |

These values are **not general recommendations or production measurements**. If one item exceeds the byte budget, lowering page size is not enough; change its representation or delivery path. A client must not treat “fewer than `page_size`” as the end; the token contract decides.

## Worked example: order card

**Hypothetical scenario:** The old endpoint returns 100 orders, including history and embedded files. The interface displays only a summary. The new contract is:

<div dir="ltr" align="left">

```http
GET /v1/orders?page_size=2&fields=id,status,total HTTP/1.1
Host: api.example.test
Accept: application/json
```

```json
{
  "items": [
    {"id": "o-102", "status": "paid", "total": 480000},
    {"id": "o-101", "status": "pending", "total": 120000}
  ],
  "next_page_token": "opaque-token-1"
}
```

</div>

For this contract, `fields` controls only fields inside `items`; continuation metadata is always present. Authorization to view fields is checked independently. An unknown field request receives a documented parameter error. An authorized detail URL replaces automatic file transfer; do not create a permanently public URL for a private file.

Assume the educational baseline is 100 items × 20 KiB, or about 2,000 KiB of item data. A summary of 50 items × 0.5 KiB is about 25 KiB; the envelope and headers are separate. This calculation shows that reducing item count and reducing item size are independent levers; measure serialized JSON for the real ratio rather than object size in memory.

## Exercise and worked solution

Create a local JSON sample of 20 orders, each with a long description and history. Without a server, produce two files: “all fields” and “only `id,status,total`.” In PowerShell, inspect the UTF-8 byte size:

<div dir="ltr" align="left">

```powershell
Get-Item -LiteralPath .\orders-full.json, .\orders-summary.json |
    Select-Object Name, Length
```

</div>

Add one item with a very large description and compare the sizes again. **Expected:** item count remains fixed while the full file grows; the summary should not grow by a similar amount if it excludes that field. Record the difference between bytes and character count, especially for Persian UTF-8 text. This exercise measures size; claims about latency or CPU require server measurement.

### Worked solution

If each of 20 complete orders contains about 2 KiB of history/description, that part contributes roughly `20×2=40 KiB`. A summary around 0.1 KiB per order is roughly 2 KiB, before JSON envelope and whitespace. Adding a 64 KiB description to one order increases the full file by about 64 KiB, while a summary that omits that field stays nearly unchanged. The actual byte count is the file’s `Length`; character count is not UTF-8 byte count for Persian text.

## Real evidence and its limits

**Official operational example:** Google Drive’s `files.list` documentation describes a limited default field set and the ability to request specific fields. This is an actual API example; it does not prove a percentage improvement for our service. [Drive fields parameter](https://developers.google.com/workspace/drive/api/guides/fields-parameter).

**Real infrastructure ceiling:** At the review date, the Amazon API Gateway HTTP API quota table listed a 10 MB payload limit that could not be increased. This number applies to that API type; do not generalize it to all gateways, streaming APIs, or response cases. [Official HTTP API quotas](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-quotas.html).

`413 Content Too Large` means the **request content** is too large; do not assume it is a general “server response too large” status. For large output, apply the page/export contract before sending headers. [MDN: 413](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/413).

## Costs, fit, and common failures

A fixed summary is simpler and its caching behavior is more predictable. Free field selection is flexible for different clients, but increases cache combinations, documentation, and authorization checks. For a small API with a few hundred bytes per response, a complex projection language may cost more than it saves. For full export, consider a file/stream path; do not make the interactive response unlimited.

| Failure | Operational signal | Action |
| --- | --- | --- |
| Limit items but not large fields | p99 size spikes with the same item count | Control largest item and expansions separately |
| Remove fields only after expensive queries | Bytes decrease but DB/CPU stays constant | Apply projection and fetch plan earlier |
| Silently return partial output | User misses some orders | Document continuation metadata and summary semantics |
| Remove an existing field abruptly | Older clients fail | Plan compatible version/change and migration period |
| Log the full oversized body | Log cost/latency or data exposure | Record size and representation type; body is unnecessary |

### Operational checklist

- [ ] Required fields are documented for each endpoint and primary consumer.
- [ ] Item, byte, field-length, and expansion limits are defined together.
- [ ] Overflow behavior and a single oversized item are handled.
- [ ] Decompressed/transferred size and p95/p99 are recorded per route.
- [ ] Sensitive fields are not exposed through client selection or automatic serialization.
- [ ] Empty sets, long Persian text, and old clients are reviewed.

## Quiz — try before viewing the answers

1. Why does a limit of 50 items not guarantee a byte limit?
2. A 2 MiB response becomes 100 KiB after gzip. Is client parsing memory also necessarily 95% lower?
3. If `fields=id` is applied only at the end of serialization, what cost may remain?
4. Is `413` the standard response for “my JSON output is too large”?
5. A page contains 18 items due to a byte cap, below the limit of 50, and includes a continuation token. Should the client stop?
6. What cost does free projection add compared with a fixed summary representation?

### Explained answers

1. Items vary in size; one long field or embedded file can exceed the budget. Both item count and bytes need limits.
2. No. Decompressed data remains about the same JSON. Parsing memory also depends on its expanded representation and runtime.
3. Relation fetching, database transfer, and field computation may already have happened. Field-driven execution should decide earlier.
4. No. It refers to request content exceeding the accepted limit. Define output-size handling in the API contract.
5. No. The continuation token says more results can be requested. A short page alone does not prove completion.
6. It creates more combinations to authorize, cache, and maintain; accept that complexity only for a real need.

## Summary

First limit fields, item count, and relation depth in the contract; then measure decompressed size, transfer bytes, and consumer memory separately. A byte cap needs a continuation or alternate-output path and must never truncate JSON silently.

## Optional references and further reading

Payload, examples, and the exercise solution are complete here. The links are optional further reading and references for specific contracts.

- Persian, supplementary: [REST design and field selection — Net Paradis](https://netparadis.com/rest-design-pagination-filtering-versioning/), an introduction to `fields` and `include`; not a reference for every API’s behavior.
- English, first-party API docs: [Google Drive fields](https://developers.google.com/workspace/drive/api/guides/fields-parameter), for field-selection contract and invalid field errors.
- English, first-party API docs: [WordPress REST global parameters](https://developer.wordpress.org/rest-api/using-the-rest-api/global-parameters/), for `_fields` projection on real responses.
- English, first-party API performance guide: [Google Drive API performance](https://developers.google.com/workspace/drive/api/guides/performance), for partial responses and reducing returned fields; its parameter syntax is specific to Google Drive.
- English, official API design: [Google API Design Guide](https://cloud.google.com/apis/design), for consistent resource and response-field design.
- English, HTTP reference: [MDN Content-Length](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Length), to interpret body length; the header does not measure every stage.
- English, first-party infrastructure docs: [AWS HTTP API quotas](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-quotas.html), an example of a hard infrastructure cap.

[API Response chapter](../README.en.md) · [Course contents](../../README.en.md) · [Next: Compression](../02-response-compression/README.en.md)

**Related:** [API pagination](../03-efficient-pagination/README.en.md) · [Selecting DB columns](../../04-databases/05-select-only-needed-columns/README.en.md) · [Streaming](../../06-code-optimization/01-streaming-large-bodies/README.en.md)

</div>
