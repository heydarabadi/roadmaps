===== Backend Performance\04-databases\04-efficient-database-pagination\README.md =====
   1: <div dir="ltr" align="left">
   2: 
   3: # Efficient pagination in the database
   4: 
   5: **Learning Objective:** Separate OFFSET cost from page size, write Keyset with deterministic order, and analyze simultaneous change of data. **Checking sources: 2026-11-10**; The PostgreSQL example is educational and not implemented.
   6: 
   7: ## mental model
   8: 
   9: OFFSET tells how many rows of the result to set aside; The engine still has to travel the path to reach that point. LIMIT only limits the output size. Keyset starts from the last sorting key of the previous page; With a consistent index, the work of traversing discarded rows becomes less. The order must be definite; Timestamp alone is not enough in case of a tie. [PostgreSQL's LIMIT/OFFSET document](https://www.postgresql.org/docs/current/queries-limit.html) explains the cost of large offsets and the necessity of predictable ordering.
  10: 
  11: Method Advantage | Limitations
  12: --- | --- | --- |
  13: OFFSET | Jump directly to the page number Work more in depth, move with insert/delete |
  14: Keyset Continue scrolling from the | key Hard arbitrary jump, dependency on sort |
  15: Fixed Snapshot Report with fixed set Snapshot/copy maintenance and operational cost
  16: 
  17: Keyset does not guarantee snapshot: changing the sort value may cause duplication or sticking. For accurate export, define a snapshot or high-water mark contract according to your needs.
  18: 
  19: ## Application and compromise
  20: 
  21: Suitable for feed and large sequential scrolling. Small, shallow screens with the need to jump to a specific number may justify the OFFSET. Price the exact COUNT separately; Counting all rows can be more expensive than fetching the page. NULL, mixed ascending/descending sort, and multiple tenants complicate the seek condition; The example below has NOT NULL columns and the same direction.
  22: 
  23: ## Solved example
  24: 
  25: Hypothetical plan: `orders(id bigint primary key, customer_id bigint not null, created_at timestamp not null)`. The first page is the query without the cursor condition; The next page uses the latest `(created_at,id)`.
  26: 
  27: <div dir="ltr" align="left">
  28: 
  29:```sql
  30: CREATE INDEX orders_page_idx
  31: ON orders(customer_id, created_at DESC, id DESC);
  32: 
  33: SELECT id, created_at
  34: FROM orders
  35: WHERE customer_id = 42
  36:   AND (created_at, id) < (TIMESTAMP '2026-10-01 12:00:00', 9001)
  37: ORDER BY created_at DESC, id DESC
  38: LIMIT 21;
  39: ```40: 
  41: </div>
  42: 
  43: The display size is 20; Row 21 is only used for continuation detection. The next cursor is created from the 20th row, not the 22nd. The client filter is repeated on every page and we don't rely on Cursor for authorization. Real values ​​are bound. Here the mechanics of SQL are reviewed; Cursor shape, input error and API convention are in [API Paging Tutorial](../../02-api-response/03-efficient-pagination/README.md).
  44: 
  45: ## Practice and expected observation
  46: 
  47: Create 100 thousand rows with equal timestamps in the test table. Compare `LIMIT 20 OFFSET 80000` and the corresponding seek with `EXPLAIN (ANALYZE, BUFFERS)`. Then insert a new line between the two pages before the border. expect: OFFSET can re-display the bottom row of the previous page; Keyset continues with fixed keys from the boundary, but does not continue the new record before the boundary. Compare buffers and plan rows; Do not expect constant numerical acceleration.
  48: 
  49: ## public witness
  50: 
  51: [GitLab development documentation for Keyset pagination](https://docs.gitlab.com/development/database/keyset_pagination/) documents the use of Order, Distinct Key, and Cursor in a real product. This engineering guide is a reference to the application, not a stand-alone benchmark for our example; The limit of sort and index should be measured in your workload.
  52: 
  53: ## Failures, signals and checklist
  54: 
  55: Ascending latency with page number, rows scanned are much more than rows returned and sort on the disk are checkable signs. Removing the tie-breaker, incorrect direction of the comparator, changing the filter between pages and the cursor based on the mutable field are common errors.
  56: 
  57: - [ ] definitive sort, comparator direction and NULL behavior are known.
  58: - [ ] index checked with tenant/filter and compatible order.
  59:- [ ] has a ceiling screen size and COUNT has an independent cost.
  60: - [ ] Insertion, deletion and change of sort between pages have been analyzed.
  61:- [ ] Cursor is bound to the filter and permission is rechecked for each request.
  62:- [ ] The deep plate, the tie boundary and the end of the set are checked.
  63: 
  64: ## self-test
  65: 
  66: 1. Why does a small LIMIT not necessarily make a large OFFSET cheap?
  67: 
  68: 2. In the descending order example, is the next page condition `<` or `>`?
  69: 
  70:3. What if several rows have the same timestamp?
  71: 
  72: 4. Does Keyset see all data in a snapshot?
  73: 
  74:5. Why is Cursor created from the 20th row?
  75: 
  76: ### Answer letter with reason
  77: 
  78: 1. The engine must calculate/pass the rows before the offset; Small output is not equal to small work.
  79: 
  80:2. `<`; The next in descending order has a smaller key, assuming the same direction for both columns.
  81: 
  82:3. supplementary unique key such as id; Otherwise, the border of the page will be blurred.
  83: 
  84: 4. No; Snapshot and changing the sorting column are separate issues.
  85: 
  86:5. That row is the last row delivered; Using an extra row will make it fit.
  87: 
  88: ## Sources
  89: 
  90: - English: [PostgreSQL LIMIT/OFFSET](https://www.postgresql.org/docs/current/queries-limit.html); Basis of cost and arrangement.91: - English: [GitLab Keyset pagination](https://docs.gitlab.com/development/database/keyset_pagination/); Implementation and application limitations.
  92: - Farsi: [Oracle Paging; continue key and still image](https://www.brserp.com/knowledge/erp-oracle-pagination-offset-seek-stable-order-snapshot-guide); To understand the unique order and Keyset limitation in variable data. The indexed text was checked in public search; Direct opening in the research instrument was limited. Don't assume Oracle's syntax and behavior are the same as PostgreSQL.
  93: 
  94: [Chapter List](../README.md) · [Collection List](../../README.md) · [Prev: ORM](../03-orm-fetch-strategies/README.md) · [Next: Projection](../05-select-only-needed-columns/README.md) · [Index](../02-indexes/README.md)
  95: 
  96: </div>

===== Backend Performance\04-databases\05-select-only-needed-columns\README.md =====
   1: <div dir="ltr" align="left">
   2: 
   3: # Select only necessary columns — Projection
   4: 
   5: **Learning objective:** Separate the cost of row width from the number of rows, write a query according to the output and know the conditions of Index-only scan. **Checking sources: 2026-11-10**; SQLs for PostgreSQL are not implemented.
   6: 
   7: ## mental model
   8: 
   9: WHERE limits the number of rows and SELECT lists the output columns. `SELECT *` may take large text, JSON, or binary that the consumer does not need. Even if the disk page read path is the same, the transfer from DB to program, decoding, object creation and serialization can be reduced. Shrinking the output does not necessarily reduce the number of heap pages read.
  10: 
  11: layer The potential effect of Projection Viewing method
  12: --- | --- | --- |
  13: Engine The middle row is narrower, the possibility of covering index | width, plan, buffers |
  14: Network DB→App | Byte less | bytes received in driver/network
  15: Program | less allocation and mapping Memory, CPU and time mapping
  16: Contract ستون حساس/جدید ناخواسته وارد نمی‌شود | Check the response schema
  17: 
  18: In PostgreSQL, Covering index is not the only condition of Index-only scan; The visibility map determines whether a heap reference is required for visibility. [Index-only scans document](https://www.postgresql.org/docs/current/indexes-index-only-scans.html) describes this limitation.
  19: 
  20: ## application and compromise
  21: 
  22: Suitable for lists and read DTOs. In the editing path, do not delete the necessary columns for concurrency such as version or mapping keys. Deferred column later called lazy can make N+1. index with INCLUDE has space and write costs for all fields; Do not insert the large column into the index just to cover the query.
  23: 
  24: ## Solved example
  25: 
  26: The default layout is `documents(id bigint primary key, tenant_id bigint, title text, body text, version bigint)`. The index page does not require the body of the document:
  27: 
  28: <div dir="ltr" align="left">
  29: 
  30:```sql
  31: -- List endpoint:
  32: SELECT id, title, version
  33: FROM documents
  34: WHERE tenant_id = 7
  35: ORDER BY id DESC
  36: LIMIT 20;
  37: 
  38: -- Detail endpoint, after authorization:
  39: SELECT id, title, body, version
  40: FROM documents
  41: WHERE tenant_id = 7 AND id = 81;
  42: ```43: 
  44: </div>
  45: 
  46: Separation of list/detail makes body only received when needed. `tenant_id` remains in both conditions. version is required for possible editing in the response. An example is a copy of the design; Do not assume that access is granted only if the query condition is complete.
  47: 
  48: ## Practice and expected observation
  49: 
  50: Create 20 test documents with a large body. Run `SELECT *` once and the above list query once with the same output; Measure received bytes and allocation. Then after Projection, give access to the body in the loop and record the query count. Expect: projection to transfer fewer bytes; Subsequent lazy access may negate the advantage with additional queries. The plan or buffers may remain the same.
  51: 
  52: ## Public witness and evidence limit
  53: 
  54: [Official PostgreSQL documentation on Covering index] (https://www.postgresql.org/docs/current/indexes-index-only-scans.html) shows selected column correlation, visibility, and heap fetch in action. The report of an independent company that only measured column removal with all controlled factors is not provided in the resources of this lesson; The body number and the document example are hypothetical.
  55: 
  56: ## Failures, signals and checklist
  57: 
  58: Fast SQL but high CPU mapping or network bytes can be a sign of additional downloads. Deleting keys breaks relationships; Removing a version breaks optimistic concurrency protection. Index-only scan with high heap fetch is not necessarily a projection issue and is also related to maintenance.
  59: 
  60:- [ ] List of columns extracted from consumer requirement.
  61: - [ ] Keys, tenant and version needed for mapping/editing are preserved.
  62: - [ ] bytes, allocation and query count are measured along with DB time.
  63: - [ ] Subsequent access to deferred column does not hide SQL.
  64: - [ ] Covering index is evaluated with space, write and visibility map.
  65: - [ ] Adding a new column to a table does not change the public response unintentionally.
  66: 
  67: ## self-test
  68: 
  69: 1. What is the difference between row reduction and column reduction?
  70: 
  71:2. Does removing body always reduce disk I/O proportionally?
  72: 
  73:3. Why might version be required in list response?
  74: 
  75:4. Index-only scan condition is only the presence of all columns in the index?
  76: 
  77:5. When does deleting a column with ORM make N+1?
  78: 
  79: ### Answer letter with reason
  80: 
  81:1. WHERE limits the rows and SELECT the columns/width of the result; The two axes are independent.
  82: 
  83: 2. No; The engine may read the same pages, but the rendering and rendering of the object will still be less.
  84: 
  85:3. For editing contract with optimistic concurrency; Removing it can change the meaning of the operation.
  86: 
  87: 4. No; In PostgreSQL, row visibility and map visibility have an effect on referring to the heap.
  88: 
  89:5. When the code later reads each deferred column separately; Query count should be measured after serialization.
  90: 
  91: ## Sources
  92:93: - English: [Index-only scans and covering indexes] (https://www.postgresql.org/docs/current/indexes-index-only-scans.html); Technical conditions and cost of INCLUDE columns.
  94: - Farsi: [Database security and optimization, basic principles of query optimization] (https://shahin.page/persian/article-fa/database-security-and-optimization-access-control-and-indexing-fa); Introduction to selecting required columns instead of SELECT *. Read the details of the visibility map from the official English reference.
  95: 
  96: [Chapter List](../README.md) · [Collection List](../../README.md) · [Prev: Pagination](../04-efficient-database-pagination/README.md) · [Next: Denormalization](../06-denormalization-for-read-heavy-workloads/README.md) · [Maintenance](../08-database-maintenance/README.md)
  97: 
  98: </div>

===== Backend Performance\04-databases\06-denormalization-for-read-heavy-workloads\README.md =====
   1: <div dir="ltr" align="left">
   2: 
   3: # Denormalization for high read load
   4: 
   5: **Learning Objective:** Design a derived Read model, write the obsolescence budget, and compare the cost of maintaining consistency with the cost of computing each read. **Checking sources: 2026-11-10**; The PostgreSQL example is educational and not implemented.
   6: 
   7: ## mental model
   8: 
   9: Normalization reduces data duplication and centralizes update rules. Denormalization stores part of the join/aggregate result or duplicate data to make reading less efficient. Derived data must have a source of truth, an update owner, and a rebuild path. Summary table, counter and materialized view are different forms of this decision; cache may also have a similar role, but the contract of durability and ownership should be written separately.
  10: 
  11: Maintenance method Newness cost |
  12: --- | --- | --- |
  13: Update in transaction write | Sync with local commit write and more competition
  14: Event/CDC and projector with a delay | replay, order and idempotency |
  15: periodic refresh Obsolete until the next turn Batch calculation and refresh time
  16: 
  17: It is not enough to have a high read/write ratio; The frequent query should be really cost effective and the result maintainable. For final price or final inventory, the old summary alone is not a license to operate.
  18: 
  19: ## Application and compromise
  20: 
  21: Suitable for frequent dashboards, lists and reports with a specific freshness budget. For large writes, continuously changing models, or transactions that require real-time accuracy, the complexity may eat away at the benefit. More space, write amplification and inconsistent data modification are part of the cost. First, measure query, index and projection.
  22: 
  23: ## Solved example
  24: 
  25: Assumption: `orders(id, customer_id, total, status)` is the source of truth. The dashboard only asks for the sum of paid orders for each customer and accepts a delay of a few minutes.
  26: 
  27: <div dir="ltr" align="left">
  28: 
  29:```sql
  30: CREATE MATERIALIZED VIEW customer_sales AS
  31: SELECT customer_id, COUNT(*) AS order_count, SUM(total) AS amount
  32: FROM orders
  33: WHERE status = 'paid'
  34: GROUP BY customer_id;
  35: 
  36: SELECT order_count, amount FROM customer_sales WHERE customer_id = 42;
  37: -- Scheduled in the lab, outside a request:
  38: REFRESH MATERIALIZED VIEW customer_sales;
  39: ```40: 
  41: </div>
  42: 
  43: In PostgreSQL, the result is cached and not automatically refreshed with each write. Record the successful time of the last refresh next to the dashboard. Regular REFRESH can keep readers waiting; The CONCURRENTLY mode has prerequisites such as a suitable unique index and a filled view, and it still has a calculation cost. [Document Materialized views] (https://www.postgresql.org/docs/current/rules-materializedviews.html) read for model and report example; Check the exact conditions of the command in your version.
  44: 
  45: ## Practice and expected observation
  46: 
  47: add a paid order; Compare direct query on orders and view before refresh. Then refresh and read again. Expectation: the view is old until refresh and after success converges with the read collection during refresh. Design an event projector scenario on paper with a repeat event and a move event: What error does keeping `event_id` and version get?
  48: 
  49: ## Public witness and evidence limit
  50: 
  51: [Official PostgreSQL Documentation](https://www.postgresql.org/docs/current/rules-materializedviews.html) Sample cached sales report showing freshness/velocity difference. This example is an educational reference, not a company production report; In this lesson, we do not have a direct case study with independent measurement for the above Read model.
  52: 
  53: ## Failures, signals and checklist
  54: 
  55: Repeated event resuming, refund/delete matching, incomplete update between two systems and unwarning failed refresh are common errors. record data age, projector lag, reconciliation difference and refresh cost; Read latency alone does not indicate accuracy.
  56: 
  57: - [ ] The source of truth and owner of Read model is known.
  58: - [ ] The freshness budget, timestamp/version and data behavior are defined too old.
  59: - [ ] update, delete and refund are covered in the derived model.
  60:- [ ] replay and deduplication are designed for the event path.
  61: - [ ] There is rebuild and reconciliation with the source of truth.
  62: - [ ] cost of write, space, lock and refresh is measured next to read latency.
  63: 
  64: ## self-test
  65: 
  66: 1. What does denormalization move from reading to another time?
  67: 
  68: 2. Does Materialized view auto refresh with every INSERT?
  69: 
  70:3. Why repeated event is dangerous for counter?
  71: 
  72: 4. Is the displayed inventory from the Read model of the sales authorization definitive?
  73: 
  74:5. What index is necessary next to reading speed?
  75: 
  76: ### Answer letter with reason
  77: 
  78: 1. join/aggregate or construction passes the output view to write, projector or refresh; The cost is not removed.
  79: 
  80:2. In the example of PostgreSQL, no; Explicit refresh is required.
  81: 
  82:3. Addition again destroys the figure; idempotency/deduplication or versioned computation is required.
  83: 
  84: 4. No; Operations must be validated against resource and budget transaction rules.
  85: 
  86:5. Data age and differences with the source; The old quick answer may be invalid for the contract.
  87: 
  88: ## Sources
  89:90: - English: [PostgreSQL Materialized views](https://www.postgresql.org/docs/current/rules-materializedviews.html); Result storage model and report example.
  91: - Additional English: [REFRESH MATERIALIZED VIEW](https://www.postgresql.org/docs/current/sql-refreshmaterializedview.html); Prerequisite unique index, filled view and locking difference in CONCURRENTLY.
  92: - Farsi: [Normalization and normal forms, theory and efficiency balance section] (https://pro-nee.net/collections/normalization-and-normal-forms/); Introduction to conscious redundancy and anomalies. A specialized Persian source for replay/reconciliation of this model was not found in this review; The exercise on this page clears up that gap.
  93: 
  94: [Chapter List](../README.md) · [Set List](../../README.md) · [Prev: Projection](../05-select-only-needed-columns/README.md) · [Next: Join](../07-join-optimization/README.md) · [Background Tasks](../../03-asynchronism/01-background-jobs/README.md)
  95: 
  96: </div>