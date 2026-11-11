# Explain، Query Plan و بهینه‌سازی

> **English edition:** [Read this lesson in English](../../en/04-performance/query-performance/readme.md).

> **هدف یادگیری:** executionStats را بخوانید و گلوگاه query را تشخیص دهید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: خواندن explain plan

برای بررسی query از explain("executionStats") استفاده کنید. خروجی implementation جزئی دارد و بین نسخه‌ها تغییر می‌کند؛ مفاهیم مهم آن:
- winningPlan: plan انتخاب‌شده.
- COLLSCAN: بررسی اسناد collection.
- IXSCAN: پیمایش index.
- FETCH: خواندن document پس از استفاده از index.
- SORT: مرتب‌سازی‌ای که از ترتیب index به دست نیامده.
- nReturned: سندهای خروجی.
- totalDocsExamined: سندهای بررسی‌شده.
- totalKeysExamined: کلیدهای index بررسی‌شده.

### نسبت‌ها را تفسیر کنید

اگر 20 سند برمی‌گردد و هزاران سند بررسی می‌شود، query ممکن است غیرگزینشی باشد یا index مناسب نداشته باشد. اگر totalDocsExamined نزدیک nReturned باشد، خوب است اما کافی نیست؛ latency شبکه، رقابت، دیسک و حجم پاسخ نیز مهم‌اند. COLLSCAN در collection کوچک آموزشی الزاماً مشکل نیست؛ رفتار با رشد داده را هم بسنجید.

~~~javascript
db.orders.find(
  { customerId: "C-100", status: "paid" },
  { createdAt: 1, total: 1 }
).sort({ createdAt: -1 }).limit(20)
 .explain("executionStats")
~~~

### فرایند tuning

1. slow query و p95/p99 را ثبت کنید.
2. query shape و cardinality را بفهمید.
3. explain را روی دادهٔ نماینده بخوانید.
4. یک فرضیه بسازید: index، projection، pagination یا مدل.
5. یک تغییر انجام دهید و همان workload را دوباره بسنجید.
6. اثر روی write و منابع را هم بررسی کنید.

executionTimeMillis یک اجرای منفرد و کوچک benchmark نیست. hint می‌تواند برای آزمایش گزینه‌ها کمک کند، اما بهتر است دلیل query planner را بفهمید نه اینکه plan را کورکورانه ثابت کنید.

## آموزش
Query planner از filter، sort، projection و indexها plan انتخاب می‌کند. explain("executionStats") winningPlan، nReturned، totalDocsExamined و totalKeysExamined را نشان می‌دهد. COLLSCAN یعنی اسکن collection؛ IXSCAN یعنی index scan، اما IXSCAN به تنهایی اثبات query بهینه نیست.

نسبت اسناد بررسی‌شده به نتیجه، دادهٔ واقعی، sort و latency صدکی را بسنجید. یک executionTimeMillis روی دیتاست کوچک معیار production نیست. projection محدود، filter گزینشی، compound index و pagination مناسب را امتحان کنید. hint ابزار تشخیصی است؛ hardcode دائمی فقط با دلیل و پایش.

## مثال
~~~javascript
db.orders.find({ customerId: "C-7", status: "open" })
  .sort({ createdAt: -1 }).limit(20)
  .explain("executionStats")
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
اگر برای 20 نتیجه 200هزار سند بررسی شود، selectivity و index را بازبینی کنید. اگر plan مناسب ولی p99 بالا است، disk، pool، شبکه و concurrency نیز ممکن است دخیل باشند.

## خطاهای رایج
- نتیجه‌گیری از یک اجرای کوچک.
- فرض اینکه IXSCAN همیشه خوب است.
- ساخت index بدون سنجش write.
- پنهان‌کردن طراحی بد با hint.

## تمرین
1. تفاوت totalDocsExamined و nReturned را بنویسید.
2. برای examined زیاد سه راه اصلاح پیشنهاد دهید.

## آزمون و پاسخ
1. **پرسش:** COLLSCAN چیست؟
   **پاسخ:** بررسی کل collection.
2. **پرسش:** IXSCAN چه چیزی را ثابت می‌کند؟
   **پاسخ:** index scan شده، نه اینکه کل query ارزان باشد.
3. **پرسش:** چرا یک executionTime کافی نیست؟
   **پاسخ:** به cache، بار و اندازهٔ داده وابسته است.
4. **پرسش:** چرا باید از «نتیجه‌گیری از یک اجرای کوچک.» پرهیز کرد؟
   **پاسخ:** یک اجرای کوچک ممکن است cache گرم، دادهٔ کم یا توزیع غیرواقعی داشته باشد. روی داده و concurrency نماینده چند بار اندازه بگیرید و examined/returned، sort، و latency صدکی را مقایسه کنید.
5. **مسئلهٔ کاربردی:** تفاوت totalDocsExamined و nReturned را بنویسید.
   **پاسخ نمونه:** اگر docsExamined بسیار بزرگ‌تر از nReturned است filter/index را بهبود دهید، projection و pagination را محدود کنید و نتیجه را با دادهٔ نماینده اندازه بگیرید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** COLLSCAN یعنی چه؟
   **پاسخ:** بررسی اسناد collection برای یافتن نتیجه.
7. **پرسش:** IXSCAN به تنهایی نشانهٔ بهینگی است؟
   **پاسخ:** نه؛ باید تعداد key/doc بررسی‌شده و بقیهٔ stageها را هم دید.
8. **پرسش:** nReturned چیست؟
   **پاسخ:** تعداد سندهای خروجی query.
9. **پرسش:** چرا p99 را می‌سنجیم؟
   **پاسخ:** تا کندی tail که میانگین پنهان می‌کند دیده شود.
10. **پرسش:** hint راه‌حل دائمی است؟
   **پاسخ:** معمولاً ابزار تشخیصی است؛ pin دائمی نیاز به دلیل و پایش دارد.

## منابع فارسی
- [بهینه‌سازی query در راهنمای فارسی](https://www.urhoba.net/fa/post/mongodb-3)
- [کارایی MongoDB به فارسی](https://pars.host/blog/what-is-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Analyze Query Plan](https://www.mongodb.com/docs/manual/tutorial/analyze-query-plan/)
- [Query Plans](https://www.mongodb.com/docs/manual/core/query-plans/)
- [Query Optimization](https://www.mongodb.com/docs/manual/core/query-optimization/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#performance-indexes) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
