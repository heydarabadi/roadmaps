# Kibana Console

> Chapter 02: Mappings and Data Modeling · Lesson 12

[Read the Persian version](../../../../../fa/elasticsearch/02-mappings-and-data-model/topics/12-kibana-console/README.md)

## Learning goals

- Execute Elasticsearch API requests interactively in Kibana Console.
- Read the request and response in the simplified HTTP syntax.
- Use Console for exploration without confusing it with version-controlled production automation.

## Explore APIs interactively

Kibana Console is an interactive editor for Elasticsearch and Kibana API requests. Each Elasticsearch request begins with a method and path, followed by an optional JSON body. Console shows the response and API errors close to the request, making it useful for learning, inspecting mappings, and troubleshooting a small example.

~~~http
GET /_cluster/health?pretty

GET /products-v1/_mapping

POST /products-v1/_search
{"query":{"match_all":{}}}
~~~

The simplified syntax can be copied to a REST client or translated to an official programming client. For an application, keep requests and configuration in version-controlled code, use a supported client, handle timeouts and errors, and apply least-privilege access. Console inherits the signed-in user's permissions, so check which cluster and identity are active. Treat destructive operations such as deleting an index or changing a template with care; verify the environment and exact target before execution.

## Exercise

In a sandbox, run cluster health, inspect an index mapping, create a temporary index, index one document, and search for it. Before deleting the test index, read its exact name aloud and verify the cluster endpoint. Record the request and response for each step.

## Quiz with answers

1. **What does Console help with?** Sending interactive API requests and inspecting responses while learning or diagnosing.
2. **What should replace hand-run Console calls in a repeatable deployment?** Version-controlled automation and application code using supported clients.
3. **Why verify the active cluster before a destructive request?** The same request syntax can target a different environment, and deletion is destructive.
4. **Whose privileges does an interactive request use?** The authenticated identity that is sending it, subject to configured access controls.

## References and further reading

- [Run API requests with Console](https://www.elastic.co/docs/explore-analyze/query-filter/tools/console) — request syntax and Dev Tools behavior.
- [Explore and analyze data with Kibana](https://www.elastic.co/docs/explore-analyze) — Kibana capabilities.
- [Elasticsearch REST APIs](https://www.elastic.co/docs/reference/elasticsearch/rest-apis) — endpoint reference.
- [Elasticsearch clients](https://www.elastic.co/docs/reference/elasticsearch/clients) — supported application clients.
- [Elastic Cloud API Console](https://www.elastic.co/docs/deploy-manage/deploy/elastic-cloud/tools-apis) — distinguish Cloud Console from Kibana Dev Tools.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

