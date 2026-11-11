<div dir="ltr" align="left">

[فارسی](README.md) | **English**

# Efficient API Pagination

Pagination is a contract for viewing a collection in several bounded responses. The API tells the client what it returned, how to continue, and when traversal is complete. This contract controls the size of each response and avoids requiring the client to keep the entire collection in memory.

**After this lesson, you can:** distinguish the API contract from query execution; choose Page/Offset/Cursor for the use case; define a maximum page size, ordering, completion, and token errors; and explain how changes between pages affect results. Prerequisites: a list endpoint and [payload budgets](../01-payload-size/README.en.md). **Sources reviewed: 2026-11-10.**

## Basic terms

An **endpoint** is the address and API contract a client calls for an operation. **Deterministic ordering** means every pair of records has a defined position; a stable ID can break ties when timestamps match. A **token/cursor** carries information for continuing traversal and remains opaque in this example.

## The exact boundary between API and database

| Layer | Responsibility | Example question |
| --- | --- | --- |
| API pagination, this lesson | Request/response contract, token, order, completion, compatibility | What should the client request after this page? |
| Database pagination | Bounded and ordered query execution, keyset/offset, index, plan | How many rows must the database read for the next page? |

`page_size=20` in a URL does not prove the database processes only 20 rows; the application might fetch everything and then slice it. Conversely, a good query with `LIMIT` does not by itself define a continuation contract for the client. SQL, composite indexes, and deep-offset cost are covered in the [database pagination lesson](../../04-databases/04-efficient-database-pagination/README.en.md); this lesson focuses on the external contract.

## Choosing a contract shape

| Method | Example request | Suitable for | Cost/limit |
| --- | --- | --- | --- |
| Page number | `?page=4&page_size=20` | Interface with “go to page 4” | Inserts/deletes move page boundaries; inspect deep-page execution |
| Limit/Offset | `?limit=20&offset=60` | Simple API and small/slow-changing collections | Large offset and concurrent data changes are problematic |
| Cursor/Token | `?page_size=20&page_token=...` | Feed and sequential traversal of a large collection | Arbitrary jumps and total count are not simple; needs ordering and a valid token |

