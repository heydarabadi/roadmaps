# Catalog Lab Exercises

[Read the Persian version](exercises.md)

Run `catalog-console.en.http` first. Each exercise connects a roadmap concept to the same sample catalog.

## Exercises

1. Search only available products in the `computer` category, priced at no more than 6,000,000, whose title matches “بی‌سیم” (wireless).
2. Find a product whose title is an exact complete keyword. Explain why `term` belongs on `title.raw`, while `match` belongs on `title`.
3. Bucket products by category and read each category's document count and average price.
4. Return products having one offer where the seller is `direct` and stock is at least 10. Why does the query need `nested` semantics?
5. Create snippets from `title` and `description`. Explain why highlighting fragments must be HTML-escaped before rendering.
6. Retrieve the three cheapest products and continue to page two with `search_after`. Copy the last hit's sort values exactly.
7. Change the price of `sku-001` with the Update API, then compare Get by ID with Search.
8. Design a fresh mapping for `brand` with lowercase normalization. Explain why changing the analysis behavior does not rewrite terms already indexed in an existing index.

## Worked answers

### 1. Text matching plus filters

```http
POST /products-lab-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"بی‌سیم"}}],"filter":[{"term":{"category":"computer"}},{"term":{"available":true}},{"range":{"price":{"lte":6000000}}}]}}}
```

`must` performs full-text matching and contributes to relevance. Category, availability, and price are eligibility conditions, so they belong in filter context.

### 2. Exact value versus full text

Use `match` on `title` for natural-language input. Use `term` on `title.raw` for a complete exact keyword value or keyword sorting. A `term` query does not analyze its input. For a product identifier, query the mapped keyword ID field directly.

### 3. Buckets and metrics

```http
POST /products-lab-v1/_search
{"size":0,"aggs":{"categories":{"terms":{"field":"category","size":10},"aggs":{"mean_price":{"avg":{"field":"price"}}}}}}
```

Each bucket represents a category. `doc_count` is its matching document count, and `mean_price.value` averages indexed prices within that bucket. In real data, account for missing values and multi-valued fields.

### 4. Nested offers

```http
POST /products-lab-v1/_search
{"query":{"nested":{"path":"offers","query":{"bool":{"must":[{"term":{"offers.seller":"direct"}},{"range":{"offers.stock":{"gte":10}}}]}}}}}
```

The nested query requires both conditions to match the same offer object. With a plain array of objects, one offer could match `seller` and a different offer could match `stock`, creating an incorrect combined match.

### 5. Highlighting

```http
POST /products-lab-v1/_search
{"query":{"match":{"description":"سفر طولانی"}},"highlight":{"fields":{"description":{"fragment_size":100,"number_of_fragments":2}}}}
```

A highlight fragment is suggested text, not safe HTML. Escape it before rendering and inspect snippets with Persian text and half-spaces.

### 6. `search_after`

Sort by `price asc` and then `product_id asc` so ties have a deterministic order. Send the same query and sort on the next request and pass the final hit's sort array unchanged as `search_after`. For a changing result set, use a Point in Time and close it after pagination.

### 7. Update and search visibility

```http
POST /products-lab-v1/_update/sku-001
{"doc":{"price":3990000}}
GET /products-lab-v1/_doc/sku-001
```

Get reads the document directly. Search may not reflect the update until refresh. Balance freshness requirements against refresh cost; avoid forcing refresh after every write in a high-throughput service.

### 8. Changing an analyzer

Analysis determines the terms created at index time. Changing an index setting cannot retroactively rebuild all existing terms. Create a new index with the intended mapping and analyzer, reindex, compare query quality, and switch an alias only after verification.

## Further reading

- [Boolean query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query)
- [Nested query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-nested-query)
- [Term-level queries](https://www.elastic.co/docs/reference/query-languages/query-dsl/term-level-queries)
- [Aggregations](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- [Pagination and `search_after`](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/paginate-search-results)
- [Refresh API and visibility](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-refresh)
- [Reindex API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-reindex)
