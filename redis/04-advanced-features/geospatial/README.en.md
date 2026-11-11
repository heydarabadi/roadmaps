<div dir="ltr" align="left">

# Redis Geospatial Data and Nearby Search

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 4 · Level: beginner to intermediate · Time: 50–80 minutes
>
> User locations are sensitive data. Use synthetic locations in the lab, and define limited access and retention for a real product.

## Learning objectives

- Use longitude and latitude in the correct order.
- Work with `GEOADD`, `GEOSEARCH`, `GEODIST`, `GEOPOS`, and `GEOHASH`.
- Configure radius or box searches, distance output, sorting, and result limits.
- Decide when Redis geospatial commands are enough and when a GIS such as PostGIS is needed.

## The central idea and its limits

Redis stores its geospatial data using a sorted-set-based representation: the member is a location identifier, and Redis encodes coordinates in an internal score. Use the GEO commands; do not interpret that internal score as a direct distance. Redis GEO is useful for simple, frequent nearby-point queries. It is not a full GIS with general polygon operations, spatial joins, map layers, or complex geometric analysis.

### Coordinate order

`GEOADD key longitude latitude member` takes longitude first and latitude second. Tehran is approximately longitude `51.3890`, latitude `35.6892`. Swapping the two is a common bug. Longitude ranges from `-180` to `180`; Redis's GeoHash-based latitude range is approximately `-85.05112878` to `85.05112878`. Reconsider the tool for polar points or specialized geodetic-accuracy requirements.

## 1. Add points and read their coordinates

```text
DEL lab:shops
GEOADD lab:shops 51.3890 35.6892 shop:central 51.4200 35.7000 shop:north
(integer) 2
GEOPOS lab:shops shop:central shop:north missing:shop
GEODIST lab:shops shop:central shop:north km
```

`GEOADD` adds a new member or updates the coordinates of an existing member. `GEOPOS` returns results in the same order as the requested members; a missing member produces a null result. `GEODIST` returns the direct distance between two members in a unit such as `m`, `km`, `ft`, or `mi`; it returns null if either member is absent.

## 2. Search around a point

Start `GEOSEARCH` from a longitude/latitude pair or an existing member. For a radius search:

```text
GEOSEARCH lab:shops FROMLONLAT 51.39 35.69 BYRADIUS 5 km WITHDIST WITHCOORD COUNT 20 ASC
```

- `FROMLONLAT` sets the search center; `FROMMEMBER` can instead use an existing member.
- `BYRADIUS 5 km` defines a circular search area.
- `WITHDIST` includes each result's distance.
- `WITHCOORD` includes longitude and latitude in the response.
- `COUNT 20 ASC` asks for at most 20 results, nearest first.

Use `BYBOX width height unit` for a rectangular search:

```text
GEOSEARCH lab:shops FROMLONLAT 51.39 35.69 BYBOX 8 5 km WITHDIST ASC
```

The width and height use the chosen unit, and the starting point is the center. If you omit `ASC` or `DESC`, do not assume results are distance-sorted. `COUNT` is a cap: you will not receive every point in the area when the cap is reached. If the application needs all matches and the set may be large, design pagination or split the query into smaller areas.

## 3. Updates, expiration, and stale locations

A driver's location can become stale within seconds. Redis TTL applies to the whole key, not to an individual sorted-set member. If each member has its own freshness window, store a timestamp in accompanying data and run a cleanup worker, or use time-bucketed keys. Exclude stale locations from results.

```text
ZREM lab:shops shop:closed
```

Because geospatial data uses a sorted set, `ZREM` removes a member. Expiring the key removes every location in that key, so align spatial or time bucket design with retention.

## 4. Design example: find the nearest open store

Extend a basic nearest-store query with explicit decisions:

1. Should only active stores be in the GEO index, or should active status live in a separate key or Hash?
2. Choose an initial radius around the user. What should happen if no store is found, and how far should the radius expand?
3. After the GEO query, filter by opening hours, inventory, service availability, and tenant.
4. Monitor latency and candidate count. A small `COUNT` may omit a qualifying store if many nearby candidates fail later business filters.
5. Retain exact coordinates only as long as needed. Define authorization, access logging, coordinate precision, and user-requested deletion.

