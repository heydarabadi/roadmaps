<div dir="rtl" align="right">

# Proxy، Load Balancer و Firewall

Reverse proxy جلوی server قرار می‌گیرد و TLS termination، routing، header handling یا cache انجام می‌دهد. Forward proxy معمولاً به نمایندگی از client بیرون می‌رود. Load balancer درخواست را میان instanceها پخش می‌کند؛ الگوریتم، health check، session affinity و zone failure رفتار سیستم را تغییر می‌دهند. Firewall قواعد ترافیک ورودی/خروجی را enforce می‌کند؛ WAF روی الگوهای HTTP application-layer تمرکز دارد.

مسیر traffic و trust boundary را ترسیم کن. معلوم کن کدام hop client IP را معتبر منتقل می‌کند، TLS کجا خاتمه می‌یابد، backendها چطور محافظت می‌شوند و health check چه چیزی را واقعاً آزمایش می‌کند. Load balancer دسترس‌پذیری application را با probe سطح TCP تضمین نمی‌کند.

## مسیر ورودی را طراحی کن

در معماری معمول، DNS/CDN یا edge ترافیک را می‌گیرد؛ reverse proxy TLS را خاتمه می‌دهد و route می‌کند؛ WAF قواعد HTTP را اعمال می‌کند؛ load balancer میان instanceهای سالم توزیع می‌کند؛ application به دیتابیس دسترسی محدود دارد. این طرح باید مشخص کند TLS در کجا خاتمه می‌یابد، credential بین hopها چگونه حفاظت می‌شود و backend از دسترسی مستقیم اینترنت بسته است یا نه.

## health و توزیع بار

Readiness می‌گوید instance برای دریافت درخواست تازه آماده است؛ liveness نشان می‌دهد process گیر نکرده است؛ startup probe فرصت آغاز می‌دهد. هر probe نباید الزاماً همهٔ وابستگی‌ها را چک کند: اگر دیتابیس کوتاه‌مدت کند شد و تمام instanceها liveness خود را fail کنند، restart storm می‌سازیم. health check را با هدف و پیامدش تعریف کن.

Round robin برای توزیع ساده است؛ least connections یا الگوریتم‌های دیگر بسته به طول درخواست کمک می‌کنند. Session affinity می‌تواند state را به instance ببندد و failover را دشوار کند؛ ترجیحاً state را بیرون process نگه دار. zone-aware balancing و drain اتصال هنگام deploy را هم در نظر بگیر.

## اعتماد به header و firewall

X-Forwarded-For و مشابه را فقط از proxyهای مورداعتماد بپذیر؛ اینترنت‌کاربر می‌تواند header را جعل کند. زنجیرهٔ proxy و تعداد hop را دقیق تنظیم کن. Firewall قاعدهٔ شبکه و جهت ترافیک را اعمال می‌کند؛ WAF حملات HTTP مشخص را فیلتر می‌کند و جای اعتبارسنجی، مجوز یا patch را نمی‌گیرد.

## نمونهٔ دسترس‌پذیری

برای API دو zone با health check واقعی، اتصال drain هنگام deploy، حد retry و timeout تعریف کن. probe باید readiness برنامه را بسنجد؛ آزمون synthetic از بیرون مسیر کامل را پایش کند. load balancer به‌تنهایی redundancy دیتابیس، موفقیت failover یا درست‌بودن backup را تضمین نمی‌کند.

## آزمون

۱. Reverse proxy برای چیست؟ **پاسخ:** واسطهٔ ورودی برای clientها و کنترل route، TLS یا cache.
۲. health check ضعیف چه مشکلی دارد؟ **پاسخ:** instance ظاهراً زنده اما فاقد وابستگی لازم را سالم اعلام می‌کند یا برعکس.
۳. WAF firewall عمومی را جایگزین می‌کند؟ **پاسخ:** خیر؛ لایهٔ دفاعی تخصصی HTTP است.
۴. چرا اعتماد به X-Forwarded-For خطرناک است؟ **پاسخ:** اگر از proxy معتبر نیامده باشد، client می‌تواند آن را جعل کند.

## تمرین

ورودی امن یک API را با CDN/reverse proxy، WAF، load balancer، service و database رسم کن و trust boundaryها را مشخص کن.

## پاسخ نمونهٔ تمرین

مرز اعتماد از CDN/WAF به reverse proxy، load balancer و service مشخص است؛ backend مستقیم public نیست. TLS termination و mTLS/شبکهٔ داخلی تعریف می‌شود؛ forwarded client IP فقط از proxyهای مجاز پذیرفته می‌شود. firewall portهای حداقلی را باز می‌کند؛ DB فقط از service network قابل‌دسترسی است. Readiness از app و synthetic external probe کل مسیر را بررسی می‌کند.

## منابع

- فارسی: [مقالهٔ زیرساخت Docker و Kubernetes](https://codity.ir/devops-infrastructure-docker-kubernetes/)، [یادداشت‌های فارسی شبکه و عملیات](https://devdocs.ir/)
- انگلیسی: [AWS Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/)، [Cloudflare Learning Center: Proxy](https://www.cloudflare.com/learning/cdn/glossary/reverse-proxy/)

</div>

