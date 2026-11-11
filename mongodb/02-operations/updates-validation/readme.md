# Update، آرایه، bulkWrite و validate

> **English edition:** [Read this lesson in English](../../en/02-operations/updates-validation/readme.md).

> **هدف یادگیری:** عملگرهای تغییر، upsert و اعتبارسنجی را درست تفکیک کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## آموزش
$set، $unset، $inc، $push، $addToSet و $pull از operatorهای رایج‌اند. positional operatorها عضو آرایه را با filter هدف می‌گیرند. upsert در نبود سند، سند جدید می‌سازد؛ filter و update آن را بررسی کنید.

bulkWrite عملیات را گروه می‌کند. ordered:false پس از خطای یک مورد اجازهٔ ادامه می‌دهد، اما ترتیب کل عملیات تضمین نیست. bulkWrite خودبه‌خود transaction نیست. schema validation شکل داده را enforce می‌کند؛ فرمان validate() برای بررسی collection و شاخص‌هاست و معادل قواعد business نیست.

## تدریس کامل: operatorهای update و نوشتن دسته‌ای

### خانواده‌های اصلی update

- $set: تعیین مقدار.
- $unset: حذف field.
- $inc: افزایش یا کاهش عدد.
- $min و $max: مقدار را فقط در صورت کوچک‌تر/بزرگ‌تر بودن تغییر می‌دهند.
- $rename: تغییر نام field.
- $push و $addToSet: افزودن به آرایه؛ دومی از مقدار تکراری برابر جلوگیری می‌کند.
- $pull: حذف عضوهایی که با شرط match می‌شوند.
- $pop: حذف عضو اول یا آخر.
- $currentDate: ثبت زمان جاری server.

### Upsert

upsert:true زمانی که filter سندی پیدا نمی‌کند، سند جدید می‌سازد. برای updateهای تکرارشونده معمولاً filter یکتا لازم است تا retry سند تکراری ایجاد نکند. هنگام استفاده از $setOnInsert، fieldهایی را تعیین کنید که فقط در ایجاد اولیه نوشته می‌شوند.

### آرایه و arrayFilters

برای تغییر تمام اعضای مطابق شرط می‌توان از arrayFilters استفاده کرد. شرط را دقیق آزمایش کنید؛ update بدون شرط محدود ممکن است عضوهای بیشتری از قصد شما تغییر دهد.

~~~javascript
db.orders.updateOne(
  { _id: orderId },
  { $set: { "items.$[line].status": "packed" } },
  { arrayFilters: [{ "line.sku": "KB-01" }] }
)
~~~

### Bulk write

bulkWrite ترکیبی از insertOne/updateOne/deleteOne و موارد مشابه را در یک round trip گروه می‌کند. حجم batch را محدود کنید. ordered:false اجازهٔ ادامه پس از بعضی خطاها می‌دهد؛ همهٔ عملیات یک transaction نیستند و ترتیب business را تضمین نکنید. نتیجه و writeErrors را بخوانید.

### Validation

Collection validator می‌تواند سند بدشکل را رد کند. validate() برای بررسی سلامت/ساختار داخلی collection است؛ این دو هدف متفاوت دارند. Validator را بعد از بررسی دادهٔ موجود و سازگاری نسخه‌های برنامه سخت‌گیرانه کنید.

### Safe update protocol

1. database و collection را چاپ/بررسی کنید.
2. filter را با find آزمایش کنید.
3. تعداد سندهای هدف را محاسبه کنید.
4. مقدار قبل و بعد را در محیط تمرینی مقایسه کنید.
5. matched/modified/deleted count و خطاها را ثبت کنید.
6. برای عملیات برگشت‌ناپذیر backup و طرح بازگشت داشته باشید.

## مثال
~~~javascript
db.orders.updateOne(
  { _id: orderId, status: "draft" },
  { $set: { status: "submitted" }, $addToSet: { tags: "priority" } }
)
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
در import دسته‌ای، batch محدود، کلید یکتا، قابلیت اجرای مجدد و گزارش خطای هر سند تعریف کنید. batch نامحدود می‌تواند timeout، فشار حافظه یا replication lag بسازد.

## خطاهای رایج
- upsert ناخواسته.
- فرض اتمیک بودن کل bulk.
- نادیده‌گرفتن خطاهای duplicate key.
- اشتباه گرفتن validate() با schema validation.

## تمرین
1. تگی بدون تکرار به سند اضافه کنید.
2. طرح import امن با batch و گزارش خطا بنویسید.

## آزمون و پاسخ
1. **پرسش:** $inc چیست؟
   **پاسخ:** افزایش/کاهش اتمیک مقدار عددی.
2. **پرسش:** $push با $addToSet چه تفاوتی دارد؟
   **پاسخ:** $push همواره اضافه می‌کند؛ $addToSet از تکرار برابر جلوگیری می‌کند.
3. **پرسش:** ordered:false چه می‌کند؟
   **پاسخ:** عملیات بعدی می‌تواند بعد از خطا ادامه یابد.
4. **پرسش:** چرا باید از «upsert ناخواسته.» پرهیز کرد؟
   **پاسخ:** وقتی هیچ سندی با filter پیدا نشود، upsert سند تازه می‌سازد. اگر filter اشتباه یا ناقص باشد، ممکن است به‌جای تغییر سند موردنظر یک سند ناخواسته اضافه شود؛ filter و کلید یکتا را قبل از فعال‌کردن upsert بررسی کنید.
5. **مسئلهٔ کاربردی:** تگی بدون تکرار به سند اضافه کنید.
   **پاسخ نمونه:** برای تگ از $addToSet استفاده کنید؛ bulkWrite را در batch با کلیدهای یکتا اجرا کنید و خطای هر operation و ordered mode را بررسی کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** $addToSet با $push چه فرقی دارد؟
   **پاسخ:** $addToSet از افزودن مقدار تکراری برابر جلوگیری می‌کند؛ $push تکرار را می‌پذیرد.
7. **پرسش:** upsert چه وقت سند می‌سازد؟
   **پاسخ:** وقتی گزینه فعال است و filter سندی پیدا نکرده.
8. **پرسش:** ordered:false چه پیامدی دارد؟
   **پاسخ:** ادامهٔ batch پس از خطا ممکن می‌شود، اما ترتیب کلی تضمین نمی‌شود.
9. **پرسش:** bulkWrite transaction است؟
   **پاسخ:** خیر؛ فقط چند operation را گروه می‌کند.
10. **پرسش:** validate() با schema validator یکی است؟
   **پاسخ:** خیر؛ یکی ساختار داخلی را می‌سنجد و دیگری شکل مجاز سند را هنگام write کنترل می‌کند.

## منابع فارسی
- [Update و آرایه در MongoDB](https://www.urhoba.net/fa/post/mongodb-4)
- [CRUD فارسی](https://www.urhoba.net/fa/post/crud-mongodb)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Update Documents](https://www.mongodb.com/docs/manual/tutorial/update-documents/)
- [Bulk Write](https://www.mongodb.com/docs/manual/core/bulk-write-operations/)
- [Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#operations-crud) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
