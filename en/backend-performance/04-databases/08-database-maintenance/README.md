<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/04-databases/08-database-maintenance/README.md) · English

# Database Maintenance — Statistics, VACUUM, and Capacity

**Learning goal:** Distinguish ANALYZE from VACUUM, detect maintenance lag from signals, and assess locks and disk space before heavy operations. Sources were checked on 2026-11-10; PostgreSQL example was completed and link-checked on 2026-11-11. It was not executed. Other engines have different maintenance cycles.

## Mental model

In PostgreSQL MVCC, UPDATE and DELETE can leave old row versions behind. VACUUM prepares reclaimable versions and space for reuse; ANALYZE collects data distribution statistics for the planner. Autovacuum automates much of this work, but table size and change rate can require tailored settings. Long-running transactions can delay cleanup of old versions.

| PostgreSQL operation | Purpose | Operational note |
| --- | --- | --- |
| ANALYZE | planner statistics | estimates are not exact row counts |
| VACUUM | dead-version cleanup and visibility | usually makes internal space reusable |
| VACUUM FULL | rewrites and compacts a table | heavy lock and extra temporary space |
| Backup/restore drill | recovery capability | not a substitute for vacuuming |

Routine vacuuming also addresses the visibility map and transaction-ID wraparound protection. Turning maintenance off to quiet a chart creates operational debt.

## Prerequisites and maintenance mechanism

With MVCC, an update or deletion can leave an older version so a valid snapshot can still see it. VACUUM processes versions that are safe to remove and usually prepares space for reuse within the relation; ANALYZE samples rows to refresh planner estimates. Autovacuum performs maintenance according to thresholds; neither command means the file instantly compacts and returns all space to the operating system.

## Use and trade-offs

Maintenance is continuous operational work. High-change tables need table-level monitoring; one schedule for every table is not enough. VACUUM and ANALYZE consume I/O and CPU, so budget them against production traffic. VACUUM FULL is not routine latency tuning and is different from regular VACUUM. For reindexing or rewrites, know the cause, locks, space, and rollback path.

## Worked example

For a test orders table, inspect estimated activity and maintenance times:

~~~sql
SELECT relname, n_live_tup, n_dead_tup,
       last_autovacuum, last_autoanalyze
FROM pg_stat_user_tables
WHERE relname = 'orders';

ANALYZE orders;
-- Run as a standalone command, not inside BEGIN/COMMIT:
VACUUM (ANALYZE) orders;
~~~

n_dead_tup is an estimate and does not prove bloat by itself. The last-run fields do not show duration or work volume. In production, combine stale timestamps with change rate, worker state, progress, and old transactions. One query is not enough evidence for VACUUM FULL.

## Worked exercise

In a temporary database, create 10,000 rows, update/delete some, then run ANALYZE and regular VACUUM. Record statistics, plan, and file size. Reusable space may be prepared, but the file is not guaranteed to shrink in the same proportion. Statistics are sampled. Then reason about an open REPEATABLE READ transaction that has already selected rows: its snapshot may still require older versions. Do not run these commands against real data as a casual exercise.

For example, after changing/deleting 2,000 rows, dead-tuple statistics are estimates and cleanup depends on open snapshots. ANALYZE targets planner estimates; regular VACUUM processes removable versions and visibility. The file need not shrink by 2,000 rows because internal space can be reused. An old transaction can still need an earlier version.

## Troubleshooting and checklist

Check disk/WAL growth, stale statistics, estimated dead tuples, old transactions, and delayed workers alongside latency. A lagging replication slot can retain WAL; do not delete it without knowing its consumer. Concurrent rebuilds can exhaust disk space.

- [ ] Monitor autovacuum health, worker progress, and per-table change rate.
- [ ] Make old transactions and idle-in-transaction sessions visible.
- [ ] Inspect planner statistics and estimate/actual differences.
- [ ] Assign ownership for free disk, WAL growth, and slot retention.
- [ ] Heavy operations have lock, temporary-space, time, and rollback plans.
- [ ] Test backups and restores separately from maintenance.

If dead tuples or disk use rise, inspect trends and change rate across several windows; then check last autovacuum/autoanalyze, workers, and long transactions. Estimate mismatches point toward ANALYZE; delayed cleanup points toward VACUUM and snapshots. Treat disk and WAL separately. An estimate alone is not authorization for VACUUM FULL.

## Evidence and limits

The official PostgreSQL maintenance guide is the operational source. No company case with a directly relevant measured result is cited. Do not generalize PostgreSQL vacuum behavior to compaction in an LSM engine or rebuild behavior in SQL Server.

## Self-check

1. What is the difference between VACUUM and ANALYZE?
2. Should regular VACUUM halve the file size?
3. Why can a long transaction block cleanup?
4. Why should VACUUM FULL not be a default nightly job?
5. Is n_dead_tup an exact count and a command to rewrite?

### Answers with reasoning

1. VACUUM handles removable versions and reusable space; ANALYZE gathers planner statistics. They can also run together.
2. No. Internal reuse is common; returning space to the operating system is not guaranteed.
3. An old snapshot may still need the versions; deleting them too soon would violate visibility rules.
4. It rewrites the table, needs a strong lock and extra space, and requires an operational reason/window.
5. No. It is an estimate to interpret alongside trends, table size, change rate, and workload.

## Optional further reading

This Persian lesson is the primary guide. These links are optional; no current Persian source dedicated to PostgreSQL vacuum operations was verified.

- English, official: [Routine vacuuming](https://www.postgresql.org/docs/current/routine-vacuuming.html) covers MVCC, autovacuum, and wraparound.
- English, official: [Vacuum configuration](https://www.postgresql.org/docs/current/runtime-config-vacuum.html) documents PostgreSQL autovacuum thresholds, scale factors, and workers; suitable values depend on table size and change rate.
- English, official: [VACUUM command](https://www.postgresql.org/docs/current/sql-vacuum.html) documents command behavior and restrictions.
- English, official: [PostgreSQL monitoring statistics](https://www.postgresql.org/docs/current/monitoring-stats.html) describes statistics views.
- English, official: [ANALYZE command](https://www.postgresql.org/docs/current/sql-analyze.html) explains collection of planner statistics and sampling.
- English, official: [Transaction-ID wraparound protection](https://www.postgresql.org/docs/current/routine-vacuuming.html#VACUUM-FOR-WRAPAROUND) describes a correctness reason for vacuuming.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Join](../07-join-optimization/README.en.md) · [Next: Slow-query logs](../09-slow-query-logging/README.en.md) · [Replication](../10-replication/README.en.md)

</div>
