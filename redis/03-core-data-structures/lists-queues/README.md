<div dir="rtl" align="right">

# List و صف ساده

> English edition: [Lists and simple queues](./README.en.md)

> سطح پیشنهادی: مقدماتی تا میانی · زمان: ۳۰ تا ۶۰ دقیقه

## هدف یادگیری

List را برای دنباله و صف ساده ارزیابی کنی.

## درس

List دنباله‌ای از رشته‌هاست. LPUSH/RPUSH از دو سر وارد می‌کنند؛ LPOP/RPOP برمی‌دارند؛ LRANGE و LLEN برای مشاهده‌اند. صف ساده می‌تواند producer را به RPUSH و consumer را به LPOP وصل کند. دستورهای blocking در صورت نبود کار می‌توانند منتظر بمانند.

List به‌تنهایی consumer group، pending recovery و replay رویدادی کامل ندارد. اگر acknowledgment، retry و چند consumer مهم‌اند، Streams یا broker اختصاصی را بررسی کن. انتقال اتمی، retry و idempotency را هم طراحی کن.

## ترتیب را از سمت producer و consumer بفهم

LPUSH عضو را به ابتدای List اضافه می‌کند و RPUSH به انتها؛ LPOP/RPOP از دو سر برمی‌دارند. برای صف FIFO دو ترکیب معمول وجود دارد:

- producer با RPUSH در انتها می‌گذارد و consumer با LPOP از ابتدا برمی‌دارد؛
- producer با LPUSH در ابتدا می‌گذارد و consumer با RPOP از انتها برمی‌دارد.

ترکیب دو سمت را اشتباه نکن؛ RPUSH و RPOP به‌تنهایی LIFO می‌سازند.

~~~text
RPUSH jobs:ready job:1001 job:1002 job:1003
LRANGE jobs:ready 0 -1
1) "job:1001"
2) "job:1002"
3) "job:1003"
LPOP jobs:ready
"job:1001"
LLEN jobs:ready
(integer) 2
~~~

LRANGE از index صفر شروع می‌کند و -1 یعنی تا انتها. روی List بزرگ، LRANGE 0 -1 همه را برمی‌گرداند و پاسخ بزرگی می‌سازد؛ برای debug کوچک خوب است، برای endpoint دائمی نه.

## منتظرماندن و جلوگیری از پنجرهٔ گم‌شدن پیام

اگر صف خالی باشد، BLPOP/BRPOP می‌تواند تا زمان معین منتظر بماند، به‌جای polling مداوم. اما LPOP عادی پیام را حذف می‌کند؛ اگر worker بلافاصله پس از برداشتن کار crash کند، آن کار دیگر در صف نیست.

در Redis 6.2+ می‌توان BLMOVE را برای انتقال اتمی از صف آماده به صف پردازش‌شده به‌کار برد:

~~~text
RPUSH jobs:ready job:1001
BLMOVE jobs:ready jobs:processing RIGHT LEFT 0
"job:1001"
LRANGE jobs:processing 0 -1
1) "job:1001"
LREM jobs:processing 1 job:1001
(integer) 1
~~~

در این الگو producer با RPUSH اضافه می‌کند و worker عضو قدیمی را از سمت RIGHT برمی‌دارد و به ابتدای jobs:processing می‌برد. صفر در آخر BLMOVE یعنی بدون timeout منتظر بمان. پس از موفقیت کار، worker آن شناسه را از processing حذف می‌کند. اگر worker پس از انتقال بمیرد، پیام در processing مانده و دیگر ready نیست؛ یک sweeper باید کارهای مانده را با lease/زمان آخرین فعالیت شناسایی و به صف آماده برگرداند. خود List زمان ورود یا مالک را ثبت نمی‌کند، پس production pattern به metadata جدا یا Streams نیاز دارد.

برای taskهای هم‌نام، LREM می‌تواند عضو نامناسب را حذف کند؛ از ID یکتا استفاده کن. دستور blocking یک اتصال client را مشغول نگه می‌دارد، بنابراین client pool را برای workerهای blocking درست تنظیم کن.

## List چه چیزی را تضمین نمی‌کند؟

