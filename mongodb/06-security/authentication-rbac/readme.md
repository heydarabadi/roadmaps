# Authentication و RBAC

> **English edition:** [Read this lesson in English](../../en/06-security/authentication-rbac/readme.md).

> **هدف یادگیری:** هویت و مجوز را تفکیک و حداقل دسترسی را اعمال کنید.

## تدریس کامل: هویت و مجوز

### دو سؤال متفاوت

Authentication می‌پرسد «این کلاینت چه هویتی دارد؟». Authorization می‌پرسد «این هویت کدام action را می‌تواند انجام دهد؟». کاربر درست با نقش بیش‌ازحد، همچنان خطرناک است؛ password قوی بدون role محدود هم کافی نیست.

### ساخت نقش

برای هر سرویس یک database user جدا بسازید. فقط database/collectionهای لازم و actionهای لازم را بدهید. حساب analyst نباید write داشته باشد اگر فقط گزارش می‌خواند. حساب backup و human operator را از برنامه جدا کنید. دسترسی role را همراه feature code review کنید.

SCRAM نام کاربری/رمز را با مکانیزم احراز هویت MongoDB بررسی می‌کند. سرویس‌های ابری و Enterprise می‌توانند مکانیزم‌های دیگری مانند X.509، OIDC یا identity provider را پشتیبانی کنند. availability را برای edition، driver و version خود بررسی کنید.

### Secret lifecycle

- secret را در source code و config قابل‌commit قرار ندهید.
- از secret manager/environment امن استفاده کنید.
- access را log یا چاپ نکنید.
- rotation را با دو credential یا زمان گذار بدون downtime اجرا کنید.
- دسترسی‌های قدیمی را revoke کنید و رخداد را audit کنید.
- شبکه را محدود و TLS را فعال کنید.

### آزمون مجوز

با user برنامه این آزمون‌ها را انجام دهید:
1. query مجاز روی collection خودش موفق شود.
2. نوشتن روی collection غیرمجاز رد شود.
3. ایجاد database یا user جدید مجاز نباشد.
4. backup user فقط وظیفهٔ تعریف‌شده را انجام دهد.

کمینه‌سازی مجوزها را می‌توان با سرقت credential، باگ API و سوءاستفادهٔ داخلی به عنوان threat scenario ارزیابی کرد.

## آموزش
Authentication هویت را تأیید می‌کند؛ authorization مشخص می‌کند چه actionهایی مجازند. کاربر انسانی، برنامه، backup و monitoring را جدا کنید. نقش built-in یا custom را طوری بسازید که برنامه فقط عملیات ضروری روی database/collection خودش را داشته باشد. secret را در vault/environment نگه دارید، rotate کنید و URI را log نکنید.

SCRAM رایج است؛ X.509، OIDC، AWS IAM و روش‌های Enterprise/Atlas دیگر نیز بسته به deployment قابل استفاده‌اند. انتخاب مکانیزم به نسخه، edition، driver و زیرساخت هویت سازمان بستگی دارد. شبکهٔ private، firewall و TLS را همراه authorization در نظر بگیرید.

## مثال
~~~text
orders-api → find/insert/update روی shop.orders
backup-service → مجوزهای محدود backup
human-operator → حساب شخصی و قابل audit
~~~

## سناریوی عملی
اگر credential یک سرویس افشا شود، دسترسی admin دامنهٔ خسارت را به تمام deployment می‌کشاند. نقش محدود و credential جدا این دامنه را کوچک می‌کند؛ دسترسی‌ها را دوره‌ای مرور کنید.

## خطاهای رایج
- اتصال app با root/admin.
- اشتراک credential بین سرویس‌ها.
- گذاشتن password داخل URI یا log.
- فراموشی rotation و audit.

## تمرین
1. ماتریس نقش برای app، analyst، backup و operator بسازید.
2. rotation secret را بدون downtime طراحی کنید.

## آزمون و پاسخ
1. **پرسش:** Authentication و authorization؟
   **پاسخ:** اثبات هویت در برابر تعیین مجوز.
2. **پرسش:** حداقل دسترسی چیست؟
   **پاسخ:** فقط action لازم به هر هویت داده شود.
3. **پرسش:** چرا حساب برنامه جدا از admin است؟
   **پاسخ:** برای محدودکردن اثر credential افشاشده.
4. **پرسش:** چرا باید از «اتصال app با root/admin.» پرهیز کرد؟
   **پاسخ:** admin مشترک اصل least privilege را نقض می‌کند؛ credential افشاشده به کل deployment راه می‌یابد.
5. **مسئلهٔ کاربردی:** ماتریس نقش برای app، analyst، backup و operator بسازید.
   **پاسخ نمونه:** app user را به database/collection و actionهای لازم محدود کنید؛ حساب backup و انسان را جدا و credentialها را rotate کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** اصل least privilege چیست؟
   **پاسخ:** هر account فقط مجوز لازم را دارد.
7. **پرسش:** چرا service user جداست؟
   **پاسخ:** برای محدودکردن دامنهٔ آسیب و امکان revoke هدفمند.
8. **پرسش:** SCRAM برای چیست؟
   **پاسخ:** احراز هویت user/password MongoDB.
9. **پرسش:** کجا secret را نگه می‌داریم؟
   **پاسخ:** Secret manager یا محیط امن، نه source code.
10. **پرسش:** چطور role را اعتبارسنجی می‌کنیم؟
   **پاسخ:** با آزمون مجاز/غیرمجاز روی حساب آزمایشی.

## منابع فارسی
- [امنیت MongoDB به فارسی](https://www.urhoba.net/fa/post/mongodb-2)
- [راهنمای MongoDB فارسی](https://www.urhoba.net/fa/series/mongodb-rehberi)

> منابع فارسی ممکن است از نسخهٔ جاری عقب باشند؛ جزئیات را با مستندات رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Authentication](https://www.mongodb.com/docs/manual/core/authentication/)
- [Role-Based Access Control](https://www.mongodb.com/docs/manual/core/authorization/)
- [Built-in Roles](https://www.mongodb.com/docs/manual/reference/built-in-roles/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#security-auth) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
