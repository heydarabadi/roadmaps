# Read-only Task 3 review supplement

## Implementer report

# Task 3 report — Chapter 02: API Response

Status: complete within the assigned chapter scope. Research verification date: 2026-11-10.

## Files created

- `D:\Learn\Roadmap\Backend Performace\02-api-response\README.md`
- `D:\Learn\Roadmap\Backend Performace\02-api-response\01-payload-size\README.md`
- `D:\Learn\Roadmap\Backend Performace\02-api-response\02-response-compression\README.md`
- `D:\Learn\Roadmap\Backend Performace\02-api-response\03-efficient-pagination\README.md`
- `D:\Learn\Roadmap\Backend Performace\02-api-response\04-avoid-unnecessary-server-work\README.md`

Only Chapter 02 content and this requested report were written. No Git repository was initialized and no commits were created. No subagents were dispatched.

## Coverage and authoring decisions

The chapter index contains prerequisites, outcomes, ordered navigation to all four topics, a shared hypothetical order-list scenario, a chapter review checklist, related-chapter links, and curated sources.

All four topic pages contain learning outcomes, a self-contained Persian explanation, trade-offs and poor-fit cases, language-neutral worked examples, a small exercise with expected observations, an explicitly labeled real-world operational evidence section, failure modes and signals, an operational checklist, six quiz questions with explained answers, Persian/English reading links, research date, and parent/chapter/related-topic navigation. Persian prose is wrapped in RTL/right-aligned HTML; copyable code/HTTP/PowerShell examples are wrapped in LTR/left-aligned HTML.

Specific coverage:

- Payload: summary/detail contracts, field selection, item and byte budgets, oversized single items, expand limits, serialized versus wire bytes, quota versus user-experience budget, private attachment handling, compatibility, and why HTTP 413 describes request content rather than a generic oversized response.
- Compression: negotiation using Accept-Encoding/Content-Encoding/Vary, Content-Type, byte accounting, CPU and tail-latency costs, layer ownership, proxy/CDN recompression, sensitive dynamic responses, buffering/streaming implications, and a curl.exe exercise preserving raw transfer bytes.
- Pagination: public API contract versus database Query execution; page/offset/cursor trade-offs; bounded sizes; deterministic ordering/tie-breaker; token opacity, validation, scope and independent authorization; short/empty pages with continuation; mutation/snapshot limits; counts; and why API pagination does not prove an efficient database query.
- Unnecessary work: early projection and query planning, avoiding unused dependencies, request-scope reuse, preserving business/security obligations, conditional GET, cheap versus late ETag generation, revision dependencies, concurrent data changes, and counters/traces that distinguish real skipped work from merely hidden output.Pagination deliberately cross-links the database pagination guide rather than repeating SQL, index and execution-plan lessons. Payload, compression, caching and processing optimization are linked but each page explains its own layer.

## Sources researched and used

The Firecrawl connector initially returned `requires a non-empty string link_id argument`. The parent confirmed that the connected account was out of credits and directed the use of the built-in web tools. Subsequent research used web search/open/find. No Firecrawl credit purchase or account change was attempted.

Primary/authoritative sources read or inspected for the included claims:

