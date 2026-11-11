<div dir="rtl" align="right">

# Hash و مدل رکورد

> English edition: [Hashes and record modeling](./README.en.md)

> سطح پیشنهادی: مقدماتی تا میانی · زمان: ۳۰ تا ۶۰ دقیقه

## هدف یادگیری

Hash را برای رکورد کوچک و به‌روزرسانی فیلدها انتخاب کنی.

## درس

Hash یک key شامل field/value است و برای profile یا metadata کوچک مناسب است. HSET/HGET تغییر و خواندن، HMGET چند field، HDEL حذف، HEXISTS بررسی و HINCRBY افزایش اتمی field را انجام می‌دهند. HGETALL برای hash کوچک راحت است، اما روی مقدار بزرگ پاسخ سنگین می‌سازد.

Hash جای schema validation، index ثانویه یا foreign key نیست. برای دادهٔ پویا، نسخه‌گذاری، migration و حد حجم را در برنامه مدیریت کن.

## رکورد را field به field بخوان و تغییر بده

برای یک پروفایل کوچک می‌توانی fieldهای مستقل بسازی:

~~~text
HSET user:42 name Sara city Tehran plan free
(integer) 3
HGET user:42 name
"Sara"
HMGET user:42 name plan unknown_field
1) "Sara"
2) "free"
3) (nil)
HEXISTS user:42 city
(integer) 1
~~~

در HSET چندتایی، پاسخ عدد تعداد fieldهای تازه است؛ اگر field قبلی را به مقدار جدید تغییر بدهی، آن field در شمارش تازه‌ها نیست. HMGET پاسخ را به همان ترتیب fieldهای درخواست‌شده می‌دهد و برای field ناموجود nil می‌گذارد. HGETALL همهٔ field/valueها را برمی‌گرداند؛ چون complexity و اندازهٔ پاسخ با تعداد fieldها رشد می‌کند، آن را برای hash بسیار بزرگ به‌کار نبر.

## به‌روزرسانی اتمی field

~~~text
HINCRBY user:42 login_count 1
(integer) 1
HINCRBY user:42 login_count 5
(integer) 6
HGET user:42 login_count
"6"
~~~

HINCRBY اگر field نبود از صفر شروع می‌کند؛ اگر مقدارش عدد صحیح معتبر نباشد، خطا می‌دهد. از HINCRBYFLOAT فقط وقتی precision اعشاری مسئله را پوشش می‌دهد استفاده کن. برای پول، واحد کوچک integer مانند ریال/سنت معمولاً از float امن‌تر است.

## Hash در برابر JSON و چند key مستقل

- Hash یک نگاشت تخت field→string است؛ nested object را خودکار parse نمی‌کند.
- JSON ساختار تودرتو و path دارد و به نسخه/قابلیت Redis JSON وابسته است.
- چند key مستقل برای fieldهای پراستفاده می‌تواند update و TTL جدا بدهد، اما key count و عملیات چندکلیدی را بالا می‌برد.

سؤال طراحی این است: برنامه معمولاً کدام fieldها را می‌خواند؟ آیا کل رکورد با هم تغییر می‌کند؟ آیا expiration برای کل entity است یا fieldهای متفاوت؟ Hash برای رکوردهای کوچک و مسطح مفید است؛ آن را جایگزین کامل schema و validation پایگاه داده ندان.

## پیمایش Hash بزرگ و انقضای field

برای hash بزرگ، HSCAN را با cursor به‌جای HGETALL در مسیر عملیاتی بررسی کن. cursor را تا صفر ادامه بده؛ COUNT تعداد دقیق field در هر پاسخ نیست و duplicate نیز باید تحمل شود.

از Redis 7.4 به بعد fieldهای Hash می‌توانند expiry جدا داشته باشند. برای نمونه:

~~~text
HSET temporary:profile verification_code 123456 display_name Sara
HPEXPIRE temporary:profile 30000 FIELDS 1 verification_code
HPTTL temporary:profile FIELDS 1 verification_code
~~~

