# Prefix Query

> Chapter 05: Search Results and Maintenance · Lesson 11

[Read the Persian version](../../../../../fa/elasticsearch/05-search-results-and-maintenance/topics/11-prefix-query/README.md)

## Learning goals

- Match indexed terms that begin with a specified prefix.
- Choose a field and prefix strategy appropriate for autocomplete.
- Measure the cost of short or broad prefixes.

## Match the beginning of a term

A prefix query finds indexed terms that start with the given prefix. On a keyword field it applies to the whole indexed value, which is useful for identifier prefixes or basic autocomplete. On a text field, it operates on indexed tokens, not necessarily the raw string the user sees.

~~~http
POST /products-v1/_search
{"query":{"prefix":{"product_id":"sku-1"}}}
~~~

Short prefixes can match many terms and create more work. Measure realistic query distributions. For richer typeahead behavior, compare prefix queries with `search_as_you_type`, edge n-grams, or a completion suggester, considering index size, update frequency, language, and ranking. A prefix query alone is not automatically a complete autocomplete design.

## Exercise

Run prefix queries with one-, three-, and six-character prefixes against representative IDs and titles. Record matching count and latency. Compare the user experience with a search-as-you-type field using realistic spelling and token order.

## Quiz with answers

1. **What matches a prefix query?** Indexed terms beginning with the requested prefix.
2. **Why is keyword often useful for ID prefixes?** The entire identifier is indexed as a single term.
3. **Why can a short prefix be expensive?** It can match a large portion of the term dictionary and many documents.
4. **Name two autocomplete alternatives.** `search_as_you_type`, edge n-grams, and completion suggesters are examples.

## References and further reading

- [Prefix query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-prefix-query) — options and performance considerations.
- [Search-as-you-type field](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/search-as-you-type) — purpose-built typeahead mapping.
- [Completion suggester](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search-suggesters) — suggestion APIs.
- [Edge n-gram tokenizer](https://www.elastic.co/docs/reference/text-analysis/analysis-edgengram-tokenizer) — index prefixes for matching.
- Persian discovery search (not a verified article): [Persian Elasticsearch prefix and autocomplete articles](https://www.google.com/search?q=Elasticsearch+prefix+autocomplete+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

