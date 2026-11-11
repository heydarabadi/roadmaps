<div dir="ltr" align="left">

[فارسی](README.md) · English

# Slow-Query Logging

**Learning goal:** Distinguish an individual slow execution from aggregated query statistics, choose thresholds and sampling deliberately, and protect sensitive data. Sources were checked on 2026-11-10; PostgreSQL examples were completed and link-checked on 2026-11-11. Settings were not executed.

## Mental model

A slow log records a particular execution: when it happened, which statement ran, and how long it took. Aggregated statistics show the total cost of a query family over a period. A frequent 10ms query can cost more in aggregate than a rare 2s query even if it never crosses the slow-log threshold. A database query log also does not show time spent waiting for an application-pool connection.

| Tool or signal | Question it answers | Limitation |
| --- | --- | --- |
| Slow log | Which individual execution was slow and when? | volume, cost, sensitive data |
| pg_stat_statements | Which query family is frequent and costly overall? | not an individual event or true p99 |
| Application trace | Which path and dependency consumed request time? | instrumentation and sampling required |

In PostgreSQL, the log_min_duration_statement parameter sets a threshold for completed statements; -1 disables it and 0 logs all durations. This threshold is not a timeout or cancellation. Duration-based sampling is configured separately; check how options interact in the installed version.

## Prerequisites and interpretation

A logging threshold selects which completed statement executions are recorded. A timeout caps allowed execution time and may cancel work. Aggregated statistics summarize a query family over a window. Thus “which event was slow?” and “which family consumed capacity?” are different questions.

## Use and trade-offs

Slow logs help investigate isolated events and correlate them with lock or I/O conditions. Logging every query forever can consume CPU, disk, and transfer capacity. Choose the threshold from SLO and logging cost; the example’s value is not a general recommendation. Query text, literals, and bind parameters may contain personal data or secrets. Limiting logged parameters does not necessarily redact literals embedded in SQL text; define access, retention, and downstream redaction.

## Worked example

In a test session with the required privileges:

~~~sql
SHOW log_min_duration_statement;
SET log_min_duration_statement = '250ms';
SELECT pg_sleep(0.05);
SELECT pg_sleep(0.30);
RESET log_min_duration_statement;
~~~

If you can read the configured log destination, the second statement is expected to be recorded and the first to stay below threshold under ordinary conditions. System load may change duration. The log destination and permission to SET are installation- or managed-service-specific. RESET does not necessarily restore a previously customized session value; use a separate test session or save and explicitly restore the old value. Extended-protocol parse/bind/execute phases have additional logging details.

## Worked exercise

Run the scenario in a disposable environment and compare clock/session/duration with the log. Then rank two hypothetical workloads: A has 1,000 runs at 10ms each; B has one run at 2s. A totals 10s, B totals 2s. At a 250ms threshold B is visible but A is not, even though A consumes five times as much aggregate execution time. This sum is not wall-clock time when runs overlap. Use aggregate statistics for A as well.

## Troubleshooting and checklist

No slow-log entry does not prove the system is fast: the log destination may be wrong, sampling may be active, or delay may be in the application pool. Monitor log volume and dropped records. Raw query text in public tickets or metric labels can leak data and create high cardinality.

- [ ] Threshold, sampling, and active window are documented.
- [ ] Destination, rotation, retention, and disk capacity are monitored.
- [ ] Access permissions and handling of sensitive literals/parameters are defined.
- [ ] Useful timestamp, database/user/session, and correlation identifiers are present.
- [ ] Slow logs are paired with aggregate statistics and request traces.
- [ ] Test settings and the restoration procedure are recorded.

If the user-facing request is slow but no slow SQL appears, inspect pool, network, and application time; then verify sampling, threshold, log destination, dropped records, and rotation. Before lowering the threshold, estimate log rate, retention space, and query-text privacy impact.

## Evidence and limits

The official PostgreSQL logging documentation is the operational source for thresholds and logging controls. This lesson has no company incident report or measured improvement; pg_sleep is a threshold demonstration, not a query benchmark.

## Self-check

1. What is the difference between the slow-log threshold and statement timeout?
2. Why can a thousand fast queries matter more than one slow query?
3. Does limiting logged bind parameters remove every sensitive value?
4. Why might a slow request have no slow SQL?
5. Why does logging every statement indefinitely need evaluation?

### Answers with reasoning

1. One records executions; the other can cancel them. Observation and control are different.
2. Aggregate cost depends on both count and duration; below-threshold queries still use capacity.
3. No. SQL literals and metadata may also be sensitive and need their own policy.
4. Time may be in pool wait, network, application code, or several short queries.
5. Every statement can add CPU, I/O, transfer, and retention cost.

## Optional further reading

The lesson provides the necessary interpretation and example. These links are optional engine-specific references.

- Persian: [Finding slow database queries](https://pro-nee.net/terms/slow-queries/) introduces slow logs, APM, and EXPLAIN; query rewrites must still be measured.
- English, official: [PostgreSQL logging configuration](https://www.postgresql.org/docs/current/runtime-config-logging.html) documents thresholds, sampling, and parameters.
- English, official: [Monitoring database activity](https://www.postgresql.org/docs/current/monitoring.html) describes tools to pair with logs.
- English, official: [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) documents query-family aggregates and counter lifecycle.
- English, official: [PostgreSQL monitoring statistics](https://www.postgresql.org/docs/current/monitoring-stats.html) describes activity and statistics views.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Maintenance](../08-database-maintenance/README.en.md) · [Next: Replication](../10-replication/README.en.md) · [Profiling](../12-database-profiling/README.en.md) · [Monitoring chapter](../../07-monitoring-and-logging/README.en.md)

</div>
