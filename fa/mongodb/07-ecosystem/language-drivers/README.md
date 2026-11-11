# Language Drivers و Connection Pool

> **English edition:** [Read this lesson in English](../../../../en/mongodb/07-ecosystem/language-drivers/README.md).

> **هدف یادگیری:** driver رسمی را استفاده و connection lifecycle را امن مدیریت کنید.

## تدریس کامل: driver در application

mongosh برای تعامل و عملیات انسانی است؛ driver بخشی از برنامه است و connection pooling، BSON encoding، command execution و error handling را فراهم می‌کند. از driver رسمی برای زبان و نسخهٔ خود استفاده کنید. Syntax برنامه با shell مشابه است اما APIها و async behavior یکسان نیستند.

### Lifecycle

در startup برنامه معمولاً یک MongoClient ساخته و به آن connect می‌شود. Client pool دارد و بین requestها reuse می‌شود. در shutdown graceful client بسته می‌شود. Client جدید به ازای هر request connection storm می‌سازد. maxPoolSize، serverSelectionTimeout و socketTimeout را بدون اندازه‌گیری تصادفی تغییر ندهید.

### Type mapping

ObjectId، Date، Decimal128، Binary و null/missing ممکن است در زبان برنامه representation متفاوت داشته باشند. در DTO/serializer این تفاوت‌ها را شفاف کنید. مبلغ را به double عادی تبدیل نکنید اگر دقت اعشاری مهم است.

### خطاها و retry

duplicate key، validation error، timeout، network error و transient transaction error معنی یکسان ندارند. برای هرکدام تصمیم بگیرید retry مجاز است، خطای کاربر است یا نیاز به alert دارد. Retry بعد از timeout ممکن است نتیجهٔ write نامعلوم باشد؛ idempotency key و query وضعیت را در business layer طراحی کنید.

### پیکربندی امن

URI از secret manager بیاید. log اتصال نباید password نشان دهد. TLS را verify کنید. health check از client موجود استفاده کند و database availability را از readiness/liveness جدا تعریف کنید.

## آموزش
Driver رسمی API برنامه و تبدیل typeهای BSON را فراهم می‌کند؛ mongosh جایگزین driver نیست. از یک MongoClient/pool در lifecycle سرویس reuse استفاده کنید، نه client جدید برای هر request. max pool، timeout، retry، credential، type mapping و graceful shutdown را با بار و framework تنظیم کنید.

خطای duplicate key، validation، network و transient transaction را از هم تشخیص دهید. health check نباید بی‌جهت pool تازه بسازد. نسخه و compatibility driver را با server بررسی کنید.

## مثال
~~~javascript
const client = new MongoClient(process.env.MONGODB_URI)
await client.connect()
const orders = client.db("shop").collection("orders")
const order = await orders.findOne({ _id: orderId })
~~~

## سناریوی عملی
ساختن connection client در هر HTTP request تعداد socketها را زیاد می‌کند. pool مشترک process، سقف اتصال و shutdown را در load test بسنجید.

## خطاهای رایج
- client تازه برای هر درخواست.
- URI در source یا log.
- نادیده‌گرفتن Decimal128/ObjectId mapping.
- نبستن pool در shutdown.

## تمرین
1. lifecycle اتصال و health check را رسم کنید.
2. برای network error و duplicate key رفتار جدا تعریف کنید.

## آزمون و پاسخ
1. **پرسش:** driver چیست؟
   **پاسخ:** کتابخانهٔ اتصال برنامه به MongoDB.
2. **پرسش:** چرا pool reuse می‌کنیم؟
   **پاسخ:** برای کاهش اتصال‌سازی و reuse اتصال‌های موجود.
3. **پرسش:** mongosh جایگزین driver است؟
   **پاسخ:** خیر؛ shell ابزار تعامل/مدیریت است.
4. **پرسش:** چرا باید از «client تازه برای هر درخواست.» پرهیز کرد؟
   **پاسخ:** client جدید برای هر درخواست connection storm می‌سازد؛ pool را در lifecycle سرویس reuse کنید.
5. **مسئلهٔ کاربردی:** lifecycle اتصال و health check را رسم کنید.
   **پاسخ نمونه:** client را در startup بسازید و reuse کنید؛ برای shutdown آن را ببندید و برای network و duplicate key رفتارهای خطای جدا بنویسید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** MongoClient را کجا می‌سازیم؟
   **پاسخ:** معمولاً یک بار در lifecycle سرویس.
7. **پرسش:** Pool چیست؟
   **پاسخ:** مجموعهٔ اتصال‌های قابل reuse.
8. **پرسش:** چرا ObjectId type mapping مهم است؟
   **پاسخ:** در زبان برنامه نوع driver ممکن است string نباشد و باید درست serialize شود.
9. **پرسش:** چرا client در shutdown بسته می‌شود؟
   **پاسخ:** تا اتصال و resource آزاد شود.
10. **پرسش:** Timeout چه زمانی باید تنظیم شود؟
   **پاسخ:** بر اساس latency و SLO، با مدیریت خطا و retry مشخص.

## منابع فارسی
- [MongoDB با Node.js به فارسی](https://www.urhoba.net/fa/post/node-js-mongodb)
- [شروع کار فارسی](https://www.urhoba.net/fa/post/mongodb-3)

> منابع فارسی ممکن است از نسخهٔ جاری عقب باشند؛ جزئیات را با مستندات رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [MongoDB Drivers](https://www.mongodb.com/docs/drivers/)
- [Node.js Driver](https://www.mongodb.com/docs/drivers/node/current/)
- [Connection Pools](https://www.mongodb.com/docs/drivers/node/current/connect/connection-options/connection-pools/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#ecosystem-drivers) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
