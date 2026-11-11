<div dir="rtl" align="right">

# Transactions، WATCH و هم‌زمانی خوش‌بینانه

> English edition: [Transactions, WATCH, and Optimistic Concurrency](README.en.md)

> مسیر: فصل ۴، قابلیت‌های پیشرفته · سطح: میانی · زمان درس و تمرین: ۷۵ تا ۱۲۰ دقیقه
>
> فرمان‌های این صفحه را فقط روی دادهٔ آزمایشی اجرا کن؛ نمونهٔ رزرو موجودی، الگوریتم پرداخت production نیست.

## هدف یادگیری

- رفتار `MULTI`, `EXEC`, `DISCARD` و `WATCH` را مرحله‌به‌مرحله توضیح دهی.
- فرق atomic execution با rollback دیتابیس رابطه‌ای را بفهمی.
- برای read-modify-write با چند نویسنده، optimistic locking و retry محدود طراحی کنی.
- تشخیص دهی چه وقت یک فرمان اتمی یا Lua از transaction ساده‌تر است.
- محدودیت چندکلیدی Redis Cluster را در طراحی تراکنش لحاظ کنی.

## مدل ذهنی

`MULTI` یک صف فرمان برای همین اتصال باز می‌کند. فرمان‌ها تا `EXEC` اجرا نمی‌شوند. هنگام `EXEC`, Redis فرمان‌های داخل صف را پشت‌سرهم، بدون درهم‌رفتن فرمان‌های دیگر clientها اجرا می‌کند. `WATCH` پیش از این صف، کلیدهای خوانده‌شده را علامت می‌زند؛ اگر تا `EXEC` کلیدی تغییر کند، تراکنش optimistic abort می‌شود تا برنامه مقدار تازه را بخواند و تصمیمش را از نو بگیرد.

```text
WATCH key(s) -> GET/READ -> MULTI -> queue writes -> EXEC
       |                                  |
       +-- any watched key changes ------+--> EXEC returns nil / retry policy
```

این قرارداد rollback عمومی SQL نیست. Redis فرمان‌های خطادار در زمان queue شدن را به همان فرمان محدود می‌کند؛ خطای اجرای یک فرمان داخل `EXEC` نیز لزوماً اثر فرمان‌های قبلی یا بعدی صف را برنمی‌گرداند. اگر invariant نیازمند «همه یا هیچ» در برابر خطاهای کسب‌وکاری است، منطق را طوری اعتبارسنجی کن که فرمان خطا نکند و برای منطق شرطی کوتاه، Lua/Function را بررسی کن.

## ۱. تراکنش پایه

```text
SET lab:counter 0
MULTI
INCR lab:counter
INCR lab:counter
GET lab:counter
EXEC
```

بعد از `MULTI` پاسخ فرمان‌های queued معمولاً `QUEUED` است. پس از `EXEC` سه پاسخ به‌ترتیب فرمان‌ها می‌آید؛ دو افزایش و سپس خواندن مقدار. هیچ client دیگری وسط اجرای این فهرست وارد نمی‌شود، ولی این به معنی یک نسخهٔ undo برای rollback نیست.

پیش از `EXEC`, `DISCARD` صف را دور می‌اندازد:

```text
MULTI
SET lab:flag ready
DISCARD
GET lab:flag
```

اگر `lab:flag` از قبل وجود نداشته باشد، خروجی آخر nil خواهد بود. `DISCARD` وقتی کاربرد دارد که خود برنامه قبل از commit تصمیم بگیرد ادامه ندهد.

## ۲. قفل خوش‌بینانه با WATCH

فرض کن موجودی `inventory:{sku-7}` یک عدد صحیح است و چند درخواست ممکن است هم‌زمان آخرین واحد را بخرند. `WATCH` روی کلید، خواندن و تصمیم را محافظت می‌کند. در redis-cli یک اتصال را به این روش امتحان کن:

```text
SET inventory:{sku-7} 1
WATCH inventory:{sku-7}
GET inventory:{sku-7}
MULTI
DECR inventory:{sku-7}
EXEC
```

در اجرای تنهایی `EXEC` مقدار را به صفر می‌رساند. حالا آزمایش رقابت را انجام بده:

1. ترمینال A: `SET inventory:{sku-7} 1`, سپس `WATCH inventory:{sku-7}` و `GET`.
2. پیش از `EXEC` ترمینال A، در ترمینال B مقدار را تغییر بده: `SET inventory:{sku-7} 0`.
3. در ترمینال A فرمان‌های `MULTI`, `DECR`, `EXEC` را اجرا کن.

