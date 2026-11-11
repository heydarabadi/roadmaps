# 1.1 — Purpose and Limits of Code Review

**Language:** English · [فارسی](../../../../fa/code-review/01-foundations/01-purpose/README.md)

**Learning outcomes:** Explain why teams review changes, distinguish review from neighboring quality controls, and describe what approval does and does not mean.

## Core lesson

Code review is a peer's deliberate examination of a proposed change before it becomes part of a shared codebase. Useful reviews can find defects, expose design and maintenance problems, improve tests and documentation, spread knowledge, and make team standards visible. Those benefits depend on context and useful feedback; the presence of an approval button does not create them automatically.

Review is one assurance layer. A unit test checks selected behavior under controlled inputs. Integration and end-to-end tests exercise larger paths. A formatter and linter enforce mechanical rules. Static security analysis searches for recognized patterns. QA and acceptance testing assess product behavior. Pairing is collaborative implementation as it happens. Production monitoring observes a deployed system. These practices overlap, but they answer different questions.

Review cannot prove the absence of bugs. Reviewers have limited time and context; tests cover selected cases; a team may share the same mistaken assumption. Approval means only that an authorized reviewer accepts the revision they examined within their review scope and repository policy. A security-sensitive design may require a specialist, and deployed behavior still needs operational evidence.

## A practical sequence

1. Restate the requirement in observable terms.
2. Identify the users, data, services, and contracts that may be affected.
3. Choose checks that fit the risk: automated tests, tools, domain review, or rollout controls.
4. Record findings with evidence and a clear priority.
5. State the review scope, unresolved risk, and next required action.

## Worked example: resource ownership

A patch changes `GET /accounts/{id}/invoices`. A unit test may prove that the route calls a service, while a formatter proves style. Neither proves that the signed-in user may read this account. The review should trace identity from the authenticated request, check resource-level authorization in the service or query, and ask for a negative test where user A requests user B's invoice. Approval should be withheld if this invariant is absent.

## Common mistakes

- Treating review as a hunt for every possible bug or as a certification.
- Replacing tests with a confident reviewer, or replacing judgment with a green CI badge.
- Blocking on personal style despite an agreed formatter or guide.
- Approving a high-risk area outside one's expertise without stating the limitation.

## Checklist

- [ ] I can explain the intended behavior in one sentence.
- [ ] I know which automated checks ran and what they cover.
- [ ] I have not confused identity with permission to access a resource.
- [ ] My decision names its scope and any material uncertainty.

## Quiz

1. What is the most complete purpose of review? **Improving the health of a change and sharing context alongside complementary checks.** Review is not bug-proofing, a test substitute, or a contest.
2. Which rule is best handled by a formatter? **A deterministic whitespace or formatting convention.** Human review should focus on semantics and context.
3. CI is green. What remains possible? **A requirement may be misunderstood, an edge case untested, or a production-only interaction missed.**
4. Does approval guarantee that production is safe? **No.** It is bounded by the revision, reviewer expertise, review scope, policy, and evidence.

## Further reading

- [Roadmap.sh Code Review checklist](https://roadmap.sh/pdfs/best-practices/code-review.pdf)
- [Google: The Standard of Code Review](https://google.github.io/eng-practices/review/reviewer/standard.html)
- [Google: What reviewers look for](https://google.github.io/eng-practices/review/reviewer/looking-for.html)
- [Modern Code Review: A Case Study at Google](https://research.google/pubs/modern-code-review-a-case-study-at-google/)
- [Microsoft: Characteristics of Useful Code Reviews](https://www.microsoft.com/en-us/research/publication/characteristics-of-useful-code-reviews-an-empirical-study-at-microsoft/)
- [Persian: Todayino beginner's guide](https://emrozino.ir/article/code-review-beginners-guide)
- [Persian: Sauleh Code Review guide (PDF)](https://www.sauleh.ir/ap97/static_files/AP97982-CodeReviewGuide.V.1.3.pdf)
