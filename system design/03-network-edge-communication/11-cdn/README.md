<div dir="rtl" align="right">
[English version](../../en/03-network-edge-communication/11-cdn/README.md)


# CDN و توزیع محتوا

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

CDN محتوای قابل‌کش را نزدیک کاربر می‌دهد تا RTT و بار origin کم شود؛ سیاست cache و invalidation بخش اصلی طراحی است.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Pull CDN در اولین miss از origin می‌گیرد؛ Push محتوا را از پیش به edge می‌فرستد. Cache-Control، کلید cache، versioning، purge و تفکیک محتوای شخصی ضروری‌اند. CDN می‌تواند برای API هم سودمند باشد، ولی با cache key امن و سیاست freshness. TLS/WAF و origin shielding نیز می‌توانند در edge باشند.

## درس گام‌به‌گام

### CDN دقیقاً چه چیزی را نزدیک می‌کند؟

CDN شبکه‌ای از نقاط حضور (PoP) دارد. کاربر معمولاً به نقطهٔ نزدیک route می‌شود؛ edge می‌تواند فایل یا پاسخ cacheشده را بدهد. در cache hit، درخواست به origin نمی‌رسد. در miss، edge محتوا را از origin می‌گیرد و بر اساس policy نگه می‌دارد. سود فقط latency نیست: پهنای‌باند origin و احتمال overload آن هم کم می‌شود. محتوای پویا، personalized و live data بدون policy خاص لزوماً cache نمی‌شوند.

### Pull در برابر Push

در Pull CDN، edge با اولین miss فایل را از origin fetch می‌کند و پس از TTL یا purge دوباره fetch می‌کند. این برای محتوایی خوب است که آدرس‌ها و تغییراتش شناخته‌شده‌اند و انتشار به همهٔ edgeها لازم نیست. Push/pre-position محتوا را پیش از درخواست در CDN بارگذاری می‌کند؛ برای ویدئوی کمپین یا انتشار قابل پیش‌بینی می‌تواند miss اولیه را کم کند، اما چرخهٔ update/delete و ظرفیت نسخه‌های قدیمی باید مدیریت شود.

### Cache key را طراحی کن

کلید cache معمولاً از host، path و برخی query/headerها ساخته می‌شود. اگر پاسخ بر اساس زبان، compression، tenant یا cookie تغییر می‌کند، این بُعد باید یا در کلید باشد یا آن پاسخ cache نشود. کلید بیش‌ازحد متنوع hit ratio را خراب می‌کند؛ کلید ناقص می‌تواند دادهٔ یک کاربر را به دیگری نشان دهد. query پارامترهای بی‌اثر را normalize کن و فقط headerهای لازم را vary بده.

### Cache-Control و تازگی

`max-age` عمر تازه‌بودن برای cacheها را تعیین می‌کند؛ `public` اجازهٔ cache مشترک می‌دهد؛ `private` برای cache مرورگر/کاربر است؛ `no-store` ذخیره‌سازی را ممنوع می‌کند. `ETag` یا `Last-Modified` امکان revalidation می‌دهد. برای فایل versioned مثل `app.a83f.js` می‌توان TTL بلند گذاشت؛ تغییر فایل، URL تازه می‌سازد. برای صفحهٔ قیمت یا موجودی، TTL کوتاه و revalidation لازم است.

### Miss storm و محافظت origin

وقتی کلید داغ منقضی می‌شود، تعداد زیادی درخواست می‌توانند هم‌زمان origin را صدا بزنند. request collapsing، stale-while-revalidate، jitter در expiry و origin shield این فشار را کم می‌کنند. برای فایل‌های بزرگ، range request، حد اندازه و caching پاسخ‌های جزئی را بررسی کن. origin نیز باید دسترسی مستقیم عمومی را محدود کند تا مهاجم از CDN عبور نکند.

### امنیت و مشاهده‌پذیری

مسیر cache باید با هویت و مجوز سازگار باشد. URL امضاشده، cookie خصوصی و headerهای authorization را بی‌بررسی cache نکن. hit ratio به تنهایی موفقیت نیست؛ stale response، origin errors، purge time و هزینهٔ egress را نیز بسنج. یک تست کوچک را با دو کاربر/tenant اجرا کن تا مطمئن شوی پاسخ private مشترک نمی‌شود.

## مثال عملی

تصویر محصول نسخه‌دار را طولانی‌مدت cache کن؛ سبد خرید با cookie کاربر را عمومی cache نکن.

## نمونهٔ قرارداد / شبه‌کد

~~~text
Cache-Control: public, max-age=31536000, immutable — فقط برای asset عمومیِ نسخه‌دار.
~~~

## تجربهٔ موردی واقعی منتشرشده

[Cloudflare: cache response rules و تصمیم‌گیری روی پاسخ origin](https://blog.cloudflare.com/introducing-cache-response-rules/) — مطالعهٔ موردی عمومی است؛ آن را با نسخه و محدودیت‌های زمان انتشار بخوان.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Cloudflare Blog](https://blog.cloudflare.com/)

مناسب assetهای عمومی و پرتکرار؛ برای دادهٔ شخصی یا خیلی پویا ابتدا تازگی و invalidation را تعیین کن.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- کلید ناقص؛ cache کردن پاسخ private؛ purge به‌جای versioning؛ origin بدون محدودسازی.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. Pull و Push CDN چه تفاوتی دارند؟
2. در cache key چه headerهایی ممکن است لازم باشند؟
3. Cookie چه خطر cacheای دارد؟

### پاسخ‌نامهٔ فشرده

1. Pull هنگام cache miss از origin می‌گیرد؛ Push/پیش‌بارگذاری، محتوا را از قبل به edgeها می‌رساند.
2. باید هر تفاوتی که پاسخ را عوض می‌کند مثل host، path، query یا header مجاز لحاظ شود؛ Cookie شخصی را جدا/غیرفعال کن.
3. چون cookie می‌تواند پاسخ مخصوص یک کاربر را عمومی کند و دادهٔ کاربران دیگر را افشا کند.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

CDN محتوای قابل‌کش را نزدیک کاربر می‌دهد تا RTT و بار origin کم شود؛ سیاست cache و invalidation بخش اصلی طراحی است. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [لایه‌های کش در نمونهٔ فروشگاهی](https://virgool.io/%40m_58197875/%D9%85%D8%B9%D9%85%D8%A7%D8%B1%DB%8C-%D9%BE%D9%86%D9%87%D8%A7%D9%86-%DA%A9%D8%B4%DB%8C%D9%86%DA%AF-%D8%AF%D8%B1-%D8%AF%DB%8C%D8%AC%DB%8C-%DA%A9%D8%A7%D9%84%D8%A7-f25nhzmvsoyl)

### منابع انگلیسی و تجربه‌های مهندسی

- [Cloudflare Learning: CDN](https://www.cloudflare.com/learning/cdn/what-is-a-cdn/)
- [Azure Architecture Center: Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
- [Cloudflare Blog](https://blog.cloudflare.com/)

</div>