در نتیجهٔ conflict، `EXEC` به‌جای آرایهٔ پاسخ‌ها پاسخ nil/null می‌دهد؛ `DECR` اعمال نشده است. برنامه باید دوباره مقدار را بخواند و اگر موجودی کافی نیست، «ناموجود» برگرداند. در این مثال دستی اگر بدون بررسی دوباره `DECR` کنی، موجودی منفی می‌شود؛ شرط تجاری باید در حلقهٔ برنامه اجرا شود.

### شبه‌کد مقاوم‌تر

```text
برای تلاش از 1 تا حداکثر 5:
    WATCH inventory:{sku-7}
    stock = GET inventory:{sku-7}
    اگر stock <= 0:
        UNWATCH
        پاسخ «ناموجود»
    MULTI
    DECR inventory:{sku-7}
    replies = EXEC
    اگر replies != null:
        پاسخ «رزرو آزمایشی شد»
    تاخیر کوتاه با jitter
پاسخ «تعارض هم‌زمانی؛ دوباره تلاش کن»
```

قفل تا `EXEC`, `DISCARD` یا `UNWATCH` باقی می‌ماند؛ اتصال را بعد از conflict یا پایان خواندن در حالت watch رها نکن. `WATCH` برای رقابت خوش‌بینانه مناسب است؛ در contention شدید، retryها خودشان فشار ایجاد می‌کنند. retry باید سقف، backoff/jitter و نتیجهٔ شفاف داشته باشد.

## ۳. تفاوت سه نوع atomicity

| واژه | معنای دقیق در این درس |
| --- | --- |
| اجرای اتمی توالی | فرمان‌های بین `MULTI` و `EXEC` هنگام اجرا با فرمان client دیگر interleave نمی‌شوند |
| conflict detection | `WATCH` تغییر کلید را می‌بیند و در `EXEC` اجازهٔ اجرای queued write را نمی‌دهد |
| rollback | بازگرداندن خودکار همهٔ writeها به وضعیت پیشین پس از خطا؛ این تضمین عمومی Redis transaction نیست |

اگر یک فرمان با نوع دادهٔ غلط در زمان `EXEC` خطا دهد، پاسخ‌های هر فرمان مستقل دیده می‌شوند؛ آن را به rollback دیتابیس تشبیه نکن. برای کاهش خطا، type، مقدار، مجوز ACL، slot و شرایط را پیش از queue بررسی کن و عملیات کلیدی را به فرمان‌های مناسب بسپار.

## ۴. انتخاب میان فرمان، transaction و Lua

- اگر یک فرمان atomic کافی است (`INCR`, `SET ... NX`, `ZINCRBY`)، همان را ترجیح بده.
- اگر چند فرمان باید پشت‌سرهم اجرا شوند و نتیجه به خواندن قبلی وابسته نیست، `MULTI/EXEC` کافی است.
- اگر برنامه قبل از نوشتن باید مقدار را بخواند و تغییر هم‌زمان را رد کند، `WATCH` مناسب است.
- اگر شرط و چند تغییر باید در server-side یک واحد کوتاه اجرا شوند، Lua script یا Redis Function را ارزیابی کن؛ script طولانی server را برای همه معطل می‌کند.
- اگر چند سیستم بیرونی مثل Redis و SQL باید با هم commit شوند، `MULTI/EXEC` یا Lua آن‌ها را در یک تراکنش توزیع‌شده قرار نمی‌دهد. الگوهایی مثل outbox، saga یا idempotent compensation را در لایهٔ برنامه بررسی کن.

## ۵. Redis Cluster

در Cluster multi-key transaction و script به سازگاری hash slot کلیدها وابسته است. برای کلیدهای یک رزرو، hash tag را آگاهانه انتخاب کن؛ بخش داخل `{...}` مبنای slot است:

```text
inventory:{sku-7}
reservation:{sku-7}:order-501
```

این‌ها می‌توانند در یک slot قرار بگیرند، اما جمع‌کردن همهٔ داده‌ها در یک hash tag داغ، یک shard را hotspot می‌کند. slot routing، محدودیت client و نسخهٔ Redis را پیش از production بررسی کن. از `{}` برای تزئین کلید استفاده نکن؛ این بخشی از رفتار sharding است.

## مثال عملی: رزرو در برابر خرید

این نمونه فقط شمارندهٔ موجودی Redis را decrement می‌کند. در سیستم واقعی، باید تصمیم بگیری Redis منبع حقیقت هست یا projection/cache از پایگاه اصلی؛ چگونه درخواست تکراری با `order_id` خنثی می‌شود؛ اگر پرداخت شکست خورد چطور رزرو آزاد می‌شود؛ و چه رخ می‌دهد اگر Redis failover آخرین تغییر را نداشته باشد. «اتمیک در یک Redis primary» به‌تنهایی جواب این پرسش‌ها نیست.

## دام‌ها و عیب‌یابی

