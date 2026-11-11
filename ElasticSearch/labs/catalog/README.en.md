# Hands-on Lab: Persian Ecommerce Catalog

[Read the Persian version](README.md)

This lab uses a fixed sample dataset across several lessons. It needs no external data service. Run the requests in Kibana Dev Tools → Console against a disposable test cluster. Review every endpoint and target index first. The sample `DELETE` request targets only `products-lab-v1`.

## Files

- [Kibana Console requests](catalog-console.en.http): index creation, sample product documents, and search examples. Persian product text is intentionally retained so that the lesson exercises work on Persian text.
- [Exercises and worked answers](exercises.en.md): staged practice from mappings through search, aggregations, and pagination.

## Run the lab

1. Read `catalog-console.en.http` in Kibana Console. Run one request at a time so you can inspect each response.
2. Create `products-lab-v1`, then inspect its mapping with `GET /products-lab-v1/_mapping`.
3. Run the Bulk request. Expect `errors: false`; if it is `true`, inspect each failed item rather than assuming all documents were indexed.
4. Before each search, predict which records should match and why. Compare that prediction with the actual response.
5. Complete the [exercises](exercises.en.md), then compare your results with the worked solutions.

## Dataset and limits

The ten products contain Persian text, brands, categories, prices, availability, dates, tags, nested offers, and flexible metadata. Prices are fictional integers without a currency unit. The data is for query learning only; it is not suitable for benchmarking, real inventory decisions, or production latency claims.

## Clean up

After finishing, and only in the disposable lab cluster, you may remove the sample index:

```http
DELETE /products-lab-v1
```

## References

- [Mappings](https://www.elastic.co/docs/manage-data/data-store/mapping)
- [Bulk API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk)
- [Search API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-search)
- [Nested field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/nested)
- [Aggregations](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- [Sort and search-after pagination](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/paginate-search-results)
- [Bilingual references](../../references/README.en.md)
