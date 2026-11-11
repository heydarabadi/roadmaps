<div dir="rtl" align="right">

# redis-cli، دستورها، کلیدها و TTL

> English edition: [redis-cli, commands, keys, and TTL](../../../../en/redis/02-getting-started/cli-keys-ttl/README.md)

> سطح پیشنهادی: مقدماتی تا میانی · زمان: ۳۰ تا ۶۰ دقیقه

## هدف یادگیری

دستورهای پایه را اجرا و کلیدها را با namespace و expiry طراحی کنی.

## درس

PING، SET/GET، DEL، EXISTS، TYPE، TTL، EXPIRE، SCAN و INFO ابزارهای پایه‌اند. از SCAN برای پیمایش تدریجی کلیدها استفاده کن؛ KEYS * می‌تواند سرور را برای پیمایش بزرگ متوقف کند. TTL برابر -2 یعنی کلید وجود ندارد و -1 یعنی کلید بدون انقضاست. کلیدهایی مانند shop:prod:product:42:summary نام‌فضا و نوع رکورد را روشن می‌کنند.

TTL بخشی از freshness است، نه جایگزین invalidation. TTL jitter می‌تواند expiry هم‌زمان تعداد زیادی cache key را پخش کند. در Cluster، hash tag مانند cart:{42}:items چند کلید مرتبط را هم‌slot می‌کند.

## شکل یک فرمان و پاسخ

در cli، هر خط معمولاً یک فرمان است. پس از ارسال، پاسخ همان فرمان را می‌خوانی و بعد فرمان بعدی می‌آید. پاسخ‌ها نوع‌دارند: عدد integer، متن status مانند OK، مقدار bulk string یا فهرست چندبخشی.

~~~text
SET course:demo "hello"
OK
GET course:demo
"hello"
TYPE course:demo
string
EXISTS course:demo
(integer) 1
~~~

Redis به بزرگی/کوچکی حروف key حساس است؛ course:demo و Course:demo دو key متفاوت‌اند. نام key فقط متن دلخواه نیست: باید برای خواننده قابل فهم، برای برنامه پایدار و از نظر privacy بی‌خطر باشد.

## الگوی نام‌گذاری کلید

ساختار پیشنهادی برای پروژه:

~~~text
<app>:<environment>:<entity>:<id>:<subresource>
shop:prod:product:42:summary
shop:prod:session:9cd8...
~~~

colon فقط قرارداد خوانایی است؛ Redis آن را مثل پوشه یا namespace واقعی تفسیر نمی‌کند. prefix برنامه و محیط، برخورد keyها را کمتر می‌کند. مقدار حساس مانند شماره تلفن یا token را در نام key نگذار؛ keyها ممکن است در log یا ابزارهای پایش دیده شوند. نام‌گذاری را از اول با تیم هماهنگ کن، چون تغییر prefix یعنی migration یا dual-read/dual-write.

## خروجی TTL را درست بخوان

~~~text
SET course:ttl "short-lived"
TTL course:ttl
-1
EXPIRE course:ttl 120
(integer) 1
TTL course:ttl
(integer) 120
~~~

TTL برابر -1 یعنی key وجود دارد ولی انقضا ندارد. TTL برابر -2 یعنی key پیدا نشد یا منقضی شده است. عدد مثبت تعداد ثانیهٔ باقی‌مانده را به‌صورت تقریبی می‌دهد و ممکن است در هر خواندن کمتر شود. برای میلی‌ثانیه از PTTL و برای انقضای مطلق از EXPIREAT استفاده کن.

اگر TTL حتماً باید همراه نوشتن اعمال شود، SET با EX/PX را در همان فرمان انجام بده:

~~~text
SET cache:item:42 "value" EX 300
~~~

