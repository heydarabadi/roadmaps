# Databases: SQL and NoSQL

[فارسی](../../../05-data-and-caching/16-databases/README.md)

## Learning goals

- Choose a database from query patterns and business guarantees.
- Explain the ACID properties and common NoSQL model families.
- Understand indexes, transactions, replication, partitioning, and backups.
- Recognize the operational cost of adding another datastore.

## Central idea

Choose a database by starting with queries, transactions, consistency, capacity, and the team’s operational ability—not slogans such as schema-less or infinitely scalable.

## Concept map

Business facts → reads and writes → transaction/invariant needs → data model and indexes → replication/partitioning → backup and operations.

## Detailed lesson

### Start with queries, not product names

For each capability, write down what is written and read, whether access is by key, range, or join, what ordering and freshness are required, how much data exists and how quickly it grows, and whether several changes must commit atomically.

Then evaluate storage systems against the actual access patterns. One popular database rarely solves every data model and service-level need at low cost.

### Relational models and ACID

A relational database represents data as tables and relationships. Constraints such as foreign keys and unique keys can enforce invariants in the source of truth.

ACID describes transaction properties:

- **Atomicity:** all transaction changes commit, or none do.
- **Consistency:** committed changes preserve the defined database invariants.
- **Isolation:** concurrent transactions have controlled interactions.
- **Durability:** committed data survives failures covered by the database’s guarantees.

Isolation levels matter. READ COMMITTED and SERIALIZABLE provide different behavior and cost. ACID does not mean the application contains no business-logic bugs; it describes transaction behavior within the system’s scope.

### Common NoSQL families

- **Key-value:** lookup by key, useful for sessions, feature flags, or cache entries.
- **Document:** semi-structured records and aggregates that are often read or written together; understand the indexes and queries.
- **Wide-column:** large partitioned datasets accessed by key and ordered columns; design from the query pattern.
- **Graph:** relationships and multi-step traversals where relationship navigation is central.

These are not strict marketing boundaries; some systems combine models. “Schema-less” usually means the application owns more schema validation, not that a schema does not exist.

### Indexes and query cost

An index speeds a lookup but consumes storage and adds work to writes. Every update may need to update relevant indexes. Start with real queries and cardinality.

A composite index has a column order. An index on (tenant_id, created_at) may support tenant filtering and a time range, but might not efficiently serve a query filtering only by created_at. Use the database’s query-plan tooling, such as EXPLAIN, to see what the engine does.

N+1 queries, full scans, lock contention, and connection exhaustion are common performance causes. Do not add indexes blindly: measure both read benefit and write cost.

### Transactions and invariants

Enforce rules such as “each provider idempotency key is unique” with a database constraint as well as application validation. Two concurrent requests can both pass an application-only check before either writes.

Keep transactions short. Avoid a slow network call inside a long database transaction. For cross-service workflows, use an explicit saga or outbox and state where atomicity ends.

### Replication, partitioning, and backups

Replication creates copies and can support more reads. Sharding distributes data among partitions to increase storage or write capacity. Sharding makes cross-partition queries, rebalancing, and hot-key handling harder.

Neither replication nor sharding is a backup. Backups need scheduling, encryption, retention, point-in-time recovery where required, and a tested restore procedure. A successful backup job is not evidence of recovery until a restore is verified.

### How to select

For each candidate, try a representative query, transaction, index, migration, backup and restore, and incident operation. Consider consistency cost and team expertise. Add a second datastore only when its workload advantage is clear and its ownership, synchronization, retention, and failure behavior are defined.

## Worked example

Orders and payments often benefit from relational constraints and transactions. A session cache may fit a key-value store. It is still one system with multiple operational owners, migrations, backups, security controls, and failure modes if the service uses both.

## Example constraint

~~~sql
CREATE UNIQUE INDEX ux_payment_key
ON payments(provider, idempotency_key);
~~~

A database-level unique constraint protects against concurrent duplicate requests; application checks alone cannot close the race.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Relational database | Relationships, joins, constraints, and transactions matter | Poor query/index design and hot shared tables can limit throughput |
| Document database | A cohesive aggregate is retrieved and updated together | Cross-document invariants and ad hoc joins need extra work |
| Key-value database | Access is mainly by known key with a predictable shape | New access patterns may require denormalized copies |
| Multiple database models | Workloads have distinct, proven needs | Each store adds migration, backup, security, monitoring, and sync costs |

## Common pitfalls

- Assuming NoSQL means no schema or validation.
- Picking a database because a company or conference recommends it.
- Adding too many indexes without considering write cost.
- Performing uniqueness checks only in application code.
- Using a replica as a backup.
- Declaring recovery ready without practicing restore.

## Short quiz

1. Which access pattern is a natural fit for a key-value store?
2. Why enforce uniqueness in the database as well as in code?
3. What costs come with adding a second datastore?
4. What does ACID not guarantee about application logic?

### Answer key

1. A simple lookup by a known key, such as a session or feature flag.
2. Concurrent requests can both pass an application check before either inserts; a unique constraint closes the race atomically.
3. Schema and migration ownership, backup/restore, security, monitoring, operations, and cross-store consistency.
4. It does not prove that the program’s business rules are correct; it defines transaction behavior within the database.

## Exercise

For a store, list the queries and invariants for products, carts, orders, payments, and inventory. Choose a primary datastore for each, define indexes and transactions, estimate growth, and describe backup, replica lag, and restore. Explain why any second database is justified.

## Summary

Select storage from data semantics, queries, transactions, freshness, and operational fit. A database choice is incomplete without indexes, migrations, failure behavior, and tested recovery.

## Further reading

- [AWS: Choosing a database on AWS](https://docs.aws.amazon.com/decision-guides/latest/decision-guides/databases-on-aws-how-to-choose.html) — compare managed database families by workload.
- [PostgreSQL documentation](https://www.postgresql.org/docs/current/) — relational constraints, transactions, queries, and replication.
- [MongoDB: Data modeling](https://www.mongodb.com/docs/manual/data-modeling/) — document structures and workload design.
- [Apache Cassandra architecture](https://cassandra.apache.org/doc/latest/cassandra/architecture/overview.html) — partitioning, replication, and consistency.
- [Amazon DynamoDB developer guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html) — key design and managed NoSQL behavior.
- [Redis documentation](https://redis.io/docs/latest/) — data structures, persistence, and caching.
