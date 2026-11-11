# Read-only Task 3 review supplement

## Snapshot: Backend Performance/02-api-response/03-efficient-pagination/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: # Efficient Pagination API — Efficient Pagination
   4: 
   5: Pagination is the convention of seeing a collection in a limited number of responses. The API tells the client what to return, how to proceed, and when browsing is complete. This contract both controls the size of each response and prevents the client from being required to maintain the entire collection.
   6: 
   7: **After this lesson, you can:** differentiate between API contract and query execution; Choose Page/Offset/Cursor according to the application; Define page cap, order, end and token error; and explain the effect of changing data between pages. Prerequisite: Listed Endpoint and [Payload Budget](../01-payload-size/README.md). Source review date: **11-10-2026**.
   8: 
   9: ## Strict API and database boundary
  10: 
  11: layer Responsibility Sample question
  12: --- | --- | --- |
  13: API Pagination, the topic of this page | Request and response contract, Token, sequence, termination and compatibility What request should the client send after this page? |
  14: Database Pagination Limited and regular implementation of Query, Keyset/Offset, Index and Plan How many rows does the DB read for the next page? |
  15: 
  16: Having `page_size=20` in the URL does not guarantee that the DB will only process 20 rows; The program may fetch all the data and then slice it. Conversely, Query with a good `LIMIT` does not continue the contract on its own to the client. SQL, Compound Index and Offset Cost are taught in depth in [Database Paging](../../04-databases/04-efficient-database-pagination/README.md); Here we focus on external commitment.
  17: 
  18: ## Choosing the form of the contract
  19: 
  20: Method Request sample Suitable for | Cost/Limit |
  21: --- | --- | --- | --- |
  22: Page number `?page=4&page_size=20` | Link to "Go to Page 4" | Insert/delete can move page border; Deep implementation should be investigated
  23: Limit/Offset | `?limit=20&offset=60` | Simple consumption and small set/low change Offset is large and changing the data at the same time is troublesome
  24: Cursor/Token | `?page_size=20&page_token=...` | Feed and sequential navigation of the large collection Arbitrary jump and total number are not simple; Requires order and valid Token |
  25: 
  26: Cursor is the name of a contract family; Each Token is not necessarily an SQL Keyset. Token can be a reference to position, Snapshot, or server-side status. "Cursor is always O(1)" or "Cursor always gives a complete Snapshot" is not a true claim about all APIs. The Django REST documentation shows examples of all three styles and Cursor requirements in the appropriate order; Do not generalize the exact behavior of that framework to all implementations. [Django REST pagination](https://www.django-rest-framework.org/api-guide/pagination/)
  27: 
  28: ### Components to be turned on before launch
  29: 
  30: 1. **Page size:** Document the default and maximum value. If the request is more than the ceiling, run the Clamp or parameter error uniformly; The number returned may be less due to the byte limit.31: 2. **Definite order:** eg `created_at DESC, id DESC`. Date alone is not enough, as multiple records can have the same time. The mutable order field requires an explanation of the shifting behavior.
  32: 3. **Continuation and end:** `next_page_token` or `next` link is the continuation criterion. In the Token contract, the short page is not necessarily the end; Even a blank page can persist Token.
  33: 4. **Token obfuscated for client:** The consumer must not parse or construct its structure. Token is status, not permission; The accessibility of each page should be rechecked.
  34: 5. **Consistency of parameters:** Connect Filter, Order, Tenant and related view to navigation. Changing the filter along with the old Token should have a specific behavior.
  35: 6. **Expiration and Data Change:** Define invalid/expired Token error and restart way. For audit report, Snapshot or Export with fixed data boundary is required; Live feed has a different need.
  36: 
  37: These principles are in line with [Google AIP-158](https://google.aip.dev/158): see pagination from the beginning in the collection contract; Token is opaque for the client; Do not use Token instead of Authorization. AIP has specific rules for APIs following it; The ceiling number and error shape of our example is an independent training contract.
  38: 
  39: ## Solved example: List of paid orders
  40: 
  41: **hypothetical contract:** Default 20 and maximum 50 items; More than the ceiling becomes 50 Clamp; It has a negative number `400`. descending order `(created_at,id)`; Token is connected to Tenant and Filter. The end is indicated by the deletion of `next_page_token` and there is no default `total_count`.
  42: 
  43: <div dir="ltr" align="left">
  44: 
  45:```http
  46: GET /v1/orders?status=paid&page_size=2 HTTP/1.1
  47: Host: api.example.test
  48: Accept: application/json
  49: ```50: 
  51:```json
  52: {
  53:   "items": [
  54:     {"id": "o-104", "created_at": "2026-11-10T08:00:00Z"},
  55:     {"id": "o-103", "created_at": "2026-11-10T08:00:00Z"}
  56:   ],
  57:   "next_page_token": "opaque-token-a"
  58: }
  59: ```60: 
  61:```http
  62: GET /v1/orders?status=paid&page_size=2&page_token=opaque-token-a HTTP/1.1
  63: Host: api.example.test
  64: Accept: application/json
  65: ```66: 
  67:```json
  68: {
  69:   "items": [
  70:     {"id": "o-102", "created_at": "2026-11-10T07:00:00Z"}
  71:   ]
  72: }
  73: ```74: 
  75: </div>
  76: 
  77: The above tokens are placeholders only. In the implementation, use a validable token or server-side mapping; Base64 alone does not prevent data manipulation or disclosure. If it contains sensitive data, the signature only preserves authenticity and does not create confidentiality. Design the token to be short-lived and without sensitive information or use a suitable protection mechanism.
  78: 
  79: In this example, if a new order with a newer time is added between two requests, continuing from the previous border can prevent repeating the beginning of the Feed; But it doesn't guarantee to see all modifiable records exactly once. Deleting, changing the status, or changing the sort field can change the result. Define the required guarantee for Feed, management navigation and financial output separately.
  80: 
  81: **Why don't we have a default Count?** Knowing "is there a continuation?" With "exactly how many total results?" not one Count can be a separate and expensive Query and quickly become obsolete with variable data. If the product requires quantity, document cost, freshness, and precision/estimate.
  82: 
  83: ## Short exercise and expected observation
  84: 
  85: On paper or in a file, consider a descending index of `8,7,6,5,4,3` and a page size of 3. The homepage is `8,7,6`. Add `9` to the beginning before the second page.
  86: 
  87: 1. Find the second page with Offset equal to 3.
  88: 2. Find the second page with the border "after ID 6 in descending order".
  89: 3. Now remove record 5 status from Filter; Do you still have a fixed Snapshot?
  90: 
  91: **Expect:** Second page offset gives `6,5,4` and repeats 6. The sample boundary gives `5,4,3`. The output of record 5 from Filter indicates that Keyset is not a simple Snapshot. This is a contract simulation; Check the performance of Query and Index in separate DB chapter.
  92: 
  93: ## True witness and its limits
  94: 
  95: **GitHub REST API:** The official guide explains the use of the `Link` Header and the `next` relation to navigate to the next pages; Parameters can vary between endpoints. Follow the link instead of guessing the next URL. This is an actual API consumption contract; We do not get numerical results about latency from it. [GitHub: Using pagination](https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api)
  96: 
  97: **WordPress REST API:** Accepts `per_page` between 1 and 100 and specifies a cap to prevent very large queries. This is a WordPress-specific cap, not a recommended cap for all APIs. [WordPress: Pagination](https://developer.wordpress.org/rest-api/using-the-rest-api/pagination/)
  98: 
  99: The evidence of this lesson is the operational documentation of services and Framework; A study before/after a specific incident with the same percentage of improvement was not found and such a result is not claimed.
 100: 
 101: ## failures and operational symptoms
 102: 
 103: Failure sign | Correction
 104: --- | --- | --- |
 105: `page_size` ceilingless or `include` limitless | Large response, memory and disproportionate p99 | Apply the number/byte/expand limit at the same time106: Slice after fetching the entire set | DB and RAM grow with total data Transfer the constraint to the Query program
 107: Indeterminate or changeable order Duplicate/lost records between pages Turn on tie-breaker and navigation guarantees
 108: Token instead of license Access to another Tenant with Token | Check the tenant and license of each page
 109: The client guesses the end with the page length | Early stop and incomplete data Measure Token/Continuation Link
 110: Accurate count on all pages Count time is the main part of Trace Count optional/separate with clear meaning
 111: Capture all pages with unlimited Parallel Burst and Rate Limit error Set the budget and concurrency limit for Export
 112: 
 113: ### operational checklist
 114: 
 115: - [ ] Default/Max size, invalid number and clamp behavior are documented.
 116: - [ ] The definite order and the meaning of simultaneous change of the data are known.
 117: - [ ] Token is attached to the contract and scope of access; License is independently reviewed.
 118: - [ ] end, empty page with continuation, broken token and expiration are defined.
 119: - [ ] Query is actually executed pagewise and Count is measured separately.
 120:- [ ] Record duplication, Token error, number of pages traversed, bytes/page and p95/p99 are monitored.
 121: - [ ] Audit/Export navigation has clear Snapshot boundaries if needed.
 122: 
 123: ## test
 124: 
 125: 1. Does the presence of `page_size` in the API prove that Query is working?
 126: 2. Why might sorting by `created_at` alone not be sufficient?
 127: 3. Page 7 items from ceiling 20 and Token continue; What is the client's action?
 128: 4. Does Simple Cursor Guarantee Constant Snapshot?
 129: 5. Does base64ing the last identifier make the token secure and authorized?
 130: 6. For an interface with direct jump to page 25, why might Cursor be an expensive choice?
 131: 
 132: ### descriptive answer
 133: 
 134: 1. No; All data may be fetched and then sliced. Query execution, number of rows read and Plan are checked separately.
 135: 2. Several records can have equal time; A stable tie-breaker such as ID creates a definitive order.
 136: 3. Send the next request with the announced token/link; Shorter length alone does not prove the end.
 137: 4. No; Cursor keeps the continued position, but the data/Filter can change. Snapshot requires independent assurance.
 138: 5. No; Base64 is the encoding. Token should not be a license and its content/integrity should be protected by design.
 139: 6. Cursor usually requires sequential scrolling and does not necessarily have a page number or count. Weigh product needs and cost of alternative methods.
 140: 
 141: ## Read more
 142: 
 143: - [Persian: REST and Pagination design — Netparadis] (https://netparadis.com/rest-design-pagination-filtering-versioning/): Comparison of Offset and Cursor in contract design text.
 144: - [English: Google AIP-158](https://google.aip.dev/158): Token meaning, page size and contract compatibility.
 145: - [English: Django REST pagination](https://www.django-rest-framework.org/api-guide/pagination/): PageNumber, LimitOffset and Cursor examples and ordering requirements.146: - [English: GitHub pagination](https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api): Use continuation links without depending on internal structure.
 147: - [English: WordPress pagination](https://developer.wordpress.org/rest-api/using-the-rest-api/pagination/): Example of page size ceiling and Metadata count.
 148: 
 149: **Navigation:** [API Response Chapter](../README.md) · [Main Index](../../README.md) · [Previous: Compression](../02-response-compression/README.md) · [Next: Removing Redundancy](../04-avoid-unnecessary-server-work/README.md)
 150: 
 151: **Related:** [Database Pagination](../../04-databases/04-efficient-database-pagination/README.md) · [Payload](../01-payload-size/README.md) · [Rate Limiting](../../08-security/03-throttling-and-rate-limiting/README.md)
 152: 
 153: </div>

## Snapshot: Backend Performance/02-api-response/04-avoid-unnecessary-server-work/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: # Remove unnecessary server processing
   4: 
   5: Unnecessary work is work that is not required for the desired result of this request: fetching a relation that is not displayed, calculating an unselected field, recreating an unchanged view, or calling a side service whose output is not consumed. First, check the reason for doing the work; Speeding up or parallelizing work that can be removed is not a good first step.
   6: 
   7: **After this lesson, you can:** Separate the critical path of a response into necessary and optional tasks; Make the field selection decision before the calculation; Implement revalidation without false promises about CPU; And confirm the task deletion with Trace and Counter. Prerequisites: HTTP, License Concept and [Payload Agreement](../01-payload-size/README.md). Source review date: **11-10-2026**.
   8: 
   9: ## Mental model: make a decision before doing the work
  10: 
  11: Application requirement Early decision Deleteable work
  12: --- | --- | --- |
  13: Order summary only Display summary and valid Field Set Details of items, calculation of customer statistics, their serialization
  14: Filter paid orders Pass valid filter to the data source Fetch all and filter in memory
  15: The previous display is still valid Cheap Validator comparison after checking access Rebuild and send the body
  16: How many times is the result of a lookup required in the same request? Reuse within the scope of the same request Repeated calls for the same key |
  17: Only the existence of the result is necessary Proportional existential measurement operation Count or load all records
  18: 
  19: These suggestions are not the "Cache every calculation" rule. First, see which work has what contribution with Trace and Profile. Microsoft guidance recommends using program components only when needed and reducing unnecessary consumption; Adding resources to cover the extra work doesn't fix the cause. [Microsoft Well-Architected] (https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure)
  20: 
  21: ### Method of checking an Endpoint
  22: 
  23: 1. **Write the required output:** Which field and validation is required for this consumer? Authorization, validation and event registration obligations are not considered "extra".
  24: 2. **Separate costs:** See the time and number of Query, network call, calculation, serialization and response bytes separately in Trace; Only the total duration is not enough.25: 3. **Declare the need early:** The fetch program should be made based on the view/allowed fields. Move the filter, screen ceiling and Projection to the appropriate layer.
  26: 4. **Remove Local Duplication:** Perform the same Lookup in the Request scope once, provided the freshness and authorization semantics remain the same. Cache has invalidation and user isolation rules between requests and is reviewed in [Cache chapter](../../01-caching/README.md).
  27: 5. **Design safe early exit:** Invalid input is rejected early; Check the unchanged view with Validator. Canceling the request can stop the remaining optional work, but should not leave the transaction or required business effect unfinished.
  28: 6. **Measure again:** If the bytes are reduced but the Query Count is constant, only the output is reduced; If p95 is better but the error or CPU is more, the result is not perfect.
  29: 
  30: ## Solved example: Summary that doesn't want heavy statistics
  31: 
  32: **hypothetical scenario:** Order page only asks for `id,status,total`. The previous implementation would load the items and get the client's score from another service each time, then the Serializer would remove the two. We move the summary display to the beginning of the path:
  33: 
  34: <div dir="ltr" align="left">
  35: 
  36:```text
  37: handleSummary(request):
  38:     principal = authenticate(request)
  39:     authorizeRead(principal, request.orderId)
  40:     fields = validateAllowedFields(request.fields)
  41:     plan = buildPlanFor(fields, view="summary")
  42: 
  43:     revision = readSummaryRevision(request.orderId, principal.tenant)
  44:     validator = makeWeakValidator(revision, fields, view="summary")
  45:     if matchesIfNoneMatch(request, validator):
  46:         return 304 with validator and private-cache-policy, no body
  47: 
  48:     summary = readAuthorizedSummaryProjection(plan)
  49:     if plan.needsItems:
  50:         summary.items = readItemsWithinBudget()
  51:     if plan.needsCustomerScore:
  52:         summary.customerScore = fetchCustomerScore()
  53:     return 200 with JSON(summary) and validatorFor(summary)
  54: ```55: 
  56: </div>
  57: 
  58: This pseudocode is not a complete HTTP algorithm or a specific language. Leave the `If-None-Match` comparison to the HTTP compatible library; A raw comparison of a string does not cover all Header states. [MDN: If-None-Match](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/If-None-Match) explains the meaning of the comparison and the necessary headers in the conditional response. `revision` should cover all view, tenant, field and contract version dependencies. If the data is changed between reading the version and reading the body, the output validator must be constructed from the same representation as the read, or there is a consistent read/retry; Do not paste the old revision into the new body.
  59: 
  60: Example exchange for a private display that must be revalidated before use:
  61: 
  62: <div dir="ltr" align="left">
  63: 
  64:```http
  65: HTTP/1.1 200 OK
  66: Content-Type: application/json
  67: Cache-Control: private, no-cache
  68: ETag: W/"o42-summary-fields-a-v7"
  69: 
  70: {"id":"o42","status":"paid","total":480000}
  71: ```72: 
  73:```http
  74: GET /v1/orders/o42?view=summary HTTP/1.1
  75: Host: api.example.test
  76: If-None-Match: W/"o42-summary-fields-a-v7"
  77: ```78: 
  79:```http
  80: HTTP/1.1 304 Not Modified
  81: Cache-Control: private, no-cache
  82: ETag: W/"o42-summary-fields-a-v7"
  83: ```84: 
  85: </div>
  86: 
  87: The client must have the previous body; `304` does not have a fresh body. `no-cache` allows saving with validation required; Not the same as `no-store`. Validator of this example is Weak and is used for GET validation; The allowed representations and the meaning of the change should be clear. This example does not display authentication and full environment headers. [MDN: HTTP caching] (https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching)
  88: 
  89: **KEY POINT:** If you build the ETag after executing all the queries and building the JSON with the body Hash, `304` will still decrement the transfer bytes, but most of the server processing is already done. CPU reduction occurs when you understand the validity of the display earlier and at a lower cost than building it. If you don't have a reliable Revision, don't claim a deletion calculation; Correct but late validation can also be useful.
  90: 
  91: ## Short exercise and expected observation
  92: 
  93: For a test handler or even manual simulation, put four counters: `summary_reads`, `items_reads`, `score_calls`, and `serializations`.
  94: 
  95: 1. Simulate the summary request with the old implementation: all counters are incremented.
  96: 2. Decide the fields before execution: make the summary but do not read the items and scores.
  97: 3. Simulate a conditional request with valid Validator and a request after state change.
  98: 
  99: **Expectation:** `items_reads` and `score_calls` remain zero in the second stage. In the `304` path with cheap Revision, Body Serialization and Details are not executed, but authorization checking and read credentials can remain. After changing the status it should return `200` and new data. If only the appearance of the JSON changes and the counters remain the same, you're not doing the deletion at the right layer. This exercise is not a proof of production performance or benchmark.
 100: 
 101: ## True witness and its limits
 102: 
 103: **WordPress REST API:** The `_fields` documentation explicitly says that WordPress leaves out unnecessary fields when generating the response object so that internal calculations and possible queries are not performed. This witness clarifies the difference between "not creating a field" and "clearing a field after creation" in a real implementation. [WordPress Global Parameters](https://developer.wordpress.org/rest-api/using-the-rest-api/global-parameters/)
 104: 
 105: **GitHub REST API:** Official manual describes conditional request with `ETag`/`If-None-Match` and response `304`; It also suggests that requests be specific and stable so that the display changes less randomly. `304` Exemption from the Primary Rate Limit on that service is dependent on a properly authenticated request; This is a GitHub rule, not public HTTP. The document doesn't say how much of GitHub's internal CPU is removed. [GitHub Best practices] (https://docs.github.com/en/rest/using-the-rest-api/best-practices-for-using-the-rest-api)
 106: 
 107: General operational evidence is used for this lesson; The latency/CPU reduction number for our hypothetical company or endpoint is not derived from these sources and is not claimed.
 108: 
 109: ## Trade-off and common failures
 110: 
 111: Decision/Failure consequence | The way to check
 112: --- | --- | --- |113: Delete the relationship only in the output N+1 queries and calculation remain | Compare Span and Query Count for each view
 114: Validator with incomplete dependency `304` error and old data Review changes to any visible dependencies
 115: Revalidation after complete Hash | Less network, almost previous CPU | Record the time of creating the Validator separately
 116: Cache result without tenant/license Disclosure of data Check the identity and scope of access in the design
 117: Parallelize all optional tasks Pressure to Pool/Dependency and Tail Latency | First, remove the useless work; Limit concurrency
 118: Removing necessary work under the title of optimization Incorrect validity, bypassed authorization or missing event Keep the business commitment as a condition of acceptance
 119: 
 120: Field based execution program for Endpoint has several useful views and calculations. To answer simply, many branches and complex revisions may make maintenance more difficult than real benefit; First, consider the two explicit "summary/detail" views. Moving the task to Background does not delete it; Changes the delivery time and guarantee and is subject to [background work](../../03-asynchronism/01-background-jobs/README.md).
 121: 
 122: ### Operational checklist
 123: 
 124: - [ ] Required fields and necessary business tasks are already known.
 125:- [ ] Authentication and authorization are applied before early exit.
 126: - [ ] Query/Dependent call not executed for unselected field.
 127:- [ ] Each Validator covers all dependencies and related representation.
 128: - [ ] Version and output body are contemporaneously compatible.
 129: - [ ] `304` percentage is measured next to CPU/Query Count; Alone is not the measure of success.
 130: - [ ] after data change, cache cold, request cancellation and dependency error behavior is clear.
 131: - [ ] p95/p99, Allocation, number of calls and user error compared to baseline.
 132: 
 133: ## test
 134: 
 135: 1. When does shrinking JSON not prove that the server is down?
 136: 2. Why hashing the full body for ETag might not reduce CPU much?
 137: 3. Does `304` allow access check removal?
 138: 4. A calculated field depends on two sources; Revision only covers one. What is the risk?
 139: 5. What is the difference between deleting a task and transferring it to Background?
 140: 6. What evidence shows that customer privilege removal was not actually implemented and not just hidden?
 141: 
 142: ### descriptive answer
 143: 
 144: 1. When the data/relationship and calculation are already done and the field is only deleted on exit. Trace and task counter should confirm the change.
 145: 2. Because the construction of the body, Query and calculation are done before Hash; The main saving could be just the transfer.
 146: 3. No; The user may no longer have access. A conditional request is also a request to access the same resource.
 147: 4. Changing the second resource may not change the ETag and generate an incorrect `304`; Validator should cover the actual representation.
 148: 5. Removal means that it is not necessary to consume the resources of that work; Background does the same thing later with a run/error commit.149: 6. `score_calls=0` in the summary path, the absence of relevant Span and the reduction of the dependency cost, next to the correct output; Just the absence of the field in JSON is not enough.
 150: 
 151: ## Further study
 152: 
 153: - [Persian: REST design, field selection and filter — Netparadis] (https://netparadis.com/rest-design-pagination-filtering-versioning/): Introduction to the contract `fields`/`include`; Regarding the actual removal of the work, there is no internal enforcement authority. In the present review, a direct Persian article with the same level of WordPress documentation for the early implementation of Projection was not found; The standalone explanation on this page covers this distance.
 154: - [English: WordPress Global Parameters](https://developer.wordpress.org/rest-api/using-the-rest-api/global-parameters/): Direct witness to save Calculation/Query with `_fields`.
 155: - [English: MDN HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching): Meaning of ETag, `304` and Cache policies.
 156: - [English: MDN ETag](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/ETag): The difference between weak and strong Validator and the meaning of display change.
 157: - [English: GitHub REST best practices](https://docs.github.com/en/rest/using-the-rest-api/best-practices-for-using-the-rest-api): Conditional request and specific request selection.
 158: - [English: Microsoft code/infrastructure optimization] (https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure): A framework for reducing resource consumption with measurement.
 159: 
 160: **Navigation:** [API Response Chapter](../README.md) · [Main Index](../../README.md) · [Previous: Pagination](../03-efficient-pagination/README.md)
 161: 
 162: **Related:** [ORM Fetch Patterns](../../04-databases/03-orm-fetch-strategies/README.md) · [DB Column Selection](../../04-databases/05-select-only-needed-columns/README.md) · [Critical Path](../../06-code-optimization/04-critical-paths/README.md) · [Cache Freshness](../../01-caching/04-invalidation-and-freshness/README.md)
 163: 
 164: </div>