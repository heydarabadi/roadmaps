<div dir="rtl" align="right">

# Denormalization برای بار خواندن زیاد

**زبان:** فارسی · [English version](../../../../en/backend-performance/04-databases/06-denormalization-for-read-heavy-workloads/README.md)


**هدف یادگیری:** یک Read model مشتق‌شده طراحی کنید، بودجه کهنگی را بنویسید و هزینه حفظ سازگاری را با هزینه محاسبه هر خواندن مقایسه کنید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ مثال PostgreSQL آموزشی و اجرا‌نشده است.

## مدل ذهنی

Normalization تکرار داده را کم و قواعد به‌روزرسانی را متمرکز می‌کند. Denormalization بخشی از نتیجه join/aggregate یا داده تکراری را ذخیره می‌کند تا خواندن کم‌کارتر شود. داده مشتق‌شده باید منبع حقیقت، مالک به‌روزرسانی و راه بازسازی داشته باشد. جدول خلاصه، counter و Materialized view شکل‌های متفاوت این تصمیم‌اند؛ cache نیز ممکن است نقش مشابهی داشته باشد ولی قرارداد ماندگاری و مالکیت را باید جدا نوشت.

| روش نگهداری | تازگی | هزینه |
| --- | --- | --- |
| به‌روزرسانی در تراکنش write | همگام با commit محلی | write و رقابت بیشتر |
| رویداد/CDC و projector | با تأخیر | replay، ترتیب و idempotency |
| refresh دوره‌ای | کهنگی تا نوبت بعد | محاسبه دسته‌ای و زمان refresh |

صرف زیادبودن نسبت read/write کافی نیست؛ query پرتکرار باید واقعاً هزینه‌بر و نتیجه قابل نگهداری باشد. برای قیمت نهایی یا موجودی قطعی، خلاصه کهنه به‌تنهایی مجوز عملیات نیست.

## کاربرد و مصالحه

برای داشبورد، فهرست و گزارش پرتکرار با بودجه تازگی مشخص مناسب است. برای write زیاد، مدل با تغییر پیوسته یا تراکنش‌هایی که به صحت لحظه‌ای نیاز دارند، پیچیدگی ممکن است سود را ببلعد. فضای بیشتر، write amplification و اصلاح داده ناسازگار بخشی از هزینه‌اند. ابتدا query، index و projection را بسنجید.

## مثال حل‌شده

فرض: `orders(id, customer_id, total, status)` منبع حقیقت است. داشبورد فقط مجموع سفارش‌های پرداخت‌شده هر مشتری را می‌خواهد و تأخیر چند دقیقه‌ای را می‌پذیرد.

<div dir="ltr" align="left">

```sql
CREATE MATERIALIZED VIEW customer_sales AS
SELECT customer_id, COUNT(*) AS order_count, SUM(total) AS amount
FROM orders
WHERE status = 'paid'
GROUP BY customer_id;

SELECT order_count, amount FROM customer_sales WHERE customer_id = 42;
-- Scheduled in the lab, outside a request:
REFRESH MATERIALIZED VIEW customer_sales;
```

</div>

