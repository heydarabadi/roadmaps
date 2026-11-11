# Search Analyzer

> Chapter 07: Analysis, Analytics, and Production · Lesson 01

[Read the Persian version](README.md)

## Learning goals

- Explain how a search analyzer turns query text into terms.
- Keep query-time analysis compatible with index-time terms.
- Test multilingual behavior before changing an index contract.

## Analyze the user's query

At index time, a text field's analyzer turns document text into tokens stored in the inverted index. At search time, a search analyzer transforms the user's query so it can match those indexed terms. The two analyzers can be different, for example when query-time synonyms are applied, but their outputs must be compatible. If a search analyzer produces a term that was never indexed, the user may see a false negative.

~~~json
{"properties":{"title":{"type":"text","analyzer":"standard","search_analyzer":"standard"}}}
~~~

For Persian content, test real titles and user queries with half-spaces, Arabic/Persian forms of kaf and yeh, digits, punctuation, transliteration, brands, and compounds. Do not assume a generic analyzer produces the matching behavior the product wants. Use Analyze API output and judged queries to decide. Changing the index-time analyzer does not reprocess existing terms; it commonly requires a new index and reindex.

## Exercise

Analyze a Persian title at index and search time. Compare queries with and without half-space and with Arabic versus Persian letter forms. Write expected recall behavior for each and test representative product data.

## Quiz with answers

1. **What does `search_analyzer` process?** The query text at search time.
2. **Why should search and index analysis be compatible?** The query terms need to match the terms already stored in the index.
3. **Can changing the search analyzer improve existing index-time tokens?** It can alter query transformation, but if indexed terms were built incorrectly, reindexing may be needed.
4. **Why test Persian input with real samples?** Orthographic variation and half-space can materially change tokenization and matching.

## References and further reading

- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis) — analysis concepts and pipeline.
- [Analyzer mapping parameter](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/analyzer) — index-time analyzer selection.
- [Search analyzer parameter](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/search-analyzer) — query-time analyzer selection.
- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze) — inspect token output.
- [ParsiAnalyzer](https://github.com/NarimanN2/ParsiAnalyzer) — Persian normalization/tokenization project; check version compatibility.
- Persian discovery search (not a verified article): [Persian analyzer articles](https://www.google.com/search?q=Elasticsearch+Persian+search+analyzer+%D9%85%D9%82%D8%A7%D9%84%D9%87).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


