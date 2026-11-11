<div dir="rtl" align="right">

# دادهٔ مکانی Redis و جست‌وجوی نزدیک

> English edition: [Redis Geospatial Data and Nearby Search](../../../../en/redis/04-advanced-features/geospatial/README.md)

> مسیر: فصل ۴ · سطح: مقدماتی تا میانی · زمان: ۵۰ تا ۸۰ دقیقه
>
> مختصات کاربران دادهٔ حساس است؛ در لَب از دادهٔ مصنوعی استفاده کن و برای محصول retention و دسترسی محدود تعریف کن.

## هدف یادگیری

- ترتیب طول جغرافیایی و عرض جغرافیایی را درست به‌کار ببری.
- با `GEOADD`, `GEOSEARCH`, `GEODIST`, `GEOPOS` و `GEOHASH` کار کنی.
- شعاع/مستطیل، فاصله، مرتب‌سازی و تعداد نتیجه را تنظیم کنی.
- تشخیص دهی چه زمانی Redis geo کافی است و چه زمانی GIS مانند PostGIS لازم است.

## ایدهٔ مرکزی و محدودیت

دادهٔ geo در Redis بر پایهٔ ساختار sorted set نگهداری می‌شود: member شناسهٔ مکان است و Redis مختصات را در قالب امتیاز geo encode می‌کند. تو باید از فرمان‌های geo استفاده کنی، نه آن score داخلی را به‌عنوان فاصلهٔ مستقیم تفسیر کنی. این ابزار برای queryهای نزدیک ساده و پرتکرار خوب است؛ GIS کامل با polygon، spatial join، نقشه و تحلیل هندسی پیچیده نیست.

### ترتیب مختصات

`GEOADD key longitude latitude member` ترتیب longitude سپس latitude است: تهران نزدیک longitude `51.3890`, latitude `35.6892` است. جابه‌جایی این دو خطای رایج است. طول جغرافیایی دامنهٔ `-180..180` و عرض جغرافیایی دامنهٔ مجاز محدودتری در GeoHash Redis دارد (تقریباً `-85.05112878..85.05112878`). برای نقاط قطبی یا نیاز دقت/مدل زمین‌فیزیکی خاص، انتخاب ابزار را دوباره بررسی کن.

## ۱. افزودن نقطه و خواندن مختصات

```text
DEL lab:shops
GEOADD lab:shops 51.3890 35.6892 shop:central 51.4200 35.7000 shop:north
(integer) 2
GEOPOS lab:shops shop:central shop:north missing:shop
GEODIST lab:shops shop:central shop:north km
```

`GEOADD` عضو جدید را اضافه می‌کند و مختصات member موجود را به‌روزرسانی می‌کند. ترتیب خروجی `GEOPOS` با ترتیب ورودی memberها متناظر است؛ برای member ناموجود null می‌بینی. `GEODIST` فاصلهٔ دو member را در واحد انتخابی مانند `m`, `km`, `ft`, `mi` می‌دهد و اگر یکی نباشد null است.

## ۲. جست‌وجوی اطراف نقطه

`GEOSEARCH` را از یک longitude/latitude یا یک member موجود آغاز کن. نمونهٔ شعاع:

```text
GEOSEARCH lab:shops FROMLONLAT 51.39 35.69 BYRADIUS 5 km WITHDIST WITHCOORD COUNT 20 ASC
```

- `FROMLONLAT` مرکز جست‌وجو را می‌دهد؛ یا `FROMMEMBER` یک member را مرکز می‌کند.
- `BYRADIUS 5 km` دایرهٔ جست‌وجو را مشخص می‌کند.
- `WITHDIST` فاصله را کنار نتیجه می‌آورد.
- `WITHCOORD` طول و عرض را در پاسخ می‌دهد.
- `COUNT 20 ASC` حداکثر ۲۰ نتیجهٔ نزدیک‌تر را اول می‌آورد.

برای محدودهٔ مستطیلی از `BYBOX width height unit` استفاده کن:

```text
GEOSEARCH lab:shops FROMLONLAT 51.39 35.69 BYBOX 8 5 km WITHDIST ASC
```

عرض و ارتفاع مستطیل در واحد داده‌شده‌اند؛ مرکز آن همان نقطهٔ شروع است. اگر `ASC` یا `DESC` ندهی، به ترتیب نزدیک‌بودن نتیجه فرض نکن. `COUNT` همهٔ نقاط داخل محدوده را برنمی‌گرداند وقتی سقف گذاشته‌ای؛ اگر دنبال «همه» هستی و تعداد زیاد است، پاسخ را کامل و قابل‌صفحه‌بندی طراحی کن یا query را به محدوده‌های کوچک تقسیم کن.

## ۳. به‌روزرسانی، انقضا و حذف نقطهٔ کهنه

موقعیت یک راننده ممکن است چند ثانیه بعد کهنه شود. TTL در Redis روی کلید است، نه تک‌عضو؛ اگر هر member عمر جدا دارد، timestamp را در دادهٔ همراه ذخیره کن و worker cleanup بساز یا کلیدهای bucket زمانی جدا انتخاب کن. دادهٔ قدیمی را از نتیجهٔ قابل‌استفاده حذف کن.

```text
ZREM lab:shops shop:closed
```

از آن‌جا که geo روی sorted set است، `ZREM` عضو را حذف می‌کند. اگر کلید را با TTL expire کنی، همهٔ نقاط همان key حذف می‌شوند؛ bucket بندی مکانی/زمانی را با retention هماهنگ کن.

