<div dir="ltr" align="left">

# Chapter 9 — Production Readiness and Redis Products

> Persian edition: [فصل ۹ — آمادگی Production و محصولات Redis](./README.md) · Suggested time: 3–5 hours plus a tabletop exercise.

This final chapter plans operations around failures and product boundaries. Community edition, managed services, and Enterprise are not identical.

## Lessons

1. [Upgrade and disaster recovery](./upgrade-dr/README.en.md): upgrade plan, backups, failover, restore, RPO/RTO, and drills.
2. [Redis product selection](./enterprise/README.en.md): OSS, managed, support, SLA, cost, and compatibility.
3. [Active-Active and Flash/Flex](./active-active-flash/README.en.md): multi-region replication, conflicts, and product-specific tiering constraints.

## Production design review

For each workload, write down:

1. **Data:** source of truth, key pattern, size, and growth.
2. **Performance:** p95/p99 target, query mix, peak QPS, payload, and benchmark dataset.
3. **Failure:** behavior during Redis outage, region loss, split brain, restart, and restore.
4. **Durability:** RPO/RTO, RDB/AOF/backup, off-site copy, and restore drill.
5. **Access:** per-service ACL, TLS/network boundary, secret rotation, and audit.
6. **Operations:** metrics, alerts, incident owner, capacity review, patch/upgrade, and rollback.
7. **Cost/vendor:** RAM, replicas, backups, network, egress, support, lock-in, and export path.

## HA versus DR

HA reduces downtime after a node or zone failure within a deployment. DR tests recovery from a larger failure domain or region/data loss. Replication can also copy a bad write or deletion, so independent backups matter. Active-Active does not imply globally linearizable consistency: inspect conflict resolution, replication delay, partition behavior, and feature compatibility.

## Tabletop exercise

Announce: “The primary region is unavailable, and the latest change was not on its replica.” In order, write the failover path, client endpoint discovery, RPO decision, write validation, recovery of the original region, prevention of dual writers, and data checks. Make it harder: the backup file is wrong or the ACL is invalid. The runbook should tell an operator the next action without guessing.

## Final readiness criteria

You can explain the architecture on one page; name each component's failure and recovery modes; state the trade-offs among cost, latency, and durability; rehearse restore; and label vendor benchmarks and published case studies accurately.

## Further reading

- [Redis products](https://redis.io/products/)
- [Redis upgrades](https://redis.io/docs/latest/operate/oss_and_stack/management/upgrade/)
- [GitLab Geo architecture](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)
- Topic-specific published customer reports are linked in the relevant lessons.
- [Cloudflare's configuration rollout postmortem](https://blog.cloudflare.com/code-orange-fail-small-complete/) — a configuration-safety lesson from another service, not a Redis incident.

</div>
