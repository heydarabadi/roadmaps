<div dir="ltr" align="left">

# Redis Glossary

> Persian edition: [واژه‌نامهٔ Redis](GLOSSARY.md)

This glossary gives the course a shared vocabulary. Redis command and product names remain in their canonical form so you can recognize them in logs, errors, and documentation.

| Term | Meaning in this course |
| --- | --- |
| Key | The name used to locate a value or structure in Redis. |
| Value | Data stored under a key; it may be a string, hash, list, or another type. |
| Data type / data structure | The shape of a value and the operations available for it, such as a Set or Sorted Set. |
| Keyspace | The full collection of keys in a logical Redis database. |
| TTL | Time remaining before a key or supported field expires. |
| Expiration | Policy for removing a key or supported field after a time limit. |
| Atomic operation | A command Redis completes before executing the next command, so another client does not observe an intermediate state. |
| Round trip | One request and response between an application and Redis. |
| Pipeline | Sending multiple commands in a batch to reduce round trips; a pipeline is not automatically a transaction. |
| Transaction | A group of queued commands executed by Redis without interleaving from other clients; it does not provide SQL-style rollback. |
| Optimistic locking | A strategy that uses WATCH to detect a concurrent change and abort a transaction attempt on conflict. |
| Cache-aside | The application checks the cache first, reads the source of truth on a miss, and then fills the cache. |
| Cache miss | The requested value is absent from the cache, so the application must fetch or compute it elsewhere. |
| Cache stampede | Many simultaneous misses send a burst of requests to the source system. |
| Invalidation | Marking cached data stale or removing it when the authoritative value changes. |
| Persistence | Saving Redis data to disk so it can be loaded after a restart. |
| RDB | A point-in-time snapshot of a Redis dataset in a file. |
| AOF | A log of write operations that can be replayed to rebuild state. |
| RPO | The greatest amount or time range of data loss the business accepts. |
| RTO | Target time to restore the service after a failure. |
| Replication | Copying primary changes to replicas; Redis replication is generally asynchronous. |
| Replication lag | The time or amount of change by which a replica trails its primary. |
| Failover | Promoting another node to primary after failure or an operator action. |
| Sentinel | Monitoring and failover for Redis deployments without sharding. |
| Redis Cluster | Distributing keys across shards and hash slots for horizontal scaling and availability. |
| Hash slot | One of 16,384 logical positions to which Redis Cluster maps keys. |
| Hash tag | The portion inside braces in a key name, used to place related keys in the same Cluster slot. |
| ACL | Access-control rules for users, commands, and key patterns. |
| TLS | Encryption and authentication for a network channel; TLS does not replace ACLs. |
| maxmemory | A limit on memory Redis may use for its dataset. |
| Eviction | Removing keys under memory pressure according to a selected policy. |
| LRU / LFU | Approximate least-recently-used / least-frequently-used policies. |
| Latency | Response time; production systems should measure percentiles such as p95 and p99. |
| Throughput | Operations completed per unit of time. |
| Slow log | Records commands whose server-side execution exceeded a configured threshold. |
| Pub/Sub | Live message delivery to connected subscribers; offline messages are not stored for replay. |
| Stream | An ordered event log with IDs that can support replay and consumer groups. |
| Consumer group | Stream workers that divide entries and track pending deliveries. |
| PEL | Pending Entries List: messages delivered but not yet acknowledged in a Stream group. |
| Acknowledgement / ACK | Confirmation that processing succeeded; Streams use XACK. |
| Idempotency | Repeating the same request does not create an unintended duplicate effect. |
| Probabilistic data structure | A compact structure that returns approximate answers with measurable error. |
| Cardinality | Number of distinct elements in a set. |
| Vector embedding | Numeric representation used for similarity search; numeric similarity alone does not guarantee relevance. |
| Edition / managed service | A product version or hosted service with a different feature set and operational responsibility model. |
| Strong eventual consistency | A convergence property: replicas eventually reach a common state after updates stop and changes are exchanged. It does not mean every replica has the latest write at every instant. |
| CRDT | Conflict-free replicated data type: a data type with defined merge behavior for distributed updates. |
| Downsampling | Replacing or supplementing detailed measurements with coarser time buckets. |
| Bloom filter | Approximate membership structure: a negative says absent; a positive may be a false positive. |
| Count-Min Sketch | Compact frequency estimator that can overestimate due to hash collisions. |
| HNSW | Graph-based approximate nearest-neighbor indexing method. |
| Recall@k | Fraction of the true top-k relevant/nearest results included in the search results. |
| Sparse array | Array with empty index positions; logical length can exceed the number of populated slots. |
| Ring buffer | Fixed-capacity circular buffer that reuses or overwrites old positions as new entries arrive. |

</div>


