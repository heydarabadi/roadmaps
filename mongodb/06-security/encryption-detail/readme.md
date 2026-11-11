# TLS، Encryption at Rest و Field-Level Encryption

> **English edition:** [Read this lesson in English](../../en/06-security/encryption-detail/readme.md).

> **هدف یادگیری:** تهدیدهای مسیر، دیسک و field حساس را تفکیک کنید.

## تدریس کامل: threat model رمزنگاری

### سه سطح رمزنگاری

1. **In transit:** TLS دادهٔ شبکه بین برنامه و database را رمز می‌کند. Certificate باید verify شود؛ خاموش‌کردن verification راه‌حل امن نیست.
2. **At rest:** دادهٔ ذخیره‌شده روی volume یا storage را محافظت می‌کند. در Atlas بخشی از قابلیت سرویس است؛ در self-managed تنظیمات و edition ممکن است متفاوت باشند.
3. **In use / field-level:** Client-Side Field Level Encryption مقدار انتخابی را در driver پیش از ارسال رمز می‌کند؛ Queryable Encryption امکان queryهای مجاز روی دادهٔ رمز‌شده را هدف می‌گیرد.

این کنترل‌ها دسترسی application مجاز یا superuser privileged را در همهٔ شرایط مسدود نمی‌کنند. RBAC، network control، key management و audit مکمل‌اند.

### مدیریت کلید

کلید را خارج از source و خارج از دادهٔ رمز‌شده نگه دارید؛ KMS/key vault، مجوز محدود، rotation، backup امن و disaster recovery را طراحی کنید. اگر کلید گم شود، ممکن است داده قابل رمزگشایی نباشد. اگر کلید لو برود، ciphertext ممکن است محرمانه نماند.

### انتخاب field-level

فقط fieldهایی را encrypt کنید که threat model نیاز دارد. مشخص کنید آیا برنامه باید equality/range search داشته باشد، چه driverهایی استفاده می‌شوند، metadata چه مقدار نشت می‌دهد، و چگونه schema/key rotation انجام می‌شود. هر operator و aggregation روی encrypted field الزاماً پشتیبانی نمی‌شود. سازگاری جاری را پیش از طراحی بررسی کنید.

### تمرین

برای شمارهٔ کارت فرضی، threatهای سرقت disk، شنود network، DB admin و افشای key را جدا فهرست کنید. سپس برای هر تهدید کنترل مناسب و محدودیت باقی‌مانده بنویسید؛ «encryption روشن است» به تنهایی پاسخ کافی نیست.

## آموزش
TLS ارتباط شبکه را رمز می‌کند؛ encryption at rest دادهٔ ذخیره‌شده را محافظت می‌کند. این دو جای RBAC یا حفاظت کلید را نمی‌گیرند. Client-Side Field Level Encryption دادهٔ مشخص را در driver و پیش از ارسال رمز می‌کند. Queryable Encryption اجازهٔ بعضی queryها روی دادهٔ encrypted را می‌دهد، با محدودیت‌های نسخه و عملیات قابل پشتیبانی.

کلید را جدا و کنترل‌شده با KMS/key vault نگه دارید؛ rotation و recovery تعریف کنید. Threat model روشن کند از شنود شبکه، سرقت دیسک یا دسترسی privileged دیتابیس در برابر چه چیزی دفاع می‌کنید. CSFLE و Queryable Encryption را برای یک collection با هم فرض نکنید؛ compatibility را مطالعه کنید.

## مثال
~~~text
TLS → مسیر شبکه
Encryption at rest → دیسک
CSFLE/Queryable Encryption → field انتخاب‌شده
RBAC + audit → دسترسی و ردگیری
~~~

## سناریوی عملی
برای شمارهٔ ملی، ابتدا تعیین کنید آیا query روی مقدار لازم است. اگر نه، tokenization یا ذخیرهٔ کمینه شاید ساده‌تر باشد؛ اگر بله، queryable encryption و چرخهٔ کلید را با امنیت/معماری ارزیابی کنید.

## خطاهای رایج
- یکی گرفتن TLS با at-rest.
- کلید کنار دیتابیس.
- خاموش‌کردن certificate verification.
- فرض پشتیبانی همهٔ queryها در QE.

## تمرین
1. برای ایمیل و شماره کارت نیاز read و search را مشخص کنید.
2. پس از TLS، تهدیدهای باقی‌مانده را بنویسید.

## آزمون و پاسخ
1. **پرسش:** TLS کجا حفاظت می‌کند؟
   **پاسخ:** در مسیر شبکه.
2. **پرسش:** at rest کجا؟
   **پاسخ:** روی فایل و storage داده.
3. **پرسش:** چرا حفاظت کلید حیاتی است؟
   **پاسخ:** دسترسی به کلید برای محرمانگی و بازیابی ضروری است.
4. **پرسش:** چرا باید از «یکی گرفتن TLS با at-rest.» پرهیز کرد؟
   **پاسخ:** یک لایه همهٔ تهدیدها را پوشش نمی‌دهد و کلید محافظت‌نشده محرمانگی را بی‌اثر می‌کند؛ TLS، at-rest، field encryption و RBAC وظایف جدا دارند.
5. **مسئلهٔ کاربردی:** برای ایمیل و شماره کارت نیاز read و search را مشخص کنید.
   **پاسخ نمونه:** TLS مسیر، at-rest storage و CSFLE/QE فیلد حساس را پوشش می‌کنند؛ کلید را جدا مدیریت کنید و queryهای نیازمند encryption را پیش از انتخاب فنی مشخص کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** TLS چه چیزی را رمز می‌کند؟
   **پاسخ:** ارتباط انتقالی شبکه.
7. **پرسش:** CSFLE کجا رمز می‌کند؟
   **پاسخ:** در سمت client/driver پیش از ارسال.
8. **پرسش:** At-rest encryption جای RBAC است؟
   **پاسخ:** خیر؛ data access را محدود نمی‌کند.
9. **پرسش:** کلید encryption کجا باید باشد؟
   **پاسخ:** در مدیریت کلید جدا و کنترل‌شده.
10. **پرسش:** آیا همهٔ operatorها روی encrypted field قابل استفاده‌اند؟
   **پاسخ:** خیر؛ query support محدودیت دارد و باید بررسی شود.

## منابع فارسی
- [رمزنگاری در راهنمای امنیت فارسی](https://www.urhoba.net/fa/post/mongodb-2)
- [مقالهٔ معرفی MongoDB فارسی](https://pars.host/blog/what-is-mongodb/)

> منابع فارسی ممکن است از نسخهٔ جاری عقب باشند؛ جزئیات را با مستندات رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Data Encryption](https://www.mongodb.com/docs/manual/core/security-data-encryption/)
- [Encryption at Rest](https://www.mongodb.com/docs/manual/core/security-encryption-at-rest/)
- [TLS Transport Encryption](https://www.mongodb.com/docs/manual/core/security-transport-encryption/)
- [Queryable Encryption](https://www.mongodb.com/docs/manual/core/queryable-encryption/)
- [CSFLE](https://www.mongodb.com/docs/manual/core/csfle/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#security-encryption) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
