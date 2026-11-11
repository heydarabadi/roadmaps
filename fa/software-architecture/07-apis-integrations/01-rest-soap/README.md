<div dir="rtl" align="right">

# REST و SOAP

API قرارداد بین مصرف‌کننده و ارائه‌دهنده است. REST سبک معماری مبتنی بر منابع، representation و semantics پروتکل است؛ هر HTTP JSON API الزاماً RESTful نیست. SOAP پیام‌محور با XML و قراردادهای رسمی مانند WSDL است و در برخی یکپارچه‌سازی‌های سازمانی، استانداردهای جانبی و قرارداد سخت‌گیرانه ارزش دارد.

در REST از resource URI و روش‌های HTTP درست استفاده کن: GET برای خواندن، POST برای ایجاد/عملیات، PUT برای جایگزینی و DELETE برای حذف؛ semantics دقیق و idempotency باید روشن باشد. status code، pagination، filtering، versioning، rate limit، error body و authentication بخشی از قراردادند. schema را با OpenAPI ثبت و تغییر شکننده را کنترل کن.

## مثال

برای سفارش، GET /orders/{id} وضعیت را می‌خواند؛ POST /orders یک سفارش می‌سازد و idempotency key می‌تواند retry client را امن‌تر کند. تغییر نام فیلد پاسخ بدون سیاست سازگاری ممکن است clientهای موبایل قدیمی را بشکند.

| رویکرد | مناسب | هزینه |
| --- | --- | --- |
| REST/JSON | API عمومی و web ecosystem | payload/round trip و قراردادن همه‌چیز در resource |
| SOAP/XML | تعامل‌های قراردادی و استانداردهای سازمانی | verbose و ابزار/پیچیدگی بیشتر |

## درس گام‌به‌گام: قرارداد ایجاد سفارش

یک API خوب رفتار موفق، خطا، امنیت و تغییر آینده را تعریف می‌کند:

۱. **منبع و عملیات:** سفارش resource است. GET برای خواندن، POST برای ایجاد، PUT برای جایگزینی کامل و DELETE برای حذف یا درخواست حذف به‌کار می‌رود. PATCH تغییر جزئی است و معنایش باید روشن باشد.
۲. **مرز ورودی:** schema، طول رشته، تعداد اقلام و دامنهٔ مقدارها را اعتبارسنجی کن. قیمت ارسالی client را معتبر فرض نکن؛ server آن را از منبع قیمت می‌گیرد.
۳. **نتیجهٔ HTTP:** ایجاد sync می‌تواند 201 و Location بدهد؛ اگر پردازش async است، 202 یعنی پذیرفته شده نه کامل. پاسخ خطا کد ماشین‌خوان، پیام امن و correlation ID داشته باشد.
۴. **تکرار:** POST به‌طور عمومی idempotent نیست. idempotency key و نگهداری نتیجه، retry کنترل‌شده را ممکن می‌کنند.
۵. **فهرست:** pagination، سقف page size، ترتیب پایدار و فیلترهای مجاز را مشخص کن؛ client نباید query دلخواه تحمیل کند.
۶. **سازگاری:** فیلد additive ممکن است امن باشد، اما تغییر معنا یا حذف فیلد client قدیمی را می‌شکند. OpenAPI را version-control کن و مصرف را پایش کن.

## semantics و caching

GET باید safe باشد و اثر کسب‌وکاری نداشته باشد؛ PUT و DELETE از نظر HTTP idempotent تعریف می‌شوند و پیاده‌سازی باید تکرار را تحمل کند. Cache-Control، ETag و conditional request انتقال را کم می‌کنند؛ برای دادهٔ شخصی shared cache و سیاست private/no-store را دقیق انتخاب کن.

Rate limit باید scope، پاسخ 429 و اطلاعات retry را مشخص کند. Timeout، اندازهٔ payload، compression و سقف concurrency هم بخشی از طراحی API هستند.

## SOAP را در زمینه‌اش بسنج

SOAP پیام XML را با envelope و قراردادهایی مانند WSDL تعریف می‌کند. قرارداد رسمی، ابزار سازمانی یا شریک legacy می‌تواند دلیل مناسبی باشد. هزینهٔ XML، ابزار و پیچیدگی را هم بسنج. تبدیل SOAP به REST صرفاً تغییر wire format نیست اگر semantics، خطا و transaction طرف مقابل ثابت باشد.

## آزمون

۱. REST و JSON API چه تفاوتی دارند؟ **پاسخ:** REST سبک معماری است؛ JSON فقط قالب داده است.
۲. چرا GET نباید عملیات تغییردهنده داشته باشد؟ **پاسخ:** cache، retry و ابزار HTTP رفتار امن/قابل‌پیش‌بینی GET را انتظار دارند.
۳. backward compatibility را چگونه حفظ می‌کنی؟ **پاسخ:** تغییر additive، قرارداد روشن، اندازه‌گیری مصرف و deprecation مرحله‌ای.
۴. چه زمانی SOAP را رد نمی‌کنی؟ **پاسخ:** وقتی قرارداد و استاندارد سازمانی/شریک به آن تکیه دارد و ابزارهایش نیاز را می‌پوشانند.

## تمرین

قرارداد API ایجاد سفارش شامل validation، error model، idempotency و version policy بنویس.

## پاسخ نمونهٔ تمرین

POST /orders بدنهٔ schemaدار می‌گیرد؛ server قیمت و مجوز را خودش حساب می‌کند. پاسخ 201 با Location برای ایجاد sync یا 202 همراه status resource برای workflow async است. خطا body ثابت code/correlation ID دارد؛ idempotency key در دامنهٔ user/order ثبت و payload متفاوت با همان key رد می‌شود. تغییر contract additive و deprecation مرحله‌ای است.

## منابع

- فارسی: [مقالات API در DNTips](https://www.dntips.ir/)، [نقشهٔ API و معماری](https://roadmap.sh/pdfs/roadmaps/software-architect.pdf)
- انگلیسی: [Microsoft API Design](https://learn.microsoft.com/en-us/azure/architecture/best-practices/api-design)، [MDN HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Overview)، [SOAP 1.2 specification](https://www.w3.org/TR/soap12/)

</div>

