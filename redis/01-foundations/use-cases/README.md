<div dir="rtl" align="right">

# کاربردها و انتخاب الگو

> English edition: [Redis use cases and patterns](./README.en.md)

> سطح پیشنهادی: مقدماتی تا میانی · زمان: ۳۰ تا ۶۰ دقیقه

## هدف یادگیری

برای cache، session، شمارنده، leaderboard و پیام‌رسانی ساختار مناسب برگزینی.

## درس

الگوهای معمول: cache-aside برای کاهش خواندن از دیتابیس، session مشترک میان چند instance، شمارنده با INCR، leaderboard با Sorted Set، membership با Set، صف/رویداد با List یا Streams و اعلان زنده با Pub/Sub. اگر consumer آفلاین باید بعداً پیام را بخواند، Streams را به Pub/Sub ترجیح بده؛ Pub/Sub پیام را نگه نمی‌دارد.

برای cache، TTL و رفتار miss را تعریف کن. برای state مهم، Redis را با منبع حقیقت و مسیر بازیابی هماهنگ کن. اگر constraint رابطه‌ای یا query تحلیلی پیچیده لازم است، دیتابیس اصلی را حفظ کن.

## Cache-aside از صفر

فرض کن صفحهٔ محصول از PostgreSQL خوانده می‌شود و خواندن تکراری آن گران است. در cache-aside، خود برنامه Redis را می‌خواند:

1. برنامه کلید shop:product:42 را GET می‌کند.
2. اگر مقدار بود، پاسخ را برمی‌گرداند؛ این cache hit است.
3. اگر مقدار نبود، دیتابیس اصلی را می‌خواند؛ این cache miss است.
4. برنامه نتیجه را در Redis با TTL می‌نویسد و به کاربر برمی‌گرداند.
5. هنگام تغییر قیمت، برنامه دیتابیس اصلی را commit می‌کند و cache را حذف می‌کند تا درخواست بعدی مقدار تازه بخواند.

برای تصور فرمان‌های دو مرحلهٔ پایانی:

~~~text
SET cache:product:42 "{\"id\":42,\"price\":129000}" EX 300
GET cache:product:42
TTL cache:product:42
DEL cache:product:42
~~~

در پاسخ واقعی Redis، SET معمولاً OK می‌دهد، GET همان document را می‌دهد، TTL عدد ثانیهٔ باقی‌مانده را نشان می‌دهد و DEL تعداد keyهای حذف‌شده را برمی‌گرداند. این مثال یک مقدار JSON را به‌صورت String ذخیره می‌کند؛ JSON module type نیست و GET کل متن را می‌دهد. در فصل JSON فرق JSON بومی را می‌خوانی.

در cache-aside دیتابیس منبع حقیقت می‌ماند. Redis outage باید مسیر fallback مشخص داشته باشد: آیا همهٔ درخواست‌ها موقتاً مستقیم به SQL می‌روند؟ آیا خطا می‌دهیم؟ اگر میلیون‌ها miss هم‌زمان به SQL برسد، fallback خودش می‌تواند outage دوم بسازد. cache stampede را با TTL تصادفی، stale-while-revalidate یا lock کوتاه و قابل‌انقضا مدیریت می‌کنند؛ lock توزیع‌شده را بدون بررسی expiry، مالکیت و failover کپی نکن.

## پنج کاربرد را با نیاز واقعی تطبیق بده

### ۱. Session

در چند instance برنامه، session مشترک را زیر keyای مانند session:<opaque-id> نگه می‌دارند و TTL می‌گذارند. مقدار باید با logout یا پایان session پاک شود. شناسهٔ غیرقابل حدس استفاده کن؛ رمز، token خام یا دادهٔ حساس را بی‌دلیل در key name نگذار. از دست‌رفتن session چه معنایی دارد؟ اگر کاربر فقط دوباره login می‌کند، شاید تحمل‌پذیر باشد؛ اگر session حاوی state حیاتی است، backup و persistence را بسنج.

### ۲. شمارنده و rate limit

INCR برای شمارندهٔ atomic مناسب است. rate limit پنجره‌ای علاوه بر افزایش، باید زمان انقضا را هم درست تعیین کند. Redis 8.8 فرمان INCREX را معرفی کرده که افزایش، سقف و expiry را در یک فرمان اتمی می‌دهد:

~~~text
INCREX rate:user:42 BYINT 1 UBOUND 5 EX 60 ENX
~~~

مقدار بازگشتی دو بخش دارد: مقدار جدید و میزان افزایش انجام‌شده. وقتی افزایش از سقف بگذرد، delta صفر می‌شود و برنامه می‌تواند درخواست را رد کند. EX پنجرهٔ ۶۰ ثانیه‌ای می‌سازد؛ ENX می‌گوید اگر key از قبل TTL دارد، هر درخواست TTL را از نو شروع نکند. این فرمان از Redis 8.8.0 است؛ روی نسخهٔ قدیمی‌تر از الگوی Lua یا راهکار سازگار استفاده کن. این مثال یک الگوریتم fixed-window است؛ رفتار مرز پنجره با sliding window فرق دارد.

### ۳. Leaderboard

