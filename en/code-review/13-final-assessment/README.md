# Final Code Review Assessment — 30 Explained Scenarios

**Language:** English · [فارسی](../../../fa/code-review/13-final-assessment/README.md)

This assessment measures reasoning, not vocabulary recall. Write your choice and rationale before reading the explanation. One option is best in each scenario. In real repositories, the final decision may depend on local policy; assumptions are stated where needed.

## Part 1 — Purpose and flow

### 1. A pull request changes five lines of authorization logic. What do you conclude?

1. It is low risk because it is small.
2. One approval is always enough.
3. Diff size alone does not determine risk; trace access and affected data.
4. No more tests are needed.

**Answer: 3.** A tiny change can alter access for many users. Options 1 and 2 equate size or reviewer count with risk; 4 removes an important control.

### 2. The formatter succeeds and CI is green. What should the reviewer still assess?

1. Nothing; green means correct.
2. Requirements, behavior, edge cases, and controls CI does not cover.
3. Only the number of commits.
4. Only the author's name.

**Answer: 2.** CI runs configured checks; a formatter cannot understand semantics. The other options are not behavioral evidence.

### 3. Which change needs more context?

1. A whitespace fix made by the formatter.
2. An API change that alters null handling and old-data behavior.
3. Removing a redundant, behavior-free comment.
4. Fixing a typo in a README.

**Answer: 2.** Contracts and old data have consumers. The others usually have less behavioral scope, though the repository still matters.

### 4. What is the purpose of review?

1. Guarantee that every bug is removed.
2. Improve change health and reduce risk using evidence and complementary controls.
3. Let the reviewer win an argument.
4. Make every project use the same style.

**Answer: 2.** Review helps but cannot mathematically prove correctness. The other choices are absolute or turn preference into policy.

## Part 2 — Author responsibilities

### 5. A PR description says only “fix bug.” What is missing?

1. Editor color.
2. The problem, solution, tests, impact, and important limitations.
3. Total hours spent.
4. The name of every variable.

**Answer: 2.** The description should preserve the reason for the change and its evidence for reviewers and future readers.

### 6. Why self-review the final diff?

1. The author's memory is always exact.
2. Accidental files or edits may have entered the diff after implementation.
3. It replaces tests.
4. Reviewers should not read the diff.

**Answer: 2.** Self-review inspects the actual proposal from a fresh perspective; it does not remove the need for tests.

### 7. When should a large PR be split?

1. Always into one-line changes.
2. When pieces have meaningful boundaries and can be integrated safely.
3. When each step intentionally breaks the system.
4. Only after a reviewer asks.

**Answer: 2.** Splitting should improve understanding without making history or intermediate states unsafe. There is no universal line limit.

### 8. What should a regression test do for a bug fix?

1. Fail before the fix and pass after it.
2. Merely call the target function.
3. Increase coverage without an assertion.
4. Avoid expected results.

**Answer: 1.** This shows the test is connected to the defective behavior; the other options can create superficial coverage.

## Part 3 — Reviewer preparation

### 9. What is the first pass on a complex PR?

1. Comment on the first strange line.
2. Read purpose and requirements, then map files and impact.
3. Count the lines.
4. Run a formatter on the author's branch.

**Answer: 2.** Context precedes judgment; other choices do not establish intended behavior.

### 10. What does CODEOWNERS not prove?

1. It describes file ownership.
2. It can route reviewers to changed paths.
3. It guarantees the logic is correct and high quality.
4. It can be combined with branch rules.

**Answer: 3.** It is a routing or approval mechanism. Ownership can be stale and reviews can be shallow.

### 11. You lack expertise and the change affects sensitive authentication behavior. What is best?

1. Guess and approve.
2. State your limits and request a domain or security reviewer.
3. Ask the author to approve their own change.
4. Trust the author's confidence.

**Answer: 2.** This manages uncertainty. The others conceal risk or weaken the control.

### 12. How should a reviewer handle a small PR?

1. Always conduct a full security and operations audit of the entire repository.
2. Match review depth to the behavior and risk of this change.
3. Approve without reading the description.
4. Treat a small change as unimportant by definition.

**Answer: 2.** Review should be proportionate; a small diff can still be consequential.

## Part 4 — Technical review

### 13. A test only asserts that a payment gateway was called. What may it miss?

1. Nothing.
2. The final amount/state and real retry or persistence behavior.
3. Only indentation.
4. The branch name.

**Answer: 2.** A mock call does not necessarily prove business outcome; the other options do not establish behavior.

### 14. A logged-in user requests another tenant's order. Which control is needed?

1. Authentication again.
2. Authorization for that object or tenant using the current identity.
3. A formatter.
4. Rate limiting only.

**Answer: 2.** Authentication establishes identity; authorization restricts access to the resource.

### 15. SAST is green. What still needs human review?

1. Nothing.
2. Business logic, contextual access control, and complex data paths.
3. Only line count.
4. Branch name.

**Answer: 2.** A tool can detect configured patterns, not all business meaning.

### 16. What is essential after adding retries to a payment operation?

