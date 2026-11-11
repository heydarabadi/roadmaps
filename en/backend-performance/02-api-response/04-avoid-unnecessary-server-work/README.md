<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/02-api-response/04-avoid-unnecessary-server-work/README.md) | **English**

# Avoiding Unnecessary Server Work

Unnecessary work is work that is not needed for this request’s required result: fetching a relation the response does not show, computing an unselected field, rebuilding an unchanged representation, or calling a downstream service whose result is not consumed. First determine why the work runs; speeding up or parallelizing work that can be removed is not the first step.

**After this lesson, you can:** separate a response’s critical path into required and optional work; move field selection before computation; implement revalidation without making false claims about CPU savings; and use traces/counters to verify the removal. Prerequisites: HTTP, authorization, and the [payload contract](../01-payload-size/README.md). **Sources reviewed: 2026-11-10.**

## Basic terms

**Authorization** checks which data an identity is allowed to read or change. A **validator**, such as an ETag, identifies a representation version for a conditional request. A **trace** records the path and timing of request components. Keep these correctness/security obligations separate from optional computation.

## Mental model: decide before doing the work

| Request need | Early decision | Work that may be removed |
| --- | --- | --- |
| Order summary only | Summary view and validated field set | Line-item details, customer analytics, their serialization |
| Filter paid orders | Apply a valid filter at the data source | Fetch all orders and filter in memory |
| Previous view is still valid | Compare an inexpensive validator after access check | Rebuild and send the body |
| Same lookup is needed more than once in the request | Reuse it within that request | Repeat call for the same key |
| Only existence is needed | Use a suitable existence check | Count/load all records |

This is not a rule that “every computation should be cached.” First use traces and profiling to see each task’s share. Microsoft’s guide recommends using application components only when needed and reducing unnecessary consumption; adding resources to hide extra work does not fix its cause. [Microsoft Well-Architected](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure).

### How to inspect an endpoint

1. **Write down the required output:** Which fields and correctness guarantees does this consumer need? Authorization, validation, and required audit events are not “extra.”
2. **Separate costs:** Inspect time and count of queries, network calls, computation, serialization, and response bytes in the trace; total duration alone is insufficient.
3. **Declare needs early:** Build the fetch plan from the allowed view/fields. Push filters, page caps, and projection toward the appropriate layer.
4. **Remove local repetition:** Run a lookup only once within a request when freshness and authorization semantics remain unchanged. Cross-request caching has invalidation and user-separation rules; see the [Caching chapter](../../01-caching/README.md).
5. **Design safe early exits:** Reject invalid input early; validate an unchanged representation with a validator. Cancellation may stop optional remaining work, but must not leave a required transaction or business effect half-complete.
6. **Measure again:** If bytes fall but query count is unchanged, only output size decreased; if p95 improves while errors or CPU increase, the result is incomplete.

## Worked example: a summary that does not need expensive analytics

**Hypothetical scenario:** An order page needs only `id,status,total`. The old implementation loads line items and calls another service for a customer score every time, then the serializer removes both. Move the summary decision to the beginning of the request path:

<div dir="ltr" align="left">

```text
handleSummary(request):
    principal = authenticate(request)
    authorizeRead(principal, request.orderId)
    fields = validateAllowedFields(request.fields)
    plan = buildPlanFor(fields, view="summary")

    revision = readSummaryRevision(request.orderId, principal.tenant)
    validator = makeWeakValidator(revision, fields, view="summary")
    if matchesIfNoneMatch(request, validator):
        return 304 with validator and private-cache-policy, no body

    summary = readAuthorizedSummaryProjection(plan)
    if plan.needsItems:
        summary.items = readItemsWithinBudget()
    if plan.needsCustomerScore:
        summary.customerScore = fetchCustomerScore()
    return 200 with JSON(summary) and validatorFor(summary)
```

</div>

