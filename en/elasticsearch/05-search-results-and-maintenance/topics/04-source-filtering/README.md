# Source Filtering

> Chapter 05: Search Results and Maintenance · Lesson 04

[Read the Persian version](../../../../../fa/elasticsearch/05-search-results-and-maintenance/topics/04-source-filtering/README.md)

## Learning goals

- Return only the `_source` fields needed by a response.
- Distinguish source filtering from mapping changes and access control.
- Reduce payload size without exposing internal data.

## Shape the returned document

By default, a hit can include the stored `_source` JSON. Source filtering uses include and exclude patterns to limit which source fields are returned. This can reduce network payload and application serialization when a UI needs only a few fields.

~~~http
POST /products-v1/_search
{"_source":["product_id","title","price"],
 "query":{"term":{"available":true}}}
~~~

Source filtering does not change the mapping, remove values from the index, or serve as authorization. A field omitted from one response may still be retrievable by another user or endpoint if access controls permit it. Apply role-based or field-level security where needed and keep application response schemas explicit. For known fields needed by sorting or aggregation, stored fields, doc values, or other retrieval options may be relevant; choose based on semantics and measured cost.

## Exercise

Compare a full-source response to a response containing only fields needed for a product card. Measure bytes transferred for a representative page. Add an internal field to the source and explain why `_source` filtering alone is not a security policy.

## Quiz with answers

1. **What does source filtering do?** Limits source fields returned in hits.
2. **Does it alter the mapping?** No.
3. **Does it guarantee confidentiality?** No. It is response shaping, not an authorization boundary.
4. **What is one benefit?** Smaller responses and less unnecessary serialization.

## References and further reading

- [Retrieve selected fields](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/retrieve-selected-fields) — `_source` includes and excludes.
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — source filtering in search requests.
- [`_source` field](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/mapping-source-field) — source storage behavior.
- [Field and document security](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/field-and-document-access-control) — enforce access restrictions.
- Persian discovery search (not a verified article): [Persian articles about Elasticsearch source filtering](https://www.google.com/search?q=Elasticsearch+_source+filtering+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