1. A shorter variable name.
2. Idempotent behavior and a bounded retry policy.
3. Disabling all warnings.
4. An English branch name.

**Answer: 2.** Retries without idempotency can create duplicate charges and amplify load.

### 17. What evidence does a migration on a large table need?

1. A successful compile only.
2. Execution plan, version compatibility, duration/locks, old data, and recovery.
3. A UI screenshot.
4. The same approval count for every company.

**Answer: 2.** A schema change interacts with stored data and live services; an arbitrary approval count is not technical evidence.

### 18. Which benchmark is more interpretable?

1. “It got faster,” without a number.
2. A defined method, environment, data, repetitions, and before/after comparison.
3. One unrecorded run on a laptop.
4. A developer's memory.

**Answer: 2.** It makes the result reviewable; the others lack a reproducible method or baseline.

## Part 5 — Feedback and disagreement

### 19. Which comment is most constructive?

1. “This is awful.”
2. “Two simultaneous requests may both read the old inventory. Does the transaction preserve this invariant?”
3. “You do not understand concurrency.”
4. “Make it better.”

**Answer: 2.** It describes behavior and risk and asks a question that can be answered. The others are insulting or vague.

### 20. The only disagreement is naming, and a style guide/formatter exists. What do you do?

1. Block the PR.
2. Follow the team's rule or formatter and do not impose personal taste.
3. The more senior reviewer wins.
4. Continue privately without recording a decision.

**Answer: 2.** An agreed rule prevents repeated subjective debate; personal preference alone is not a blocker.

### 21. A comment is genuinely optional. Which label fits?

1. Blocker.
2. Nit or suggestion under team convention, clearly marked as non-blocking.
3. Security.
4. Request changes with no explanation.

**Answer: 2.** Severity should be honest; the exact label should follow local convention.

### 22. Review discussion keeps looping. What next?

1. Add more comments.
2. State the issue, decision criteria, options, and owner; record the outcome.
3. Threaten the author.
4. Merge without a decision.

**Answer: 2.** It turns conversation into a traceable decision.

## Part 6 — Response and merge

### 23. The author disagrees with a suggestion. What is a useful response?

1. Silence.
2. Explain the reason and evidence/constraints, and ask for clarification if needed.
3. Resolve the thread without explanation.
4. Make the discussion personal.

**Answer: 2.** Reasoned disagreement is collaboration; silence makes the review state ambiguous.

### 24. A thread is resolved. Is that enough?

1. Yes, the tool proves correctness.
2. No; inspect the resulting code and tests.
3. Only if the author is senior.
4. Yes, if an old CI run was green.

**Answer: 2.** Discussion state and correctness of the revision are separate things.

### 25. A new commit arrives after approval. What do you check?

1. Only the number of approvals.
2. The new diff, CI on the current head, and stale-approval policy.
3. The latest positive comment.
4. Only the PR title.

**Answer: 2.** Approval is connected to the revision the reviewer saw.

### 26. What does a high-impact change need after merge?

1. Assume CI proves production health.
2. Rollout, relevant metrics, owned alerts, and a recovery plan.
3. Remove all logs.
4. Add more review comments.

**Answer: 2.** Change control continues after merge; the other choices are not operational evidence.

## Part 7 — Team and incident learning

### 27. Which is a weak individual KPI?

1. Sampled review quality and rework trends.
2. Number of comments posted.
3. Queue size and first response time used for flow analysis.
4. Knowledge distribution and reviewer workload.

**Answer: 2.** Comment-count targets can reward nits or low-value opinions.

### 28. CI is flaky, so the team ignores alerts. What is the right action?

1. Turn off all alerts permanently.
2. Assign and fix the flaky test and define a clear temporary handling policy.
3. Require more approvals.
4. Blame authors.

**Answer: 2.** Controls must be dependable; silencing everything removes coverage.

### 29. What is a careful lesson from the Cloudflare 2019 incident report?

1. The definite cause was an inattentive reviewer.
2. Consider worst-case performance, testing, rollout, and blast-radius controls; use the report for facts and label lessons as inference.
3. Never use regular expressions.
4. More reviewers always prevent incidents.

**Answer: 2.** This extracts an engineering lesson without reducing the postmortem to a person or single factor.

### 30. How should a postmortem lesson change team practice?

1. Name a person to blame and close the issue.
2. Turn a supported finding into an owned test, guardrail, rollout step, or runbook change.
3. Increase approval counts without analysis.
4. Leave the conclusion in a temporary chat.

**Answer: 2.** The goal is actionable learning and reduced recurrence risk.

## Score interpretation

- **27–30:** Strong independent reasoning; continue learning each repository's policy and domain.
- **22–26:** Solid foundation; revisit missed topics and practice on another PR.
- **15–21:** The concepts are familiar; write a concrete scenario and evidence for each missed answer.
- **Below 15:** Do not memorize the answer key. Follow the four-week plan and explain why each option fits or fails.

A score does not grant security expertise or automatic approval authority. Real decisions depend on domain, policy, context, and evidence.
