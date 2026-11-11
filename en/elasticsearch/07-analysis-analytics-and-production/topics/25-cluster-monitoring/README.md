# Cluster Monitoring

> Chapter 07: Analysis, Analytics, and Production · Lesson 25

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/25-cluster-monitoring/README.md)

## Learning goals

- Monitor user-facing service indicators and cluster resource signals.
- Distinguish allocation health from latency and correctness.
- Build alerts from SLOs and baselines rather than arbitrary thresholds.

## Observe trends, not isolated states

Cluster monitoring should cover user-visible latency and errors as well as cluster internals. Track p95/p99 search latency, timeout and shard-failure rates, indexing throughput and rejections, JVM heap and garbage collection, disk watermarks, shard allocation and relocation, snapshot age and success, transform lag, and CCR lag when used. A green cluster health status means shard copies are allocated; it does not guarantee the application is fast or returning useful results.

~~~http
GET /_cluster/health
GET /_nodes/stats/jvm,fs,thread_pool,indices
~~~

Use CAT APIs for rapid human triage, but collect metrics in a time-series monitoring system for trends and alerting. Set thresholds from service SLOs and normal workload baselines. Correlate load, deploys, data growth, and shard changes to find causes rather than immediately increasing hardware.

## Exercise

Create a simple dashboard with search p95, errors, rejected thread-pool tasks, heap, disk use, shard allocation, and snapshot age. Define one alert that pages and one that creates a lower-priority ticket. Explain why a green health check is not enough.

## Quiz with answers

1. **Does green health mean users experience low latency?** No; it summarizes shard allocation rather than end-to-end performance.
2. **Name four useful operational metrics.** Search latency, errors, rejections, heap/GC, disk, shard movement, throughput, or backup freshness.
3. **Why collect trends?** A single snapshot cannot show growth, saturation, or regression over time.
4. **How should alert thresholds be chosen?** From SLOs, baselines, and operational impact.

## References and further reading

- [Monitor a cluster](https://www.elastic.co/docs/deploy-manage/monitor) — monitoring options.
- [Stack Monitoring](https://www.elastic.co/docs/explore-analyze/monitor/stack-monitoring) — Kibana monitoring views.
- [Cluster health API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-health) — allocation status.
- [Node stats API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-nodes-stats) — JVM, filesystem, thread pools, and index metrics.
- [Production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance) — reliability and performance operations.
- Persian discovery search (not a verified article): [Persian Elasticsearch monitoring tutorials](https://www.google.com/search?q=Elasticsearch+monitoring+%D9%BE%D8%A7%DB%8C%D8%B4+%DA%A9%D9%84%D8%A7%D8%B3%D8%AA%D8%B1+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

