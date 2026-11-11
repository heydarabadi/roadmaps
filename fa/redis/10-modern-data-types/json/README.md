<div dir="rtl" align="right">

# Redis JSON: سند تو‌در‌تو و کار با path

> English edition: [Redis JSON: Nested Documents and Path-Based Updates](../../../../en/redis/10-modern-data-types/json/README.md)

> مسیر: فصل ۱۰، data typeهای جدید · سطح: میانی · زمان درس و لَب: ۷۰ تا ۱۱۰ دقیقه
>
> در Redis Open Source، JSON به‌صورت native از Redis 8.0 آمده است؛ در نسخه‌های پیشین ممکن است RedisJSON module/Redis Stack لازم باشد.

## هدف یادگیری

- فرق Redis JSON را با string JSON و Hash توضیح دهی.
- سند را با `JSON.SET` ذخیره، با `JSON.GET` بخوانی و path مشخصی را تغییر دهی.
- آرایه‌ها/عددها/فیلدهای تو‌در‌تو را دست‌کاری کنی.
- نسخه، schema validation، حافظه، indexing و privacy را در design لحاظ کنی.

## مدل ذهنی

یک key از نوع JSON سندی سلسله‌مراتبی شامل object, array, string, number, boolean یا null است. به‌جای GET/SET کل JSON text، commandهای JSON می‌توانند روی path قسمت مشخصی را بخوانند یا mutate کنند. JSON type حافظه/ساختار داخلی و commandهای خودش را دارد؛ یک String که محتوایش JSON text است همان JSON type نیست.

| مدل | نقطهٔ قوت | محدودیت |
| --- | --- | --- |
| String با متن JSON | ساده، قابل‌انتقال، هر client می‌خواند | read-modify-write کل سند؛ update هم‌زمان/partial پیچیده |
| Hash | fieldهای flat، کوچک و ساده | nested object/array را طبیعی مدل نمی‌کند |
| Redis JSON | path-based update/query روی document nested | memory/query/index/schema و module/version dependency باید بررسی شود |

## ۱. ایجاد و خواندن یک سند

```text
DEL lab:product:42
JSON.SET lab:product:42 $ '{"name":"keyboard","price":25,"tags":["office","usb"],"inventory":{"stock":8}}'
OK
JSON.GET lab:product:42
"{\"name\":\"keyboard\",\"price\":25,\"tags\":[\"office\",\"usb\"],\"inventory\":{\"stock\":8}}"
JSON.GET lab:product:42 $.name
"[\"keyboard\"]"
```

`$` ریشه در JSONPath است. خروجی `$` معمولاً مجموعه‌ای از matchهاست و حتی یک match در wrapper آرایه می‌آید؛ خواندن بدون path کل سند را برمی‌گرداند. مسیر legacy با `.` در commandهای قدیمی‌تر متفاوت بود؛ روی نسخهٔ هدف syntax/path dialect را چک کن.

## ۲. خواندن و تغییر مسیر مشخص

```text
JSON.GET lab:product:42 $.inventory.stock
JSON.NUMINCRBY lab:product:42 $.inventory.stock 2
JSON.SET lab:product:42 $.price 29
JSON.GET lab:product:42 $.price
JSON.DEL lab:product:42 $.tags[0]
```

- `JSON.NUMINCRBY` عدد را روی path تغییر می‌دهد.
- `JSON.SET key path json-value` همان node را عوض می‌کند؛ اگر path طبق قواعد قابلیت ایجاد باشد، node جدید ساخته می‌شود.
- `JSON.DEL` node/مسیر انتخابی را حذف می‌کند؛ `$` را حذف نکن مگر قصد حذف سند کامل را داری.
- `JSON.TYPE` نوع path، `JSON.ARRLEN` طول آرایه، `JSON.ARRAPPEND` و `JSON.ARRINSERT` برای arrayها هستند.

برای string که JSON literal است، quote داخلی را درست escape کن. `JSON.ARRAPPEND key $.tags '"hardware"'` مقدار رشته‌ای JSON را می‌افزاید.

## ۳. update atomic و schema

یک JSON command روی Redis به‌صورت یک فرمان server-side اجرا می‌شود؛ دو فرمان جدا `GET` و بعد `JSON.SET` به‌طور خودکار یک transaction مشترک نیستند. برای تغییر شرطی، `WATCH`, `MULTI/EXEC`, Lua/Function یا commandهای atomic تخصصی را بررسی کن.

Redis JSON به‌تنهایی schema enforcement محصولی نیست: application باید required fields, type, version, validation, migration و backward compatibility را مدیریت کند. برای تغییر ساختار version در سند یا key name ثبت کن تا consumerهای قدیمی با شکل جدید crash نکنند.

Redis 8 در Open Source، JSON را همراه قابلیت‌های Search integrated کرده است؛ نسخه‌های قبلی ممکن است ماژول جدا بخواهند. Full-text/secondary indexing یک مبحث جدا با هزینهٔ index memory, update, query syntax و compatibility خودش است.

## ۴. ظرفیت و مناسب‌بودن

