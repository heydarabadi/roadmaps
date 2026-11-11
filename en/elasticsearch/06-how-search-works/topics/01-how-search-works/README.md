# How Search Works

> Chapter 06: How Search Works · Lesson 01

[Read the Persian version](../../../../../fa/elasticsearch/06-how-search-works/topics/01-how-search-works/README.md)

## Learning goals

- Trace a search request from query analysis through shard execution and coordinator reduction.
- Understand why search is near real time and Get-by-ID behaves differently.
- Identify common sources of search latency.

## From query text to ranked hits

At index time, a text analyzer can apply character filters, tokenize the input, and normalize tokens with token filters. At search time, the query analyzer prepares the user's terms. If index-time and search-time analysis are incompatible, expected documents may not match. The Analyze API helps inspect this transformation.

The request reaches a node that coordinates it. The coordinating node routes work to the relevant shard copies. Each shard searches its local Lucene index and produces candidate hits, scores, and partial aggregations. The coordinator gathers and reduces these results, sorts them, and returns a response. Shard fan-out, queueing, CPU and heap, network traffic, hit count, sorting, and aggregation complexity all affect latency. The response's `took` time is not the entire client-to-client duration.

~~~text
client -> coordinator -> target shards -> local hits and aggregations
       <- reduce/merge <- shard responses
~~~

Search is near real time. A successful write becomes searchable after a refresh creates a searchable view of recent segments. Get-by-ID follows a different path and can observe recent writes sooner. Use `refresh=wait_for` only when a workflow specifically needs the search result before continuing; forcing a refresh for each write can create expensive small segments.

## Exercise

Run the same search on a small index and an index with more shards. Record p50/p95 end-to-end time, Elasticsearch `took`, shard count, and query result. Use representative data and avoid inferring that more shards are always faster.

## Quiz with answers

1. **What does each shard do during search?** It searches its local shard data and returns local candidates, scores, or aggregation results.
2. **What does the coordinating node do?** Routes the request and reduces or merges shard responses.
3. **Why can search differ immediately after a write?** Search visibility follows refresh, while Get-by-ID uses a different real-time retrieval path.
4. **Does `took` include network and application time?** No, it reports Elasticsearch's processing duration rather than full user-perceived latency.

## References and further reading

- [Reading and writing documents](https://www.elastic.co/docs/deploy-manage/distributed-architecture/reading-and-writing-documents) — distributed request flow.
- [Refresh parameter](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/refresh-parameter) — when writes become searchable.
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — query execution and response fields.
- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis) — index-time and search-time analysis.
- [Apache Lucene](https://lucene.apache.org/) — the search library underlying Elasticsearch.
- [Elasticsearch from the Top Down](https://www.elastic.co/blog/found-elasticsearch-top-down) — conceptual explanation of indices and shards.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

