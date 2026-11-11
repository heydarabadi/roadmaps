<div dir="ltr" align="left">

# Redis Capstone Projects

These three projects connect separate lessons into end-to-end designs. Run mutating examples only in the local container from the [zero lesson](../00-start-here/README.en.md). You do not need to create a production service; the objective is to explain the data model, flow, failure behavior, and runbook.

> Persian edition: [پروژه‌های پایانی Redis](README.md)

## Suggested order

1. [Product cache](./01-product-cache/README.en.md): cache-aside, TTL, invalidation, misses, stale data, and stampedes.
2. [Order event processing](./02-order-stream/README.en.md): Streams, consumer groups, pending/acknowledgement, retry, deduplication, and retention.
3. [Production readiness](./03-production-readiness/README.en.md): security, durability, HA/DR, memory, telemetry, rollout, and incident drills.

## Project deliverable

For each project, create a one-page design with the workload, key schema, authoritative source, operation sequence, concurrency, failure modes, metrics, recovery, and trade-offs. Adapt the sample solution to your own hypothetical requirements. Copying commands without defining failure behavior does not complete a project.

## Lesson dependencies

| Project | Core lessons |
| --- | --- |
| Product cache | Strings, TTL, datastore choice, memory/eviction, monitoring |
| Order stream | Streams, transactions/Lua, ACLs, backup/retention |
| Production readiness | Persistence, replication/Sentinel/Cluster, security, latency, upgrade/DR |

## Completion criteria

- You can identify whether Redis is a cache, source of truth, event log, or part of a control/data plane in each design.
- You analyze data loss, duplicates, stale reads, and unavailability separately.
- You do not invent capacity or latency numbers; you list the missing benchmark inputs.
- You practice failures only in a lab or tabletop and check real restores in an isolated instance.

</div>

