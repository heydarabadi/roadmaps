# Autoscaling

> Chapter 07: Analysis, Analytics, and Production · Lesson 27

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/27-autoscaling/README.md)

## Learning goals

- Understand autoscaling as a deployment-dependent capacity mechanism.
- Identify scaling limits, triggers, and relocation effects.
- Diagnose workload or query problems before adding resources.

## Adjust capacity with guardrails

Autoscaling can increase or decrease capacity based on workload and platform constraints. Availability, triggers, minimum and maximum capacity, and scale timing depend on whether the cluster is self-managed, hosted, or serverless and on the relevant version. Scaling may trigger shard relocation, cache warm-up, and rebalance work, so it may not immediately reduce latency.

~~~http
GET /_cluster/allocation/explain
~~~

Use allocation explanations and node statistics to understand why shards are not moving or why capacity is constrained. Storage growth and CPU-heavy search are different bottlenecks; scaling one resource may not fix the other. Autoscaling can make an inefficient query or oversized shard more expensive without correcting the design. Set budgets, monitor scale actions, and test behavior under realistic load.

## Exercise

Create two scenarios: disk utilization is approaching a limit, and search CPU is saturated while disk is healthy. For each, identify which capacity dimension should change, what might happen during scale-up, and what query or mapping investigation should accompany it.

## Quiz with answers

1. **What does autoscaling do?** Adjusts capacity according to supported metrics and policy constraints.
2. **Does it fix every performance issue?** No; bad queries, hot shards, and poor mappings may remain.
3. **Why can scaling take time to help?** Shards may need to move and caches warm up.
4. **What should be defined before enabling autoscaling?** Supported platform behavior, limits, triggers, budget, monitoring, and scale-down risks.

## References and further reading

- [Elastic autoscaling](https://www.elastic.co/docs/deploy-manage/autoscaling) — supported deployment and scaling behavior.
- [Shard allocation explain](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-allocation-explain) — diagnose allocation decisions.
- [Shard sizing](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/size-shards) — capacity before and after scaling.
- [Elastic Cloud deployment types](https://www.elastic.co/docs/deploy-manage/deploy/elastic-cloud/choosing-your-deployment-type) — platform differences.
- Persian discovery search (not a verified article): [Persian Elasticsearch autoscaling articles](https://www.google.com/search?q=Elasticsearch+autoscaling+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

