# Geo Points

> Chapter 03: Data Types and Node Roles · Lesson 08

[Read the Persian version](../../../../../fa/elasticsearch/03-data-types-and-node-roles/topics/08-geo-points/README.md)

## Learning goals

- Map a point location and choose an unambiguous coordinate representation.
- Query documents by distance or bounding region.
- Validate coordinate ranges and protect the location's meaning.

## Store and search locations

The `geo_point` type represents one geographic point. It can be sent as an object with named `lat` and `lon` properties, a string such as `lat,lon`, or an array in `[longitude, latitude]` order. Named properties are easiest to review because they make coordinate order explicit. Latitude ranges from -90 to 90 degrees and longitude from -180 to 180 degrees. Validate coordinates at the application boundary; reversed values may still look plausible in some regions.

~~~http
PUT /shops-v1/_doc/shop-1
{"name":"Central shop","location":{"lat":35.70,"lon":51.40}}

POST /shops-v1/_search
{"query":{"geo_distance":{"distance":"5km","location":{"lat":35.70,"lon":51.40}}}}
~~~

Geo queries can find points within a distance or shape. Sorting by distance is useful for “nearest location” experiences. If a record represents an area or boundary rather than one point, consider a geo-shape mapping and query instead. Clarify whether the stored location is a storefront, a user's last known position, or a service coverage point; those semantics matter as much as coordinates.

For production services, consider location freshness, privacy and retention, whether approximate geohashes are acceptable, and how geo filters combine with text and access-control filters. Do not log or expose precise user coordinates without a clear need and policy.

## Exercise

Index several shops around a chosen center. Query within 3 km and sort matching results by distance. Introduce one reversed coordinate and one out-of-range coordinate; decide how validation should reject them.

## Quiz with answers

1. **What is the coordinate order for a geo point array?** Longitude followed by latitude.
2. **Why is an object with `lat` and `lon` keys easier to review?** It makes coordinate intent explicit and reduces ordering mistakes.
3. **When should `geo_shape` be considered?** When representing a boundary or area rather than a single point.
4. **What operational concern accompanies precise user location?** Privacy, access control, data minimization, and retention.

## References and further reading

- [Geo-point field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/geo-point) — formats and supported queries.
- [Geospatial search](https://www.elastic.co/docs/solutions/search/geospatial) — geospatial capabilities and patterns.
- [Geo-distance query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-geo-distance-query) — distance filtering.
- [Geo-distance sort](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/sort-search-results#geo-distance-sorting) — order hits by distance.
- Persian discovery search (not a verified article): [Persian Elasticsearch geo-point tutorials](https://www.google.com/search?q=Elasticsearch+geo_point+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