این کار فاصلهٔ زمانی میان SET و EXPIRE را حذف می‌کند. نکتهٔ مهم: SET موفق روی key موجود، مقدار قبلی را جایگزین می‌کند و TTL قبلی را پاک می‌کند، مگر KEEPTTL بگذاری یا TTL تازه را همان‌جا تعیین کنی. در مقابل INCR، HSET و LPUSH که مقدار همان ساختار را تغییر می‌دهند معمولاً TTL خود key را حفظ می‌کنند.

## حذف، ماندگاری و نوع

~~~text
SET course:ttl "short-lived" EX 120
PERSIST course:ttl
(integer) 1
TTL course:ttl
(integer) -1
DEL course:ttl
(integer) 1
EXISTS course:ttl
(integer) 0
TTL course:ttl
(integer) -2
~~~

PERSIST expiry را حذف می‌کند و key را بدون timeout می‌گذارد؛ DEL خود key را حذف می‌کند. پاسخ ۱ یعنی تغییری انجام شده و ۰ معمولاً یعنی key پیدا نشده/عملی انجام نشده است. مراقب باش PERSIST را اشتباهی روی cache نزنی: ممکن است key دیگر خودکار پاک نشود.

TYPE بهت می‌گوید دستورهای بعدی باید برای کدام ساختار باشند:

~~~text
SET course:type "x"
TYPE course:type
string
HSET course:record name Sara
(integer) 1
TYPE course:record
hash
~~~

اگر key از نوع دیگری باشد، Redis معمولاً آن را خودکار تبدیل نمی‌کند و خطای WRONGTYPE می‌دهد. کلیدهای دارای prefix مشترک فقط نام مشابه‌اند؛ نوع داده را TYPE مشخص می‌کند.

## چرا KEYS * خطر دارد و SCAN چگونه کار می‌کند؟

KEYS * همهٔ نام‌ها را یک‌باره برمی‌گرداند؛ روی keyspace بزرگ ممکن است event loop سرور را برای مدت قابل‌توجه مشغول کند. در برنامهٔ واقعی از KEYS برای پیدا کردن داده استفاده نکن.

SCAN cursor-based است. iteration را از cursor صفر آغاز می‌کنی، cursor جدید پاسخ را به فرمان بعدی می‌دهی، و فقط وقتی cursor برگشتی صفر شد iteration کامل شده است:

~~~text
SCAN 0 MATCH shop:prod:product:* COUNT 100
1) "12"
2) 1) "shop:prod:product:42:summary"
~~~

عدد 12 در این نمونه فقط cursor بعدی است؛ مقدار واقعی در سرور تو ممکن است فرق داشته باشد. ادامه:

~~~text
SCAN 12 MATCH shop:prod:product:* COUNT 100
~~~

COUNT یک hint برای میزان کار همان call است، نه تضمین دقیقاً ۱۰۰ نتیجه. ممکن است یک صفحه خالی باشد ولی cursor هنوز صفر نباشد. برخی keyها ممکن است تکراری برگردند؛ کاری که روی هر نتیجه می‌کنی باید duplicate-safe باشد. SCAN snapshot ثابت از keyspace نمی‌سازد و هنگام تغییر هم‌زمان مجموعه، نتیجهٔ کل اسکن الزاماً یک فهرست لحظه‌ای نیست. برای pagination محصول، مدل key را عوض نکن تا بعداً به SCAN تکیه کنی.

## Database منطقی، namespace و Cluster

در بعضی نصب‌های standalone می‌توان با SELECT شمارهٔ database منطقی را عوض کرد. این‌ها همان server و همان حافظه/منابع‌اند و مرز امنیتی یا tenant isolation نیستند. Redis Cluster از SELECT برای جابه‌جایی database پشتیبانی نمی‌کند؛ بنابراین پروژه‌های توزیع‌شده بهتر است از prefix کلید و user ACL استفاده کنند، نه شمارهٔ DB به‌عنوان مرز tenancy.

