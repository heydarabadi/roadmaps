# Atlas Search

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/04-performance/atlas-search/README.md).

> **Learning goal:** Build application search with an explicit index, analyzer, relevance rule, and pagination strategy.

## Database filter versus search engine

An equality or prefix filter is often best handled by MongoDB query operators and indexes. Full-text search adds tokenization, language analysis, scoring, autocomplete, facets, fuzzy matching, and other search behavior. Atlas Search provides a dedicated search index and `$search` aggregation stage. It is not interchangeable with a classic text index, and it is not available in every deployment configuration.

## Search index and analyzer

A Search index describes which fields are searchable and how their values are indexed. An analyzer transforms text into tokens and may normalize case, punctuation, or language morphology. A mismatched analyzer can produce poor results even when the query is syntactically correct. For Persian, test real text including Arabic/Persian character variants, half-spaces, diacritics, numbers, transliterations, and mixed-language terms. Confirm which analyzers are available for the deployment and current version.

## Text search example

~~~javascript
db.products.aggregate([
  {
    $search: {
      index: "products_search",
      text: {
        query: "wireless keyboard",
        path: ["title", "description"]
      }
    }
  },
  { $limit: 20 },
  {
    $project: {
      title: 1,
      price: 1,
      score: { $meta: "searchScore" }
    }
  }
])
~~~

Use autocomplete for prefix-as-you-type experiences, facets for aggregations over search results, and fuzzy matching only when its recall and cost suit the product. Sort and paginate using the search capabilities supported by the chosen version; keep a deterministic secondary key when the API needs stable pages.

## Relevance is a product requirement

Write representative user queries and expected top results. Compare exact phrase, token matching, synonyms, typo tolerance, language variants, and filters. A search result can be technically correct but poor for users. Track no-result rate, click-through or task success, latency, and index freshness. Search indexes update asynchronously, so define how quickly a catalog change must appear.

## Published example: Bazaarvoice

MongoDB's customer story describes Bazaarvoice using Atlas Search for a large product catalog and discusses scale and search replication lag as the data grew. The story is published by the vendor/customer and should be treated as a design example, not an independent benchmark. [Bazaarvoice story](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice)

## Exercise

Create a test set of at least ten Persian product queries. For each, record expected results and whether the query should match on exact phrase, normalized token, autocomplete prefix, or typo tolerance. Include a no-result example.

## Common mistakes

- Assuming an English analyzer works for Persian without testing.
- Treating Atlas Search and the classic text index as the same feature.
- Optimizing relevance against one query only.
- Forgetting index freshness and Search-index resource cost.
- Adding fuzzy matching without measuring extra matches and latency.

## Quiz and answer key

1. **What does an analyzer do?** Converts input text into indexed/searchable tokens and may normalize it.
2. **How does Atlas Search differ from a classic text index?** It uses dedicated Search indexes and operators with richer relevance and search behavior.
3. **What is autocomplete for?** Matching prefixes during type-ahead interaction.
4. **Why test analyzers with actual Persian text?** Character variants, half-spaces, diacritics, transliteration, and mixed-language data change tokenization and relevance.
5. **Applied task: build a Persian search evaluation set.** Use representative queries and expected results for exact, token, prefix, fuzzy, and no-result cases.
6. **What is a Search facet?** A grouped count or value summary over search results, useful for filters.
7. **Why does index freshness matter?** Search may not reflect a write immediately because index updates are asynchronous.
8. **What metrics help judge search quality?** No-result rate, relevance/task success, latency, and freshness.
9. **Should fuzzy search always be enabled?** No. It can increase false positives and resource use.
10. **How should relevance be tuned?** Evaluate a representative query set against expected results and user outcomes.

## Further reading

- [Atlas Search Overview](https://www.mongodb.com/docs/atlas/atlas-search/)
- [Create a Search Index](https://www.mongodb.com/docs/atlas/atlas-search/create-index/)
- [Analyzers](https://www.mongodb.com/docs/atlas/atlas-search/analyzers/)
- [Text Operator](https://www.mongodb.com/docs/atlas/atlas-search/text/)
- [Autocomplete Operator](https://www.mongodb.com/docs/atlas/atlas-search/autocomplete/)
- [Search Facets](https://www.mongodb.com/docs/atlas/atlas-search/facet/)
- [Bazaarvoice customer story](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice)
- [Persian MongoDB learning series — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [Curated reference library: Atlas Search](../../reference-library.md#performance-search)

---
Sources reviewed: 2026-11-11. Atlas Search is version- and deployment-dependent.
