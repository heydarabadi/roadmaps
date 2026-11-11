# Schema Validation و versioning

> **English edition:** [Read this lesson in English](../../en/03-modeling/schema-validation/readme.md).

> **هدف یادگیری:** اعتبارسنجی شکل سند را اعمال و تغییر schema را مرحله‌بندی کنید.

## تدریس کامل: اعتبارسنجی و مهاجرت schema

### چرا validation داریم؟

MongoDB منعطف است، ولی برنامه ممکن است به قرارداد مشخص نیاز داشته باشد: order باید status و createdAt داشته باشد، total باید Decimal128 باشد و items باید آرایه باشد. Validator در سطح collection می‌تواند شرط‌های نوع و حضور را enforce کند؛ validation در برنامه همچنان باید ورودی را بررسی کند و پیام مناسب به کاربر بدهد.

### JSON Schema Validator

~~~javascript
db.createCollection("trainingOrders", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["status", "createdAt", "items"],
      properties: {
        status: { enum: ["open", "paid", "shipped", "cancelled"] },
        createdAt: { bsonType: "date" },
        total: { bsonType: "decimal" },
        items: { bsonType: "array" }
      }
    }
  },
  validationAction: "error"
})
~~~

قابلیت‌های دقیق JSON Schema را با مستندات نسخه بسنجید. برای شرط‌های وابسته یا business rule پیچیده، ممکن است validation برنامه مناسب‌تر باشد.

### reject یا warn

در rollout تدریجی، reject همهٔ سندهای نامعتبر ممکن است برنامهٔ قدیمی را بشکند. ابتدا داده را audit کنید، آمار شکل‌های متفاوت را جمع کنید، writerها را به‌روز کنید و در صورت نیاز مدتی هشدار ثبت کنید. بعد از پاک‌سازی، قانون reject را فعال کنید. bypass validation را مسیر عادی برنامه نکنید.

### تکامل با expand-migrate-contract

فرض کنید price از string به Decimal128 تغییر می‌کند:
1. **Expand:** reader موقتاً هر دو نوع را می‌فهمد.
2. **Deploy writer:** همهٔ نوشتن‌های جدید Decimal128 هستند.
3. **Migrate:** batchهای محدود و قابل‌تکرار سندهای قبلی را تبدیل می‌کنند.
4. **Measure:** شمار سندهای باقی‌مانده در شکل قدیم باید صفر یا توجیه‌شده باشد.
5. **Contract:** reader قدیمی و امکان نوشتن string حذف می‌شود؛ validator جدید فعال می‌شود.

این ترتیب rollback را ممکن‌تر می‌کند و انتشار برنامه را از migration داده جدا می‌سازد.

### validate() با validator یکی نیست

validator محدودیت سند هنگام write اعمال می‌کند. دستور validate() ساختار داخلی collection و indexها را بررسی می‌کند و ابزار تشخیص فساد/ناسازگاری است؛ آن را به عنوان validation فرم کاربر به کار نبرید.

## آموزش
Flexible schema یعنی سندها می‌توانند شکل‌های مختلف داشته باشند، نه اینکه کنترل ساختار لازم نباشد. validator در سطح collection با $jsonSchema می‌تواند fieldهای لازم، نوع BSON و nested structure را enforce کند. validationAction و validationLevel را آگاهانه انتخاب کنید.

قبل از تغییر validator دادهٔ موجود و writerهای قدیمی را بررسی کنید. مهاجرت را مرحله‌ای انجام دهید: readerهای سازگار، writer جدید، backfill batchای، شمارش باقی‌مانده و سپس حذف شکل قدیمی. schemaVersion می‌تواند نسخهٔ هر سند را مشخص کند. اعتبارسنجی DB مکمل validation برنامه است؛ همهٔ قواعد business را به JSON Schema نسپارید.

## مثال
~~~javascript
db.createCollection("users", {
  validator: { $jsonSchema: {
    bsonType: "object",
    required: ["email", "createdAt"],
    properties: {
      email: { bsonType: "string" },
      createdAt: { bsonType: "date" },
      schemaVersion: { bsonType: "int" }
    }
  }},
  validationAction: "error"
})
~~~

## سناریوی عملی
هنگام تبدیل price از string به Decimal128، ابتدا reader را با هر دو شکل سازگار کنید، سپس اسناد قدیمی را batchای تبدیل و شمارش کنید، بعد validator سخت‌گیرانه را فعال کنید. deploy و migration را یک جهش ناسازگار نکنید.

## خطاهای رایج
- سخت‌کردن validator پیش از بررسی دادهٔ جاری.
- نادیده‌گرفتن writer قدیمی.
- یکی گرفتن validator با قواعد business.
- استفادهٔ عادی از bypassDocumentValidation.

## تمرین
1. validator ساده برای سفارش بسازید که status و createdAt اجباری‌اند.
2. مهاجرت یک فیلد string به عدد دقیق را مرحله‌بندی کنید.

## آزمون و پاسخ
1. **پرسش:** validator در کجا اجرا می‌شود؟
   **پاسخ:** در سطح collection هنگام نوشتن سند.
2. **پرسش:** جایگزین validation برنامه است؟
   **پاسخ:** خیر؛ دو لایهٔ مکمل‌اند.
3. **پرسش:** schemaVersion چه کمکی می‌کند؟
   **پاسخ:** شکل‌های مختلف سند را در دورهٔ migration قابل تشخیص می‌کند.
4. **پرسش:** چرا باید از «سخت‌کردن validator پیش از بررسی دادهٔ جاری.» پرهیز کرد؟
   **پاسخ:** validator سخت‌گیرانه بدون بررسی اسناد قدیمی write را می‌شکند؛ داده و writerها را پیش از تغییر بررسی کنید.
5. **مسئلهٔ کاربردی:** validator ساده برای سفارش بسازید که status و createdAt اجباری‌اند.
   **پاسخ نمونه:** reader را سازگار کنید، writer جدید را منتشر کنید، اسناد قدیمی را batchای تبدیل و شمارش کنید، سپس validationAction:error را فعال کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** JSON Schema validator چه می‌کند؟
   **پاسخ:** نوع، required و بخش‌هایی از شکل سند را enforce می‌کند.
7. **پرسش:** چرا اول دادهٔ فعلی را بررسی می‌کنیم؟
   **پاسخ:** تا validator جدید writeهای معتبر قدیمی را ناگهان رد نکند.
8. **پرسش:** expand-migrate-contract چه ترتیبی دارد؟
   **پاسخ:** سازگاری reader، writer جدید، مهاجرت داده، حذف شکل قدیمی.
9. **پرسش:** schemaVersion برای چیست؟
   **پاسخ:** تشخیص و مهاجرت نسخه‌های مختلف document.
10. **پرسش:** بای‌پس validation مسیر دائمی است؟
   **پاسخ:** خیر؛ باید استثنای محدود و قابل‌حسابرسی باشد.

## منابع فارسی
- [مدل‌سازی و تکامل schema فارسی](https://www.urhoba.net/fa/post/mongodb-12)
- [مبانی MongoDB به فارسی](https://pars.host/blog/what-is-mongodb/)

> منابع فارسی ممکن است از نسخهٔ جاری عقب باشند؛ جزئیات را با مستندات رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/)
- [JSON Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/specify-json-schema/)
- [Schema Versioning Pattern](https://www.mongodb.com/docs/manual/data-modeling/design-patterns/data-versioning/schema-versioning/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#modeling-schema) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
