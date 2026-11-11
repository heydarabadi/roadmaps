<div dir="rtl" align="right">

# Sorted Set و رتبه‌بندی

> English edition: [Sorted Sets and ranking](../../../../en/redis/03-core-data-structures/sorted-sets/README.md)

> سطح پیشنهادی: مقدماتی تا میانی · زمان: ۳۰ تا ۶۰ دقیقه

## هدف یادگیری

رتبه‌بندی، top-N و زمان‌بندی را با score طراحی کنی.

## درس

Sorted Set اعضای یکتا را براساس score مرتب می‌کند. ZADD درج/به‌روزرسانی، ZRANGE بازه، ZRANK جایگاه، ZREM حذف و ZINCRBY افزایش score را انجام می‌دهند. برای بالاترین score از دستورهای range معکوس استفاده کن. score برابر نیز tie-break خود را دارد و باید برای محصول قابل قبول باشد.

Leaderboard و صف زمان‌بندی نمونه‌اند، اما TTL در سطح key است نه عضو؛ حذف بازه‌ای را طراحی کن. برای syntax جدیدتر، مستندات نسخهٔ نصب‌شده را بررسی کن.

## از score تا رتبه

Sorted Set دو مفهوم نگه می‌دارد: member یکتا و score عددی. Redis اعضا را با score مرتب می‌کند. درج دوبارهٔ همان member عضو دومی نمی‌سازد؛ score همان member عوض می‌شود.

~~~text
ZADD game:season:9 1200 user:42 1850 user:17 1430 user:99
(integer) 3
ZCARD game:season:9
(integer) 3
ZREVRANGE game:season:9 0 2 WITHSCORES
1) "user:17"
2) "1850"
3) "user:99"
4) "1430"
5) "user:42"
6) "1200"
ZREVRANK game:season:9 user:17
(integer) 0
~~~

index بازهٔ ZREVRANGE از صفر شروع می‌شود؛ 0 تا 2 سه عضو اول را می‌گیرد. WITHSCORES مقدار امتیاز را هم برمی‌گرداند. ZREVRANK نفر اول را رتبهٔ صفر می‌دهد. در مقابل، ZRANK از پایین‌ترین score شروع می‌کند. قبل از نشان‌دادن rank به کاربر، قرارداد محصول را مشخص کن: آیا UI از 1 می‌شمارد؟

## تغییر امتیاز، فیلتر و tie

~~~text
ZINCRBY game:season:9 25 user:42
"1225"
ZRANGEBYSCORE game:season:9 1200 1500 WITHSCORES
1) "user:42"
2) "1225"
3) "user:99"
4) "1430"
ZCOUNT game:season:9 1200 1500
(integer) 2
~~~

ZINCRBY score را اتمی تغییر می‌دهد و score جدید را برمی‌گرداند. ZRANGEBYSCORE محدودهٔ score می‌گیرد؛ در نسخه‌های جدید، ZRANGE با BYSCORE هم برای range استفاده می‌شود. مرزها به‌طور معمول inclusive هستند؛ پرانتز را برای exclude مرز بررسی کن. برای بازهٔ بزرگ از LIMIT با صفحه‌بندی استفاده کن، اما هنگام تغییر هم‌زمان رتبه‌ها، offset pagination ممکن است رکورد را جابه‌جا یا تکرار کند.

اگر دو member score یکسان داشته باشند، Redis آن‌ها را با ترتیب lexical member مرتب می‌کند. اگر مسابقه نیازمند tie-break مثل زمان رسیدن باشد، آن را در member/score encoding یا دادهٔ جدا طراحی و مستند کن؛ فرض نکن دو امتیاز برابر یک ترتیب تصادفی می‌گیرند.

## فرمان‌های نگهداری

- ZSCORE امتیاز یک member را می‌خواند.
- ZREM member را حذف می‌کند.
- ZCARD تعداد memberهای key را می‌دهد.
- ZCOUNT تعداد memberهای یک score range را می‌دهد.
- ZPOPMIN/ZPOPMAX عضو کمترین/بیشترین score را برمی‌دارند و حذف می‌کنند.
- ZADD با NX فقط member جدید را درج می‌کند؛ XX فقط member موجود را به‌روزرسانی می‌کند.

