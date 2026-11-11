# Task 3 omitted snapshot

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