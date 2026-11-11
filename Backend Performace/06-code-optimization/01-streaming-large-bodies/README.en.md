# 6.1 — Streaming Large Bodies

**Language:** English | [فارسی](README.md)

Streaming reads, transforms, and delivers data incrementally instead of constructing the entire body before continuing. It can lower peak memory and time to first chunk. Total transfer time still depends on the producer, network, and consumer.

**Learning goal:** distinguish buffering from streaming, apply backpressure across the whole pipeline, design for mid-response errors and cancellation, and estimate memory across concurrent transfers. Sources reviewed: **2026-11-10**.

## Prerequisites defined here

The HTTP body is the content bytes sent or received after the headers. I/O means reading or writing a resource such as a file, network connection, or database; it can be slower than CPU work. A buffer is temporary storage for data. With full buffering, the complete output is built before delivery; with streaming, chunks move through stages incrementally. **Backpressure** means a producer pauses when the next stage cannot accept more data, so a queue does not grow without limit.

## Mental model and stages

| Stage | Responsibility | Required bound |
| --- | --- | --- |
| Source: file, cursor, or upload | Produces data incrementally | Total bytes, record size, and time |
| Transform: parse, compress, encode | Retains only necessary state between chunks | Transform buffer and memory |
| Destination: socket or storage | Accepts data at a limited rate | Output queue and concurrent transfer count |

