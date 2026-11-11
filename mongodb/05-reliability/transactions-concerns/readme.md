# Transaction، Atomicity و Read/Write Concern

> **English edition:** [Read this lesson in English](../../en/05-reliability/transactions-concerns/readme.md).

> **هدف یادگیری:** نیاز اتمیک‌بودن چندسندی را تشخیص دهید و concern را متناسب انتخاب کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: Concern و Retry

Write concern تعیین می‌کند server چه سطحی از تأیید را قبل از پاسخ به write بدهد. w:1 تأیید primary را می‌خواهد؛ w:majority تأیید اکثریت اعضای داده‌دار/رأی‌دهنده مطابق topology را هدف می‌گیرد. journal option و تنظیم کلاستر هم در دوام نهایی مؤثرند؛ نتیجه را فقط از نام option استنباط نکنید.

Read concern تعیین می‌کند چه داده‌ای قابل‌خواندن تلقی شود. local ممکن است داده‌ای را بدهد که بعداً rollback شود؛ majority دادهٔ commitشده به اکثریت را هدف دارد؛ snapshot برای سازگاری snapshot در transaction کاربرد دارد. Read preference جداست و primary/secondary انتخاب می‌کند.

### سناریوها

- نمایش فهرست محصول: ممکن است stale read قابل‌قبول باشد.
- نمایش موجودی حین checkout: stale read می‌تواند تصمیم فروش را خراب کند؛ write شرطی و consistency مناسب لازم است.
- گزارش مدیریتی: ممکن است lag یا snapshot مشخص پذیرفتنی باشد.
- پرداخت: outcome نامعلوم پس از قطع شبکه باید با idempotency و query وضعیت حل شود، نه retry کور.

### Retryable reads/writes

Driver ممکن است برخی operationهای واجدشرایط را یک بار در خطاهای شبکه یا انتخاب server دوباره امتحان کند. Retry همهٔ operationها را پوشش نمی‌دهد و تضمین exactly-once برای کسب‌وکار نیست. APIهایی مانند افزایش موجودی، ایجاد سفارش یا پرداخت باید idempotency key یا شناسهٔ یکتای درخواست داشته باشند.

### روش انتخاب

1. چه خطایی/از دست‌رفتن داده را باید تحمل کنیم؟
2. آیا stale read چه پیامدی دارد؟
3. چند عضو باید write را تأیید کنند؟
4. operation امن برای تکرار هست؟
5. timeout و retry با latency هدف سازگار است؟

تنظیم read/write concern را براساس رفتار مطلوب بنویسید، سپس با failover آزمایش کنترل‌شده و observability آن را بسنجید.

## آموزش
هر write روی یک سند اتمیک است. اگر invariant بین چند سند نیازمند all-or-nothing باشد، transaction چندسندی به کار می‌آید و در replica set یا sharded cluster پشتیبانی می‌شود. transaction کوتاه نگه داشته شود؛ callback در برخی خطاها retry می‌شود، پس تماس ایمیل، HTTP یا درگاه پرداخت را در آن قرار ندهید. idempotency و outbox را بررسی کنید.

Write concern سطح تأیید نوشتن را مشخص می‌کند؛ read concern سطح دید سازگار را؛ read preference انتخاب عضو را. Retryable writes بخشی از خطاهای گذرا را پوشش می‌دهد، اما معنای exactly-once کسب‌وکاری تضمین نمی‌کند.

## مثال
در نمونهٔ انتقال وجه باید نتیجهٔ هر دو `updateOne` بررسی شود: اگر حساب مبدأ/مقصد پیدا نشد یا موجودی کافی نبود، exception ایجاد کنید تا transaction abort شود. صرف اجرای دو فرمان در callback برای حفظ invariant کافی نیست.

## تجربهٔ واقعی یا سناریوی کاربردی
انتقال وجه دو حساب را با invariant مشترک تغییر می‌دهد؛ ولی سرویس بانک بیرونی rollback نمی‌شود. idempotency key، outbox و reconciliation مسیر بین سامانه‌ها را پوشش می‌دهند.

## خطاهای رایج
- transaction طولانی.
- تماس HTTP در callback قابل retry.
- فرض رایگان بودن transaction.
- یکی گرفتن read preference و read concern.

## تمرین
1. مرز تغییرات اتمیک ثبت سفارش را مشخص کنید.
2. برای side effect درگاه پرداخت، طرح idempotency پیشنهاد دهید.

## آزمون و پاسخ
1. **پرسش:** اتمیک بودن پایه چه سطحی دارد؟
   **پاسخ:** یک سند.
2. **پرسش:** transaction چه وقت لازم است؟
   **پاسخ:** وقتی چند write باید یک‌جا commit یا rollback شوند.
3. **پرسش:** read concern چه چیزی را تعیین می‌کند؟
   **پاسخ:** سطح consistency دادهٔ خوانده‌شده.
4. **پرسش:** چرا باید از «transaction طولانی.» پرهیز کرد؟
   **پاسخ:** transaction طولانی منابع و قفل/تعارض بیشتری نگه می‌دارد و احتمال timeout یا خطای cache را بالا می‌برد. فقط writeهای لازم برای invariant را در مرز transaction بگذارید؛ تماس سرویس بیرونی را بیرون نگه دارید.
5. **مسئلهٔ کاربردی:** مرز تغییرات اتمیک ثبت سفارش را مشخص کنید.
   **پاسخ نمونه:** تغییر چندسندی دیتابیس را در transaction کوتاه انجام دهید؛ پرداخت بیرونی را بیرون آن نگه دارید و idempotency key/outbox را به کار ببرید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** write concern کدام مرحله را کنترل می‌کند؟
   **پاسخ:** سطح تأیید write.
7. **پرسش:** read concern کدام مرحله را کنترل می‌کند؟
   **پاسخ:** سطح سازگاری/قابلیت مشاهدهٔ دادهٔ خوانده‌شده.
8. **پرسش:** read preference چیست؟
   **پاسخ:** انتخاب عضو/مقصد برای read.
9. **پرسش:** w:majority به چه چیزی اشاره می‌کند؟
   **پاسخ:** درخواست تأیید اکثریت طبق topology/تنظیمات.
10. **پرسش:** Retry با idempotency چه نسبتی دارد؟
   **پاسخ:** Retry ممکن است تکرار ایجاد کند؛ idempotency اثر تکرار را کنترل می‌کند.

## منابع فارسی
- [Transaction در MongoDB به فارسی](https://www.urhoba.net/fa/post/mongodb-acid)
- [تراکنش‌های MongoDB در فارسی](https://pars.host/blog/what-is-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Transactions](https://www.mongodb.com/docs/manual/core/transactions/)
- [Read Concern](https://www.mongodb.com/docs/manual/reference/read-concern/)
- [Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)
- [Retryable Writes](https://www.mongodb.com/docs/manual/core/retryable-writes/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#reliability-transactions) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
