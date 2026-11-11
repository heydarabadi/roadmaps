# Custom Analyzers

> Chapter 07: Analysis, Analytics, and Production · Lesson 07

[Read the Persian version](README.md)

## Learning goals

- Build a custom analyzer from character filters, a tokenizer, and token filters.
- Understand why component order changes output.
- Test a custom analysis chain before creating production indices.

## Compose the pipeline deliberately

A custom analyzer can contain character filters that preprocess characters, one tokenizer that splits the text, and token filters that normalize, remove, or expand tokens. The order matters because each component receives the previous component's output. A title analyzer might lowercase and fold accents; an identifier field may use a keyword analyzer instead. Synonyms and stemming need special evaluation because they can change recall and ranking.

~~~http
PUT /products-v1
{"settings":{"analysis":{"analyzer":{"product_text":{
  "type":"custom","tokenizer":"standard",
  "filter":["lowercase","asciifolding"]
}}}},
 "mappings":{"properties":{"title":{"type":"text","analyzer":"product_text"}}}}
~~~

This is a simple English-oriented example, not a universal language configuration. Test each stage with Analyze API and representative content. Analysis settings are normally fixed when an index is created. Changing index-time analyzer behavior for existing documents generally requires a new index and reindex.

## Exercise

Add a character filter or token filter to normalize one domain-specific variation. Test the same string after each stage and verify the result for both indexing and searching. Write an evaluation query set before deciding whether to deploy the analyzer.

## Quiz with answers

1. **What are the main components?** Character filters, one tokenizer, and token filters.
2. **Why does the order matter?** Every stage transforms the input seen by later stages.
3. **How do you inspect the result?** Use Analyze API and inspect token text, position, and offsets.
4. **What migration is commonly needed after changing an index analyzer?** Create a new index and reindex existing data.

## References and further reading

- [Create a custom analyzer](https://www.elastic.co/docs/manage-data/data-store/text-analysis/create-custom-analyzer) — analyzer construction.
- [Character filters](https://www.elastic.co/docs/reference/text-analysis/characterfilters) — preprocessing components.
- [Tokenizers](https://www.elastic.co/docs/reference/text-analysis/tokenizer-reference) — split text into tokens.
- [Token filters](https://www.elastic.co/docs/reference/text-analysis/tokenfilters) — transform tokens.
- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze) — test the complete chain.
- [ParsiAnalyzer](https://github.com/NarimanN2/ParsiAnalyzer) — Persian normalization reference; assess release compatibility.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

