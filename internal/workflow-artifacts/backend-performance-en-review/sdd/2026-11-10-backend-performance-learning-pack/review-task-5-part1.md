===== Backend Performance\04-databases\README.md =====
   1: <div dir="ltr" align="left">
   2: 
   3: #Chapter 04 — Database performance
   4: 
   5: Order page slowness may be from waiting for connection, hundreds of ORM round trips, reading too many rows, lock or disk. This chapter will help you isolate these causes and then choose the appropriate change. The goal is to reduce the work required to answer correctly; Increasing the number of connections, indexes or replicas alone is not a measure of success.
   6: 
   7: This chapter covers twelve Databases in [Backend Performance Roadmap](https://roadmap.sh/backend-performance-best-practices). **Checking sources: 2026-11-10**; The link `current` showed the PostgreSQL documentation when checking version 18. For the actual implementation, see the documentation for the installed version. All SQLs and exercise numbers are educational and not implemented in this series.
   8: 
   9: ## prerequisite and diagnostic path
  10: 
  11: Be familiar with SELECT, WHERE, JOIN, primary/foreign key, transaction and percentile delay. PostgreSQL is just an example engine; Concepts are not dependent on the programming language. Do the exercises in a separate test database; Creating an index, maintaining and changing settings require permission and an operating plan.
  12: 
  13: lesson | Subject | Diagnostic question
  14: --- | --- | --- |
  15: 1 [Connection pooling and capacity adjustment] (01-connection-pooling/README.md) | Is the time spent in the connection queue or in the SQL execution? |
  16: 2 | [indexes](02-indexes/README.md) | How much data is read for a multi-row response? |
  17: 3 [Lazy, Eager and Batch in ORM](03-orm-fetch-strategies/README.md) | How much SQL is executed for one query? |
  18: 4 | [Paging in the database] (04-efficient-database-pagination/README.md) | What extra work do deep pages create? |
  19: 5 | [Select the necessary columns] (05-select-only-needed-columns/README.md) | What is the cost of row width and making things? |
  20: 6 | [Denormalization for frequent reading](06-denormalization-for-read-heavy-workloads/README.md) | Is iterative calculation worth maintaining a Read model? |
  21: 7 | [Join Optimization](07-join-optimization/README.md) | Is the estimation of the row and the meaning of the connection correct? |
  22: 8 | [Database maintenance] (08-database-maintenance/README.md) | Statistics and space recycling of old versions are delayed? |
  23: 9 | [Record slow queries] (09-slow-query-logging/README.md) | Which actual performance slowed down and when? |
  24: 10 | [Replication](10-replication/README.md) | Which reading can withstand obsolescence? |
  25: 11 | [Sharding](11-sharding/README.md) | Is the bottleneck really exceeding the capacity of a node? |
  26: 12 | [Database Profiling] (12-database-profiling/README.md) | Which query family has the highest total cost? |
  27: 
  28: To study in order, start from lesson 1; To fix slowness, first read lessons **12 and 9** to record the baseline, then go back to the observed cause. Usual path: Request time → Pool waiting time → Number of SQL → Expensive family → Query plan → Smallest modification → Comparison of result and write cost. Replication and sharding are discussed after examining this path.
  29: 
  30: ## continuous scenario of the season
  31:32: An educational store shows a customer's order list. First, record the Pool time and SQL count of each request. Create a limited pool with connection failback; For customer filter and time order, check the proportional index. Batch the customer name, remove the receipt body column from the list, and measure deep navigation with Keyset. For daily report, define Read model with time of last rebuild. After that, check the stats, VACUUM and locks. Add Replica only if residual read load and obsolescence budget justify; For sharding, first write the tenant access pattern and hot tenant risk.
  33: 
  34: This scenario is hypothetical. [Discord engineering report in 2023] (https://discord.com/blog/how-discord-stores-trillions-of-messages) is a real example of the effect of access pattern and hot partition; As a result, it is not a license to generalize engine selection to every store.
  35: 
  36: ## Connection with other chapters
  37: 
  38: - [Cache] (../01-caching/README.md): Reducing database references should be accompanied by freshness, invalidation and recovery policies.
  39: - [API Paging Agreement](../02-api-response/03-efficient-pagination/README.md): Cursor shape and user experience in API; Seek and index mechanics are in this chapter.
  40: - [Scaling and Load balancing] (../05-load-balancing-and-scaling/README.md): increasing the service instance can exceed the total pool budget.
  41:- [Batching and round-trip](../06-code-optimization/08-batching-and-round-trips/README.md): N+1 is an example of round-trip cost.
  42: - [Monitor](../07-monitoring-and-logging/README.md) and [Performance Test](../09-performance-testing/README.md): Baseline comparisons are performed with the same data, concurrency, and interval.
  43: 
  44: ## Checklist at the end of the season
  45: 
  46: - [ ] I measure connection queue time, SQL execution and end-to-end response separately.
  47: - [ ] Pool capacity I collect all application replicas and operational reservations.
  48: - [ ] I measure the index with Query plan and write cost.
  49:- [ ] I have seen ORM generated SQL, query count and result size.
  50:- [ ] Pagination has definite order and Projection has necessary columns.
  51: - [ ] Read owner model has old budget, replay and reconciliation.
  52: - [ ] Join has correct meaning and cardinality and VACUUM/ANALYZE is monitored.
  53: - [ ] Slow log protects sensitive data; Profiling has a certain interval and reset.
  54: - [ ] Replica is not a backup and Failover, lag and read-after-write are designed.
  55: - [ ] Before Sharding, the cost of routing, hotspot, transaction and migration is clear.
  56: 
  57: [Collection list](../README.md) · [Start of first lesson](01-connection-pooling/README.md)
  58: 
  59: </div>

===== Backend Performance\04-databases\01-connection-pooling\README.md =====
   1: <div dir="ltr" align="left">
   2: 
   3: # Connection Pooling — Connection Pooling
   4: 
   5: **Learning Objective:** Be able to separate connection reuse from data cache, adjust Pool size to database capacity, and identify why connection is waiting. **Checking sources: 2026-11-10**; The examples are educational and not implemented.
   6: 
   7: ## mental model and mechanism
   8:9: Establishing a connection includes networking, authentication, and establishing a session. Pool holds open connections; Borrows a connection request, does its short work, and returns on success or error. The limited pool controls the concurrency of entering the database; SQL execution capacity is not unlimited.
  10: 
  11: stage | Measurable time Possible cause of slowness
  12: --- | --- | --- |
  13: Getting connected acquire wait | Pool saturation, leakage, long transaction |
  14: Execute SQL execution/lock wait | Plan, Lock, I/O or CPU |
  15: Liberation hold duration | Keeping the connection while calling another service
  16: 
  17: Pool in driver and external Pooler are two different layers. In [PgBouncer](https://www.pgbouncer.org/config), the session mode keeps the server connection until the client disconnects, the transaction until the end of the transaction, and the statement until the end of the statement; The latter mode does not accept multi-order transaction. This difference has an effect on the state of the meeting.
  18: 
  19: ## Application and compromise
  20: 
  21: Useful for frequent short requests. Long transaction or session state, such as temp table and persistent SET, requires Pooler compatibility check. prepared statement support depends on the version, driver, protocol and setting; PgBouncer with non-zero `max_prepared_statements` handles some protocol-level named prepared statements, but SQL-level PREPARE does not have the same behavior. Remove the setting number from your copy document.
  22: 
  23: A larger pool temporarily reduces the queue, but can increase CPU, memory, and lock contention. coordinate connection timeout, request deadline and rejection policy; retry continuously creates a new queue.
  24: 
  25: ## Solved example
  26: 
  27: Educational assumption: 4 sample programs, each Pool with a maximum of 20 connections; The total potential is 80 connections. If the agreed budget of this service in the database is 60, the setting is not acceptable; Even if each individual sample looks healthy. Reservation of admin, worker and other services should be calculated separately.
  28: 
  29: <div dir="ltr" align="left">
  30: 
  31:```text
  32: connection = pool.acquire(timeout = remaining_request_budget)
  33: try:
  34:     begin(connection)
  35:     rows = query(connection, parameterized_sql)
  36:     commit(connection)
  37:     return rows
  38: catch error:
  39:     rollback_if_needed(connection)
  40:     raise error
  41: finally:
  42:     pool.release_or_discard_broken(connection)
  43: ```44: 
  45: </div>
  46: 
  47: Make the HTTP call or image processing before taking the connection or after the release, unless there is a specific transactional requirement. A faulty rollback or broken connection should not reach the next consumer without cleanup.
  48: 
  49: ## Small exercise and expected observation
  50: 
  51: In a test environment, run 10 concurrent requests with a two-connection Pool; Deliberately simulate each query for 100 milliseconds and write the acquire wait/hold time separately. Then put a request in the error path and check the release. Waiting: Requests are served in several waves; SQL time stays the same but wait Pool grows. After the error, the capacity should return to two. This test does not prove the actual throughput of the engine.
  52: 
  53: ## Public witness and limit of evidence
  54: 
  55: [PgBouncer ops doc](https://www.pgbouncer.org/config) documents the release cycle and state constraints. It witnesses the behavior of the tool; A generic case study with a generalizable improvement percentage is not provided for this lesson example. Size 20 in the example is not the default company report or recommendation.
  56: 
  57: ## Failures, signals and operational checklist
  58: 
  59: Connection leakage is seen with constant busy and growth of acquire timeout. `idle in transaction` can keep lock/old version. Application scale-out, failover, or concurrent pool reconstruction can also create connection congestion. See the number of waiters next to CPU and active transaction.
  60: 
  61: - [ ] Cumulative ceiling of all Pooler instances, workers and users is known.
  62: - [ ] acquire timeout and global deadline are limited; The queue is not unlimited.
  63: - [ ] finally/cleanup and rollback are in error path.
  64: - [ ] The compatibility of session state and prepared statement has been checked for the real version.
  65: - [ ] acquire wait, hold time, busy/idle, timeouts and DB saturation are registered.
  66: - [ ] The behavior of failover, broken connection and gradual reconnection is specified.
  67: 
  68: ## self-test
  69: 
  70:1. Does the Pool store the result of the SELECT?
  71: 
  72: 2. With three program examples and a ceiling of 30, what is the potential budget of the connection?
  73: 
  74: 3. SQL is fast, but the acquire wait is long; What is the first review?
  75: 
  76: 4. Why HTTP call inside the transaction can reduce the capacity?
  77: 
  78: 5. Is transaction pooling always compatible with session state?
  79: 
  80: ### Answer letter with reason
  81: 
  82:1. No; Reuses the connection. The cache is the result of a separate mechanism with rules of freshness.
  83: 
  84: 2. 90; The ceiling of each process is multiplied by the number of samples and other consumers are added separately.
  85: 
  86: 3. busy/idle, hold time and release path; The slowness of the queue is not necessarily the slowness of the query.
  87: 
  88: 4. The connection and possibly the lock remain busy until the call ends, waiting for other requests.
  89: 
  90:5. No; The server connection changes after the transaction, so the persistent state dependency must be checked explicitly.
  91: 
  92: ## Sources
  93:94: - Farsi: [Managing Connection Pooling and DbContext Pooling] (https://dntips.ir/www.dntips.ir-posts-3725.html); To separate the connection pool from ORM object reuse in .NET, not the configuration version of all drivers.
  95: - English: [PgBouncer configuration](https://www.pgbouncer.org/config); Reference modes, queues and limitations of the installed version.
  96: 
  97: [Chapter List](../README.md) · [Collection List](../../README.md) · [Next Lesson: Index](../02-indexes/README.md) · [Scaling](../../05-load-balancing-and-scaling/README.md)
  98: 
  99: </div>

===== Backend Performance\04-databases\02-indexes\README.md =====
   1: <div dir="ltr" align="left">
   2: 
   3: # index — reduce the search path
   4: 
   5: **Learning objective:** Build a proposed index query from the filter and order, check its actual use and enter the write cost in the decision. **Checking sources: 2026-11-10**; The sample SQL is for PostgreSQL and is not implemented.
   6: 
   7: ## mental model
   8: 
   9: The index is an auxiliary structure for finding rows; Not all queries benefit from it. If most of the table is required or if the table is very small, Sequential scan may be the right choice. In the composite index, the order of the columns depends on the filter, sort, and engine capability; Do not assume the versions and index type to be the same.
  10: 
  11: Access pattern Review option The accompanying fee
  12: --- | --- | --- |
  13: Customer equality and time order Composite B-tree write and more space
  14: Condition on the fixed subset | Partial index in the backup engine predicate must be usable |
  15: Spatial data GiST/PostGIS suitable for operator | Knowledge of type and operator class
  16: Return limited columns Covering index Wider index and maintenance cost
  17: 
  18: First find the actual SQL and delegate parameter; Update statistics; see plan and buffers; make a change; Compare with similar read/write load. [PostgreSQL's Guide to Checking Index Usage] (https://www.postgresql.org/docs/current/indexes-examine.html) emphasizes statistics and representative data.
  19: 
  20: ## application and compromise
  21: 
  22: Index is useful for selective searching or consistent ordering. For a less differentiated column, it may be beneficial in the right combination, but the column name alone does not determine the decision. Each INSERT/UPDATE/DELETE may generate more index and WAL work. The cast function on the column can change the way to use the normal index. Removing the "underutilized" index without seeing the full range of workload and the role of the constraint is dangerous.
  23: 
  24: ## Solved example
  25: 
  26: Consider the hypothetical table `orders(id bigint primary key, customer_id bigint, created_at timestamp, total numeric)`. To list a customer's latest orders:
  27: 
  28: <div dir="ltr" align="left">
  29: 
  30:```sql
  31: CREATE INDEX orders_customer_time_idx
  32:     ON orders(customer_id, created_at DESC, id DESC);
  33: 
  34: EXPLAIN (ANALYZE, BUFFERS)
  35: SELECT id, created_at, total
  36: FROM orders
  37: WHERE customer_id = 42
  38: ORDER BY created_at DESC, id DESC
  39: LIMIT 20;
  40: ```41: 
  42: </div>
  43: 
  44: Parity on the client and matching order is a candidate for the index scan path with an early stop; A definitive plan or specific time is not guaranteed. `id` determines the order of equal times. `EXPLAIN ANALYZE` actually executes the query; In the SELECT test, the load is also created.
  45: 
  46: ## Small exercise and expected observation
  47: 
  48: In the test database for 100 customers, create 100 thousand orders with unbalanced distribution. Before and after index and `ANALYZE orders`, check the above query for small and large customer. Note rows, sort, buffer hit/read and time; Then measure the cost of inserting an identical batch. Expectation: index may reduce read/sort, but write is not free and different clients can have different plans. Do not take capacity with 10 rows of meaningful results.
  49: 
  50: ## Public witness and evidence limit
  51: 
  52: [Official PostgreSQL Documentation](https://www.postgresql.org/docs/current/indexes-examine.html) explains why small data and non-realistic distributions skew test results; The main witness of this lesson is operational. [Persian article by Arta Sanghnegar about PostGIS] (https://asnegar.ir/blog/postgis-optimization/) also reports a general example of spatial plan change; Its numbers are not independently reproduced and GiST behavior should not be generalized to B-tree. Don't read the "lock-free" claim for concurrent construction as absolute; Check its limitations and steps from the engine documentation.
  53: 
  54: ## Failures, signals and checklist
  55: 
  56: See write latency, WAL and index size next to read latency. The estimated/actual rows difference can be from statistics or data distribution. Inappropriate index may not improve any important query and still make writing expensive.
  57: 
  58: - [ ] filter, sort, selectivity and representative parameters are specified.
  59: - [ ] New statistics and pre/post query plan have been maintained.
  60: - [ ] The order of the columns is measured by the access path.
  61: - [ ] cost of write, space, WAL and build time are measured.
  62: - [ ] Considers creation and deletion, constraint and migration locks.
  63: - [ ] index usage is checked in full working interval.
  64: 
  65: ## self-test
  66: 
  67: 1. Is Seq Scan always a sign of trouble?
  68: 
  69: 2. Why was `id` added to the time sequence?
  70: 
  71:3. How much does an index on all columns cost?
  72: 
  73: 4. What do you check if the estimated rows differ greatly from the actual?
  74: 
  75:5. Is SELECT speedup enough to verify index?
  76: 
  77: ### Answer letter with reason
  78: 
  79: 1. No; For a small table or a large share of rows it can be the cheapest route.
  80: 
  81:2. To break a timestamp tie and make a definitive order; Pagination requires this feature.
  82: 
  83:3. space, memory, WAL and index change in write; Adding aimlessly has a permanent cost.
  84: 
  85: 4. Newness of statistics, correlation of columns, skew and true parameter; Wrong estimation affects the choice of plan.
  86: 
  87:5. No; Write latency, throughput, space consumption and manufacturing lock are also among the results.
  88:89: ## Sources
  90: 
  91: - Farsi: [Database Indexing] (https://pro-nee.net/terms/indexing/); Familiarity with concepts and costs. Read the clustered/non-clustered explanation depending on the engine.
  92: - Additional Farsi: [Example of PostGIS and EXPLAIN] (https://asnegar.ir/blog/postgis-optimization/); To see the spatial example, with the limits of evidence above.
  93: - English: [Examining index usage] (https://www.postgresql.org/docs/current/indexes-examine.html); Test reference with real data and statistics.
  94: 
  95: [Chapter List](../README.md) · [Collection List](../../README.md) · [Prev: Pooling](../01-connection-pooling/README.md) · [Next: ORM](../03-orm-fetch-strategies/README.md) · [Profiling](../12-database-profiling/README.md)
  96: 
  97: </div>

===== Backend Performance\04-databases\03-orm-fetch-strategies\README.md =====
   1: <div dir="ltr" align="left">
   2: 
   3: # Receive strategy in ORM — Lazy, Eager and Batch
   4: 
   5: **Learning objective:** Identify N+1 from SQL, choose between join and batch and measure the number of queries along with the data size. **Checking sources: 2026-11-10**; The example is ORM independent and unimplemented.
   6: 
   7: ## mental model
   8: 
   9: Lazy loading reads the relation when accessed. Eager loading gets it in advance; It may be separate with join or query. Batch/select-in aggregates identifiers and reads multiple relations at once. The term Eager does not necessarily mean "exactly an SQL".
  10: 
  11: Strategy Form of work danger |
  12: --- | --- | --- |
  13: Lazy basic query and then get a case N+1 and hidden I/O in serializer |
  14: Joined eager | A join with duplicate parent data | A sharp increase in rows in several collections
  15: Batch/select-in | parents, then children with set ID | parameter limit, memory and multiple snapshots
  16: 
  17: If 20 orders and customer queries are executed for each, we have a 1+20 pattern; The identity map or cache of some ORMs may reduce the count, so count the actual SQL. [SQLAlchemy 2.0 document] (https://docs.sqlalchemy.org/en/20/orm/queryguide/relationships.html) describes the difference between lazy, joined and select-in and how to avoid unwanted lazy; Check each ORM's API separately.
  18: 
  19: ## Application and compromise
  20: 
  21: For a small single-valued relation, join can be suitable. Two collections with 10 and 5 children may make 50 combined rows for a parent; batch sometimes takes less bytes and memory, although it has more round-trips. Lazy can be acceptable for relationships that are not used often. Don't be eager for an unlimited list. Reading two queries in normal isolation may see the change at the same time; If persistent snapshot is required, design appropriate transaction/isolation.
  22: 
  23: ## Solved example
  24: 
  25: Hypothetical design: `orders(id, customer_id)` and `customers(id, name)`. The list only asks for the order ID and customer name. Receive 20 parents and names of unique customers in a batch:
  26: 
  27: <div dir="ltr" align="left">
  28: 
  29:```sql
  30: SELECT id, customer_id FROM orders ORDER BY id DESC LIMIT 20;
  31: -- Application collects DISTINCT customer_id values, e.g. 7, 9, 12.
  32: SELECT id, name FROM customers WHERE id IN (7, 9, 12);
  33: -- Map customer_id -> name, then build response.
  34: ```35: 
  36: </div>
  37: 
  38: In execution, bind the values; Do not create index by concatenating SQL text. The number of queries is usually two, but if the parameter limit is forced to chunk, it will be more. For the above requirement, a join is also a comparison candidate; "Two" is not a general purpose.
  39: 
  40: ## Practice and expected observation
  41: 
  42: Make 20 orders with mutual customers. Compare lazy, join and batch versions on the same output: query count, rows returned, bytes and time. Then add two collections to each order and measure again. Expectation: Lazy can show round-trip linear growth; join multiple collections can create duplicate rows; batch reduces the product growth of collections. The numbers depend on the ORM and the data.
  43: 
  44: ## Public witness and evidence limit
  45: 
  46: [SQLAlchemy Official Guide](https://docs.sqlalchemy.org/en/20/orm/queryguide/relationships.html) is a technical witness of loading methods; This lesson does not have a company's production result or documented improvement percentage. An example is a hypothetical store. The selection must be based on the generated SQL and the size of the response, not the strategy name.
  47: 
  48: ## Failures, signals and checklist
  49: 
  50: serializer, template and logging can open lazy relationship unintentionally. join on sets will change the parent pagination, unless the ORM does the correct rewrite. Closing the session before lazy also gives an error. Increasing the query count proportionally to the parent number is the N+1 signal.
  51: 
  52: - [ ] Number of SQLs and generated SQLs for a representative request are logged.
  53: - [ ] Collections are limited and the volume of the result is measured.
  54: - [ ] join, batch and lazy are compared with the same output and semantics.
  55: - [ ] IN limit, chunk and parameter binding are observed.
  56: - [ ] Snapshot contract and session closing behavior is on.
  57: - [ ] Unwanted access to the relationship in the serializer is visible or denied.
  58: 
  59: ## self-test
  60: 
  61:1. Is Eager loading always a SQL?
  62: 
  63: 2. For 30 parents, what pattern does the query make separately on each child?
  64: 
  65:3. Why two collections in a join may be worse?
  66: 
  67: 4. Why batch may have more than two queries?
  68: 
  69:5. If the number of SQL decreases but the latency increases, what do you measure?
  70: 
  71: ### Answer letter with reason
  72: 
  73: 1. No; Prefetching can be done with join or separate queries.
  74: 
  75:2. usually 1+30; We check the behavior of cache/identity map with SQL registration.
  76: 
  77:3. The product of the number of children, the iteration of the parent, and the cost of transferring/creating the object.
  78: 
  79: 4. due to chunk, parameter limit or multiple relations; There is no fixed and universal ceiling.
  80: 
  81:5. rows, bytes, memory, plan and sort; Eliminating the round-trip is only one of the factors.
  82: 
  83: ## Sources
  84: 
  85: - English: [SQLAlchemy Relationship Loading](https://docs.sqlalchemy.org/en/20/orm/queryguide/relationships.html); Methods reference in branch 2.0.86: - Farsi: [Optimizing Django ORM and preventing N+1](https://mixins.ir/article/django-orm-query-optimization-performance/); As a result of the public search, the subject connection of `select_related` and `prefetch_related` was confirmed; Opening the full text in this review timed out. Therefore, it is not the basis of the technical claim of this lesson.
  87: 
  88: [Chapter List](../README.md) · [Series List](../../README.md) · [Prev: Index](../02-indexes/README.md) · [Next: Pagination](../04-efficient-database-pagination/README.md) · [Join](../07-join-optimization/README.md)
  89: 
  90: </div>