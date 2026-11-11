<div dir="rtl" align="right">
[English version](../../en/06-async-and-messaging/21-messaging-patterns/README.md)


# الگوهای Messaging

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

الگوی پیام باید ترتیب، فشار، دوام و مالکیت workflow را مشخص کند؛ payload کوچک و correlation‌دار نگه‌دار.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Pub/Sub fan-out می‌دهد؛ competing consumers throughput را بالا می‌برند؛ queue leveling burst را صاف می‌کند. Priority queue مراقب starvation است. Pipes & Filters مراحل را جدا می‌کند. Claim Check دادهٔ بزرگ را بیرون broker می‌گذارد. Async request-reply به correlation id نیاز دارد. Sequential convoy ترتیب می‌دهد اما head-of-line blocking دارد. Scheduler-Agent-Supervisor اجرای زمان‌دار را پایش می‌کند. Choreography هماهنگی را بین eventها پخش می‌کند.

## درس گام‌به‌گام: الگوها و زمان کاربرد

### Publisher/Subscriber

Publisher رخداد را یک بار منتشر می‌کند؛ چند subscription می‌توانند مستقل آن را مصرف کنند: `OrderPaid` برای ساخت فاکتور، امتیاز وفاداری و اعلان. Producer از زمان/مکان مصرف‌کننده خبر ندارد، اما schema، version و semantics رخداد باید پایدار باشند. subscriber جدید ممکن است replay بخواهد؛ retention و امکان backfill را طراحی کن.

### Competing Consumers

چند worker از یک صف یا subscription مشترک کار می‌گیرند و ظرفیت موازی می‌شود. هر worker باید stateless یا stateش بیرونی باشد و duplicate امن باشد. ترتیب کل صف معمولاً از بین می‌رود؛ اگر ترتیب هر سفارش لازم است، کلید را partition کن. تعداد worker بی‌حد downstream را overload می‌کند.

### Queue-Based Load Leveling و Priority Queue

Load leveling بین burst ورودی و نرخ ثابت worker حائل می‌سازد. سقف backlog و deadline را تعیین کن؛ ردکردن زودهنگام گاهی از پذیرش کاری که هرگز به‌موقع اجرا نمی‌شود بهتر است. Priority queue کار فوری را زودتر می‌فرستد، ولی اگر high-priority پیوسته برسد، low-priority گرسنه می‌شود. aging، سهمیه و جداسازی classها راه‌های کنترل‌اند.

### Pipes & Filters

کار بزرگ به مراحل کوچک تبدیل می‌شود: parse، validate، enrich، persist. هر filter ورودی/خروجی و خطای مشخص دارد و می‌تواند مستقل scale شود. مزیت جایگزینی/موازی‌سازی است؛ هزینهٔ serialization، چند queue، tracing و احتمال تکرار بین مراحل. پیام هر مرحله باید version و correlation id حمل کند.

### Sequential Convoy

وقتی ترتیب برای یک entity مهم است، پیام‌های همان key را سری پردازش کن. مثال: تغییر وضعیت یک سفارش نباید قبل از ایجاد سفارش پردازش شود. ترتیب جهانی را تحمیل نکن؛ معمولاً ترتیب per key کافی است. پیام poison در ابتدای convoy می‌تواند پیام‌های بعدی را معطل کند، پس dead-letter و سیاست skip/repair لازم است.

### Claim Check

برای فایل بزرگ، payload را در object storage نگه‌دار و یک reference کوچک در پیام بفرست. object باید پیش از پیام در دسترس باشد، lifecycle و permission روشن داشته باشد و reference نسخه‌دار باشد. consumer باید پس از پردازش retention را رعایت کند. URL امضاشده را داخل log عمومی یا صف با دسترسی وسیع نگذار.

### Async Request-Reply

Client درخواست را با correlation id می‌فرستد و سریع شناسهٔ پیگیری می‌گیرد؛ پاسخ بعداً در reply queue، callback یا status store می‌آید. timeout کلاینت به معنای لغو job نیست. dedupe، expiry، ownership و نگهداری پاسخ لازم‌اند. این الگو برای کار چندثانیه‌ای یا طولانی مناسب است؛ برای پاسخ فوری REST ساده‌تر است.

### Choreography

سرویس‌ها به event واکنش می‌دهند و مرحلهٔ بعدی را منتشر می‌کنند. coupling مستقیم کم و افزودن consumer آسان است. اما مسیر کامل workflow در چند repo پراکنده می‌شود؛ correlation، audit، timeout، جبران و کشف loop سخت‌تر می‌شود. برای فرایندهای بلندمدت با شرط و جبران زیاد، یک orchestrator/saga coordinator می‌تواند روند را روشن‌تر کند.

### Scheduler-Agent-Supervisor

Scheduler کارهای زمان‌دار را انتخاب می‌کند؛ agent هر کار را اجرا می‌کند؛ supervisor وضعیت، timeout، retry و نتیجه را پایش می‌کند. job باید lease/checkpoint/idempotency داشته باشد تا leader جدید اجرای نیمه‌تمام را ادامه دهد. زمان‌بندی مرکزی بدون نظارت بر completion صرفاً یک trigger است و تضمین پایان موفق نمی‌دهد.

## مثال عملی

بازپرداخت: پیام کوچک order id و version دارد؛ worker idempotent است؛ نتیجه به رخداد جداگانه تبدیل می‌شود.

## تجربهٔ موردی واقعی منتشرشده

[Uber Cherami: fan-out، competing consumers و redelivery](https://www.uber.com/us/en/blog/cherami-message-queue-system/) — مطالعهٔ موردی عمومی است؛ آن را با نسخه و محدودیت‌های زمان انتشار بخوان.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

ترتیب را به یک key محدود کن؛ orchestration برای workflow دارای جبران شفاف؛ choreography برای واکنش‌های مستقل.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- ack پیش از commit؛ DLQ فراموش‌شده؛ payload بزرگ/PII؛ starvation؛ correlation id گم‌شده.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. Claim Check چه می‌کند؟
2. ترتیب یک سفارش چطور حفظ می‌شود؟
3. Choreography چه دشواری‌ای دارد؟

### پاسخ‌نامهٔ فشرده

1. reference به دادهٔ بیرون broker می‌دهد تا پیام payload بزرگ حمل نکند.
2. key/partition و پردازش سری برای همان key، با idempotency در redelivery.
3. رخدادها بین سرویس‌ها پخش‌اند؛ فهم جریان، tracing، تعارض و جبران دشوارتر می‌شود.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

الگوی پیام باید ترتیب، فشار، دوام و مالکیت workflow را مشخص کند؛ payload کوچک و correlation‌دار نگه‌دار. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [راهنمای فارسی معماری رویدادمحور](https://github.com/gloonch/eventdrivenfarsi)

### منابع انگلیسی و تجربه‌های مهندسی

- [Azure Architecture Center: Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [AWS SQS: Best practices](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-best-practices.html)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