## ۴. مثال طراحی: نزدیک‌ترین فروشگاه باز

Query سادهٔ نزدیک‌ترین فروشگاه را به چند تصمیم تکمیل کن:

1. فقط فروشگاه‌های فعال در geo index باشند یا وضعیت فعال در key/hash جدا بررسی شود؟
2. از مرکز کاربر، radius اولیه تعیین کن؛ اگر نتیجه نیست، چه طور شعاع را گسترش می‌دهی؟
3. نتیجهٔ نزدیک را بعد از Geo با ساعت کاری، موجودی، سرویس‌دهی و tenant filter کن.
4. latency و تعداد candidateهای برگشتی را پایش کن؛ `COUNT` کوچک ممکن است فروشگاه واجدشرایط را جا بیندازد اگر filter بعدی تعداد زیادی حذف کند.
5. مختصات دقیق را تنها برای مدت نیازمند نگه‌دار؛ مجوز، access log، دقت گردکردن و حذف درخواست کاربر را تعریف کن.

Redis geo ترتیب فاصله‌ای ساده می‌دهد، اما queryهایی مثل «فروشگاه داخل polygon استان، با geometry intersection دقیق و نقشهٔ چندلایه» را به سامانهٔ GIS واگذار کن. گاهی معماری دو مرحله‌ای مناسب است: سیستم مکانی دقیق candidate را می‌سازد، Redis نتیجهٔ پرتکرار/زنده را با TTL کوتاه سرو می‌کند.

## تمرین آزمایشگاهی

```text
DEL lab:drivers
GEOADD lab:drivers 51.3890 35.6892 driver:42 51.4100 35.6900 driver:77
GEOSEARCH lab:drivers FROMLONLAT 51.3900 35.6900 BYRADIUS 3 km WITHDIST WITHCOORD ASC
GEODIST lab:drivers driver:42 driver:77 m
GEOHASH lab:drivers driver:42 driver:77
```

1. فاصله‌ها و ترتیب را توضیح بده.
2. مختصات را عمداً جابه‌جا کن و خطا یا نتیجهٔ غیرمنطقی را ببین.
3. `driver:42` را به نقطه‌ای دور منتقل کن؛ ببین membership یکتا می‌ماند و نتیجه تغییر می‌کند.
4. سیاست حذف رانندهٔ stale را طراحی کن؛ چرا TTL روی یک key مشترک جواب نمی‌دهد؟

## تصمیم‌ها و دام‌ها

- **longitude/latitude جابه‌جا شده:** ترتیب `lon lat` است.
- **فاصله با crow-flies اشتباه گرفته شده:** GEO فاصلهٔ مستقیم تقریبی می‌دهد، نه زمان رانندگی/مسیر خیابان.
- **GIS کامل انتظار داری:** polygon، join و topology پیچیده را به ابزار مکانی اختصاصی بسپار.
- **result count کوچک است:** `COUNT` سقف دارد؛ پس از filterهای کسب‌وکار ممکن است گزینهٔ معتبر باقی نماند.
- **stale location نمایش داده می‌شود:** freshness را در مدل و query کنترل کن، نه فقط در UI.
- **دادهٔ مکانی پرسنلی بی‌دلیل طولانی می‌ماند:** دقت، retention و مجوز را حداقلی کن.
- **یک key بسیار حجیم است:** اندازهٔ index، نرخ update، shard/slot و overhead هر member را اندازه بگیر.

## کوییز

### ۱. ترتیب آرگومان مکان در `GEOADD` چیست؟

<details><summary>پاسخ</summary>

longitude سپس latitude.

</details>

### ۲. برای جست‌وجوی radius از چه فرمانی استفاده می‌کنی؟

<details><summary>پاسخ</summary>

`GEOSEARCH` با `BYRADIUS`.

</details>

### ۳. `WITHDIST` چه می‌افزاید؟

<details><summary>پاسخ</summary>

فاصلهٔ هر member را همراه نتیجه برمی‌گرداند.

</details>

### ۴. آیا Redis GEO زمان رانندگی را می‌دهد؟

<details><summary>پاسخ</summary>

خیر؛ برای مسیر/ترافیک به routing یا نقشه نیاز داری.

</details>

### ۵. TTL مستقل برای هر موقعیت وجود دارد؟

<details><summary>پاسخ</summary>

TTL روی key است؛ عمر متفاوت memberها به cleanup/model جدا نیاز دارد.

</details>

### ۶. چه زمانی PostGIS را انتخاب می‌کنی؟

<details><summary>پاسخ</summary>

وقتی query دقیق و غنی GIS مثل polygon و spatial join لازم باشد.

</details>

## منابع

### انگلیسی و رسمی

- [Geospatial data type](https://redis.io/docs/latest/develop/data-types/geospatial/)
- [GEOSEARCH](https://redis.io/docs/latest/commands/geosearch/)
- [GEOADD](https://redis.io/docs/latest/commands/geoadd/)
- [GEODIST](https://redis.io/docs/latest/commands/geodist/)
- [PostGIS geography/spatial model](https://postgis.net/docs/using_postgis_dbmanagement.html#PostGIS_Geography)

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی تکمیلی فارسی دربارهٔ GEOSEARCH](https://www.google.com/search?q=آموزش+فارسی+Redis+GEOSEARCH)

آموزش‌های فارسی GEO محدودند؛ توضیح و آزمایش این صفحه برای عملیات ساده خودبسنده است. برای دامنهٔ مختصات، syntax نسخه و دقت use case عملی را با مستند رسمی و سامانهٔ GIS خود تطبیق بده.

</div>
