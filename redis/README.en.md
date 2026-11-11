<div dir="ltr" align="left">

# Redis Learning Path — Persian course, English edition

This course is based on the [Redis roadmap on roadmap.sh](https://roadmap.sh/redis) and its [Redis roadmap PDF](https://roadmap.sh/pdfs/roadmaps/redis.pdf). The interactive webpage does not expose the full diagram as plain text, so the PDF is the reference for the topic list. This folder is an original, expanded course: it teaches the roadmap topics rather than reproducing the diagram.

> [Read the Persian edition](./README.md) · [English manifest](./MANIFEST.en.md) · [فهرست فارسی دوره](./MANIFEST.md)

## How to study

This collection is written for learning Redis from the beginning. The lessons contain the explanations needed for the core and intermediate topics; you do not need to read an outside course first. External links are supplements for command/version verification, further reading, and published case studies.

1. Complete the [zero lesson: local lab and study method](./00-start-here/README.en.md).
2. Study the three foundation lessons. Explain the difference between a cache, a database, and a broker in your own words.
3. Start Redis, connect with `redis-cli`, create a key, inspect its TTL, and clean up the lab.
4. Run each data-structure example and explain its output. Memorizing command names is not enough.
5. Study advanced features and production operations. For every feature, write down a failure mode and a monitoring signal.
6. Complete the three [capstone projects](./projects/README.en.md).
7. Review the [glossary](./GLOSSARY.en.md) and [command quick reference](./QUICK-REFERENCE.en.md).

Each lesson contains learning objectives, a step-by-step explanation, examples, practice, an answered quiz, and references. Try the quiz before opening its answers. Run commands only in the isolated lab from lesson zero.

## Learning path and exit criteria

- **Foundations:** explain what Redis is and why a system may place it beside a primary database.
- **Getting started:** start, connect to, inspect, and stop Redis; explain `SET`, `GET`, `TTL`, `TYPE`, `DEL`, and `SCAN`.
- **Data structures:** choose a type for a workload and justify the choice, common operations, and limitations.
- **Advanced features:** compare Pub/Sub, Streams, transactions, and Lua by delivery guarantees, atomicity, and cost.
- **Operations:** define persistence, memory, ACL/TLS, backup, restore, monitoring, RPO, and RTO for a workload.
- **Capstone:** design a small system end to end and explain a controlled failure scenario.

## Version and scope

Core examples target the Redis Open Source 8.x family. Redis 8.8 adds newer features such as Arrays and Streams NACK. A patch version or a managed service's feature set can change; version-sensitive lessons call this out. See the [official Redis 8.8 announcement](https://redis.io/blog/announcing-redis-8-8/). Always check the commands available on the actual endpoint you plan to use.

## Course map

| Chapter | Chapter guide (Persian / English) | English topic lessons |
| --- | --- | --- |
| 1. Foundations | [فارسی](./01-foundations/README.md) / [English](./01-foundations/README.en.md) | [Redis overview](./01-foundations/redis-overview/README.en.md) · [Use cases](./01-foundations/use-cases/README.en.md) · [Choosing a datastore](./01-foundations/choose-datastore/README.en.md) |
| 2. Getting started | [فارسی](./02-getting-started/README.md) / [English](./02-getting-started/README.en.md) | [Install and connect](./02-getting-started/install-run/README.en.md) · [CLI, keys, TTL](./02-getting-started/cli-keys-ttl/README.en.md) |
| 3. Core data structures | [فارسی](./03-core-data-structures/README.md) / [English](./03-core-data-structures/README.en.md) | [Strings and bitmaps](./03-core-data-structures/strings-bitmaps/README.en.md) · [Lists and queues](./03-core-data-structures/lists-queues/README.en.md) · [Sets](./03-core-data-structures/sets/README.en.md) · [Hashes](./03-core-data-structures/hashes/README.en.md) · [Sorted sets](./03-core-data-structures/sorted-sets/README.en.md) |
| 4. Advanced features | [فارسی](./04-advanced-features/README.md) / [English](./04-advanced-features/README.en.md) | [HyperLogLog](./04-advanced-features/hyperloglog/README.en.md) · [Streams](./04-advanced-features/streams/README.en.md) · [Geospatial](./04-advanced-features/geospatial/README.en.md) · [Transactions and WATCH](./04-advanced-features/transactions-watch/README.en.md) · [Lua and Functions](./04-advanced-features/lua-scripting/README.en.md) · [Pub/Sub](./04-advanced-features/pubsub/README.en.md) |
| 5. Persistence and recovery | [فارسی](./05-persistence-recovery/README.md) / [English](./05-persistence-recovery/README.en.md) | [Persistence modes](./05-persistence-recovery/persistence-modes/README.en.md) · [RDB](./05-persistence-recovery/rdb/README.en.md) · [AOF](./05-persistence-recovery/aof/README.en.md) · [Backup and restore](./05-persistence-recovery/backup-restore/README.en.md) |
| 6. Availability and scaling | [فارسی](./06-high-availability-scaling/README.md) / [English](./06-high-availability-scaling/README.en.md) | [Replication](./06-high-availability-scaling/replication/README.en.md) · [Sentinel](./06-high-availability-scaling/sentinel/README.en.md) · [Cluster](./06-high-availability-scaling/cluster/README.en.md) |
| 7. Security | [فارسی](./07-security/README.md) / [English](./07-security/README.en.md) | [ACL and authentication](./07-security/acl-auth/README.en.md) · [Network and TLS](./07-security/network-tls/README.en.md) |
| 8. Operations and performance | [فارسی](./08-operations-performance/README.md) / [English](./08-operations-performance/README.en.md) | [Memory and eviction](./08-operations-performance/memory-eviction/README.en.md) · [Latency and benchmarking](./08-operations-performance/latency-benchmark/README.en.md) · [Monitoring tools](./08-operations-performance/monitoring-tools/README.en.md) · [Configuration](./08-operations-performance/redis-conf/README.en.md) |
| 9. Production and Enterprise | [فارسی](./09-production-enterprise/README.md) / [English](./09-production-enterprise/README.en.md) | [Upgrade and DR](./09-production-enterprise/upgrade-dr/README.en.md) · [Product choice](./09-production-enterprise/enterprise/README.en.md) · [Active-Active and tiering](./09-production-enterprise/active-active-flash/README.en.md) |
| 10. Modern data types | [فارسی](./10-modern-data-types/README.md) / [English](./10-modern-data-types/README.en.md) | [Redis JSON](./10-modern-data-types/json/README.en.md) · [Time Series and probabilistic types](./10-modern-data-types/timeseries-probabilistic/README.en.md) · [Vector Sets and Arrays](./10-modern-data-types/vectors-arrays/README.en.md) |

## Capstone projects

- [Product cache with cache-aside](./projects/01-product-cache/README.en.md)
- [Order events with Streams](./projects/02-order-stream/README.en.md)
- [Production readiness and DR design](./projects/03-production-readiness/README.en.md)

## Selected published case studies

- [North American retail use case](https://redis.io/customers/retail-na/) — Redis-published story about caching and inventory events.
- [DBS Bank](https://aws.amazon.com/solutions/case-studies/dbs-bank-case-study/) — AWS-published story about ElastiCache for Redis in pricing workloads.
- [Etermax](https://redis.io/customers/etermax/) — Redis-published story about growth, autoscaling, and auto-sharding.
- [GitLab Redis latency investigation](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/) — engineering investigation into eviction-related latency.

These are vendor- or customer-published accounts, not guarantees for a different workload. Lessons label other scenarios as exercises unless a published source supports the claim.

## Persian references

The Persian edition contains Persian links alongside each lesson. Selected starting points include [DNTips's Redis overview (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf), [a Persian Redis guide from SalamLang](https://www.salamlang.ir/std/db/redis/), and Persian videos on [Strings and atomic increments](https://www.youtube.com/watch?v=e5Q_RUwviaE), [Pipelines and Lua](https://www.youtube.com/watch?v=m5j4YUvuUmc), and [Redis Streams](https://www.youtube.com/watch?v=_IcgS_NuV-k). Persian material for some newer data types is sparse; the course explains those concepts here and uses official English command references as supplements.

## Safety and practice

- Commands such as `FLUSHDB`, `FLUSHALL`, and runtime config or persistence changes can alter or destroy data. Use only the local lab.
- Never expose Redis directly to the public Internet.
- A laptop benchmark does not predict production capacity.
- For every chapter, write a small design: key schema, data type, TTL, eviction policy, persistence, failure behavior, backup, metrics, and trade-offs.
- Lab commands and sample outputs are educational material; no live Redis or production result is claimed.

</div>