در Cluster، دو کلید با hash tag یکسان، مثل cart:{42}:items و cart:{42}:total، به یک slot می‌روند. این برای multi-key operation سازگار مفید است؛ ولی هم‌slot کردن بی‌برنامه می‌تواند یک shard را داغ کند.

## تمرین مرحله‌ای و پاسخ

1. یک key رشته‌ای بساز، TYPE بگیر، به آن TTL بده و TTL را دوباره بخوان.
2. مقدار را با SET عوض کن و TTL را چک کن؛ چرا تغییر کرد؟
3. یک key را بدون TTL و یک key را با EX ذخیره کن؛ خروجی TTL را مقایسه کن.
4. سه key با prefix آزمایشی بساز و از SCAN 0 تا cursor صفر پیمایش کن.
5. یک hash بساز و با GET امتحان کن؛ خطای نوع را بخوان، سپس TYPE و HGETALL را اجرا کن.

**پاسخ:** SET معمولی TTL قبلی را حذف می‌کند؛ EXPIRE یا SET EX یک expiry می‌گذارد؛ key موجود بدون expiry عدد -1 دارد و key ناموجود -2. SCAN باید تا cursor صفر ادامه یابد، حتی اگر یک call نتیجهٔ خالی بدهد. Hash را با HGETALL بخوان، نه GET.

## مثال و آزمایش

```text
SET cache:product:42 '{"id":42,"name":"keyboard"}' EX 300
TTL cache:product:42
SCAN 0 MATCH cache:* COUNT 100
DEL cache:product:42
TYPE cache:product:42
```

## تجربهٔ کاربردی و سناریوی طراحی

در عملیات واقعی، بررسی endpoint، DB و namespace پیش از اسکن یا حذف داده خطای انسانی را کم می‌کند؛ این رویهٔ عمومی است.

این بخش یک الگوی مهندسی/تمرین است؛ آن را به شرکت مشخصی نسبت نده.

## خطاهای رایج

استفاده از KEYS روی دیتابیس بزرگ، TTL فراموش‌شده، اجرای FLUSHALL روی سرویس واقعی، یا استفاده از pattern scan به‌جای مدل query برنامه.

## تمرین

1. مثال را در Redis محلی اجرا و خروجی را با زبان خودت توضیح بده.
2. دو حالت شکست یا edge case برای این الگو بنویس.
3. برای workload خودت حجم داده، نرخ خواندن/نوشتن، TTL یا retention و رفتار زمان outage را مشخص کن.
4. یک معیار بگذار: p95 latency، hit rate، RAM، lag، pending count یا زمان restore.

## کوییز

### 1. TTL -1 و -2 چه معنایی دارند؟

<details><summary>پاسخ</summary>

-1 یعنی کلید هست و expiry ندارد؛ -2 یعنی کلید نیست.

</details>

### 2. چرا SCAN به‌جای KEYS؟

<details><summary>پاسخ</summary>

پیمایش تدریجی انجام می‌دهد و مکث یک‌بارهٔ طولانی را کم می‌کند.

</details>

### 3. hash tag چه فایده‌ای دارد؟

<details><summary>پاسخ</summary>

چند key را در یک hash slot قرار می‌دهد.

</details>

## منابع انگلیسی

- [نقشهٔ Redis در roadmap.sh](https://roadmap.sh/pdfs/roadmaps/redis.pdf)
- [cli](https://redis.io/docs/latest/develop/tools/cli/)
- [scan](https://redis.io/docs/latest/commands/scan/)
- [expire](https://redis.io/docs/latest/commands/expire/)

## منابع فارسی

- مرور فارسی کلید و دستورها: https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf
- مقالهٔ مقدماتی: https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh

> برای قابلیت‌های تخصصی، مستند رسمی نسخه‌ای را که اجرا می‌کنی مرجع اصلی بگیر. منابع فارسی تخصصی برای همهٔ موضوع‌ها پوشش یکسان ندارند؛ این محدودیت در لینک‌های مکمل مشخص است.

</div>
