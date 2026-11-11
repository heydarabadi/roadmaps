# ETL, Data Warehouses, and Analytics

## Learning goals

- Separate operational workloads from analytical workloads.
- Explain ETL and ELT, dimensional modeling, slowly changing dimensions, and data quality.
- Design a pipeline with lineage, idempotency, observability, privacy, and recovery.

## Core idea

Operational systems answer questions needed to run the business now; analytical systems help people understand patterns across time. A warehouse organizes integrated historical data for analysis. ETL transforms data before loading; ELT loads raw or lightly processed data and transforms it in the analytical platform.

## Warehouse modeling

A star schema places measurable business events in a **fact table** and descriptive context in **dimension tables**. An order-line fact may include quantity, net amount, and keys for date, product, customer segment, and region. Declare the grain first: one row per order line, shipment, or payment attempt. Mixing grains causes double counting.

Dimensions change over time. A type 1 update overwrites a descriptive value; a type 2 dimension preserves history with effective dates and a current-row marker. Choose based on the question: “current region” differs from “region when the order was placed.”

## Pipeline reliability

Extract or capture data with checkpoints. Make transformations deterministic where possible, attach source and ingestion timestamps, validate schema and business rules, and make reprocessing safe. An idempotent load can be retried without duplicating records. Track freshness, volume, null rates, rejected rows, and reconciliation against source totals.

Late-arriving events and corrections need policy. A daily sales report may restate prior days when refunds arrive; a financial close may instead freeze a certified snapshot. Record lineage from report metric back to source and transformation version. Apply least privilege, masking or aggregation for personal data, retention rules, and deletion propagation.

Do not run expensive warehouse scans against the primary transactional database by default. Use replicas, change streams, or batch exports with capacity controls. The pipeline itself is production software: it needs ownership, alerting, replay, backfill procedures, and cost monitoring.

## Worked example: revenue dashboard

Define revenue precisely: gross or net, order date or settlement date, treatment of tax, refunds, discounts, and currency conversion. Build a fact at payment or order-line grain that supports the required definition. Reconcile totals with finance, document late adjustments, expose freshness, and version the metric definition so reports do not silently change meaning.

## Self-check quiz

1. Why state fact-table grain before adding columns? Grain defines what each row means and prevents duplicate counting.
2. When is a type 2 dimension useful? When historical analysis must preserve prior attribute values.
3. What makes a pipeline retry-safe? Checkpointed, idempotent writes or deduplication keyed by a stable event or batch identity.
4. Why is a revenue metric definition part of architecture? Different date, refund, tax, and currency rules produce different numbers and decisions.
5. Name three useful pipeline signals. Freshness/lag, row counts or volume anomalies, and validation/reconciliation failures.

## Exercise

Specify a daily order analytics pipeline: source events, fact grain, two dimensions, quality checks, late-arrival behavior, and recovery from a failed load.

### Sample answer

Capture committed order and refund events with stable IDs and timestamps. Use one fact row per order line plus separate refund facts if their grain differs. Dimensions include product and order date with historical rules stated. Validate required identifiers, amounts, currency, duplicate IDs, and source-to-target totals. Retry a failed partition idempotently, alert on freshness, and support bounded backfill from retained source events.

## Further reading

- First-hand case: [Meta's large-scale data-ingestion migration](https://engineering.fb.com/2026/05/12/data-infrastructure/migrating-data-ingestion-systems-at-meta-scale/) documents shadow comparisons, quality gates, and staged rollback.
- English: [Kimball Group: Dimensional Modeling Techniques](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/), [Microsoft: What is a data warehouse?](https://learn.microsoft.com/en-us/azure/architecture/data-guide/relational-data/data-warehousing), [AWS: Data warehouse concepts](https://docs.aws.amazon.com/whitepapers/latest/data-warehouse-on-aws/data-warehouse-on-aws.html), [Google Cloud: Data warehouse architecture](https://cloud.google.com/architecture/data-warehouse), [dbt documentation](https://docs.getdbt.com/), [OpenLineage](https://openlineage.io/docs/)
- Persian: [DNTips technical articles](https://www.dntips.ir/), [Quera data engineering learning](https://quera.org/college)
