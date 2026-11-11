<div dir="rtl" align="right">
[English version](../../en/06-async-and-messaging/19-background-jobs/README.md)


# Background Jobs

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

پردازش پس‌زمینه درخواست تعاملی را از کار طولانی جدا می‌کند؛ پذیرش، اجرا و تحویل نتیجه مراحل مستقل‌اند.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Event-driven با رخداد شروع می‌شود؛ schedule-driven با زمان. پاسخ 202 و job id می‌دهد و وضعیت از polling/webhook/notification پیگیری می‌شود. job باید timeout، retry محدود، idempotency، progress و DLQ/manual path داشته باشد. scheduler تضمین اجرای یک‌باره نمی‌دهد.

## درس گام‌به‌گام

### چه کاری باید پس‌زمینه برود؟

کار طولانی، پرتغییر یا قابل retry را از درخواست synchronous جدا کن، به‌خصوص وقتی کاربر لازم نیست نتیجه را در همان اتصال بگیرد. نمونه‌ها: ساخت گزارش، تبدیل ویدئو، ارسال انبوه اعلان، import فایل و پردازش رویداد. اگر کار 20ms است و باید فوراً نتیجه بدهد، صف ممکن است پیچیدگی بی‌مورد باشد. اگر client منتظر 60 ثانیه بماند، timeout شبکه و تجربهٔ کاربر بد می‌شود.

### دو نوع شروع job

Event-driven job پس از رخداد کسب‌وکار آغاز می‌شود: `OrderPaid` باعث ساخت فاکتور می‌شود. رخداد باید پایدار و قابل deduplicate باشد. Schedule-driven job در زمان مشخص یا دوره‌ای اجرا می‌شود: بستن صورتحساب روزانه. ساعت سیستم، اجرای هم‌زمان چند scheduler و daylight saving می‌توانند رفتار را تغییر دهند؛ زمان‌ها را با منطقهٔ زمانی و سیاست idempotency ذخیره کن.

### چرخهٔ عمر و قرارداد نتیجه

Job را به وضعیت‌های واضح تقسیم کن: `accepted`، `queued`، `running`، `succeeded`، `failed`، `cancelled` یا `needs_attention`. پاسخ `202 Accepted` یعنی درخواست پذیرفته شده، نه اینکه نتیجه موفق است. شناسهٔ job، زمان ایجاد، مالک، progress، آخرین خطای قابل نمایش و endpoint وضعیت را بده. جزئیات حساس داخلی را به client افشا نکن.

نتیجه می‌تواند با polling، webhook، event یا notification برسد. Polling ساده است ولی polling پرتناوب خود بار می‌سازد؛ backoff و `Retry-After` کمک می‌کند. Webhook نیاز به امضای پیام، retry و dedupe دارد. نتیجهٔ طولانی را در object storage بگذار و لینک محدود/زمان‌دار ارائه کن.

### طراحی worker قابل‌بازیابی

Job payload باید کوچک و versioned باشد؛ دادهٔ بزرگ را reference بده. Worker پیش از گرفتن کار ظرفیت و dependency را بررسی کند، deadline داشته باشد، checkpointهای لازم را ثبت کند و پس از crash دوباره قابل اجرا باشد. هر تلاش شماره، زمان، خطا و correlation id داشته باشد. Retry فقط برای خطای گذرا، با backoff، jitter و سقف انجام شود. خطای دائمی مانند ورودی نامعتبر نباید بی‌پایان retry شود.

### هم‌زمانی و لغو

ممکن است scheduler و retry هر دو یک job را هم‌زمان تحویل دهند؛ lock/lease کمک می‌کند ولی به تنهایی exactly-once نمی‌دهد. Job effect را idempotent طراحی کن. لغو یعنی worker سیگنال را ببیند و در نقطهٔ امن متوقف شود؛ اگر side effect پرداخت انجام شده، صرفاً تغییر وضعیت به `cancelled` کافی نیست و باید عملیات جبرانی تعریف شود.

### عملیات و هزینه

صف هرگز نباید بی‌نهایت رشد کند. oldest-job age، backlog، نرخ پذیرش/تکمیل، retry، DLQ و زمان اجرای هر نوع job را پایش کن. برای priority، tenant و workload سنگین سهم/ظرفیت جدا بگذار تا یک import طولانی اعلان‌های فوری را عقب نیندازد. retention نتیجه و payload را با privacy و نیاز audit هماهنگ کن.

## مثال عملی

گزارش ماهانه سریع job id می‌گیرد و پس از ساخته‌شدن لینک امن تحویل داده می‌شود.

## نمونهٔ قرارداد / شبه‌کد

~~~text
HTTP 202 Accepted {job_id: rpt-8f2, status_url: /jobs/rpt-8f2}
~~~

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

صف پایدار برای کار قابل‌بازیابی؛ in-memory برای کار غیرحیاتی کوتاه. schedule را با idempotency ترکیب کن.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- گم‌شدن کار پس از 202؛ retry نامحدود؛ نتیجه بی‌وضعیت؛ ارسال ایمیل تکراری.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. 202 چه چیزی را تضمین نمی‌کند؟
2. چرا job باید idempotent باشد؟
3. سه روش رساندن نتیجه را نام ببر.

### پاسخ‌نامهٔ فشرده

1. 202 یعنی درخواست پذیرفته شده؛ نه اینکه کار کامل یا حتی موفق شده باشد.
2. scheduler، broker یا client می‌تواند همان کار را دوباره اجرا کند پس اثر تجاری نباید تکراری شود.
3. polling status endpoint، webhook، event/notification یا ایمیل.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

پردازش پس‌زمینه درخواست تعاملی را از کار طولانی جدا می‌کند؛ پذیرش، اجرا و تحویل نتیجه مراحل مستقل‌اند. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [معماری وب و اجزای یک سامانه](https://virgool.io/Quera-Mag/%D9%85%D8%B9%D9%85%D8%A7%D8%B1%DB%8C-%D9%88%D8%A8-%D8%A2%D8%B4%D9%86%D8%A7%DB%8C%DB%8C-%D9%85%D9%81%D8%A7%D9%87%DB%8C%D9%85-%D9%BE%D8%A7%DB%8C%D9%87-ofbcud4oao0c)

### منابع انگلیسی و تجربه‌های مهندسی

- [Azure: Background jobs](https://learn.microsoft.com/en-us/azure/architecture/best-practices/background-jobs)
- [AWS SQS: Best practices](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-best-practices.html)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

