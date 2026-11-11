<div dir="rtl" align="right">

# بهینه‌سازی Join با حفظ معنا

**زبان:** فارسی · [English version](../../../../en/backend-performance/04-databases/07-join-optimization/README.md)


**هدف یادگیری:** cardinality خروجی را پیش‌بینی کنید، هزینه Join را از شکل نوشتاری جدا کنید و در Query plan به تخمین، حلقه‌ها و spill توجه کنید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ SQL برای PostgreSQL و اجرا‌نشده است.

## مدل ذهنی

Join ترکیب ردیف‌ها بر اساس شرط است. ابتدا معنای رابطه را روشن کنید: یک‌به‌یک، یک‌به‌چند یا چندبه‌چند؟ سپس حجم ورودی و خروجی را تخمین بزنید. Nested loop، Hash join و Merge join انتخاب‌های اجرایی‌اند؛ نام الگوریتم به‌تنهایی خوب یا بد نیست. ورودی کوچک با lookup index می‌تواند Nested loop مناسبی بسازد؛ ورودی بزرگ با تخمین غلط ممکن است حلقه‌های پرهزینه ایجاد کند.

| مشاهده پلن | پرسش بعدی |
| --- | --- |
| actual rows بسیار بیشتر از estimate | آمار، skew و وابستگی ستون‌ها چطور است؟ |
| loops بسیار زیاد در lookup | آیا ورودی بیرونی بیش از انتظار بزرگ است؟ |
| temp read/write یا hash batches زیاد | حافظه یا حجم ورودی باعث spill شده است؟ |
| خروجی چندبرابر تعداد والد | آیا چندبه‌چند یا شرط ناقص داریم؟ |

