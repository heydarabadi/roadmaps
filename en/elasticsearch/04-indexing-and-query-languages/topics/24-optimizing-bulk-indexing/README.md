# Optimizing Bulk Indexing

> Chapter 04: Indexing and Query Languages · Lesson 24

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/24-optimizing-bulk-indexing/README.md)

## Learning goals

- Tune bulk size and concurrency through measurement rather than a universal guess.
- Recognize backpressure from rejections, latency, heap, and I/O.
- Make temporary refresh or replica changes only with a controlled restore plan.

## Tune against the real bottleneck

Bulk indexing performance depends on request size, document shape, mappings, shard layout, refresh frequency, storage, and concurrent workers. Start with modest batches and increase gradually while measuring throughput, request latency, memory pressure, disk I/O, merges, and 429 rejections. Very large requests can consume memory and increase timeouts; one worker may fail to use available cluster capacity, while too many can overload a shard.

~~~http
PUT /products-v1/_settings
{"index":{"refresh_interval":"30s"}}
~~~

During a controlled initial load, a longer refresh interval can reduce refresh overhead. Restore the intended setting afterward and wait for normal search visibility. Changing replicas during bulk loading affects resilience and must be planned with capacity and recovery. Do not disable safety settings blindly. Use client bulk helpers where they handle chunking, retries, and backoff, but still inspect errors.

If the cluster returns 429, reduce concurrency or pause and retry with exponential backoff and jitter. Keep a cap on retries and a dead-letter path for permanent failures. Benchmark with representative data and query load, not just an empty index on a developer laptop.

## Exercise

Test a sequence of small to larger bulk payloads and one to several workers in a disposable environment. Record documents per second, p95 latency, rejection count, heap, disk throughput, and merge activity. Choose a stable operating point rather than the single highest short-lived throughput.

## Quiz with answers

1. **How do you choose a bulk size?** Benchmark representative payloads and increase gradually until throughput stops improving or pressure rises.
2. **What does a 429 response tell you?** The cluster is applying backpressure or cannot keep up; uncontrolled retries will make pressure worse.
3. **When may refresh interval be raised?** During a controlled bulk load when delayed search visibility is acceptable, with a plan to restore the normal setting.
4. **Why not choose the highest momentary throughput?** It may coincide with unstable latency, memory pressure, rejections, or recovery risks.

## References and further reading

- [Tune for indexing speed](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/indexing-speed) — batch sizing, workers, and backoff.
- [Bulk API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk) — per-item handling and request options.
- [Refresh parameter](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/refresh-parameter) — refresh cost and visibility controls.
- [Shard sizing](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/size-shards) — index layout affects ingest throughput.
- [Go bulk indexing example](https://www.elastic.co/docs/reference/elasticsearch/clients/go/using-the-api/bulk-indexing) — client helper and flushing patterns.
- [Anyone.com customer story](https://www.elastic.co/customers/anyone) — a production migration example, with vendor-reported results.
- Persian discovery search (not a verified article): [Persian Elasticsearch bulk performance articles](https://www.google.com/search?q=Elasticsearch+bulk+performance+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

