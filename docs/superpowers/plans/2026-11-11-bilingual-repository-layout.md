# Bilingual Roadmap Layout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` or `superpowers:subagent-driven-development` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move all Persian learning material under `fa/` and all English learning material under `en/`, with matching course slugs and working internal links.

**Architecture:** Keep eleven course trees mirrored beneath the two locale roots. Move neutral assets, workflow records, scripts, and plans into their own repository-level locations. Generate one old-to-new path map, apply it to the file moves and Markdown links, then audit the resulting tree against the current 754 README pages per language.

**Tech Stack:** Git, Node.js standard library for path mapping and link rewrites, Markdown.

**Spec:** `docs/superpowers/specs/2026-11-11-bilingual-repository-layout.md`

## Global Constraints

- Keep all eleven course slugs identical under `fa/` and `en/`.
- Preserve the current baseline of 754 Persian and 754 English course README pages.
- Do not rewrite, translate, shorten, or remove lesson content, quizzes, references, or examples.
- Keep Markdown and HTTP/JavaScript assets with their actual language edition; move only neutral assets to `shared/`.
- Rewrite local paths and preserve link fragments and query strings; leave external URLs unchanged.
- Keep root `.gitignore`; do not execute translation or topic-generation scripts.
- Do not change GitHub access, integrations, repository visibility, or account settings.
- Treat `internal/workflow-artifacts/` as historical snapshots. When a copied lesson excerpt has a relative link with no unique source-page context, preserve the record and report it separately instead of guessing a new target.

## Review Focus

- **Language classification:** `README.en.md`, nested `en/`, and localized `.en.*` assets must land only in the English tree; other course pages must land only in Persian.
- **Destination collisions:** case folding and suffix normalization must not overwrite two different source files.
- **Relative links:** links to sibling lessons, parent indexes, directories, anchors, and the other language must resolve after the move.
- **Executable assets:** each localized HTTP or seed file must stay beside its matching lab; neutral assets must have a shared destination.
- **Support artifacts:** plans, progress notes, and helper scripts must remain available outside learner-facing course trees.

---

### Task 1: Generate and review a migration map

**Files:**
- Create temporarily: migration utility outside the tracked course content.
- Read: all tracked files under the eleven existing course roots, `docs/`, `.superpowers/`, and `en/.superpowers/`.

**Interfaces:**
- Consumes: the current Git-tracked file paths and the source-to-slug map in the design specification.
- Produces: a deterministic source path → destination path map plus a collision and unclassified-file report.

- [x] **Step 1: Inventory the source paths and classify each file.**
  - Expected: every tracked course file has exactly one language and one destination; scripts and workflow artifacts have explicit non-course destinations.
- [x] **Step 2: Run the migration utility in dry-run mode.**
  - Expected: zero destination collisions, zero unclassified course files, and counts of 754 README pages per language.
- [x] **Step 3: Review every non-Markdown path in the map.**
  - Expected: both Elasticsearch HTTP examples, both MongoDB seed files, both temporary course scripts, the translator, and the shared-reference marker each have an intentional destination.

### Task 2: Move the eleven course trees into locale roots

**Files:**
- Create: `fa/<course-slug>/...` and `en/<course-slug>/...` for all eleven slugs.
- Move: all current course Markdown and localized assets to the mapped paths.

**Interfaces:**
- Consumes: the reviewed migration map from Task 1.
- Produces: parallel Persian and English course trees with normalized `README.md` filenames.

- [x] **Step 1: Create the locale roots and course directories from the map.**
  - Expected: `fa/` and `en/` contain the same eleven course slugs.
- [x] **Step 2: Move each mapped course file without changing its text.**
  - Expected: the per-course Persian and English README counts match the pre-migration inventory.
- [x] **Step 3: Place language-specific HTTP, JavaScript, and lesson assets with their edition.**
  - Expected: each lab keeps its localized filename and relative organization.

### Task 3: Separate shared material and workflow artifacts

**Files:**
- Create: `shared/README.md`, `shared/references/`, `shared/assets/`, `tools/`, and `internal/` subdirectories as required by the map.
- Move: `docs/superpowers/` remains the maintained design/plan area; `.superpowers/`, `en/.superpowers/`, course-local temporary scripts, the translator script, and `references/.gitkeep` move to their specified shared, tools, or internal locations.

**Interfaces:**
- Consumes: the non-course destinations in the migration map.
- Produces: clear locations for language-neutral assets, repository utilities, and non-learning workflow notes.

- [x] **Step 1: Move workflow and review artifacts under `internal/workflow-artifacts/`.**
  - Expected: task briefs, reports, progress notes, and review packages remain present and retain their workstream grouping.
- [x] **Step 2: Move helper scripts under `tools/` or `internal/scripts/`.**
  - Expected: no helper script remains at a course root; the translation helper is marked for the new locale layout and is never run during migration.
- [x] **Step 3: Move the shared-reference marker and create the shared-assets guide.**
  - Expected: `shared/README.md` explains what belongs in `shared/`; existing language-specific assets remain under `fa/` or `en/`.

### Task 4: Rewrite links and add locale catalogs

**Files:**
- Create: `fa/README.md`, `en/README.md`, and the root bilingual entry pages.
- Modify: local Markdown and HTML links in course pages, `docs/superpowers/`, and repository guides.

**Interfaces:**
- Consumes: the final destination map from Tasks 1–3.
- Produces: Persian and English catalogs that link to matching course indexes; every rewritten local link uses the final layout.

- [x] **Step 1: Rewrite local link targets using the destination map.**
  - Expected: resolvable learner-facing relative links preserve fragments and queries, and cross-language links point to the translated counterpart; ambiguous historical workflow links are reported separately.
- [x] **Step 2: Write matching `fa/README.md` and `en/README.md` catalogs.**
  - Expected: both catalogs list the same eleven courses with language-correct entry links and recommended learning routes.
- [x] **Step 3: Update root `README.md` and `README.en.md` as language-selection pages.**
  - Expected: readers can reach the Persian catalog or English catalog from the repository home page.
- [x] **Step 4: Update maintained plans and design documents to current paths.**
  - Expected: `docs/superpowers/` no longer points readers to removed course roots.

### Task 5: Audit, commit, and push the reorganization

**Files:**
- Review: all moved paths and rewritten Markdown links.
- Commit: the completed language-layout migration.

**Interfaces:**
- Consumes: the two locale trees, shared/internal locations, and updated indexes.
- Produces: one pushed commit on `main` with local and remote heads aligned.

- [x] **Step 1: Compare source and destination inventories.**
  - Expected: all source files are accounted for and all eleven course README counts remain 754 Persian and 754 English.
- [x] **Step 2: Audit local Markdown and HTML destinations.**
  - Expected: no missing local target remains in course pages, catalogs, repository entry pages, or maintained `docs/superpowers/` guides; report any ambiguous historical workflow links separately.
- [x] **Step 3: Review the final Git diff for text changes outside path rewrites.**
  - Expected: course prose and examples are unchanged.
- [ ] **Step 4: Commit the reorganization and push `main`.**
  - Expected: `origin/main` matches local `HEAD`, and the worktree is clean.
