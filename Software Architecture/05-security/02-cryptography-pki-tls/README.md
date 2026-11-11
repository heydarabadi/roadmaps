<div dir="rtl" align="right">

# هش، رمزنگاری، PKI و TLS

Hash تابع یک‌طرفه برای اثرانگشت داده است؛ password hashing باید کند و saltدار باشد؛ encryption داده را با کلید قابل‌بازیابی محرمانه می‌کند؛ digital signature تمامیت و منشأ را می‌سنجد؛ certificate/PKI کلید عمومی را به هویت و زنجیرهٔ اعتماد پیوند می‌دهد. این‌ها جای یکدیگر نیستند.

برای password از Argon2id یا گزینهٔ مناسب پلتفرم استفاده کن؛ SHA-256 ساده، به‌دلیل سرعت، حدس آفلاین را ارزان می‌کند. برای دادهٔ حساس کتابخانهٔ استاندارد به‌کار ببر، کلید را در مدیریت کلید نگه دار و rotation، backup و recovery را تمرین کن.

TLS کانال را با رمزنگاری و اعتبارسنجی گواهی محافظت می‌کند. HTTPS به‌تنهایی authorization، ایمنی منطق API یا حفاظت از log را تضمین نمی‌کند. expiry گواهی، hostname validation و چرخش کلید مسئولیت عملیاتی‌اند.

~~~text
Client -- TLS + server certificate validation --> API
Password -- slow hash + unique salt --> verifier
Never log passwords, tokens, or raw payment credentials
~~~

## انتخاب درست ابزار رمزنگاری

- **Hash عمومی:** اثرانگشت و مقایسهٔ تمامیت؛ برگشت‌پذیر نیست، اما hash سادهٔ password برای مقاومت در برابر حدس آفلاین کافی نیست.
- **Password hashing:** الگوریتم purpose-built و کند با salt یکتای هر رمز؛ پارامتر هزینه را با سخت‌افزار و راهنمای به‌روز انتخاب و بازبینی کن. salt را secret ندان؛ pepper اگر استفاده شد باید جدا حفاظت و قابل‌چرخش باشد.
- **رمزگذاری متقارن:** همان کلید برای رمزگذاری و رمزگشایی؛ سریع و مناسب حجم زیاد، ولی حفاظت و rotation کلید حیاتی است.
- **رمزگذاری نامتقارن:** کلید عمومی و خصوصی برای کاربردهایی مانند تبادل کلید؛ به‌تنهایی جای طراحی پروتکل یا کتابخانهٔ TLS را نمی‌گیرد.
- **امضای دیجیتال:** کلید خصوصی امضا می‌کند و کلید عمومی امضا را اعتبارسنجی می‌کند؛ محرمانگی ایجاد نمی‌کند.
- **MAC/HMAC:** طرف‌های دارای secret مشترک تمامیت و اصالت پیام را می‌سنجند؛ همهٔ دارندگان کلید می‌توانند پیام معتبر بسازند.

خودت cipher، padding، nonce یا پروتکل نساز. از API استاندارد و به‌روز چارچوب استفاده کن و تنظیم را با threat model بسنج.

## چرخهٔ عمر کلید

۱. کاربرد، صاحب، طبقه‌بندی داده و محیط کلید را ثبت کن.
۲. کلید را با مولد تصادفی امن یا سرویس مدیریت کلید بساز؛ در source code، image یا log قرار نده.
۳. دسترسی حداقلی بده و آن را audit کن. dev، test و production را از هم جدا نگه دار.
۴. rotation را با دورهٔ هم‌پوشانی طراحی کن: گیرنده کلید تازه را می‌شناسد، تولیدکننده به آن می‌نویسد، دادهٔ قدیمی در صورت نیاز re-encrypt می‌شود و کلید پیشین پس از پایان مهلت revoke می‌شود.
۵. backup و recovery را تمرین کن. گم‌شدن تنها کلید می‌تواند داده را غیرقابل‌بازیابی کند؛ افشای کلید نیازمند revoke و ارزیابی دامنهٔ افشاست.

## TLS از اتصال تا درخواست

Client گواهی سرور را از نظر زنجیرهٔ مورداعتماد، تاریخ اعتبار و تطبیق نام میزبان بررسی می‌کند. مذاکرهٔ رمز و تبادل امن کلید، کانال نشست را ایجاد می‌کند و داده‌ها در transit رمزگذاری و در برابر تغییر محافظت می‌شوند. از TLS مدرن و تنظیمات رسمی پلتفرم استفاده کن و نسخه‌های ناامن را غیرفعال کن.

TLS دادهٔ داخل حافظه، دیتابیس، backup، log یا screenshot را خودکار محافظت نمی‌کند و مجوز کاربر را هم نمی‌سنجد. برای webhook امضا را همراه timestamp، شناسهٔ یکتا و پنجرهٔ پذیرش تعریف کن تا replay محدود شود؛ timestamp به‌تنهایی جلوی replay را نمی‌گیرد.

## مثال انتخاب

برای ذخیرهٔ رمز عبور، password hashing کند لازم است، نه رمزگذاری برگشت‌پذیر. برای backup که باید restore شود، encryption با کلید مدیریت‌شده لازم است. برای ارتباط API، TLS لازم است. برای سنجش اصالت webhook، امضا یا MAC با حفاظت replay لازم است. اگر یک واژه مثل «رمزنگاری» برای هر چهار مورد به‌کار ببری، نیاز امنیتی مبهم می‌ماند.

## آزمون

۱. چرا SHA-256 ساده برای password مناسب نیست؟ **پاسخ:** سریع است و brute-force آفلاین را ارزان می‌کند.
۲. Encryption چه تفاوتی با hash دارد؟ **پاسخ:** encryption با کلید قابل‌بازیابی است؛ hash معمولاً یک‌طرفه است.
۳. TLS چه چیزی را تضمین نمی‌کند؟ **پاسخ:** مجوز کاربر و امن‌بودن منطق برنامه را.
۴. PKI چه رابطه‌ای را برقرار می‌کند؟ **پاسخ:** اعتبارسنجی کلید عمومی و هویت از راه گواهی و زنجیرهٔ اعتماد.

## تمرین

برای password، backup، TLS API و امضای webhook تعیین کن کلید کجا نگهداری و چگونه چرخانده شود.

## پاسخ نمونهٔ تمرین

Password با password hashing purpose-built و salt یکتا ذخیره می‌شود؛ هیچ کلید رمزگشایی ندارد. Backup با data-encryption key رمز و key-encryption key در KMS/HSM نگهداری می‌شود؛ rotation و restore تمرین می‌شود. TLS private key در certificate manager و renewal خودکار است. Webhook امضا/MAC با secret/key جدا، timestamp و event ID دارد؛ rotation با هم‌پوشانی کلید قدیم/جدید و revoke پس از مهاجرت انجام می‌شود.

## منابع

- فارسی: [مبانی معماری به فارسی](https://www.alirostami.com/software-architecture/)، [راهنمای OWASP](https://cheatsheetseries.owasp.org/)
- انگلیسی: [Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)، [TLS Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Transport_Layer_Security_Cheat_Sheet.html)، [NIST Cryptographic Standards](https://csrc.nist.gov/projects/cryptographic-standards-and-guidelines)

</div>