This pseudocode is not a complete HTTP algorithm or a specific language. Delegate `If-None-Match` comparison to an HTTP-compatible library; comparing raw strings does not cover every header case. [MDN: If-None-Match](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/If-None-Match) explains comparison and headers for conditional responses. `revision` must cover every representation dependency, Tenant, field set, and contract version. If data changes between reading the revision and the body, build the response validator from the same read representation or use a consistent read/retry; do not attach an old revision to a new body.

An example exchange for a private representation that must be revalidated before reuse:

<div dir="ltr" align="left">

```http
HTTP/1.1 200 OK
Content-Type: application/json
Cache-Control: private, no-cache
ETag: W/"o42-summary-fields-a-v7"

{"id":"o42","status":"paid","total":480000}
```

```http
GET /v1/orders/o42?view=summary HTTP/1.1
Host: api.example.test
If-None-Match: W/"o42-summary-fields-a-v7"
```

```http
HTTP/1.1 304 Not Modified
Cache-Control: private, no-cache
ETag: W/"o42-summary-fields-a-v7"
```

</div>

The client must already have the old body; `304` has no new body. `no-cache` permits storage but requires validation before reuse; it is not the same as `no-store`. This example uses a weak validator for GET; allowed representations and change semantics must be clear. It does not show all authentication and environment headers. [MDN: HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching).

**Key point:** If an ETag is built by hashing the full body after all queries and JSON construction, `304` still saves transfer bytes, but most server processing has already happened. CPU savings require a cheap way to know the representation is valid before rebuilding it. If no trustworthy revision exists, do not claim that computation was removed; correct but late validation may still help.

## Exercise and worked solution

For a test handler or a paper simulation, add four counters: `summary_reads`, `items_reads`, `score_calls`, and `serializations`.

1. Simulate the old execution for a summary request: every counter increases.
2. Move field decisions before execution: build the summary without reading items or score.
3. Simulate one conditional request with a valid validator and one after a status change.

**Expected:** In step 2, `items_reads` and `score_calls` remain zero. On a `304` path with an inexpensive revision, body serialization and details do not run, though access checking and reading the revision may remain. After the status changes, return `200` with fresh data. If only the JSON appearance changed while counters stayed the same, work was not removed at the right layer. This exercise is not production-performance evidence or a benchmark.

### Step-by-step solution

In the old handler, each summary request increments `summary_reads`, `items_reads`, `score_calls`, and `serializations` once. After creating the summary plan, `items_reads=0` and `score_calls=0`; `summary_reads` and one serialization for a 200 response are still needed. With a valid validator, the 304 path authenticates/authorizes and reads the revision, then stops before building a body: `serializations=0`, with no item or score query. A status change must change the revision and return a fresh 200. To claim CPU was removed, compare counters and cost spans too, not only response bytes.

## Real evidence and limits

