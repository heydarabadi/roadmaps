<div dir="rtl" align="right">

# Active-Active، geo-replication و Flash tiering

> English edition: [Active-Active, Geo-Replication, and Flash Tiering](../../../../en/redis/09-production-enterprise/active-active-flash/README.md)

> مسیر: فصل ۹، قابلیت‌های محصولی/Enterprise · سطح: پیشرفته · زمان: ۸۰ تا ۱۲۰ دقیقه
>
> این قابلیت‌ها در همهٔ Redis OSS یا سرویس‌های ابری موجود نیستند. این صفحه مشخصات کلی را آموزش می‌دهد؛ طرح نهایی را با edition/version/contract بررسی کن.

## هدف یادگیری

- تفاوت Active-Active را با Redis Cluster و primary/replica/Sentinel شرح دهی.
- Strong eventual consistency و conflict resolution بر پایهٔ CRDT را بفهمی.
- محدودیت write هم‌زمان روی invariant تجاری را تحلیل کنی.
- Redis Flex/Auto Tiering (نام‌های امروزیِ خانوادهٔ Redis on Flash) را از all-RAM Redis جدا کنی.
- تصمیم multi-region و hot/warm memory را با latency/cost/availability بسنجی.

## ۱. Active-Active چیست؟

در Active-Active geo-distributed deployment، چند region می‌توانند هم‌زمان از همان logical dataset بخوانند و بنویسند؛ هر region برای کاربر نزدیک، latency محلی دارد و تغییرها بین کپی‌ها پخش می‌شود. Redis Enterprise/Redis Cloud آن را با replication چند-primary و CRDTها ارائه می‌کند. این feature با Redis Cluster متن‌باز که keyها را shard می‌کند یکی نیست.

```text
Region A client <-> local database A <---- replication ----> database B <-> Region B client
                       \ writes                       writes /
```

**Strong eventual consistency** به این معناست که اگر updateها متوقف شوند و ارتباط بازیابی شود، replicaها با ruleهای merge مشخص به حالت سازگار همگرا می‌شوند. این وعدهٔ «همهٔ regionها هم‌زمان یک ترتیب global خطی می‌بینند» نیست. برای write هم‌زمان روی همان مقدار، CRDT operation/type rule تعیین می‌کند نتیجه چه شود.

## ۲. چرا conflict policy مهم است؟

دو region ممکن است هم‌زمان موجودی یک کالا را `1` بخوانند و هرکدام `-1` بنویسند؛ merge سادهٔ counter یا last-write-wins ممکن است invariant «موجودی منفی نشود» را حفظ نکند. برای cart، profile fields یا countersی که merge-friendly هستند Active-Active مناسب‌تر است؛ payment ledger، رزرو محدود، unique constraint و workflow ordered نیازمند منطق سراسری/transactional منبع حقیقت‌اند.

پیش از انتخاب data type و conflict semantics را روی تمام operations بررسی کن: SADD/SREM, counters, Hash field updates, expiration, JSON/path operations, scripts, multi-key. Product compatibility matrix مشخص می‌کند کدام commands/types پشتیبانی می‌شوند؛ فرض نکن همهٔ data typeها behavior یکسان دارند.

### پرسش‌های طراحی

1. آیا دو region هم‌زمان یک field/element را تغییر می‌دهند؟
2. کدام عملیات commutative/idempotent است؟
3. اگر conflict با حذف و اضافهٔ هم‌زمان رخ دهد، application کدام نتیجه را می‌خواهد؟
4. آیا legal/data-residency policy اجازهٔ replication بین این regionها را می‌دهد؟
5. failover منطقه‌ای هنگام partition چگونه client endpoint و write routing را تغییر می‌دهد؟

## ۳. تجربهٔ مشتری منتشرشده

