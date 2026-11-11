# Cursor، شمارش و Read/Write Concern

> **English edition:** [Read this lesson in English](../../../../en/mongodb/02-operations/cursor-count-concerns/README.md).

> **هدف یادگیری:** cursor، شمارش و سطوح consistency را جداگانه بفهمید.

## آموزش
find() یک cursor برمی‌گرداند و نتیجه را می‌توان batchای مصرف کرد؛ در driver همهٔ سندها را بی‌حد در حافظه جمع نکنید. countDocuments(filter) شمارش دقیق بر اساس فیلتر است؛ estimatedDocumentCount برآورد کل collection از metadata است و جای شمارش دقیق یک query را نمی‌گیرد.

Write concern سطح تأیید write را تعیین می‌کند، read concern سطح دید/سازگاری داده را، و read preference انتخاب عضو خواندن را. retryable writes و reads بعضی خطاهای گذرا را مدیریت می‌کنند، اما دقیقاً یک‌بار انجام‌شدن منطق برنامه را تضمین نمی‌کنند. برای صفحه‌بندی بزرگ، keyset pagination را به skipهای عمیق ترجیح دهید.

## تدریس کامل: cursor، count و consistency

### Cursor چگونه مصرف می‌شود؟

find نتیجه را به صورت cursor می‌دهد. Server سندها را در batch می‌فرستد؛ driver می‌تواند با مصرف تدریجی از جمع‌کردن کل مجموعه در حافظه جلوگیری کند. در برنامه cursor را تا پایان مصرف یا تا وقتی دیگر لازم نیست باز نگه ندارید. limit نتیجه و projection را مشخص کنید.

### Pagination

skip(offset) ساده است؛ اما هرچه offset بزرگ‌تر شود، server باید سندهای قبلی را رد کند. اگر feed با دادهٔ زیاد دارید، sort پایدار روی (createdAt, _id) بگذارید. صفحهٔ بعد باید سندهایی را بگیرد که کلیدشان بعد از آخرین سند صفحهٔ قبل قرار دارد. کلید tie-breaker مثل _id از ابهام زمان‌های برابر جلوگیری می‌کند.

### شمارش

countDocuments(filter) شمارش مطابق filter را به دست می‌دهد. estimatedDocumentCount برای تخمین کل collection سریع‌تر است و query دلخواه نمی‌گیرد. اگر count در لحظه لازم نیست، cache یا شمارش غیرهمزمان را بررسی کنید؛ اگر عدد حقوقی/مالی لازم است، روش دقیق و consistency را تعریف کنید.

### سه تنظیم جدا

- read preference: از primary یا secondary بخوانم؟
- read concern: چه سطحی از داده را قابل مشاهده بدانم؟
- write concern: چه میزان تأیید برای write لازم است؟

این گزینه‌ها trade-off consistency، latency و availability دارند. خواندن از secondary می‌تواند دادهٔ عقب‌مانده بدهد. w:majority معمولاً تأیید اکثریت عضوهای replica set را می‌خواهد، اما تضمین دقیق به topology و تنظیمات وابسته است.

### Retry

Driver بعضی read/writeها را در خطاهای گذرا retry می‌کند. این قابلیت همهٔ عملیات را پوشش نمی‌دهد و عملیات کسب‌وکار را exactly-once نمی‌کند. برای پرداخت، پیام یا انتقال وجه idempotency key و بررسی نتیجه لازم است.

## مثال
~~~javascript
db.orders.countDocuments({ status: "open" })
db.orders.estimatedDocumentCount()
db.orders.find({ customerId: "C-7" })
  .sort({ createdAt: -1, _id: -1 }).limit(50)
~~~

## سناریوی عملی
برای نمایش badge شمارش تقریبی ممکن است کافی باشد؛ برای گزارش مالی باید شمارش دقیق و consistency مورد نیاز تعریف شود. رفتار stale read روی secondary را نیز در UX و business rule لحاظ کنید.

## خطاهای رایج
- یکی گرفتن read preference با read concern.
- استفاده از estimated count به‌عنوان نتیجهٔ دقیق فیلتر.
- skip عمیق در مجموعهٔ بزرگ.
- فرض exactly-once از retry.

## تمرین
1. برای صفحهٔ بعدی keyset filter بسازید.
2. برای فهرست محصول و تأیید پرداخت concern مناسب پیشنهاد دهید.

## آزمون و پاسخ
1. **پرسش:** find چه می‌دهد؟
   **پاسخ:** Cursor قابل پیمایش.
2. **پرسش:** countDocuments و estimatedDocumentCount چه فرقی دارند؟
   **پاسخ:** اولی شمارش filterدار؛ دومی برآورد کل collection.
3. **پرسش:** write concern چیست؟
   **پاسخ:** سطح تأیید مورد انتظار برای write.
4. **پرسش:** چرا باید از «یکی گرفتن read preference با read concern.» پرهیز کرد؟
   **پاسخ:** read preference تعیین می‌کند درخواست خواندن به کدام عضو topology برود؛ read concern تعیین می‌کند چه سطحی از داده برای آن خواندن پذیرفته شود. مقصد خواندن و تضمین مشاهده دو تصمیم جدا هستند.
5. **مسئلهٔ کاربردی:** برای صفحهٔ بعدی keyset filter بسازید.
   **پاسخ نمونه:** برای exact count فیلترشده countDocuments را به کار ببرید؛ برای تعداد کل تقریبی estimatedDocumentCount. صفحهٔ بعد را با شرط روی آخرین createdAt و _id بسازید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** estimatedDocumentCount چه می‌شمارد؟
   **پاسخ:** تخمین تعداد کل collection، نه filter دلخواه.
7. **پرسش:** کدام تنظیم عضو read را انتخاب می‌کند؟
   **پاسخ:** read preference.
8. **پرسش:** کدام تنظیم سطح تأیید write را کنترل می‌کند؟
   **پاسخ:** write concern.
9. **پرسش:** چرا skip عمیق گران می‌شود؟
   **پاسخ:** نتایج قبلی باید رد شوند تا offset بزرگ طی شود.
10. **پرسش:** Retryable write exactly-once است؟
   **پاسخ:** خیر؛ منطق business باید idempotent باشد.

## منابع فارسی
- [Cursor و count در مفاهیم پایه فارسی](https://www.urhoba.net/fa/post/mongodb-11)
- [راهنمای شروع mongosh](https://www.urhoba.net/fa/post/mongodb-3)

> منابع فارسی ممکن است از نسخهٔ جاری عقب باشند؛ جزئیات را با مستندات رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Cursors](https://www.mongodb.com/docs/manual/core/cursors/)
- [Read Concern](https://www.mongodb.com/docs/manual/reference/read-concern/)
- [Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)
- [Retryable Reads and Writes](https://www.mongodb.com/docs/manual/core/retryable-reads/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#operations-concerns) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
