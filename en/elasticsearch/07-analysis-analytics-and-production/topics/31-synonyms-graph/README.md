# Synonym Graphs

> Chapter 07: Analysis, Analytics, and Production · Lesson 31

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/31-synonyms-graph/README.md)

## Learning goals

- Expand query terms into synonyms while preserving multiword token paths.
- Place synonym handling at an appropriate analysis stage.
- Version, test, and evaluate synonym rules against real queries.

## Equivalent terms and phrases

The synonym graph token filter supports synonym expansion, including multiword alternatives, while preserving token graph positions needed by phrase-aware queries. It is commonly used at search time so rules can change without reindexing every document, but the index and search analyzers must remain compatible. Filter ordering with stemming and stop-word handling can change the result. Large or invalid synonym sets can affect memory, reload, or query behavior.

~~~json
{"filter":{"synonyms_graph":{"type":"synonym_graph",
  "synonyms":["laptop, notebook","headphones, headset"]}}}
~~~

The filter must be placed inside an analyzer definition and tested through Analyze API. Search for each synonym in documents containing its alternative and check false positives. Keep synonym rules reviewed and versioned. For Persian, define spelling variants and colloquial terms from observed queries rather than assuming dictionary entries are interchangeable.

## Exercise

Add one single-word and one multiword synonym rule. Inspect token graphs and run match and phrase queries. Compare results with a small set of relevance judgments and document which rules should be removed or adjusted.

## Quiz with answers

1. **Why use a synonym graph filter?** To represent equivalent terms and multiword alternatives while preserving token paths.
2. **Why is search-time use common?** Rules can be changed without rebuilding all indexed documents, if analyzer compatibility is maintained.
3. **Why does filter order matter?** Stemming, stop words, and synonym expansion change the tokens seen by later filters.
4. **How should synonym rules be maintained?** Version, validate, test with representative queries, and monitor relevance changes.

## References and further reading

- [Search with synonyms](https://www.elastic.co/docs/solutions/search/full-text/search-with-synonyms) — configure synonyms for search.
- [Synonym graph token filter](https://www.elastic.co/docs/reference/text-analysis/analysis-synonym-graph-tokenfilter) — multiword synonym behavior.
- [Synonym token filter](https://www.elastic.co/docs/reference/text-analysis/analysis-synonym-tokenfilter) — index-time and search-time considerations.
- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze) — inspect token paths.
- [Match phrase query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-match-query-phrase) — phrase query interaction.
- Persian discovery search (not a verified article): [ParsiAnalyzer](https://github.com/NarimanN2/ParsiAnalyzer) and [Persian Elasticsearch synonym articles](https://www.google.com/search?q=Elasticsearch+synonym+%D9%85%D8%B9%D8%A7%D8%AF%D9%84+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