When the destination is slow, the producer must pause. An unbounded queue between stages does not make streaming memory-bounded. [MDN's Streams overview](https://developer.mozilla.org/en-US/docs/Web/API/Streams_API/Concepts) is supplemental background on queues and backpressure.

1. Check authorization, parameters, and whether the source can be opened before starting; after headers are sent, the status code usually cannot be changed.
2. Choose a format that can be consumed incrementally, such as a binary file or NDJSON with one record per line. A network chunk is not necessarily a complete record or UTF-8 character.
3. Read only up to the next stage's capacity. Include library, compressor, and proxy buffers in the memory budget.
4. On consumer disconnect, deadline, or transform error, cancel source reads and related work, then release resources.
5. Distinguish successful completion from a truncated transfer. Resumable exports need a separate contract for identifiers/checksums or resume behavior.

## Worked example: an instructional export

Assume the final file is **1 GiB**. Collecting the entire body requires memory on the order of the full body size; temporary copies and parsed objects can require more. In a hypothetical pipeline with three buffers capped at 64 KiB each, the in-flight data budget is about 192 KiB per transfer. For 100 transfers, that component is about 18.75 MiB. This is **not the process's total RSS**; cursor, connection, and runtime capacity must be counted separately.

~~~text
authorize(request)
source = open_incremental_source(request)
try:
    while not source.finished:
        check_deadline_and_cancellation()
        chunk = source.read_at_most(64_KiB)
        transformed = transform_incrementally(chunk)
        await sink.write_with_backpressure(transformed)
    await sink.write_with_backpressure(transform.finish())
    await sink.finish()
except error:
    sink.abort(error)
    raise
finally:
    source.close()
~~~

This pseudocode describes a behavior contract, not a particular language API; <code>transform</code> must also keep its output bounded. A small compressed file can expand dramatically, so cap decompressed bytes too. If a database source first builds a list containing every row, streaming at the socket does not solve the upstream memory problem.

## When it fits and what it costs

Streaming fits large downloads/uploads, exports, and consumers that can process data incrementally. For small JSON that must be validated completely before delivery, bounded buffering may be simpler. Streaming keeps a connection and sometimes a cursor open longer; a very slow client can occupy resources. A proxy or middleware can buffer the whole response and erase the time-to-first-byte benefit, so measure through to the real client. Flushing every byte also adds overhead; tune chunk size and flush behavior under representative load.

## Exercise with worked solution

Model a 100 MiB source at 20 MiB/s feeding a destination at 2 MiB/s. In the first five seconds, an unbounded queue falls behind by about 90 MiB. Then cap total buffers at 1 MiB and pause the producer when full.

**Solution:** the rate difference is <span dir="ltr">20 − 2 = 18 MiB/s</span>; after five seconds, <span dir="ltr">18 × 5 = 90 MiB</span> is queued. With a 1 MiB buffer, the producer must pause after it fills and proceed roughly at the destination's rate. The lower bound on total transfer time is <span dir="ltr">100 ÷ 2 = 50</span> seconds because the destination is the slowest stage. If the destination disconnects in the third second, source reading should stop. This is a calculation, not a measured throughput test.

## Operational evidence and its limits

**Operational guide with an experiment:** the official [Node.js guide to backpressure in streams](https://nodejs.org/en/learn/modules/backpressuring-in-streams) demonstrates how ignoring <code>write()</code>'s result affects memory and garbage collection. Its results apply to the program and environment in that article; its percentages are not universal across runtimes. It is a documented experiment with a real tool, not a report about a named product deployment. No directly comparable production study for this lesson's export scenario was identified; the example numbers are hypothetical.

## Failures and operational signals

| Failure | Signal | What to inspect next |
| --- | --- | --- |
| Ignored backpressure | RSS grows with slow clients | Bound every queue in the chain |
| Parser assumes chunk boundaries | Intermittent text/JSON failures | Use an incremental decoder/parser that preserves incomplete state |
| Work continues after client disconnect | DB/CPU work remains active | Propagate cancellation to the source |
| Mid-stream error looks successful | Incomplete file with HTTP 200 | Define and record incomplete-transfer behavior and bytes sent |
| Proxy buffers output | First chunk arrives late | Measure client TTFB and inspect the actual path |

### Operational checklist

- [ ] Total byte, time, record-size, and concurrency limits are defined.
- [ ] A slow destination slows the source.
- [ ] The source, transform, and proxy do not accidentally collect the full output.
- [ ] Cancellation, errors, and deadlines release the source/file/connection.
- [ ] TTFB, completion time, bytes, peak RSS, and incomplete transfers are observed separately.
- [ ] Output correctness is checked with small chunks and UTF-8 boundaries.

## Quiz

1. Why does streaming not necessarily make the complete transfer faster?
2. What problem does an unbounded queue between a database and socket create?
3. Is a 64 KiB chunk always one complete JSON record?
4. After half a file has been sent, can the response status be changed to an error?
5. Why is reducing memory per transfer not enough to estimate capacity for 100 transfers?
6. If server TTFB is good but client TTFB is poor, what should you inspect?

### Explained answers

1. Throughput is bounded by the slowest stage. Sending the first chunk sooner does not increase the network's capacity.
2. It accumulates the rate difference and grows memory; propagate backpressure to the producer.
3. No. Transport boundaries are not data boundaries; the parser must retain incomplete state.
4. Usually not; the headers have already been sent. Define and record how an incomplete body is detected.
5. Cursors, connections, other buffers, and slow clients also consume resources; limit concurrency.
6. The proxy, compressor, client buffering, and network path. A measurement inside the handler does not cover the whole route.

## Summary

Streaming avoids memory that grows with the whole body only if every stage and queue is bounded and backpressure reaches the source. Validate and authorize before sending; make cancellation, mid-stream errors, and truncated-output detection part of the contract.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve the exercise; they provide additional reading and technical provenance.

- **Persian, complementary and Node.js-specific:** [A comprehensive guide to Node.js streams](https://shahin.page/persian/article-fa/comprehensive-guide-to-nodejs-streams-nodestream-api-fa). Covers <code>pipeline</code>, backpressure, and Node APIs; use it as an example of one stack, not as a language-neutral authority.
- **English, standards:** [WHATWG Streams Standard](https://streams.spec.whatwg.org/). Defines readable, writable, and transform streams, queues, and backpressure signals. It specifies the Web Streams API, not every runtime's stream implementation.
- **English, platform documentation:** [MDN Streams concepts](https://developer.mozilla.org/en-US/docs/Web/API/Streams_API/Concepts). Introduces producers, consumers, queues, and backpressure in the Web Streams model.
- **English, official Go API reference:** [<code>io</code> package](https://pkg.go.dev/io). Documents bounded reads, <code>Copy</code>, and synchronous <code>Pipe</code> behavior; Go APIs illustrate mechanics but are not a general stream contract.
- **English, official Microsoft guidance:** [ASP.NET Core performance best practices](https://learn.microsoft.com/aspnet/core/performance/performance-best-practices). Covers large-body buffering and response lifecycle concerns for ASP.NET Core; version-specific recommendations may change.
- **English, official Node.js guide:** [Backpressuring in Streams](https://nodejs.org/en/learn/modules/backpressuring-in-streams). Provides an implementation example and an environment-specific memory/GC experiment.

**Navigation:** [Chapter 6](../README.en.md) · [Course index](../../README.en.md) · [Next: Application Profiling](../02-application-profiling/README.en.md)

**Related lessons:** [Payload size](../../02-api-response/01-payload-size/README.en.md) · [Deadlines and retries](../07-timeouts-and-retries/README.en.md) · [Performance testing](../../09-performance-testing/README.en.md)