فرمان سوم TTL باقی‌ماندهٔ همان field را به millisecond می‌دهد؛ syntax و پاسخ را با version واقعی بررسی کن. expiration field با expiration کل key فرق دارد: اگر کل key منقضی شود، تمام fieldها از بین می‌روند. قابلیت اعلان تغییر field نیز وابسته به نسخه است؛ برای واکنش قطعی روی آن بدون بررسی مستندات تکیه نکن.

## طرح نمونه: session

برای یک session کوتاه‌عمر:

- key: `session:{opaque-id}`
- fields: user_id، created_at، permission_version
- TTL: انقضای کل session
- update: فقط field لازم را با HSET تغییر بده
- امنیت: token خام را به‌عنوان key یا log نکن؛ ACL را به prefix session محدود کن
- خروج: DEL key و invalidate سمت client

اگر هر field زمان انقضای متفاوت دارد، field-level expiry یا مدل چند key را مقایسه کن. session محل مناسبی برای نگه‌داری بی‌حد دادهٔ حساب کاربر نیست.

## تمرین با پاسخ

1. Hash user:42 را بساز، دو field بخوان و یک field غایب را با HMGET ببین.
2. HSET یک field موجود را دوباره تغییر بده؛ خروجی count را با درج field تازه مقایسه کن.
3. با HINCRBY یک counter بساز؛ سپس متن غیرعددی بگذار و خطا را بخوان.
4. hashی با ۵۰ field بساز و به جای HGETALL، HSCAN را تا cursor صفر ادامه بده.
5. اگر Redis نسخهٔ 7.4+ است، field موقت را با HPEXPIRE expire کن؛ اگر نیست، feature را به‌عنوان unsupported علامت بزن.

**پاسخ:** شمارش HSET فقط fieldهای جدید را می‌گیرد؛ HINCRBY روی مقدار غیرعددی خطا می‌دهد؛ HMGET nil را در خانهٔ همان field می‌گذارد؛ HSCAN incremental است و جای یک snapshot ثابت را نمی‌گیرد.

## مثال و آزمایش

```text
HSET user:42 name "Sara" city "Tehran" plan "free"
HGET user:42 city
HINCRBY user:42 login_count 1
HMGET user:42 name plan
```

## تجربهٔ کاربردی و سناریوی طراحی

ذخیرهٔ metadata پرتکرار session/profile می‌تواند دریافت یک سند بزرگ را حذف کند؛ کنترل دسترسی دادهٔ حساس را جدا نگه دار.

این بخش یک الگوی مهندسی/تمرین است؛ آن را به شرکت مشخصی نسبت نده.

## خطاهای رایج

HGETALL روی hash بزرگ، یا تصور حذف فیلد که index و دادهٔ مشتق‌شده را هم خودکار پاک می‌کند.

## تمرین

1. مثال را در Redis محلی اجرا و خروجی را با زبان خودت توضیح بده.
2. دو حالت شکست یا edge case برای این الگو بنویس.
3. برای workload خودت حجم داده، نرخ خواندن/نوشتن، TTL یا retention و رفتار زمان outage را مشخص کن.
4. یک معیار بگذار: p95 latency، hit rate، RAM، lag، pending count یا زمان restore.

## کوییز

### 1. HINCRBY چه خاصیتی دارد؟

<details><summary>پاسخ</summary>

افزایش field را اتمی انجام می‌دهد.

</details>

### 2. چطور چند field را با یک فرمان می‌خوانی؟

<details><summary>پاسخ</summary>

HMGET.

</details>

### 3. Hash constraint رابطه‌ای دارد؟

<details><summary>پاسخ</summary>

خیر؛ نگاشت سادهٔ field/value است.

</details>

## منابع انگلیسی

- [نقشهٔ Redis در roadmap.sh](https://roadmap.sh/pdfs/roadmaps/redis.pdf)
- [hashes](https://redis.io/docs/latest/develop/data-types/hashes/)

## منابع فارسی

- مرور فارسی ساختارها: https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf

> برای قابلیت‌های تخصصی، مستند رسمی نسخه‌ای را که اجرا می‌کنی مرجع اصلی بگیر. منابع فارسی تخصصی برای همهٔ موضوع‌ها پوشش یکسان ندارند؛ این محدودیت در لینک‌های مکمل مشخص است.

</div>