- consumer group، pending list و XACK شبیه Streams ندارد.
- retry خودکار یا dead-letter queue آماده ندارد.
- خود List زمان ایجاد عضو یا مالک پردازش را نگه نمی‌دارد.
- اگر کاربر چند بار همان درخواست را بفرستد، ممکن است job تکراری بسازی؛ idempotency باید در handler باشد.

List برای صف کوچک و سادهٔ درون یک برنامه مناسب است. برای event log، چند گروه مصرف‌کننده، replay، pending recovery و عملیات روزانه روی message state، فصل Streams را بخوان. اگر retention بلندمدت، partitioning یا ecosystem connector گسترده لازم داری، message broker را هم مقایسه کن.

## تمرین با پاسخ

1. پنج task را با RPUSH اضافه و یکی‌یکی با LPOP بگیر؛ ترتیب را ثبت کن.
2. List را خالی کن، BLPOP را با timeout کوتاه اجرا و از اتصال دوم task اضافه کن.
3. BLMOVE را اجرا و بلافاصله فرض کن worker crash کرد؛ نشان بده job در processing باقی می‌ماند.
4. همان job را recovery کن و توضیح بده چرا handler باید idempotent باشد.

**پاسخ:** RPUSH+LPOP FIFO است. BLPOP بعد از timeout پاسخ خالی می‌دهد، یا در صورت درج task آن را تحویل می‌دهد. BLMOVE انتقال ready→processing را اتمی می‌کند و پنجرهٔ crash بین pop و push را حذف می‌کند، اما recovery processing list و duplicate execution را خودش حل نمی‌کند.

## مثال و آزمایش

```text
LPUSH jobs:ready "email:101"
LPUSH jobs:ready "email:102"
LLEN jobs:ready
RPOP jobs:ready
LRANGE jobs:ready 0 -1
```

## تجربهٔ کاربردی و سناریوی طراحی

صف کارهای سبک می‌تواند با List شروع شود؛ پردازش پیام که از دست رفتن آن مجاز نیست به ack، retry و recovery نیاز دارد.

این بخش یک الگوی مهندسی/تمرین است؛ آن را به شرکت مشخصی نسبت نده.

## خطاهای رایج

برداشتن پیام و crash قبل از کار، پیام را گم می‌کند؛ retry بدون idempotency می‌تواند دوباره‌کاری کند.

## تمرین

1. مثال را در Redis محلی اجرا و خروجی را با زبان خودت توضیح بده.
2. دو حالت شکست یا edge case برای این الگو بنویس.
3. برای workload خودت حجم داده، نرخ خواندن/نوشتن، TTL یا retention و رفتار زمان outage را مشخص کن.
4. یک معیار بگذار: p95 latency، hit rate، RAM، lag، pending count یا زمان restore.

## کوییز

### 1. LPUSH چه می‌کند؟

<details><summary>پاسخ</summary>

عضو را به ابتدای List اضافه می‌کند.

</details>

### 2. چه زمانی List کافی نیست؟

<details><summary>پاسخ</summary>

وقتی pending recovery، ack، replay یا گروه مصرف لازم است.

</details>

### 3. چرا idempotency مهم است؟

<details><summary>پاسخ</summary>

retry ممکن است یک کار را دوباره اجرا کند.

</details>

## منابع انگلیسی

- [نقشهٔ Redis در roadmap.sh](https://roadmap.sh/pdfs/roadmaps/redis.pdf)
- [lists](https://redis.io/docs/latest/develop/data-types/lists/)
- [blmove](https://redis.io/docs/latest/commands/blmove/)

## منابع فارسی

- مرور فارسی ساختارها و صف: https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf
- جست‌وجوی تکمیلی: https://www.youtube.com/results?search_query=آموزش+فارسی+Redis+List+Queue

> برای قابلیت‌های تخصصی، مستند رسمی نسخه‌ای را که اجرا می‌کنی مرجع اصلی بگیر. منابع فارسی تخصصی برای همهٔ موضوع‌ها پوشش یکسان ندارند؛ این محدودیت در لینک‌های مکمل مشخص است.

</div>
