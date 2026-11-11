# X.509، Kerberos و LDAP سازمانی

> **English edition:** [Read this lesson in English](../../en/06-security/enterprise-auth/readme.md).

> **هدف یادگیری:** روش‌های احراز هویت سازمانی را بشناسید و deprecation فعلی LDAP را لحاظ کنید.

## تدریس کامل: SCRAM، X.509، Kerberos و LDAP

### SCRAM

SCRAM user/password authentication رایج است و در Community edition نیز موجود است. Password را URL-encode کنید اگر در URI است، از shell history دور نگه دارید و authentication database درست را انتخاب کنید.

### X.509

X.509 هویت را با certificate اثبات می‌کند. Certificate authority، subject، expiry، rotation و trust chain باید مدیریت شوند. Certificate منقضی یا hostname نامنطبق اتصال را خراب می‌کند. در replica set/sharded cluster، نام host و certificate باید با topology سازگار باشند.

### Kerberos

Kerberos از GSSAPI استفاده می‌کند و معمولاً برای سازمانی است که KDC و principalهای موجود دارد. مستندات MongoDB قابلیت server-side را به Enterprise نسبت می‌دهند. Clock skew، service principal، DNS/FQDN، ticket و driver support از نقاط عیب‌یابی‌اند. این گزینه را برای Atlas/Community فرض نکنید؛ compatibility جدول driver را ببینید.

### LDAP

LDAP/LDAPS directory سازمانی را به auth و group mapping وصل می‌کند. mapping گروه به role باید با حساب آزمایشی تست شود. نکتهٔ فعلی: MongoDB اعلام کرده LDAP authentication/authorization از MongoDB 8.0 deprecated است و در یک نسخهٔ اصلی آینده حذف خواهد شد. به عنوان طراحی جدید، مسیر جایگزین رسمی را بررسی و مهاجرت deployment موجود را برنامه‌ریزی کنید. اگر LDAP فعلاً فعال است، certificate، اتصال امن، fallback، version support و deadline مهاجرت را ثبت کنید.

### انتخاب مکانیزم

سؤال‌ها: کدام edition/deployment؟ آیا IdP سازمانی وجود دارد؟ برنامه چه driverهایی دارد؟ rotation و outage IdP چگونه مدیریت می‌شود؟ آیا این مکانیزم در نسخهٔ هدف پشتیبانی می‌شود؟ انتخاب را با تیم identity/security انجام دهید و دسترسی نهایی را با RBAC محدود کنید.

## آموزش
X.509 هویت را با certificate تأیید می‌کند. Kerberos با GSSAPI برای محیط‌های سازمانی و MongoDB Enterprise self-managed کاربرد دارد. LDAP/LDAPS می‌تواند به directory سازمان وصل شود، اما باید سیاست certificate، rotation، mapping گروه به role و دسترس‌پذیری directory طراحی شود.

نکتهٔ نسخه‌ای مهم: طبق مستندات رسمی جاری، LDAP authentication/authorization از MongoDB 8.0 deprecated شده و در نسخهٔ اصلی آینده حذف خواهد شد. برای طراحی جدید، alternativeهای رسمی را بررسی کنید و LDAP قدیمی را بی‌برنامه مبنا نگذارید. جزئیات edition و پشتیبانی driver متفاوت است؛ قبل از پیکربندی صفحهٔ compatibility همان deployment را بخوانید.

## مثال
~~~text
تصمیم سازمانی:
1) هویت از کدام IdP/Directory می‌آید؟
2) کدام گروه به کدام MongoDB role نگاشت می‌شود؟
3) TLS، rotation و failure در دسترس‌نبودن IdP چگونه مدیریت می‌شود؟
4) مسیر مهاجرت از LDAP deprecation چیست؟
~~~

## سناریوی عملی
در سازمانی که Active Directory دارد، اتصال موفق به معنی mapping درست مجوز نیست؛ گروه اشتباه می‌تواند دسترسی ناخواسته بدهد. role mapping و رفتار هنگام قطع directory را با حساب آزمایشی تست کنید.

## خطاهای رایج
- نادیده‌گرفتن deprecated بودن LDAP از MongoDB 8.0.
- تصور پشتیبانی Kerberos در Community/Atlas به صورت یکسان.
- تنظیم auth بدون TLS امن.
- گذاشتن keytab یا certificate در دسترسی عمومی.

## تمرین
1. برای سرویس سازمانی، یک مسیر auth و role mapping بنویسید.
2. برنامهٔ مهاجرت از LDAP را با deadline نسخه‌ها بررسی کنید.

## آزمون و پاسخ
1. **پرسش:** X.509 چه چیزی را به کار می‌گیرد؟
   **پاسخ:** Certificate برای هویت کلاینت/عضو.
2. **پرسش:** Kerberos معمولاً با چه مکانیزمی شناخته می‌شود؟
   **پاسخ:** GSSAPI.
3. **پرسش:** وضعیت LDAP از MongoDB 8.0 چیست؟
   **پاسخ:** Deprecated است و قرار است در نسخهٔ اصلی آینده حذف شود.
4. **پرسش:** چرا باید از «نادیده‌گرفتن deprecated بودن LDAP از MongoDB 8.0.» پرهیز کرد؟
   **پاسخ:** نادیده‌گرفتن deprecation می‌تواند مانع upgrade شود؛ LDAP از MongoDB 8.0 deprecated است و باید جایگزین و زمان مهاجرت بررسی شود.
5. **مسئلهٔ کاربردی:** برای سرویس سازمانی، یک مسیر auth و role mapping بنویسید.
   **پاسخ نمونه:** X.509 را برای certificate، Kerberos/GSSAPI را برای Enterprise و LDAP را فقط با توجه به deprecation و مسیر migration بسنجید؛ role mapping و TLS را تست کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** X.509 از چه سازوکاری استفاده می‌کند؟
   **پاسخ:** گواهی دیجیتال.
7. **پرسش:** Kerberos با چه SASL mechanism شناخته می‌شود؟
   **پاسخ:** GSSAPI.
8. **پرسش:** وضع LDAP از MongoDB 8.0 چیست؟
   **پاسخ:** Deprecated است و برای نسخهٔ اصلی آینده حذف آن اعلام شده.
9. **پرسش:** چرا role mapping گروه مهم است؟
   **پاسخ:** گروه اشتباه می‌تواند مجوز اضافی بدهد.
10. **پرسش:** آیا Kerberos در Community و Atlas یکسان است؟
   **پاسخ:** خیر؛ edition و driver compatibility را بررسی کنید.

## منابع فارسی
- [امنیت و احراز هویت MongoDB به فارسی](https://www.urhoba.net/fa/post/mongodb-2)
- [منبع فارسی عمومی MongoDB](https://pars.host/blog/what-is-mongodb/)

> منابع فارسی ممکن است از نسخهٔ جاری عقب باشند؛ جزئیات را با مستندات رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [X.509 Authentication](https://www.mongodb.com/docs/manual/core/security-x.509/)
- [Kerberos Authentication](https://www.mongodb.com/docs/manual/tutorial/control-access-to-mongodb-with-kerberos-authentication/)
- [LDAP Deprecation and Authorization](https://www.mongodb.com/docs/manual/core/security-ldap-external/)
- [Node Driver Mechanism Compatibility](https://www.mongodb.com/docs/drivers/node/current/security/authentication/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#security-auth) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