- **`EXEC` nil/null:** یک WATCH conflict رخ داده؛ مقدار تازه را بخوان، تصمیم را دوباره حساب کن.
- **عدد موجودی منفی:** read/condition خارج از حلقهٔ transaction بوده یا retry شرط را دور زده؛ invariant را در هر تلاش بازبینی کن.
- **تراکنش، خطا داد ولی داده برگشت نخورد:** این انتظار rollback است؛ error reply هر فرمان را بررسی و الگوریتم را طوری طراحی کن که خطای میانی قابل‌پیش‌بینی نباشد.
- **retry بی‌پایان:** contention یا hot key وجود دارد؛ سقف retry و رفتار fail واضح تعریف کن و مدل داده را بازنگری کن.
- **کلید چندگانه در Cluster خطای CROSSSLOT می‌دهد:** hash tag و slotها را بررسی کن؛ مجبورکردن همهٔ کار به یک slot هزینهٔ hotspot دارد.
- **اتصال pooled در حالت WATCH می‌ماند:** قبل از برگرداندن connection به pool از `UNWATCH` یا پاک‌سازی client مطمئن شو.

## تمرین‌ها

1. یک counter را با `MULTI/EXEC` دوبار زیاد کن و نشان بده پاسخ‌ها فقط پس از `EXEC` اجرا می‌شوند.
2. race آزمایشی دو ترمینال را انجام بده و پاسخ nil را ثبت کن.
3. برنامهٔ فرضی با ۳۰٪ conflict طراحی کن: سقف retry، backoff، metric و پاسخ API چیست؟
4. دو کلید موجودی و reservation را برای Cluster نام‌گذاری کن و hash slot را با فرمان مناسب بررسی کن.
5. توضیح بده چرا ثبت Redis و PostgreSQL را نمی‌توان با `MULTI/EXEC` به یک commit اتمی تبدیل کرد.

<details><summary>راهنمای پاسخ</summary>

در سؤال ۲، نویسندهٔ دوم پس از `WATCH` کلید را تغییر می‌دهد؛ `EXEC` اولی abort می‌شود و نباید decrement کند. در سؤال ۳، نتیجه باید محدود و قابل مشاهده باشد؛ مثلاً چند retry محدود با jitter، شمارندهٔ conflict و در پایان پاسخ conflict/retryable. برای سؤال ۵، Redis transaction فقط وضعیت خود Redis را کنترل می‌کند؛ PostgreSQL عضو صف Redis نیست و protocol دو فاز commit مشترک خودکار وجود ندارد.

</details>

## کوییز

### ۱. `MULTI` فرمان‌ها را همان لحظه اجرا می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ آن‌ها را برای `EXEC` queue می‌کند.

</details>

### ۲. آیا `EXEC` یک rollback عمومی در صورت خطای هر فرمان دارد؟

<details><summary>پاسخ</summary>

خیر؛ خطاهای پاسخ فرمان‌ها را جداگانه تحلیل کن و روی rollback سراسری حساب نکن.

</details>

### ۳. `WATCH` چه نوع کنترلی می‌دهد؟

<details><summary>پاسخ</summary>

کنترل خوش‌بینانه؛ تغییر کلید watched پیش از `EXEC` باعث abort می‌شود.

</details>

### ۴. با `EXEC` nil چه می‌کنی؟

<details><summary>پاسخ</summary>

کلید را تازه می‌خوانی، شرط تجاری را دوباره ارزیابی می‌کنی و با سقف retry اقدام می‌کنی.

</details>

### ۵. `MULTI` دو دیتابیس را با هم commit می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ فقط فرمان‌های همان Redis را مدیریت می‌کند.

</details>

### ۶. برای یک افزایش ساده چند round-trip transaction لازم است؟

<details><summary>پاسخ</summary>

هیچ؛ فرمان atomic مثل `INCR` کافی است.

</details>

## منابع تکمیلی

### انگلیسی و رسمی

- [Transactions در Redis](https://redis.io/docs/latest/develop/using-commands/transactions/)
- [WATCH](https://redis.io/docs/latest/commands/watch/)
- [EXEC](https://redis.io/docs/latest/commands/exec/)
- [Transactions در Redis Cluster](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/)

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [ویدئوی فارسی دربارهٔ هم‌زمانی در Redis](https://www.youtube.com/watch?v=e5Q_RUwviaE)
- [ویدئوی فارسی Transaction و Lua](https://www.youtube.com/watch?v=m5j4YUvuUmc)

منابع فارسیِ عمیق دربارهٔ مرز rollback و WATCH محدودند؛ محتوای همین درس برای مفهوم و آزمایش پایه خودبسنده است. تفاوت فرمان‌ها و Cluster را با نسخه‌ای که اجرا می‌کنی تطبیق بده.

</div>
