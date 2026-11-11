===== Backend Performance\04-databases\07-join-optimization\README.md =====
   1: <div dir="ltr" align="left">
   2: 
   3: # Optimizing Join by preserving meaning
   4: 
   5: **Learning Objective:** Predict output cardinality, separate Join cost from written form and pay attention to estimation, loops and spill in Query plan. **Checking sources: 2026-11-10**; SQL for PostgreSQL is not implemented.
   6: 
   7: ## mental model
   8: 
   9: Join is the combination of rows based on the condition. First clarify the meaning of the relationship: one-to-one, one-to-many or many-to-many? Then estimate the volume of input and output. Nested loop, Hash join and Merge join are implementation choices; The name of the algorithm alone is not good or bad. A small input with a lookup index can make a proper nested loop; Large input with misestimation may create costly loops.
  10: 
  11: View the plan The next question
  12: --- | --- |
  13: actual rows are much more than estimate How are the statistics, skew and dependence of the columns? |
  14: Too many loops in lookup Is the exterior entrance larger than expected? |
  15: temp read/write or many hash batches Memory or input volume caused spill? |
  16: output multiple times parent number | Do we have multiple or incomplete conditions? |
  17: 
  18: Planner rearranges many inner joins; Changing the order of the SQL text does not guarantee a change of execution order. outer join has a semantic limit. [PostgreSQL documentation on explicit joins] (https://www.postgresql.org/docs/current/explicit-joins.html) explains the difference between allowed ordering and planner control; A global setting is not the first step to force an algorithm.
  19: 
  20: ## application and compromise
  21: 
  22: Join is suitable for combining data close to the source and can eliminate multiple round-trips. For very large output or multi-collection relationships, batch may be smaller. index on the join key is a useful candidate, but when reading large portions of the table, hash/seq scan can be correct. The memory increase of each query is multiplied by the time; Don't assume a large `work_mem` number is a generic spill treatment.
  23: 
  24: ## Solved example
  25: 
  26: The default layout is `customers(id, name)` and `orders(id, customer_id, total, status)`. All customers, even without paid orders, should be displayed:
  27: 
  28: <div dir="ltr" align="left">
  29: 
  30:```sql
  31: SELECT c.id, c.name, COALESCE(p.amount, 0) AS paid_amount
  32: FROM customers AS c
  33: LEFT JOIN (
  34:     SELECT customer_id, SUM(total) AS amount
  35:     FROM orders
  36:     WHERE status = 'paid'
  37:     GROUP BY customer_id
  38: ) AS p ON p.customer_id = c.id;
  39: ```40: 
  41: </div>
  42: 
  43: Pre-aggregation turns orders into one row per customer and prevents the aggregate from being multiplied by the next join. This rewrite is for the specific requirement above; Aggregation of all orders may be more expensive if only a few customers are requested. The predicate on the right side of the LEFT JOIN in WHERE can remove the NULL row and change the meaning of the result.
  44: 
  45: ## Practice and expected observation
  46: 
  47: Create two clients; One has two paid orders and three related payments, the other has no orders. Compare raw query with join both collection and SUM with preaggregation of each relation. Expectation: A raw join can inflate the sum due to duplicate rows; Precompiling with the correct level will fix this error. Then take EXPLAIN and compare the rows/loops with the prediction on paper; More speed is not accepted without equal results.
  48: 
  49: ## Public witness and evidence limit
  50: 
  51: [PostgreSQL Operational Document on Join Order Control] (https://www.postgresql.org/docs/current/explicit-joins.html) shows that the number of relations and semantic constraints affect the search space of the planner. This is the official witness; The customer/payment example is hypothetical and the production report is not considered a company.
  52: 
  53: ## Failures, signals and checklist
  54: 
  55: An incomplete condition or tenant deletion can break cardinality and even data isolation. DISTINCT on the large result may indicate incorrect join hiding. Check for inconsistent casts, stale statistics, sort/spill, and incorrect estimates; Dropping a join without proving equality is not an optimization answer.
  56: 
  57: - [ ] The cardinality and aggregate level of each relationship is specified.
  58: - [ ] inner/outer and predicate location preserve the desired result.
  59: - [ ] estimated/actual rows, loops, buffers and temp I/O have been checked.
  60: - [ ] index and data type of join keys are compatible.
  61: - [ ] The tenant constraint and the full key of the relationship are present in the condition.
  62: - [ ] The result of pre/post and memory consumption is compared at the same time.
  63: 
  64: ## self-test
  65: 
  66: 1. Is nested loop always bad?
  67: 
  68: 2. Why join two collections can break SUM?
  69: 
  70:3. What is the risk of predicate on the right side of LEFT JOIN in WHERE?
  71: 
  72: 4. Why changing the inner join text order does not guarantee the new plan?
  73: 
  74:5. What do you measure before increasing the query memory?
  75: 
  76: ### Answer letter with reason
  77: 
  78: 1. No; Small input and effective lookup can make it cheap.
  79: 
  80:2. Rows are repeated in a multi-to-many combination, and aggregate aggregates the same repetition.
  81: 
  82:3. Removes rows without matching NULL and can change the meaning of outer join.
  83: 
  84: 4. Planner is allowed to reorder equivalent joins; Text is not a definite physical order.
  85: 
  86:5. real volume, skew, statistics, spill and number of simultaneous queries; Memory per operator/session can be aggregated.
  87: 
  88: ## Sources
  89:90: - English: [PostgreSQL explicit JOIN clauses](https://www.postgresql.org/docs/current/explicit-joins.html); The order and difference control limits of outer join.
  91: - Additional English: [Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html); Reading plan tree and loops.
  92: - Farsi: [Breaking the Myth "FILTER EARLIER, JOIN LATER" — PDF Version](https://www.dntips.ir/exports/news/www.dntips.ir-news-20517.pdf); To separate the query writing order from the optimizer's decision. The indexed text was checked in public search; It was not possible to open the PDF directly in the research tool. The basis for PostgreSQL's behavior in this tutorial is the official documentation, not the paper's benchmark numbers.
  93: 
  94: [Chapter List](../README.md) · [Collection List](../../README.md) · [Prev: Denormalization](../06-denormalization-for-read-heavy-workloads/README.md) · [Next: Maintenance](../08-database-maintenance/README.md) · [ORM](../03-orm-fetch-strategies/README.md)
  95: 
  96: </div>

===== Backend Performance\04-databases\08-database-maintenance\README.md =====
   1: <div dir="ltr" align="left">
   2: 
   3: # Database maintenance — statistics, vacuum and capacity
   4: 
   5: **LEARNING OBJECTIVE:** Separate ANALYZE and VACUUM job, see maintenance lag from signals and evaluate lock/space before heavy operation. **Checking sources: 2026-11-10**; The example is obviously PostgreSQL and not implemented. Other engines have different recycling and maintenance cycles.
   6: 
   7: ## mental model
   8: 
   9: In MVCC, UPDATE/DELETE can leave the old version of the row. VACUUM prepares the space of erasable copies for reuse; ANALYZE Gets data distribution statistics for the planner. Autovacuum does most of this automatically, but the rate of change and table size may require some adjustment. A long transaction can delay the cleanup of some older versions.
  10: 
  11: PostgreSQL operations The goal Operational point
  12: --- | --- | --- |
  13: ANALYZE | planner statistics Statistics are estimates, not exact counts of total |
  14: Normal VACUUM | Recycle dead copies, visibility | It usually makes the interior space reusable
  15: VACUUM FULL | Rewriting and compressing the table Heavy lock and extra temporary space
  16: Backup/restore drill The possibility of recovery It is not a substitute for VACUUM
  17: 
  18: [Routine vacuuming guide] (https://www.postgresql.org/docs/current/routine-vacuuming.html) in addition to space, also mentions visibility map and preventing transaction ID wraparound. Turning off maintenance to silence the chart creates an operational liability.
  19: 
  20: ## application and compromise
  21: 
  22: Maintenance is a permanent program. Variable workload requires table-oriented monitoring; The same calendar is not enough for all tables. VACUUM/ANALYZE has both I/O and CPU; Their budget should be compatible with the production load. VACUUM FULL is not a daily latency reduction program and is not the same as normal VACUUM. Reindex, rewrite and delete index must have clear cause, lock, space and return path.
  23: 
  24: ## Solved example
  25: 
  26: For the existing test table `orders`, first read the estimate and hold time:
  27: 
  28: <div dir="ltr" align="left">
  29: 
  30:```sql
  31: SELECT relname, n_live_tup, n_dead_tup,
  32:        last_autovacuum, last_autoanalyze
  33: FROM pg_stat_user_tables
  34: WHERE relname = 'orders';
  35: 
  36: ANALYZE orders;
  37: -- Standalone command, not inside BEGIN/COMMIT:
  38: VACUUM (ANALYZE) orders;
  39: ```40: 
  41: </div>
  42: 
  43: `n_dead_tup` is an estimate and not just bloat proof. The last time does not fully show the duration and amount of work. In production, check the absence of new timestamps with change rate, workers, progress and long transactions; A query alone is not a VACUUM FULL command. [VACUUM REFERENCE](https://www.postgresql.org/docs/current/sql-vacuum.html) describes transaction limits and locks.
  44: 
  45: ## Practice and expected observation
  46: 
  47: In the temporary database, create a table with 10,000 rows, UPDATE/DELETE a section, then run the normal ANALYZE and VACUUM. Note the statistics, plan and file size. Waiting: the space of dead versions is prepared for reuse; The file does not necessarily shrink in the same proportion. Statistics are updated at intervals and sampling may vary. Analyze the second test with a long REPEATABLE READ transaction that performed the initial SELECT and is still open; Why are some versions still needed? Do not practice these commands on real data.
  48: 
  49: ## Public witness and evidence limit
  50: 
  51: [Official PostgreSQL Maintenance Document](https://www.postgresql.org/docs/current/routine-vacuuming.html) is the operational witness of this lesson. A report of a company with a direct numerical result not provided; The scenario of the orders table is educational. Do not extend the behavior of compaction in LSM engines or rebuild in SQL Server to VACUUM.
  52: 
  53: ## Failures, signals and checklist
  54: 
  55: Check disk/WAL growth, stale statistics, high dead tuple, old transaction and worker backlog in addition to latency. Replication slot lagging can also hold WAL; Removing it without the knowledge of the consumer is dangerous. Simultaneous rebuild of several tables can exhaust the disk capacity.
  56: 
  57: - [ ] The health of autovacuum, worker and table change rate is monitored.
  58: - [ ] Old transactions and idle in transaction can be seen.
  59: - [ ] planner statistics and estimate/actual difference are checked.
  60: - [ ] Free space, WAL growth and retention/slots are owned.
  61: - [ ] Heavy operation has lock, temporary space, execution time and return path.
  62:- [ ] Backup and trial recovery are verified separately from maintenance.
  63: 
  64: ## self-test
  65: 
  66: 1. What is the difference between VACUUM and ANALYZE?
  67: 
  68: 2. Should normal VACUUM cut the file size in half?
  69: 
  70:3. Why can a long transaction prevent cleanup?
  71: 
  72: 4. Why shouldn't VACUUM FULL be the default program every night?
  73: 
  74:5. Is `n_dead_tup` the exact number and definitive rewrite command?
  75: 
  76: ### Answer letter with reason
  77: 
  78: 1. The first one handles erasable/space versions; The second takes the planner statistics. Their combination is also possible.
  79: 
  80:2. No; Internal reuse is the usual goal, and returning space to the OS is not the same guarantee.
  81: 
  82:3. An old snapshot may still require versions; Premature removal will spoil the reading accuracy.
  83: 
  84: 4. overwrites the table, requires heavy locking and extra space; It must have a cause and an operational window.
  85:86:5. No; It is an estimate and should be interpreted along with the trend, size, rate of change and type of workload.
  87: 
  88: ## Sources
  89: 
  90: - English: [Routine vacuuming](https://www.postgresql.org/docs/current/routine-vacuuming.html); MVCC cycle, autovacuum and wraparound.
  91: - English: [VACUUM command](https://www.postgresql.org/docs/current/sql-vacuum.html) and [Monitoring statistics](https://www.postgresql.org/docs/current/monitoring-stats.html); command behavior and the meaning of views.
  92: - Farsi: A suitable direct source for maintaining the current version of PostgreSQL was not verified in this review; Persian description of this page is provided. Match the engine claims with the official source of your version.
  93: 
  94: [Chapter list](../README.md) · [Collection list](../../README.md) · [Prev: Join](../07-join-optimization/README.md) · [Next: Slow logs](../09-slow-query-logging/README.md) · [Replication](../10-replication/README.md)
  95: 
  96: </div>

===== Backend Performance\04-databases\09-slow-query-logging\README.md =====
   1: <div dir="ltr" align="left">
   2: 
   3: # Slow-query Logging
   4: 
   5: **Learning Objective:** Separate the log of a slow run from aggregate statistics, choose thresholds and sampling wisely, and include sensitive information in log design. **Checking sources: 2026-11-10**; The settings are specific to PostgreSQL and are not implemented.
   6: 
   7: ## mental model
   8: 
   9: Slow log records the occurrence of a specific execution: what time, what statement and with what duration? Cumulative statistics tells how much the query family spent in a period. A frequent query of 10 milliseconds may have a higher total cost than a rare query of 2 seconds, although it does not cross the slow log threshold. The query log also does not show the waiting time for connection in the program.
  10: 
  11: Tool/Index | Answer Limitations
  12: --- | --- | --- |
  13: Slow log | Which should be implemented and when? | Volume, cost and sensitive data
  14: pg_stat_statements | Frequent family and total cost | It doesn't happen once and p99
  15: App trace | Application path and dependencies The need for instrumentation and sampling
  16: 
  17: In [PostgreSQL Logging Reference](https://www.postgresql.org/docs/current/runtime-config-logging.html), `log_min_duration_statement` the statement logging threshold is over; `-1` is inactive and `0` has been registered for a long time. This is not a timeout threshold or query cancellation. There is duration-based sampling with separate settings; Read their names and interactions for your copy.
  18: 
  19: ## Application and compromise
  20: 
  21: Useful for detecting sporadic events and correlation with lock/I/O. Logging all queries forever may cost a lot of CPU, disk and transfer. Select threshold from SLO and registration fee; The sample number below is not a general recommendation. query text, literal and bind parameter can have private or secret data; Limiting the log parameters does not necessarily clear the literal inside the SQL text. Design access, retention and downstream redaction.
  22: 
  23: ## Solved example
  24: 
  25: In the test session with the required permission, just to see the threshold behavior:
  26: 
  27: <div dir="ltr" align="left">
  28: 
  29:```sql
  30: SHOW log_min_duration_statement;
  31: SET log_min_duration_statement = '250ms';
  32: SELECT pg_sleep(0.05);
  33: SELECT pg_sleep(0.30);
  34: RESET log_min_duration_statement;
  35: ```36: 
  37: </div>
  38: 
  39: By accessing the log destination, the second statement is expected to be recorded and the first one remains below the threshold under normal conditions. The actual load can change the time. The location of the log and SET permission depends on the installation and the managed service. RESET does not necessarily return to the previous custom session value; Open a separate session in the test or save the previous value and return it explicitly. In the extended protocol, the parse/bind/execute steps have their own registration details.
  40: 
  41: ## Practice and expected observation
  42: 
  43: Run the above scenario in the temporary environment and compare the time, session and duration with the log. Then rank two workloads on paper: A with 1000 10ms executions and B with one 2s execution. Expectation: B is seen at the threshold of 250ms, but the total time of A is 10s and B is 2s. Aggregate statistics should be available for A. This sum of time is not a calendar period in simultaneous execution.
  44: 
  45: ## Public witness and evidence limit
  46: 
  47: [Official Error Reporting and Logging] (https://www.postgresql.org/docs/current/runtime-config-logging.html) operational witness of thresholds and cost/logging details. This lesson does not have an incident report or numerical improvement of a company; `pg_sleep` is intentionally a threshold test and not a real benchmark query.
  48: 
  49: ## Failures, signals and checklist
  50: 
  51: Absence of log does not always mean that the system is fast: wrong destination, sampling or waiting Pool can be the explanation. Monitor the volume of logs and dropped logs. Registering the complete query in the public ticket and metric label with raw SQL can also cause data leakage and high cardinality.
  52: 
  53: - [ ] Threshold, sampling and registration activation interval are specified.
  54: - [ ] Destination, rotation, retention and disk space are monitored.
  55: - [ ] access permission and sensitive literal/parameter management defined.
  56: - [ ] timestamp, DB/user/session and appropriate correlation ID exist.
  57: - [ ] slow log is completed with summary statistics and request trace.
  58: - [ ] The experimental setting and its restore path are recorded.
  59: 
  60: ## self test
  61: 
  62: 1. What is the difference between slow log threshold and statement timeout?
  63: 
  64: 2. Why a thousand fast queries may be more important than one slow query?
  65: 
  66: 3. Does limiting the bind parameter remove all sensitive data?
  67: 
  68: 4. Why a slow request may not have any slow SQL?
  69: 
  70:5. Why does zeroing the threshold forever require evaluation?
  71: 
  72: ### Answer letter with reason
  73: 
  74: 1. The first registers; The latter can cancel execution. Observation and control tools are not the same.
  75: 
  76: 2. Total cost is the result of quantity and duration; The query consumes capacity below the threshold.
  77: 
  78: 3. No; literal inside SQL or metadata can also be sensitive and require independent policy.
  79: 
  80:4. The time may be spent in the pool, network, program or a few short queries.
  81: 
  82:5. All statements are logged; CPU, I/O, transmission and retention can be expensive.
  83: 
  84: ## Sources
  85:86: - English: [PostgreSQL logging configuration](https://www.postgresql.org/docs/current/runtime-config-logging.html); Threshold, sampling and parameters.
  87: - Additional English: [Monitoring database activity] (https://www.postgresql.org/docs/current/monitoring.html); log position next to other tools.
  88: - Farsi: [identification of slow database queries] (https://pro-nee.net/terms/slow-queries/); Introduction Slow query log, APM and EXPLAIN. Get PostgreSQL fine-tuning, privacy, and sampling from the official reference; Don't assume any Join/CTE overrides are better without testing.
  89: 
  90: [Chapter List](../README.md) · [Collection List](../../README.md) · [Prev: Maintenance](../08-database-maintenance/README.md) · [Next: Replication](../10-replication/README.md) · [Profiling](../12-database-profiling/README.md) · [Monitoring](../../07-monitoring-and-logging/README.md)
  91: 
  92: </div>