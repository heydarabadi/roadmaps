# Developer Tools: mongosh، Compass و Database Tools

> **English edition:** [Read this lesson in English](../../../../en/mongodb/07-ecosystem/developer-tools/README.md).

> **هدف یادگیری:** ابزار مناسب را برای کاوش، script، backup و عیب‌یابی انتخاب کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: ابزارها برای کدام کار؟

- **mongosh:** اکتشاف، command، script کوتاه و اجرای عملیات DBA.
- **Compass:** دیدن document، ساخت query، بررسی schema و pipeline بصری.
- **Database Tools:** dump/restore و import/export.
- **Atlas UI/CLI یا مدیریت سازمانی:** مدیریت deployment و شاخص‌های سرویس بسته به امکانات.
- **Driver:** کار درون application؛ shell جایگزین آن نیست.

GUI اجرای امن را تضمین نمی‌کند. پیش از mutation انبوه، filter را بازبینی، تعداد هدف را تخمین، backup و dry-run را بررسی کنید. دادهٔ production را برای laptop debug بدون masking کپی نکنید.

### عملیات تکرارپذیر

عملیات مکرر را به script بازبینی‌پذیر تبدیل کنید. script باید:
- مقصد را در ابتدا چاپ کند.
- حالت dry-run یا تعداد هدف داشته باشد.
- batch limit و timeout داشته باشد.
- log بدون credential بنویسد.
- در خطا متوقف شود یا گزارش قابل‌اقدام بسازد.
- روش rollback یا restore را توضیح دهد.

### عیب‌یابی

Server version، driver/tool version، host، database، role، زمان و خطای کاملِ redacted را ثبت کنید. explain را برای query plan، Compass را برای مشاهدهٔ شکل داده و log/metrics را برای رفتار زمان اجرا به کار برید. هر ابزار فقط بخشی از تصویر را نشان می‌دهد.

## آموزش
mongosh برای command و script، Compass برای مرور داده و ساخت query/pipeline، و Database Tools برای dump/restore و import/export کاربرد دارند. ابزار GUI اجرای امن را تضمین نمی‌کند. برای عملیات تکراری، script بازبینی‌پذیر با dry-run، batch limit، log و روش توقف بسازید.

دادهٔ production را بدون masking برای debug محلی کپی نکنید. نسخهٔ ابزار و server را هماهنگ و URI را از history/log پنهان کنید. explain ابزار مهمی است، اما نتیجه را با metric سرور و workload بررسی کنید.

## مثال
~~~bash
mongosh --version
mongodump --version
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
در import حساس، dry-run باید مقصد، تعداد ورودی، سندهای ناسازگار و اندازهٔ batch را گزارش دهد. شمارش و راه توقف قبل از نوشتن کنترل ریسک است.

## خطاهای رایج
- کپی dump production به سیستم ناامن.
- اجرای delete بدون بازبینی filter.
- فرض GUI مساوی audit است.
- ابزار ناسازگار با نسخهٔ server.

## تمرین
1. runbook import با dry-run، backup و rollback بنویسید.
2. explain یک query را بخوانید و stage را تفسیر کنید.

## آزمون و پاسخ
1. **پرسش:** Compass برای چیست؟
   **پاسخ:** کاوش داده، query و pipeline.
2. **پرسش:** Database Tools چه می‌کنند؟
   **پاسخ:** dump/restore و import/export.
3. **پرسش:** چرا عملیات تکراری را script کنیم؟
   **پاسخ:** بازبینی و تکرارپذیری بهتر.
4. **پرسش:** چرا باید از «کپی dump production به سیستم ناامن.» پرهیز کرد؟
   **پاسخ:** dump می‌تواند اطلاعات شخصی، token یا دادهٔ محرمانه داشته باشد. قبل از انتقال به محیط توسعه آن را محدود/محو کنید و رمزگذاری، دسترسی و مدت نگهداری فایل را تعیین کنید.
5. **مسئلهٔ کاربردی:** runbook import با dry-run، backup و rollback بنویسید.
   **پاسخ نمونه:** قبل از import مقصد و count را نشان دهید، dry-run و backup بگیرید، batch محدود اجرا کنید و پس از نوشتن داده و index را بررسی کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** mongosh برای چیست؟
   **پاسخ:** اجرای دستورات و script تعاملی.
7. **پرسش:** Compass چه کمکی می‌کند؟
   **پاسخ:** مرور data، ساخت query/pipeline و دیدن plan.
8. **پرسش:** Database Tools چه کارهایی می‌کنند؟
   **پاسخ:** Dump/restore و import/export.
9. **پرسش:** چرا dry-run مفید است؟
   **پاسخ:** قبل از نوشتن مقصد و تعداد هدف را نشان می‌دهد.
10. **پرسش:** چطور دادهٔ production را برای debug محافظت کنیم؟
   **پاسخ:** Mask/anonymize کنیم و دسترسی/نگهداری محدود داشته باشیم.

## منابع فارسی
- [ابزارهای MongoDB به فارسی](https://www.urhoba.net/fa/post/mongodb-3)
- [نصب و Compass به فارسی](https://pars.host/blog/what-is-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [MongoDB Shell](https://www.mongodb.com/docs/mongodb-shell/)
- [MongoDB Compass](https://www.mongodb.com/docs/compass/current/)
- [Database Tools](https://www.mongodb.com/docs/database-tools/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#foundations-tools) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