Redis customer story دربارهٔ Flowdesk می‌گوید سرویس معاملاتی‌شان از Redis Enterprise روی Google Cloud برای حفظ sessionهای trading و cache دادهٔ سفارش/قیمت/بازار استفاده می‌کند و Active-Active را برای اشتراک داده میان جغرافیاها به کار گرفته است. این case مطالعهٔ مشتری است که Redis منتشر کرده؛ مستقل benchmark‌شده نیست و تضمین‌های آن را به workload خودت تعمیم نده. [Flowdesk customer story](https://redis.io/customers/flowdesk/)

در case رسمی Mutualink نیز Redis Enterprise CRDT-based Active-Active برای هماهنگی داده در سرویس‌های اضطراری توصیف شده است؛ باز هم معماری با نیاز محصول خاص است، نه اثبات مناسب‌بودن برای هر تراکنش. [Mutualink case](https://redis.io/customers/mutualink/)

## ۴. Redis on Flash، Auto Tiering و Redis Flex

همهٔ داده را در RAM نگه‌داشتن هزینه‌بر است. محصول‌های Redis Software/Cloud با ترکیب RAM و Flash/SSD می‌توانند hot data را در RAM و warm/cold data را روی storage ارزان‌تر بگذارند. واژهٔ قدیمی Redis on Flash با Auto Tiering و نسل جدیدتر Redis Flex مرتبط است؛ این feature را با persistence/backup یکی ندان. Flash tier فقط storage tier است و latency، key/value size, working set, media type و support matrix مهم‌اند.

مستند فعلی Redis می‌گوید Flex جانشین Auto Tiering است؛ پشتیبانی به Redis database version بستگی دارد (مثلاً database version 8.0+ Flex، 7.4 هر دو، و 7.2 و پایین‌تر Auto Tiering). Active-Active با Flex در compatibility فعلی پشتیبانی نمی‌شود، در حالی که Auto Tiering شرایط جدا دارد. این جدول محصولی است و می‌تواند تغییر کند؛ پیش از خرید/ارتقا matrix جاری را بخوان. [Flex and Auto Tiering](https://redis.io/docs/latest/operate/rs/databases/flash/)

Tiering برای dataset بزرگ با working set کوچک مناسب‌تر است؛ اگر کل dataset هر لحظه داغ باشد، Flash hit باعث latency بیشتری می‌شود و هدف cost ممکن است محقق نشود. حجم key/value, hot-set ratio, p95/p99, throughput، flash IOPS و eviction/tiering hit rate را در workload خود اندازه بگیر.

## ۵. مقایسهٔ معماری

| الگو | هدف اصلی | محدودیت/هزینه |
| --- | --- | --- |
| Primary + replica + Sentinel | failover یک shard در یک trust/domain | replica lag و loss احتمالی؛ scale افقی نه |
| Redis Cluster | sharding و failover روی چند primary | slot/client/multi-key complexity؛ sync global نیست |
| Active-Active Enterprise/Cloud | write/read محلی از چند region و conflict-free merge | product/command limits, network replication, eventual consistency, cost |
| Flex/Auto Tiering | dataset اقتصادی‌تر از DRAM با hot/warm tiers | warm read latency, storage constraints, edition compatibility |

## لَب طراحی

دو region فرضی را روی کاغذ مدل کن: هر دو `cart:{user}` را update می‌کنند؛ سپس یک موجودی محدود را تغییر می‌دهند. برای هرکدام conflict semantics، acceptable staleness، client routing، partition mode، source of truth و metric را بنویس. هیچ deployment واقعی لازم نیست.

## دام‌ها

- **Active-Active را به معنی strong consistency می‌گیری:** eventual convergence و conflict resolution rule را مطالعه کن.
- **Cluster را Active-Active می‌خوانی:** sharding single logical cluster با geo multi-primary فرق دارد.
- **خرید را با CRDT counter امن می‌کنی:** عملیات merge-friendly به تنهایی business invariant را تضمین نمی‌کند.
- **Flash را معادل RAM/TTL می‌دانی:** warm data latency/storage behavior متفاوت دارد.
- **نام قدیمی را با feature امروزی قاطی می‌کنی:** Auto Tiering و Flex compatibility را از docs نسخه بخوان.
- **vendor case را benchmark مستقل فرض می‌کنی:** آن را customer-published story بدان.

## کوییز

### ۱. Active-Active و Redis Cluster یکی‌اند؟

<details><summary>پاسخ</summary>

خیر؛ Cluster متن‌باز keyspace را shard می‌کند، Active-Active محصول geo-distributed چند-primary است.

</details>

### ۲. CRDT چه مسئله‌ای را حل می‌کند؟

<details><summary>پاسخ</summary>

با ruleهای merge مشخص، replicaهای مستقل پس از تبادل updateها به‌طور سازگار همگرا می‌شوند.

</details>

### ۳. آیا Active-Active هر invariant کسب‌وکار را تضمین می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ conflict type و invariant باید با عملیات و consistency مدل شوند.

</details>

### ۴. Redis Flex روی کدام محصول‌ها/نسخه‌هاست؟

<details><summary>پاسخ</summary>

در Redis Software/Cloud tiering product است؛ exact support با نسخه/edition و compatibility matrix تعیین می‌شود، نه فرض کلی دربارهٔ Redis OSS.

</details>

### ۵. چه وقت Flash tier سودمندتر است؟

<details><summary>پاسخ</summary>

وقتی dataset از RAM بزرگ‌تر، ولی working set داغ کوچک‌تر باشد و warm access latency قابل‌قبول باشد.

</details>

### ۶. Flowdesk case چه چیزی را ثابت می‌کند؟

<details><summary>پاسخ</summary>

یک نمونهٔ Redis-published از use case خودش است؛ نه benchmark مستقل و نه تضمین مناسب‌بودن برای workload دیگر.

</details>

## منابع

### انگلیسی و رسمی

- [Redis Active-Active overview](https://redis.io/docs/latest/operate/rs/databases/active-active/)
- [Active-Active planning considerations](https://redis.io/docs/latest/operate/rs/databases/active-active/planning/)
- [Active-Active command compatibility](https://redis.io/docs/latest/operate/rs/references/compatibility/commands/data-types/)
- [Redis Flex and Auto Tiering](https://redis.io/docs/latest/operate/rs/databases/flash/)
- [Flowdesk Active-Active customer story](https://redis.io/customers/flowdesk/)
- [Mutualink Active-Active customer story](https://redis.io/customers/mutualink/)

### فارسی

- [جست‌وجوی فارسی Redis Enterprise Active-Active](https://www.google.com/search?q=آموزش+فارسی+Redis+Enterprise+Active-Active)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

منابع فارسی deep dive برای Active-Active و tiering بسیار محدودند؛ درس بالا مدل و trade-off را خودبسنده توضیح می‌دهد. pricing, SLA, command support و version matrix را در زمان انتخاب از vendor رسمی بگیر.

</div>