**WordPress REST API:** Its `_fields` documentation explicitly says WordPress omits unneeded fields while generating the response object so their internal computation and possible queries are avoided. This demonstrates the difference between never building a field and deleting it after building. [WordPress Global Parameters](https://developer.wordpress.org/rest-api/using-the-rest-api/global-parameters/).

**GitHub REST API:** The official guide explains conditional requests with `ETag`/`If-None-Match` and a `304` response; it also recommends specific, stable requests so a representation changes less unnecessarily. The exemption of `304` from GitHub’s Primary Rate Limit depends on a correctly authenticated request; it is a GitHub rule, not a general HTTP rule. The guide does not claim a particular amount of GitHub CPU is removed. [GitHub Best practices](https://docs.github.com/en/rest/using-the-rest-api/best-practices-for-using-the-rest-api).

These are public operational sources; they do not establish a CPU/latency percentage for our hypothetical endpoint or any other company.

## Trade-offs and common failures

| Decision/failure | Effect | How to inspect |
| --- | --- | --- |
| Remove relation only from output | N+1 queries/computation remain | Compare spans and query count per view |
| Validator omits a dependency | Incorrect `304` and stale data | Review every visible dependency |
| Revalidate only after full-body hash | Less network, nearly unchanged CPU | Record validator build time separately |
| Cache result without tenant/authorization | Data exposure | Review identity and access scope |
| Parallelize all optional work | Pool/downstream pressure and tail latency | Remove unused work first; cap concurrency |
| Remove required work as an optimization | Incorrect result, bypassed authorization, or lost event | Keep business obligations as acceptance conditions |

Field-driven execution plans help endpoints with multiple views and expensive computations. For a simple response, many branches and complicated revisions may be harder to maintain than their benefit; first compare two explicit views, “summary” and “detail.” Moving work to a Background job does not remove it; it changes timing and delivery guarantees and is covered in the [background jobs lesson](../../03-asynchronism/01-background-jobs/README.en.md).

### Operational checklist

- [ ] Required fields and necessary business work are identified in advance.
- [ ] Authentication and authorization happen before an early exit.
- [ ] An unselected field does not run its query/dependency.
- [ ] Every validator covers all dependencies and the relevant representation.
- [ ] Version and response body are consistent under concurrency.
- [ ] Measure `304` rate with CPU/query count; it is not a success metric by itself.
- [ ] Behavior is defined for changed data, cold cache, cancellation, and dependency errors.
- [ ] Compare p95/p99, allocation, call counts, and user errors with a baseline.

## Quiz

1. When does smaller JSON fail to prove that server work decreased?
2. Why may hashing the full body for ETag save little CPU?
3. Does `304` authorize skipping an access check?
4. A computed field depends on two sources, but the revision covers only one. What is the risk?
5. How does removing work differ from moving it to a Background job?
6. What evidence shows that customer-score computation was removed rather than merely hidden?

### Explained answers

1. When data/relations and computation already ran and the field was removed only at output time. Traces and counters must confirm the change.
2. Because body construction, queries, and computation already happened before hashing; the main savings may be transfer only.
3. No. The user may no longer be allowed to access the data. A conditional request is still a request for that resource.
4. A change to the second source may not change ETag, causing an incorrect `304`; the validator must cover the actual representation.
5. Removal means the work is unnecessary; Background execution performs it later with delivery and failure obligations.
6. `score_calls=0` for summary, no corresponding trace span, and lower dependency cost while output remains correct; omission from JSON alone is insufficient.

## Summary

Remove work before it runs, while preserving authorization, validation, and required business effects. ETag/304 can save bytes; only a cheap and complete validator can also skip body construction or expensive queries, and traces must confirm that happened.

## Optional references and further reading

Definitions, example path, and exercise solution are complete here. These links are optional for further reading and verification.

- Persian, supplementary: [REST design, field selection, and filtering — Net Paradis](https://netparadis.com/rest-design-pagination-filtering-versioning/), an introduction to `fields`/`include`; not an implementation reference for early work removal. No direct Persian source comparable to WordPress’s documentation of early projection was found in this review; this lesson provides the explanation.
- English, first-party API documentation: [WordPress Global Parameters](https://developer.wordpress.org/rest-api/using-the-rest-api/global-parameters/), direct example of saving computation/queries with `_fields`.
- English, HTTP caching guide: [MDN HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching), ETag, `304`, and cache policies.
- English, HTTP reference: [MDN ETag](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/ETag), weak/strong validators and representation changes.
- English, first-party API documentation: [GitHub REST best practices](https://docs.github.com/en/rest/using-the-rest-api/best-practices-for-using-the-rest-api), conditional requests and specific request selection.
- English, first-party architecture guidance: [Microsoft code/infrastructure optimization](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure), reducing resource use through measurement.

[API Response chapter](../README.en.md) · [Course contents](../../README.en.md) · [Previous: Pagination](../03-efficient-pagination/README.en.md)

**Related:** [ORM fetch strategies](../../04-databases/03-orm-fetch-strategies/README.en.md) · [Selecting DB columns](../../04-databases/05-select-only-needed-columns/README.en.md) · [Critical paths](../../06-code-optimization/04-critical-paths/README.en.md) · [Cache freshness](../../01-caching/04-invalidation-and-freshness/README.en.md)

</div>
