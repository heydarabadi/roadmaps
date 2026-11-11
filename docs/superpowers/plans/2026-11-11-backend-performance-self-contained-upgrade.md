# Backend Performance Self-Contained Course Upgrade

> **Current repository location:** the Persian edition now lives under `fa/backend-performance/` and the English edition under `en/backend-performance/`. This plan records the completed course upgrade before the repository-wide language split; the current layout normalizes both editions to `README.md` at each matching path.

> **For agentic workers:** Execute by parallel chapter authorship, followed by an independent content review and one integration audit. The user has already selected subagent-driven work and authorized execution.

**Goal:** Upgrade all 44 topic guides into self-contained Persian lessons with complete English editions and expanded curated references, so neither language depends on external reading for core understanding.

**Architecture:** Preserve every existing Persian README and add a sibling `README.en.md` for each of the 55 existing root, chapter, and topic README files. Work in four disjoint chapter groups, then cross-review the edits and perform a root-level consistency and navigation audit. The course remains language- and vendor-independent.

**Tech Stack:** Markdown only; use Persian instructional prose, RTL wrappers, and LTR blocks for code, protocols, formulas, and identifiers.

**Spec:** `docs/superpowers/specs/2026-11-10-backend-performance-learning-pack-design.md`, extended by the active user goal in this conversation.

## Global Constraints

- Keep the requested directory spelling `Backend Performace` and preserve the existing 55 README paths.
- Add exactly 55 English siblings named `README.en.md`: one at the course root, ten in chapter directories, and one in every topic directory.
- English editions are full lessons, not summaries; preserve the technical explanation, worked examples, exercises/solutions, quiz/answers, evidence limits, and navigation from the Persian edition.
- Every Persian and English edition must be discoverable from its parent index by a clear language link.
- Every topic guide must teach prerequisites or define them in place; no essential explanation may exist only behind a link.
- Write original explanations; do not translate or reproduce external articles wholesale.
- Retain language-independent examples and qualify vendor-, language-, product-, and version-specific behavior.
- Keep real production evidence distinct from teaching examples; do not invent company outcomes or performance numbers.
- Preserve the 5–8 quiz questions per topic and provide in-page answers with reasoning.
- External links are optional enrichment and technical provenance, not assigned reading needed to understand or complete a lesson.
- Expand each topic's optional references to at least five distinct, relevant resources when credible sources are available: aim for four English technical/first-party references and at least one genuinely relevant Persian source; label a Persian-source gap rather than adding filler.
- Do not add or run software tests. Use read-only document audits only: coverage, internal links, teaching sections, quiz/answer alignment, and consistency.
- Workspace is not a Git repository; do not initialize Git or make commits.

## Review Focus

- **Hidden prerequisite:** a learner cannot follow a lesson without another page or external link. Review: inspect each topic's opening and all terms used in its core explanation.
- **Unworked advice:** a recommendation has no causal explanation or concrete example. Review: confirm each topic has a reasoned worked example, not just a claim.
- **Unusable exercises:** a lab has no expected result or explanation. Review: compare every exercise to its in-page answer or expected output.
- **Evidence inflation:** illustrative scenarios sound like measured production results. Review: check labels and attributions against linked first-party evidence.
- **Shallow coverage from batch editing:** a group received boilerplate additions rather than topic-specific teaching. Review: inspect representative pages from every topic and ensure each addition addresses its mechanism, decisions, and failure modes.

---

## Topic Lesson Acceptance Contract

Each of the 44 topic READMEs must be usable as the sole lesson for that topic. Keep existing accurate material and deepen where needed; do not pad pages just to reach a word count. The reader should be able to learn without opening links. Each guide must clearly teach:

1. What the concept is, which problem it solves, and how it relates to the whole request/data path.
2. Any prerequisite terms and the causal mechanism, step by step, with an accurate mental model.
3. How to decide when to use it, when not to, and what it costs or changes.
4. At least one complete worked example, showing assumptions, intermediate steps or calculations, and how to interpret the result. Use a second edge case where it materially changes the decision.
5. A language-neutral procedure, pseudocode, SQL, HTTP exchange, formula, or configuration only when it makes the mechanism easier to understand; explain every non-obvious line/field.
6. Failure modes and an actionable debugging sequence: what to observe, what signal suggests which cause, and what to inspect next.
7. A practical exercise with an expected result and a worked solution or reasoning path.
8. The existing mixed 5–8 question quiz and explained answers, with every answer derivable from the page.
9. A short recap and optional references clearly labeled as additional reading / authoritative provenance, never required to understand the lesson.
10. A faithful, full English companion as the corresponding `README.en.md`, translated from the finished Persian lesson and independently checked for technical equivalence.

