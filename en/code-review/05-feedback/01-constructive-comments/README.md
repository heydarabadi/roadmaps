# 5.1 — Constructive, Specific Review Comments

**Language:** English · [فارسی](../../../../fa/code-review/05-feedback/01-constructive-comments/README.md)

**Learning outcomes:** Write feedback that is precise, respectful, proportionate, and easy to act on.

## Core lesson

A review comment should make the code easier to improve. A compact pattern is: **observed behavior → impact or reason → request or question → evidence/priority**. Point to code, not the author's character. Explain why a behavior matters instead of prescribing a change without context. When the risk is uncertain, ask for the invariant or evidence that would resolve it.

Bad: “This is wrong.” Better: “If two workers process the same message, both can decrement inventory after reading the old value. Could we make the update atomic and add a concurrent duplicate test? The stock invariant is that quantity never becomes negative.”

Questions are useful when they are genuine questions. A polite question that secretly means “change this now” creates confusion; state whether the request blocks merge. Praise can identify a strong test, clear migration, or helpful explanation. Positive feedback teaches the team what to repeat, but should be specific rather than a generic “nice work.”

Use a conversational tone and make one point per comment. Avoid sarcasm, absolutes, rhetorical attacks, vague imperatives, and a wall of unrelated findings. If a complex issue needs a live discussion, summarize the decision and evidence in the PR so future readers can follow it.

## Rewrite exercise

Rewrite: “You forgot security here.” A stronger version names the route or resource, identifies the missing authorization check, explains the exposure, and asks for a specific negative test. Do not claim the endpoint is exploitable until you have traced the actual path.

## Checklist

- [ ] The comment points to observable behavior.
- [ ] The reason or impact is understandable.
- [ ] The requested action is specific and proportionate.
- [ ] Severity and uncertainty are explicit.
- [ ] The wording critiques the change, not the person.

## Quiz

1. Which comment is actionable? **“This query can cross tenant boundaries because it filters only by invoice ID; can we scope it by the authenticated tenant and test a foreign ID?”**
2. Is every question a non-blocking request? **No. State the actual intent and whether the issue blocks merge.**
3. When is praise useful? **When it identifies a concrete practice worth repeating, such as a regression test for a difficult edge case.**
4. What if the claim is uncertain? **Ask a question or request evidence; do not state an unverified defect as fact.**

## Further reading

- [Google: How to write code review comments](https://google.github.io/eng-practices/review/reviewer/comments.html)
- [Conventional Comments specification](https://conventionalcomments.org/)
- [Microsoft Research: Characteristics of Useful Code Reviews](https://www.microsoft.com/en-us/research/publication/characteristics-of-useful-code-reviews-an-empirical-study-at-microsoft/)
- [What Makes a Code Review Useful to OpenDev Developers?](https://arxiv.org/abs/2302.11686)
- [Comments on Comments: Code Review and Documentation](https://research.ibm.com/publications/comments-on-comments-where-code-review-and-documentation-meet)
- [Persian: Sauleh review culture guide (PDF)](https://www.sauleh.ir/ap97/static_files/AP97982-CodeReviewGuide.V.1.3.pdf)
- [Persian: Todayino on constructive feedback](https://emrozino.ir/article/code-review-beginners-guide)
