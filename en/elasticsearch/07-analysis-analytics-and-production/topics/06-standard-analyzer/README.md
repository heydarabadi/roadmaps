# Standard Analyzer

> Chapter 07: Analysis, Analytics, and Production · Lesson 06

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/06-standard-analyzer/README.md)

## Learning goals

- Understand the Standard Analyzer as a general-purpose starting point.
- Inspect its tokenization and normalization behavior.
- Avoid assuming it is optimal for every language or domain.

## A general-purpose baseline

The Standard Analyzer uses Unicode text segmentation and normalization rules suited to general text. It separates text into tokens according to standard word-boundary behavior and applies lowercase normalization. It is a sensible baseline for many content fields, but a baseline is not proof of search quality. Domain terms, identifiers, compound words, Persian orthography, and multilingual content may need other analysis choices.

~~~http
POST /_analyze
{"analyzer":"standard","text":"Elasticsearch برای جست‌وجوی متن"}
~~~

Read the returned tokens, then evaluate queries that real users type. For Persian, test half-space, letter variants, diacritics, numbers, and mixed-script product names. If the baseline does not meet relevance requirements, compare a custom analyzer or language-specific processing on a representative judgment set. Changing index-time analysis later requires rebuilding indexed terms, typically through reindexing.

## Exercise

Analyze a set of English and Persian product names. Make a table of expected tokens versus actual output. Decide which cases require normalization, synonyms, or a specialized analyzer and whether each change could affect exact identifiers.

## Quiz with answers

1. **What is the Standard Analyzer useful for?** A general-purpose starting point for tokenizing and normalizing text.
2. **Does it guarantee quality for Persian?** No; test the target corpus and query behavior.
3. **Why inspect the Analyze API output?** It shows what terms will be available for matching.
4. **What is usually needed after changing index-time analysis?** A new index and reindex so existing documents use the new tokens.

## References and further reading

- [Standard Analyzer](https://www.elastic.co/docs/reference/text-analysis/analysis-standard-analyzer) — tokenizer and filter behavior.
- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis) — choose and test analyzers.
- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze) — inspect token output.
- [Custom analyzers](https://www.elastic.co/docs/manage-data/data-store/text-analysis/create-custom-analyzer) — adapt when the baseline is insufficient.
- [ParsiAnalyzer](https://github.com/NarimanN2/ParsiAnalyzer) — a Persian normalization project for comparison.
- Persian discovery search (not a verified article): [Persian Elasticsearch analyzer articles](https://www.google.com/search?q=Elasticsearch+standard+analyzer+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C+%D9%85%D9%82%D8%A7%D9%84%D9%87).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

