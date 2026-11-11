<div dir="rtl" align="right">

# راهبرد دریافت در ORM — Lazy، Eager و Batch

**زبان:** فارسی · [English version](../../../../en/backend-performance/04-databases/03-orm-fetch-strategies/README.md)


**هدف یادگیری:** N+1 را از روی SQL شناسایی کنید، بین join و batch انتخاب کنید و تعداد query را کنار اندازه داده بسنجید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ مثال مستقل از ORM و اجرا‌نشده است.

## مدل ذهنی

Lazy loading رابطه را هنگام دسترسی می‌خواند. Eager loading آن را پیشاپیش دریافت می‌کند؛ ممکن است با join یا query جدا باشد. Batch/select-in شناسه‌ها را جمع می‌کند و چند رابطه را یک‌جا می‌خواند. اصطلاح Eager الزاماً به معنی «دقیقاً یک SQL» نیست.

| راهبرد | شکل کار | خطر |
| --- | --- | --- |
| Lazy | query پایه و سپس دریافت موردی | N+1 و I/O پنهان در serializer |
| Joined eager | یک join با داده تکراری والد | افزایش شدید ردیف‌ها در چند collection |
| Batch/select-in | والدها، سپس فرزندان با مجموعه ID | حد پارامتر، حافظه و چند snapshot |

