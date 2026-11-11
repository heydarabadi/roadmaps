<div dir="rtl" align="right">
[English version](../../en/05-data-and-caching/17-caching/README.md)


# Cache Strategies

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

Cache داده را نزدیک مصرف‌کننده نگه می‌دارد؛ سود latency در برابر stale data، invalidate، miss و stampede سنجیده می‌شود.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Cache-aside: برنامه در miss منبع را می‌خواند و پر می‌کند. Write-through منبع و cache را باهم به‌روز می‌کند؛ write-behind اول cache را می‌نویسد و خطر از دست‌رفتن دارد؛ refresh-ahead دادهٔ داغ را پیش از انقضا تازه می‌کند. TTL، eviction، versioning، negative cache و single-flight را مشخص کن. cache لزوماً منبع حقیقت نیست.

## درس گام‌به‌گام

### Cache کجا قرار می‌گیرد؟

Cache ممکن است در مرورگر، CDN، reverse proxy، process برنامه یا datastore جدا مثل Redis باشد. هر لایه latency، ظرفیت، scope و سیاست freshness متفاوت دارد. Cache محلی بسیار سریع ولی بین instanceها ناسازگار می‌شود؛ distributed cache مشترک است ولی network hop، availability و هزینهٔ خودش را می‌افزاید. پیش از انتخاب، hit rate، miss penalty، اندازهٔ working set و هدف freshness را اندازه بگیر.

### چهار سیاست نوشتن/خواندن roadmap

**Cache-Aside:** برنامه cache را می‌خواند؛ در miss منبع را fetch و cache می‌کند. ساده و مناسب بسیاری از read-heavy endpointهاست، اما درخواست‌های هم‌زمان می‌توانند stampede بسازند و invalidation باید مشخص باشد.

**Write-Through:** برنامه هم‌زمان منبع اصلی و cache را به‌روز می‌کند. Read-after-write تازه‌تر می‌شود، ولی هزینهٔ write و failure اتمیک میان دو مقصد مطرح است. اگر یکی موفق و دیگری fail شود، reconciliation یا نسخه لازم است.

**Write-Behind:** ابتدا cache نوشته می‌شود و بعداً تغییر به منبع پایدار flush می‌شود. Latency write کم است، ولی crash پیش از flush می‌تواند داده از دست بدهد؛ برای دادهٔ حیاتی مثل پرداخت بدون durability و replay قوی مناسب نیست.

**Refresh-Ahead:** پیش از انقضای دادهٔ داغ آن را تازه می‌کند. Hit سریع می‌ماند ولی refresh بی‌فایده می‌تواند هزینه‌زا و refresh هم‌زمان باعث فشار شود. فقط keyهای پرتکرار ارزش این کار را دارند.

### TTL، invalidation و eviction

TTL سقف عمر cache entry است؛ TTL بلند freshness را بدتر، TTL کوتاه hit rate را کم می‌کند. Invalidation هنگام update یا versioned key cache stale را دور می‌زند. Eviction وقتی حافظه پر است انتخاب می‌کند چه چیزی بیرون برود: LRU بر اساس زمان استفادهٔ اخیر، LFU بر اساس فراوانی، و سیاست‌های دیگر براساس هزینه/اندازه. Hot key، working set بزرگ و object نامحدود می‌توانند cache را بی‌اثر کنند.

### Stampede، penetration و avalanche

Stampede یعنی چندین miss هم‌زمان برای key داغ؛ single-flight/lock محدود، TTL با jitter یا stale-while-revalidate کمک می‌کند. Cache penetration درخواست مکرر برای key ناموجود است؛ negative caching با TTL کوتاه و rate limit مناسب است. Avalanche انقضای هم‌زمان تعداد زیادی key است؛ expiry تصادفی و warmup مرحله‌ای فشار را پخش می‌کند. قفل توزیع‌شده هم باید timeout و رفتار recovery داشته باشد.

### Consistency و امنیت

Cache را برای اطلاعاتی که مجاز به stale بودن نیستند در مسیر تصمیم نهایی نگذار؛ checkout پس از cache کردن صفحهٔ محصول باید قیمت/موجودی را دوباره اعتبارسنجی کند. Cache key باید tenant، زبان یا scope لازم را لحاظ کند؛ نشت پاسخ private از cache خطای امنیتی است. دادهٔ حساس را رمزگذاری، زمان نگهداری را محدود و دسترسی را حداقلی کن.

### سنجش سود واقعی

Hit ratio، latency hit/miss، بار منبع، هزینهٔ حافظه، eviction، stale response و نرخ خطا را کنار هم بگذار. Hit ratio بالا که پاسخ اشتباه می‌دهد موفقیت نیست. یک endpoint را با و بدون cache و در cold/warm حالت مقایسه کن؛ بعد purge، deploy نسخهٔ جدید و خرابی cache را نیز بررسی کن.

## مثال عملی

کاتالوگ با TTL کوتاه cache می‌شود؛ checkout قیمت و موجودی را دوباره از منبع معتبر می‌گیرد.

## نمونهٔ قرارداد / شبه‌کد

~~~text
value = cache.get(key)
if value is None: value = db.read(key); cache.set(key, value, ttl=60)
~~~

## تجربهٔ موردی واقعی منتشرشده

[Cloudflare: کنترل Cache-Control و Cache key در edge](https://blog.cloudflare.com/introducing-cache-response-rules/) — مطالعهٔ موردی عمومی است؛ آن را با نسخه و محدودیت‌های زمان انتشار بخوان.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Cloudflare Blog](https://blog.cloudflare.com/)

Cache-aside برای read-heavy؛ write-through برای read-after-write؛ write-behind فقط برای دادهٔ بازسازی‌پذیر.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- cache stampede؛ stale write؛ کلید ناقص؛ PII بدون جداسازی؛ حد حافظه نداشتن.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. Cache-aside چه زمانی DB را می‌خواند؟
2. ریسک write-behind چیست؟
3. دو راه کاهش stampede را بگو.

### پاسخ‌نامهٔ فشرده

1. در cache miss منبع اصلی خوانده و معمولاً نتیجه در cache پر می‌شود.
2. اگر cache پیش از ذخیرهٔ پایدار تأیید بدهد، crash می‌تواند دادهٔ پذیرفته‌شده را حذف کند.
3. single-flight/lock در miss هم‌زمان، jitter در TTL، stale-while-revalidate یا محدودکردن نرخ پرکردن.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

Cache داده را نزدیک مصرف‌کننده نگه می‌دارد؛ سود latency در برابر stale data، invalidate، miss و stampede سنجیده می‌شود. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [لایه‌های کش در نمونهٔ فروشگاهی](https://virgool.io/%40m_58197875/%D9%85%D8%B9%D9%85%D8%A7%D8%B1%DB%8C-%D9%BE%D9%86%D9%87%D8%A7%D9%86-%DA%A9%D8%B4%DB%8C%D9%86%DA%AF-%D8%AF%D8%B1-%D8%AF%DB%8C%D8%AC%DB%8C-%DA%A9%D8%A7%D9%84%D8%A7-f25nhzmvsoyl)

### منابع انگلیسی و تجربه‌های مهندسی

- [Redis: Client-side caching](https://redis.io/docs/latest/develop/use/client-side-caching/)
- [Azure Architecture Center: Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
- [Cloudflare Blog](https://blog.cloudflare.com/)

</div>

