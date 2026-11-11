# 3.2 — Reviewer Selection and Review Planning

**Language:** English · [فارسی](../../../03-reviewer/02-reviewer-selection/README.md)

**Learning outcomes:** Select reviewers by expertise and risk, plan coverage for cross-cutting changes, and communicate review limits.

## Core lesson

The right reviewer is someone who can give a thorough and correct assessment of the changed area. Consider current code ownership, domain knowledge, system architecture, security or privacy expertise, familiarity with a data pipeline, and the availability to respond. `CODEOWNERS` and automatic assignment improve routing; they do not prove the named person still understands the code or that every risk is covered.

For cross-cutting changes, assign complementary questions. One reviewer may understand API compatibility, another authorization, and another migration/operations. Avoid requesting many reviewers “just in case”: overlapping reviews create coordination cost and unclear ownership. Agree which reviewer is responsible for the final decision, and notify the author if review will be delayed.

Review depth should fit the risk and policy. A small docs change may need a quick content check. An auth or payment change may need a security/domain owner, targeted tests, and a deployment plan. Do not outsource a decision to an expert who has not seen the relevant revision; summarize the question and evidence.

## Worked example: database migration plus API change

For adding a required customer field, request an API owner to assess client compatibility, a data owner to assess backfill and null behavior, and the service maintainer to check the end-to-end transition. One person can fill several roles if qualified. The author documents deploy order and the backward-compatible interval; ownership does not remove the need to inspect CI and the current diff.

## Checklist

- [ ] Reviewers match the domains and risk areas changed.
- [ ] Cross-cutting checks have named owners.
- [ ] The author knows when the review is delayed.
- [ ] Reviewers state limits rather than approving outside expertise.
- [ ] CODEOWNERS and team assignment rules are current.

## Quiz

1. What does `CODEOWNERS` guarantee? **Routing or required ownership under a configured policy; it does not guarantee correct or deep review.**
2. A PR changes auth, storage, and an API. What is a good plan? **Assign qualified reviewers for the distinct risk areas and make their responsibilities explicit.**
3. You are not qualified to assess an auth change. What should you do? **State that limit and request an appropriate security or domain reviewer.**
4. Is requesting every possible reviewer safer? **Not automatically; it may create delay and diffusion of responsibility. Select the expertise needed.**

## Further reading

- [Google: Reviewer selection](https://google.github.io/eng-practices/review/reviewer/looking-for.html)
- [GitHub: About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [GitHub: Requesting a pull request review](https://docs.github.com/en/pull-requests/how-tos/create-pull-requests/requesting-a-pull-request-review)
- [Review of code reviewer recommendation studies](https://doi.org/10.1016/j.scico.2021.102652)
- [CORRECT: Code Reviewer Recommendation in GitHub](https://arxiv.org/abs/1807.02965)
- [Persian: Todayino on author and reviewer collaboration](https://emrozino.ir/article/code-review-beginners-guide)
