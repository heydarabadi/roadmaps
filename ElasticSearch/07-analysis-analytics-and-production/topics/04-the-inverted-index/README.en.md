# The Inverted Index

> Chapter 07: Analysis, Analytics, and Production · Lesson 04

[Read the Persian version](README.md)

## Learning goals

- Explain how an inverted index maps terms to documents.
- Connect analysis, postings, positions, and full-text search.
- Understand why the index cannot simply reconstruct the original source text.

## From terms to postings

When Elasticsearch indexes text, an analyzer turns it into tokens. Lucene stores an inverted index that maps each term to a postings list of documents containing it, potentially with frequency, position, and offset information depending on field settings. A search can look up terms and combine postings rather than scanning every source string character by character.

~~~text
Document 1: elastic search   -> elastic: [1], search: [1]
Document 2: elastic cluster  -> elastic: [2], cluster: [2]
~~~

A query for `elastic AND search` intersects the relevant postings. Phrase queries use positional information to reason about order and proximity. The stored `_source` is a different structure; analysis may remove punctuation, normalize case, split terms, or apply language transformations, so the inverted index is not a reversible copy of the original text. Updates and deletions create new segments or mark old documents deleted; later merges consolidate segments and reclaim space.

## Exercise

Take a sentence of your choice, apply a simple tokenization rule, and build a term-to-document posting table for three documents. Add positions for one phrase. Explain what information would be lost if the analyzer removes stopwords.

## Quiz with answers

1. **What does an inverted index map?** Terms to postings for documents containing those terms.
2. **Why do phrase queries need positions?** They need to reason about token order and distance within a field.
3. **Can the inverted index reconstruct `_source` exactly?** No; analysis can transform or discard information.
4. **When are deleted segment bytes reclaimed?** Through later segment merges, not immediately at logical deletion.

## References and further reading

- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis) — how text becomes tokens.
- [Index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics) — how Lucene shards store index data.
- [Elasticsearch from the Top Down](https://www.elastic.co/blog/found-elasticsearch-top-down) — conceptual Lucene and shard explanation.
- [Lucene documentation](https://lucene.apache.org/core/) — postings and indexing library resources.
- [Segment merging](https://www.elastic.co/docs/reference/elasticsearch/index-settings/merge) — segment lifecycle.
- Persian discovery search (not a verified article): [Persian articles explaining inverted indexes](https://www.google.com/search?q=inverted+index+Elasticsearch+%D8%A7%DB%8C%D9%86%D8%AF%DA%A9%D8%B3+%D9%85%D8%B9%DA%A9%D9%88%D8%B3+%D9%85%D9%82%D8%A7%D9%84%D9%87).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

