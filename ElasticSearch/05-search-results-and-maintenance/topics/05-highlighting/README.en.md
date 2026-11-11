# Highlighting

> Chapter 05: Search Results and Maintenance · Lesson 05

[Read the Persian version](README.md)

## Learning goals

- Return text fragments that show where a query matched.
- Choose a highlight field and fragment strategy.
- Render highlighted snippets safely and avoid treating them as a complete proof of relevance.

## Explain matches in the UI

Highlighting adds fragments with tags around terms that matched a query. It helps users see why a long description appeared in search results. The highlighter and field choice affect which fragments are returned, and highlighting may not expose every synonym, token, or match from a complex query.

~~~http
POST /products-v1/_search
{"query":{"match":{"description":"clear sound"}},
 "highlight":{"fields":{"description":{"fragment_size":120,"number_of_fragments":2}}}}
~~~

Tune fragment size and count for the interface and test long documents. Highlighting adds processing cost, so benchmark it on realistic search traffic. Treat returned snippets as untrusted text: escape content when rendering HTML and ensure only the intended markup is interpreted. Highlighting is a presentation feature; it does not replace quality evaluation or Explain-based score diagnosis.

## Exercise

Search multilingual descriptions with punctuation, diacritics, and synonyms. Compare the returned fragments and adjust fragment size. Render the snippet in a safe test page and verify that embedded markup from a source document cannot execute.

## Quiz with answers

1. **What does highlighting provide?** Text fragments with matching terms marked for presentation.
2. **Does a highlighted fragment prove the ranking is good?** No; it only shows text associated with a match.
3. **Why might some matches be absent from a snippet?** Fragment selection, analyzer behavior, synonyms, and highlighter limitations affect output.
4. **What must the UI do before rendering HTML?** Escape untrusted source content and allow only intended highlight markup.

## References and further reading

- [Highlighting](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/highlighting) — highlighter types and options.
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — configure highlights per request.
- [Synonyms in search](https://www.elastic.co/docs/solutions/search/full-text/search-with-synonyms) — synonym-aware matching behavior.
- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis) — understand tokens behind matches.
- Persian discovery search (not a verified article): [Persian Elasticsearch highlighting tutorials](https://www.google.com/search?q=Elasticsearch+highlighting+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