- JSON خوب است وقتی رکورد nested است و بخش‌هایی از آن به شکل path خوانده/تغییر می‌شوند.
- Hash مناسب‌تر است برای fieldهای کم‌تعداد و flat، مثلاً session ساده.
- اگر همیشه کل document را GET/SET می‌کنی، Redis JSON شاید ارزش پیچیدگی/حافظهٔ اضافه نداشته باشد.
- سند بزرگ و پرتغییر ممکن است copy/update cost و serialization را زیاد کند؛ benchmark بگیر.
- ACL باید هم command family JSON و هم key pattern را محدود کند.
- PII/security/retention policy را روی کل سند و indexها اعمال کن؛ حذف field تنها raw backupهای قدیمی را حذف نمی‌کند.

## مثال طراحی: catalog محصول

1. `product:{id}` سند اصلی cacheable را نگه دارد.
2. fieldهای کوچک و پرتغییر مانند stock را از document بزرگ جدا کن اگر contention/atomic update مهم است.
3. `JSON.SET`-based update را idempotent طراحی کن تا retry payload را ناخواسته overwrite نکند.
4. TTL کلید JSON در سطح key است؛ field-specific expiry را با key مدل جدا یا feature/version support بررسی کن.
5. اگر query «همهٔ محصول‌های price زیر X» می‌خواهی، indexing/query engine را با memory/latency benchmark کن؛ با جست‌وجوی کل keyspace جای index نساز.

## تجربهٔ کاربردی منتشرشده

Caseهای Redis در حوزهٔ document/search نشان می‌دهند Redis JSON معمولاً بخشی از لایهٔ data/query است، نه validation/authorization کامل application. برای مثال case رسمی Docugami Redis را در pipelineهای AI/search و vector storage استفاده می‌کند؛ این case را نباید دلیل اینکه هر JSON workload نیازمند Redis است تعبیر کرد. [Docugami customer story](https://redis.io/customers/docugami/)

## لَب و عیب‌یابی

```text
JSON.SET lab:customer:42 $ '{"id":42,"profile":{"city":"Tehran"},"tags":[]}'
JSON.GET lab:customer:42 $.profile.city
JSON.ARRAPPEND lab:customer:42 $.tags '"learner"'
JSON.GET lab:customer:42
```

- `unknown command JSON.*`: Redis version/module نصب‌شده قابلیت JSON را ندارد؛ `MODULE LIST`/version/product را بررسی کن.
- `WRONGTYPE`: همان key قبلاً String/Hash دیگری است؛ type را با `TYPE` بخوان و key naming را بازبینی کن.
- `path does not exist` یا empty result: JSONPath syntax/root/path/index را بررسی کن.
- کل سند برگشت نمی‌کند: تفاوت single match و multi-match JSONPath/output wrapper را بخوان.
- memory بالا رفته: document size, arrays, index, duplicate cache و `MEMORY USAGE` را اندازه بگیر.

## تمرین با پاسخ

1. document محصول را بساز و فقط قیمت/stock را بخوان.
2. stock را با `JSON.NUMINCRBY` افزایش بده؛ چرا دو client که اول مقدار را می‌خوانند بعد `JSON.SET` می‌کنند ممکن است update همدیگر را overwrite کنند؟
3. یک schema v2 اضافه کن؛ چه چیزی consumer قدیمی را حفظ می‌کند؟
4. JSON یا Hash را برای session ده‌فیلدی انتخاب و دلیل بنویس.

**راهنمای پاسخ:** update numeric server command یک operation است؛ read-then-set client flow race دارد. Schema version/dual-reader migration لازم است. Flat field session شاید Hash ساده‌تر باشد، nested values JSON را توجیه می‌کند.

## کوییز

### ۱. Redis JSON با String حاوی JSON یکی است؟

<details><summary>پاسخ</summary>

خیر؛ String یک مقدار متن است، JSON type command/path-based دارد.

</details>

### ۲. چه زمانی JSON path خروجی آرایه‌ای می‌دهد؟

<details><summary>پاسخ</summary>

JSONPath با `$` می‌تواند چند match را برگرداند و حتی یک result در آرایه wrapper شود.

</details>

### ۳. JSON schema را خودکار enforce می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ validation/versioning application را بساز.

</details>

### ۴. Redis 8 برای JSON چه تغییری دارد؟

<details><summary>پاسخ</summary>

در Redis Open Source 8 قابلیت JSON integrated است؛ نسخه‌های قدیمی‌تر ممکن است module جدا لازم داشته باشند.

</details>

### ۵. TTL روی یک field از JSON است؟

<details><summary>پاسخ</summary>

TTL عمومی روی key است؛ per-field expiry feature و version جدا می‌خواهد.

</details>

## منابع

### انگلیسی و رسمی

- [Redis JSON](https://redis.io/docs/latest/develop/data-types/json/)
- [JSON paths and JSONPath](https://redis.io/docs/latest/develop/data-types/json/path/)
- [JSON.SET](https://redis.io/docs/latest/commands/json.set/)
- [Redis 8 release notes and integrated data types](https://redis.io/docs/latest/operate/oss_and_stack/stack-with-enterprise/release-notes/redisce/redisos-8.0-release-notes/)
- [Docugami customer story](https://redis.io/customers/docugami/)

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی فارسی Redis JSON](https://www.google.com/search?q=آموزش+فارسی+Redis+JSON+JSON.SET)
- [مرور فارسی ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

پوشش فارسی Redis JSON محدود است؛ شرح command/path این صفحه برای شروع کافی است. نسخه، JSONPath dialect، module و feature indexing را با مستند جاری همان endpoint کنترل کن.

</div>