Do not force identical headings if a topic's teaching flow works better another way. A quick self-contained prerequisite box, concept map, comparison table, walkthrough, decision tree, or FAQ may be added where useful. Keep cases accurate and linkable.

## Parallel Work Groups

### Task 1: Chapters 01–03 — Caching, API Response, Asynchronism

**Files:** all README files under `Backend Performace/01-caching/`, `02-api-response/`, and `03-asynchronism/`; their `README.en.md` companions; English companions for the four topic pages and index under `08-security/` after its Persian content is stabilized.

- [x] Read every topic and chapter index in the assigned directories.
- [x] Deepen each topic to the acceptance contract, preserving accurate sources, evidence, quizzes, and cross-links.
- [x] Update the three chapter indexes to state that each topic is taught in-page and external sources are optional.
- [x] Create full English companions for each assigned Persian chapter/topic index and lesson, then the stable English-only 08-security companions; link both language variants in navigation.
- [x] Ensure topic resource lists meet the expanded-reference target where relevant sources exist.
- [x] Return a list of touched paths, topic-specific teaching improvements, uncertain technical claims, and a self-review result.

### Task 2: Chapters 04–05 — Databases, Load Balancing and Scaling

**Files:** all README files under `Backend Performace/04-databases/` and `05-load-balancing-and-scaling/`; their `README.en.md` companions; root `Backend Performace/README.en.md`.

- [x] Read every topic and chapter index in the assigned directories.
- [x] Deepen each topic to the acceptance contract, preserving accurate sources, evidence, quizzes, and cross-links.
- [x] Update both chapter indexes to state that each topic is taught in-page and external sources are optional.
- [x] Create full English companions for each assigned Persian chapter/topic index and lesson, plus the stable English root guide; link both language variants in navigation.
- [x] Ensure topic resource lists meet the expanded-reference target where relevant sources exist.
- [x] Return a list of touched paths, topic-specific teaching improvements, uncertain technical claims, and a self-review result.

### Task 3: Chapters 06–07 — Code Optimization, Monitoring and Logging

**Files:** all README files under `Backend Performace/06-code-optimization/` and `07-monitoring-and-logging/`; their `README.en.md` companions; English companions for the stable 09-performance-testing and 10-network indexes and topic lessons.

- [x] Read every topic and chapter index in the assigned directories.
- [x] Deepen each topic to the acceptance contract, preserving accurate sources, evidence, quizzes, and cross-links.
- [x] Update both chapter indexes to state that each topic is taught in-page and external sources are optional.
- [x] Create full English companions for each assigned Persian chapter/topic index and lesson, then the stable English-only 09–10 companions; link both language variants in navigation.
- [x] Ensure topic resource lists meet the expanded-reference target where relevant sources exist.
- [x] Return a list of touched paths, topic-specific teaching improvements, uncertain technical claims, and a self-review result.

### Task 4: Chapters 08–10 and Root — Security, Performance Testing, Network

**Files:** Persian README files under `Backend Performace/08-security/`, `09-performance-testing/`, and `10-network/`; root `Backend Performace/README.md`.

- [x] Read every topic and chapter index in the assigned directories and the root README.
- [x] Deepen each topic to the acceptance contract, preserving accurate sources, evidence, quizzes, and cross-links.
- [x] Update the three chapter indexes and root study guidance so external pages are optional enrichment only.
- [x] Add Persian-to-English language-switch links for the root, assigned chapter indexes, and every topic lesson; English companions are created in Tasks 1–3.
- [x] Ensure topic resource lists meet the expanded-reference target where relevant sources exist.
- [x] Return a list of touched paths, topic-specific teaching improvements, uncertain technical claims, and a self-review result.

### Task 5: Independent review and integration

**Files:** all 110 README files under `Backend Performace/` (review first; edit only if an actionable gap is found).

- [x] Review representative and weak/short topic pages from all ten chapters against the acceptance contract; report any topic needing specific correction.
- [x] Resolve review findings with targeted edits and re-check only affected pages.
- [x] Count the Persian and English editions: 55 Persian `README.md` and 55 English `README.en.md`; compare the topic set with the approved 44-topic inventory.
- [x] Spot-check English translations against the Persian technical content, quiz answer keys, exercises, and evidence caveats.
- [x] Check internal Markdown links and confirm quizzes, answers, exercises, sources, and RTL/LTR wrappers remain structurally sound.
- [x] Report what the review establishes and any limits (no rendered-browser review, no exercise execution, no live retesting of every external source).

