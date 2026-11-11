# MongoDB Connectors: Kafka, Spark, and Elasticsearch

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/07-ecosystem/connectors-detail/README.md).

> **Learning goal:** Evaluate connector ownership, delivery semantics, retries, lag, and resynchronization for each integration.

## MongoDB and Kafka

MongoDB's Kafka Connector can act as a source or sink. A source publishes MongoDB changes to Kafka topics; a sink consumes records and writes them to MongoDB. Design topic keys, partition ordering, offsets, retry behavior, dead-letter handling, and destination idempotency. Consumers can process the same event again after a failure.

## MongoDB and Spark

The MongoDB Spark Connector lets Spark jobs read and write MongoDB data. For large analytics, choose a projection and partitioning strategy that avoids concentrating work on one partition or shard. Schedule heavy reads with the operational workload in mind. Add checkpoints and safe job retries, and measure the load imposed on the production database.

## MongoDB and Elasticsearch

Elastic publishes a MongoDB connector for synchronizing data into Elasticsearch. It is not the MongoDB Kafka Connector. Check the current connector method, Elastic and MongoDB versions, field mappings, deletes, and resync behavior. Some connector documentation has changed or been discontinued over time, so use the current owner's documentation.

## Define the event contract

For each message, define a stable key, operation type, schema version, delete representation, and source timestamp. Monitor event lag, failed records, throughput, checkpoint age, and replay status. Keep a snapshot-and-rebuild process if the consumer can no longer resume from its old checkpoint.

## Example flow

~~~text
MongoDB -> Kafka topic -> idempotent consumer -> Elasticsearch index
failure -> retry -> dead letter + alert -> rebuild projection from source
~~~

## Practical case: Bazaarvoice search catalog

MongoDB's published Bazaarvoice story discusses a large product catalog with Atlas Search and cluster sharding. It illustrates why ingestion, targeted queries, search freshness, and a rebuildable search projection matter as a catalog grows. Treat the account as a customer/vendor story, not an independent benchmark. [Bazaarvoice story](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice)

## Common mistakes

- Assuming a connector automatically guarantees business-level exactly-once effects.
- Not handling duplicates or deletes.
- Missing a resync path when offsets or resume tokens expire.
- Using mismatched connector and server versions.
- Letting analytics jobs overload the operational database.

## Exercises

1. Design MongoDB-to-search sync for duplicate, update, delete, and schema change.
2. Choose lag and dead-letter alerts.
3. Describe how to rebuild the destination from a fresh snapshot.

## Quiz and answer key

1. **What two roles can the MongoDB Kafka Connector play?** Source and sink.
2. **What is the Spark Connector for?** Reading/writing MongoDB data from Spark jobs.
3. **Who publishes the MongoDB-to-Elasticsearch connector described here?** Elastic; verify the current product documentation.
4. **Why avoid assuming exactly once?** Failures can repeat messages or side effects; design idempotency and recovery from actual semantics.
5. **Applied task: design sync to search.** Use stable product IDs, idempotent upserts/deletes, checkpoint after durable writes, alert on lag, and implement full rebuild.
6. **What is message lag?** The difference between source progress and consumer processing position/time.
7. **Why define delete semantics?** A sink must know how to remove or tombstone a deleted source record.
8. **What is a dead-letter queue?** A place to isolate repeatedly failing records for inspection.
9. **Why keep analytics load in mind?** Large scans can consume operational resources and increase latency or replication lag.
10. **Why must a destination be rebuildable?** Checkpoints can be lost or expire, and the search index may need full repair.

## Further reading

- [MongoDB Kafka Connector](https://www.mongodb.com/docs/kafka-connector/current/)
- [Kafka Connector Change Stream Source](https://www.mongodb.com/docs/kafka-connector/current/source-connector/fundamentals/change-streams/)
- [MongoDB Spark Connector](https://www.mongodb.com/docs/spark-connector/current/)
- [Elastic MongoDB Connector](https://www.elastic.co/docs/reference/search-connectors/)
- [MongoDB Connector Integrations](https://www.mongodb.com/products/integrations/connectors)
- [Change Streams](https://www.mongodb.com/docs/manual/changeStreams/)
- [Bazaarvoice customer story](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice)
- [Persian MongoDB series — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [Curated reference library: connectors](../../reference-library.md#ecosystem-streams)

---
Sources reviewed: 2026-11-11. Confirm current connector ownership and compatibility before deployment.