Cursor names a family of contracts; not every token means keyset SQL. A token may point to a position, a snapshot, or server-side state. “Cursor is always O(1)” and “cursor always provides a full snapshot” are not true of every API. Django REST Framework documents examples of all three styles and the need for suitable cursor ordering; do not generalize that framework’s behavior to every implementation. [Django REST pagination](https://www.django-rest-framework.org/api-guide/pagination/).

### Contract details to settle before release

1. **Page size:** Document the default and maximum. Consistently clamp or reject an over-limit request; byte caps may yield fewer items.
2. **Deterministic order:** For example, `created_at DESC, id DESC`. A timestamp alone is insufficient because records can tie. Explain behavior if a sort field can change.
3. **Continuation and completion:** Use `next_page_token` or a `next` link as the continuation signal. Under a token contract, a short page is not necessarily the end; an empty page may still have a next token.
4. **Opaque token:** The consumer must not parse or construct it. A token is position information, not authorization; check access again for every page.
5. **Stable parameters:** Bind filters, order, tenant, and relevant representation to traversal. Define behavior if the client changes filters while reusing an old token.
6. **Expiry and data changes:** Define invalid/expired-token errors and how to restart. Auditing reports may require a snapshot/export with a fixed data boundary; a live feed has different requirements.

These principles align with [Google AIP-158](https://google.aip.dev/158): design pagination into a collection contract from the start; keep the token opaque to the client; do not use it as authorization. AIP rules apply to APIs that follow them; the example’s cap and error shape are independent teaching choices.

## Worked example: paid orders

**Hypothetical contract:** Default 20, maximum 50 items; values above the maximum are clamped to 50; a negative number returns `400`. Order descending by `(created_at,id)`. Token is bound to Tenant and Filter. Completion is indicated by omission of `next_page_token`; there is no default `total_count`.

<div dir="ltr" align="left">

```http
GET /v1/orders?status=paid&page_size=2 HTTP/1.1
Host: api.example.test
Accept: application/json
```

```json
{
  "items": [
    {"id": "o-104", "created_at": "2026-11-10T08:00:00Z"},
    {"id": "o-103", "created_at": "2026-11-10T08:00:00Z"}
  ],
  "next_page_token": "opaque-token-a"
}
```

```http
GET /v1/orders?status=paid&page_size=2&page_token=opaque-token-a HTTP/1.1
Host: api.example.test
Accept: application/json
```

```json
{
  "items": [
    {"id": "o-102", "created_at": "2026-11-10T07:00:00Z"}
  ]
}
```

</div>

The tokens above are placeholders. In an implementation, use a validated token or server-side mapping; Base64 alone does not prevent tampering or disclosure. If the token contains sensitive data, signing protects integrity but not confidentiality. Keep it short-lived and free of sensitive information, or use suitable protection.

In this example, adding a newer order between requests can avoid repeating the beginning of the feed when continuing from the prior boundary; it does not guarantee exactly-once visibility of every mutable record. Deletion, status changes, or a changed sort field can alter the result. Define the guarantee separately for a feed, administrative traversal, and financial export.

**Why no default count?** Knowing whether another page exists is not the same as knowing the exact total. Count may require a separate expensive query and can become stale as data changes. If the product needs it, document cost, freshness, and whether it is exact or approximate.

## Exercise and worked solution

On paper or in a file, use the descending list `8,7,6,5,4,3` with page size 3. The first page is `8,7,6`. Insert `9` at the beginning before requesting the second page.

1. Find page two using Offset 3.
2. Find page two using the boundary “after ID 6” in descending order.
3. Now remove record 5 from the filter. Do you still have a fixed snapshot?

**Expected:** Offset page two returns `6,5,4`, repeating 6. The sample cursor boundary returns `5,4,3`. Removing 5 from the filter shows that simple keyset continuation is not a snapshot. This simulates a contract; query performance and indexes are discussed separately in the database chapter.

### Step-by-step solution

The initial list is `8,7,6,5,4,3`; the first three items are `8,7,6`. Inserting 9 produces `9,8,7,6,5,4,3`. A zero-based offset of 3 starts at 6, so it returns `6,5,4` and repeats the last item from the first page. Continuing after cursor value 6 instead returns `5,4,3`. If record 5 leaves the filter, the next result can be shorter: this cursor preserves a continuation boundary, not a fixed snapshot. A true snapshot requires the source to retain the requested version/time boundary and the API to expose that guarantee.

## Real evidence and limits

**GitHub REST API:** The official guide explains `Link` headers and the `next` relation for traversing pages; parameters can differ by endpoint. Follow the returned link rather than guessing the next URL. This is evidence of a real API contract; it does not establish a latency number. [GitHub: Using pagination](https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api).

**WordPress REST API:** `per_page` accepts values from 1 through 100, and its guide explains the cap as protection against very large queries. That is a WordPress-specific limit, not a recommended cap for every API. [WordPress: Pagination](https://developer.wordpress.org/rest-api/using-the-rest-api/pagination/).

These sources document real service/framework behavior; no before/after incident study with a transferable improvement percentage was found for this lesson, and no such result is claimed.

## Failures and operational signals

| Failure | Signal | Correction |
| --- | --- | --- |
| Unbounded `page_size` or `include` | Large response, disproportionate memory/p99 | Apply item, byte, and expansion caps together |
| Slice after fetching the whole collection | DB and RAM grow with all data | Push bounds into the query |
| Nondeterministic or mutable order | Duplicate/missing records across pages | Define a tie-breaker and traversal guarantee |
| Token used as authorization | Token grants access to another tenant | Check tenant and authorization on every page |
| Client guesses completion from page length | Stops early and misses data | Use the token/next link as the continuation signal |
| Exact count on every page | Count dominates the trace | Make count optional/separate with clear semantics |
| Unbounded parallel fetch of all pages | Burst and rate-limit failures | Bound export budget and concurrency |

### Operational checklist

- [ ] Default/maximum size, invalid values, and clamp behavior are documented.
- [ ] Deterministic ordering and concurrent-change semantics are clear.
- [ ] Token is bound to contract/scope; authorization is checked separately.
- [ ] Completion, empty page with continuation, invalid token, and expiry are defined.
- [ ] The query is actually paginated; Count cost is measured separately.
- [ ] Duplicates, token errors, pages traversed, bytes/page, and p95/p99 are monitored.
- [ ] Audit/export traversal has a defined snapshot boundary if required.

## Quiz

1. Does `page_size` in the API prove the query is efficient?
2. Why may ordering only by `created_at` be insufficient?
3. A page has 7 items below the limit of 20 and has a next token. What should the client do?
4. Does a simple cursor guarantee a fixed snapshot?
5. Does Base64-encoding the last ID make a token secure and authorized?
6. Why may a cursor be costly for an interface that jumps directly to page 25?

### Explained answers

1. No. The application may fetch everything and slice it later. Inspect query execution, rows read, and plan separately.
2. Multiple records can share a timestamp; a stable tie-breaker such as ID creates deterministic order.
3. Send the next request with the declared token/link; a short page alone does not prove completion.
4. No. A cursor holds a continuation position, but data/filter may change. A snapshot needs a separate guarantee.
5. No. Base64 is encoding. A token is not authorization; protect integrity/content according to the design.
6. A cursor usually requires sequential traversal and may not provide page numbers or a total count. Evaluate product needs and alternative costs.

## Summary

Pagination is both the client’s continuation contract and bounded execution at the source; neither replaces the other. Define caps, stable ordering, opaque tokens, and change/completion behavior, and measure query cost, Count, and bytes per page separately.

## Optional references and further reading

The API contract, Offset/Cursor example, and exercise solution are on this page. Links are optional further reading and comparisons with real APIs.

- Persian, supplementary: [REST design and pagination — Net Paradis](https://netparadis.com/rest-design-pagination-filtering-versioning/), comparing Offset and Cursor in API contract design.
- English, first-party API design: [Google AIP-158](https://google.aip.dev/158), token meaning, page size, and contract compatibility.
- English, first-party framework docs: [Django REST pagination](https://www.django-rest-framework.org/api-guide/pagination/), PageNumber, LimitOffset, Cursor, and ordering requirements.
- English, first-party product docs: [GitHub pagination](https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api), following continuation links without relying on their internal format.
- English, first-party product docs: [WordPress pagination](https://developer.wordpress.org/rest-api/using-the-rest-api/pagination/), page-size caps and count metadata.
- English, primary database reference: [PostgreSQL LIMIT and OFFSET](https://www.postgresql.org/docs/current/queries-limit.html), for query-level limits and predictable ordering.

[API Response chapter](../README.en.md) · [Course contents](../../README.en.md) · [Previous: Compression](../02-response-compression/README.en.md) · [Next: Avoiding unnecessary work](../04-avoid-unnecessary-server-work/README.en.md)

**Related:** [Database pagination](../../04-databases/04-efficient-database-pagination/README.en.md) · [Payload size](../01-payload-size/README.en.md) · [Rate limiting](../../08-security/03-throttling-and-rate-limiting/README.en.md)

</div>
