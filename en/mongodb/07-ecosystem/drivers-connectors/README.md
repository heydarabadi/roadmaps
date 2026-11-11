# Drivers and Data Connectors

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/07-ecosystem/drivers-connectors/README.md).

> **Learning goal:** Distinguish application drivers from data connectors and design integrations for duplicates, retries, ownership, and replay.

## Driver or connector?

A **driver** is used directly by an application to issue MongoDB operations. A **connector** moves or streams data between MongoDB and another system such as Kafka, Spark, or Elasticsearch. The two solve different problems and have different ownership and operational concerns.

## Application connection pattern

Create a long-lived client per application process, reuse its connection pool, and configure timeouts based on a measured SLO. Keep a single request from creating its own client. Monitor pool wait, connection churn, topology errors, command latency, and retry activity.

## Data-pipeline contract

For every pipeline, document:

- Which system is the source of truth?
- Are events or writes delivered at least once, and how are duplicates handled?
- What does ordering mean, and what key determines a partition or target document?
- How are schema changes and deletes represented?
- Where do retries, dead-letter records, and checkpoints live?
- How can the destination be rebuilt from source data?

Do not assume “exactly once” at the business level because a connector advertises processing guarantees. External side effects and destination writes can be repeated after failure. Use a stable key and idempotent upserts, and test replay after a crash.

## Example architecture

~~~text
MongoDB Change Stream -> Kafka source connector -> topic -> consumer
consumer -> idempotent projection -> search index
failure -> retry/dead-letter/alert -> snapshot rebuild and replay
~~~

Track lag, throughput, failed records, checkpoint age, and replay progress. Define a resynchronization process for events that expire from the source retention window.

## Exercise

Design a product-search sync flow. Specify update/delete semantics, duplicate handling, topic key, checkpoint, dead-letter policy, monitoring, and full-rebuild steps.

## Common mistakes

- Using an application driver as if it were a managed streaming connector.
- Assuming exactly-once business outcomes.
- Failing to make a destination write idempotent.
- Losing deletes or schema changes during sync.
- Having no rebuild path after retention or checkpoint loss.

## Quiz and answer key

1. **What is a language driver for?** Application code that sends MongoDB commands.
2. **What does a data connector do?** Moves or streams data between MongoDB and another system.
3. **Why does the source-of-truth question matter?** It tells the system which copy can rebuild the others.
4. **Why not assume exactly-once business behavior?** A failure can repeat a write or side effect; define real delivery semantics and make processing idempotent.
5. **Applied task: sync product changes to search.** Key by product ID, process upserts and deletes idempotently, checkpoint after durable destination writes, monitor lag, and support rebuild.
6. **What is a dead-letter queue for?** Holding records that repeatedly fail so they can be inspected and repaired.
7. **Why use a stable message key?** It helps determine partitioning, ordering, and idempotent destination updates.
8. **What metric indicates slow consumers?** Increasing event lag or checkpoint age.
9. **What if the stream cannot resume from its checkpoint?** Rebuild from the source snapshot and then resume/replay from a valid point.
10. **Who publishes Elastic's MongoDB connector?** Elastic; it is distinct from MongoDB's Kafka connector.

## Further reading

- [MongoDB Connectors overview](https://www.mongodb.com/products/integrations/connectors)
- [MongoDB Kafka Connector](https://www.mongodb.com/docs/kafka-connector/current/)
- [MongoDB Spark Connector](https://www.mongodb.com/docs/spark-connector/current/)
- [Elastic MongoDB Connector](https://www.elastic.co/docs/reference/search-connectors/)
- [Change Streams](https://www.mongodb.com/docs/manual/changeStreams/)
- [Curated reference library: drivers and connectors](../../reference-library.md#ecosystem-drivers)

---
Sources reviewed: 2026-11-11. Connector ownership, version compatibility, and delivery behavior change over time.
