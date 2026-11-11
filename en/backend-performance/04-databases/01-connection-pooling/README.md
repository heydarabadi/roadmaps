<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/04-databases/01-connection-pooling/README.md) · English

# Connection Pooling

**Learning goal:** Distinguish connection reuse from data caching, size a pool against database capacity, and diagnose connection-acquisition waits. **Sources checked: 2026-11-10; lesson completed and links checked: 2026-11-11.** Examples are educational and were not executed.

## Mental model and mechanism

Opening a connection involves network setup, authentication, and session creation. A pool keeps connections open, lends one to a request, and expects it back after the short database task, whether the task succeeds or fails. A bounded pool controls concurrent entry to the database; it does not make SQL execution capacity unlimited.

| Stage | Measurable duration | Possible cause of delay |
| --- | --- | --- |
| Acquire | acquire wait | saturated pool, leak, long transaction |
| Run SQL | execution or lock wait | plan, lock, I/O, or CPU |
| Release | hold duration | connection kept while calling another service |

A driver pool and an external pooler are separate layers. In PgBouncer, session mode holds a server connection until the client disconnects, transaction mode until the transaction ends, and statement mode until the statement ends. Statement mode does not support a multi-statement transaction. This changes the assumptions the application can make about session state.

## Prerequisites, lifecycle, and diagnosing a queue

Concurrency is the amount of work waiting or running at the same time. A database session is temporary state associated with a connection. Hold time runs from checkout to return. Pooling reuses connections, not query results.

1. Ask the pool for a connection using the time left in the request budget.
2. After acquiring it, keep the transaction only around required database work.
3. Commit or roll back; discard a broken connection and release a healthy one.
4. Measure acquire time, SQL execution time, and hold time separately.

## Use and trade-offs

Pooling helps with frequent short requests. Long transactions or session state such as temporary tables or persistent SET values require checking pooler compatibility. Prepared-statement support depends on version, driver, protocol, and configuration. With a nonzero setting for managed prepared statements, PgBouncer can manage some named protocol-level prepared statements; SQL-level PREPARE does not behave the same way. Check the manual for the installed version.

A larger pool may temporarily reduce the queue, but can raise CPU, memory, and lock contention. Coordinate acquisition timeouts with the request deadline and load-shedding policy; unbounded retries make a new queue.

## Worked example

Assume four application instances, each with a maximum pool of 20 connections: the potential total is 80. If the database budget assigned to this service is 60, this setup is not acceptable even if each instance looks healthy alone. Count admin access, workers, and other services separately.

<pre dir="ltr"><code>connection = pool.acquire(timeout = remaining_request_budget)
try:
    begin(connection)
    rows = query(connection, parameterized_sql)
    commit(connection)
    return rows
catch error:
    rollback_if_needed(connection)
    raise error
finally:
    pool.release_or_discard_broken(connection)</code></pre>

Do HTTP calls or image processing before acquiring the connection or after releasing it unless a clear transactional need requires otherwise. A failed rollback or broken connection must not be returned uncleaned.

## Worked exercise: a two-connection pool

Run 10 simultaneous requests in a lab with a two-connection pool. Make each query take 100ms and record acquire wait and hold time separately; then force one request to fail. In the idealized model, the work runs in five waves. The first two requests wait zero; the second wave waits about 100ms and the fifth about 400ms. Average acquisition wait is (0+0+100+100+200+200+300+300+400+400)/10 = 200ms; SQL still takes 100ms. The final wave finishes at about 500ms. After error cleanup, both pool slots must be usable again. This does not establish real database throughput.

## Evidence and limits

The PgBouncer manual is operational documentation for pool behavior; it is not a transferable company performance result. No public case with a generally applicable improvement percentage is used here. The pool size of 20 is an assumption, not a recommendation or a reported measurement.

## Failure signals and operational checklist

A leak can appear as a persistently busy pool and growing acquisition timeouts. An idle transaction can retain locks or old row versions. Application scale-out, failover, or simultaneous pool recreation can create a connection surge. Observe waiters alongside CPU and active transactions.

- [ ] Sum the limits for all instances, workers, and pool users.
- [ ] Bound acquisition timeout and the overall request deadline.
- [ ] Release in cleanup and roll back on failure.
- [ ] Check session-state and prepared-statement behavior for the deployed versions.
- [ ] Record acquire wait, hold time, busy/idle, timeouts, and database saturation.
- [ ] Define failover, broken-connection, and gradual-reconnect behavior.

When acquisition wait is high but SQL time is low, inspect busy/idle counts and waiters, then open transactions, error paths, and hold time. If hold time is high while SQL is short, find network calls or application work inside the connection window. If SQL and lock waits are also high, inspect the plan and database waits. Finally, sum all pool limits and compare them with the budget after workers and administrative reserves.

## Quick recap

A pool limits simultaneous database connections and reuses their setup cost. Size it against the aggregate budget and database capacity; diagnose time in the queue separately from time executing SQL.

## Self-check

1. Does a pool cache the result of a SELECT?
2. With three application instances and a limit of 30 each, what is the potential total?
3. SQL is fast but acquire wait is high. What do you inspect first?
4. Why can an HTTP call inside a transaction reduce capacity?
5. Is transaction pooling always compatible with session state?

### Answers with reasoning

1. No. It reuses a connection; a result cache has separate freshness rules.
2. 90, before counting other consumers.
3. Busy/idle counts, hold time, and release paths; queue delay does not necessarily mean a slow query.
4. The connection, and possibly locks, remain occupied during the call.
5. No. The server connection can change after a transaction, so persistent session-state assumptions need review.

## Optional further reading

This lesson contains the concepts, decision process, and exercise needed to learn the topic. The links below are optional deeper reading and version- or product-specific provenance.

- Persian: [Connection pooling and DbContext pooling](https://dntips.ir/www.dntips.ir-posts-3725.html) distinguishes connection pooling from .NET ORM-object reuse; it is not a universal driver configuration guide.
- English, official: [PgBouncer configuration](https://www.pgbouncer.org/config) documents pool modes and their constraints.
- English, official: [Microsoft SQL Server connection pooling](https://learn.microsoft.com/en-us/sql/connect/ado-net/sql-server-connection-pooling?view=sql-server-ver17) explains client-side reuse and pool exhaustion; defaults are provider-specific.
- English, official: [Amazon RDS Proxy concepts](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.howitworks.html) distinguishes client and database connections and describes multiplexing.
- English, official: [RDS Proxy connection considerations](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy-connections.html) covers pool limits, borrow waits, and service metrics.
- English, official: [PgBouncer FAQ](https://www.pgbouncer.org/faq.html) discusses prepared-statement compatibility by version and client protocol.

**Navigation:** [Database chapter, English](../README.md) · [Course index, English](../../README.md) · [Next: Indexes](../02-indexes/README.md) · [Scaling chapter](../../05-load-balancing-and-scaling/README.md)

</div>
