<div dir="ltr" align="left">

# Self-Managed Redis, Managed Services, and Redis Enterprise

> Path: Chapter 9 · Level: advanced · Lesson and worksheet: 75–110 minutes
>
> Features, versions, service levels, prices, and license terms change. This lesson provides a decision method, not a quote or legal advice.

> Persian edition: [Redis OSS، Managed Redis و Redis Enterprise: انتخاب محصول](../../../../fa/redis/09-production-enterprise/enterprise/README.md)

## Learning objectives

- Compare self-managed Redis, managed Redis services, Redis Software, and Redis Cloud by responsibility and feature availability.
- Build a requirements matrix for commands, data types, high availability, disaster recovery, security, residency, and backups.
- Estimate total cost of ownership (TCO) beyond the advertised node price.
- Read a vendor-published customer story as contextual evidence rather than a general guarantee.
- Plan compatibility, migration, portability, and a credible exit path.

## Start with the workload

Do not select a product from a feature checklist alone. Write down:

1. Availability objective, RPO, RTO, and the consequence of a stale or lost write.
2. Dataset size, growth, working-set ratio, peak throughput, latency percentiles, and burst pattern.
3. Required topology: one primary, replicas, Sentinel, sharding, multi-zone, multi-region, or active-active writes.
4. Required Redis commands, data types, client libraries, scripting/functions, and protocols.
5. Security controls: private networking, TLS, ACLs, encryption at rest, audit trail, identity, and secret rotation.
6. Backup retention, restore regions, restore testing, incident support, and escalation time.
7. Data residency, compliance, contractual guarantees, and who can access the data.
8. Team skill, on-call coverage, planned maintenance, and provider exit cost.

## Responsibility model

| Area | Self-managed Redis | Managed Redis service | Application team always retains |
| --- | --- | --- | --- |
| Installation and infrastructure patches | Platform team | Provider usually handles some layers | Client compatibility and rollout |
| Network, TLS, ACL, and secrets | Platform team | Service exposes settings/primitives | Permission model and secret lifecycle |
| High availability and failover | Team designs and operates it | Provider may automate parts | Retry, idempotency, and stale-read behavior |
| Backup and restore | Team builds and runs process | Feature/retention depend on service and plan | Restore validation and business correctness |
| Scaling and resharding | Team owns capacity and procedure | API or console may automate steps | Hot-key design and application load tests |
| Monitoring and incident response | Team supplies the full stack | Provider supplies some metrics/support | Business SLI and end-to-end diagnosis |

“Managed” changes who operates infrastructure. It does not transfer ownership of data semantics, authorization, key design, application correctness, or incident decisions.

Redis Open Source 8 integrates a number of capabilities previously distributed across Redis Stack modules. Older versions and different managed offerings may expose a different command surface. Always validate the exact database version, service plan, and required commands. A passing PING proves connectivity; it does not prove compatibility.

## Compare total cost of ownership

For a 12–36 month horizon, model:

~~~text
TCO = service or license
    + compute, RAM, flash, storage, and replicas
    + network, cross-zone traffic, and egress
    + backups, retention, and DR region
    + observability, security, and support tools
    + engineering and on-call time
    + migration, upgrades, compatibility tests, and exit
    + expected operational and outage cost
~~~

Price depends on dataset, replication, persistence, multi-region design, network traffic, retention, support tier, and plan limits. Compare a provider quote using the same workload and failure assumptions. Include traffic egress, support response, and backup restore costs rather than relying on a simple per-node price.

## Compatibility matrix before commitment

Run a small, repeatable matrix against the real candidate service:

- Every command, data type, module, search/vector path, and associated ACL permission.
- Client protocol, TLS, authentication, Sentinel/Cluster redirects, and DNS behavior.
- Multi-key operations, transactions, Lua or Functions, and slot constraints.
- Backup, restore, persistence, and data migration from the current version.
- Failover and retry behavior, including duplicates and stale reads.
- Payload/key limits, connections, per-shard limits, and rate or quota controls.
- Metrics export, audit logs, private endpoints, and credential rotation.

Keep this matrix in CI or a provider acceptance job. Repeat it after version, plan, or client-library changes.

## Vendor-published case study: Ekata

