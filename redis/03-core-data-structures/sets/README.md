<div dir="rtl" align="right">

# Set و عملیات عضویت

> English edition: [Sets and membership operations](./README.en.md)

> سطح پیشنهادی: مقدماتی تا میانی · زمان: ۳۰ تا ۶۰ دقیقه

## هدف یادگیری

Set را برای عضوهای یکتا و عملیات مجموعه‌ای به‌کار ببری.

## درس

Set مجموعهٔ بدون ترتیب از عضوهای یکتاست. SADD درج، SREM حذف، SISMEMBER بررسی عضویت و SCARD شمارش می‌کند. SINTER، SUNION و SDIFF اشتراک، اجتماع و تفاضل را می‌سازند. برای پیمایش مجموعهٔ بزرگ SSCAN را بشناس؛ بازگرداندن همهٔ عضوها با SMEMBERS می‌تواند پاسخ بسیار بزرگی بسازد.

Set برای tag، گروه، دنبال‌کننده و membership مناسب است. اگر ترتیب score لازم است Sorted Set را بگیر. در Cluster، عملیات چندکلیدی ممکن است نیازمند قرارگرفتن keyها در یک hash slot باشد.

## Set چه چیزی را مدل می‌کند؟

Set مجموعه‌ای از memberهای یکتا و بدون ترتیب است. اگر عضو یک بار یا صد بار SADD شود، در set یک عضو می‌ماند. این رفتار برای «کاربر در کمپین عضو شده؟»، «این tag به مقاله وصل است؟» یا «کاربر این محصول را پسندیده؟» مناسب است. اگر باید هر بار تکرار به‌عنوان event جدا ثبت شود، Set مدل درستی نیست.

~~~text
SADD campaign:summer members:user:42 members:user:17 members:user:42
(integer) 2
SISMEMBER campaign:summer members:user:42
(integer) 1
SCARD campaign:summer
(integer) 2
SREM campaign:summer members:user:17
(integer) 1
~~~

SADD تعداد memberهای تازه‌اضافه‌شده را برمی‌گرداند، نه تعداد کل. SISMEMBER عدد 1 یا 0 می‌دهد؛ SCARD اندازهٔ set است. از این پاسخ‌ها می‌توان عملیات idempotent ساخت: دوباره‌اضافه‌کردن همان member وضعیت را دو برابر نمی‌کند.

## عملیات مجموعه‌ای

برای ترکیب گروه‌ها:

~~~text
SADD user:42:following user:17 user:99
SADD user:99:following user:17 user:55
SINTER user:42:following user:99:following
1) "user:17"
SUNION user:42:following user:99:following
1) "user:17"
2) "user:99"
3) "user:55"
SDIFF user:42:following user:99:following
1) "user:99"
~~~

SINTER اشتراک، SUNION اجتماع، SDIFF عضوهای set اول را که در setهای بعدی نیستند می‌دهد. order پاسخ‌ها تضمین‌شده نیست. اگر setها بزرگ‌اند، زمان ترکیب و تعداد پاسخ را بسنج؛ نتیجهٔ بزرگ ممکن است memory/شبکه را تحت فشار بگذارد. برای ذخیرهٔ نتیجهٔ ترکیب، دستورهای STORE خانوادهٔ set را بررسی کن.

## پیمایش و انتخاب نوع

SMEMBERS برای دیدن همهٔ عضوهای یک set کوچک و آزمایش مناسب است؛ برای set بزرگ، SSCAN را با cursor تا صفر ادامه بده. مثل SCAN، COUNT یک hint است و ممکن است member تکراری ببینی. query روزمرهٔ برنامه را با SCAN پیاده نکن؛ برای پاسخ membership از SISMEMBER و برای لیست‌کردن محدود، مدل دسترسی مناسب بساز.

Set را با این‌ها مقایسه کن:

- **List:** ترتیب و duplicate دارد؛ Set ندارد.
- **Sorted Set:** member یکتا است، ولی score و rank هم دارد.
- **Hash:** field/value یک رکورد است؛ Set فقط عضویت عضوها را نگه می‌دارد.

