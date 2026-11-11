# System Design Reference Library

[فارسی](../sources.md)

This library groups primary documentation, standards, research papers, engineering articles, and public architecture case studies by subject. Vendor documentation is strongest for that vendor’s behavior; use cross-vendor patterns as design ideas and validate them against your own workload. Case studies describe a particular context and should not be copied as universal recipes.

## System design, requirements, and operations

- [System Design Roadmap — roadmap.sh](https://roadmap.sh/system-design) — course scope map.
- [Official System Design roadmap PDF](https://roadmap.sh/pdfs/roadmaps/system-design.pdf) — printable topic tree.
- [Google SRE Book](https://sre.google/sre-book/table-of-contents/) — reliability, monitoring, capacity, incidents, and service management.
- [Google SRE Workbook](https://sre.google/workbook/table-of-contents/) — practical SLO and operational exercises.
- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) — reliability, security, performance, operations, and cost.
- [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/) — architecture concepts and Azure implementation guidance.
- [AWS Builders’ Library](https://aws.amazon.com/builders-library/) — production engineering articles about timeouts, retries, deployments, and operations.
- [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/) — measurable objectives and percentiles.
- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/) — golden signals and monitoring design.
- [Google SRE: Availability Table](https://sre.google/sre-book/availability-table/) — availability arithmetic.
- [Google SRE: Capacity Planning](https://sre.google/sre-book/software-engineering-in-sre/) — capacity planning as an engineering problem.
- [Azure: Design to scale out](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/scale-out) — scale-out limits and design considerations.
- [Microsoft: Cloud application best practices](https://learn.microsoft.com/en-us/azure/architecture/best-practices/index-best-practices) — practical guidance and common antipatterns.

## Consistency, availability, and distributed systems

- [Gilbert and Lynch: CAP theorem formal result (PDF)](https://users.ece.cmu.edu/~adrian/731-sp04/readings/GL-cap.pdf) — formal result on consistency, availability, and partition tolerance.
- [Dynamo: Amazon’s Highly Available Key-value Store](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf) — influential design for an always-writable distributed key-value system.
- [Spanner: Google’s Globally-Distributed Database](https://research.google/pubs/spanner-googles-globally-distributed-database/) — external consistency and globally distributed transactions.
- [Jepsen analyses](https://jepsen.io/analyses) — independent reports on distributed database guarantees.
- [PostgreSQL: Warm standby and streaming replication](https://www.postgresql.org/docs/current/warm-standby.html) — primary/standby behavior and replication.
- [AWS Builders’ Library: Avoiding insurmountable queue backlogs](https://aws.amazon.com/builders-library/avoiding-insurmountable-queue-backlogs/) — queue age, backlog, and recovery.

## DNS, HTTP, transport, and edge delivery

- [RFC 1034: Domain Names — Concepts and Facilities](https://www.rfc-editor.org/rfc/rfc1034) — DNS concepts.
- [RFC 1035: Domain Names — Implementation and Specification](https://www.rfc-editor.org/rfc/rfc1035) — DNS message and implementation details.
- [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110) — HTTP semantics.
- [RFC 9112: HTTP/1.1](https://www.rfc-editor.org/rfc/rfc9112) — HTTP/1.1 message syntax and connections.
- [RFC 9113: HTTP/2](https://www.rfc-editor.org/rfc/rfc9113) — HTTP/2 framing and multiplexing.
- [RFC 9114: HTTP/3](https://www.rfc-editor.org/rfc/rfc9114) — HTTP/3 over QUIC.
- [RFC 8446: TLS 1.3](https://www.rfc-editor.org/rfc/rfc8446) — transport security.
- [Cloudflare: What is DNS?](https://www.cloudflare.com/learning/dns/what-is-dns/) — approachable DNS overview.
- [Cloudflare: What is a CDN?](https://www.cloudflare.com/learning/cdn/what-is-a-cdn/) — CDN overview.
- [Cloudflare Cache documentation](https://developers.cloudflare.com/cache/) — cache behavior and controls.
- [MDN: HTTP overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Overview) — HTTP concepts and examples.
- [gRPC core concepts](https://grpc.io/docs/what-is-grpc/core-concepts/) — RPC, deadlines, streaming, and channels.
- [GraphQL specification](https://spec.graphql.org/) — query language and execution model.
- [AWS Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html) — load-balancer concepts and implementations.

## Service architecture and discovery

- [Microsoft: Microservices architecture style](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) — service boundaries and trade-offs.
- [Martin Fowler: Microservices](https://martinfowler.com/articles/microservices.html) — benefits, costs, and prerequisites.
- [Martin Fowler: Monolith First](https://martinfowler.com/bliki/MonolithFirst.html) — why boundaries often need domain learning first.
- [HashiCorp Consul: Service discovery](https://developer.hashicorp.com/consul/docs/concepts/service-discovery) — registration and discovery.
- [Kubernetes Services and networking](https://kubernetes.io/docs/concepts/services-networking/service/) — stable endpoints for changing workloads.
- [Envoy: What is Envoy?](https://www.envoyproxy.io/docs/envoy/latest/intro/what_is_envoy) — proxy concepts.

## Databases, storage, caching, and data patterns

- [AWS: Choosing a database on AWS](https://docs.aws.amazon.com/decision-guides/latest/decision-guides/databases-on-aws-how-to-choose.html) — workload-driven database selection.
- [PostgreSQL documentation](https://www.postgresql.org/docs/current/) — relational storage, indexes, transactions, and replication.
- [MongoDB data modeling](https://www.mongodb.com/docs/manual/data-modeling/) — document data-modeling trade-offs.
- [Apache Cassandra architecture](https://cassandra.apache.org/doc/latest/cassandra/architecture/overview.html) — partitioning, replication, and consistency.
- [Amazon DynamoDB developer guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html) — partition keys and managed key-value/document storage.
- [Redis documentation](https://redis.io/docs/latest/) — in-memory data structures, caching, and operations.
- [Azure Cache-Aside pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside) — application cache behavior and invalidation.
- [Azure CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs) — separated command/query models and trade-offs.
- [Martin Fowler: Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) — event log as record of state changes.
- [microservices.io: Transactional Outbox](https://microservices.io/patterns/data/transactional-outbox.html) — atomic database update plus reliable publication.
- [AWS: Database sharding](https://docs.aws.amazon.com/whitepapers/latest/database-caching-strategies-using-redis/sharding.html) — distribution considerations.
- [Redis client-side caching](https://redis.io/docs/latest/develop/use/client-side-caching/) — invalidation tracking and client cache behavior.

## Queues, streams, and asynchronous processing

- [Apache Kafka Design](https://kafka.apache.org/40/design/design/) — delivery, ordering, replication, and consumer behavior.
- [Apache Kafka Protocol](https://kafka.apache.org/protocol.html) — wire protocol details.
- [RabbitMQ Reliability guide](https://www.rabbitmq.com/docs/reliability) — acknowledgements, confirms, and recovery.
- [Amazon SQS best practices](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-best-practices.html) — queue and consumer practices.
- [Azure Queue-Based Load Leveling pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/queue-based-load-leveling) — decoupling intake from processing rate.
- [Reactive Streams specification](https://www.reactive-streams.org/) — non-blocking backpressure.
- [AWS Builders’ Library: Making retries safe with idempotent APIs](https://aws.amazon.com/builders-library/making-retries-safe-with-idempotent-APIs/) — retry semantics and idempotency.
- [AWS Architecture Blog: Exponential backoff and jitter](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/) — avoiding synchronized retry storms.
- [Stripe: Idempotent requests](https://docs.stripe.com/api/idempotent_requests) — API-level idempotency behavior.

## Performance, observability, reliability, and security

- [Microsoft: Performance antipatterns](https://learn.microsoft.com/en-us/azure/architecture/antipatterns/) — common bottlenecks.
- [OpenTelemetry documentation](https://opentelemetry.io/docs/) — vendor-neutral traces, metrics, and logs.
- [Prometheus documentation](https://prometheus.io/docs/introduction/overview/) — metrics collection and querying.
- [Grafana documentation](https://grafana.com/docs/grafana/latest/) — dashboards and alerting.
- [Google SRE: Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/) — error-budget-based alerting.
- [Azure: Retry pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/retry) — bounded transient-fault retries.
- [Azure: Circuit Breaker pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker) — stopping repeated calls to an unhealthy dependency.
- [Azure: Throttling pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/throttling) — protecting service capacity.
- [OWASP Top 10](https://owasp.org/www-project-top-ten/) — web application security risks.
- [OWASP API Security Top 10](https://owasp.org/API-Security/) — API-specific risks.
- [NIST SP 800-207: Zero Trust Architecture](https://csrc.nist.gov/pubs/sp/800/207/final) — trust boundaries and continuous authorization.
- [RFC 6749: OAuth 2.0](https://www.rfc-editor.org/rfc/rfc6749) — delegated authorization.
- [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html) — credentials and rotation.

## Public engineering case studies

- [Uber: Modernizing artifact storage](https://www.uber.com/us/en/blog/modernizing-artifact-storage/) — storage and replication evolution.
- [Uber: Herb data-center replication](https://www.uber.com/us/en/blog/herb-datacenter-replication/) — multi-data-center replication.
- [Uber: Cherami message queue](https://www.uber.com/us/en/blog/cherami-message-queue-system/) — durable queue design.
- [Uber: Technology stack foundations](https://www.uber.com/us/en/blog/tech-stack-part-one-foundation/) — platform, discovery, and telemetry.
- [Cloudflare: DNS cache memory optimization](https://blog.cloudflare.com/dns-cache-memory-optimization-1111/) — memory efficiency at DNS scale.
- [Cloudflare: Cache response rules](https://blog.cloudflare.com/introducing-cache-response-rules/) — cache policy control.
- [Netflix TechBlog](https://netflixtechblog.com/) — distributed-system and streaming engineering articles.
- [Amazon Builders’ Library](https://aws.amazon.com/builders-library/) — operational design lessons from AWS services.

Case studies describe published experiences at particular organizations and points in time. Use them to ask better design questions, not as proof that the same implementation fits every workload.


## More implementation and reliability references

- [Azure: Autoscaling guidance](https://learn.microsoft.com/en-us/azure/architecture/best-practices/auto-scaling) — lifecycle, scale-in, and downstream bottleneck checks.
- [Azure: Transient fault handling](https://learn.microsoft.com/en-us/azure/architecture/best-practices/transient-faults) — bounded retry, retry budgets, and circuit breaking.
- [Azure: Bulkhead pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/bulkhead) — isolating resource pools.
- [Azure: Health Endpoint Monitoring](https://learn.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring) — health and readiness checks.
- [Azure: Queue-Based Load Leveling](https://learn.microsoft.com/en-us/azure/architecture/patterns/queue-based-load-leveling) — decoupled intake and processing.
- [Azure: Sequential Convoy](https://learn.microsoft.com/en-us/azure/architecture/patterns/sequential-convoy) — per-key FIFO with parallelism across groups.
- [Azure: Scheduler-Agent-Supervisor](https://learn.microsoft.com/en-us/azure/architecture/patterns/scheduler-agent-supervisor) — supervised long-running work.
- [Azure: Gateway Aggregation](https://learn.microsoft.com/en-us/azure/architecture/patterns/gateway-aggregation) — composing responses from several services.
- [Azure: Gateway Routing](https://learn.microsoft.com/en-us/azure/architecture/patterns/gateway-routing) — routing through a gateway.
- [Azure: Strangler Fig](https://learn.microsoft.com/en-us/azure/architecture/patterns/strangler-fig) — incremental replacement of a legacy system.
- [Azure: Sidecar](https://learn.microsoft.com/en-us/azure/architecture/patterns/sidecar) — companion process for cross-cutting work.
- [AWS multi-Region fundamentals](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-multi-region-fundamentals/) — recovery use cases and implications.
- [AWS Well-Architected: Least privilege](https://docs.aws.amazon.com/wellarchitected/latest/framework/sec_permissions_least_privileges.html) — permission scope and access lifecycle.
- [OpenID Foundation specifications](https://openid.net/developers/specs/) — OpenID Connect Core, Discovery, and related standards.
- [Azure: Security design principles](https://learn.microsoft.com/en-us/azure/well-architected/security/principles) — security architecture guidance.
- [OWASP Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/) — security verification requirements.
- [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html) — credentials, storage, and rotation.
- [microservices.io: Idempotent Consumer](https://microservices.io/patterns/communication-style/idempotent-consumer.html) — deduplicating redelivered messages.
- [RFC 9111: HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111) — HTTP cache semantics.
- [Reactive Streams](https://www.reactive-streams.org/) — asynchronous stream backpressure.
