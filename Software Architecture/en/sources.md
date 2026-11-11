# Curated Software Architecture References

The lessons link to topic-specific readings. This file collects a broader set of primary references and first-hand engineering material. “Many references” does not mean every source on the internet has been covered; these links are selected for authority, practical detail, or documented experience. Check the source’s current version where product behavior or standards matter.

## Architecture and decision records

- [Software Architect roadmap](https://roadmap.sh/software-architect) and [PDF](https://roadmap.sh/pdfs/roadmaps/software-architect.pdf)
- [Software Design & Architecture roadmap](https://roadmap.sh/pdfs/roadmaps/software-design-architecture.pdf)
- [System Design roadmap](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)
- [C4 model](https://c4model.com/)
- [Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)
- [Microsoft Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/)
- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html)
- [Google Cloud Architecture Framework](https://cloud.google.com/architecture/framework)
- [GOV.UK Architectural Decision Record Framework](https://www.gov.uk/government/publications/architectural-decision-record-framework)
- [Architecture Decision Records repository](https://adr.github.io/)
- [Martin Fowler: Monolith First](https://martinfowler.com/bliki/MonolithFirst.html)
- [Martin Fowler: Microservices](https://martinfowler.com/articles/microservices.html)

## Domain design, patterns, and testing

- [Microsoft .NET architecture guidance](https://learn.microsoft.com/en-us/dotnet/architecture/)
- [Microsoft DDD microservices guide](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/)
- [Martin Fowler: Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)
- [Martin Fowler: CQRS](https://martinfowler.com/bliki/CQRS.html)
- [Martin Fowler: Strangler Fig Application](https://martinfowler.com/bliki/StranglerFigApplication.html)
- [Google Testing Blog](https://testing.googleblog.com/)
- [Martin Fowler: Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html)
- [Thoughtworks Technology Radar](https://www.thoughtworks.com/radar)

## Security, identity, and cryptography

- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [OWASP Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/)
- [OWASP API Security Project](https://owasp.org/www-project-api-security/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [NIST Cryptographic Standards and Guidelines](https://csrc.nist.gov/projects/cryptographic-standards-and-guidelines)
- [OAuth 2.0 Security Best Current Practice, RFC 9700](https://www.rfc-editor.org/rfc/rfc9700.html)
- [OpenID Connect specifications](https://openid.net/developers/specs/)
- [Let’s Encrypt documentation](https://letsencrypt.org/docs/)

## Data, APIs, and integration

- [PostgreSQL documentation](https://www.postgresql.org/docs/)
- [Apache Cassandra documentation](https://cassandra.apache.org/doc/latest/)
- [Apache Kafka documentation](https://kafka.apache.org/documentation/)
- [Apache Spark documentation](https://spark.apache.org/docs/latest/)
- [Apache Hadoop documentation](https://hadoop.apache.org/docs/)
- [OpenAPI specification](https://spec.openapis.org/oas/latest.html)
- [HTTP Semantics, RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html)
- [GraphQL specification](https://spec.graphql.org/)
- [gRPC documentation](https://grpc.io/docs/)
- [W3C SOAP specifications](https://www.w3.org/TR/soap12/)
- [CloudEvents specification](https://cloudevents.io/)
- [AWS transactional outbox guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html)

## Web, network, cloud, and reliability

- [MDN Web Docs](https://developer.mozilla.org/)
- [WHATWG HTML standard](https://html.spec.whatwg.org/)
- [W3C Web standards](https://www.w3.org/standards/)
- [IETF RFC index](https://www.rfc-editor.org/)
- [Linux man-pages](https://man7.org/linux/man-pages/)
- [Kubernetes documentation](https://kubernetes.io/docs/)
- [Docker documentation](https://docs.docker.com/)
- [Terraform documentation](https://developer.hashicorp.com/terraform/docs)
- [Google SRE books](https://sre.google/books/)
- [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/)
- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)

## First-hand industry engineering

- [Netflix Technology Blog](https://netflixtechblog.com/)
- [Uber Engineering](https://www.uber.com/blog/engineering/)
- [Stripe Engineering](https://stripe.com/blog/engineering)
- [Cloudflare Blog](https://blog.cloudflare.com/)
- [GitHub Engineering](https://github.blog/engineering/)
- [Meta Engineering](https://engineering.fb.com/)
- [Amazon Builders’ Library](https://aws.amazon.com/builders-library/)
- [Google Cloud Architecture Center: case studies](https://cloud.google.com/architecture)

### Selected reports with concrete design and operations lessons

- [Shopify: E-commerce at scale](https://shopify.engineering/e-commerce-at-scale-inside-shopifys-tech-stack) — database sharding, cache dependencies, and outage lessons.
- [Shopify: Shard balancing at terabyte scale](https://shopify.engineering/mysql-database-shard-balancing-terabyte-scale) — moving tenant data with controlled rollout and low downtime.
- [Shopify: Upgrading MySQL](https://shopify.engineering/upgrading-mysql-shopify) — turning risky infrastructure upgrades into repeatable operations.
- [Meta: GraphQL, a data query language](https://engineering.fb.com/2015/09/14/core-infra/graphql-a-data-query-language/) — why a product team created a typed graph query API for mobile.
- [Meta: Rebuilding Facebook.com](https://engineering.fb.com/2020/05/08/web/facebook-redesign/) — server rendering, streaming data, and client/server coordination.
- [Meta: Migrating data ingestion systems at Meta scale](https://engineering.fb.com/2026/05/12/data-infrastructure/migrating-data-ingestion-systems-at-meta-scale/) — shadow runs, checksums, staged promotion, and rollback during a large migration.
- [LinkedIn: How Kafka is customized for 7 trillion messages per day](https://www.linkedin.com/blog/engineering/open-source/apache-kafka-trillion-messages) — partitions, operational tooling, and production-specific changes.
- [Netflix: Announcing Zuul, an edge service](https://netflixtechblog.com/announcing-zuul-edge-service-in-the-cloud-ab3af5be08ee) — a first-hand view of a programmable reverse-proxy layer.
- [Netflix: Service-level prioritized load shedding](https://netflixtechblog.com/enhancing-netflix-reliability-with-service-level-prioritized-load-shedding-e735e6ce8f7d) — protecting essential traffic under overload.
- [Amazon Builders’ Library: Making retries safe with idempotent APIs](https://aws.amazon.com/builders-library/making-retries-safe-with-idempotent-APIs/) — retry safety for operations with side effects.

These are first-person engineering reports from organizations with their own scale, teams, and constraints. Use them to understand trade-offs and failure modes; do not copy their topology without validating your own workload and operating capacity.

## Persian starting points

- [Software architecture articles by Ali Rostami](https://www.alirostami.com/software-architecture/)
- [CodingCogs architecture roadmaps](https://codingcogs.org/road-maps/software-architecture)
- [DNTips technical articles](https://www.dntips.ir/)
- [Persian Event-Driven Architecture notes](https://github.com/gloonch/eventdrivenfarsi)
- [Persian DDD learning repository](https://github.com/hheydarian/Understanding-Domain-Driven-Design)

These Persian references are supplementary. For exact standards, protocol behavior, and current vendor limits, prefer the linked primary specifications and official product documentation.

## Web and mobile architecture

- [React Learn](https://react.dev/learn), [Vue Guide](https://vuejs.org/guide/), and [Angular documentation](https://angular.dev/overview)
- [web.dev: Rendering on the Web](https://web.dev/articles/rendering-on-the-web)
- [MDN Web Docs](https://developer.mozilla.org/) and [MDN Progressive Web Apps](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)
- [W3C Web Content Accessibility Guidelines](https://www.w3.org/WAI/standards-guidelines/wcag/)
- [Martin Fowler: Micro Frontends](https://martinfowler.com/articles/micro-frontends.html)
- [Android architecture recommendations](https://developer.android.com/topic/architecture) and [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

## Enterprise architecture and business analysis

- [The Open Group: TOGAF](https://www.opengroup.org/togaf) and [TOGAF ADM](https://pubs.opengroup.org/togaf-standard/adm/)
- [Capgemini Integrated Architecture Framework](https://www.capgemini.com/insights/expert-perspectives/integrated-architecture-framework/)
- [IIBA: BABOK Guide](https://www.iiba.org/standards-and-resources/babok/)
- [GOV.UK Service Manual: User needs](https://www.gov.uk/service-manual/user-research/start-by-learning-user-needs)
- [OMG BPMN 2.0](https://www.omg.org/spec/BPMN/2.0/) and [OASIS WS-BPEL 2.0](https://docs.oasis-open.org/wsbpel/2.0/OS/wsbpel-v2.0-OS.html)
- [The Open Group: IT4IT](https://www.opengroup.org/it4it)

## Delivery, agile, and professional practice

- [PMI standards and PMBOK Guide](https://www.pmi.org/standards/pmbok)
- [PeopleCert: ITIL and PRINCE2](https://www.peoplecert.org/certifications)
- [Agile Manifesto](https://agilemanifesto.org/) and [Persian translation](https://agilemanifesto.org/iso/fa/manifesto.html)
- [The Scrum Guide](https://scrumguides.org/scrum-guide.html)
- [Open Guide to Kanban](https://kanbanguides.org/open-guide-to-kanban/)
- [LeSS framework](https://less.works/) and [Scaled Agile Framework](https://framework.scaledagile.com/)
- [DORA capabilities](https://dora.dev/capabilities/)

## Enterprise platforms and field evidence

- [Dynamics 365 reference architectures](https://learn.microsoft.com/en-us/dynamics365/guidance/reference-architectures/)
- [SAP S/4HANA Help Portal](https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE), [SAP HANA documentation](https://help.sap.com/docs/SAP_HANA_PLATFORM), and [SAP BusinessObjects BI](https://pages.community.sap.com/topics/bi-platform)
- [OpenText Documentum Content Management](https://www.opentext.com/products/documentum-content-management)
- [IBM Business Automation Workflow documentation](https://www.ibm.com/docs/en/baw/26.0.x?topic=overview)
- [Salesforce Architects](https://architect.salesforce.com/) and [Salesforce Well-Architected](https://architect.salesforce.com/well-architected/overview)
- [Shopify Engineering](https://shopify.engineering/), [Stripe Engineering](https://stripe.com/blog/engineering), and [Amazon Builders' Library](https://aws.amazon.com/builders-library/)

## Persian learning references

- [Ali Rostami: Software architecture](https://www.alirostami.com/software-architecture/)
- [CodingCogs: Software architecture roadmaps](https://codingcogs.org/road-maps/software-architecture)
- [DNTips: Persian technical articles](https://www.dntips.ir/)
- [Persian Domain-Driven Design learning repository](https://github.com/hheydarian/Understanding-Domain-Driven-Design)
- [Persian Event-Driven Architecture notes](https://github.com/gloonch/eventdrivenfarsi)

