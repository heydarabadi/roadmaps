<div dir="rtl" align="right">

# String، شمارنده و Bitmap

> English edition: [Strings, counters, and bitmaps](../../../../en/redis/03-core-data-structures/strings-bitmaps/README.md)

> سطح پیشنهادی: مقدماتی تا میانی · زمان: ۳۰ تا ۶۰ دقیقه

## هدف یادگیری

String را برای متن و شمارنده و Bitmap را برای flagهای فشرده انتخاب کنی.

## درس

String رشتهٔ بایت است و برای متن، مقدار سریال‌شده و counter مناسب است. SET/GET، MGET/MSET، APPEND و INCR/DECR پرکاربردند. INCR روی Redis اتمی است و از الگوی خواندن مقدار در برنامه و نوشتن جمع امن‌تر است. Bitmap با SETBIT/GETBIT، بیت‌های وضعیت را روی یک رشته فشرده می‌کند؛ BITCOUNT و BITOP آن را می‌شمارند و ترکیب می‌کنند.

Bitmap برای وضعیت دودویی با index قابل پیش‌بینی مناسب است. اندازه‌اش با بالاترین offset تعیین می‌شود، پس ورودی index را محدود کن. مقدار بزرگ و پرتغییر JSON را بی‌دلیل در یک String بازنویسی نکن.

## String را از پایه بفهم

String در Redis یک رشتهٔ سادهٔ زبان برنامه‌نویسی نیست؛ یک مقدار binary-safe است و می‌تواند متن UTF-8، عدد متنی، JSON serializeشده یا بایت‌های فایل کوچک باشد. Redis معنای داخل String را نمی‌فهمد مگر فرمانی برای آن طراحی شده باشد. مثلاً اگر JSON را با SET ذخیره کنی، GET کل متن را پس می‌دهد؛ نمی‌توانی با دستور Hash یک field داخلی آن را بخوانی.

یک key در هر لحظه نوع دارد. SET روی key موجود مقدار قبلی را جایگزین می‌کند، حتی اگر قبلاً نوع دیگری داشته باشد؛ TTL قدیمی هم با SET معمولی پاک می‌شود. برای شرط درج، SET key value NX فقط وقتی key وجود ندارد می‌نویسد. برای نگه‌داشتن TTL موجود، KEEPTTL را بررسی کن؛ برای lock، مالکیت و release امن باید جداگانه طراحی شوند.

## فرمان‌های String و پاسخ

~~~text
SET page:42:title "Redis basics"
OK
GET page:42:title
"Redis basics"
STRLEN page:42:title
(integer) 12
APPEND page:42:title " — intro"
(integer) 22
GET page:42:title
"Redis basics — intro"
~~~

STRLEN طول بایتی String را می‌دهد، نه لزوماً تعداد حرف قابل‌دیدن؛ حروف فارسی و emoji ممکن است چند بایت UTF-8 باشند. APPEND مقدار را به انتها اضافه می‌کند و طول جدید را می‌دهد. برای شمارنده از GET و محاسبه در client استفاده نکن؛ از INCR/INCRBY کمک بگیر:

~~~text
INCR article:42:views
(integer) 1
INCRBY article:42:views 5
(integer) 6
GET article:42:views
"6"
~~~

INCR اگر key نبود از صفر شروع می‌کند. اگر مقدار موجود عدد صحیح معتبر نباشد، خطا می‌دهد. فرمان افزایش اتمی است؛ دو client هم‌زمان افزایش بدهند، هر دو افزایش اعمال می‌شود. این تضمین فقط برای همین فرمان است، نه برای چند عملیات جدا مثل «اگر کمتر از سقف بود، افزایش بده».

برای چند key مرتبط، MGET/MSET می‌تواند رفت‌وبرگشت شبکه را کم کند. MGET برای key ناموجود مقدار خالی/nil در همان خانهٔ نتیجه می‌دهد؛ ترتیب پاسخ مطابق ترتیب keyهای درخواست‌شده است. Pipeline نیز چند فرمان را batch می‌کند، اما به‌تنهایی transaction نیست.

## Bitmap را با مثال روزانه تصور کن

Bitmap یک رشته است که هر موقعیتش یک بیت صفر یا یک است. فرض کن bit شمارهٔ 1200 برای user ID=1200 در تاریخ خاص نشان دهد کاربر فعال بوده است:

~~~text
SETBIT active:2026-11-10 1200 1
(integer) 0
GETBIT active:2026-11-10 1200
(integer) 1
BITCOUNT active:2026-11-10
~~~

SETBIT مقدار قبلی همان bit را برمی‌گرداند؛ پاسخ صفر یعنی قبلاً خاموش بود و اکنون روشن شد. اجرای دوباره هم پاسخ ۱ می‌دهد و وضعیت یکتا باقی می‌ماند. BITCOUNT تعداد بیت‌های یک را می‌شمارد. برای ترکیب روزها BITOP می‌تواند AND/OR/XOR انجام دهد، اما ترتیب و نام‌گذاری keyهای روزانه را خودت تعریف کن.

