# Elastic Cloud

> Chapter 02: Mappings and Data Modeling · Lesson 11

[Read the Persian version](README.md)

## Learning goals

- Understand the difference between managed infrastructure and managed search design.
- Evaluate region, network access, identity, capacity, retention, and recovery before deployment.
- Store credentials safely and grant applications limited access.

## What a managed deployment changes

Elastic Cloud offers hosted Elasticsearch and Kibana deployments and serverless projects. Managed services can reduce the work of provisioning and operating infrastructure, but the application team still owns mappings, data quality, query behavior, access policy, capacity and cost decisions, retention, and validation of recovery. “Managed” does not mean the product design is automatically correct or that a backup has been tested.

Before creating a production deployment, determine the data region and residency requirements, network and private connectivity, user and service identities, TLS expectations, workload shape, growth, retention, recovery objectives, and feature or subscription requirements. Benchmark representative search and ingest load. Model cost from data volume, replicas or project resources, retention, and query patterns; a larger deployment cannot repair every inefficient query.

~~~text
Application -> TLS endpoint + least-privilege API credential -> deployment
                         |
                  secret manager / rotation
~~~

Use a dedicated credential for each application and environment. Keep API keys in a secret manager, restrict their privileges, set expiration where appropriate, rotate them, and revoke unused credentials. Never expose a cloud endpoint together with a secret in browser code or a public repository. Plan and rehearse restore, not only snapshot creation.

## Exercise

Write a deployment checklist for staging and production. Include region, network, identity, application privileges, capacity, version and client compatibility, retention, snapshot policy, and a restore test. Compare which operational tasks the provider performs with those that remain your responsibility.

## Quiz with answers

1. **What does a managed service typically reduce?** Infrastructure provisioning and some maintenance work.
2. **Which responsibilities remain with the application team?** Data modeling, query quality, access design, cost and capacity, retention requirements, and validating recovery.
3. **Where should a service credential live?** In an appropriate secret manager, with limited privileges and a rotation plan.
4. **Does a configured snapshot prove recovery works?** No. Restore and application behavior must be tested against recovery objectives.

## References and further reading

- [Elastic Cloud documentation](https://www.elastic.co/docs/deploy-manage/deploy/elastic-cloud) — hosted and serverless deployment options.
- [Choose a deployment type](https://www.elastic.co/docs/deploy-manage/deploy/elastic-cloud/choosing-your-deployment-type) — compare deployment choices.
- [Elastic Cloud tools and APIs](https://www.elastic.co/docs/deploy-manage/deploy/elastic-cloud/tools-apis) — automation and deployment management.
- [Elastic Cloud status](https://status.elastic.co/) — service availability and incidents.
- [API keys](https://www.elastic.co/docs/deploy-manage/api-keys/elasticsearch-api-keys) — application credentials and privileges.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

