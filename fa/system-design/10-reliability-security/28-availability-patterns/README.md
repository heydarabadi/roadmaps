<div dir="rtl" align="right">
[English version](../../../../en/system-design/10-reliability-security/28-availability-patterns/README.md)


# Availability Patterns

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

دسترس‌پذیری بالا با محدودکردن blast radius، مسیر جایگزین و کنترل بار ساخته می‌شود؛ نام الگو تضمین نیست.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Deployment Stamp محیط‌های مستقل می‌سازد؛ Geodes نمونه‌های منطقه‌ای نزدیک کاربر ایجاد می‌کند و مالکیت داده لازم دارد. Throttling پیش از اشباع درخواست اضافی را رد یا محدود می‌کند. Health Endpoint وضعیت dependency را نمایان می‌کند. Queue-based leveling burst را هموار می‌کند. ظرفیت failover را برای بار منتقل‌شده هم بسنج.

## درس گام‌به‌گام

### Deployment Stamp

Stamp یک deployment نسبتاً مستقل از app، storage و ظرفیت است که tenantها یا بخشی از بار را می‌گیرد. اگر یک stamp خراب شود، دامنهٔ اثر محدود می‌ماند؛ stampهای سالم می‌توانند بار را بگیرند، به شرط آنکه ظرفیت رزرو شده باشد. تقسیم tenant باید ثابت یا قابل جابه‌جایی باشد، و عملیات deploy/upgrade بین stampها سازگار بماند. Stampهای بسیار کوچک هزینهٔ عملیاتی بالا و بسیار بزرگ blast radius بزرگ دارند.

### Geodes و منطقه‌بندی جغرافیایی

Geode نمونهٔ سامانه در یک منطقه است که کاربران را نزدیک‌تر سرویس می‌دهد. routing باید به region نزدیک، ظرفیت و سلامت توجه کند. مشکل اصلی داده است: آیا هر entity یک region owner دارد؟ replication چه latency دارد؟ اگر دو region هم‌زمان بنویسند conflict را چه کسی حل می‌کند؟ برای data residency نیز محل ذخیره و backup باید با سیاست حقوقی سازگار باشد. چند region فعال بدون ownership روشن، دادهٔ ناسازگار می‌سازد.

### Throttling و admission control

Throttling نرخ درخواست را محدود می‌کند تا سیستم زیر overload به مسیر حیاتی پاسخ دهد. Token bucket burst محدود را اجازه می‌دهد و نرخ میانگین را کنترل می‌کند؛ leaky bucket خروجی هموارتر می‌سازد؛ fixed window ساده ولی مرز زمانی burst ایجاد می‌کند؛ sliding window دقیق‌تر ولی هزینه‌دارتر است. limit را بر اساس user/tenant، نوع endpoint و هزینهٔ درخواست بساز. پاسخ 429، retry-after و سیاست client روشن باشد. Throttle باید با ظرفیت downstream تنظیم شود و راه bypass داخلی/مجاز نیز کنترل‌شده باشد.

### Health Endpoint Monitoring

Liveness می‌گوید process نیاز به restart دارد یا نه؛ readiness می‌گوید از load balancer ترافیک بگیرد یا نه. Startup probe می‌تواند initialization طولانی را پوشش دهد. هر health endpoint را به اندازهٔ لازم عمیق کن: چک وابستگی همهٔ سرویس‌ها در هر probe می‌تواند outage آبشاری بسازد. synthetic check از مسیر کاربر نیز خطای ترکیب‌شدهٔ DNS، TLS، API و DB را می‌بیند.

### Queue-Based Load Leveling

Queue میان سرعت ورود و ظرفیت worker buffer می‌سازد. عمق، سن قدیمی‌ترین پیام و اعتبار زمانی کار را پایش کن. برای taskی که تا 2 دقیقه ارزش دارد، صفی با age ده دقیقه «در دسترس» نیست. backlog سقف، producer admission، worker scaling و DLQ باید با هم تعریف شوند. Queue outage نیز باید behavior داشته باشد: رد کنترل‌شده، ذخیرهٔ موقت یا degraded mode.

### کنار هم گذاشتن الگوها

این الگوها را برای failure domainهای جدا ترکیب کن: stamps برای جداسازی tenant، geodes برای جداسازی منطقه، throttling برای حفظ ظرفیت، health برای تشخیص آمادگی و queue برای burst. اما common dependency، control-plane، identity و storage مشترک را بررسی کن؛ هرکدام می‌توانند همهٔ stampها را هم‌زمان خراب کنند.

## مرور همهٔ ریزموضوع‌های roadmap

- Deployment Stamps: نمونه‌های مستقل برای tenant/بار و محدودکردن شعاع خرابی.
- Geodes: deploymentهای جغرافیایی برای latency و تداوم منطقه‌ای.
- Throttling: محدودکردن درخواست بیش‌ازظرفیت.
- Health Endpoint Monitoring: سنجش آماده‌بودن و وابستگی‌ها.
- Queue-Based Load Leveling: جذب burst تا سقف backlog.

## مثال عملی

در قطعی region، region سالم باید ظرفیت اضافه داشته باشد وگرنه با failover خودش نیز می‌افتد.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

stamp برای جداسازی tenant/استقرار؛ geode برای latency منطقه‌ای؛ throttling برای حفظ مسیر حیاتی زیر فشار.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- ظرفیت failover load-test نشده؛ health endpoint اطلاعات حساس؛ صفی که خرابی را فقط عقب می‌اندازد؛ throttle ناعادلانه.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. Deployment Stamp چه مرزی ایجاد می‌کند؟
2. چرا ظرفیت failover را باید آزمود؟
3. throttle با صف چه تفاوتی دارد؟

### پاسخ‌نامهٔ فشرده

1. مرز استقرار/داده/ظرفیت مستقل برای محدودکردن blast radius.
2. region پشتیبان باید ظرفیت اوج منتقل‌شده را داشته باشد؛ در غیر این صورت failover cascade می‌سازد.
3. throttle مقدار ورودی را کنترل/رد می‌کند؛ queue کار را می‌پذیرد و با افزودن تاخیر بعداً پردازش می‌کند.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

دسترس‌پذیری بالا با محدودکردن blast radius، مسیر جایگزین و کنترل بار ساخته می‌شود؛ نام الگو تضمین نیست. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [معماری وب و اجزای یک سامانه](https://virgool.io/Quera-Mag/%D9%85%D8%B9%D9%85%D8%A7%D8%B1%DB%8C-%D9%88%D8%A8-%D8%A2%D8%B4%D9%86%D8%A7%DB%8C%DB%8C-%D9%85%D9%81%D8%A7%D9%87%DB%8C%D9%85-%D9%BE%D8%A7%DB%8C%D9%87-ofbcud4oao0c)

### منابع انگلیسی و تجربه‌های مهندسی

- [Azure Architecture Center: Resiliency](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/)
- [AWS: Multi-Region fundamentals](https://docs.aws.amazon.com/whitepapers/latest/aws-fault-isolation-boundaries/multi-region-fundamentals.html)
- [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

