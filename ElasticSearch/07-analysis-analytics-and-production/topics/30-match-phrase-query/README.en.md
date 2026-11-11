# Match Phrase Query

> Chapter 07: Analysis, Analytics, and Production · Lesson 30

[Read the Persian version](README.md)

## Learning goals

- Search for analyzed terms in order and near one another.
- Understand phrase positions and the `slop` trade-off.
- Evaluate phrase behavior with synonyms and multilingual text.

## Ordered token sequences

The `match_phrase` query analyzes its input and searches for the resulting token sequence in order. It uses token positions produced by the analyzer. By default, terms must occur next to one another; `slop` allows limited distance or movement, increasing recall but potentially reducing precision.

~~~http
POST /products-v1/_search
{"query":{"match_phrase":{"title":{"query":"wireless headphones","slop":1}}}}
~~~

Test examples such as “wireless headphones,” “wireless noise cancelling headphones,” and reordered terms. A phrase query is not an exact raw-string match: analysis can normalize terms and punctuation. Multiword synonyms interact with token graphs and should be tested with a search analyzer that handles them correctly.

## Exercise

Create documents with adjacent, separated, and reversed terms. Compare `slop: 0`, `1`, and a larger value. Add a multiword synonym and inspect token positions before selecting the production query.

## Quiz with answers

1. **What does `match_phrase` require?** Analyzed terms in order within the allowed positional distance.
2. **What does `slop` change?** How much distance or movement between terms is permitted.
3. **What is the trade-off of higher slop?** More matches and potentially lower precision.
4. **Why inspect analysis with phrase queries?** Positions and synonym graphs affect phrase matching.

## References and further reading

- [Match phrase query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-match-query-phrase) — phrase matching and slop.
- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis) — positions and analyzers.
- [Synonym graph token filter](https://www.elastic.co/docs/reference/text-analysis/analysis-synonym-graph-tokenfilter) — multiword synonym handling.
- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze) — inspect token positions.
- Persian discovery search (not a verified article): [Persian match-phrase and phrase-search articles](https://www.google.com/search?q=Elasticsearch+match_phrase+%D8%AC%D8%B3%D8%AA%D8%AC%D9%88%DB%8C+%D8%B9%D8%A8%D8%A7%D8%B1%D8%AA+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

