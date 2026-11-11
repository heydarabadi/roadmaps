# Running Elasticsearch with Docker

> Chapter 02: Mappings and Data Modeling · Lesson 10

[Read the Persian version](../../../../../fa/elasticsearch/02-mappings-and-data-model/topics/10-running-with-docker/README.md)

## Learning goals

- Use a pinned container image for a repeatable local learning environment.
- Understand why a persistent volume and local-only port binding matter.
- Keep development shortcuts away from production configuration.

## A local lab is not a production deployment

Docker is convenient for learning, reproducing examples, and running a specific version. Choose and pin an Elasticsearch image tag, and use a compatible Kibana version if you run both. Persist the data directory with a volume if you want it to survive container recreation. Allocate enough memory for Elasticsearch and the operating system. Current releases can enable security automatically, so follow the setup steps for the exact release instead of assuming an old no-password command still applies.

~~~text
docker run --name es-lab \
  -p 127.0.0.1:9200:9200 \
  -e discovery.type=single-node \
  -v es-lab-data:/usr/share/elasticsearch/data \
  docker.elastic.co/elasticsearch/elasticsearch:<pinned-version>
~~~

Replace `<pinned-version>` with a current compatible tag. Binding to loopback limits access to the local machine; it does not configure TLS or authentication for a shared deployment. A single-node setup is a lab topology, not a highly available cluster. A Docker volume is persistence on that host, not an independent backup. Production requires secure networking, capacity planning, monitoring, upgrade and recovery procedures, and snapshots stored outside the failed node or host.

## Exercise

Start a version-pinned local node, verify its reported version and cluster health, create a lab index, then stop and recreate the container while keeping the volume. Confirm what persists. Remove only the lab volume after checking its exact name.

## Quiz with answers

1. **Why pin the image version?** It makes the environment reproducible and reduces surprise behavior changes.
2. **What does a Docker volume provide?** Persistence across container replacement on that Docker host; it is not a backup by itself.
3. **Why bind port 9200 to `127.0.0.1` for a local lab?** It avoids exposing the service to other network interfaces by default.
4. **Is `discovery.type=single-node` suitable for production HA?** No. It creates a single-node development topology without node redundancy.

## References and further reading

- [Elasticsearch Docker installation](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-with-docker) — official Docker setup paths.
- [Run Elasticsearch locally](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/local-development-installation-quickstart) — quickstart for local development.
- [Configure Elasticsearch with Docker](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-docker-configure) — configuration details.
- [Production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance) — operating a production cluster.
- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) — recovery independent of a container volume.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