- [MDN Compression in HTTP] (https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression): encoding negotiation, Vary and already compressed formats.
- [MDN Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding) and [Content-Length](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Length): representation and size semantics.
- [MDN HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching), [ETag](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/ETag) and [If-None-Match](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/If-None-Match): validators, 304, private/no-cache policy, weak comparison and proper conditional response handling.
- [MDN 413](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/413): request-content limit semantics.
- [Google API design guide](https://docs.cloud.google.com/apis/design) and [AIP-158](https://google.aip.dev/158): bounded collection contracts, token semantics, authorization and compatibility.
- [Google Drive fields parameter] (https://developers.google.com/workspace/drive/api/guides/fields-parameter): production API field selection and limited default field sets.
- [AWS HTTP API quotas] (https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-quotas.html): scoped example of a hard infrastructure payload quota; not generalized to other API types/streaming.
- [Cloudflare Content compression] (https://developers.cloudflare.com/speed/optimization/content/compression/): independent origin/client legs and recompression in a real service.
- [Django REST framework pagination] (https://www.django-rest-framework.org/api-guide/pagination/): page/offset/cursor variants and suitable ordering.
- [GitHub pagination] (https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api): Link-based continuation in a real API.
- [WordPress pagination](https://developer.wordpress.org/rest-api/using-the-rest-api/pagination/): a real API's page-size cap.
- [WordPress Global Parameters](https://developer.wordpress.org/rest-api/using-the-rest-api/global-parameters/): `_fields` avoids unnecessary internal computation/queries while generating a response.
- [GitHub REST best practices] (https://docs.github.com/en/rest/using-the-rest-api/best-practices-for-using-the-rest-api): conditional GET, stable/specific requests and the authorization condition for GitHub's primary-rate-limit exception.
- [Microsoft performance-efficiency guidance] (https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure): measured reduction of unnecessary work.
- [Microsoft response compression] (https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0): compression cost and dynamic HTTPS response considerations.

Persian sources checked for direct relevance:

- [Net Paradis REST design, pagination, filtering and versioning] (https://netparadis.com/rest-design-pagination-filtering-versioning/): used as a supplemental Persian reference for payload fields, pagination and request specificity.
- [mehdiMj Nginx compression/static-cache lesson](https://mehdimj.ir/blog/2026/10/08/nginx-night-16-static-cache-compression/): a concise Persian header/MIME/compression exercise, with its static-file scope clearly stated.No article was reproduced wholesale. All numerical teaching budgets and timing calculations are explicitly hypothetical, not published company benchmarks. Real-world sections use permitted authoritative operational documentation and disclose that a directly comparable incident/percentage improvement is not established. The server-work page explicitly notes the lack of a comparably direct Persian article about early internal field projection, rather than presenting an unrelated reference as proof.

## Inspection results

One-line check summary: 5/5 assigned README files present; 21/21 within-chapter relative-link occurrences resolve; 4 quizzes each contain 6 questions and 6 explained answers; code fences and RTL/LTR div boundaries balance; all four requested subjects meet the topic-page contract.

Manual content review included the arithmetic in the payload/compression examples, the offset-versus-cursor exercise result (`6,5,4` versus `5,4,3`), the caveat that cursor does not guarantee a snapshot, the request meaning of HTTP 413, absence of a response body in 304, authorization before conditional early return, the risk of hashing a fully built body too late to save CPU, and consistency of quiz answers with the lesson text.

PowerShell read-only document inspection enumerated files, resolved relative links and counted code fences/div boundaries and question/answer entries. This is documentation inspection, not software test execution. No lab/benchmark commands were run against a live service; Exercises are learner instructions. No software tests were added or run. A browser rendering pass was not performed, so final renderer-specific RTL/layout behavior remains an integration review item.

## Integration concerns

At the latest check, 18 cross-chapter link occurrences point to 9 not-yet-present spec-defined pages. The chapter-internal links and existing root/cache links resolve. These pending targets are owned by other tasks; no out-of-scope files were created to fill them:

- `03-asynchronism/01-background-jobs/README.md`
- `04-databases/03-orm-fetch-strategies/README.md`
- `04-databases/04-efficient-database-pagination/README.md`
- `04-databases/05-select-only-needed-columns/README.md`
- `06-code-optimization/01-streaming-large-bodies/README.md`
- `06-code-optimization/04-critical-paths/README.md`
- `08-security/03-throttling-and-rate-limiting/README.md`
- `10-network/01-region-and-network-latency/README.md`
- `10-network/03-cdn-for-static-and-frequent-content/README.md`

The parent should rerun the pack-wide local-link check once the remaining chapters exist. External resources and vendor quotas can change after the recorded research date; the material points to owning documentation and scopes product-specific behavior explicitly.


## Snapshot: Backend Performance/02-api-response/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: #Chapter 02: API Response — Necessary data, with appropriate work and transfer
   4:5: Query speed alone is not enough when the user opens the list of orders. Creating thousands of objects, calculating unused fields, converting them to JSON, transferring a few megabytes and parsing on the phone also costs money. This chapter connects four decisions: what data to return, how many, with what encoding, and after how much processing.
   6: 
   7: This chapter is part of [Backend Performance Package](../README.md) and corresponds to the API Response section in [Base Roadmap](https://roadmap.sh/backend-performance-best-practices). Source review date: **11-10-2026**. The numerical examples of this chapter are educational; They are not general performance goals for all services.
   8: 
   9: ## Prerequisite and result of learning
  10: 
  11: Be familiar with Request/Response in HTTP, JSON, Header, Status Code and a List Endpoint. Knowing the concept of Query and Index is enough; No special language or cloud is required. After reading, you can set a size budget for an Endpoint, check the Compression negotiation, create a Pagination contract, and eliminate redundant work before implementation.
  12: 
  13: ## Suggested order of study
  14: 
  15: Order lesson | The main question Practical output
  16: --- | --- | --- | --- |
  17: 1 [Payload size and limit](01-payload-size/README.md) | Should this data be in this response at all? | Fields contract, item/byte limit and overflow behavior
  18: 2 | [Response Compression](02-response-compression/README.md) | How to transfer the required bytes more cheaply? | Correct header, compression ratio and CPU cost
  19: 3 [Efficient Paging API](03-efficient-pagination/README.md) | How does the client go through the collection step by step? | Page size, order, token and end of navigation
  20: 4 | [Remove unnecessary processing](04-avoid-unnecessary-server-work/README.md) | Which calculation can not be done? | Implementation program based on fields and cheap Revalidation
  21: 
  22: Size and Pagination are related: the limit of 50 records does not create a byte limit for a record that has a large file inside. Compression is not a substitute for these two; Finally, the client must keep the opened data in memory. Turn on the response convention first and then measure the effect of each layer.
  23: 
  24: ## common scenario of the chapter
  25: 
  26: **hypothetical scenario:** The store order list sends all the history, items, photos in JSON and the customer's calculated score on each visit; The interface only shows ID, date, status and amount.
  27: 
  28: 1. Define a summary representation; Details and files should have separate paths. Record the opened and transferred size separately.
  29: 2. Limit the number of outputs and continue the link; Write the order and behavior of changing data between pages.
  30: 3. Compress the big enough JSON in the responsible layer with Encoding accepted by the client; See the result from the consumer's point of view.
  31: 4. Calculate points and retrieve items only in the details request. If the summary view has not changed, check its validity before the full build.
  32:33: The success of this scenario is not just "smaller JSON". Also compare the number of dependent queries/invocations, CPU per request, memory, time to first byte and total response time, p95/p99 and client errors. Percentage improvement without a baseline and the same conditions has little practical meaning.
  34: 
  35: ## The border of this chapter and related chapters
  36: 
  37: Related topic The responsibility of this chapter Supplementary study
  38: --- | --- | --- |
  39: Pagination in the database General page contract, Token and client behavior [Run Query, Offset/Keyset and Index] (../04-databases/04-efficient-database-pagination/README.md) |
  40: Column selection External need for fields and summary display [Projection in the database] (../04-databases/05-select-only-needed-columns/README.md) |
  41: HTTP caching Cheap detection of "display not changed" | [Cache Layers] (../01-caching/01-cache-layers/README.md) and [Frequency and Revocation] (../01-caching/04-invalidation-and-freshness/README.md) |
  42: Large file Limitation of interactive response and separate export route [Streaming](../06-code-optimization/01-streaming-large-bodies/README.md) and [Background Work](../03-asynchronism/01-background-jobs/README.md) |
  43: Network delivery Encoding and the size of the response body [Delay and Region](../10-network/01-region-and-network-latency/README.md) and [CDN](../10-network/03-cdn-for-static-and-frequent-content/README.md) |
  44: 
  45: ## Chapter Review Checklist
  46: 
  47: - [ ] the consumer and the required fields are specified; The list answer differs from the details.
  48: - [ ] Number limit, byte size, expand depth and error behavior are documented.
  49: - [ ] The size of the unpacked JSON and the transmitted body are measured separately.
  50:- [ ] Encoding, `Vary` and Reverse Proxy/CDN behavior are checked from the client's point of view.
  51: - [ ] Pagination is defined from the first page to the end, on the empty set and the changing data.
  52: - [ ] The unselected field does not cause query execution or expensive calculation.
  53:- [ ] Eliminating additional work does not eliminate licensing, data integrity and event logging obligations.
  54:- [ ] For every change, there is a baseline, an expected observation, and a way back.
  55: 
  56: ## Help sources
  57: 
  58: - [Persian: REST Design, Pagination and Field Selection — Netparadis](https://netparadis.com/rest-design-pagination-filtering-versioning/): to link API contract decisions; Adapt the recommendations to the actual need.
  59: - [Google API Design Guide](https://docs.cloud.google.com/apis/design): Contract design framework; Pagination details in the third lesson refer to AIP-158.
  60: - [Microsoft Well-Architected: Optimize code and infrastructure](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure): Reduce unnecessary consumption by measurement, considering infrastructure cost.
  61: 
  62: **Continued:** [Lesson 1 — Payload Size](01-payload-size/README.md) · [Main List](../README.md)
  63: 
  64: </div>

## Snapshot: Backend Performance/02-api-response/01-payload-size/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: # Payload size and limitation
   4: 
   5: Payload is the body of the message; In this lesson, the focus is on API response data. "Low-volume response" means that the data volume should be proportional to the consumer's needs. "Limit" means the contract to stop the unbridled growth of the number of items, the size of the field, or nested Expand. Infrastructure ceiling is not equal to user experience budget.
   6:7: **After this lesson you can:** Interpret the opened and transferred size separately; Create summary view; Define item and byte ceiling together; And design an understandable way out for the big answer. Prerequisite: JSON and HTTP. Source review date: **11-10-2026**.
   8: 
   9: ## Mental model: The cost starts before the network
  10: 
  11: stage | A fee that grows with additional data Review question
  12: --- | --- | --- |
  13: Fetch | Read column/relation, transfer from DB | Does the user need this field? |
  14: Build the answer Allocation, Calculation, Serialization | Is the list view independent of the detail view? |
  15: Transfer Byte on the network and receiving time Is the actual size of the transfer recorded? |
  16: Consumption Decompression, Parse, Memory and Render | Can the weak phone consume the response? |
  17: 
  18: Compression shortens the transfer step, but the number of records and the JSON structure after decompression are the same. Field selection should be applied as far as possible before fetching/calculation; Removing the field at the end of the Serializer only reduces part of the cost. The official Google Drive sample documents the `fields` parameter to request a subset of data; This functionality is contractual and not present in any API by default. [Source: Drive fields] (https://developers.google.com/workspace/drive/api/guides/fields-parameter)
  19: 
  20: Suggested decision path:
  21: 
  22: 1. Write the fields really needed for each consumer; For example, "order card" does not need the history of all items.
  23: 2. Default to a summary answer and make the big details/relationship available by explicit request. Do not forget the fields that are required to continue the page, such as Token.
  24: 3. Limit the number of items, the length of free fields, the number and depth of Expand and the bytes of the expanded body. Select the numerical ceiling with the actual data and product requirement.
  25: 4. Measure the opened size, transferred size and peak memory separately; `Content-Length` may show a compressed size in the compressed response or not at all.
  26: 5. Define limit crossing in contract: smaller page with continue link, parameter modification request, or separate export. Do not break the JSON body in the middle of an object.
  27: 
  28: ### Educational budget and hard ceiling
  29: 
  30: Limit type Hypothetical example Designed behavior
  31: --- | --- | --- |
  32: Monitoring budget p95 The unpacked body of the list below 100 KiB | Schema change alert and check; It is not necessarily an error
  33: Number ceiling `page_size <= 50` | Clamp or parameter error, according to the document convention
  34: Byte ceiling Maximum 256 KiB for each page of this API less than the ceiling of the return item; Continue Token
  35: Very large single field | Explanation 2 MiB in one item Document summary and detail path/separate file
  36: 
  37: These numbers are **not a general offer or the result of production testing**. If the byte limit does not fit an item, reducing the number of pages is not enough; The display of that item or delivery route must be changed. The client should also not consider "less than `page_size`" to be definitive; Token contract is decisive.
  38:39: ## Solved example: order card
  40: 
  41: **hypothetical scenario:** Previous endpoint returns 100 orders, along with history and JSON file. The interface only displays the summary. The new contract is as follows:
  42: 
  43: <div dir="ltr" align="left">
  44: 
  45:```http
  46: GET /v1/orders?page_size=2&fields=id,status,total HTTP/1.1
  47: Host: api.example.test
  48: Accept: application/json
  49: ```50: 
  51:```json
  52: {
  53:   "items": [
  54:     {"id": "o-102", "status": "paid", "total": 480000},
  55:     {"id": "o-101", "status": "pending", "total": 120000}
  56:   ],
  57:   "next_page_token": "opaque-token-1"
  58: }
  59: ```60: 
  61: </div>
  62: 
  63: In the convention of this example, `fields` controls only the fields inside `items`; Metadata always remains. Permission to view fields is checked independently of this parameter. Unknown field request has parameter documented error. A license detail URL replaces the automatic file transfer; This URL should not provide permanent public access to the private file.
  64: 
  65: Suppose that in the training baseline, 100 items x 20 KiB equals about 2000 KiB of item data. The summary display of 50 items x 0.5 KiB is about 25 KiB; Envelope and Header are separate. This account shows that reducing the number and reducing the size of each item are two independent levers; Measure the actual ratio by the serialized JSON, not by the size of the object in memory.
  66: 
  67: ## Short exercise and expected observation
  68: 
  69: Create a local JSON instance of 20 orders, each with a long description and history. Generate two files without server: "All fields" and "`id,status,total` only". Read the stored UTF-8 size in PowerShell:
  70: 
  71: <div dir="ltr" align="left">
  72: 
  73:```powershell
  74: Get-Item -LiteralPath .\orders-full.json, .\orders-summary.json |
  75:     Select-Object Name, Length
  76: ```77: 
  78: </div>
  79: 
  80: Then add an item with a very large description and compare the sizes again. **Expectation:** The number of items is fixed, but the full size increases; The summary display should not have the same growth history as the growth. Note the difference in bytes versus the number of characters, especially for Persian UTF-8 text. This exercise shows the size; The claim of reducing latency or CPU requires measuring the server.
  81: 
  82: ## True witness and its limitations
  83: 
  84: **Official Working Witness:** The Google Drive documentation for `files.list` introduces a limited default field set and explains the ability to request specific fields. This is a real API reference example; This page does not prove the percentage of improvement of our service. [Drive fields parameter] (https://developers.google.com/workspace/drive/api/guides/fields-parameter)
  85: 
  86: **Actual infrastructure limit:** The HTTP API table in Amazon API Gateway shows Payload as 10 MB and non-scalable as of review date. This number corresponds to the same type of API; Do not extend it to all Gateways, Streaming APIs, or response states. [Official HTTP API quotas table] (https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-quotas.html)
  87: 
  88: `413 Content Too Large` indicates that **request content** is large; Don't assume it's a generic "server response is too big" code. For large output, execute Page/Export contract before sending Header. [MDN: 413](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/413)
  89: 
  90: ## Costs, fit and common failures
  91: 
  92: The fixed display of the summary is simpler and its cache is more predictable. Free field selection gives flexibility to different clients, but cache combinations further enhance documentation and permission checking. For a small API with a response of several hundred bytes, a complex Projection language may cost more than the savings. For full export, check the file path/Streaming; Do not limit the interactive response limit.
  93: 
  94: Failure Operational sign | Action |
  95: --- | --- | --- |
  96: Limit the number without limiting the large field | p99 size has the same number of mutations | Control the maximum item size and Expand separately
  97: Delete the field only after expensive queries Byte decreased but DB/CPU is stable Apply Projection and fetch program early
  98: Silent send incomplete output The user loses part of the orders Metadata Document the continuation and meaning of the summary
  99: Sudden deletion of an existing field Old client error Design compatible version/change and migration period
 100: Registering a large body in Log | Cost and delay Log or data disclosure record the size and type of display; The body is not necessary
 101: 
 102: ### Operational checklist
 103: 
 104:- [ ] Required fields are registered for Endpoint and main consumer.
 105: - [ ] Item ceiling, bytes, field length and Expand are defined together.
 106: - [ ] The behavior of exceeding the limit and the single item is too large is turned on.
 107: - [ ] The opened/transmitted size and p95/p99 are recorded separately by Route.
 108: - [ ] Sensitive field is not exposed by user selection or automatic Serializer.
 109: - [ ] The empty set scenario, long Persian text and old client have been reviewed.
 110:111: ## Quiz — Solve without answers first
 112: 
 113: 1. Why doesn't the 50 item cap alone guarantee the byte cap?
 114: 2. Answer 2 MiB after gzip to 100 KiB; Has Parse client's memory decreased by 95%?
 115: 3. If `fields=id` is applied only at the end of the Serializer, which cost might remain?
 116: 4. Is `413` the standard response to "My output JSON is large"?
 117: 5. Due to the byte limit, the page has 18 items out of the 50 limit, and the continuation token is also available; Should the client stop?
 118: 6. How much does it cost to add a free Projection compared to a fixed summary display?
 119: 
 120: ### descriptive answer
 121: 
 122: 1. The size of the items is not the same; A long field or inline file can break the budget. Both count and bytes are required.
 123: 2. No; The data after unpacking is almost the same JSON as before. Parse memory depends on the opened view and Runtime.
 124: 3. Retrieving relationships, transferring DB and calculating fields; A field-based implementation program must decide early.
 125: 4. No; It means the content of the request is larger than the accepted limit. The output solution must be defined in the API contract.
 126: 5. No; Token goes on to say that more results can be requested. A number below the ceiling does not automatically signal the end.
 127: 6. Creates more combinations for authorization, cache and contract maintenance; Accept this complexity only with real need.
 128: 
 129: ## Further study
 130: 
 131: - [Persian: Field selection section in REST design — Netparadis] (https://netparadis.com/rest-design-pagination-filtering-versioning/): Introduction related to `fields` and `include`; The resource is complementary, not the reference for the behavior of all APIs.
 132: - [English: Google Drive fields] (https://developers.google.com/workspace/drive/api/guides/fields-parameter): Detailed example of field selection contract and invalid selection error.
 133: - [English: MDN Content-Length](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Length): to interpret body length; Header does not take the place of measuring all steps.
 134: - [English: AWS HTTP API quotas](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-quotas.html): Example of infrastructure hard cap, checkable when choosing a delivery route.
 135: 
 136: **Navigation:** [API Response Chapter](../README.md) · [Main Index](../../README.md) · [Next: Compression](../02-response-compression/README.md)
 137: 
 138: **Related:** [Pagination API](../03-efficient-pagination/README.md) · [DB Column Selection](../../04-databases/05-select-only-needed-columns/README.md) · [Streaming](../../06-code-optimization/01-streaming-large-bodies/README.md)
 139: 
 140: </div>

## Snapshot: Backend Performance/02-api-response/02-response-compression/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: # response compression — Response Compression
   4: 
   5: Compression makes the byte representation of the same content smaller for transmission; It does not semantically abstract JSON. Server and client must agree on Encoding. Byte reduction reduces network overhead, but compressing and decompressing it requires CPU; A good decision is the result of comparing these costs.
   6:7: **After this lesson, you can:** Explain the role of the three main headers; Don't confuse the transfer size with the opened body; Determine the layer responsible for compression; And measure network gain along with CPU, latency and sensitive content risk. Prerequisite: HTTP Header and [Payload Size](../01-payload-size/README.md). Source review date: **11-10-2026**.
   8: 
   9: ## How does Encoding negotiation work?
  10: 
  11: Component | role Example
  12: --- | --- | --- |
  13: `Accept-Encoding` in request | Acceptable algorithms for the client `gzip, br` |
  14: `Content-Encoding` in reply | Encoding actually applied to the body `gzip` |
  15: `Vary: Accept-Encoding` in reply | Inform the Cache about the dependence of the display on the Request Header The compressed and raw versions should not be delivered to each other by mistake
  16: `Content-Type` | Opened content type Still `application/json` |
  17: 
  18: The client declares its support; The server selects an acceptable and supported Encoding and sends the body with it. When the display selection depends on `Accept-Encoding`, `Vary` must express this dependency. gzip is usually useful for text/JSON; Compressing a JPEG or ZIP again is usually of little benefit. [MDN: Compression in HTTP] (https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression)
  19: 
  20: You should not send raw JSON body by adding only `Content-Encoding: gzip`; The header must describe the actual bytes. On the contrary, gzip body without proper Header cannot be interpreted by the consumer. `Content-Length`, if present, specifies the length of the encoded message; Do not copy it after changing the Encoding from the previous value. [MDN: Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding)
  21: 
  22: ### Choosing the location and level of compression
  23: 
  24: 1. Write the delivery path: Application → Reverse Proxy → CDN → Client. See the response behavior at each hop, not just the program setting.
  25: 2. Set a clear owner for the Policy. If they convert multiple layers, the responsibility of Header, Validator and Decompression/Recompression should be known.
  26: 3. Specify the MIME Type, minimum size, and allowed algorithms. The appropriate threshold depends on your data, CPU, and network conditions.
  27: 4. Select compression level with p95/p99 and CPU for high traffic dynamic response. The lowest byte is not necessarily the lowest latency.
  28: 5. Precompress and distribute fixed assets if possible; For streaming response, consider Buffer and Flush cost as well.
  29: 
  30: Compression is suitable for medium/large text response on limited link. For a very small response, a pre-compressed file, or a CPU-bound service, the benefit may be negligible or negative. If you are sending unnecessary data, first modify [Payload](../01-payload-size/README.md); The client will continue to parse additional data after opening.
  31: 
  32: ## Solved example of HTTP and thumb account
  33: 
  34: <div dir="ltr" align="left">
  35: 
  36:```http
  37: GET /v1/orders?page_size=50 HTTP/1.1
  38: Host: api.example.test
  39: Accept: application/json
  40: Accept-Encoding: gzip
  41: ```42: 
  43:```http
  44: HTTP/1.1 200 OK
  45: Content-Type: application/json
  46: Content-Encoding: gzip
  47: Vary: Accept-Encoding
  48: 
  49: [gzip-encoded bytes of the JSON representation]
  50: ```51: 
  52: </div>
  53: 
  54: The last line is the educational representation of the binary body; You should not implement that text as the actual body of the server. In the example above, we deliberately did not write a number `Content-Length`, because the length must be calculated from the actual output byte.
  55: 
  56: **hypothetical scenario:** JSON equals 200 KiB; The result of local gzip measurement is 40 KiB. Output to input ratio is 0.2 and byte saving is 80%. On a hypothetical 1 MiB/s link, the net transfer portion goes from about 195 to 39 ms; RTT, queue, TLS and processing are not included in this account. If compression costs 5 milliseconds, there is a possibility of profit; This choice may be worse if it adds 200ms of CPU queue under load. These numbers are not production reports.
  57: 
  58: ## Short exercise: see the actual response from the client side
  59: 
  60: On your local Endpoint or test environment that has a big enough JSON response, send two requests to the same URL with the same permission. `localhost:8080` is hypothetical in this exercise and should be replaced with your test service. On Windows use `curl.exe`:
  61: 
  62: <div dir="ltr" align="left">
  63: 
  64:```powershell
  65: curl.exe -sS -H "Accept-Encoding: identity" -D identity-headers.txt -o identity-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
  66: curl.exe -sS -H "Accept-Encoding: gzip" -D gzip-headers.txt -o gzip-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
  67: Get-Item -LiteralPath .\identity-body.bin, .\gzip-body.bin |
  68:     Select-Object Name, Length
  69: ```70: 
  71: </div>
  72: 
  73: `--compressed` is not used in these two commands so that the body tool does not open automatically; The second file has compressed bytes if gzip is accepted. **Expect:** In the qualified path, the second Header is `Content-Encoding: gzip` and the transmitted size is smaller; The first answer should not claim gzip. If no difference, check MIME Type, Threshold, Supported Encoding and Proxy behavior. Compare several times with fixed data and specified Cache mode; A time measurement does not prove improvement. You can send a separate request with `--compressed` to check the validity of the unpacked JSON.
  74: 
  75: ## True witness and its limits
  76: 
  77: **Cloudflare operational documentation:** Compressing the origin path to the Cloudflare network and its path to the visitor is separate. This Reverse Proxy can convert between raw and compressed rendering, and some content changes require decompression and recompression. Practical consequence for troubleshooting: Header and size observed in Origin are not necessarily the same as the final output of the client. [Cloudflare: Content compression] (https://developers.cloudflare.com/speed/optimization/content/compression/)
  78: 
  79: This evidence comes from the behavior of a real service; Our program is not a comparative test or a percentage savings guarantee. Double-check your CDN settings and limitations when running; Do not make an "HTTP standard number" out of a product-specific threshold.
  80: 
  81: ## failures, risks and symptoms
  82: 
  83: Failure Sign | Action |
  84: --- | --- | --- |
  85: Very heavy level on dynamic response Fewer bytes, more CPU and p99 | Compare lighter layers and layer owner
  86: Incorrect header or incompatible conversion Decode/JSON error in client | Check the real byte and header of each hop together
  87: `Vary` Incomplete | The problem is only for part of the clients behind Cache Modify display policy and cache key
  88: Relying on DevTools' unpacked size instead of transferring | Wrong savings report Record transfer size and decoded size separately
  89: Buffering the entire streaming response Increasing the memory and time of the first byte Check Buffer size and Flush behavior
  90: 
  91: **Sensitive Content:** Combining secret data and attacker-controllable input in a dynamically compressed response can leak information from changing the response length; HTTPS does not solve this problem alone. The ASP.NET Core documentation warns about the risk of compression on dynamic and secure responses. This does not mean that all compressed JSON is unsafe; Check the sensitive endpoint and threat model. [Microsoft: Response compression] (https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0)
  92: 
  93: ### Operational checklist
  94: 
  95:- [ ] MIME Type, Threshold, Encoding and Owner Policy are on.
  96: - [ ] request without compression and with any supported encoding gets correct response.
  97: - [ ] `Content-Encoding`, `Vary` and body length are compatible with actual bytes.
  98:- [ ] Decompressed size, compression ratio, CPU, TTFB and p95/p99 are recorded.
  99: - [ ] Checked final behavior after Proxy/CDN and Cache effect.
 100: - [ ] Sensitive responses and pre-compressed data are checked separately.101:- [ ] For Streaming, Buffer memory and Flush latency are under observation.
 102: 
 103: ## test
 104: 
 105: 1. What is the difference between `Accept-Encoding` and `Content-Encoding`?
 106: 2. Why is `Vary: Accept-Encoding` necessary in selecting Encoding based on request?
 107: 3. Should `Content-Type` change compressed JSON response to `application/gzip`?
 108: 4. The output has gone from 200 to 40 KiB, but p99 has gotten worse; What are the next two reviews?
 109: 5. Is just seeing `Content-Encoding` in Origin enough to prove the final output?
 110: 6. Why is "compress all HTTPS responses with the heaviest level" not a defensible decision?
 111: 
 112: ### descriptive answer
 113: 
 114: 1. The first expresses the client's ability/preference; The latter declares the Encoding actually applied to the response body.
 115: 2. Cache must recognize representations dependent on client capability; Otherwise it may deliver inappropriate display.
 116: 3. No; The unwrapped content type is still JSON. `Content-Encoding` describes its transitive transformation.
 117: 4. Measure CPU and queuing/compression time and see Buffer/TTFB; Fewer bytes are not enough for total latency.
 118: 5. No; Proxy/CDN may perform conversion or recompression. From the consumer's point of view, check both Header and Byte.
 119: 6. CPU cost, size and type of content, buffering and risk of sensitive content are different; Level and range should be selected by measurement.
 120: 
 121: ## Further study
 122: 
 123: - [Persian: EnginX; Fixed file compression and cache] (https://mehdimj.ir/blog/2026/10/08/nginx-night-16-static-cache-compression/): MIME short practice, `gzip_vary` and Header viewing; The example domain is a fixed file.
 124: - [English: MDN Compression in HTTP] (https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression): content negotiation model and algorithm differences.
 125: - [English: MDN Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding): body interpretation reference and content type.
 126: - [English: Microsoft response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0): Trade-off, HTTPS considerations and an example implementation; .NET dependency is not required to understand this lesson.
 127: - [English: Cloudflare Content compression](https://developers.cloudflare.com/speed/optimization/content/compression/): Multi-stage delivery and Proxy transformations.
 128: 
 129: **Navigation:** [API Response Chapter](../README.md) · [Main Index](../../README.md) · [Previous: Payload](../01-payload-size/README.md) · [Next: Pagination](../03-efficient-pagination/README.md)
 130: 
 131: **Related:** [Streaming](../../06-code-optimization/01-streaming-large-bodies/README.md) · [CDN](../../10-network/03-cdn-for-static-and-frequent-content/README.md) · [Network Latency](../../10-network/01-region-and-network-latency/README.md)
 132: 
 133: </div>