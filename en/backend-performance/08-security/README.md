# Chapter 8 — Security and Service Capacity Protection

[فارسی](../../../fa/backend-performance/08-security/README.md) | **English**

A service that is fast under normal load can lose resources because of an expensive input, a vulnerable dependency, or an unauthorized request. Security is part of backend availability and reliability: define who may do what, the budget for each operation, and how software changes are reviewed. Removing validation, authorization, encryption, or abuse controls to reduce latency is not an acceptable optimization in this course.

This chapter covers the four security topics in the [Backend Performance roadmap](https://roadmap.sh/backend-performance-best-practices). **Source review: 2026-11-11; educational completion: 2026-11-11.** Each lesson defines its basic terms, examples, and exercise solutions; external references are optional further reading and technical sources, not prerequisites. Examples are instructional, language-neutral, and not executed. Their numbers are not general capacity targets, organizational security policies, or reports of company performance.

## Prerequisites and learning path

Basic familiarity with HTTP, applications, and system resources is enough to begin. Each lesson defines the related terms it needs, such as direct and transitive dependencies, sessions, tenants, latency percentiles, quotas, and artifacts. Paper exercises require no cloud account or scanning tools. Perform practical exercises only in environments where you are authorized to work.

| Order | Lesson | Main question |
| --- | --- | --- |
| 1 | [Dependency hygiene](01-dependency-hygiene/README.md) | What code, versions, and origins entered the release? |
| 2 | [Authentication and authorization](02-authentication-and-authorization/README.md) | Is the identity valid, and is this operation on this object authorized? |
| 3 | [Throttling and rate limiting](03-throttling-and-rate-limiting/README.md) | How much work and cost are acceptable for this request or user? |
| 4 | [Security review and continuous updates](04-security-review-and-updates/README.md) | What evidence shows that controls still work after a change? |

For an operational problem, first inspect the resource path: incoming request → inexpensive checks and size limits → authentication → identity-based authorization and quotas → work with a deadline and bounded concurrency. The exact order depends on the endpoint and threat model; initial anonymous controls, final tenant checks, and authorization checks complement one another. Each lesson explains its part of this chain so you do not need to search elsewhere to understand the topic.

## Chapter-wide scenario

An instructional online store can generate order reports. The PDF library and its transitive dependencies are recorded in an inventory. A signed-in user can retrieve reports only for an authorized tenant; changing an order ID must not change the access boundary. Export count, report-range size, file size, concurrent workers, and external-service cost all have limits. A new library release is checked in a controlled environment for correctness, security, time, and memory; a later review also covers old routes and workers.

This scenario is hypothetical. [OWASP API4:2023](https://api-security.owasp.org/editions/2023/en/0xa4-unrestricted-resource-consumption/) includes CPU and memory use and the cost of paid services within unrestricted resource consumption. A small response may still require an expensive query, computation, or SMS; limiting request count alone is insufficient.

## Connections to other chapters

- [Payload and request/response size](../02-api-response/01-payload-size/README.md): request and response limits make resource budgets enforceable.
- [Background jobs](../03-asynchronism/01-background-jobs/README.md): moving work to a queue does not remove authorization, quota, TTL, or cost controls.
- [Caching and freshness](../01-caching/README.md): identity and authorization caches also need revocation and tenant-isolation contracts.
- [Deadlines and retries](../06-code-optimization/07-timeouts-and-retries/README.md): retries without a budget can amplify rate-limit pressure and outages.
- [Monitoring](../07-monitoring-and-logging/README.md): record denials, control latency, 429 rates, and resource use while protecting sensitive data.
- [Performance testing](../09-performance-testing/README.md): measure allowed load, bursts, boundary inputs, and active controls together.

## Chapter review checklist

- [ ] The dependency inventory is tied to deployed artifacts and an update owner.
- [ ] A scan with no findings is not treated as proof that vulnerabilities are absent.
- [ ] Authentication, authorization, and quotas are separate, complementary controls.
- [ ] Object, operation, and tenant authorization runs on each request and worker path.
- [ ] Authentication cost, authorization caching, and revocation are measured without removing controls.
- [ ] Rate, burst, concurrency, payload, deadline, and external cost each have a budget.
- [ ] Failure behavior for limiters, identity systems, and policies is explicit and observable.
- [ ] Each security finding has an owner, due date, remediation evidence, and re-review.
- [ ] Rollback does not remove required safeguards or restore a vulnerable version without a plan.

**Navigation:** [Course index](../README.md) · [Start with lesson 1](01-dependency-hygiene/README.md)
