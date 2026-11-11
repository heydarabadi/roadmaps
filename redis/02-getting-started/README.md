<div dir="rtl" align="right">

# فصل ۲ — نصب، اتصال و اولین دستورها

> English edition: [Chapter 2 — Getting started](./README.en.md)

> در این فصل یک Redis محلی و ایزوله می‌سازی و قرارداد کلاینت/سرور، redis-cli، key، type و TTL را یاد می‌گیری. زمان پیشنهادی: ۹۰ تا ۱۲۰ دقیقه.

## ترتیب درس

1. [درس صفر: محیط آزمایش](../00-start-here/README.md) را اجرا کن؛ برای تمام فرمان‌های تغییردهنده از همین محیط محلی استفاده کن.
2. [نصب و اتصال](./install-run/README.md) را بخوان؛ وضعیت Docker، port، server health، log و version را یاد بگیر.
3. [redis-cli، keyها و TTL](./cli-keys-ttl/README.md) را بخوان؛ RESP، پاسخ فرمان، namespace، expiration و جست‌وجوی key را تمرین کن.

## از فرمان تا پاسخ

یک client مانند `redis-cli` به server وصل می‌شود و فرمان را با آرگومان‌های جداگانه می‌فرستد. `SET greeting salam` یک دستور است؛ مقدار با فضای خالی باید quote شود. پاسخ Redis متن سادهٔ success، مقدار، عدد، خطا یا مجموعه‌ای از داده‌هاست. در این دوره، متن بلوک `text` را بعد از ورود به redis-cli تایپ کن؛ بلوک `powershell` را در PowerShell اجرا کن.

کلید را نام‌گذاری کن، مثلاً `course:session:student-7` یا `catalog:product:42`. پیشوند namespace قابلیت پیدا کردن/پاک‌سازی هدفمند و در ACL محدودکردن دسترسی را بهتر می‌کند. اسم key بخشی از قرارداد برنامه است: اگر clientهای مختلف برداشت متفاوت داشته باشند، داده به‌سختی قابل اداره می‌شود.

TTL رفتار key را در زمان تعریف می‌کند. زمان پایان TTL به معنی تضمین حذف در همان میلی‌ثانیه نیست؛ expire semantics را برای منطق برنامه جدی بگیر. TTL را برای cache/session مناسب انتخاب کن، نه برای داده‌ای که نباید بی‌خبر حذف شود.

## لَب فصل

```text
PING
SET course:hello "Salam Redis"
GET course:hello
TYPE course:hello
EXPIRE course:hello 60
TTL course:hello
SCAN 0 MATCH course:* COUNT 100
```

پیش‌بینی کن هر پاسخ چیست، سپس اجرا کن. بعد `EXPIRE course:hello 0` را فقط روی لَب بزن تا حذف و `TTL` برای key ناموجود را ببینی. در محیط مشترک یا production این cleanup را کپی نکن.

## عیب‌یابی اولیه

- `Connection refused`: server/container بالا نیست، port اشتباه است یا mapping برقرار نیست.
- `NOAUTH`: server authentication می‌خواهد؛ secret را در shell history یا log عمومی نگذار.
- `WRONGTYPE`: key وجود دارد اما از نوع دیگری است؛ `TYPE` را پیش از فرمان بررسی کن.
- خروجی ناقص از `SCAN`: cursor برگردانده‌شده را تا صفر ادامه بده؛ یک بار SCAN ممکن است همهٔ کلیدها را ندهد.
- TTL برابر `-1`: key هست اما expire ندارد؛ `-2`: key وجود ندارد (رفتار رایج TTL/PTTL).

## آزمون عبور

1. تفاوت Redis server و redis-cli چیست؟
2. چرا `KEYS *` برای keyspace بزرگ خطر دارد و `SCAN` هم چه ضمانتی نمی‌دهد؟
3. خروجی `TTL` چه تفاوتی بین key بدون expire و key ناموجود دارد؟
4. اگر `SET x value` روی key از نوع Hash اجرا شود، چه اتفاقی می‌افتد؟

<details><summary>پاسخ راهنما</summary>

server داده و فرمان را مدیریت می‌کند؛ cli client است. `KEYS` همهٔ keyها را در یک عملیات مسدودکننده جست‌وجو می‌کند؛ `SCAN` تدریجی است اما snapshot ثابت/بدون تکرار مطلق تضمین نمی‌کند و باید cursor را پیمود. TTL معمولاً `-1` برای بدون expire و `-2` برای ناموجود است. SET روی key دارای type دیگر ممکن است آن را overwrite کند یا در برخی شرایط پاسخ خطا بدهد؛ نام key/type را با مدل برنامه بساز و از آزمایش مخرب فقط روی لَب استفاده کن.

</details>

## منابع

- [redis-cli](https://redis.io/docs/latest/develop/tools/cli/)
- [Keys و expiration](https://redis.io/docs/latest/develop/using-commands/keyspace/)
- [SCAN](https://redis.io/docs/latest/commands/scan/)
- [راهنمای فارسی Redis در SalamLang](https://www.salamlang.ir/std/db/redis/)

</div>
