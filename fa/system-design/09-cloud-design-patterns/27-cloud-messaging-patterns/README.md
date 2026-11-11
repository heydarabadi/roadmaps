<div dir="rtl" align="right">
[English version](../../../../en/system-design/09-cloud-design-patterns/27-cloud-messaging-patterns/README.md)


# الگوهای Cloud برای Messaging

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

الگوی پیام‌رسانی فشار، ترتیب و workflow را اداره می‌کند؛ مرز delivery و جبران را مشخص کن.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Sequential Convoy ترتیب پیام هم‌کلید دارد؛ Scheduler-Agent-Supervisor job زمان‌دار و خرابی را پایش می‌کند. Queue-based Load Leveling burst را نگه می‌دارد؛ Pub/Sub fan-out می‌کند؛ Priority Queue باید starvation را مهار کند. Pipes & Filters مراحل را جدا؛ Competing Consumers موازی؛ Choreography وابستگی مستقیم را کم اما جریان را پخش می‌کند. Claim Check دادهٔ بزرگ را بیرون broker می‌گذارد؛ Async Request-Reply correlation id می‌خواهد.

## مرور همهٔ ریزموضوع‌های roadmap

- Sequential Convoy: ترتیب پردازش پیام‌های یک جریان/کلید.
- Scheduling Agent Supervisor: زمان‌بندی، اجرای agent و پایش/بازیابی آن.
- Queue-Based Load Leveling: صف بین ورودی و ظرفیت مصرف‌کننده.
- Publisher/Subscriber: یک انتشار برای چند مشترک.
- Priority Queue: ترتیب براساس اولویت؛ مراقب گرسنگی.
- Pipes and Filters: پردازش مرحله‌ای پیام.
- Competing Consumers: چند worker یک صف را موازی مصرف می‌کنند.
- Choreography: سرویس‌ها با event هماهنگ می‌شوند.
- Claim Check: payload بزرگ بیرون پیام و reference در آن.
- Async Request-Reply: پاسخ دیررس با correlation id.

## درس گام‌به‌گام

### پیام‌ها را براساس رفتار، نه broker نام‌گذاری کن

پیش از انتخاب فناوری، مشخص کن پیام کار (task) است یا واقعیت رخ‌داده (event)، چند مصرف‌کننده دارد، replay لازم است یا نه، ترتیب در چه دامنه‌ای مهم است، payload چه اندازه‌ای دارد و چه زمانی باید تمام شود. سپس semantics broker را بررسی کن: durability، retention، ack، redelivery، partition، ordering، dead-letter، transaction و security.

### الگوها در کنار هم

- Queue-Based Load Leveling burst را تا سقف ظرفیت جذب می‌کند؛ bounded backlog و oldest age لازم دارد.
- Publisher/Subscriber یک event را به subscriptionهای مستقل می‌رساند؛ schema و replay مهم‌اند.
- Competing Consumers یک queue را موازی مصرف می‌کنند؛ سرعت بالا می‌رود ولی ترتیب جهانی نداریم.
- Priority Queue فوری‌ها را جلو می‌اندازد؛ starvation با aging یا سهمیه کنترل می‌شود.
- Pipes & Filters کار را به مراحل مستقل می‌شکند؛ هر stage باید retry و input/output version داشته باشد.
- Sequential Convoy ترتیب پیام‌های یک key را حفظ می‌کند؛ partition داغ و پیام poison را مدیریت کن.
- Claim Check payload بزرگ را به object storage می‌برد؛ پیام reference امن و versionدار دارد.
- Async Request-Reply درخواست و پاسخ دیررس را با correlation id پیوند می‌دهد؛ timeout به معنی لغو نیست.
- Choreography سرویس‌ها را با event هماهنگ می‌کند؛ tracing و جبران باید مستقل طراحی شوند.
- Scheduler-Agent-Supervisor trigger، worker و recovery job طولانی را اداره می‌کند؛ checkpoint و lease لازم‌اند.

