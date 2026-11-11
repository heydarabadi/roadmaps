# 4.3 — Performance, Scale, and Operations

**Language:** English · [فارسی](../../../04-technical-review/03-performance-operations/README.md)

**Learning outcomes:** Review complexity and data access, assess latency and failure behavior, and connect code changes to safe operations.

## Core lesson

Performance review starts with workload and evidence. Identify hot paths, input sizes, query counts, algorithmic complexity, memory growth, lock duration, and network round trips. An O(n²) loop may be harmless for a small bounded list but dangerous for unbounded data. A single database query may still scan a huge table. Ask for representative benchmarks or plans when the impact matters.

Tail latency matters because averages hide slow requests. Check p95/p99, timeouts, queue growth, saturation, and error rates. Retries need limits, jittered backoff, and idempotent effects; retries at multiple layers can amplify a small failure into a cascading outage. Cancellation and deadlines should propagate. A cache needs invalidation, freshness, tenancy, and fallback behavior—not just a faster hit path.

Operational review asks how the change will be enabled, observed, and reversed. Consider schema rollout order, mixed-version compatibility, feature flags, canaries, owner-assigned alerts, dashboards, and a safe recovery plan. Merge is not production validation. The team needs a signal tied to the behavior it changed.

## Worked case: Cloudflare, July 2019

Cloudflare's postmortem describes a global outage after a configuration/software change triggered a CPU-intensive regular expression in production. The useful review lesson is not “a reviewer should have spotted it”; the report describes a chain of design, testing, rollout, and safeguard factors. For a complex expression or hot-path change, ask about worst-case input cost, realistic performance testing, staged deployment, an emergency disable/rollback path, and telemetry. Keep facts in the postmortem separate from lessons inferred for your own system.

## Checklist

- [ ] Data size and workload bounds are known.
- [ ] Query count, complexity, memory, locks, and tail latency are considered.
- [ ] Timeout/retry behavior cannot multiply load without bounds.
- [ ] Rollout, observability, owner, and recovery are explicit for risky changes.
- [ ] Benchmark claims include a baseline and reproducible method.

## Quiz

1. Which performance claim is better evidence? **A repeatable comparison with workload, environment, baseline, and measurements.**
2. Why can nested retries be dangerous? **Attempts at each layer can multiply, adding load during an overload.**
3. What should a cache change preserve? **Correct freshness, authorization/tenant separation, and a safe miss or fallback path.**
4. What can we conclude from the Cloudflare report? **Use the documented factors to consider performance tests, rollout, and safeguards; do not assert that a specific review comment would certainly have prevented it.**

## Further reading

- [Cloudflare: Details of the July 2, 2019 outage](https://blog.cloudflare.com/details-of-the-cloudflare-outage-on-july-2-2019/)
- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [Google SRE: Addressing Cascading Failures](https://sre.google/sre-book/addressing-cascading-failures/)
- [PostgreSQL: Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)
- [PostgreSQL: Performance Tips](https://www.postgresql.org/docs/current/performance-tips.html)
- [AWS Architecture Blog: Exponential Backoff and Jitter](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/)
- [Cloudflare: October 30, 2023 incident postmortem](https://blog.cloudflare.com/cloudflare-incident-on-october-30-2023/)
- [Persian: Anophel on slow code reviews](https://anophel.com/articles/the-reason-of-slow-code-reviews)
