<div dir="ltr" align="left">

# Chapter 6 — Availability and Scaling

> Persian edition: [فصل ۶ — دسترس‌پذیری و مقیاس‌پذیری](../../../fa/redis/06-high-availability-scaling/README.md) · Suggested time: 4–6 hours.

These are three different problems: a replica copies data and can serve selected reads; Sentinel monitors and fails over a primary; Cluster shards data to scale horizontally.

## Lesson order

1. [Replication](replication/README.md): full/partial sync, replication ID and offset, lag, and asynchronous copying.
2. [Sentinel](sentinel/README.md): quorum, subjective/objective down, primary election, and client discovery.
3. [Cluster](cluster/README.md): 16,384 hash slots, shards, `MOVED`/`ASK`, hash tags, and multi-key constraints.

## Architecture model

Replication sends a change stream from a primary to replicas and is not inherently synchronous. Sentinel monitors and coordinates failover, then helps clients discover the new endpoint; Sentinel is not sharding. Cluster spreads data across hash slots owned by different nodes. Replicas of a shard can support failover.

```text
Replication: client -> primary ---- async changes ----> replica
Sentinel:    sentinels monitor primary/replicas -> elect/fail over -> client discovers primary
Cluster:     client -> node owning key's hash slot; slot ranges are split among shards
```

## Decisions to make

- Are stale reads from a replica acceptable? How will you observe replication lag?
- During primary failure, which writes may be lost? How does the client reconnect and refresh topology?
- Are Sentinel processes independent and in separate failure domains, with an appropriate quorum?
- Which keys must participate in multi-key atomic operations in Cluster? Can hash tags place them in the same slot?
- How do resharding and rebalancing affect latency, connection pools, and deploys?
- Where are backups and cross-region disaster recovery? HA does not replace backups.

## Design exercise

Imagine one primary and two replicas. Now isolate the primary from the network: Who detects the failure? Who elects a new primary? How does the application discover the endpoint? Is the latest acknowledged write guaranteed to exist on a replica? Then consider three Cluster shards: why might `MGET keyA keyB` require both keys to share a slot? Explain using the [Cluster lesson](./cluster/README.en.md).

## Review quiz

1. Does a replica synchronously receive every primary write?
2. Does Sentinel shard data?
3. How does Sentinel quorum relate to the number of monitoring processes?
4. When is a Cluster hash tag needed?

<details><summary>Answer guide</summary>

Replication is usually asynchronous, so a replica can lag. Sentinel provides monitoring, failover, and discovery rather than sharding. Quorum determines how many monitors must agree for a down decision/action; majority and failure-domain availability must also be designed. A hash tag maps related keys to the same slot for multi-key operations but can create a hot slot if used too broadly.

</details>

## Further reading

- [Redis replication](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/)
- [Redis Sentinel](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/)
- [Redis Cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/)
- [Redis Cluster scaling](https://redis.io/docs/latest/operate/oss_and_stack/management/scaling/)
- [Persian article on replication and Cluster](https://azarsys.com/blog/setup-redis-replication-cluster/)

</div>
