<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/04-databases/06-denormalization-for-read-heavy-workloads/README.md) · English

# Denormalization for Read-Heavy Workloads

**Learning goal:** Design a derived read model, state its freshness budget, and compare the cost of maintaining it with the repeated cost of computing each read. Sources were checked on 2026-11-10; the PostgreSQL teaching example was completed and link-checked on 2026-11-11. It was not executed.

## Mental model

Normalization reduces duplication and centralizes update rules. Denormalization stores part of a join, aggregate, or repeated value so reads do less work. A derived value needs a source of truth, an update owner, and a rebuild path. Summary tables, counters, and materialized views are different forms of this choice. A cache may serve a similar role, but its persistence and ownership contract must be stated separately.

| Maintenance method | Freshness | Cost |
| --- | --- | --- |
| Update in the write transaction | current with local commit | more write work and contention |
| Events/CDC and projector | delayed | replay, ordering, and idempotency |
| Periodic refresh | stale until next run | batch compute and refresh duration |

A high read/write ratio alone is not enough; the repeated query must actually be expensive and maintainable. A stale summary alone cannot authorize a final price or inventory decision.

## Prerequisites and read-model lifecycle

The source of truth is where base data is recorded under the primary business rules. A read model is derived data shaped for retrieval. Freshness is how far it lags behind source changes. Denormalization does not remove joins or aggregates; it moves that work to writes, a projector, or refresh. Define the owner, tolerated staleness, and rebuild path before creating one.

## Use and trade-offs

It can suit dashboards, lists, and reports with a stated freshness budget. For high write volume, constantly changing data, or transactions requiring immediate correctness, maintenance complexity may exceed the benefit. Extra storage, write amplification, and repair work are part of the cost. Measure the original query, indexes, and projection first.

## Worked example

Assume orders(id, customer_id, total, status) is the source of truth. A dashboard needs the count and sum of paid orders by customer and accepts a delay of several minutes:

~~~sql
CREATE MATERIALIZED VIEW customer_sales AS
SELECT customer_id, COUNT(*) AS order_count, SUM(total) AS amount
FROM orders
WHERE status = 'paid'
GROUP BY customer_id;

SELECT order_count, amount FROM customer_sales WHERE customer_id = 42;
-- Run outside a request:
REFRESH MATERIALIZED VIEW customer_sales;
~~~

In PostgreSQL, the result is stored and is not automatically updated by every write. Record the last successful refresh time. A regular refresh can make readers wait. REFRESH CONCURRENTLY has prerequisites, including a suitable unique index and an already-populated view, and still costs computation. Check the installed version’s command requirements.

If three paid orders have amounts 20, 30, and 50, the refreshed summary has amount 100 and count 3. A new paid order for 20 appears in the source while the view remains 100; after refresh it becomes 120. A refund of 30 must also be removed from the aggregate. An incremental projector must handle refunds/deletes and duplicate events or the summary becomes incorrect.

## Worked exercise

Add a paid order; compare the base-table query and the view before refresh, then refresh and compare again. The view is stale until refresh. For an event-projector design, consider a duplicate and an out-of-order event: tracking processed event IDs can prevent double application; aggregate versions can detect older events. These are design techniques, not guarantees supplied by every broker.

## Troubleshooting and checklist

Common failures include applying a duplicate event twice, missing refunds/deletes, partial updates across systems, and silent refresh failure. Track data age, projector lag, reconciliation differences, and refresh cost; read latency alone does not prove correctness.

- [ ] Source of truth and read-model owner are explicit.
- [ ] Freshness budget, timestamp/version, and stale-data behavior are defined.
- [ ] Updates, deletes, and refunds are represented.
- [ ] Replay and deduplication are designed for event-driven updates.
- [ ] Rebuild and reconciliation against the source exist.
- [ ] Read latency is weighed against write, storage, lock, and refresh costs.

If answers are fast but stale, compare the last refresh and projector lag with the freshness budget. Reconcile sums against the source and investigate failed refreshes, duplicate events, and deletes separately. Measure the original plan, indexes, and projection before adding a derived model.

## Evidence and limits

PostgreSQL’s official materialized-view documentation shows a stored sales summary and its freshness/performance trade-off. It is technical documentation, not a company production case; this lesson has no independently measured production result for the example.

## Self-check

1. What work does denormalization move away from a read?
2. Does a PostgreSQL materialized view update automatically after every INSERT?
3. Why is a duplicate event dangerous for a counter?
4. Does a stale inventory read authorize a sale?
5. Which signal is needed in addition to read speed?

### Answers with reasoning

1. It moves joins/aggregates or response shaping to writes, a projector, or refresh; the work is not eliminated.
2. No. The example requires an explicit refresh.
3. It can count the same change twice; use idempotency/deduplication or versioned recomputation.
4. No. The transaction and source-of-truth rules must validate the operation.
5. Data age and difference from the source; a fast stale value may violate the contract.

## Optional further reading

The page explains the pattern and its correctness concerns. These links are optional further reading.

- Persian: [Normalization and normal forms](https://pro-nee.net/collections/normalization-and-normal-forms/) introduces deliberate redundancy and anomalies; the lesson itself explains replay and reconciliation.
- Persian, supplemental: [Metabase Persian: making dashboards faster](https://metabase.ir/learn/metabase-basics/administration/administration-and-operation/making-dashboards-faster) gives a materialized-view example; its product workflow is not a database rule.
- English, official: [PostgreSQL materialized views](https://www.postgresql.org/docs/current/rules-materializedviews.html) documents stored results and a reporting example.
- English, official: [REFRESH MATERIALIZED VIEW](https://www.postgresql.org/docs/current/sql-refreshmaterializedview.html) documents refresh behavior and concurrent-refresh requirements.
- English, official: [Microsoft CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs) explains read projections and eventual consistency.
- English, official: [AWS Prescriptive Guidance: CQRS](https://docs.aws.amazon.com/prescriptive-guidance/latest/modernization-data-persistence/cqrs-pattern.html) walks through updates to a query model.
- English, official: [.NET cloud-native distributed data patterns](https://learn.microsoft.com/en-us/dotnet/architecture/cloud-native/distributed-data) discusses normalized write and denormalized read models.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Projection](../05-select-only-needed-columns/README.en.md) · [Next: Join optimization](../07-join-optimization/README.en.md) · [Background jobs](../../03-asynchronism/01-background-jobs/README.en.md)

</div>
