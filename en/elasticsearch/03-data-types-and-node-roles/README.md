# Chapter 03: Data Types and Node Roles

[Read the Persian chapter guide](../../../fa/elasticsearch/03-data-types-and-node-roles/README.md)

## Learning goals

- Choose a field type based on the query and precision needs of the application.
- Distinguish text analysis from exact-value matching.
- Explain the roles of master-eligible, data, and coordinating nodes.
- Relate node and field design to availability, performance, and recovery.

## Chapter thesis

The field type decides which operations are meaningful: full-text search, exact matching, ranges, sorting, aggregations, or geospatial calculations. A type is part of the data contract, so model values consistently and treat incompatible changes as migrations. Node roles similarly represent responsibilities and resource boundaries. Master-eligible nodes coordinate cluster state, data nodes host shards and execute data operations, and coordinating nodes distribute requests and combine results. The right role layout depends on measured workload and failure requirements; adding nodes without identifying a bottleneck can make the cluster more complex without fixing the problem.

## Study sequence

1. [Data Types](topics/01-data-types/README.md) — choose mappings from required operations.
2. [Master-Eligible Nodes](topics/02-master-eligible-nodes/README.md) — election and cluster-state coordination.
3. [Data Nodes](topics/03-data-nodes/README.md) — shards, storage, indexing, and search work.
4. [Coordinating Nodes](topics/04-coordinating-nodes/README.md) — fan-out, reduction, and request routing.
5. [Numeric](topics/05-numeric/README.md) — ranges, precision, and monetary units.
6. [Boolean](topics/06-boolean/README.md) — true, false, and absent values.
7. [Dates](topics/07-dates/README.md) — timestamps, formats, and timezone discipline.
8. [Geo Points](topics/08-geo-points/README.md) — coordinates and distance-oriented retrieval.

## Practical lab

Model shops with name, price, open status, update timestamp, and location. Give each field a type appropriate to its search behavior. Index sample documents and run one exact filter, one numeric range, one date range, and a geo-distance query. Inspect node roles and cluster health while running the exercise. Use metrics to distinguish query latency, storage pressure, and unassigned replicas.

## Architecture decisions and pitfalls

| Choice | Consider | Common failure |
| --- | --- | --- |
| Numeric representation | Range and aggregation needs, precision, and unit | Storing prices as strings or mixing minor and major currency units |
| Date contract | UTC normalization, accepted formats, and source timezone | Treating a local wall-clock time as UTC without conversion |
| Geo coordinate shape | Named latitude/longitude objects reduce ambiguity | Reversing `[longitude, latitude]` order |
| Dedicated node roles | Resource isolation and measured workload | Over-separating a small cluster or overloading one role |
| More data nodes | Storage, search/ingest capacity, and replica placement | Adding nodes without rebalancing or fixing a hot shard |

## Chapter quiz

1. A product name needs full-text search and exact sorting. What mapping pattern should be considered?
2. Which node responsibility coordinates cluster metadata and state changes?
3. In a geo point array, which coordinate is first?
4. Why are `false` and a missing boolean field different?
5. Does adding a data node guarantee a slow query becomes faster?

**Answer key:** (1) A `text` field with a `keyword` multi-field. (2) The elected master, chosen from master-eligible nodes. (3) Longitude, then latitude; named `lat` and `lon` properties are clearer. (4) `false` is a known value; missing can mean unknown or not supplied. (5) No; measure the bottleneck, routing, shard placement, data, and query first.

## References

- [Field data types](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/field-data-types)
- [Node roles](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles)
- [Nodes and shards](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards)
- [Production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance)
- [Geospatial search](https://www.elastic.co/docs/solutions/search/geospatial)
