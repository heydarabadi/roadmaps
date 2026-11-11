# Bilingual Code Review Glossary

**Language:** English · [فارسی](../../09-glossary/README.md)

Definitions describe practical usage in this course. A team's platform or policy may use some terms differently.

## Roles and change objects

| Term | Meaning | Example |
|---|---|---|
| Code review | A peer examines a proposed change before integration | Reviewing an order-service diff |
| Author / submitter | Person who proposes the change | Creates the branch and PR |
| Reviewer | Person who evaluates the change | Checks behavior, risks, and evidence |
| Maintainer | Person responsible for repository health and decisions | Project owner who enforces contribution policy |
| Pull Request (PR) | GitHub's proposal to merge a branch | Feature branch into `main` |
| Merge Request (MR) | GitLab's equivalent review and merge proposal | An MR with discussion and pipeline |
| Change List (CL) | A proposed change; term used in Google's review guides | A self-contained code submission |
| Diff | Difference between two revisions | Added and removed lines |
| Base branch | Destination branch against which a change is compared | Often `main` |
| Head/source branch | Branch containing the proposed change | `feature/search` |
| Commit | Recorded snapshot in Git history | A revision on the feature branch |
| Draft PR | Unfinished proposal for early feedback | Design feedback before merge readiness |
| Stacked PR | A PR depending on another PR | Schema change followed by endpoint change |

## Discussion and decisions

| Term | Meaning | Key distinction |
|---|---|---|
| Comment | Message on a line or PR | May be a question, explanation, or request |
| Suggestion | Optional proposed improvement | Must be marked non-blocking when optional |
| Approval | Acceptance of the reviewed revision | Not a guarantee of defect-free production |
| Request changes | Review state requesting a change | May block merge under repository policy |
| Blocker | Material issue that must be resolved or explicitly decided | Should have a clear risk or requirement |
| Question | Request for missing context | Does not necessarily require a code change |
| Nit | Minor, non-blocking preference | Must not disguise a serious concern |
| LGTM | “Looks Good To Me” | Better paired with review scope and caveats |
| Thread | Discussion attached to a specific topic or line | Resolving it does not prove the fix |
| Re-review | Review of a newer revision | Needed after meaningful changes |
| Push | Sending commits to the remote repository | May change the diff and approval validity |
| Stale approval | Approval that no longer covers the current diff | Repository rules determine exact handling |

## Quality, design, and testing

| Term | Meaning | Example |
|---|---|---|
| Requirement | Desired system behavior or constraint | A user can see only their own invoice |
| Acceptance criteria | Conditions that demonstrate a requirement is met | Unauthorized account access returns no data |
| Invariant | Property that must remain true | One payment key creates at most one charge |
| Edge case | Boundary or unusual input/state | Empty list, max size, duplicate request |
| Regression | Reintroduction of a previously fixed defect | Pagination breaks after a new filter |
| Unit test | Test of a small unit with controlled dependencies | Pure function behavior |
| Integration test | Test of collaborating components | Service with a test database |
| Contract test | Test of producer/consumer agreement | Response schema compatibility |
| End-to-end test | Test of a complete user or system flow | Sign in, order, pay, view receipt |
| Assertion | Expected property checked by a test | Final amount equals the expected total |
| Mock | Controlled substitute for a dependency | Simulated payment-provider response |
| Flaky test | Test with nondeterministic outcomes | Passes or fails without code changes |
| Coverage | Portion of code executed by tests | Does not prove assertions are meaningful |
| Refactoring | Restructuring without intended behavior change | Simplifying a method under tests |
| Coupling | Degree of dependency between components | A change to one module breaks several |
| API contract | Shape and meaning of an interface | Inputs, outputs, errors, access, defaults |
| Backward compatibility | New version still works with old clients/data | Old app continues to read new response |

## Security and dependencies

| Term | Meaning | Reminder |
|---|---|---|
| Authentication | Establishing an identity | “Who is this?” |
| Authorization | Deciding what that identity may do to a resource | A valid user is not automatically allowed |
| Trust boundary | Point where data crosses a security context | HTTP, queue, file, or external service |
| Source | Origin of data | Request, upload, message, environment, DB |
| Sink | Sensitive operation that consumes data | Query, shell, HTML, log, filesystem |
| Taint/data flow | Tracking untrusted data to its use | Source → transformation → sink |
| SAST | Static application security testing | Analyzes source without normal execution |
| DAST | Dynamic application security testing | Probes a running application externally |
| Secret | Credential or cryptographic material | Password, token, private key |
| Dependency | External package or component | Library included by the application |
| Lockfile | Exact resolved dependency versions | Helps reproduce an install |
| Supply-chain risk | Risk from component origin and lifecycle | Maintainer, version, provenance, scripts |
| Least privilege | Granting only required permissions | Service gets only necessary access |
| Threat model | Structured view of assets, actors, threats, boundaries | Helps prioritize security review |

## Operations and measurement

| Term | Meaning | Example |
|---|---|---|
| Migration | Change to schema or persisted data | Adding and backfilling a column |
| Rollout | Gradual enablement or deployment | Start with a small traffic percentage |
| Rollback | Reverting code or behavior | Disable a feature flag |
| Feature flag | Runtime switch for a capability | Merged code remains disabled initially |
| Canary | Limited initial deployment | One instance or small user cohort |
| Observability | Ability to understand system behavior from telemetry | Metrics, logs, traces |
| Metric | Quantitative signal | Payment error rate |
| Alert | Notification intended to prompt action | Error rate exceeds a threshold |
| Blast radius | Scope of impact if a change fails | One user, one tenant, or all traffic |
| Tail latency | Slow end of latency distribution | p95 or p99 response time |
| N+1 query | One query plus another per returned record | 101 queries for 100 rows |
| Idempotency | Repeating an operation does not duplicate its effect | Retry does not charge twice |
| Race condition | Outcome depends on concurrent timing | Two requests both read the same balance |
| Backoff | Increasing delay between retries | Reduces pressure during failure |
| SLO | Service-level objective | Measurable reliability target |

## Pairs that are easy to confuse

- **Authentication ≠ authorization:** knowing identity does not grant every permission.
- **Coverage ≠ test quality:** code can execute without a useful assertion.
- **Resolved ≠ fixed:** a thread can close while the behavior remains wrong.
- **Approval ≠ guarantee:** approval covers a revision and a stated review scope.
- **Merge ≠ deploy:** integration is not necessarily release or activation.
- **Input validation ≠ access control:** a valid identifier does not prove ownership.
- **Average latency ≠ tail latency:** an average can hide very slow requests.
- **Correlation ≠ causation:** two events moving together does not prove one caused the other.

## References

- [Google Engineering Practices: Code Review](https://google.github.io/eng-practices/review/)
- [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html)
- [Persian Code Review guide (Sauleh PDF)](https://www.sauleh.ir/ap97/static_files/AP97982-CodeReviewGuide.V.1.3.pdf)
- [Persian review guide (Todayino)](https://emrozino.ir/article/code-review-beginners-guide)