اگر ۲۰ سفارش و برای هرکدام query مشتری اجرا شود، الگوی ۱+۲۰ داریم؛ identity map یا cache برخی ORMها ممکن است شمارش را کاهش دهد، پس SQL واقعی را بشمارید. [مستند SQLAlchemy 2.0](https://docs.sqlalchemy.org/en/20/orm/queryguide/relationships.html) تفاوت lazy، joined و select-in و راه جلوگیری از lazy ناخواسته را شرح می‌دهد؛ API هر ORM را جدا بررسی کنید.

## کاربرد و مصالحه

برای یک رابطه تک‌مقداری کوچک، join می‌تواند مناسب باشد. دو collection با ۱۰ و ۵ فرزند ممکن است ۵۰ ردیف ترکیبی برای یک والد بسازند؛ batch گاهی بایت و حافظه کمتری می‌گیرد، هرچند round-trip بیشتری دارد. Lazy برای روابطی که اغلب استفاده نمی‌شوند می‌تواند قابل قبول باشد. فهرست نامحدود را eager نکنید. خواندن دو query در isolation معمول ممکن است تغییر هم‌زمان را ببیند؛ اگر snapshot ثابت لازم است، تراکنش/isolation متناسب را طراحی کنید.

## مثال حل‌شده

طرح فرضی: `orders(id, customer_id)` و `customers(id, name)`. فهرست فقط شناسه سفارش و نام مشتری می‌خواهد. دریافت ۲۰ والد و نام مشتری‌های یکتا به صورت batch:

<div dir="ltr" align="left">

```sql
SELECT id, customer_id FROM orders ORDER BY id DESC LIMIT 20;
-- Application collects DISTINCT customer_id values, e.g. 7, 9, 12.
SELECT id, name FROM customers WHERE id IN (7, 9, 12);
-- Map customer_id -> name, then build response.
```

</div>

در اجرا، مقادیر را bind کنید؛ فهرست را با الحاق متن SQL نسازید. شمار query معمولاً دو است، اما اگر حد پارامتر مجبور به chunk کند بیشتر می‌شود. برای نیاز فوق یک join نیز نامزد مقایسه است؛ «دو» هدف عمومی نیست.

## تمرین و مشاهده مورد انتظار

۲۰ سفارش با مشتری‌های مشترک بسازید. نسخه lazy، join و batch را روی یک خروجی یکسان مقایسه کنید: query count، rows returned، bytes و زمان. سپس دو collection به هر سفارش اضافه کنید و دوباره بسنجید. انتظار: lazy می‌تواند رشد خطی round-trip نشان دهد؛ join چند collection می‌تواند ردیف‌های تکراری بسازد؛ batch رشد حاصل‌ضرب collectionها را کم می‌کند. اعداد به ORM و داده وابسته‌اند.

## شاهد عمومی و حد شواهد

[راهنمای رسمی SQLAlchemy](https://docs.sqlalchemy.org/en/20/orm/queryguide/relationships.html) شاهد فنی روش‌های loading است؛ این درس نتیجه تولیدی یک شرکت یا درصد بهبود مستند ندارد. مثال فروشگاه فرضی است. انتخاب باید از SQL تولیدشده و اندازه پاسخ اثبات شود، نه نام راهبرد.

## شکست‌ها، سیگنال‌ها و چک‌لیست

serializer، template و logging می‌توانند رابطه lazy را ناخواسته باز کنند. join روی مجموعه‌ها pagination والد را تغییر می‌دهد، مگر ORM بازنویسی درست انجام دهد. بسته‌شدن session پیش از lazy نیز خطا می‌دهد. افزایش query count متناسب تعداد والد، سیگنال N+1 است.

- [ ] تعداد SQL و SQL تولیدشده برای یک درخواست نماینده ثبت شده است.
- [ ] collectionها محدود و حجم نتیجه اندازه‌گیری شده است.
- [ ] join، batch و lazy با خروجی و semantics یکسان مقایسه شده‌اند.
- [ ] محدودیت IN، chunk و parameter binding رعایت می‌شود.
- [ ] قرارداد snapshot و رفتار هنگام بسته‌شدن session روشن است.
- [ ] دسترسی ناخواسته به رابطه در serializer قابل مشاهده یا ممنوع شده است.

## پیش‌نیازها و انتخاب راهبرد دریافت

رابطه تک‌مقداری مثل سفارش به یک مشتری، حداکثر یک ردیف مرتبط می‌دهد؛ collection چند فرزند دارد. Round-trip رفت‌وبرگشت برنامه به دیتابیس است و identity map هویت شیء خوانده‌شده را در نشست ORM دوباره استفاده می‌کند. Lazy query را هنگام دسترسی اجرا می‌کند؛ serializer هم ممکن است آن دسترسی را پنهانی انجام دهد.

از endpoint شروع کنید: چند والد لازم است و کدام رابطه در پاسخ مصرف می‌شود؟ برای رابطه تک‌مقداری، join را با batch بسنجید. برای collectionها، ردیف/بایت تکراری join را کنار رفت‌وبرگشت batch بگذارید. حد پارامتر می‌تواند batch را به چند قطعه بشکند. اگر دو query باید یک snapshot ببینند، isolation تراکنش را هم انتخاب کنید.

### حل محاسبه مثال و تمرین

۲۰ سفارش و سه customer_id یکتا داریم. Lazy ساده می‌تواند ۱ query والدها و تا ۲۰ query مشتری بزند: ۲۱ round-trip. Batch ابتدا سفارش‌ها، سپس سه مشتری را می‌خواند: معمولاً ۲ query با سه شناسه ورودی. Joined loading برای رابطه تک‌مقداری می‌تواند همان ۲۰ ردیف را با نام مشتری برگرداند. اما دو collection با ۱۰ و ۵ فرزند برای یک والد ۱۰×۵=۵۰ ردیف ترکیبی می‌سازند. در تمرین شمار SQL، rows و bytes را برای خروجی یکسان ثبت کنید؛ اعداد واقعی به ORM و داده وابسته‌اند.

### مسیر عیب‌یابی

شمار SQL را حین query پایه و serialization جدا ثبت کنید. رشد query متناسب تعداد والدها نشانه N+1 است؛ query کم اما rows/bytes و حافظه زیاد می‌تواند از join چند collection باشد؛ خطای پس از بسته‌شدن session به lazy دیرهنگام اشاره می‌کند. روابط موردنیاز را محدود و سه راهبرد را با پارامتر یکسان بسنجید.

## جمع‌بندی

Lazy زمان خواندن را به لحظه دسترسی عقب می‌اندازد؛ joined و batch محل و شکل هزینه را عوض می‌کنند. تعداد query، اندازه نتیجه و snapshot را باهم بسنجید.

## خودآزمایی

۱. آیا Eager loading همیشه یک SQL است؟

۲. برای ۳۰ والد، query جدا روی هر فرزند چه الگویی می‌سازد؟

۳. چرا دو collection در یک join ممکن است بدتر باشند؟

۴. Batch چرا ممکن است بیش از دو query داشته باشد؟

۵. اگر شمار SQL کم شد ولی latency بالا رفت، چه می‌سنجید؟

### پاسخ‌نامه با دلیل

۱. خیر؛ پیش‌دریافت می‌تواند با join یا queryهای جدا انجام شود.

۲. معمولاً ۱+۳۰؛ رفتار cache/identity map را با ثبت SQL بررسی می‌کنیم.

۳. حاصل‌ضرب تعداد فرزندان، تکرار والد و هزینه انتقال/ساخت شیء ایجاد می‌کند.

۴. به علت chunk، حد پارامتر یا چند رابطه؛ سقف ثابت و جهانی وجود ندارد.

۵. rows، bytes، حافظه، plan و sort؛ حذف round-trip تنها یکی از عوامل است.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- انگلیسی: [SQLAlchemy Relationship Loading](https://docs.sqlalchemy.org/en/20/orm/queryguide/relationships.html)؛ مرجع روش‌ها در شاخه 2.0.
- فارسی: [بهینه‌سازی Django ORM و جلوگیری از N+1](https://mixins.ir/article/django-orm-query-optimization-performance/)؛ در نتیجه جستجوی عمومی، ارتباط موضوعی `select_related` و `prefetch_related` تأیید شد؛ بازکردن متن کامل در این بررسی timeout شد. بنابراین مبنای ادعای فنی این درس نیست.

- English, official: [EF Core efficient querying](https://learn.microsoft.com/en-us/ef/core/performance/efficient-querying) shows N+1, eager loading, projection, and limits of each approach.
- English, official: [EF Core single versus split queries](https://learn.microsoft.com/en-us/ef/core/querying/single-split-queries) explains duplicated rows, cartesian explosion, and round-trip trade-offs.
- English, official: [Django database optimization](https://docs.djangoproject.com/en/stable/topics/db/optimization/) distinguishes select_related and prefetch_related by relationship shape.
- English, official: [SQLAlchemy relationship loading](https://docs.sqlalchemy.org/en/20/orm/queryguide/relationships.html) documents joined, select-in, and lazy strategies for SQLAlchemy 2.0.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: ایندکس](../02-indexes/README.md) · [بعدی: Pagination](../04-efficient-database-pagination/README.md) · [Join](../07-join-optimization/README.md)

</div>