برای likes:product:42 می‌توان user IDها را به‌صورت member ذخیره کرد. بااین‌حال، اگر نیاز داری زمان like را بدانی، Set تنها کافی نیست؛ Sorted Set با timestamp یا event log را بررسی کن. اگر نیاز به توصیف رابطه یا queryهای پیچیده داری، انتخاب Redis را با دیتابیس اصلی مقایسه کن.

## خطاهای داده‌ای و Cluster

Set ترتیب insertion را حفظ نمی‌کند و نتیجهٔ SMEMBERS را بر اساس ترتیب دلخواه UI نشان نده. در Cluster، دستورهای چندکلیدی مثل SINTER باید کلیدها را روی slotهای سازگار ببیند؛ hash tag می‌تواند keyهای لازم را هم‌slot کند، ولی hotspot را هم ممکن است زیاد کند. Set بزرگ با member تکراری مشکلی ندارد، اما ساخت چند key مرتبط بدون قرارداد prefix مدیریت را دشوار می‌کند.

## تمرین با پاسخ

1. سه user را به set کمپین اضافه کن؛ یکی را دوبار وارد کن و پاسخ SADD را توضیح بده.
2. دو set دنبال‌شونده بساز و اشتراک/اجتماع را محاسبه کن.
3. یک member حذف کن و SISMEMBER را دوباره اجرا کن.
4. SSCAN را تا cursor صفر ادامه بده؛ چرا نتیجه را sort نمی‌کنی و چرا ممکن است duplicate را تحمل کنی؟

**پاسخ:** درج تکراری پاسخ تازه‌اضافه‌شده را افزایش نمی‌دهد. عضو حذف‌شده در SISMEMBER پاسخ 0 می‌دهد. Set ترتیب ندارد؛ SSCAN iteration تدریجی است و cursor تا صفر ادامه می‌یابد، ممکن است عضو تکراری برگرداند.

## مثال و آزمایش

```text
SADD article:42:tags redis database tutorial
SISMEMBER article:42:tags redis
SCARD article:42:tags
SINTER user:42:following user:99:following
SSCAN article:42:tags 0 COUNT 100
```

## تجربهٔ کاربردی و سناریوی طراحی

اشتراک دنبال‌کنندگان دو کاربر یا مجموعهٔ tagها نمونه‌های رایج‌اند. اندازهٔ نتیجه را کنترل کن.

این بخش یک الگوی مهندسی/تمرین است؛ آن را به شرکت مشخصی نسبت نده.

## خطاهای رایج

انتظار ترتیب ثابت، SMEMBERS بی‌قید برای دادهٔ بزرگ، یا اجرای چندکلیدی بدون توجه به slot.

## تمرین

1. مثال را در Redis محلی اجرا و خروجی را با زبان خودت توضیح بده.
2. دو حالت شکست یا edge case برای این الگو بنویس.
3. برای workload خودت حجم داده، نرخ خواندن/نوشتن، TTL یا retention و رفتار زمان outage را مشخص کن.
4. یک معیار بگذار: p95 latency، hit rate، RAM، lag، pending count یا زمان restore.

## کوییز

### 1. Set ترتیب insertion را حفظ می‌کند؟

<details><summary>پاسخ</summary>

خیر، ترتیب تضمین‌شده ندارد.

</details>

### 2. بررسی عضویت با چه دستوری است؟

<details><summary>پاسخ</summary>

SISMEMBER.

</details>

### 3. برای پیمایش تدریجی؟

<details><summary>پاسخ</summary>

SSCAN و دنبال‌کردن cursor تا پایان iteration.

</details>

## منابع انگلیسی

- [نقشهٔ Redis در roadmap.sh](https://roadmap.sh/pdfs/roadmaps/redis.pdf)
- [sets](https://redis.io/docs/latest/develop/data-types/sets/)
- [sscan](https://redis.io/docs/latest/commands/sscan/)

## منابع فارسی

- مرور فارسی ساختارها: https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf

> برای قابلیت‌های تخصصی، مستند رسمی نسخه‌ای را که اجرا می‌کنی مرجع اصلی بگیر. منابع فارسی تخصصی برای همهٔ موضوع‌ها پوشش یکسان ندارند؛ این محدودیت در لینک‌های مکمل مشخص است.

</div>
