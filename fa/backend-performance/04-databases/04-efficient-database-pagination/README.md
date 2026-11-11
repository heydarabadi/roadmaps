<div dir="rtl" align="right">

# صفحه‌بندی کارآمد در دیتابیس

**زبان:** فارسی · [English version](../../../../en/backend-performance/04-databases/04-efficient-database-pagination/README.md)


**هدف یادگیری:** هزینه OFFSET را از اندازه صفحه جدا کنید، Keyset با ترتیب قطعی بنویسید و تغییر هم‌زمان داده را تحلیل کنید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ نمونه PostgreSQL آموزشی و اجرا‌نشده است.

## مدل ذهنی

OFFSET می‌گوید چند ردیف نتیجه کنار گذاشته شود؛ موتور همچنان باید مسیر رسیدن به آن نقطه را طی کند. LIMIT تنها اندازه خروجی را محدود می‌کند. Keyset از آخرین کلید مرتب‌سازی صفحه قبل شروع می‌کند؛ با ایندکس سازگار، کار پیمایش ردیف‌های دورریخته‌شده کمتر می‌شود. ترتیب باید قطعی باشد؛ timestamp به‌تنهایی در صورت تساوی کافی نیست. [مستند LIMIT/OFFSET PostgreSQL](https://www.postgresql.org/docs/current/queries-limit.html) هزینه offset بزرگ و ضرورت ترتیب قابل پیش‌بینی را توضیح می‌دهد.

| روش | مزیت | محدودیت |
| --- | --- | --- |
| OFFSET | پرش مستقیم به شماره صفحه | کار بیشتر در عمق، جابه‌جایی با درج/حذف |
| Keyset | ادامه پیمایش از کلید | پرش دلخواه دشوار، وابستگی به sort |
| Snapshot ثابت | گزارش با مجموعه ثابت | نگهداری snapshot/نسخه و هزینه عملیاتی |

Keyset تضمین snapshot نیست: تغییر مقدار sort ممکن است باعث تکرار یا جاافتادن شود. برای export دقیق، قرارداد snapshot یا high-water mark متناسب با نیاز تعریف کنید.

## کاربرد و مصالحه

برای feed و پیمایش متوالی بزرگ مناسب است. صفحه‌های کوچک کم‌عمق با نیاز پرش به شماره مشخص ممکن است OFFSET را توجیه کنند. COUNT دقیق را جدا قیمت‌گذاری کنید؛ شمارش همه ردیف‌ها می‌تواند از گرفتن صفحه گران‌تر باشد. NULL، sort ترکیبی صعودی/نزولی و چند tenant شرط seek را پیچیده می‌کنند؛ مثال پایین ستون‌های NOT NULL و جهت یکسان دارد.

## مثال حل‌شده

طرح فرضی: `orders(id bigint primary key, customer_id bigint not null, created_at timestamp not null)`. صفحه اول همان query بدون شرط cursor است؛ صفحه بعد از آخرین `(created_at,id)` استفاده می‌کند.

<div dir="ltr" align="left">

```sql
CREATE INDEX orders_page_idx
ON orders(customer_id, created_at DESC, id DESC);

SELECT id, created_at
FROM orders
WHERE customer_id = 42
  AND (created_at, id) < (TIMESTAMP '2026-10-01 12:00:00', 9001)
ORDER BY created_at DESC, id DESC
LIMIT 21;
```

</div>

اندازه نمایشی ۲۰ است؛ ردیف ۲۱ فقط برای تشخیص ادامه مصرف می‌شود. Cursor بعدی از ردیف بیستم ساخته می‌شود، نه بیست‌ویکم. فیلتر مشتری در هر صفحه تکرار می‌شود و به Cursor برای مجوز اعتماد نمی‌کنیم. مقادیر واقعی bind می‌شوند. اینجا مکانیک SQL بررسی می‌شود؛ شکل Cursor، خطای ورودی و قرارداد API در [درس صفحه‌بندی API](../../02-api-response/03-efficient-pagination/README.md) است.

## تمرین و مشاهده مورد انتظار

در جدول آزمایشی ۱۰۰ هزار ردیف با timestampهای مساوی بسازید. `LIMIT 20 OFFSET 80000` و seek متناظر را با `EXPLAIN (ANALYZE, BUFFERS)` مقایسه کنید. سپس میان دو صفحه یک ردیف جدید قبل از مرز درج کنید. انتظار: OFFSET می‌تواند دوباره ردیف انتهای صفحه قبلی را نشان دهد؛ Keyset با کلیدهای ثابت از مرز ادامه می‌دهد، ولی رکورد جدید قبل از مرز را در ادامه نمی‌بیند. bufferها و rows پلن را مقایسه کنید؛ شتاب عددی ثابت انتظار نداشته باشید.

## شاهد عمومی

[مستند توسعه GitLab برای Keyset pagination](https://docs.gitlab.com/development/database/keyset_pagination/) استفاده از ترتیب، کلید متمایز و Cursor را در یک محصول واقعی مستند می‌کند. این راهنمای مهندسی شاهد کاربرد است، نه benchmark مستقل برای مثال ما؛ محدودیت sort و index باید در workload خود سنجیده شود.

## شکست‌ها، سیگنال‌ها و چک‌لیست

latency صعودی با شماره صفحه، rows scanned بسیار بیشتر از rows returned و sort روی دیسک نشانه‌های قابل بررسی‌اند. حذف tie-breaker، جهت نادرست comparator، تغییر فیلتر بین صفحات و cursor بر پایه فیلد mutable از خطاهای رایج‌اند.

- [ ] sort قطعی، جهت comparator و رفتار NULL مشخص است.
- [ ] index با tenant/filter و order سازگار بررسی شده است.
- [ ] اندازه صفحه سقف دارد و COUNT هزینه مستقل دارد.
- [ ] درج، حذف و تغییر sort میان صفحات تحلیل شده است.
- [ ] Cursor به فیلتر مرتبط است و مجوز هر درخواست دوباره بررسی می‌شود.
- [ ] صفحه عمیق، مرز تساوی و پایان مجموعه بررسی می‌شوند.

## پیش‌نیازها، مرز cursor و حل تمرین

صفحه‌بندی نتیجه مرتب را به بخش‌های محدود تقسیم می‌کند. OFFSET تعداد ردیف‌های قبلی را دور می‌اندازد؛ cursor کلید آخرین ردیف تحویل‌شده را نگه می‌دارد؛ tie-breaker کلید یکتایی است که تساوی sort را می‌شکند. فیلتر، sort و جهت هر کلید باید معلوم باشند؛ ترتیب نامعین مرز قابل اتکا ندارد.

صفحه اول ۲۰ ردیف می‌دهد و یک ردیف اضافه فقط وجود صفحه بعد را نشان می‌دهد. اگر ردیف بیستم زوج (created_at,id) مشخصی داشته باشد، cursor همین زوج است؛ صفحه بعد در sort نزولی شرط زوج کوچک‌تر می‌گیرد. ردیف ۲۱ تحویل نشده و نباید cursor شود. index با customer_id و سپس کلیدهای sort نامزد است، ولی پلن باید بررسی شود.

برای OFFSET=80,000 و اندازه صفحه ۲۰، مسیر معمول باید 80,020 ردیف نتیجه را رد/طی کند؛ این شمار I/O فیزیکی نیست چون cache و plan اثر دارند. Keyset از مرز شروع می‌کند و ردیف‌های پیشین را برای شمردن صفحه نمی‌خواهد. درج قبل از مرز در ادامه Keyset دیده نمی‌شود؛ این با snapshot کامل یکی نیست. OFFSET با درج پیش از مرز می‌تواند ردیف را تکرار یا جا بیندازد.

### مسیر عیب‌یابی

اگر صفحه عمیق کند است، plan، rows طی‌شده نسبت به تحویل‌شده، sort و buffers را ببینید. اگر مرز پرش دارد، کلید یکتا، جهت comparator، NULL و فیلتر ثابت را بررسی کنید؛ بعد فیلد sort قابل تغییر را شناسایی کنید. برای export ثابت، snapshot یا high-water mark تعریف کنید. جهت‌های مختلط و NULL به شرط seek صریح و بررسی داده مرزی نیاز دارند.

## جمع‌بندی

OFFSET برای پرش شماره صفحه ساده است ولی هزینه عمق دارد؛ Keyset برای پیمایش پیوسته مرز دارد اما snapshot ایجاد نمی‌کند. Cursor بخشی از صحت است.

## خودآزمایی

۱. چرا LIMIT کوچک، OFFSET بزرگ را لزوماً ارزان نمی‌کند؟

۲. در ترتیب نزولی مثال، شرط صفحه بعد `<` است یا `>`؟

۳. اگر چند ردیف timestamp یکسان داشته باشند، چه لازم است؟

۴. آیا Keyset همه داده‌ها را در یک snapshot می‌بیند؟

۵. چرا Cursor از ردیف بیستم ساخته می‌شود؟

### پاسخ‌نامه با دلیل

۱. موتور باید ردیف‌های پیش از offset را محاسبه/عبور کند؛ خروجی کوچک برابر کار کم نیست.

۲. `<`؛ بعدی در ترتیب نزولی کلید کوچک‌تر دارد، با فرض جهت یکسان هر دو ستون.

۳. کلید یکتای تکمیلی مانند id؛ وگرنه مرز صفحه مبهم می‌شود.

۴. خیر؛ snapshot و تغییر ستون مرتب‌سازی مسئله جدا هستند.

۵. آن ردیف آخرین ردیف تحویل‌شده است؛ استفاده از ردیف اضافی باعث جاافتادنش می‌شود.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- انگلیسی: [PostgreSQL LIMIT/OFFSET](https://www.postgresql.org/docs/current/queries-limit.html)؛ مبنای هزینه و ترتیب.
- انگلیسی: [GitLab Keyset pagination](https://docs.gitlab.com/development/database/keyset_pagination/)؛ پیاده‌سازی و محدودیت‌های کاربردی.
- فارسی: [صفحه‌بندی Oracle؛ کلید ادامه و تصویر ثابت](https://www.brserp.com/knowledge/erp-oracle-pagination-offset-seek-stable-order-snapshot-guide)؛ برای فهم ترتیب یکتا و محدودیت Keyset در داده متغیر. متن نمایه‌شده در جستجوی عمومی بررسی شد؛ بازکردن مستقیم در ابزار پژوهش محدود بود. نحو و رفتار Oracle را با PostgreSQL یکسان فرض نکنید.

- English, official: [GitLab pagination performance guidelines](https://docs.gitlab.com/development/database/pagination_performance_guidelines/) discusses indexes and sort requirements across pagination methods.
- English, official: [EF Core pagination](https://learn.microsoft.com/en-us/ef/core/querying/pagination) contrasts offset and keyset navigation and documents composite ordering.
- English, official: [GitLab keyset pagination](https://docs.gitlab.com/development/database/keyset_pagination/) describes its implementation and unsupported query shapes in one large application.
- English, official: [PostgreSQL LIMIT and OFFSET](https://www.postgresql.org/docs/current/queries-limit.html) documents deterministic ordering and planner behavior.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: ORM](../03-orm-fetch-strategies/README.md) · [بعدی: Projection](../05-select-only-needed-columns/README.md) · [ایندکس](../02-indexes/README.md)

</div>


