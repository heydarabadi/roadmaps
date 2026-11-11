<div dir="rtl" align="right">

# انتخاب فقط ستون‌های لازم — Projection

**زبان:** فارسی · [English version](../../../../en/backend-performance/04-databases/05-select-only-needed-columns/README.md)


**هدف یادگیری:** هزینه پهنای ردیف را از تعداد ردیف جدا کنید، query متناسب با خروجی بنویسید و شرایط Index-only scan را بشناسید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ SQLها برای PostgreSQL و اجرا‌نشده‌اند.

## مدل ذهنی

WHERE تعداد ردیف را محدود می‌کند و SELECT فهرست ستون‌های خروجی را. `SELECT *` ممکن است متن، JSON یا باینری بزرگی بگیرد که مصرف‌کننده لازم ندارد. حتی اگر مسیر خواندن صفحه دیسک همان باشد، انتقال از DB به برنامه، decoding، ساخت شیء و serialization می‌تواند کمتر شود. کوچک‌شدن خروجی الزاماً تعداد heap pageهای خوانده‌شده را کم نمی‌کند.

| لایه | اثر بالقوه Projection | روش مشاهده |
| --- | --- | --- |
| موتور | ردیف میانی باریک‌تر، امکان پوشش index | width، plan، buffers |
| شبکه DB→App | بایت کمتر | bytes received در driver/شبکه |
| برنامه | allocation و mapping کمتر | حافظه، CPU و زمان mapping |
| قرارداد | ستون حساس/جدید ناخواسته وارد نمی‌شود | بررسی schema پاسخ |