Sorted Set score را مرتب می‌کند و member کاربر یکتا است. امتیاز برابر ممکن است با ترتیب lexical عضوها شکسته شود؛ اگر قانون tie-break محصول متفاوت است، طراحی را مشخص کن. فصل Sorted Set آن را با نمونهٔ بازی توضیح می‌دهد.

### ۴. عضویت و آمار

Set برای «آیا کاربر عضو کمپین است؟» مناسب است. HyperLogLog وقتی تعداد unique تقریبی کافی است memory را کم می‌کند، ولی نمی‌تواند لیست عضوها را پس بدهد. آمار تقریبی را برای billing یا reconciliation استفاده نکن.

### ۵. پیام

Pub/Sub اعلان لحظه‌ای به subscriber آنلاین می‌دهد و پیام را نگه نمی‌دارد. Stream پیام را ثبت می‌کند و consumer group می‌تواند ack/pending داشته باشد. queue سادهٔ List هم به‌خودی‌خود recovery و replay کامل ندارد. تصمیم را با سؤال «اگر worker خاموش بود، آیا باید پیام را بعداً بگیرد؟» شروع کن.

## چه زمانی Redis را انتخاب نکنیم؟

- قرار نیست با اضافه‌کردن cache، query ضعیف یا schema نامناسب منبع اصلی را پنهان کنی.
- اگر latency فعلی قابل قبول است و دیتابیس بار مناسبی دارد، Redis فقط هزینهٔ عملیات و failure mode اضافه می‌کند.
- اگر داده نه قابل بازسازی است و نه RPO مشخص دارد، ابتدا طراحی durability/backup را انجام بده.
- اگر مسئله join، constraint یا گزارش چندبعدی است، از database مناسب همان query استفاده کن.

## طراحی cache محصول: پاسخ نمونه

برای «صفحهٔ پربازدید محصول» این design قابل شروع است:

- **منبع حقیقت:** PostgreSQL
- **کلید cache:** shop:product:{id}:summary:v1
- **TTL اولیه:** مثلاً ۵ دقیقه، همراه jitter؛ عدد نهایی از freshness requirement می‌آید.
- **miss:** خواندن از PostgreSQL، سپس cache کردن
- **تغییر قیمت:** commit در DB، سپس invalidate با outbox/event قابل retry؛ اگر حذف Redis شکست خورد، TTL حداکثر زمان stale را محدود می‌کند.
- **Redis outage:** fallback کنترل‌شده با محدودیت concurrency روی DB و metric
- **metric:** hit ratio، p95 latency، miss، خطای Redis و نرخ fallback به DB

این یک طرح آموزشی است، نه universal best practice. اگر قیمت حتی چند ثانیه stale بودنش پذیرفتنی نیست، مسیر checkout باید از منبع authoritative خوانده شود؛ cache صفحهٔ نمایش نباید تصمیم نهایی پرداخت را تعیین کند.

## مثال و آزمایش

برای این نیازها نوع داده، TTL و رفتار outage را بنویس: تعداد درخواست کاربر در دقیقه؛ ۱۰ رتبهٔ برتر بازی؛ رویداد سفارش با چند worker.

## تجربهٔ واقعی منتشرشده

DBS Bank در گزارش AWS از ElastiCache for Redis برای cache و محاسبات نزدیک به real-time قیمت‌گذاری استفاده کرده است. گزارش از بهبود ۱۰۰ برابری زمان پاسخ query قیمت می‌گوید؛ این عدد ادعای گزارش کیس است و تضمین workload دیگر نیست.

- [گزارش مطالعهٔ موردی](https://aws.amazon.com/solutions/case-studies/dbs-bank-case-study/)

## خطاهای رایج

Redis را بدون اندازه‌گیری اضافه نکن؛ invalidation، stampede، ظرفیت RAM و fallback به دیتابیس را طراحی کن.

## تمرین

1. مثال را در Redis محلی اجرا و خروجی را با زبان خودت توضیح بده.
2. دو حالت شکست یا edge case برای این الگو بنویس.
3. برای workload خودت حجم داده، نرخ خواندن/نوشتن، TTL یا retention و رفتار زمان outage را مشخص کن.
4. یک معیار بگذار: p95 latency، hit rate، RAM، lag، pending count یا زمان restore.

## کوییز

### 1. برای fan-out فوری با پیام قابل‌ازدست‌رفتن چه گزینه‌ای؟

<details><summary>پاسخ</summary>

Pub/Sub.

</details>

### 2. برای top-N امتیازها؟

<details><summary>پاسخ</summary>

Sorted Set.

</details>

### 3. آیا وجود Redis یعنی منبع حقیقت است؟

<details><summary>پاسخ</summary>

خیر؛ نقش، durability و recovery باید روشن باشد.

</details>

## منابع انگلیسی

- [نقشهٔ Redis در roadmap.sh](https://roadmap.sh/pdfs/roadmaps/redis.pdf)
- [patterns](https://redis.io/docs/latest/develop/use/patterns/)
- [compare data types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)

## منابع فارسی

- مرور فارسی کاربردها: https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh
- مرور ساختارها: https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf

> برای قابلیت‌های تخصصی، مستند رسمی نسخه‌ای را که اجرا می‌کنی مرجع اصلی بگیر. منابع فارسی تخصصی برای همهٔ موضوع‌ها پوشش یکسان ندارند؛ این محدودیت در لینک‌های مکمل مشخص است.

</div>
