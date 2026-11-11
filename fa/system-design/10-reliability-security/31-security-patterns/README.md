<div dir="rtl" align="right">
[English version](../../../../en/system-design/10-reliability-security/31-security-patterns/README.md)


# Security Patterns

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

امنیت معماری با هویت قابل‌اثبات، کمترین دسترسی و مرزبندی ساخته می‌شود؛ gateway جای کنترل مجوز در سرویس مالک نیست.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Federated Identity ورود را به هویت‌گذار می‌سپارد؛ claim و توکن باید محدود باشند. Gatekeeper ورودی را اعتبارسنجی، احراز هویت و rate-limit می‌کند. Valet Key دسترسی محدود و زمان‌دار به object می‌دهد. سرویس مالک باید authorization را دوباره بررسی کند. secretها چرخش، scope محدود و logها redaction می‌خواهند.

## درس گام‌به‌گام

### Threat model را از مرزها بساز

دارایی‌ها را مشخص کن: پول، اطلاعات شخصی، فایل، حساب کاربر، کلید API و دسترس‌پذیری. بازیگرها شامل کاربر معتبر، مهاجم ناشناس، حساب compromiseشده، سرویس داخلی و operator هستند. مسیرهای داده/اعتماد را روی دیاگرام علامت بزن و برای هرکدام بپرس چه سوءاستفاده‌ای ممکن است. حداقل، هر request را از دید هویت، مجوز، validation، rate، audit و failure امن بررسی کن.

### Federated Identity

Federation احراز هویت را به Identity Provider مورد اعتماد می‌سپارد تا SSO و چرخهٔ عمر هویت مدیریت شود. OIDC بر OAuth 2.0 برای authentication ساخته شده؛ SAML در سامانه‌های سازمانی رایج است. توکن باید issuer، audience، expiry، signature و scope/claim درست داشته باشد. Access token برای audience مشخص و کوتاه‌عمر باشد؛ refresh token در client امن نگهداری شود. امضای توکن، مجوز عملیات روی هر resource را تعیین نمی‌کند.

### Gatekeeper و کنترل مرزی

Gatekeeper یا API gateway می‌تواند TLS، authentication مقدماتی، schema validation، request size limit، rate limit و audit را در ورودی اعمال کند. اما سرویس مالک باید authorization دامنه‌ای انجام دهد؛ gateway ممکن است bypass شود، route اشتباه داشته باشد یا هویت service را اشتباه منتقل کند. ورودی را allowlist و normalize کن؛ مسیرهای admin و internal نباید با ruleهای عمومی باز شوند.

### Valet Key و دسترسی مستقیم به فایل

Signed URL یا token کوتاه‌عمر اجازه می‌دهد client مستقیم به object storage بخواند/بنویسد و backend لازم نیست بایت‌های بزرگ را proxy کند. scope به یک object و operation محدود شود؛ expiry، اندازه، content type و owner بررسی شوند. اگر فایل private است، cache policy باید private باشد. URL خودش credential است: در log، analytics، referrer و chat ظاهر نشود.

### کمترین دسترسی و هویت workload

هر user/service فقط مجوز موردنیاز و مدت لازم را داشته باشد. از shared secret ثابت بین همهٔ سرویس‌ها دوری کن؛ identity کوتاه‌عمر، rotation و scope براساس environment/service بهتر است. شبکهٔ داخلی trusted فرض نشود؛ ارتباط service-to-service احراز و مجوزدهی شود. خطا در identity provider باید رفتار مشخص داشته باشد؛ fail-open می‌تواند دسترسی ناخواسته بدهد.

### Audit، داده و پاسخ رخداد

برای تغییر نقش، دسترسی به دادهٔ حساس، ایجاد signed URL و عملیات مالی رویداد audit با actor، زمان، target، correlation id و نتیجه ثبت کن. secret و payload حساس را log نکن. logها tamper-resistant، زمان‌همگام و با retention مشخص باشند. alert امنیتی باید به owner/runbook متصل شود. incidentهای دسترسی را بتوان با revoke token/credential و rotate key مهار کرد.

### چک‌لیست threat review

برای هر endpoint بنویس چه کسی می‌تواند آن را صدا بزند، روی کدام resource، با چه اندازه/نرخی، از کجا credential می‌گیرد، چه داده‌ای برمی‌گردد، چه چیزی log می‌شود و هنگام timeout/identity failure چه می‌کند. سپس positive و negative test cases را تعریف کن: مالک مجاز، user دیگر، token منقضی، scope نادرست، درخواست تکراری و payload حجیم.

## مرور همهٔ ریزموضوع‌های roadmap

- Federated Identity: واگذاری ورود/هویت به identity provider.
- Gatekeeper: کنترل ورودی، اعتبارسنجی و سیاست‌های مرزی.
- Valet Key: دسترسی محدود و مدت‌دار به منبع.

## مثال عملی

آپلود مستقیم تصویر با URL امضاشدهٔ فقط PUT و پنج‌دقیقه‌ای؛ API پس از upload مالکیت، نوع و اندازه را تأیید می‌کند.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

Federation برای SSO؛ signed URL برای فایل حجیم؛ در کنار WAF و gateway مجوز منبع را داخل سرویس حفظ کن.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- authorization فقط در gateway؛ URL افشانده؛ scope گسترده؛ audit/rotation غایب؛ fail-open.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. احراز هویت و مجوزدهی چه فرق دارند؟
2. URL امضاشده چه scope/expiry می‌خواهد؟
3. چرا سرویس داخلی هم مجوز را بررسی کند؟

### پاسخ‌نامهٔ فشرده

1. authentication هویت را اثبات می‌کند؛ authorization تعیین می‌کند آن هویت اجازهٔ چه کاری دارد.
2. resource و operation مشخص، scope حداقلی و expiry کوتاه؛ در صورت نیاز محدودیت IP/تعداد نیز.
3. شبکهٔ داخلی از پیش قابل‌اعتماد نیست و هر سرویس باید مجوز همان منبع/عملیات را کنترل کند.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

امنیت معماری با هویت قابل‌اثبات، کمترین دسترسی و مرزبندی ساخته می‌شود؛ gateway جای کنترل مجوز در سرویس مالک نیست. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [API Gateway](https://virgool.io/%40javadAgha/gateway-api-%DA%86%D9%87-%DA%A9%D8%A7%D8%B1%DB%8C-%D8%A7%D9%86%D8%AC%D8%A7%D9%85-%D9%85%DB%8C-%D8%AF%D9%87%D8%AF-mpxgnytywqua)

### منابع انگلیسی و تجربه‌های مهندسی

- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
- [Azure: Security design principles](https://learn.microsoft.com/en-us/azure/well-architected/security/principles)
- [Azure Architecture Center: Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

