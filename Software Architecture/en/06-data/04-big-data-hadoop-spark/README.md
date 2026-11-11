# Big Data: Hadoop and Spark

## Learning goals

- Understand distributed storage and computation at a high level.
- Compare batch processing, stream processing, and interactive analytics.
- Recognize partitioning, shuffles, skew, fault recovery, and data-format choices.

## Core idea

Big-data tools distribute storage and computation across machines when one machine or one database cannot meet the workload's volume, speed, or variety needs economically. Distribution creates new costs: network transfer, coordination, skew, retries, schema management, and operations. Measure the workload before adopting a cluster.

## Hadoop and Spark

Hadoop's ecosystem popularized distributed storage with HDFS and batch computation with MapReduce. HDFS splits large files into blocks replicated across nodes; MapReduce maps records to intermediate key-value pairs and reduces values by key. Spark provides a general distributed engine with APIs for batch, SQL, streaming, and iterative computation. It can process data in memory when appropriate, but it still performs network shuffles and can spill to disk.

Partitioning determines which worker handles a key range. A wide transformation such as a join or group-by can require a shuffle, moving data across the network. Skewed keys may send most work to one task. Address skew by inspecting task metrics, changing partitioning, salting hot keys when semantics allow, or using a better join strategy. Increasing worker count does not automatically fix skew or an inefficient query.

Use columnar formats such as Parquet when analytical queries scan selected columns. Define schemas, evolution rules, partition sizes, and small-file compaction. Object storage, open table formats, and managed engines may replace parts of a classic Hadoop cluster; select based on workload, governance, portability, and operational skills.

## Batch versus streaming

Batch processes bounded data on a schedule and supports replay from durable inputs. Streaming processes unbounded events continuously and needs explicit event-time windows, late-event handling, state retention, delivery semantics, and recovery checkpoints. “Exactly once” is an end-to-end property only when sources, processing, and sinks cooperate; a framework option alone cannot guarantee that an external side effect happens once.

## Worked example: daily sales aggregation

Read immutable order and refund events from partitioned storage, validate schema and duplicate IDs, aggregate by event date and product, and write output to a versioned partition. Re-running the same input should replace or merge the same logical partition deterministically. Compare totals with source records and publish completion/freshness metrics.

## Self-check quiz

1. What is a shuffle? Cross-partition data movement required by operations such as joins or grouping.
2. Why can adding workers fail to speed up a job? A serial bottleneck, skew, I/O limits, poor partitioning, or coordination may dominate.
3. What does event time represent? When the event occurred, which may differ from processing/arrival time.
4. Why compact small files? Excessive file metadata and task overhead can slow distributed reads.
5. Is exactly-once processing guaranteed solely by choosing a streaming framework? No; the end-to-end source, state, sink, and side-effect behavior must support it.

## Exercise

Sketch a replayable daily aggregation pipeline. Identify the source, partition key, deduplication key, transformation, output format, quality checks, and handling of late refunds.

### Sample answer

Store immutable events partitioned by ingestion date and retain event time plus stable event ID. Deduplicate by event ID, aggregate by business date and product, and write a versioned columnar output partition. Reprocess a bounded date range when late refunds arrive, publish freshness and reconciliation metrics, and make output replacement idempotent.

## Further reading

- First-hand case: [LinkedIn's Kafka production experience](https://www.linkedin.com/blog/engineering/open-source/apache-kafka-trillion-messages) illustrates partitioning, operations, and scale-specific engineering.
- English: [Apache Hadoop documentation](https://hadoop.apache.org/docs/), [Apache Spark documentation](https://spark.apache.org/docs/latest/), [Spark SQL performance tuning](https://spark.apache.org/docs/latest/sql-performance-tuning.html), [Spark Structured Streaming guide](https://spark.apache.org/docs/latest/streaming/index.html), [Parquet documentation](https://parquet.apache.org/docs/), [Google MapReduce paper](https://research.google/pubs/mapreduce-simplified-data-processing-on-large-clusters/)
- Persian: [DNTips](https://www.dntips.ir/), [Quera: Big Data learning paths](https://quera.org/college)
