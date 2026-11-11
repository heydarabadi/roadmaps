# CRUD و نوشتن گروهی

> **English edition:** [Read this lesson in English](../../en/02-operations/crud/readme.md).

> **هدف یادگیری:** insert، find، update و delete را با filter دقیق انجام دهید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## آموزش
عملیات CRUD شامل create، read، update و delete است. از insertOne/insertMany، find/findOne، updateOne/updateMany/replaceOne، deleteOne/deleteMany و bulkWrite استفاده می‌شود. Filter سندهای هدف را مشخص می‌کند و projection فیلدهای خروجی را محدود می‌سازد.

با $set و $inc بخشی از سند را تغییر دهید؛ replaceOne کل سند را جایگزین می‌کند. write روی یک سند اتمیک است، ولی updateMany روی کل collection تراکنش واحد نیست. bulkWrite چند عملیات را جمع می‌کند اما خودش transaction نیست. matchedCount و modifiedCount را بررسی کنید.

## تدریس کامل: چهار عمل پایه

CRUD را به عنوان قرارداد اصلی تعامل برنامه با داده یاد بگیرید. هر عملیات باید filter و نتیجهٔ قابل بررسی داشته باشد.

### درج

insertOne یک document می‌گیرد. insertMany چند document را می‌گیرد. اگر collection وجود نداشته باشد، نوشتن می‌تواند آن را بسازد. _id اگر تعیین نشده باشد ایجاد می‌شود. در bulk insert، ordered:true بعد از خطای یکی از سندها متوقف می‌شود؛ ordered:false می‌تواند بقیه را ادامه دهد و ترتیب را تضمین نمی‌کند.

### خواندن

find(filter, projection) cursor می‌سازد. filter مشخص می‌کند کدام سندها بازگردند. projection فیلدها را محدود می‌کند؛ _id پیش‌فرض در خروجی است. sort، skip و limit را برای ترتیب و تعداد خروجی تعریف کنید.

~~~javascript
db.products.find(
  { active: true, price: { $lt: NumberDecimal("30.00") } },
  { sku: 1, title: 1, price: 1, _id: 0 }
).sort({ price: 1 }).limit(10)
~~~

### تغییر

$set یک مقدار را قرار می‌دهد؛ $inc عدد را اتمیک بالا/پایین می‌برد؛ $unset field را حذف می‌کند. updateOne نخستین سند منطبق را می‌زند. updateMany همهٔ سندهای منطبق را می‌زند، اما کل عملیات روی مجموعه transaction اتمیک واحد نیست. replaceOne کل بدنهٔ سند را جایگزین می‌کند و اگر فیلدی را جا بگذارید آن فیلد حذف می‌شود.

نتیجه را بخوانید: matchedCount یعنی چند سند با filter match شدند؛ modifiedCount یعنی چند سند واقعاً تغییر کردند. matchedCount صفر می‌تواند به معنی race condition، شناسهٔ اشتباه یا status نامعتبر باشد.

### حذف

deleteOne و deleteMany بر اساس filter حذف می‌کنند. filter خالی در deleteMany تمام سندهای collection را حذف می‌کند. در برنامه‌های واقعی از soft delete، retention و مجوز مناسب استفاده کنید؛ حذف فیزیکی ممکن است بازگردانی‌پذیر نباشد.

### مثال کنترل موجودی

~~~javascript
const r = db.products.updateOne(
  { sku: "KB-01", stock: { $gte: 1 } },
  { $inc: { stock: -1 } }
)
if (r.matchedCount !== 1) {
  print("کالا موجود نیست یا موجودی تمام شده")
}
~~~

شرط موجودی و کاهش آن در همان write تک‌سندی قرار دارد؛ بین خواندن موجودی و کاهش آن فاصلهٔ جدا ایجاد نکرده‌ایم. برای چند سند یا ارتباط با پرداخت، invariantها را جدا طراحی کنید.

### روش حل مسئله

قبل از اجرا، با find همان filter را امتحان کنید. سپس تعداد هدف را تخمین بزنید. برای update/delete گسترده، backup و runbook داشته باشید. فرمان را در دیتابیس learning تمرین کنید؛ روی production به «یک خط سریع» اعتماد نکنید.

## مثال
~~~javascript
db.products.insertOne({ sku: "M-1", stock: 10 })
db.products.find({ stock: { $gt: 0 } }, { sku: 1, stock: 1, _id: 0 })
db.products.updateOne(
  { sku: "M-1", stock: { $gte: 1 } },
  { $inc: { stock: -1 } }
)
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
برای فروش آخرین کالا، شرط stock >= 1 را داخل filter update قرار دهید تا درخواست هم‌زمان نتواند موجودی منفی بسازد. تغییر چندسندی مثل پرداخت و سفارش نیازمند بررسی مرز transaction است.

## خطاهای رایج
- اشتباه گرفتن update operator با replacement.
- filter حذف عمومی یا خالی.
- نادیده‌گرفتن تعداد سندهای منطبق.
- فرض اتمیک‌بودن همهٔ bulk.

## تمرین
1. محصول فعال ارزان‌تر از 100 را با projection محدود پیدا کنید.
2. کاهش موجودی را مشروط به مثبت‌بودن stock بنویسید.

## آزمون و پاسخ
1. **پرسش:** insertMany چه می‌کند؟
   **پاسخ:** چند سند را در یک فراخوانی درج می‌کند.
2. **پرسش:** projection چیست؟
   **پاسخ:** محدودکردن فیلدهای خروجی.
3. **پرسش:** دامنهٔ اتمیک بودن write چیست؟
   **پاسخ:** یک سند.
4. **پرسش:** چرا باید از «اشتباه گرفتن update operator با replacement.» پرهیز کرد؟
   **پاسخ:** replacement کل سند را با سند جدید جایگزین می‌کند و fieldهای حذف‌شده از replacement از بین می‌روند؛ update با `$set` فقط fieldهای تعیین‌شده را تغییر می‌دهد. نوع operation را آگاهانه انتخاب کنید.
5. **مسئلهٔ کاربردی:** محصول فعال ارزان‌تر از 100 را با projection محدود پیدا کنید.
   **پاسخ نمونه:** برای فروش موجودی، filter را روی SKU و stock >= 1 بگذارید، با $inc یک واحد کم کنید و matchedCount را بررسی کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** updateOne با replaceOne چه تفاوتی دارد؟
   **پاسخ:** updateOne با operatorها می‌تواند fieldها را تغییر دهد؛ replaceOne کل سند را جایگزین می‌کند.
7. **پرسش:** matchedCount صفر یعنی چه؟
   **پاسخ:** هیچ سندی با filter match نشده است.
8. **پرسش:** $inc برای موجودی چه سودی دارد؟
   **پاسخ:** تغییر عدد را اتمیک روی سند انجام می‌دهد.
9. **پرسش:** چرا deleteMany با filter خالی خطرناک است؟
   **پاسخ:** تمام سندهای collection را حذف می‌کند.
10. **پرسش:** updateMany در کل collection اتمیک است؟
   **پاسخ:** خیر؛ اتمیک بودن پایه در سطح هر سند است.

## منابع فارسی
- [CRUD در MongoDB به فارسی](https://www.urhoba.net/fa/post/crud-mongodb)
- [دورهٔ فارسی CRUD](https://darsman.com/course/aggregation-operations-in-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [CRUD Operations](https://www.mongodb.com/docs/manual/crud/)
- [Update Operators](https://www.mongodb.com/docs/manual/reference/operator/update/)
- [Bulk Write](https://www.mongodb.com/docs/manual/core/bulk-write-operations/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#operations-crud) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
