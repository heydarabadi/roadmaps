<div dir="rtl" align="right">

# اسکریپت‌نویسی Lua و Redis Functions

> English edition: [Lua Scripting and Redis Functions](README.en.md)

> مسیر: فصل ۴ · سطح: میانی · زمان درس و تمرین: ۷۵ تا ۱۲۰ دقیقه
>
> اسکریپت را فقط در Redis آزمایشی اجرا کن. اسکریپت طولانی می‌تواند فرمان‌های همهٔ clientها را معطل کند.

## هدف یادگیری

- فرق round-trip، pipeline و اجرای script روی سرور را توضیح دهی.
- از `KEYS` و `ARGV`، `redis.call` و `redis.pcall` برای نوشتن اسکریپت کوتاه استفاده کنی.
- یک check-and-update اتمی را اجرا و خروجی هر مسیر را بفهمی.
- محدودیت زمان اجرا، cache شدن SHA، error handling، Cluster slot و قابلیت‌های نسخه را در طراحی لحاظ کنی.
- `EVAL`/`EVALSHA` را از Redis Functions تشخیص دهی.

## ایدهٔ مرکزی

وقتی client ابتدا مقدار را می‌خواند و بعد بر اساس آن می‌نویسد، clientهای دیگر می‌توانند بین این دو round-trip تغییر دهند. Lua چند فرمان را در همان سرور، بدون درهم‌رفتن فرمان‌های دیگر clientها اجرا می‌کند. این برای منطق کوتاه شرطی مفید است؛ عملیات سنگین را به سرور منتقل نکن چون بار هم‌زمان همه را عقب می‌اندازد.

| ابزار | چه مسئله‌ای را حل می‌کند | چه تضمینی به‌تنهایی ندارد |
| --- | --- | --- |
| فرمان atomic مثل `INCR` | یک عمل سادهٔ server-side | چند شرط و چند write ترکیبی |
| pipeline | کاهش تعداد رفت‌وبرگشت شبکه | atomicity؛ فرمان‌های clientهای دیگر می‌توانند میان batch اثر بگذارند |
| `MULTI/EXEC` | اجرای صف چند فرمان بدون interleaving | rollback عمومی یا شرط‌گذاری راحت بر نتیجهٔ خواندن قبلی |
| Lua/Function | شرط و چند فرمان در یک اجرای server-side | تراکنش با دیتابیس خارجی، اسکریپت آزاد از خطا یا exactly-once |

## ۱. پارامترها و اجرای یک script

فرم کلی:

```text
EVAL <script> <number-of-keys> <key-1> ... <arg-1> ...
```

فهرست `KEYS` را صریح بفرست تا Redis و Cluster بدانند script روی کدام کلیدها کار می‌کند. ورودی غیرکلیدی مثل مقدار افزایشی را از `ARGV` بخوان. کلید را با کنار هم چسباندن نام‌های مخفی داخل Lua نساز؛ پارامترهای صریح برای slot routing و review لازم‌اند.

### نمونه: کاهش موجودی اگر کافی باشد

در محیط آزمایشی:

```text
SET lab:stock:sku-7 3
EVAL "local n = tonumber(redis.call('GET', KEYS[1]) or '0'); local q = tonumber(ARGV[1]); if not q or q <= 0 then return redis.error_reply('quantity must be positive') end; if n < q then return 0 end; redis.call('DECRBY', KEYS[1], q); return 1" 1 lab:stock:sku-7 2
(integer) 1
GET lab:stock:sku-7
"1"
```

در بخش اول `GET` عدد را می‌خواند؛ `tonumber` آن را برای مقایسهٔ Lua تبدیل می‌کند. اگر مقدار گم باشد صفر می‌گیریم. بعد quantity معتبر بررسی می‌شود. اگر موجودی کافی نباشد script عدد `0` می‌دهد و هیچ decrement نمی‌کند؛ در صورت کافی‌بودن `DECRBY` انجام شده و `1` برمی‌گردد.