در PostgreSQL، نتیجه ذخیره می‌شود و خودکار با هر write تازه نمی‌شود. زمان موفق آخرین refresh را کنار داشبورد ثبت کنید. REFRESH معمولی می‌تواند خوانندگان را منتظر بگذارد؛ حالت CONCURRENTLY پیش‌نیازهایی از جمله unique index مناسب و view پرشده دارد و همچنان هزینه محاسبه دارد. [مستند Materialized views](https://www.postgresql.org/docs/current/rules-materializedviews.html) برای مدل و مثال گزارش بخوانید؛ شرایط دقیق command را در نسخه خود بررسی کنید.

## تمرین و مشاهده مورد انتظار

یک سفارش paid اضافه کنید؛ query مستقیم روی orders و view را پیش از refresh مقایسه کنید. سپس refresh کنید و دوباره بخوانید. انتظار: view تا refresh قدیمی است و پس از موفقیت با مجموعه خوانده‌شده هنگام refresh همگرا می‌شود. سناریوی projector رویدادی را روی کاغذ با یک event تکراری و یک event جابه‌جا طراحی کنید: نگهداری `event_id` و version چه خطایی را می‌گیرد؟

## شاهد عمومی و حد شواهد

[مستند رسمی PostgreSQL](https://www.postgresql.org/docs/current/rules-materializedviews.html) نمونه گزارش فروش ذخیره‌شده و تفاوت تازگی/سرعت را نشان می‌دهد. این مثال مرجع آموزشی است، نه گزارش تولیدی شرکت؛ در این درس مطالعه موردی مستقیم با اندازه‌گیری مستقل برای Read model بالا نداریم.

## شکست‌ها، سیگنال‌ها و چک‌لیست

جمع دوباره رویداد تکراری، جاافتادن refund/delete، update ناقص بین دو سیستم و refresh ناموفقِ بی‌هشدار از خطاهای رایج‌اند. age داده، lag projector، اختلاف reconciliation و هزینه refresh را ثبت کنید؛ latency خواندن به‌تنهایی صحت را نشان نمی‌دهد.

- [ ] منبع حقیقت و مالک Read model مشخص است.
- [ ] بودجه تازگی، timestamp/version و رفتار داده خیلی کهنه تعریف شده است.
- [ ] update، delete و refund در مدل مشتق‌شده پوشش دارند.
- [ ] replay و deduplication برای مسیر رویدادی طراحی شده‌اند.
- [ ] rebuild و reconciliation با منبع حقیقت وجود دارد.
- [ ] هزینه write، فضا، قفل و refresh کنار read latency سنجیده می‌شود.

## پیش‌نیازها و چرخه Read model

منبع حقیقت جای ثبت داده پایه طبق قواعد اصلی است؛ Read model نتیجه مشتق‌شده برای خواندن است؛ freshness فاصله آن نتیجه از تغییرات منبع است. Denormalization محاسبه join/aggregate را حذف نمی‌کند، آن را به write، projector رویداد یا refresh می‌برد. پیش از ساخت، مالک به‌روزرسانی، بودجه کهنگی و راه بازسازی را تعیین کنید.

### حل محاسبه، تمرین و تشخیص

اگر سه سفارش paid مبلغ‌های ۲۰، ۳۰ و ۵۰ داشته باشند، refresh مجموع ۱۰۰ و count برابر ۳ را ذخیره می‌کند. سفارش paid جدید ۲۰ در source دیده می‌شود اما view هنوز ۱۰۰ دارد تا refresh شود؛ پس از refresh مقدار ۱۲۰ است. بازپرداخت ۳۰ را نیز باید از جمع خارج کند. Projector افزایشی باید refund/delete و event تکراری را پوشش دهد؛ وگرنه خلاصه خراب می‌شود. در تمرین، event_id پردازش‌شده را رد می‌کند تا دوباره جمع نشود؛ version aggregate می‌تواند رویداد عقب‌تر را شناسایی کند، اما تضمین ابزار خاص نیست.

اگر پاسخ سریع ولی کهنه است، سن refresh و lag را با freshness budget مقایسه کنید. اختلاف جمع را با reconciliation منبع حقیقت پیدا کنید؛ refresh شکست‌خورده، event تکراری و delete را جدا بررسی کنید. پیش از denormalization plan، index و projection query اصلی را بسنجید؛ سپس هزینه write، فضا، rebuild و قفل را هم لحاظ کنید.

## جمع‌بندی

Read model هزینه خواندن را کم می‌کند و در عوض مالکیت، تازگی و بازسازی می‌خواهد. صحت و زمان پاسخ هر دو بخشی از قراردادند.

## خودآزمایی

۱. Denormalization چه کاری را از خواندن به زمان دیگری منتقل می‌کند؟

۲. آیا Materialized view با هر INSERT خودکار تازه می‌شود؟

۳. چرا event تکراری برای counter خطرناک است؟

۴. موجودی نمایش‌داده‌شده از Read model مجوز فروش قطعی است؟

۵. چه شاخصی کنار سرعت خواندن ضروری است؟

### پاسخ‌نامه با دلیل

۱. join/aggregate یا ساخت نمای خروجی را به write، projector یا refresh منتقل می‌کند؛ هزینه حذف نمی‌شود.

۲. در مثال PostgreSQL خیر؛ refresh صریح لازم است.

۳. جمع دوباره رقم را خراب می‌کند؛ idempotency/deduplication یا محاسبه نسخه‌دار لازم است.

۴. خیر؛ عملیات باید با قواعد تراکنشی منبع و بودجه سازگاری اعتبارسنجی شود.

۵. سن داده و اختلاف با منبع؛ پاسخ سریع قدیمی ممکن است برای قرارداد نامعتبر باشد.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- انگلیسی: [PostgreSQL Materialized views](https://www.postgresql.org/docs/current/rules-materializedviews.html)؛ مدل ذخیره نتیجه و مثال گزارش.
- انگلیسی تکمیلی: [REFRESH MATERIALIZED VIEW](https://www.postgresql.org/docs/current/sql-refreshmaterializedview.html)؛ پیش‌نیاز unique index، view پرشده و تفاوت قفل در CONCURRENTLY.
- فارسی: [نرمال‌سازی و فرم‌های نرمال، بخش تعادل تئوری و کارایی](https://pro-nee.net/collections/normalization-and-normal-forms/)؛ مقدمه افزونگی آگاهانه و anomalyها. منبع فارسی تخصصی برای replay/reconciliation این مدل در این بررسی پیدا نشد؛ تمرین همین صفحه آن فاصله را روشن می‌کند.

- English, official: [Microsoft CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs) explains read models, denormalized projections, and eventual consistency.
- English, official: [AWS Prescriptive Guidance: CQRS](https://docs.aws.amazon.com/prescriptive-guidance/latest/modernization-data-persistence/cqrs-pattern.html) walks through event-driven updates to a query model and its design variants.
- English, official: [.NET cloud-native distributed data patterns](https://learn.microsoft.com/en-us/dotnet/architecture/cloud-native/distributed-data) discusses normalized write models and denormalized read models.
- Persian, complementary: [Metabase Persian: making dashboards faster](https://metabase.ir/learn/metabase-basics/administration/administration-and-operation/making-dashboards-faster) gives a practical materialized-view example; its product-specific workflow is not a database rule.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Projection](../05-select-only-needed-columns/README.md) · [بعدی: Join](../07-join-optimization/README.md) · [کارهای پس‌زمینه](../../03-asynchronism/01-background-jobs/README.md)

</div>