در PostgreSQL، Covering index تنها شرط Index-only scan نیست؛ visibility map تعیین می‌کند آیا مراجعه به heap برای دیدپذیری لازم است. [مستند Index-only scans](https://www.postgresql.org/docs/current/indexes-index-only-scans.html) این محدودیت را شرح می‌دهد.

## کاربرد و مصالحه

برای فهرست‌ها و read DTO مناسب است. در مسیر ویرایش، ستون‌های لازم برای concurrency مانند version یا کلیدهای mapping را حذف نکنید. deferred column که بعداً lazy خوانده شود می‌تواند N+1 بسازد. index با INCLUDE برای همه فیلدها نیز هزینه فضا و write دارد؛ ستون بزرگ را صرفاً برای پوشش query وارد index نکنید.

## مثال حل‌شده

طرح فرضی `documents(id bigint primary key, tenant_id bigint, title text, body text, version bigint)` است. صفحه فهرست، بدنه سند را لازم ندارد:

<div dir="ltr" align="left">

```sql
-- List endpoint:
SELECT id, title, version
FROM documents
WHERE tenant_id = 7
ORDER BY id DESC
LIMIT 20;

-- Detail endpoint, after authorization:
SELECT id, title, body, version
FROM documents
WHERE tenant_id = 7 AND id = 81;
```

</div>

جداسازی list/detail باعث می‌شود body فقط با نیاز واقعی دریافت شود. `tenant_id` در هر دو شرط باقی می‌ماند. version برای ویرایش احتمالی در پاسخ لازم است. مثال نسخه‌ای از طراحی است؛ اجازه دسترسی را صرف وجود شرط query کامل فرض نکنید.

## تمرین و مشاهده مورد انتظار

۲۰ سند آزمایشی با body بزرگ بسازید. یک بار `SELECT *` و یک بار query فهرست بالا را با خروجی یکسان نمایشی اجرا کنید؛ بایت دریافتی و allocation را بسنجید. سپس پس از Projection، در حلقه به body دسترسی بدهید و query count را ثبت کنید. انتظار: projection بایت کمتری منتقل کند؛ دسترسی lazy بعدی ممکن است مزیت را با queryهای اضافی از بین ببرد. پلن یا bufferها ممکن است یکسان بمانند.

## شاهد عمومی و حد شواهد

[مستند رسمی PostgreSQL درباره Covering index](https://www.postgresql.org/docs/current/indexes-index-only-scans.html) شاهد عملیاتی ارتباط ستون‌های انتخاب‌شده، visibility و heap fetch است. گزارش شرکت مستقلی که صرفاً حذف ستون را با تمام عوامل کنترل‌شده اندازه گرفته باشد در منابع این درس ارائه نشده؛ عدد body و مثال سند فرضی‌اند.

## شکست‌ها، سیگنال‌ها و چک‌لیست

SQL سریع ولی CPU mapping یا network bytes زیاد، می‌تواند نشانه دریافت اضافی باشد. حذف کلیدها رابطه‌ها را می‌شکند؛ حذف version حفاظت optimistic concurrency را مختل می‌کند. Index-only scan با heap fetch بالا الزاماً مسئله Projection نیست و به نگهداری نیز مرتبط است.

- [ ] فهرست ستون‌ها از نیاز مصرف‌کننده استخراج شده است.
- [ ] کلیدها، tenant و version مورد نیاز mapping/ویرایش حفظ شده‌اند.
- [ ] بایت، allocation و query count کنار زمان DB سنجیده می‌شوند.
- [ ] دسترسی بعدی به ستون deferred، SQL پنهان نمی‌سازد.
- [ ] Covering index با فضا، write و visibility map ارزیابی می‌شود.
- [ ] افزودن ستون جدید به جدول، پاسخ عمومی را ناخواسته تغییر نمی‌دهد.

## پیش‌نیازها و حل عددی Projection

Projection ستون‌های نتیجه را محدود می‌کند؛ WHERE ردیف را. این دو مستقل‌اند. پهنای ردیف و هزینه mapping/انتقال به برنامه را از تعداد heap page جدا بسنجید؛ ستون کمتر تضمین نمی‌کند موتور صفحه کمتری از دیسک بخواند.

فرض آموزشی: body هر سند ۶۴ KiB و فهرست ۲۰ سند است. SELECT * دست‌کم ۲۰×۶۴=۱۲۸۰ KiB یا ۱٫۲۵ MiB داده body می‌گیرد، به‌علاوه ستون‌های دیگر. فهرست id/title/version همین bodyها را حذف می‌کند؛ اندازه واقعی encoding و فشرده‌سازی فرق دارد، پس این benchmark نیست. اگر renderer سپس body هر سند را جدا بخواند، ۲۰ query اضافی بخشی از سود را می‌بلعد.

### حل تمرین و مسیر عیب‌یابی

در خروجی نمایشی یکسان، انتظار کمترشدن bytes و allocation داریم؛ plan و buffers ممکن است ثابت بمانند. اگر حلقه بعدی به body دسترسی دهد، SQL تولیدشده و query count را پس از serialization دوباره ثبت کنید. راه‌حل، projection فهرست و query detail جدا با مجوز درست است؛ همه bodyها را برای پرهیز از یک query بیشتر برنگردانید.

اگر زمان DB مناسب ولی response bytes، mapping CPU یا شبکه DB→App زیاد است، ستون‌های واقعاً مصرف‌شده را فهرست کنید. بعد از projection، queryهای lazy/deferred را بشمارید و کلید tenant، mapping و version را حذف نکنید. برای Index-only scan، heap fetch و visibility را در plan ببینید؛ وجود ستون‌ها در index به‌تنهایی کافی نیست.

## جمع‌بندی

ستون کمتر پهنای انتقال و ساخت خروجی را کم می‌کند، نه الزاماً I/O دیسک را. قرارداد endpoint و دسترسی بعدی را باهم بررسی کنید.

## خودآزمایی

۱. تفاوت کاهش ردیف و کاهش ستون چیست؟

۲. آیا حذف body همیشه I/O دیسک را به همان نسبت کم می‌کند؟

۳. چرا version در پاسخ فهرست ممکن است لازم باشد؟

۴. شرط Index-only scan فقط وجود همه ستون‌ها در index است؟

۵. حذف ستون با ORM چه زمانی N+1 می‌سازد؟

### پاسخ‌نامه با دلیل

۱. WHERE ردیف‌ها را و SELECT ستون‌ها/پهنای نتیجه را محدود می‌کند؛ دو محور مستقل‌اند.

۲. خیر؛ موتور ممکن است همان صفحه‌ها را بخواند، ولی انتقال و ساخت شیء همچنان کمتر شود.

۳. برای قرارداد ویرایش با optimistic concurrency؛ حذفش می‌تواند معنای عملیات را عوض کند.

۴. خیر؛ در PostgreSQL دیدپذیری ردیف و visibility map روی مراجعه به heap اثر دارد.

۵. وقتی کد بعداً هر ستون deferred را جدا می‌خواند؛ query count باید پس از serialization سنجیده شود.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- انگلیسی: [Index-only scans and covering indexes](https://www.postgresql.org/docs/current/indexes-index-only-scans.html)؛ شرایط فنی و هزینه ستون‌های INCLUDE.
- فارسی: [امنیت و بهینه‌سازی دیتابیس، بخش اصول پایه بهینه‌سازی کوئری](https://shahin.page/persian/article-fa/database-security-and-optimization-access-control-and-indexing-fa)؛ مقدمه انتخاب ستون‌های لازم به‌جای SELECT *. جزئیات visibility map را از مرجع رسمی انگلیسی بخوانید.

- English, official: [EF Core efficient querying](https://learn.microsoft.com/en-us/ef/core/performance/efficient-querying) demonstrates selecting only required properties and the tracking trade-off.
- English, official: [SQLAlchemy column loading](https://docs.sqlalchemy.org/en/20/orm/queryguide/columns.html) explains load_only, deferred fields, and accidental follow-up SQL.
- English, official: [Django database optimization](https://docs.djangoproject.com/en/stable/topics/db/optimization/) covers values, defer, and only with cautions for their use.
- English, official: [PostgreSQL visibility map](https://www.postgresql.org/docs/current/storage-vm.html) explains why index-only scans can still consult heap pages.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Pagination](../04-efficient-database-pagination/README.md) · [بعدی: Denormalization](../06-denormalization-for-read-heavy-workloads/README.md) · [نگهداری](../08-database-maintenance/README.md)

</div>


