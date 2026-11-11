[فارسی](../fa/README.md) | **English**

# Roadmap Learning Library

This repository brings together eleven self-study paths covering programming, data structures and algorithms, databases, system design, software architecture, and software operations. Each path has its own folder and starting index. Choose a course from the catalog below, then follow that course's guide for chapter order, prerequisites, labs, and references.

All eleven learning paths have mirrored Persian and English editions. Persian lessons live under `fa/`, and their English counterparts live under `en/`. Both trees use the same course slugs, and every course entry page is named `README.md`. The links below point directly to each course index.

## Course catalog

| Area | Learning path | Main focus | فارسی | English |
|---|---|---|---|---|
| Programming foundations | Go | Go language, tooling, concurrency, testing, and projects | [شروع فارسی](../fa/go/README.md) | [English course](go/README.md) |
| Computer science foundations | Data Structures and Algorithms | Data structures, algorithms, complexity, and problem solving | [شروع فارسی](../fa/data-structures-and-algorithms/README.md) | [English course](data-structures-and-algorithms/README.md) |
| Design and architecture | Software Design and Architecture | Design principles, patterns, architecture styles, and a capstone | [شروع فارسی](../fa/software-design-and-architecture/README.md) | [English course](software-design-and-architecture/README.md) |
| Design and architecture | Software Architecture | Architect responsibilities, principles, patterns, enterprise architecture, and evaluation | [شروع فارسی](../fa/software-architecture/README.md) | [English course](software-architecture/README.md) |
| System design | System Design | Scalability, storage, communication, resilience, and service design | [شروع فارسی](../fa/system-design/README.md) | [English course](system-design/README.md) |
| Data and search | Elasticsearch | Data modeling, indexing, search, analytics, and operations | [شروع فارسی](../fa/elasticsearch/README.md) | [English course](elasticsearch/README.md) |
| Databases | MongoDB | Document modeling, operations, performance, security, and projects | [شروع فارسی](../fa/mongodb/README.md) | [English course](mongodb/README.md) |
| Data and storage | Redis | Data structures, persistence, replication, security, and operations | [شروع فارسی](../fa/redis/README.md) | [English course](redis/README.md) |
| Platform and infrastructure | Kubernetes | Containers, workloads, networking, configuration, security, and cluster operations | [شروع فارسی](../fa/kubernetes/README.md) | [English course](kubernetes/README.md) |
| Performance and operations | Backend Performance | Caching, databases, concurrency, networking, measurement, and optimization | [شروع فارسی](../fa/backend-performance/README.md) | [English course](backend-performance/README.md) |
| Engineering practice | Code Review | Change preparation, review, feedback, follow-up, and PR workflows | [شروع فارسی](../fa/code-review/README.md) | [English course](code-review/README.md) |

## Where to start

You do not need to read every path in repository order. Pick one goal and work through the relevant course.

- **New to programming:** Start with Go to learn a language and its tooling, then study data structures and algorithms.
- **Backend development:** Review data structures and algorithms as needed, choose a database related to your project, then study Backend Performance and System Design. Go complements paths that use Go.
- **Architecture and design:** Start with Software Design and Architecture, then use Software Architecture and System Design for broader service and system decisions.
- **Platform and operations:** Start with Kubernetes, then use Backend Performance and System Design to reason about capacity, bottlenecks, and resilience.
- **Engineering quality:** Practice Code Review alongside any other path using small, reviewable changes.

Prerequisites and difficulty are documented in each course index. Some chapters expect familiarity with programming, HTTP, networking, or SQL.

## Study method

1. Open the Persian or English course index and review its prerequisites, coverage map, and chapter sequence.
2. Follow the course guide. Glossaries, labs, sample projects, and roadmap coverage maps live with the course.
3. Rewrite or run the examples yourself. For quizzes, write your answer and reasoning before reading the answer key.
4. Complete exercises and capstones with explicit assumptions and constraints. Run lab instructions only in a learning environment.
5. Check official product documentation for version-specific behavior. Linked articles and engineering case studies are further reading.

Depending on the topic, lessons may include step-by-step explanations, worked examples, real-world scenarios, common pitfalls, exercises, answer-explained quizzes, and Persian and English sources. Each course index describes the contents of that course.

## Repository structure

```text
.
├── README.md                         # Language selector and short guide
├── README.en.md                      # Direct English entry page
├── fa/
│   ├── README.md                     # Persian course catalog
│   └── <course-slug>/                # Eleven courses with shared slugs
├── en/
│   ├── README.md                     # English course catalog
│   └── <course-slug>/                # The same eleven courses in English
├── shared/
│   ├── README.md                     # Shared-content convention
│   └── references/                  # References used across courses
├── docs/superpowers/                 # Maintained plans and specifications
├── tools/                            # Repository utilities
└── internal/
    ├── scripts/                      # Maintenance scripts
    └── workflow-artifacts/           # Process reports and review records
```

The names `fa/` and `en/` have one meaning throughout the repository: Persian and English. Each course has the same slug in both trees. Chapters, topics, labs, glossaries, and course-specific references stay inside their language edition. For example, `fa/kubernetes/` and `en/kubernetes/` are the two editions of the same path. Every course entry page uses the filename `README.md`.

`docs/superpowers/` contains maintained plans and specifications, including the [Backend Performance learning-pack plan](../docs/superpowers/plans/2026-11-10-backend-performance-learning-pack.md), [self-contained learning upgrade plan](../docs/superpowers/plans/2026-11-11-backend-performance-self-contained-upgrade.md), and [design specification](../docs/superpowers/specs/2026-11-10-backend-performance-learning-pack-design.md). Historical execution and review records live under `internal/workflow-artifacts/` and are outside the learning routes. Technology-specific references stay with their course; `shared/references/` is reserved for material genuinely shared by multiple courses.

`tools/translate_architecture_en.legacy.ps1` is a utility from the previous layout. It deliberately stops with a notice so it cannot overwrite the separated course editions. Edit and maintain learning material directly in the appropriate `fa/` or `en/` tree.

## Languages and naming

- The course entry page is `README.md` in both editions; its parent directory identifies the language.
- Find an English lesson under `en/<course-slug>/` at the same relative path as its Persian counterpart under `fa/<course-slug>/`.
- Follow each course index to its chapter and topic pages; folder depth and names vary by course.
- Keep internal links relative and within the same language tree. For a cross-language link, point to the matching page in the other locale tree.
- For version-sensitive lessons and references, record the version or review date and link to official documentation.

## Tools and examples

No special software is needed to read the repository; most content is Markdown. Executable tools are required only for some labs. Read the lab prerequisites before installing or running them. Run cluster, database, and infrastructure examples in a personal or test environment, never against production.

`.gitignore` excludes local secrets such as `.env` files and private-key formats, along with operating-system files, from accidental Git tracking. Use fabricated values and non-sensitive example files for configuration samples.

## Maintenance and contributions

- Treat each course index as the source of truth for that course's chapter and lesson order.
- When adding a lesson, update its course index, chapter links, and topic links; check relative paths.
- Keep the Persian and English editions aligned when changing lesson content.
- Record the title, publisher or author, and exact URL for external sources; do not copy full articles.
- Document practical examples with prerequisites, sample input, expected output, and environment cleanup.
- State version-sensitive claims, source limitations, and review dates clearly.

## Scope and freshness

This repository is a library of learning paths and exercises, not one mandatory curriculum. Check each course README for its sequence and coverage. Roadmaps and products evolve; verify operational decisions and version-specific behavior against the relevant official source.
