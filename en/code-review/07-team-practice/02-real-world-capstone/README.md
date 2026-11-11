# 7.2 — Real-World Cases and Capstone

**Language:** English · [فارسی](../../../../fa/code-review/07-team-practice/02-real-world-capstone/README.md)

**Learning outcomes:** Read incident reports carefully, separate evidence from inference, and perform an end-to-end review.

## Core lesson

Capstone work combines the whole course: understand the requirement, trace behavior across system boundaries, prioritize findings by risk, request evidence, communicate clearly, and connect the final review to rollout and recovery. An incident report can provide a concrete scenario, but it does not tell you that code review alone would have prevented the event. Keep the report's facts, your inferences, and your proposed controls separate.

## Reading incident reports responsibly

Postmortems describe a particular system, incident, and set of contributing factors. They are primary evidence for what the organization reported, not proof that a specific reviewer missed a line or that a generic review rule would have prevented the event. Separate three columns in your notes: **reported facts**, **engineering lesson inferred**, and **control proposed for your own system**.

### Case A: Cloudflare, July 2, 2019

Cloudflare's report describes a regular expression that caused very high CPU usage during a production change and a widespread service disruption. Useful review prompts include worst-case input complexity, load/performance tests, canary or staged rollout, a fast disable/revert path, and monitoring of saturation and errors. These prompts are lessons for analogous systems; the report itself is the evidence for the incident's details.

### Case B: GitHub, October 21, 2018

GitHub's post-incident analysis describes a multi-hour service disruption and recovery from a database failover and replication lag. Use it to ask about failover drills, replication visibility, operator runbooks, data recovery, and how system dependencies affect recovery. Do not simplify the report to “the review missed a bug.”

## Capstone scenario: tenant-isolated invoice export

You are reviewing a PR that adds `GET /accounts/{accountId}/invoices/export`. The PR adds an endpoint, queries invoices by account ID, generates a CSV in memory, uploads it to object storage, and returns a temporary URL. The description says “tested locally” but lists no tests. The existing code uses tenant-aware repository methods. The new route calls a generic repository method. The CSV can contain customer names, addresses, and balances. A retry may create another export job.

### Review procedure

1. **Context:** Find the requirement, authentication middleware, tenant model, export conventions, storage policy, retention rules, and callers.
2. **Correctness:** Confirm the requested account belongs to the current principal; handle empty results, large exports, partial upload, and cancellation.
3. **Security/privacy:** Check resource-level authorization, data minimization, CSV formula injection, URL lifetime, object access, logs, and retention.
4. **Performance/operations:** Avoid unbounded memory use; check pagination/streaming, rate limits, duplicate jobs, timeout, queue retry, metrics, and cleanup.
5. **Tests:** Request negative tenant access, empty and large datasets, storage failure, expiring URL, duplicate request, and safe CSV values.
6. **Feedback:** State confirmed findings separately from questions. Prioritize cross-tenant exposure or data leakage as blockers if the path is verified.
7. **Decision:** Require a qualified security/data owner if policy demands it; inspect the new revision and CI before approval.

### Example finding register

| Priority | Evidence / question | Requested action |
|---|---|---|
| Blocker if confirmed | Generic lookup appears to select by account ID without checking the authenticated tenant. | Use tenant-scoped access and add a negative test for another tenant's account. |
| High | CSV may include values beginning with spreadsheet formula characters. | Apply a context-appropriate safe export strategy and test dangerous cells. |
| Question | Export appears to buffer all rows in memory. What is the maximum expected size? | Bound, stream, or queue the export and add a size/load check. |
| Suggestion | A repeated request may start duplicate work. | Consider an idempotency key or deduplication if duplicate exports have cost or risk. |
| Documentation | Temporary URL lifetime and retention are not stated. | Document the policy and verify the configured expiry. |

Do not assert exploitability until you trace the actual authentication, repository, storage, and client behavior. Record what remains unknown.

## Assessment rubric

Score each 0–2: requirement/context; correct risk ranking; authorization/data flow; meaningful test requests; actionable comments; evidence vs assumption; revision/merge policy; operational recovery. A score of 12/16 is a useful practice threshold, not a professional certification. Any missed tenant-isolation or secret exposure issue means repeat the relevant lessons.

## Capstone tasks

- Write a PR description with risks and review focus.
- Produce at least five findings/questions with priority and evidence.
- Explain which checks belong in CI and which need a human/domain owner.
- Sketch rollout, monitoring, and rollback/recovery.
- Compare your findings with the rubric and revise them.

## Quiz

1. What three things should your incident notes distinguish? **Facts stated by the report, lessons you infer, and controls you propose for your own system.**
2. The export uses a generic repository method while the project is multi-tenant. What is the first high-risk question? **Whether the authenticated tenant is included in the authorization and data query.**
3. A postmortem describes a production outage. Can you claim a reviewer would certainly have prevented it? **No; that is an unsupported counterfactual unless the report provides evidence for it.**
4. What should a strong capstone finding include? **Specific behavior, impact, evidence or uncertainty, priority, and a concrete request or test.**

## Further reading

- [Cloudflare's July 2019 outage postmortem](https://blog.cloudflare.com/details-of-the-cloudflare-outage-on-july-2-2019/)
- [GitHub's October 2018 post-incident analysis](https://github.blog/news-insights/company-news/oct21-post-incident-analysis/)
- [Cloudflare's October 2023 incident postmortem](https://blog.cloudflare.com/cloudflare-incident-on-october-30-2023/)
- [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html)
- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [Persian: Sauleh review guide (PDF)](https://www.sauleh.ir/ap97/static_files/AP97982-CodeReviewGuide.V.1.3.pdf)
- [Persian: Pro-nee secure code review](https://pro-nee.net/terms/secure-code-review/)