**هشدار مدل:** Bitmap روی بزرگ‌ترین offset حافظه می‌گیرد، حتی اگر فقط چند bit روشن باشد. اگر شناسهٔ کاربر بسیار بزرگ یا قابل‌کنترل توسط کاربر باشد، استفاده از ID مستقیم می‌تواند مقدار عظیمی allocate کند. در آن حالت، IDها را به index متراکم map کن یا Set را بسنج. Bitmap فهرست کاربرها یا اطلاعات اضافه را نگه نمی‌دارد.

## انتخاب میان String، Hash و JSON

- یک token یا counter ساده: String.
- چند field مستقل برای یک رکورد کوچک: Hash.
- سند تو در تو با تغییر path و نیاز به قابلیت JSON: Redis JSON، اگر نسخه/محصول پشتیبانی کند.
- String سریال‌شدهٔ بزرگ که مرتب یک field آن عوض می‌شود: معمولاً هزینهٔ serialize و rewrite را بررسی کن.

برای هرکدام اندازهٔ payload، تعداد updateها و queryهایی را که لازم داری یادداشت کن. Redis type را بر اساس شکل class برنامه انتخاب نکن؛ بر اساس عملیات پرتکرار انتخاب کن.

## تمرین هدایت‌شده

1. یک counter از صفر بساز و سه بار INCR بزن؛ مقدار نهایی را پیش‌بینی کن.
2. با SET دوباره همان key را متن کن و INCR را اجرا کن؛ خطا را توضیح بده.
3. در key جدا، SET با EX بزن، سپس SET معمولی اجرا و TTL را بررسی کن.
4. چند user ID متراکم روی Bitmap روزانه ثبت کن، BITCOUNT بگیر، و توضیح بده چرا ID پراکندهٔ خیلی بزرگ خطرناک است.
5. MGET روی key موجود و ناموجود اجرا کن و جای مقدار nil را تشخیص بده.

**پاسخ:** پس از سه INCR مقدار 3 است. SET متن، نوع را string نگه می‌دارد ولی INCR روی متن عددی خطا می‌دهد. SET معمولی روی همان key TTL قبلی را پاک می‌کند. Bitmap تعداد bitهای یک را می‌شمارد، نه تعداد eventها؛ ثبت تکراری user همان bit را دوباره یک می‌کند.

## مثال و آزمایش

```text
SET visits:today 0
INCR visits:today
SETBIT active:2026-11-10 12345 1
GETBIT active:2026-11-10 12345
BITCOUNT active:2026-11-10
```

## تجربهٔ کاربردی و سناریوی طراحی

شمارندهٔ بازدید و flag ورود روزانه کاربردهای رایج‌اند. ویدئوی فارسی منتخب، INCR و atomic counter را با مثال فروشگاه توضیح می‌دهد؛ مثال آموزشی است.

این بخش یک الگوی مهندسی/تمرین است؛ آن را به شرکت مشخصی نسبت نده.

## خطاهای رایج

الگوی GET سپس SET باعث lost update می‌شود؛ INCR به‌تنهایی شرط خرید موجودی یا منطق پیچیدهٔ رزرو را حل نمی‌کند.

## تمرین

1. مثال را در Redis محلی اجرا و خروجی را با زبان خودت توضیح بده.
2. دو حالت شکست یا edge case برای این الگو بنویس.
3. برای workload خودت حجم داده، نرخ خواندن/نوشتن، TTL یا retention و رفتار زمان outage را مشخص کن.
4. یک معیار بگذار: p95 latency، hit rate، RAM، lag، pending count یا زمان restore.

## کوییز

### 1. چرا INCR از read-modify-write برنامه‌ای امن‌تر است؟

<details><summary>پاسخ</summary>

افزایش در خود Redis اتمی اجرا می‌شود.

</details>

### 2. Bitmap برای چیست؟

<details><summary>پاسخ</summary>

پرچم‌های دودویی فشرده با index معلوم.

</details>

### 3. بالاترین offset چه اثری دارد؟

<details><summary>پاسخ</summary>

مقدار حافظهٔ bitmap را تعیین می‌کند.

</details>

## منابع انگلیسی

- [نقشهٔ Redis در roadmap.sh](https://roadmap.sh/pdfs/roadmaps/redis.pdf)
- [strings](https://redis.io/docs/latest/develop/data-types/strings/)
- [bitmaps](https://redis.io/docs/latest/develop/data-types/bitmaps/)

## منابع فارسی

- ویدئوی فارسی String و INCR: https://www.youtube.com/watch?v=e5Q_RUwviaE
- مرور فارسی: https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf

> برای قابلیت‌های تخصصی، مستند رسمی نسخه‌ای را که اجرا می‌کنی مرجع اصلی بگیر. منابع فارسی تخصصی برای همهٔ موضوع‌ها پوشش یکسان ندارند؛ این محدودیت در لینک‌های مکمل مشخص است.

</div>
