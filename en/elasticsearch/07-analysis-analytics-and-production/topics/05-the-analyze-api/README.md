# The Analyze API

> Chapter 07: Analysis, Analytics, and Production · Lesson 05

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/05-the-analyze-api/README.md)

## Learning goals

- Inspect tokens produced by an analyzer.
- Read positions and offsets as well as token text.
- Use analysis to debug relevance and multilingual input before indexing.

## Make tokenization visible

The Analyze API lets you apply a named analyzer or supply a tokenizer and filters. Its response can include tokens, positions, offsets, and token types. These details affect phrase queries, synonym graphs, highlighting, and how query terms match the index. Use the same analysis logic as the field mapping where possible.

~~~http
POST /products-v1/_analyze
{"analyzer":"standard","text":"برنامه‌نویسی Elasticsearch و کد 123"}
~~~

Inspect whether the output matches user expectations. Test Persian and mixed-language strings with Arabic/Persian yeh and kaf, half-spaces, digits, punctuation, and compound product names. An analyzer that looks reasonable for one sample may behave poorly on a real corpus. Build a small evaluation set and record which token changes help or hurt recall and precision.

## Exercise

Analyze the same phrase with the standard analyzer, the field analyzer, and a candidate custom analyzer. Compare tokens, positions, and offsets. Write five search cases where the intended result is known before choosing the analysis chain.

## Quiz with answers

1. **What can Analyze API show?** Token text, position, offsets, type, and analysis sequence output.
2. **Why inspect positions?** Phrase and proximity behavior depends on token positions.
3. **Why inspect offsets?** Highlighting and text-span behavior can depend on offsets.
4. **What should precede a custom analyzer in production?** Representative corpus testing and an evaluation of expected query behavior.

## References and further reading

- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze) — request syntax and response.
- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis) — analyzer components.
- [Test an analyzer](https://www.elastic.co/docs/manage-data/data-store/text-analysis/test-an-analyzer) — inspect analysis behavior.
- [Token filters](https://www.elastic.co/docs/reference/text-analysis/tokenfilters) — normalization and token transformations.
- [ParsiAnalyzer](https://github.com/NarimanN2/ParsiAnalyzer) — Persian text-processing reference; verify compatibility with the selected Elasticsearch release.
- Persian discovery search (not a verified article): [Persian Analyze API lessons](https://www.google.com/search?q=Elasticsearch+Analyze+API+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


