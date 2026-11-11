# MongoDB Audit و logهای امنیتی

> **English edition:** [Read this lesson in English](../../en/06-security/audit-detail/readme.md).

> **هدف یادگیری:** رخدادهای حساس را ثبت کنید بدون اینکه secret یا PII را افشا کنید.

## تدریس کامل: ثبت و پاسخ به رخداد

### چه چیزی را ثبت کنیم؟

برای رخداد قابل‌پیگیری معمولاً actor، زمان UTC، منبع، action، resource، outcome و request ID لازم است. Audit log روی عمل‌های حساس، تغییر نقش و دسترسی مهم تمرکز دارد؛ application log علت business action را نشان می‌دهد؛ metric و alert روند و فشار منابع را نشان می‌دهند.

### امنیت خود log

Log می‌تواند خود یک منبع افشای داده شود. password، token، connection string کامل و PII غیرضروری را حذف یا redact کنید. دسترسی log، retention، رمزنگاری، انتقال، immutability و حذف مطابق سیاست سازمان تعریف شود. ساعت serverها را همگام کنید تا timeline قابل بازسازی باشد.

### طراحی یک drill

فرض کنید یک user برنامه به نقش admin ارتقا یافته است:
1. چه هشدار یا audit eventی آن را نشان می‌دهد؟
2. آیا actor و زمان با تغییر در deployment ثبت است؟
3. چگونه دسترسی را revoke می‌کنید؟
4. credential rotation لازم است؟
5. چه داده‌ای باید بررسی شود؟
6. چه کسی تصمیم می‌گیرد incident خاتمه یافته؟
7. logها تا چه مدت محفوظ‌اند؟

قابلیت audit به edition، service و تنظیمات وابسته است. قبل از فرض‌کردن eventهایی که ثبت می‌شوند، deployment خود را بررسی و یک drill آزمایشی انجام دهید.

## آموزش
Audit trail باید هویت، زمان، مبدأ، action، resource و outcome را قابل بررسی کند. امکانات audit به نسخه و deployment وابسته است؛ self-managed و Atlas گزینه‌های یکسان ندارند. Audit، database log، application log، metrics و alert را با request ID و ساعت هماهنگ به هم پیوند دهید.

ثبت همه‌چیز حجم و هزینه می‌آورد و ممکن است دادهٔ حساس را وارد log کند. retention، دسترسی، حفاظت در برابر تغییر و masking را تعریف کنید. پایش تغییر role، login failure، اتصال غیرعادی و backup failure را به runbook وصل کنید.

## مثال
~~~text
timestamp UTC | actor | source | action | resource | outcome | request-id
ممنوع در log: password، token، URI کامل و payload حساس غیرضروری
~~~

## سناریوی عملی
در رخداد privilege escalation، audit باید از قبل فعال بوده و زمان application/DB هماهنگ باشد؛ بعد از حادثه نمی‌توان logی را که نگرفته‌ایم بازسازی کرد. drill دوره‌ای انجام دهید.

## خطاهای رایج
- logging کامل بدون سیاست retention.
- نوشتن credential در log.
- زمان ناهماهنگ و نبود correlation.
- alert بدون runbook.

## تمرین
1. یک تغییر نقش مشکوک را بازسازی کنید؛ چه eventهایی نیاز است؟
2. retention و دسترسی audit log را تعریف کنید.

## آزمون و پاسخ
1. **پرسش:** audit برای چیست؟
   **پاسخ:** ثبت فعالیت قابل بررسی برای تحلیل رخداد.
2. **پرسش:** چرا secret در log خطرناک است؟
   **پاسخ:** log تکثیر و با افراد بیشتری به‌اشتراک گذاشته می‌شود.
3. **پرسش:** آیا امکانات audit همهٔ deploymentها یکسان است؟
   **پاسخ:** خیر؛ نسخه و محصول را بررسی کنید.
4. **پرسش:** چرا باید از «logging کامل بدون سیاست retention.» پرهیز کرد؟
   **پاسخ:** بدون retention، correlation و حفاظت log رخداد قابل بازسازی نیست یا خودش داده افشا می‌کند؛ log را محدود و محافظت کنید.
5. **مسئلهٔ کاربردی:** یک تغییر نقش مشکوک را بازسازی کنید؛ چه eventهایی نیاز است؟
   **پاسخ نمونه:** ثبت actor/time/action/resource/outcome و request-id را فعال کنید، secret را حذف کنید، زمان را هماهنگ و دسترسی/retention را تعریف کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** Audit log چه می‌گوید؟
   **پاسخ:** چه هویتی، چه زمانی، چه عملی روی کدام resource انجام داد.
7. **پرسش:** چرا UTC و clock sync مهم است؟
   **پاسخ:** برای ساخت timeline مشترک بین logها.
8. **پرسش:** چرا token را log نمی‌کنیم؟
   **پاسخ:** چون logها تکثیر و به افراد/سامانه‌های دیگر می‌رسند.
9. **پرسش:** Retention چه چیزی را کنترل می‌کند؟
   **پاسخ:** مدت نگهداری و حذف log.
10. **پرسش:** Alert بدون runbook کافی است؟
   **پاسخ:** خیر؛ باید اقدام و مالک پاسخ مشخص باشد.

## منابع فارسی
- [Audit و امنیت MongoDB به فارسی](https://www.urhoba.net/fa/post/mongodb-2)
- [مسیر فارسی MongoDB](https://www.urhoba.net/fa/series/mongodb-rehberi)

> منابع فارسی ممکن است از نسخهٔ جاری عقب باشند؛ جزئیات را با مستندات رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Auditing](https://www.mongodb.com/docs/manual/core/auditing/)
- [Configure Auditing](https://www.mongodb.com/docs/manual/tutorial/configure-auditing/)
- [Log Messages](https://www.mongodb.com/docs/manual/reference/log-messages/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#security-encryption) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
