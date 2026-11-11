# امنیت: Auth، RBAC، TLS، Encryption و Audit

> **English edition:** [Read this lesson in English](../../../../en/mongodb/06-security/security/README.md).

> **هدف یادگیری:** لایه‌های هویت، مجوز، شبکه، رمزنگاری و پایش را طراحی کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس فصل: امنیت به صورت لایه‌ای

امنیت یک تنظیم واحد نیست. threat model را با دارایی، مهاجم، مسیر دسترسی و اثر رخداد شروع کنید. سپس کنترل‌ها را لایه‌لایه ببندید:
1. Authentication برای هویت.
2. RBAC برای مجوز کمینه.
3. private network/firewall برای محدودکردن مسیر دسترسی.
4. TLS برای دادهٔ مسیر.
5. encryption at rest و field encryption برای تهدیدهای ذخیره/دسترسی.
6. audit/log/alert برای کشف و پاسخ.
7. backup رمزگذاری‌شده و restore برای تاب‌آوری.

### مثال حساب‌ها

- app user: فقط collectionهای برنامه و actionهای لازم.
- backup user: مجوزهای backup و restore مطابق runbook.
- analyst: read-only روی داده‌های مجاز یا viewهای کنترل‌شده.
- operator: حساب شخصی، MFA/SSO در صورت پشتیبانی و audit.

Credential مشترک بین همهٔ سرویس‌ها ریشه‌یابی و revoke را دشوار می‌کند.

### Review پیش از production

- هیچ secret در Git، log یا ticket نیست.
- دسترسی شبکه فقط از host/subnet لازم است.
- TLS certificate معتبر و rotation plan دارد.
- userها و roleها فهرست شده و مالک دارند.
- encryption key و audit log policy مستند است.
- alertها به runbook وصل‌اند.
- backup و restore drill انجام شده است.
- LDAP، Kerberos یا هر مکانیزم Enterprise طبق نسخه و edition معتبر بررسی شده است.

LDAP از MongoDB 8.0 deprecated اعلام شده؛ قابلیت‌ها و مسیر مهاجرت را در مستندات جاری ببینید. برای جزئیات هر کنترل به درس‌های مستقل این فصل بروید.

## آموزش
Authentication هویت را ثابت می‌کند؛ authorization مجوز را تعیین می‌کند. برنامه user جدا با حداقل action لازم داشته باشد. روش‌ها بسته به deployment شامل SCRAM، X.509، LDAP/LDAPS و Kerberos هستند. TLS ترافیک شبکه را رمز می‌کند؛ encryption at rest فایل ذخیره‌شده را. CSFLE و Queryable Encryption برای field حساس‌اند و به driver، نسخه و مدیریت کلید وابسته‌اند.

Audit و log فعالیت را ثبت می‌کنند، اما نباید secret یا دادهٔ حساس غیرضروری در آنها باشد. network access، private networking، firewall، credential rotation و پایش login failure را هم طراحی کنید. امکانات دقیق محصول به نسخه و محیط بستگی دارد.

## مثال
~~~text
app-user → فقط find/insert/update روی shop.orders
TLS → محافظت مسیر شبکه
at-rest → محافظت دادهٔ ذخیره‌شده
audit → ثبت دسترسی‌های حساس
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
اگر credential برنامه افشا شود، نقش admin خسارت را به کل deployment گسترش می‌دهد؛ حداقل دسترسی و حساب‌های جدا دامنهٔ اثر را محدود می‌کنند. برای دادهٔ حساس، ابتدا نیاز واقعی query را روشن کنید و سپس field encryption را انتخاب کنید.

## خطاهای رایج
- اتصال برنامه با admin.
- باز بودن endpoint به اینترنت.
- ذخیرهٔ کلید کنار دیتابیس.
- خاموش‌کردن TLS verification.
- نوشتن secret در log.

## تمرین
1. ماتریس app/backup/operator و actionهای مجاز بسازید.
2. تهدیدهای باقی‌مانده پس از TLS را فهرست کنید.

## آزمون و پاسخ
1. **پرسش:** Authentication و authorization؟
   **پاسخ:** اثبات هویت در برابر تعیین اجازه.
2. **پرسش:** TLS کجا حفاظت می‌کند؟
   **پاسخ:** در مسیر شبکه.
3. **پرسش:** حداقل دسترسی یعنی چه؟
   **پاسخ:** فقط مجوز لازم به هر حساب داده شود.
4. **پرسش:** چرا باید از «اتصال برنامه با admin.» پرهیز کرد؟
   **پاسخ:** این کار دامنهٔ خسارت را بزرگ می‌کند؛ حداقل‌دسترسی، TLS، network restriction و حفاظت secret را باهم اعمال کنید.
5. **مسئلهٔ کاربردی:** ماتریس app/backup/operator و actionهای مجاز بسازید.
   **پاسخ نمونه:** برای هر account نقش جدا و کم‌دسترسی بسازید، ارتباط را با TLS محافظت کنید، secret را rotate و دسترسی privileged را audit کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** Authentication از چه می‌پرسد؟
   **پاسخ:** هویت کلاینت چیست.
7. **پرسش:** Authorization چه می‌پرسد؟
   **پاسخ:** چه actionهایی مجاز است.
8. **پرسش:** TLS از چه چیزی حفاظت می‌کند؟
   **پاسخ:** داده در مسیر شبکه.
9. **پرسش:** Encryption at rest چه چیزی را پوشش می‌دهد؟
   **پاسخ:** storage دادهٔ ذخیره‌شده.
10. **پرسش:** چرا log هم نیاز به امنیت دارد؟
   **پاسخ:** ممکن است credential یا PII داشته باشد.

## منابع فارسی
- [امنیت MongoDB به فارسی](https://www.urhoba.net/fa/post/mongodb-2)
- [معرفی MongoDB و امنیت](https://pars.host/blog/what-is-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

نکتهٔ نسخه‌ای: مستندات MongoDB اعلام می‌کنند LDAP auth/authz از نسخهٔ 8.0 deprecated است و در نسخهٔ اصلی آینده حذف می‌شود؛ برای طراحی تازه جایگزین رسمی را بررسی کنید.

## منابع انگلیسی و رسمی
- [LDAP deprecation](https://www.mongodb.com/docs/manual/core/security-ldap-external/)
- [Authentication](https://www.mongodb.com/docs/manual/core/authentication/)
- [RBAC](https://www.mongodb.com/docs/manual/core/authorization/)
- [Encryption](https://www.mongodb.com/docs/manual/core/security-data-encryption/)
- [Queryable Encryption](https://www.mongodb.com/docs/manual/core/queryable-encryption/)
- [Auditing](https://www.mongodb.com/docs/manual/core/auditing/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#security-auth) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
