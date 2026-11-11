# Cross-Cluster Replication (CCR)

> Chapter 07: Analysis, Analytics, and Production · Lesson 26

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/26-cross-cluster-replication/README.md)

## Learning goals

- Explain the leader/follower model across Elasticsearch clusters.
- Identify useful cases such as regional read copies or a recovery target.
- Distinguish CCR from local replicas and snapshots.

## Replicate across clusters

Cross-cluster replication copies changes from a leader index in one cluster to a follower index in another. It can support local reads, geographic distribution, or a recovery architecture. Replication is asynchronous, so the follower may lag behind. Cross-cluster connectivity, security credentials, compatibility, and supported deployment features must be configured.

~~~http
GET /_ccr/stats
~~~

Monitor follower status and lag, especially during network disruption. Define which cluster is authoritative, how promotion occurs, and how clients switch reads or writes during a failover. CCR is not the same as a local replica shard, which protects a copy within one cluster, and it is not the same as a snapshot, which is a recoverable backup. Use snapshots and restore drills for backup requirements even when CCR exists.

## Exercise

Document a two-cluster design with one leader and one follower. Define acceptable replication lag, failure detection, promotion, failback, access privileges, and snapshot strategy. Test network interruption in a controlled environment and record recovery behavior.

## Quiz with answers

1. **What does CCR replicate?** A leader index's changes to a follower index in another cluster.
2. **Is replication synchronous?** It is asynchronous, so the follower can lag.
3. **Does CCR replace snapshots?** No; snapshots provide a distinct backup and restore mechanism.
4. **What is needed for disaster recovery?** A tested promotion and recovery plan, lag objectives, connectivity/security, and independent snapshots.

## References and further reading

- [Cross-cluster replication](https://www.elastic.co/docs/deploy-manage/tools/cross-cluster-replication) — setup and operation.
- [CCR APIs](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-ccr) — follower management and stats.
- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) — independent backup plan.
- [Production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance) — resilient cluster operations.
- [CCR stats API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ccr-stats) — replication status.
- Persian discovery search (not a verified article): [Persian Elasticsearch CCR tutorials](https://www.google.com/search?q=Elasticsearch+CCR+cross+cluster+replication+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

