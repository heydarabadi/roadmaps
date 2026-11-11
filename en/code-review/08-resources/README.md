# Curated Code Review Reference Library

**Language:** English · [فارسی](../../../fa/code-review/08-resources/README.md)

This library adds primary documentation, security standards, empirical research, incident reports, and Persian-language reading. It is deliberately broad, but curated: no one has read “the entire internet.” Prefer the source closest to the claim. Company playbooks describe that company's context; research describes its samples and method; platform docs may change as products evolve. Check publication dates and repository policy before applying advice.

## Start here: core practice

1. [Roadmap.sh Code Review checklist](https://roadmap.sh/pdfs/best-practices/code-review.pdf) — the checklist mapped by this course.
2. [Google Engineering Practices: Code Review](https://google.github.io/eng-practices/review/) — a complete, practical reviewer and author guide.
3. [GitHub: Reviewing changes in a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-a-pull-request) — platform workflow.
4. [GitLab: Code Review Guidelines](https://docs.gitlab.com/development/code_review/) — contributor-focused review guidance.
5. [Microsoft Engineering Playbook: Pull Requests](https://github.com/microsoft/code-with-engineering-playbook/blob/main/docs/code-reviews/pull-requests.md) — team process guidance.
6. [Microsoft Engineering Playbook: Review FAQ](https://microsoft.github.io/code-with-engineering-playbook/code-reviews/faq/) — recurring review questions.

## Google Engineering Practices — detailed chapters

- [Standard of Code Review](https://google.github.io/eng-practices/review/reviewer/standard.html)
- [What reviewers look for](https://google.github.io/eng-practices/review/reviewer/looking-for.html)
- [Navigating a CL in review](https://google.github.io/eng-practices/review/reviewer/navigating-cl.html)
- [Speed of Code Reviews](https://google.github.io/eng-practices/review/reviewer/speed.html)
- [Writing review comments](https://google.github.io/eng-practices/review/reviewer/comments.html)
- [Handling pushback](https://google.github.io/eng-practices/review/reviewer/pushback.html)
- [The CL Author's Guide](https://google.github.io/eng-practices/review/developer/)
- [Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html)
- [CL descriptions](https://google.github.io/eng-practices/review/developer/cl-descriptions.html)
- [Handling reviewer comments](https://google.github.io/eng-practices/review/developer/handling-comments.html)

## GitHub and GitLab workflow references

- [GitHub: Quickstart for reviewing pull requests](https://docs.github.com/en/pull-requests/get-started/reviewing-pull-requests-quickstart)
- [GitHub: Pull request review concepts](https://docs.github.com/en/pull-requests/reference/pull-request-reviews)
- [GitHub: Incorporating feedback](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/incorporating-feedback-in-your-pull-request)
- [GitHub: Resolving reviews](https://docs.github.com/en/pull-requests/concepts/resolving-reviews)
- [GitHub: Protected branches and required reviews](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub: About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [GitHub: Requesting a pull request review](https://docs.github.com/en/pull-requests/how-tos/create-pull-requests/requesting-a-pull-request-review)
- [GitLab: Review guidelines](https://docs.gitlab.com/development/code_review/)
- [Conventional Comments specification](https://conventionalcomments.org/)
- [Conventional Comments labels and decorations](https://conventionalcomments.io/docs/labels/)

## Security review and secure development

- [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html)
- [NIST Secure Software Development Framework, SP 800-218](https://csrc.nist.gov/pubs/sp/800/218/final)
- [OWASP Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/)
- [OWASP Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [OWASP Authorization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)
- [OWASP Input Validation Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)
- [OWASP SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [OWASP Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Injection_Prevention_Cheat_Sheet.html)
- [OWASP File Upload Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)
- [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)

## Testing, contracts, performance, and operations

- [Google Testing Blog: Test sizes](https://testing.googleblog.com/2010/12/test-sizes.html)
- [Google API Design Guide](https://cloud.google.com/apis/design)
- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)
- [Stripe API: Idempotent requests](https://docs.stripe.com/api/idempotent_requests)
- [PostgreSQL: Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)
- [PostgreSQL: Performance tips](https://www.postgresql.org/docs/current/performance-tips.html)
- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [Google SRE: Addressing Cascading Failures](https://sre.google/sre-book/addressing-cascading-failures/)
- [Google SRE Workbook: Canarying Releases](https://sre.google/workbook/canarying-releases/)
- [AWS Architecture Blog: Exponential Backoff and Jitter](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/)

## Research papers and empirical studies

Use these to understand what reviews do in the studied settings. Their sample, company, platform, period, and metric limit generalization.

- [Expectations, Outcomes, and Challenges of Modern Code Review (ICSE 2013)](https://doi.org/10.1109/ICSE.2013.6606617) — interviews and observations of modern review.
- [Modern Code Review: A Case Study at Google (ICSE 2018)](https://research.google/pubs/modern-code-review-a-case-study-at-google/) — developer goals, workflow, benefits, and difficulties at Google.
- [Characteristics of Useful Code Reviews: An Empirical Study at Microsoft](https://www.microsoft.com/en-us/research/publication/characteristics-of-useful-code-reviews-an-empirical-study-at-microsoft/) — what developers consider useful feedback.
- [Code Reviews Do Not Find Bugs (Microsoft Research / ICSE SEIP 2015)](https://www.microsoft.com/en-us/research/publication/code-reviews-do-not-find-bugs-how-the-current-code-review-best-practice-slows-us-down/) — a critical argument about review costs, skill, and social factors; read the evidence and scope rather than treating the title as a universal law.
- [Can We Benchmark Code Review Studies? (Journal of Systems and Software)](https://doi.org/10.1016/j.jss.2021.111009) — systematic mapping of study methods, datasets, and metrics.
- [Modern Code Reviews: Survey of Literature and Practice](https://arxiv.org/abs/2403.00088) — mapping through 2021 and practitioner relevance.
- [A Survey on Modern Code Review: Progresses, Challenges and Opportunities](https://arxiv.org/abs/2405.18216) — a broader survey of research themes.
- [What Makes a Code Review Useful to OpenDev Developers?](https://arxiv.org/abs/2302.11686) — comment usefulness in OpenDev projects.
- [Characteristics of Useful Code Reviews (Microsoft Research)](https://www.microsoft.com/en-us/research/publication/characteristics-of-useful-code-reviews-an-empirical-study-at-microsoft/) — empirical comment-classification study.
- [Opportunities and Challenges in Repeated Revisions to Pull Requests](https://doi.org/10.1145/3555208) — feedback, revision rounds, and avoidable rework.
- [Quality Gatekeepers: Effects of Code Review Bots on Pull Requests](https://doi.org/10.1007/s10664-022-10130-9) — exploratory study of bots and PR activity.
- [Review of Code Reviewer Recommendation Studies](https://doi.org/10.1016/j.scico.2021.102652) — methods and validity concerns in reviewer recommendation research.
- [CORRECT: Code Reviewer Recommendation in GitHub](https://arxiv.org/abs/1807.02965) — reviewer recommendations using experience and technology context.
- [Comments on Comments: Where Code Review and Documentation Meet](https://research.ibm.com/publications/comments-on-comments-where-code-review-and-documentation-meet) — review comments that clarify code and persist knowledge.
- [Understanding Code Smell Detection via Code Review: OpenStack](https://arxiv.org/abs/2103.11446) — how maintainers discuss code smells in two projects.
- [Code Review Effectiveness: An Empirical Study on Selected Factors](https://doi.org/10.1049/iet-sen.2020.0134) — factors associated with review effectiveness.
- [A Survey of Code Review Benchmarks and Evaluation Practices in the Pre-LLM and LLM Era](https://arxiv.org/abs/2602.13377) — recent benchmark and evaluation landscape; research is rapidly evolving.

## Incident reports and real-world engineering cases

- [Cloudflare: Details of the July 2, 2019 outage](https://blog.cloudflare.com/details-of-the-cloudflare-outage-on-july-2-2019/)
- [Cloudflare: July 17, 2020 outage](https://blog.cloudflare.com/cloudflare-outage-on-july-17-2020/)
- [Cloudflare: June 21, 2022 outage](https://blog.cloudflare.com/cloudflare-outage-on-june-21-2022/)
- [Cloudflare: October 30, 2023 incident](https://blog.cloudflare.com/cloudflare-incident-on-october-30-2023/)
- [GitHub: October 21, 2018 post-incident analysis](https://github.blog/news-insights/company-news/oct21-post-incident-analysis/)

## Persian-language reading

Persian resources differ in date, depth, and editorial method. Use them as approachable introductions; verify security, platform behavior, and standards against primary English sources.

- [Todayino: Code Review for beginners](https://emrozino.ir/article/code-review-beginners-guide)
- [Netparadis: Reading and reviewing other people's code](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
- [Sauleh: Persian Code Review guide (PDF)](https://www.sauleh.ir/ap97/static_files/AP97982-CodeReviewGuide.V.1.3.pdf)
- [Hheydarian / Gitab: Review process and importance](https://hheydarian.github.io/Gitab/books/book2/Book/02/Code-Review-Process-and-Importance/)
- [Pro-nee: Secure Code Review in Persian](https://pro-nee.net/terms/secure-code-review/)
- [Javacup: Different code review methods](https://javacup.ir/code-review-methods/)
- [Anophel: Why code reviews become slow](https://anophel.com/articles/the-reason-of-slow-code-reviews)
- [Hamed Lotf: A comprehensive Code Review guide](https://hamedlotf.ir/blog/code-review-guide)
- [DNTips: Code Review article collection (PDF)](https://www.dntips.ir/exports/newstag/www.dntips.ir-newstag-77.pdf)

## How to read research and postmortems

For every empirical claim, ask: Which organization or projects were studied? What data and time period? How was “useful,” “defect,” or “effective” defined? What limitations do the authors state? A postmortem is first-party evidence of what its authors reported, not proof that a generic code review rule would have prevented the incident. Record **reported fact**, **your inference**, and **proposed control** separately.
