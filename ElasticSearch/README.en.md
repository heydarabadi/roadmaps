# Elasticsearch: Complete Bilingual Study Course

[نسخهٔ فارسی دوره](README.md)

This repository is a chapter-by-chapter learning path based on the [Elasticsearch roadmap on roadmap.sh](https://roadmap.sh/elasticsearch). It contains seven chapters and 113 topic lessons. Each English lesson is paired with a Persian lesson in the same topic folder. The material is written as original teaching notes: it explains the concepts and practical trade-offs rather than reproducing an external book or course.

## How to study

Read the chapter guide first, then follow its lessons in order. Work through the code against a disposable cluster that matches the documentation version you are using. Complete the exercise before reading the answer key. Use the [catalog lab](labs/catalog/README.en.md) and [e-commerce project](projects/ecommerce-catalog/README.en.md) to connect separate topics. See the [case studies](case-studies/README.en.md) for vendor-published examples and read their reported results as workload-specific evidence, not universal promises.

## Chapter index

- [01 — Foundations and orientation](01-foundations/README.en.md) · 6 lessons
- [02 — Mappings and data modeling](02-mappings-and-data-model/README.en.md) · 12 lessons
- [03 — Data types and node roles](03-data-types-and-node-roles/README.en.md) · 8 lessons
- [04 — Indexing and query languages](04-indexing-and-query-languages/README.en.md) · 25 lessons
- [05 — Search results and maintenance](05-search-results-and-maintenance/README.en.md) · 15 lessons
- [06 — How search works](06-how-search-works/README.en.md) · 5 lessons
- [07 — Analysis, analytics, and production](07-analysis-analytics-and-production/README.en.md) · 42 lessons

## Reference collections

- [Official Elasticsearch documentation](https://www.elastic.co/docs/products/elasticsearch)
- [Elasticsearch reference documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/)
- [Search approaches](https://www.elastic.co/docs/solutions/search/search-approaches)
- [Production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance)
- [Elastic customer stories](https://www.elastic.co/customers/)
- [Apache Lucene](https://lucene.apache.org/)
- Persian starting points: [Codity's advanced search article](https://codity.ir/advanced-search-training-with-elasticsearch/), [Persian analyzer implementation article](https://virgool.io/@technotesai/%DA%86%D8%B1%D8%A7-%D8%AC%D8%B3%D8%AA%D8%AC%D9%88%DB%8C-%D9%81%D8%A7%D8%B1%D8%B3%DB%8C-%D8%AF%D8%B1-elasticsearch-%D8%AF%D8%B1%D8%B3%D8%AA-%DA%A9%D8%A7%D8%B1-%D9%86%D9%85%DB%8C-%DA%A9%D9%86%D8%AF-%D9%88-%DA%86%D8%B7%D9%88%D8%B1-%D8%AF%D8%B1%D8%B3%D8%AA%D8%B4-%DA%A9%D9%86%DB%8C%D9%85-dfsaaev7zebh), [ParsiAnalyzer](https://github.com/NarimanN2/ParsiAnalyzer), [TopLearn course](https://toplearn.com/c/6112), and [EngineDevOps course](https://enginedevops.com/product/آموزش-جامع-elasticsearch).

Each English topic links to a curated bilingual reference library and contains lesson-specific official docs, articles, and case studies. The external reference list is intentionally curated and cannot represent every article on the internet. Prefer current official documentation for API syntax and version-sensitive behavior; check each source's date and tested Elasticsearch version before applying it.

[Curated bilingual reference library](references/README.en.md) · [نسخهٔ فارسی کتابخانه](references/README.md)

## Version and safety notes

Elasticsearch, Kibana, clients, plugins, and APIs evolve. Match server and client versions, verify examples against current documentation, and run experiments in an isolated lab index. Never copy production credentials into examples or use a learning cluster as the authority for payments, permissions, or other sensitive decisions.