قبل از pop در queue-like design، بررسی کن حذف عضو پیش از انجام کار باعث گم‌شدن job نشود. Sorted Set برای مرتب‌سازی score است؛ acknowledgment و retry خودکار ندارد.

## سه مدل استفاده

1. **Leaderboard:** member=user ID، score=امتیاز؛ باید reset فصل و tie policy تعریف شود.
2. **Scheduled work:** member=job ID، score=زمان اجرای epoch؛ worker با range از زمان حال به بعد کارهای رسیده را پیدا می‌کند.
3. **Priority queue:** score=priority؛ dequeue با ZPOPMIN/MAX بسته به قرارداد اولویت انجام می‌شود.

در همهٔ این‌ها TTL فقط روی کل key است. اگر هر job تاریخ انقضای متفاوت دارد، worker باید range قدیمی‌ها را پاک کند یا model دیگری بگیرد. استفاده از timestamp به‌عنوان score هم به واحد و دامنهٔ score حساس است؛ ثانیه یا millisecond را قاطی نکن.

## تمرین با پاسخ

1. سه player با امتیاز متفاوت اضافه کن و top 2 را با score بخوان.
2. امتیاز بازیکن را با ZINCRBY تغییر بده و rank را دوباره بررسی کن.
3. دو player با امتیاز برابر وارد کن و tie را مشاهده کن.
4. طراحی کن که آیا Sorted Set برای queue کاری با retry و ack کافی است.

**پاسخ:** ZREVRANK برای بالاترین score صفر می‌دهد. با تغییر score rank ممکن است تغییر کند. tie-break بر اساس member lexical است. برای queue قابل‌اعتماد، retry/pending/ack باید جدا طراحی شود؛ Streams یا broker پایدار ممکن است مناسب‌تر باشد.

## مثال و آزمایش

```text
ZADD game:season:9 1200 user:42 1850 user:17 1430 user:99
ZREVRANGE game:season:9 0 9 WITHSCORES
ZREVRANK game:season:9 user:17
ZINCRBY game:season:9 25 user:42
```

## تجربهٔ کاربردی و سناریوی طراحی

Leaderboard بازی الگوی رایجی است؛ pagination هنگام تغییر هم‌زمان score ممکن است جابه‌جا شود. برای top-N پرترافیک، حجم عضوها را اندازه‌گیری کن.

این بخش یک الگوی مهندسی/تمرین است؛ آن را به شرکت مشخصی نسبت نده.

## خطاهای رایج

انتظار TTL برای هر عضو، یا تعریف‌نکردن tie-break برای score برابر.

## تمرین

1. مثال را در Redis محلی اجرا و خروجی را با زبان خودت توضیح بده.
2. دو حالت شکست یا edge case برای این الگو بنویس.
3. برای workload خودت حجم داده، نرخ خواندن/نوشتن، TTL یا retention و رفتار زمان outage را مشخص کن.
4. یک معیار بگذار: p95 latency، hit rate، RAM، lag، pending count یا زمان restore.

## کوییز

### 1. اعضای Sorted Set یکتا هستند؟

<details><summary>پاسخ</summary>

بله؛ هر member یکتا است و ZADD امتیازش را به‌روزرسانی می‌کند.

</details>

### 2. برای top scores چه نوعی؟

<details><summary>پاسخ</summary>

Sorted Set.

</details>

### 3. TTL مستقل برای هر member وجود دارد؟

<details><summary>پاسخ</summary>

خیر؛ expiry در سطح key است.

</details>

## منابع انگلیسی

- [نقشهٔ Redis در roadmap.sh](https://roadmap.sh/pdfs/roadmaps/redis.pdf)
- [sorted sets](https://redis.io/docs/latest/develop/data-types/sorted-sets/)

## منابع فارسی

- مرور فارسی ساختارها: https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf
- جست‌وجوی تکمیلی: https://www.youtube.com/results?search_query=آموزش+فارسی+Redis+Sorted+Set+leaderboard

> برای قابلیت‌های تخصصی، مستند رسمی نسخه‌ای را که اجرا می‌کنی مرجع اصلی بگیر. منابع فارسی تخصصی برای همهٔ موضوع‌ها پوشش یکسان ندارند؛ این محدودیت در لینک‌های مکمل مشخص است.

</div>
