# Latest Transforms

> Chapter 07: Analysis, Analytics, and Production · Lesson 17

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/17-latest/README.md)

## Learning goals

- Produce the most recent document for each entity key.
- Choose a reliable unique key and a meaningful timestamp or sort field.
- Account for late-arriving events and transform checkpoint delay.

## Keep the newest state per entity

A latest transform creates a destination view containing the most recent document for each configured unique key, based on a sort field. It can support device status, customer profile state, or the latest event per account without discarding the original event history.

~~~json
{"unique_key":["device_id"],"sort":"@timestamp"}
~~~

This shows the key concept; a complete transform also defines source, destination, and sync configuration. Ensure `device_id` is stable and the sort field has correct date semantics. If events arrive late, the latest event by event time may differ from the most recently ingested event. Define which meaning the application wants and measure how long the destination may lag behind the source.

## Exercise

Index two device events in reverse timestamp order. Build a latest transform and compare event-time latest with ingestion-time latest. Add a late event and document the expected destination behavior and sync delay.

## Quiz with answers

1. **What does a latest transform retain?** The most recent source document per unique key according to its sort field.
2. **Why does the sort field matter?** It defines which record is considered newest.
3. **What is the effect of late-arriving data?** The destination may change if the late event is newer by the chosen sort semantics.
4. **Does the latest destination replace the event log?** No; preserve the source history for replay and audit needs.

## References and further reading

- [Transforms overview](https://www.elastic.co/docs/explore-analyze/transforms/transform-overview) — latest and pivot modes.
- [Latest transform](https://www.elastic.co/docs/explore-analyze/transforms/transform-latest) — latest document per key.
- [Create transform API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-transform-put-transform) — transform configuration.
- [Transform stats API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-transform-get-transform-stats) — monitor checkpoint and progress.
- Persian discovery search (not a verified article): [Persian Elasticsearch latest-transform articles](https://www.google.com/search?q=Elasticsearch+latest+transform+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

