<div dir="rtl" align="right">
[English version](../../en/03-network-edge-communication/12-load-balancing/README.md)


# Load Balancer و Reverse Proxy

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

Load balancer درخواست را میان نمونه‌های سالم توزیع می‌کند؛ لایه، الگوریتم، health check و session باید با ترافیک جور باشند.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

L4 بر اتصال/آدرس/پورت تصمیم می‌گیرد؛ L7 از host، path و header آگاه است. الگوریتم‌ها شامل round-robin، least-connections و hash هستند. Reverse proxy می‌تواند TLS terminate و مسیر‌دهی کند. Readiness باید ظرفیت واقعی را بسنجد. scale افقی اپ معمولاً نیازمند بیرون‌بردن session از حافظهٔ نمونه است.

## درس گام‌به‌گام

### نقش Load Balancer و Reverse Proxy

Load balancer چند backend را به‌عنوان یک مقصد قابل استفاده نشان می‌دهد و ترافیک را میانشان پخش می‌کند. Reverse proxy از دید client جلوی serverها قرار می‌گیرد و درخواست را forward می‌کند؛ می‌تواند TLS را terminate کند، headerها را تنظیم کند، route بدهد یا پاسخ را cache کند. این اصطلاح‌ها هم‌پوشانی دارند: یک reverse proxy می‌تواند load balancing انجام دهد، ولی هر proxy الزاماً توزیع بار نمی‌کند.

### L4 و L7

L4 از IP، port و connection استفاده می‌کند و معمولاً سربار کمتر و دید ساده‌تری دارد. L7 درخواست HTTP را می‌فهمد و می‌تواند `/api/orders` را به backend سفارش و `/images` را به CDN بفرستد، header یا host را بررسی کند و سیاست rate limit را اجرا کند. L7 انعطاف بیشتری دارد، اما parse، TLS و ruleها منابع و پیچیدگی می‌افزایند. انتخاب را براساس نیاز routing و performance بسنج.

### الگوریتم‌های رایج

- Round-robin: درخواست‌ها را نوبتی پخش می‌کند؛ وقتی backendها مشابه‌اند خوب است.
- Weighted round-robin: ظرفیت سرورها را وزن می‌دهد؛ وزن نادرست یا تغییر بار می‌تواند skew بسازد.
- Least connections: نمونه‌ای با اتصال کمتر را برمی‌گزیند؛ اتصال طولانی الزاماً به معنی کار بیشتر نیست.
- Random/Power of Two Choices: انتخاب تصادفی یا مقایسهٔ دو مقصد؛ معمولاً state مرکزی کم‌تری می‌خواهد.
- Consistent hashing: کلیدهای مشابه را به مقصد ثابت می‌دهد؛ مفید برای locality/cache، اما hotspot کلید باید دیده شود.

الگوریتم را در برابر توزیع واقعی مدت درخواست، ظرفیت و اتصال آزمایش کن. الگوریتم هوشمندتر اگر اطلاعات سلامت یا بار نادرست بگیرد، تصمیم بدتری می‌سازد.

### Health check، drain و session

Liveness می‌پرسد process باید restart شود یا نه؛ readiness می‌پرسد الان می‌تواند درخواست جدید بگیرد یا نه. health check نباید هر اختلال کوتاه DB باعث restart همهٔ instanceها شود و storm بسازد. هنگام deploy، instance را از مسیر انتخاب خارج کن، اتصال‌های جاری را فرصت اتمام بده (drain) و سپس terminate کن. session در حافظهٔ یک سرور sticky routing می‌خواهد و failover را سخت می‌کند؛ ترجیحاً session را بیرون اپلیکیشن ذخیره یا token امضاشده استفاده کن.

### Scale افقی و ظرفیت پایین‌دستی

قبل از افزایش backendها سقف DB، connection pool و سرویس‌های بیرونی را حساب کن. اگر هر instance 50 اتصال باز دارد، 40 instance می‌توانند 2,000 اتصال بسازند. LB باید max connection، timeout، retry و queue را با ظرفیت کل هماهنگ کند. Retry هم در client و هم در LB می‌تواند یک درخواست را چندبار تکثیر کند؛ مالکیت retry و idempotency را روشن کن.

## مثال عملی

نمونهٔ کند اما TCP سالم ممکن است درخواست بیشتری بگیرد اگر health check فقط اتصال را بسنجد.

## نمونهٔ قرارداد / شبه‌کد

~~~text
upstream api { least_conn; server api-1:8080; server api-2:8080; }
~~~

## تجربهٔ موردی واقعی منتشرشده

[Uber: GeoDNS و توزیع درخواست بین دو مرکز داده](https://www.uber.com/us/en/blog/modernizing-artifact-storage/) — مطالعهٔ موردی عمومی است؛ آن را با نسخه و محدودیت‌های زمان انتشار بخوان.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

L4 برای انتقال کم‌پیچیدگی؛ L7 برای routing HTTP؛ sticky session فقط اگر پیامدش روشن است.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- health check بیش از حد ساده؛ retry در چند لایه؛ LB واحد؛ session محلی.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. L7 چه چیزی بیشتر از L4 می‌بیند؟
2. چرا least-connections همیشه بهتر نیست؟
3. health check باید چه چیزی بسنجد؟

### پاسخ‌نامهٔ فشرده

1. L7 می‌تواند HTTP host/path/header را بخواند و route کند؛ L4 اتصال و آدرس/پورت را می‌بیند.
2. درخواست‌ها زمان/هزینهٔ متفاوت دارند؛ تعداد اتصال، CPU، session و locality ممکن است معیار بهتری باشد.
3. آمادگی واقعی سرویس و وابستگی حیاتی، بدون probe تهاجمی یا افشای داده.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

Load balancer درخواست را میان نمونه‌های سالم توزیع می‌کند؛ لایه، الگوریتم، health check و session باید با ترافیک جور باشند. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [معماری وب و اجزای یک سامانه](https://virgool.io/Quera-Mag/%D9%85%D8%B9%D9%85%D8%A7%D8%B1%DB%8C-%D9%88%D8%A8-%D8%A2%D8%B4%D9%86%D8%A7%DB%8C%DB%8C-%D9%85%D9%81%D8%A7%D9%87%DB%8C%D9%85-%D9%BE%D8%A7%DB%8C%D9%87-ofbcud4oao0c)

### منابع انگلیسی و تجربه‌های مهندسی

- [AWS: Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html)
- [Azure Architecture Center: Resiliency](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