دوباره با quantity `2` اجرا کن: این بار خروجی `0` است و موجودی `1` می‌ماند. این نمونه برای آموزش atomic check-and-decrement است، اما خرید production نیست: شناسهٔ درخواست برای جلوگیری از تکرار، رزرو و لغو، payment consistency، سیاست مقدار خراب و persistence/failover لازم است.

## ۲. `redis.call` و خطاها

`redis.call` خطای فرمان Redis را به‌صورت خطای script بالا می‌آورد. `redis.pcall` خطا را به شکل مقدار قابل‌بررسی برمی‌گرداند؛ آن را فقط وقتی استفاده کن که recovery تعریف کرده‌ای. نادیده‌گرفتن پاسخ خطا می‌تواند invariant را پنهان خراب کند.

اسکریپت اجرا با script دیگر interleave نمی‌شود، ولی این به معنای rollback خودکار side effectهای قبل از یک خطا نیست. ورودی را پیش از write اعتبارسنجی کن، فرمان‌های قابل‌خطا را قبل از تغییر وضعیت اجرا/بررسی کن، و چندعملی را طوری طراحی کن که حالت میانی ناخواسته حداقل شود.

## ۳. `EVALSHA` و cache اسکریپت

`EVAL` متن script را می‌فرستد و Redis آن را hash می‌کند. `SCRIPT LOAD` SHA را cache می‌کند و `EVALSHA` آن hash را صدا می‌زند؛ این کار بار ارسال متن تکراری را کم می‌کند. cache اسکریپت دادهٔ پایدار application نیست. client باید `NOSCRIPT` را مدیریت کند و در صورت نیاز متن را دوباره `EVAL` یا `SCRIPT LOAD` کند، مخصوصاً پس از restart/failover یا تغییر node.

الگوی معمول client:

1. script را با SHA از cache فراخوانی کن.
2. اگر پاسخ `NOSCRIPT` بود، نسخهٔ معلوم script را `EVAL` یا load کن.
3. نسخهٔ script را در برنامه version کن و rollback deployment را ممکن نگه دار.

## ۴. Redis Functions

Redis 7 به بعد Redis Functions را برای بارگذاری libraryهای server-side معرفی کرد. Function نام‌دار است و library در dataset ذخیره می‌شود؛ برخلاف scriptهای `EVAL` که متن/sha با مدل cache فراخوانی می‌شوند. در deployment چند-node، بارگذاری و همگام‌سازی library با topology و ابزار مدیریت انجام می‌شود. Function هم روی server اجرا می‌شود و همان اصل باقی است: کوتاه، bounded، تست‌پذیر و با keyهای صریح.

برای یکبار اجرای کوچک یا clientهای سازگار، `EVAL` ساده است. برای logic مشترک نام‌دار که به‌صورت artifact نسخه‌دار عرضه می‌شود، Function را ارزیابی کن. رفتار deploy/replicate را دقیقاً با نسخه و سرویس managed خود بسنج.

## ۵. Cluster و کلیدها

در Cluster همهٔ keyهای دست‌کاری‌شدهٔ یک script باید با قواعد slot سازگار باشند. `{sku-7}` را در کلیدهای یک stock/order-related script می‌توان برای هم‌slotی به کار برد، اما hash tag گسترده hotspot می‌سازد. کلیدهای مورد استفاده را در آرگومان `KEYS` اعلام کن و mismatch slot را پیش از بار واقعی پیدا کن.

## ۶. انتخاب، امنیت و کارایی

- اسکریپت را کوتاه و محدود به تعداد کم کلید/عضو نگه دار.
- loop با طول وابسته به دادهٔ کنترل‌نشده، `HGETALL` روی hash بسیار بزرگ، یا پیمایش همهٔ اعضای مجموعه در script می‌تواند latency بسازد.
- script را راهی برای دور زدن ACL ندان؛ دسترسی command/key/function را با کمترین مجوز تعریف کن.
- client باید timeout، reconnect، `NOSCRIPT`, خطای نوع، wrong number of keys و خطای application را درست هندل کند.
- برای سریع‌ترشدن صرفاً script ننویس؛ ابتدا مشخص کن bottleneck شبکه است یا CPU/server, big key, persistence, eviction یا client pool.

## تمرین با پاسخ

