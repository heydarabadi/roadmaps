# Bilingual Repository Layout Design

## Intent

Give Persian and English learning materials a consistent physical home across the Roadmap repository. A reader should be able to enter through `fa/` or `en/`, choose the same course slug in either language, and follow a course without needing to know its historical folder name or language-file convention.

## Current state

- The repository contains eleven learning paths. Their lesson README inventories are paired: 754 Persian README pages and 754 English README pages.
- Course folders currently sit at the repository root. English lessons use a mix of sibling `.en.md` files and nested `en/` directories.
- Course folder names and README casing vary. Some paths contain spaces or legacy spelling.
- A few executable assets have language-specific variants. Repository-level plans, review artifacts, and helper scripts are mixed with learning material.

## Goals

1. Place Persian course content under `fa/<course-slug>/` and English course content under `en/<course-slug>/`.
2. Use the same lowercase kebab-case course slugs in both language trees:
   - `backend-performance`
   - `code-review`
   - `data-structures-and-algorithms`
   - `elasticsearch`
   - `go`
   - `kubernetes`
   - `mongodb`
   - `redis`
   - `software-architecture`
   - `software-design-and-architecture`
   - `system-design`
3. Use `README.md` for the index at the root of each course in both language trees. Keep chapter and topic folder structure parallel where a matching lesson exists.
4. Add `fa/README.md` and `en/README.md` as language catalogs. Keep short root `README.md` and `README.en.md` entry pages that route readers to those catalogs.
5. Rewrite local Markdown and HTML links to the new paths, preserving anchors, query strings, and link text. Keep external URLs unchanged.
6. Preserve all existing course text, quizzes, references, examples, and assets. Normalize filenames only when moving language variants into their locale tree, such as moving `README.en.md` to `en/.../README.md`.
7. Separate non-course material into clear repository-level locations:
   - `shared/` for language-neutral references and assets.
   - `tools/` for maintained repository utilities.
   - `docs/` for maintained plans and design specifications.
   - `internal/` for workflow/review artifacts and legacy helper scripts.
8. Preserve distinct localized assets in their corresponding language tree. Move only demonstrably shared assets to `shared/`.

## Non-goals

- Rewrite, translate, expand, or summarize lesson content.
- Change roadmap scope, source claims, quizzes, labs, or project requirements.
- Change GitHub repository settings, visibility, integrations, or access permissions.
- Remove artifacts or examples merely because they are internal or temporary; move and label them.

## Layout

```text
.
├── README.md
├── README.en.md
├── fa/
│   ├── README.md
│   ├── backend-performance/README.md
│   └── ... ten other course roots
├── en/
│   ├── README.md
│   ├── backend-performance/README.md
│   └── ... ten other course roots
├── shared/
│   ├── README.md
│   ├── references/
│   └── assets/
├── tools/
├── docs/superpowers/
└── internal/
    ├── scripts/
    └── workflow-artifacts/
```

Each locale catalog links to every course index in that locale and links to the matching course in the other locale. Root entry pages summarize the repository and direct readers to the language catalogs.

## Migration rules

- Classify Markdown as English when it is under an existing course `en/` subtree or uses an `.en.md` suffix. All remaining course Markdown is Persian. Confirm ambiguous pages by reading their language before moving them.
- Remove the `.en` segment from an English filename only inside the English tree; retain the source basename and extension otherwise.
- Place a language-tagged executable asset with that language. Keep neutral assets in `shared/assets/<course-slug>/` only when both language editions use the same asset or it has no user-facing language.
- Keep maintained plans and design specifications under `docs/superpowers/` and update their course paths.
- Move progress and review artifacts under `internal/workflow-artifacts/`, preserving the workstream grouping.
- Move helper scripts under `tools/` or `internal/scripts/`. Do not run translation or generation scripts during the migration.
- Build the complete old-to-new path map before moving anything. Apply the map to file moves and link updates, then audit the final layout. Do not infer a destination from a guessed path when a target has no unique mapping.
- Keep `.gitignore` at the repository root. Move only the existing empty shared-reference marker into `shared/references/`.

## Acceptance conditions

- All eleven courses exist under both `fa/` and `en/` with matching slugs.
- The Persian and English course README counts remain 754 each; no course file is lost.
- Each language catalog links to all eleven corresponding course indexes.
- All local relative Markdown and HTML links in course pages resolve to the moved file or directory and retain their fragment where present.
- Cross-language links point to the corresponding translated page.
- External links and lesson text remain unchanged except for paths that refer to moved repository files.
- Shared files, internal artifacts, scripts, and root Git configuration are accounted for in the new structure.
- The Git worktree has no accidental deletions or untracked migration leftovers.
