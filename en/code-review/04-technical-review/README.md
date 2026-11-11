# Chapter 4 — Technical Review

**Language:** English · [فارسی](../../../fa/code-review/04-technical-review/README.md)

**Goal:** Evaluate behavior, design, tests, security, performance, and operational consequences.

## Connecting lesson

Translate the requirement into invariants and scenarios. Follow the normal path, boundary values, failures, retries, concurrency, and data compatibility. Read tests to see whether they assert the promised behavior, not merely whether a function was called. For security, trace data across trust boundaries and check authorization at the resource. For performance, identify the hot path and use representative data. For operations, check compatibility, staged rollout, useful telemetry, and recovery.

Order review effort by risk. Formatting is important but can usually be automated. Human attention is more valuable on access control, business invariants, API contracts, races, data migration, and failure behavior. Support findings with an observable path, a requirement, a test, or a reproducible example. If the risk is plausible but unproven, ask a precise question or propose the evidence needed.

## Topics

- [4.1 Correctness, design, and API contracts](01-correctness-design-api/README.md)
- [4.2 Tests and security review](02-tests-security/README.md)
- [4.3 Performance, scale, and operations](03-performance-operations/README.md)

## Chapter practice

Select an endpoint. Write its intended behavior, invariants, five test scenarios, trust boundaries, likely performance bottleneck, rollout signals, and rollback path. Then identify which claims can be checked automatically and which need domain review.

## Review questions and answer guide

1. Where do you start when checking behavior? **Start from the requirement and turn it into invariants and success, edge, and failure scenarios.**
2. Why do green tests or SAST not prove security and performance? **They only cover configured checks and exercised paths; business authorization, workload, concurrency, and realistic data may remain untested.**
3. What should a high-impact change include beyond code and tests? **Migration and version compatibility, staged rollout, metrics and alerts, ownership, and recovery or rollback.**

## Further reading

- [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html)
- [NIST Secure Software Development Framework (SP 800-218)](https://csrc.nist.gov/pubs/sp/800/218/final)
- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [GitLab Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [Persian: Pro-nee secure code review](https://pro-nee.net/terms/secure-code-review/)