Planner بسیاری از inner joinها را بازمرتب می‌کند؛ تغییر ترتیب متن SQL تضمین تغییر ترتیب اجرا نیست. outer join محدودیت معنایی دارد. [مستند PostgreSQL درباره explicit joins](https://www.postgresql.org/docs/current/explicit-joins.html) تفاوت ترتیب مجاز و کنترل planner را توضیح می‌دهد؛ تنظیم سراسری برای اجبار یک الگوریتم اولین اقدام نیست.

## کاربرد و مصالحه

Join برای ترکیب داده نزدیک به منبع مناسب است و می‌تواند round-tripهای متعدد را حذف کند. برای خروجی بسیار بزرگ یا رابطه چند collection، batch ممکن است کم‌حجم‌تر باشد. index روی کلید join نامزد مفیدی است ولی در خواندن سهم بزرگ جدول، hash/seq scan می‌تواند درست باشد. افزایش حافظه هر query با هم‌زمانی ضرب می‌شود؛ یک عدد بزرگ `work_mem` را درمان عمومی spill فرض نکنید.

## مثال حل‌شده

طرح فرضی `customers(id, name)` و `orders(id, customer_id, total, status)` است. همه مشتری‌ها، حتی بدون سفارش paid، باید نمایش داده شوند:

<div dir="ltr" align="left">

```sql
SELECT c.id, c.name, COALESCE(p.amount, 0) AS paid_amount
FROM customers AS c
LEFT JOIN (
    SELECT customer_id, SUM(total) AS amount
    FROM orders
    WHERE status = 'paid'
    GROUP BY customer_id
) AS p ON p.customer_id = c.id;
```

</div>

پیش‌تجمیع، orders را به یک ردیف در هر مشتری تبدیل می‌کند و از ضرب‌شدن aggregate با join بعدی جلوگیری می‌کند. این بازنویسی برای نیاز مشخص بالاست؛ اگر فقط چند مشتری خواسته شوند، aggregation همه orders شاید گران‌تر شود. predicate روی سمت راست LEFT JOIN در WHERE می‌تواند ردیف NULL را حذف و معنای نتیجه را عوض کند.

## تمرین و مشاهده مورد انتظار

دو مشتری بسازید؛ یکی دو سفارش paid و سه payment مرتبط داشته باشد، دیگری سفارش نداشته باشد. query خام با join هر دو collection و SUM را با پیش‌تجمیع هر رابطه مقایسه کنید. انتظار: join خام می‌تواند جمع را به علت تکرار ردیف‌ها باد کند؛ پیش‌تجمیع با سطح درست این خطا را برطرف می‌کند. سپس EXPLAIN بگیرید و rows/loops را با پیش‌بینی روی کاغذ مقایسه کنید؛ سرعت بیشتر بدون برابری نتیجه پذیرفته نیست.

## شاهد عمومی و حد شواهد

[مستند عملیاتی PostgreSQL درباره کنترل ترتیب Join](https://www.postgresql.org/docs/current/explicit-joins.html) نشان می‌دهد تعداد روابط و محدودیت معنایی بر فضای جستجوی planner اثر دارد. این شاهد رسمی است؛ مثال مشتری/پرداخت فرضی بوده و گزارش production یک شرکت محسوب نمی‌شود.

## شکست‌ها، سیگنال‌ها و چک‌لیست

شرط ناقص یا حذف tenant می‌تواند cardinality و حتی جداسازی داده را خراب کند. DISTINCT روی نتیجه بزرگ ممکن است نشانه پنهان‌کردن join نادرست باشد. cast ناسازگار، آمار کهنه، sort/spill و تخمین غلط را بررسی کنید؛ حذف Join بدون اثبات برابری پاسخ بهینه‌سازی نیست.

- [ ] cardinality و سطح aggregate هر رابطه مشخص است.
- [ ] inner/outer و محل predicate، نتیجه مورد نظر را حفظ می‌کنند.
- [ ] estimated/actual rows، loops، buffers و temp I/O بررسی شده‌اند.
- [ ] index و نوع داده کلیدهای join سازگارند.
- [ ] محدودیت tenant و کلید کامل رابطه در شرط وجود دارد.
- [ ] نتیجه پیش/پس و مصرف حافظه در هم‌زمانی مقایسه شده است.

## پیش‌نیازها و پیش‌بینی cardinality

Cardinality یعنی تعداد ردیف‌ها در هر سطح از join؛ یک‌به‌چند به هر والد چند فرزند می‌دهد و دو collection مستقل می‌توانند خروجی ضربی بسازند. ابتدا grain نتیجه را بنویسید: هر ردیف باید نماینده مشتری، سفارش یا جفت سفارش/پرداخت باشد؟ سپس کلید join و outer/inner semantics را تعیین کنید. نوع الگوریتم فیزیکی پس از این معنا و آمار توسط planner انتخاب می‌شود.

### حل عددی تمرین Join

یک مشتری دو سفارش با totalهای ۱۰۰ و ۵۰، و سه ردیف در collection پرداخت‌های همان مشتری دارد. اگر دو collection فقط با customer_id کنار هم join شوند، ۲×۳ = ۶ ردیف ساخته می‌شود؛ هر سفارش در سه ردیف تکرار می‌شود و SUM(order.total) = ۳×۱۰۰ + ۳×۵۰ = ۴۵۰، در حالی که جمع واقعی سفارش‌ها ۱۵۰ است. اگر پرداخت به order وصل است، کلید رابطه باید order_id باشد؛ معنا را قبل از حساب بررسی کنید. پیش‌تجمیع سفارش و پرداخت هرکدام را تا یک ردیف در grain درست کاهش می‌دهد، بعد join مبلغ را تکرار نمی‌کند.

### حل تمرین و مسیر عیب‌یابی پلن

برای مشتری با دو سفارش paid و چند پرداخت، اول ردیف‌های خام و کلیدهای اتصال را بشمارید؛ سپس جمع واقعی را از جدول سفارش به‌تنهایی حساب و با join خام مقایسه کنید. اگر جمع باد کرده، تعداد تکرار هر سفارش را پیدا و هر collection را تا یک ردیف در grain درست تجمیع کنید. مشتری بدون سفارش با LEFT JOIN باقی می‌ماند؛ predicate جدول سمت راست را در WHERE قرار ندهید اگر باید مشتری حفظ شود. برای plan، actual rows را با estimate مقایسه کنید؛ mismatch را به آمار/skew پیگیری کنید، loops زیاد را در ورودی بیرونی ضرب کنید و temp read/write را به spill ربط دهید. DISTINCT خطای رابطه را پنهان نکند.

## جمع‌بندی

Join رفت‌وبرگشت را کم می‌کند، اما خروجی از کلیدها و cardinality پیروی می‌کند. ابتدا صحت نتیجه و سپس هزینه plan را بهینه کنید.

## خودآزمایی

۱. آیا Nested loop همیشه بد است؟

۲. چرا join دو collection می‌تواند SUM را خراب کند؟

۳. predicate سمت راست LEFT JOIN در WHERE چه خطری دارد؟

۴. چرا تغییر ترتیب متن inner join تضمین پلن جدید نیست؟

۵. پیش از افزایش زیاد حافظه query چه می‌سنجید؟

### پاسخ‌نامه با دلیل

۱. خیر؛ ورودی کوچک و lookup مؤثر می‌تواند آن را ارزان کند.

۲. ردیف‌ها در ترکیب چندبه‌چند تکرار می‌شوند و aggregate همان تکرار را جمع می‌زند.

۳. ردیف‌های بدون تطبیق NULL را حذف می‌کند و می‌تواند معنای outer join را عوض کند.

۴. Planner مجاز است joinهای هم‌ارز را بازمرتب کند؛ متن، ترتیب فیزیکی قطعی نیست.

۵. حجم واقعی، skew، آمار، spill و تعداد queryهای هم‌زمان؛ حافظه هر عملگر/نشست می‌تواند جمع شود.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- انگلیسی: [PostgreSQL explicit JOIN clauses](https://www.postgresql.org/docs/current/explicit-joins.html)؛ حدود کنترل ترتیب و تفاوت outer join.
- انگلیسی تکمیلی: [Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)؛ خواندن plan tree و loops.
- فارسی: [شکستن افسانه «فیلتر زودتر، JOIN دیرتر» — نسخه PDF](https://www.dntips.ir/exports/news/www.dntips.ir-news-20517.pdf)؛ برای تفکیک ترتیب نوشتن query از تصمیم optimizer. متن نمایه‌شده در جستجوی عمومی بررسی شد؛ بازکردن مستقیم PDF در ابزار پژوهش ممکن نشد. مبنای رفتار PostgreSQL در این درس مستند رسمی است، نه عدد benchmark مقاله.

- English, official: [PostgreSQL Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html) explains rows, loops, costs, and interpreting plan nodes.
- English, official: [MySQL EXPLAIN](https://dev.mysql.com/doc/refman/8.4/en/explain.html) documents plan inspection in MySQL; its operators and plans are engine-specific.
- English, official: [Microsoft SQL Server joins](https://learn.microsoft.com/en-us/sql/relational-databases/performance/joins?view=sql-server-ver17) explains nested loops, merge, and hash joins for SQL Server.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Denormalization](../06-denormalization-for-read-heavy-workloads/README.md) · [بعدی: نگهداری](../08-database-maintenance/README.md) · [ORM](../03-orm-fetch-strategies/README.md)

</div>


