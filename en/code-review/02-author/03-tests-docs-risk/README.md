# 2.3 — Tests, Documentation, and Change Risk

**Language:** English · [فارسی](../../../../fa/code-review/02-author/03-tests-docs-risk/README.md)

**Learning outcomes:** Select evidence that matches a change, review test assertions, and remember contracts and operational documentation.

## Core lesson

Tests are executable examples of expected behavior. A useful regression test fails for the old defect and passes after the fix. Check the assertion, fixture, and boundary—not just the test name or coverage percentage. Unit tests localize behavior; integration tests cover collaborators and persistence; contract tests protect producer/consumer agreements; end-to-end tests verify a user path. Choose the cheapest layer that can credibly prove the claim, adding broader tests where interactions matter.

Build a scenario matrix: normal input, empty or missing value, invalid input, boundary size, permission denied, dependency failure, duplicate request, concurrency, and legacy data. Not every change needs every case. Focus on behavior the diff changes. A mock can isolate a boundary but cannot prove that a real database, queue, provider, or authorization policy behaves as assumed.

Review flaky tests as a reliability problem. Identify nondeterministic time, ordering, network, shared state, and cleanup. Do not silence a check without an owner and a plan. Update API docs, migration notes, examples, runbooks, dashboards, and operator instructions when behavior changes. A successful compile cannot prove the docs or runbook still match production.

## Worked example: duplicate payment retry

For a payment endpoint, test a valid first request, the same idempotency key repeated, a timeout after the provider accepted the charge, a key reused with a different amount, and a database failure between provider response and local persistence. Assert the resulting charge count and stored state. A mock-only assertion that “provider.charge was called” misses the central safety property.

## Risk checklist

- Data: migration/backfill, retention, deletion, old records, restore.
- API: clients, defaults, nullability, error semantics, versioning.
- Security: trust boundary, authorization, secrets, sensitive logging.
- Operations: retries, timeouts, idempotency, feature flags, recovery.
- Documentation: user guidance, examples, runbook, release notes.

## Quiz

1. What is the strongest regression test for a bug? **It reproduces the old failure, asserts the expected behavior, fails before the fix, and passes after it.**
2. Does high coverage prove test quality? **No; executed lines may have weak or incorrect assertions.**
3. When is a mock insufficient? **When the claim concerns an integration, transaction, real authorization rule, or external system behavior that the mock does not model.**
4. What should happen to a flaky test? **Find and own the cause, restore a dependable signal, and state any temporary policy.**

## Further reading

- [Google Testing Blog: Test sizes](https://testing.googleblog.com/2010/12/test-sizes.html)
- [NIST SSDF: verification and code review practices](https://csrc.nist.gov/pubs/sp/800/218/final)
- [OWASP Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/)
- [Google: CL descriptions and testing evidence](https://google.github.io/eng-practices/review/developer/cl-descriptions.html)
- [Persian: Sauleh Code Review guide (PDF)](https://www.sauleh.ir/ap97/static_files/AP97982-CodeReviewGuide.V.1.3.pdf)
- [Persian: Javacup review methods](https://javacup.ir/code-review-methods/)