Redis GEO provides simple distance ordering. Delegate queries such as “stores inside this province polygon, with exact geometry intersection and multiple map layers” to GIS software. A two-stage architecture can work: a spatial database identifies candidates, while Redis serves frequently requested or live results with a short TTL.

## Guided lab

```text
DEL lab:drivers
GEOADD lab:drivers 51.3890 35.6892 driver:42 51.4100 35.6900 driver:77
GEOSEARCH lab:drivers FROMLONLAT 51.3900 35.6900 BYRADIUS 3 km WITHDIST WITHCOORD ASC
GEODIST lab:drivers driver:42 driver:77 m
GEOHASH lab:drivers driver:42 driver:77
```

1. Explain the reported distances and ordering.
2. Deliberately swap the coordinates and observe the error or implausible result.
3. Move `driver:42` to a distant point. Confirm that its member identity remains unique and its search results change.
4. Design stale-driver cleanup. Why does TTL on one shared key not solve per-driver freshness?

This lab deletes any old data under `lab:drivers`.

## Decisions and pitfalls

- **Longitude and latitude are reversed:** The command order is `lon lat`.
- **Straight-line distance is confused with travel distance:** GEO does not calculate road routes or driving time.
- **A full GIS is expected:** Delegate complex polygons, joins, and topology to a dedicated spatial tool.
- **The result count is too small:** `COUNT` is a cap; later business filters may leave no valid candidate.
- **A stale location is displayed:** Model and check freshness instead of hiding the problem in the UI.
- **Sensitive location data is retained unnecessarily:** Minimize precision, retention, and access.
- **One key becomes too large:** Measure index size, update rate, shard/slot behavior, and per-member overhead.

## Quiz with answers

### 1. What is the coordinate order for `GEOADD`?

<details><summary>Answer</summary>

Longitude followed by latitude.

</details>

### 2. Which command searches within a radius?

<details><summary>Answer</summary>

`GEOSEARCH` with `BYRADIUS`.

</details>

### 3. What does `WITHDIST` add?

<details><summary>Answer</summary>

The distance for each returned member.

</details>

### 4. Does Redis GEO provide driving time?

<details><summary>Answer</summary>

No. Use a routing or mapping service for road routes and traffic-aware travel time.

</details>

### 5. Is there an independent TTL for each location?

<details><summary>Answer</summary>

No. TTL applies to the key; per-member freshness needs separate metadata and cleanup/modeling.

</details>

### 6. When would you choose PostGIS?

<details><summary>Answer</summary>

When you need richer, precise GIS operations such as polygon queries or spatial joins.

</details>

## References and further reading

### English: official documentation

- [Redis geospatial data type guide](https://redis.io/docs/latest/develop/data-types/geospatial/) — Redis GEO data and command concepts.
- [GEOSEARCH command reference](https://redis.io/docs/latest/commands/geosearch/) — radius and box queries.
- [GEOADD command reference](https://redis.io/docs/latest/commands/geoadd/) — adding and updating coordinates.
- [GEODIST command reference](https://redis.io/docs/latest/commands/geodist/) — distances and units.
- [GEOPOS command reference](https://redis.io/docs/latest/commands/geopos/) and [GEOHASH command reference](https://redis.io/docs/latest/commands/geohash/) — read coordinates and geohashes.
- [Redis Query Engine: geospatial queries](https://redis.io/docs/latest/develop/interact/search-and-query/query/geo-spatial/) — separate, richer geo-search capabilities and version requirements.
- [Redis geospatial query model](https://redis.io/docs/latest/develop/interact/search-and-query/advanced-concepts/geo/) — distinction between GEO data type and Search geo fields.
- [PostGIS geography and geometry concepts](https://postgis.net/docs/using_postgis_dbmanagement.html#PostGIS_Geography) — when a spatial database offers a better model.
- [Redis GEO tutorial](https://redis.io/tutorials/howtos/solutions/geo/getting-started/) — hands-on nearby-search workflow.

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی تکمیلی فارسی دربارهٔ GEOSEARCH](https://www.google.com/search?q=آموزش+فارسی+Redis+GEOSEARCH)

Detailed Persian coverage of Redis GEO is limited. This lesson is self-contained for simple geospatial operations. Verify coordinate ranges, command syntax, and real-world accuracy against the Redis version and GIS system you use.

</div>

