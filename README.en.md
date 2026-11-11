[فارسی](README.md) | **English**

# Roadmap Learning Library

This repository brings together eleven self-study paths covering programming, data structures and algorithms, databases, system design, software architecture, and software operations. Each path has its own folder and starting index. Choose a course from the catalog below, then follow that course's guide for chapter order, prerequisites, labs, and references.

All eleven learning paths have Persian and English editions. Depending on the course, its English entry point is either a sibling `README.en.md` file or a page inside an `en/` directory. The links below point to the correct entry point for each language.

## Course catalog

| Area | Learning path | Main focus | فارسی | English |
|---|---|---|---|---|
| Programming foundations | Go | Go language, tooling, concurrency, testing, and projects | [شروع فارسی](./GoLang/README.md) | [English course](./GoLang/README.en.md) |
| Computer science foundations | Data Structures and Algorithms | Data structures, algorithms, complexity, and problem solving | [شروع فارسی](./data%20structure%20and%20algorithm/readme.md) | [English course](./data%20structure%20and%20algorithm/readme.en.md) |
| Design and architecture | Software Design and Architecture | Design principles, patterns, architecture styles, and a capstone | [شروع فارسی](./Software%20Design%20and%20Architecture/README.md) | [English course](./Software%20Design%20and%20Architecture/en/README.md) |
| Design and architecture | Software Architecture | Architect responsibilities, principles, patterns, enterprise architecture, and evaluation | [شروع فارسی](./Software%20Architecture/README.md) | [English course](./Software%20Architecture/en/README.md) |
| System design | System Design | Scalability, storage, communication, resilience, and service design | [شروع فارسی](./system%20design/README.md) | [English course](./system%20design/en/README.md) |
| Data and search | Elasticsearch | Data modeling, indexing, search, analytics, and operations | [شروع فارسی](./ElasticSearch/README.md) | [English course](./ElasticSearch/README.en.md) |
| Databases | MongoDB | Document modeling, operations, performance, security, and projects | [شروع فارسی](./mongodb/readme.md) | [English course](./mongodb/en/readme.md) |
| Data and storage | Redis | Data structures, persistence, replication, security, and operations | [شروع فارسی](./redis/README.md) | [English course](./redis/README.en.md) |
| Platform and infrastructure | Kubernetes | Containers, workloads, networking, configuration, security, and cluster operations | [شروع فارسی](./kubernetes/README.md) | [English course](./kubernetes/README.en.md) |
| Performance and operations | Backend Performance | Caching, databases, concurrency, networking, measurement, and optimization | [شروع فارسی](./Backend%20Performace/README.md) | [English course](./Backend%20Performace/README.en.md) |
| Engineering practice | Code Review | Change preparation, review, feedback, follow-up, and PR workflows | [شروع فارسی](./Code%20Review/README.md) | [English course](./Code%20Review/en/README.md) |

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
├── README.md                         # Main Persian guide
├── README.en.md                      # Main English guide
├── Backend Performace/               # Backend performance
├── Code Review/                      # Code review
├── data structure and algorithm/     # Data structures and algorithms
├── ElasticSearch/                    # Search and analytics
├── GoLang/                           # Go language and ecosystem
├── kubernetes/                       # Container orchestration and cluster operations
├── mongodb/                          # Document database
├── redis/                            # In-memory data store
├── Software Architecture/            # Software architecture
├── Software Design and Architecture/ # Software design and architecture
├── system design/                    # Distributed system design
├── docs/superpowers/                 # Content plans and specifications
├── references/                       # Repository-wide shared references
├── en/.superpowers/                  # English review notes
└── .superpowers/                     # Workflow artifacts and review notes
```

The root README of each course is its entry point; chapters, topics, labs, and references live under that course folder. The current course paths are preserved so relative links inside lessons and projects remain valid. Some English editions use `en/`, while others place `.en.md` files beside Persian pages.

`docs/superpowers/` contains plans and specifications for selected courses: the [Backend Performance learning-pack plan](./docs/superpowers/plans/2026-11-10-backend-performance-learning-pack.md), [self-contained learning upgrade plan](./docs/superpowers/plans/2026-11-11-backend-performance-self-contained-upgrade.md), and [design specification](./docs/superpowers/specs/2026-11-10-backend-performance-learning-pack-design.md). `.superpowers/` and `en/.superpowers/` contain planning, progress, and review artifacts; they are not course entry points. Technology-specific sources stay with their course. The repository-level `references/` directory is intended for sources shared by multiple courses.

The root script `translate_architecture_en.ps1` reads Markdown files from the current working directory, uses the public Google Translate service, and writes output under `en/`. Running it can create many files or replace files at matching output paths; review its scope and destination before running it.

## Languages and naming

- `README.md` or `readme.md` at a course root is the Persian entry point.
- The English edition follows one of the two existing conventions: a sibling file with an `.en.md` suffix or a matching structure under `en/`.
- Follow each course index to its chapter and topic pages; folder depth and names vary by course.
- Use relative links. Encode spaces as `%20` in Markdown link destinations.
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
