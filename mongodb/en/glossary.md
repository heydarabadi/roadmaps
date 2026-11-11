# MongoDB Glossary

> **Persian edition:** [Read the Persian version](../glossary.md).

| Term | Plain-language definition |
|---|---|
| Acknowledgment | Server response confirming a write at the level requested by write concern. |
| Aggregation | Processing documents through an ordered pipeline of stages. |
| Analyzer | Text transformation used when indexing and searching terms. |
| Atomicity | An indivisible change; the basic MongoDB write is atomic at the single-document level. |
| Atlas | MongoDB's managed cloud database service. |
| BSON | Binary document representation with more types than JSON. |
| BSON type | The stored type of a value, such as Date or Decimal128. |
| Collection | Logical group of related documents. |
| Compound index | An index over multiple fields in a meaningful order. |
| Connection pool | Reusable server connections maintained by a driver. |
| Consistency | How closely reads agree with committed data across members and operations. |
| Cursor | A batched iterator over query results. |
| Database | A namespace used to organize collections. |
| Denormalization | Controlled duplication of data to simplify or accelerate reads. |
| Document | MongoDB record made of fields, values, nested documents, and arrays. |
| Driver | Official language library connecting application code to MongoDB. |
| Election | Process that selects a new replica-set primary. |
| Embedding | Placing related data inside a parent document. |
| Execution plan | Steps the query planner chooses to execute a query. |
| Explain | Report showing a query plan and execution statistics. |
| Field | Name/value pair inside a document. |
| Filter | Conditions selecting documents for a read or write operation. |
| Idempotency | Repeating an operation without repeating its final business effect. |
| Index | Auxiliary structure that can speed searches at storage and write cost. |
| Journaling | Recording changes to support recovery, depending on configuration. |
| Keyset pagination | Pagination using the last sort key instead of a large offset. |
| Majority | Majority of members as defined by topology; used in concerns and commit behavior. |
| Mapping | Definition of fields and types for a search index. |
| `mongod` | MongoDB database server process. |
| `mongosh` | Interactive shell for commands and scripts. |
| `mongos` | Router that directs requests in a sharded cluster. |
| Multikey index | Index on an array field. |
| Oplog | Record of replica-set operations used to replicate changes. |
| Projection | Restriction or shaping of fields returned by a query. |
| Query planner | Server component that selects a query execution plan. |
| Read concern | Consistency/visibility level requested for a read. |
| Read preference | Selection of primary or secondary members for a read. |
| Reference | Identifier pointing from one document to related data elsewhere. |
| Replica set | Group of `mongod` members providing replication and failover. |
| RPO | Maximum acceptable recovery-point/data-loss window. |
| RTO | Target time to restore service after an incident. |
| Schema | Rules for data structure, types, and relationships. |
| Schema validation | Server-side checks on document shape during writes. |
| Shard | Data-bearing part of a sharded cluster. |
| Shard key | Field or fields that guide shard distribution and query routing. |
| Snapshot | Consistent view of data at a point in time. |
| Stage | One transformation step in an aggregation pipeline. |
| TTL index | Index used to delete documents after a configured time. |
| Transaction | Commit/abort boundary for related database operations. |
| Write concern | Level of acknowledgment requested for a write. |
| Write throughput | Number of writes completed per unit of time. |