Redis’s Ekata customer story describes an identity-verification workload that evaluated multiple data stores and selected Redis Enterprise for latency-sensitive graph/query needs. It is a case study published by the vendor, so its environment, measurements, and selection criteria are not an independent benchmark or a guarantee for another workload. Use it to generate questions; validate your own data shape and contract. [Ekata customer story](https://redis.io/customers/ekata/)

## Portability and risk register

| Risk | Mitigation |
| --- | --- |
| Required command exists only in a certain edition or version | Maintain a required-command matrix, version pin, and fallback |
| Region or provider outage | Document traffic routing, restore point, and regional recovery procedure |
| Proprietary feature creates lock-in | Define export format, read/write migration plan, and exit exercise |
| Compatibility drifts after an upgrade | Run integration tests against a production-like endpoint |
| Cost rises unexpectedly | Add usage alerts and quotas; measure retention and egress |
| Operational incident lacks an owner | Name primary/backup operators and practice escalation |
| Backups exist but cannot be loaded elsewhere | Test a portable artifact in a separate destination |

## Decision exercise

Compare three hypothetical choices for a product cache plus order event Streams: self-managed Redis OSS, a cloud-managed Redis service, and a Redis Enterprise multi-region deployment. Fill in requirements for availability, data semantics, required commands, owner, recovery, security, cost, and exit.

Create a weighted score only after the product and application teams agree on requirement priorities. A score does not make assumptions true: attach the compatibility test or contract evidence behind each high-weight score.

**Answer guide:** The right answer depends on the workload. A defensible decision identifies the required consistency model, validated command support, who restores data, how application retries behave, what the full cost includes, and how to migrate away.

## Common traps

- Treating a feature page as a contract: verify plan limits, regions, availability, support, and terms.
- Assuming a managed service removes on-call: application failures and recovery decisions remain.
- Treating Redis OSS 8 as identical to a Redis 7 Stack deployment: confirm the exact version and command surface.
- Testing only connectivity after migration: exercise routing, ACL, TLS, data restore, and failure behavior.
- Treating a vendor case as an independent benchmark: retain its source and deployment context.
- Planning no exit: test data export, client compatibility, serialization, and rebuild time before lock-in matters.

## Quiz

### 1. Which responsibilities remain with the application team on a managed service?

<details><summary>Answer</summary>

Data model, key and permission design, retry/idempotency, application correctness, and end-to-end recovery validation.

</details>

### 2. Why does Redis 8 matter in a product comparison?

<details><summary>Answer</summary>

Several Stack capabilities are integrated in Redis Open Source 8, while older releases or managed products can differ in versions and exposed commands.

</details>

### 3. What belongs in TCO?

<details><summary>Answer</summary>

Service/compute, replicas, networking, backup and DR, security/observability, support, on-call, upgrades, migration, and expected operational risk.

</details>

### 4. Does PING prove a service is compatible?

<details><summary>Answer</summary>

No. Test required commands, permissions, client routing, TLS, persistence/restore, quotas, and failure behavior.

</details>

### 5. How should you use a vendor-published customer story?

<details><summary>Answer</summary>

As contextual evidence about one deployment and a source of design questions, not a universal performance guarantee.

</details>

### 6. What makes an exit plan credible?

<details><summary>Answer</summary>

A tested export/rebuild path, target compatibility, client changes, migration procedure, reconciliation, and measured cutover time.

</details>

## References and further reading

### English: official and engineering sources

- [Redis product and operations documentation](https://redis.io/docs/latest/operate/) — product families and operational documentation.
- [Redis Stack with Redis Enterprise](https://redis.io/docs/latest/operate/oss_and_stack/stack-with-enterprise/) — product and feature context.
- [Redis Open Source 8.0 release notes](https://redis.io/docs/latest/operate/oss_and_stack/stack-with-enterprise/release-notes/redisce/redisos-8.0-release-notes/) — version-specific feature changes.
- [Redis license information](https://redis.io/legal/licenses/) — inspect the license applicable to the exact release and component.
- [Redis AGPLv3 announcement](https://redis.io/blog/agplv3/) — background on a license change; not a substitute for checking the release’s actual license files.
- [Redis Cloud pricing](https://redis.io/pricing/) — current published plans/pricing; recalculate for your workload and region.
- [Ekata customer story](https://redis.io/customers/ekata/) — vendor-published customer experience.
- [Redis customer stories](https://redis.io/customers/) — additional first-party case studies; treat them as selected customer examples.

### فارسی

- [آموزش فارسی Redis در SalamLang](https://www.salamlang.ir/std/db/redis/) — مبانی Redis.
- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf) — مرور ساختارها و مفاهیم.
- [جست‌وجوی فارسی مقایسه Redis OSS و Managed Redis](https://www.google.com/search?q=Redis+OSS+Managed+Redis+مقایسه+فارسی)
- [جست‌وجوی فارسی Redis Enterprise و Redis Cloud](https://www.google.com/search?q=آموزش+فارسی+Redis+Enterprise+Redis+Cloud)
- [جست‌وجوی فارسی مجوز Redis 8 و AGPL](https://www.google.com/search?q=مجوز+Redis+8+AGPL+فارسی)

منابع فارسی برای قیمت‌گذاری، قرارداد، مجوز و تفاوت دقیق editionها محدود و زودقدیمی‌شونده‌اند. نسخهٔ مجوز، plan و contract را برای محصول مشخص و در زمان تصمیم بخوان؛ برای تصمیم تجاری حقوقی از مشاور حقوقی سازمان کمک بگیر.

</div>