### Delivery، ack و تضمین واقعی

At-least-once یعنی پیام می‌تواند دوباره برسد. Consumer باید قبل از ack اثر را پایدار کند و برای crash بین commit و ack idempotency داشته باشد. At-most-once ممکن است در failure پیام را حذف کند. Exactly-once را فقط با محدودهٔ دقیق ادعا کن: اگر side effect در DB یا provider بیرونی است، broker transaction به تنهایی آن را اتمیک نمی‌کند. Outbox در producer و inbox/dedupe در consumer کمک می‌کنند مرزهای محلی قابل اعتماد باشند.

### Ordering و concurrency

ترتیب per partition/key معمولاً دست‌یافتنی‌تر از ترتیب کل سامانه است. اگر تمام سفارش‌ها key واحد داشته باشند، concurrency از بین می‌رود؛ اگر key هر پیام متفاوت باشد، ترتیب یک سفارش هم حفظ نمی‌شود. کلیدی انتخاب کن که هم consistency دامنه را نگه دارد و هم بار را پخش کند. Consumer کند می‌تواند بقیهٔ همان partition را متوقف کند؛ batching و parallelism باید ترتیب را نسازند.

### Retry و poison message

Retry delay و maximum attempts داشته باشد. خطای transient به retry می‌رود؛ خطای دائمی/دادهٔ malformed به DLQ. DLQ باید owner، alert، retention، ابزار inspect و تصمیم replay/skip داشته باشد. Replay با نسخهٔ فعلی consumer ممکن است نتیجه‌ای متفاوت از گذشته بدهد؛ replay را در محیط و با idempotency امن کن.

### انتخاب در سناریوی سفارش

ثبت `OrderCreated` می‌تواند pub/sub باشد؛ تخصیص کار ارسال با competing consumer؛ بایت‌های فاکتور با claim check؛ ترتیب وضعیت هر سفارش با partition key برابر order id؛ burst کمپین با queue leveling؛ تأیید نتیجهٔ بلندمدت با async request-reply. هر پیام correlation id، event id، schema version و حداقل دادهٔ لازم را داشته باشد. Secret، شماره کارت و payload غیرضروری در broker پیام قرار نده.

برای walkthrough کامل تمام patternها و مثال‌هایشان، [درس الگوهای Messaging](../../06-async-and-messaging/21-messaging-patterns/README.md) را هم بخوان.

## مثال عملی

برای بازپرداخت، command در صف durable قرار می‌گیرد؛ consumer idempotent می‌ماند؛ نتیجه و اعلان مراحل جدا هستند.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

ترتیب را به partition/key محدود کن؛ workflow با جبران پیچیده به orchestrator نیاز دارد.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- ack زودرس؛ DLQ بدون مالک؛ payload بزرگ؛ انتظار ترتیب میان partitionها؛ retry بی‌نهایت.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. Competing consumers چه تغییری در ترتیب می‌دهند؟
2. DLQ چه زمانی کمک می‌کند؟
3. correlation id چه چیزی را پیوند می‌دهد؟

### پاسخ‌نامهٔ فشرده

1. consumerهای متعدد روی یک queue ممکن است کارها را به ترتیب متفاوت بگیرند؛ partition/key برای ترتیب لازم.
2. پیام poison پس از تلاش محدود به DLQ می‌رود تا حلقهٔ بی‌نهایت را متوقف و بررسی کند.
3. درخواست async اولیه و پاسخ/رخداد نهایی را از روی correlation id جفت می‌کند.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

الگوی پیام‌رسانی فشار، ترتیب و workflow را اداره می‌کند؛ مرز delivery و جبران را مشخص کن. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [Kafka و سیستم‌های توزیع‌شده](https://www.dntips.ir/post/2822)

### منابع انگلیسی و تجربه‌های مهندسی

- [Azure Architecture Center: Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
- [AWS SQS: Best practices](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-best-practices.html)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

