# The Elastic Stack (Historically “ELK”)

> Chapter 01: Foundations · Lesson 05

[Read the Persian version](../../../../../fa/elasticsearch/01-foundations/topics/05-the-elk-stack/README.md)

## Learning goals

- Identify Elasticsearch, Kibana, Elastic Agent, Logstash, and related components.
- Follow data from collection and transformation into search, analysis, and dashboards.
- Select only the components a use case actually needs.

## Components and responsibilities

“ELK” originally referred to Elasticsearch, Logstash, and Kibana. The current broader name is the Elastic Stack. Elasticsearch stores, indexes, searches, and analyzes data. Kibana provides interfaces such as Discover, dashboards, management, and Dev Tools Console. Elastic Agent collects and forwards operational data from hosts; integrations can package collection and parsing configuration. Logstash is a flexible data collection and transformation pipeline with many input, filter, and output plugins. Ingest pipelines can also transform documents inside Elasticsearch before indexing.

~~~text
Applications / hosts / cloud sources
        |             |
 Elastic Agent     Logstash or direct API
        \             /
        Elasticsearch  ->  Kibana: Discover, dashboards, Console
~~~

This is a pattern, not a mandatory deployment. A small application may write through an official client directly to Elasticsearch and use Kibana for exploration. A complex event pipeline may need Logstash. A host-monitoring use case may use Elastic Agent and integrations. Choose based on input protocols, parsing, buffering, enrichment, operational skills, and throughput.

## Version and production considerations

Keep compatible stack components aligned with the current version guidance. Secure transport with TLS, authenticate agents and applications, give each identity only the privileges it needs, and keep secrets out of configuration repositories. Plan buffering and backpressure: if Elasticsearch slows, a pipeline needs a defined way to queue, retry, or expose dropped events. Monitor ingestion failures and data freshness, not only whether each service process is running.

## Exercise

Design a path for JSON application logs, host metrics, and a daily CSV import. For each source, state whether it should use Elastic Agent, Logstash, an Elasticsearch ingest pipeline, or a direct client, and explain why. Identify where you would monitor parsing failures and delayed data.

## Quiz with answers

1. **What does Elasticsearch do?** It stores and indexes records and provides search and analytics APIs.
2. **What is Kibana for?** It offers user interfaces for exploring, visualizing, and managing Elastic data, including Dev Tools Console.
3. **Is Logstash mandatory?** No. It is useful for flexible ingest and transformation, but direct clients, Elastic Agent, and ingest pipelines cover other patterns.
4. **Why care about backpressure?** A downstream slowdown can otherwise cause unbounded queues, dropped events, or delayed observability data.

## References and further reading

- [The Elastic Stack](https://www.elastic.co/docs/get-started/the-stack) — current component overview and how products fit together.
- [Elastic Agent](https://www.elastic.co/docs/reference/fleet/elastic-agent) — host collection and centralized management.
- [Logstash](https://www.elastic.co/docs/reference/logstash) — pipeline inputs, filters, outputs, and operations.
- [Ingest pipelines](https://www.elastic.co/docs/manage-data/ingest/transform-enrich/ingest-pipelines) — transformations within Elasticsearch.
- [Explore and analyze data with Kibana](https://www.elastic.co/docs/explore-analyze) — Discover, visualization, and analysis tools.
- [Elastic customer stories](https://www.elastic.co/customers/) — vendor-published examples across search, observability, and security.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

