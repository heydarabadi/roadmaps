<div dir="rtl" align="right">

# احراز هویت و مجوزدهی

احراز هویت می‌پرسد «چه کسی هستی؟»؛ مجوزدهی می‌پرسد «برای این عمل روی این منبع چه اجازه‌ای داری؟». Login موفق دسترسی به همهٔ objectها نمی‌دهد. policy را سمت server برای هر resource و action، با توجه به مالکیت، tenant و وضعیت کسب‌وکار اجرا کن.

Session شناسهٔ تصادفی می‌دهد و state سمت server می‌ماند؛ bearer token به دارنده اجازهٔ استفاده می‌دهد، پس سرقت آن خطرناک است. OAuth 2.0 برای delegated authorization است؛ OpenID Connect هویت را روی OAuth مشخص می‌کند. برای browser/native از flow مدرن Authorization Code با PKCE و کتابخانهٔ معتبر استفاده کن. token باید کوتاه‌عمر و محدود به audience/scope باشد.

## مثال: حساب چندمستاجره

شناسهٔ tenant را از هویت معتبر استخراج کن و درخواست سفارش را با tenant و نقش بررسی کن. فیلتر UI کنترل امنیتی نیست. برای پاسخ 404/403 و audit event سیاست یکنواخت تعریف کن و اطلاعات حساس را در log نریز.

## طراحی قدم‌به‌قدم ورود

۱. **روش ورود را بر اساس کاربر و تهدید انتخاب کن.** رمز عبور، SSO، passkey یا عامل دوم نیازهای تجربه و بازیابی متفاوت دارند. رمز خام ذخیره نمی‌شود؛ password hashing سازگار و مقابله با credential stuffing لازم است.
۲. **نشست را ایمن بساز.** شناسهٔ session تصادفی و قابل ابطال در server باشد؛ پس از ورود یا تغییر سطح دسترسی session را عوض کن. cookie را با Secure، HttpOnly و SameSite مناسب تنظیم کن؛ دفاع CSRF هنوز به معماری بستگی دارد.
۳. **برای client ثالث flow استاندارد بگیر.** OAuth 2.0 چارچوب authorization است و OpenID Connect اطلاعات هویت را تعریف می‌کند. برای client عمومی از Authorization Code + PKCE و redirect URI دقیق استفاده کن؛ flowهای قدیمی را پیش‌فرض نکن. identity provider معتبر را با کتابخانهٔ رسمی وصل کن.
۴. **token را محدود کن.** expiry، audience، scope و issuer را بررسی کن. access token کوتاه‌عمر باشد؛ refresh token را محافظت، بچرخان و در صورت امکان revoke کن. JWT امضاشده الزاماً رمزگذاری نشده؛ محتوا را محرمانه فرض نکن.
۵. **خروج و compromise را طراحی کن.** خروج، تغییر رمز، حذف دستگاه و رخداد مشکوک باید session/token مربوط را revoke کند. token کاملاً stateless ممکن است تا پایان عمر قابل استفاده بماند؛ trade-off ابطال را آگاهانه بپذیر.

## مجوزدهی: نقش کافی نیست

RBAC برای نقش‌های نسبتاً پایدار مثل customer، support و admin ساده است. اما شرط «کاربر فقط سند خودش را در tenant خودش و تا وقتی وضعیت باز است تغییر دهد» به resource و context وابسته است؛ policy مبتنی بر ویژگی ممکن است لازم باشد. دسترسی را بر اساس subject، action، resource، context، مالکیت، tenant، وضعیت دامنه و سیاست صریح allow/deny بسنج.

### مثال حل‌شده: پشتیبانی و بازپرداخت

- **هویت:** کارمند support با MFA و session سازمانی.
- **مشاهدهٔ سفارش:** فقط برای ticket دارای هدف مشخص و tenant مجاز.
- **بازپرداخت:** permission جدا، سقف مبلغ، وضعیت پرداخت معتبر و شاید تأیید دوم.
- **audit:** ثبت actor، resource، action، نتیجه و reason؛ token، password و اطلاعات پرداخت حساس ثبت نشود.
- **آزمون:** customer دیگر، tenant دیگر، سفارش لغوشده، مبلغ بالاتر از سقف و session منقضی‌شده جداگانه بررسی شوند.

## سیاست خطا و حریم خصوصی

پاسخ 401 یعنی هویت معتبر شناسایی نشده؛ 403 یعنی هویت هست اما اجازه نیست. 404 می‌تواند برای جلوگیری از افشای وجود resource به‌کار رود، اگر رفتار کل API یکنواخت باشد. پیام خطا نباید نشان دهد شناسه متعلق به کدام کاربر است.

## فهرست بازبینی طراحی

- آیا authorization برای هر endpoint و هر object بررسی می‌شود؟
- آیا تغییر شناسه، tenant یا نقش در client بی‌اثر است؟
- آیا cache بر اساس هویت یا tenant partition شده تا دادهٔ خصوصی جابه‌جا نشود؟
- آیا دسترسی staff حداقلی، مدت‌دار و قابل‌ممیزی است؟
- آیا token، URL امضاشده یا session در log و analytics نشت نمی‌کند؟
- آیا بازیابی حساب به‌اندازهٔ ورود امن است؟ راه بازیابی ضعیف کل زنجیره را تضعیف می‌کند.

## آزمون

۱. OAuth با OIDC چه تفاوتی دارد؟ **پاسخ:** OAuth مجوز دسترسی واگذارشده را می‌دهد؛ OIDC لایهٔ هویت روی OAuth است.
۲. چرا JWT همیشه امن‌تر از session نیست؟ **پاسخ:** امضا محرمانگی یا ابطال‌پذیری نمی‌دهد؛ storage، audience و expiry مهم‌اند.
۳. IDOR را چگونه مهار می‌کنی؟ **پاسخ:** authorization مبتنی بر مالکیت یا tenant را برای هر object بررسی می‌کنی.
۴. Scope گسترده چه خطری دارد؟ **پاسخ:** در سرقت token، دامنهٔ اثر بزرگ‌تر است.

## تمرین

نقش پشتیبانی را طوری طراحی کن که سفارش مشتری مجاز را ببیند اما refund نکند. هویت، policy و audit را جدا بنویس.

## پاسخ نمونهٔ تمرین

کارمند support با identity سازمانی و MFA وارد می‌شود. policy مشاهدهٔ سفارش نیاز به ticket فعال، tenant مجاز و scope مشاهده دارد؛ refund permission جداگانه و ممنوع است. API برای هر درخواست این policy را سمت سرور می‌سنجد. audit شامل actor/resource/action/result/reason است و token، PII غیرضروری یا اطلاعات کارت را ثبت نمی‌کند.

## منابع

- فارسی: [OWASP و منابع فارسی](https://owasp.org/www-project-top-ten/)، [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)
- انگلیسی: [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)، [OAuth2 Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/OAuth2_Cheat_Sheet.html)، [OAuth Security BCP](https://oauth.net/security/)

</div>