1. نمونه را با ۲ واحد از ۳ واحد اجرا کن؛ خروجی مقدار را ثبت کن.
2. با مقدار بیشتر از موجودی اجرا کن و ثابت کن stock تغییر نمی‌کند.
3. چرا `KEYS[1]` بهتر از ساختن نام کلید در Lua است؟
4. فرق pipeline و script را با مثال «GET سپس شرط و DECR» توضیح بده.
5. چه چیزی را client در `EVALSHA` باید برای restart جبران کند؟

<details><summary>پاسخ‌های راهنما</summary>

1. موفقیت `1`, باقی‌مانده `1`.
2. عدم‌موفقیت `0`, باقی‌مانده بدون تغییر.
3. keyها واضح و قابل route شدن برای Cluster هستند و script key access را اعلام می‌کند.
4. pipeline فقط رفت‌وبرگشت را batch می‌کند، اما script read-condition-write را بدون interleaving روی Redis اجرا می‌کند.
5. `NOSCRIPT` را مدیریت کرده و script را مجدداً load/`EVAL` می‌کند.

</details>

## دام‌ها و عیب‌یابی

- **script خیلی کند:** اندازهٔ داده/loop و فرمان‌های بزرگ را بررسی و منطق را به jobهای کوچک تقسیم کن.
- **`NOSCRIPT`:** cache script روی آن node موجود نیست؛ fallback load را پیاده کن.
- **خطای `CROSSSLOT`:** کلیدهای KEYS در slotهای متفاوت‌اند؛ مدل کلید را بازبینی کن.
- **`nil` به عدد تبدیل نمی‌شود:** مقدار کلید ناموجود یا بدشکل است؛ default/validation لازم است.
- **فکر می‌کنی هر خطا rollback می‌کند:** پیش از mutation ورودی را validate کن و حالت‌های نیمه‌اجرا را تحلیل کن.
- **از client ورودی را در script concatenate می‌کنی:** پارامترها را از `KEYS` و `ARGV` بده؛ به ورودی untrusted اجازهٔ تبدیل به کد نده.

## کوییز

### ۱. چرا script از pipeline برای read-condition-write بهتر است؟

<details><summary>پاسخ</summary>

چون این منطق داخل یک اجرای سرور انجام می‌شود و فرمان‌های دیگر بین خواندن و write وارد نمی‌شوند.

</details>

### ۲. چرا script باید کوتاه باشد؟

<details><summary>پاسخ</summary>

چون اجرای آن فرمان‌های دیگر را معطل می‌کند و به latency مشترک می‌افزاید.

</details>

### ۳. `KEYS` و `ARGV` برای چه‌اند؟

<details><summary>پاسخ</summary>

`KEYS` کلیدهای Redis مورد استفادهٔ script و `ARGV` داده‌های ورودی دیگر را می‌دهد.

</details>

### ۴. `EVALSHA` با `NOSCRIPT` چه می‌کند؟

<details><summary>پاسخ</summary>

client باید script را دوباره load کند یا با `EVAL` متن معتبر را اجرا کند.

</details>

### ۵. Lua بین Redis و PostgreSQL atomic commit می‌دهد؟

<details><summary>پاسخ</summary>

خیر؛ فقط عملیات server-side Redis را دربر می‌گیرد.

</details>

## منابع

### انگلیسی و رسمی

- [EVAL introduction](https://redis.io/docs/latest/develop/programmability/eval-intro/)
- [Redis Functions](https://redis.io/docs/latest/develop/programmability/functions-intro/)
- [Lua API](https://redis.io/docs/latest/develop/programmability/lua-api/)
- [EVALSHA](https://redis.io/docs/latest/commands/evalsha/)

### فارسی

- [ویدئوی فارسی Pipeline و Lua](https://www.youtube.com/watch?v=m5j4YUvuUmc)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

لینک‌های فارسی Lua محدودتر از مستندات اصلی‌اند؛ درس و آزمایش فوق هستهٔ کاربردی را پوشش می‌دهند. تفاوت function و script را با نسخه و سرویس مورد استفاده‌ات تطبیق بده.

</div>
