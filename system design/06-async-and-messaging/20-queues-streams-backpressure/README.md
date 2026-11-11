<div dir="rtl" align="right">
[English version](../../en/06-async-and-messaging/20-queues-streams-backpressure/README.md)


# Queue، Stream و Backpressure

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

ناهمگامی تولیدکننده را از مصرف‌کننده جدا می‌کند؛ بدون backpressure صف به انبار نامحدود تأخیر تبدیل می‌شود.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Task queue معمولاً یک worker کار را می‌گیرد؛ pub/sub رخداد را به چند مشترک می‌رساند؛ log stream پیام و offset را برای replay نگه می‌دارد. تحویل غالباً at-least-once است و consumer باید idempotent باشد. Bounded queue، pause، rate control یا load shedding ظرفیت را محدود می‌کنند. lag و age پیام را پایش کن.

## درس گام‌به‌گام

### صف چه جداسازی‌ای می‌سازد؟

Producer یک کار را durable می‌فرستد؛ consumer آن را در زمان و ظرفیت خودش برمی‌دارد. Producer لازم نیست بداند کدام instance کار را اجرا می‌کند. صف burst کوتاه را جذب می‌کند و producer/consumer را از نظر زمان جدا می‌سازد، اما مجموع کار را حذف نمی‌کند. اگر ورودی به‌طور دائم از نرخ پردازش بیشتر باشد، backlog تا پرشدن storage یا پایان اعتبار داده رشد می‌کند.

### Task queue، message queue و stream

Task queue یک واحد کار را به worker می‌دهد و پس از موفقیت ack می‌شود. Pub/Sub یک پیام را به چند subscription می‌رساند؛ هر subscription باید offset/ack خود را داشته باشد. Log-based stream پیام‌های append-only را برای بازه‌ای نگه می‌دارد و consumer با offset می‌خواند، پس می‌تواند replay یا consumer مستقل داشته باشد. Kafka نمونهٔ stream؛ SQS/RabbitMQ نمونه‌های queue messaging با semantics متفاوت‌اند. نام محصول تعیین‌کنندهٔ رفتار دقیق نیست؛ retention، delivery، partition و ack را بررسی کن.

### Delivery semantics

At-most-once پیام گم نمی‌شود که دوباره پردازش شود، اما ممکن است از دست برود. At-least-once از دست‌رفتن را با redelivery محدود می‌کند، پس duplicate محتمل است. «Exactly once» معمولاً در مرز محدودی مثل transaction داخل broker معنا دارد؛ اثر end-to-end روی DB، ایمیل، پرداخت و سرویس بیرونی بدون طراحی idempotency/transaction تضمین نمی‌شود. consumer ابتدا اثر را پایدار، سپس ack کند؛ اگر crash بین این دو باشد، redelivery باید بی‌خطر باشد.

### Ordering و partition

ترتیب معمولاً در یک queue یا یک partition/key تضمین می‌شود، نه در کل cluster. اگر همهٔ پیام‌ها یک partition داشته باشند، ترتیب ساده ولی throughput محدود است. partition key مثل `order_id` همهٔ تغییرهای یک سفارش را کنار هم می‌برد؛ keyهای داغ می‌توانند یک partition را اشباع کنند. consumer group معمولاً هر partition را به یک consumer در همان group می‌دهد؛ تعداد consumer مفید از تعداد partitionها بیشتر نمی‌شود.

### Backpressure و ظرفیت

Backpressure تولیدکننده را با ظرفیت مصرف هم‌راستا می‌کند. راه‌ها: bounded queue با رد کنترل‌شده، credit/flow control، کندکردن producer، نرخ‌محدودسازی، pause partition یا load shedding برای کارهای کم‌اهمیت. اگر queue در حافظه است، حد اندازه و رفتار پرشدن لازم است. در broker پایدار نیز quota، retention، disk headroom و admission control ضروری‌اند.

### Retry، DLQ و poison message

Retry با تأخیر و سقف برای خطای موقت است؛ retry فوری حلقهٔ فشار می‌سازد. پیام poison بارها fail می‌شود و بقیهٔ پیام‌های همان partition را می‌بندد. پس از تعداد/مدت معین آن را به DLQ بفرست، علت را نگه‌دار، مالک و روند replay داشته باش. DLQ زباله‌دان نیست؛ محتوا می‌تواند دادهٔ حساس یا پیام تجاری مهم باشد.

### چه چیزهایی را پایش کن؟

Queue depth فقط تعداد است؛ oldest message age تأخیر تجربه را می‌سنجد. نرخ publish/consume، lag هر consumer group، retry ratio، DLQ، processing time و ظرفیت disk/memory را کنار هم بگذار. آستانه را براساس deadline کسب‌وکار تعیین کن: صف ایمیل ممکن است چند دقیقه تحمل کند، ولی رزرو موقت موجودی نه.

## مثال عملی

فروش ویژه burst را جذب می‌کند، اما اگر lag از اعتبار قیمت بگذرد worker باید سفارش را دوباره اعتبارسنجی کند.

## نمونهٔ قرارداد / شبه‌کد

~~~text
اگر صف محدود پر است، درخواست تازه را کنترل‌شده رد کن یا بار کم‌اهمیت را shed کن.
~~~

## تجربهٔ موردی واقعی منتشرشده

[Uber Cherami: صف durable و الگوی competing consumers](https://www.uber.com/us/en/blog/cherami-message-queue-system/) — مطالعهٔ موردی عمومی است؛ آن را با نسخه و محدودیت‌های زمان انتشار بخوان.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

Queue برای task حذف‌شونده؛ stream برای replay و مصرف مستقل. Broker را برای ارتباط درون یک process اضافه نکن.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- ادعای exactly-once سراسری؛ صف نامحدود؛ poison message؛ ترتیب جهانی؛ worker بیشتر از ظرفیت downstream.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. Queue و stream چه فرقی دارند؟
2. چرا at-least-once idempotency می‌خواهد؟
3. چه metricی backlog را نشان می‌دهد؟

### پاسخ‌نامهٔ فشرده

1. queue معمولاً کار را پس از ack از جریان انتظار حذف می‌کند؛ stream رکورد را نگه می‌دارد و consumer با offset مستقل replay می‌کند.
2. redelivery می‌تواند کار را تکرار کند؛ commit نتیجه و ack با عملیات idempotent هماهنگ می‌شود.
3. queue lag، oldest message age، نرخ تولید/مصرف و DLQ.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

ناهمگامی تولیدکننده را از مصرف‌کننده جدا می‌کند؛ بدون backpressure صف به انبار نامحدود تأخیر تبدیل می‌شود. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [Kafka و سیستم‌های توزیع‌شده](https://www.dntips.ir/post/2822)

### منابع انگلیسی و تجربه‌های مهندسی

- [AWS SQS: Best practices](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-best-practices.html)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

