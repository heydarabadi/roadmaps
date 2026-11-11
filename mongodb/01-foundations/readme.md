# فصل ۱ — مبانی MongoDB

> **نسخهٔ انگلیسی:** [English edition](../en/01-foundations/readme.md).

مدل سندی، BSON و ابزارهای شروع.

## درس‌ها

- [MongoDB چیست و چه وقت انتخاب مناسبی است؟](./what-is-mongodb/readme.md) — مدل سندی را توضیح دهید و انتخاب MongoDB را با نیاز واقعی بسنجید.
- [سند، BSON و انواع داده](./bson-documents/readme.md) — تفاوت JSON و BSON و محدودیت‌های سند را بشناسید.
- [Atlas، نصب و محیط کاری](./atlas-tools/readme.md) — سرور، mongosh، Compass، driver و Atlas را از هم جدا کنید.

## روش مطالعه
1. آموزش را بخوانید و مثال را روی محیط آزمایشی اجرا کنید.
2. تمرین را پیش از دیدن پاسخ انجام دهید.
3. برای production مستندات همان نسخه و تست کنترل‌شده را مبنا بگذارید.


## تدریس فصل: از یک درخواست تا یک سند

### هدف فصل

در پایان باید بتوانید مفاهیم server/database/collection/document را از هم تفکیک کنید، نوع مناسب BSON را انتخاب کنید، به محیط آزمایشی وصل شوید و یک سند امن بسازید. این فصل پیش‌نیاز بقیهٔ مسیر است.

### مدل ذهنی

برنامه از driver، فرمانی مثل find یا update می‌فرستد. server از نام database و collection محل داده را می‌یابد، filter و option را تفسیر می‌کند، در صورت نیاز index را به کار می‌گیرد، سند را می‌خواند یا تغییر می‌دهد و نتیجه را بازمی‌گرداند. BSON دادهٔ انتقالی/ذخیره‌ای است؛ JSON قالبی است که معمولاً در API و مثال می‌بینید.

### دست‌ورزی پایه

~~~javascript
use learning

db.products.insertMany([
  { sku: "KB-01", title: "صفحه‌کلید", price: NumberDecimal("45.00"), active: true },
  { sku: "MS-01", title: "ماوس", price: NumberDecimal("18.50"), active: true }
])

db.products.find({ active: true })
db.products.find({ price: { $lt: NumberDecimal("30.00") } })
~~~

در query دوم قیمت‌ها با Decimal128 هستند؛ اگر داده‌ها بعضی string و بعضی number باشند، رفتار یکسان نخواهد بود. پس نوع داده را هنگام درج استاندارد کنید.

### چه چیزی را از این فصل نباید نتیجه گرفت؟

NoSQL به معنی بی‌نیازی از schema نیست. Atlas به معنی امنیت خودکار بدون تنظیم نیست. Compass به معنی داشتن server نیست. ObjectId شمارهٔ مشتری نیست. انعطاف در داده به معنی انتخاب بدون طراحی نیست.

### خروجی فصل

یک database آزمایشی learning بسازید، دو collection products و orders تعریف کنید، سه سند درج کنید، نوع fieldها را ثبت کنید و connection string را در فایل عمومی قرار ندهید. سپس درس‌های CRUD و query را ادامه دهید.
