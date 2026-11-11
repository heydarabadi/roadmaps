# Go Self-Study Course Expansion Plan

> **For agentic workers:** Implement this plan in the current Codex session; track the phases below and do not stop for routine clarification.

**Goal:** Turn the GoLang folder into a thorough Persian self-study course that teaches every Roadmap.sh Go topic from first principles through practical use.

**Architecture:** Keep the existing 14-chapter / 27-topic hierarchy. Expand each topic README using a common teaching structure, then add course-level practice projects, glossary, study route, and source/version guidance. The local lessons should contain the knowledge needed for the roadmap; online links serve as current references and deeper reading.

**Tech Stack:** Persian RTL Markdown, Go examples, official Go docs as technical authority, selected Persian instructional material and primary engineering case studies.

**Spec:** User request in the active Codex chat on 2026-11-10.

## Global Constraints

- Preserve the existing `D:\Learn\Roadmap\GoLang` hierarchy and roadmap coverage.
- Write Persian explanations right-to-left; keep Go code and commands copyable left-to-right.
- Treat Go 1.27.4 as the current toolchain release and Go 1.27 as the language baseline as of 2026-11-11; annotate version-sensitive features.
- Explain concepts locally so external sources are supplementary; do not claim an education file eliminates all need for official references.
- Do not run tests or compile every sample unless explicitly requested; snippets must be labeled if not standalone.
- Distinguish documented engineering case studies from hypothetical practice scenarios.

## Review Focus

- Every Roadmap.sh node remains covered by the topic pages and `ROADMAP-MAP.md`.
- Code that relies on version-specific or external packages is labeled with requirements.
- Quiz answer keys are complete, accurate, and separated from questions.
- Persian resources and real-world claims are linked to the relevant direct source when available.
- The course remains navigable without a network connection except for linked optional reading.

---

### Task 1: Course structure and current source baseline

**Files:** `README.md`, `ROADMAP-MAP.md`, `SOURCES-AND-CASES.md`, this plan.

- [x] Create a phase plan and common lesson contract.
- [x] Update version and self-study expectations in the index.
- [x] Add a learning sequence and note on snippets / optional references.

### Task 2: Foundations and language model

**Files:** topics in chapters 01–04.

- [x] Expand all 11 lessons with prior knowledge, mental model, syntax walkthrough, examples, pitfalls, guided exercises with solutions, and at least 8 quiz questions with a separated key.

### Task 3: Types, APIs, packages, and failure handling

**Files:** topics in chapters 05–08.

- [x] Teach pointers/GC, methods/interfaces, generics, package/module workflow, error chains, panic/defer/recover in depth.

### Task 4: Concurrency and tests

**Files:** topics in chapters 09–10.

- [x] Add ownership/lifecycle, cancellation, backpressure, synchronization, race reasoning, test design, fuzzing and benchmark interpretation.

### Task 5: Standard library, ecosystem, tools, and advanced topics

**Files:** topics in chapters 11–14.

- [x] Expand standard-library recipes, HTTP/RPC/database/CLI boundaries, tooling/security/deployment, diagnostics, cgo/unsafe/reflection tradeoffs.

### Task 6: Course-level practice and review

**Files:** root index, roadmap map, sources, new project/glossary files.

- [x] Add three stepwise projects integrating the roadmap topics, a glossary, and a 12-week offline learning route.
- [x] Audit roadmap mapping, all 27 quiz/key pairs, all internal Markdown links, bilingual source sections, version notes, and final file inventory.

### Task 7: Complete English edition and expanded reading list

**Files:** English edition of every learner-facing lesson, chapter index, project, roadmap map, source catalog, study route, glossary, and course index.

- [x] Create English editions for all 27 lessons, 14 chapter indexes, three projects, and four course support references.
- [x] Add navigation in both directions between Persian and English versions.
- [x] Expand topic references and engineering case studies; keep the bibliography selected and evidence limits explicit.
- [x] Audit English quizzes, answer keys, local links, wrappers, code fences, and file inventory.

### Review record — 2026-11-11

- 27 topic lesson READMEs were counted; each quiz has at least 8 numbered questions and an equal number of numbered answers.
- Static local-link audit passed for all Markdown files after fenced code blocks were excluded.
- 50 English Markdown files were counted: the root index, 14 chapter indexes, 27 topic lessons, three project guides plus project index, and four course reference documents. Each of the 50 paired Persian documents links to its English edition.
- The English edition contains 30 quiz/answer-key pairs across 27 lessons and three project guides: 417 numbered questions and 417 numbered answers. Each quiz page has at least 10 questions; lesson/project references have at least six direct external links per page.
- The English pages link to 210 unique external URLs. These are selected official documentation, articles, papers, and engineering reports, not an exhaustive crawl of the internet.
- Static local-link audit passed across all 101 Markdown files. English/Persian wrapper tags and code fences are balanced.
- The 14 course chapter indexes exist; three guided project folders, one glossary, one 12-week route, and the source catalog are present.
- No Go sample was compiled or test suite run. This review verifies document structure and links, not the executable behavior of every example.

## Completion contract

- All 27 topic READMEs materially expanded; each has 8+ questions plus answers and self-contained explanations.
- All learner-facing course materials are available in Persian and English with reciprocal navigation.
- Every official roadmap node is accounted for; the index links every chapter/topic.
- At least three guided projects, a glossary, and a project-based progression are available locally.
- No claim of “the whole internet” or universal completeness; update and official-reference guidance is explicit.
