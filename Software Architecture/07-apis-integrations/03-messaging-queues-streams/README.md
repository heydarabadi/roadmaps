<div dir="rtl" align="right">

# صف، پیام‌رسانی و جریان رویداد

Queue یک کار را برای مصرف‌کننده نگه می‌دارد؛ competing consumers کارها را میان workerها تقسیم می‌کنند. Pub/sub یک event را به چند subscriber می‌رساند. Event stream دنبالهٔ پایدار و مرتب‌شده در محدوده‌ای مانند partition است و مصرف‌کننده می‌تواند offset خود را مدیریت کند. این مدل‌ها کاربردهای یکسان ندارند.

پیام باید schema و نسخه داشته باشد، اندازه و عمرش محدود باشد، شناسهٔ هم‌بستگی داشته باشد و مصرف‌کننده تکرار را تحمل کند. Ordering معمولاً فقط داخل کلید یا partition تعریف می‌شود. Backpressure، retry policy، poison message، DLQ، retention، replay و lag را اداره کن. برای publish اتمی همراه تغییر database از outbox یا راه مشابه استفاده کن.

## مثال: سفارش

Order service ابتدا order و event موردنیاز را در transaction محلی ذخیره می‌کند؛ relay آن را به broker می‌فرستد؛ inventory consumer پیام را idempotent پردازش و نتیجه را منتشر می‌کند. سفارش تا تکمیل جریان «در حال پردازش» است. UI نباید موفقیت کامل را ادعا کند تا مصرف‌کنندهٔ ضروری تأیید نداده باشد.

## درس گام‌به‌گام: outbox تا consumer

سفارش commit شده اما publish پیام شکست می‌خورد. اگر ابتدا DB را commit کنی، crash میان DB و broker پیام را جا می‌اندازد؛ اگر ابتدا publish کنی و DB شکست بخورد، consumer دربارهٔ سفارش ناموجود می‌شنود.

۱. در transaction سفارش، رکورد outbox با event ID، type، schema version، aggregate ID و payload بنویس.
۲. relay رکوردها را با lease کوتاه می‌خواند و به broker می‌فرستد.
۳. پس از تأیید broker، رکورد را published علامت بزن. crash پس از publish و پیش از علامت ممکن است duplicate بسازد؛ consumer باید idempotent باشد.
۴. consumer در transaction خودش event ID را deduplicate و تغییر محلی را ذخیره می‌کند.
۵. consumer نتیجه را با correlation ID منتشر می‌کند؛ سفارش تا آن زمان state میانی دارد.

## انتخاب الگوی پیام

- Queue برای توزیع کار میان workerهاست؛ هر پیام معمولاً توسط عضوی از گروه مصرف می‌شود.
- Pub/sub یک رخداد را به subscriptionهای متعدد fan-out می‌کند.
- Stream برای log پایدار، offset مصرف‌کننده و replay بر اساس partition مناسب است.
- Command از receiver انجام کاری را می‌خواهد؛ event واقعیت رخ‌داده را گزارش می‌کند.

## ترتیب، partition و تغییر قرارداد

ترتیب اغلب فقط در partition تضمین می‌شود. کلید را با واحد ترتیب کسب‌وکار انتخاب کن؛ کلید سراسری parallelism را کم و کلید نامتوازن skew می‌سازد. پیام event ID، aggregate ID، زمان و schema version داشته باشد، ولی timestamp به‌تنهایی ترتیب قطعی نیست.

تغییر schema را ابتدا سازگار اضافه کن، مصرف‌کننده‌های قدیمی را پایش کن، replay پیام قدیمی را آزمایش و بعد حذف را اجرا کن. retention و replay می‌توانند دادهٔ حساس را دوباره آشکار کنند.

## عملیات قابل مشاهده

سن قدیمی‌ترین پیام، نرخ ورودی/خروجی، retry، DLQ، consumer lag، duplicate و زمان پردازش را اندازه بگیر. poison message به retry نامحدود نیاز ندارد. backpressure را با کنترل concurrency مدیریت کن؛ worker بیشتر ممکن است DB downstream را از کار بیندازد.

## آزمون

۱. Queue و pub/sub چه تفاوتی دارند؟ **پاسخ:** queue معمولاً هر کار را به یک consumer از گروه می‌دهد؛ pub/sub یک رخداد را به subscriptionهای متعدد fan-out می‌کند.
۲. چرا consumer باید idempotent باشد؟ **پاسخ:** تحویل و retry ممکن است پیام تکراری ایجاد کند.
۳. DLQ برای چیست؟ **پاسخ:** جداسازی پیام‌های ناموفق پس از policy مشخص و تحلیل/بازیابی کنترل‌شده.
۴. event با command چه تفاوتی دارد؟ **پاسخ:** event می‌گوید رخدادی اتفاق افتاده؛ command درخواست انجام کاری است.

## تمرین

برای تأیید پرداخت و به‌روزرسانی موجودی schema پیام، idempotency key، retry و DLQ policy طراحی کن.

## پاسخ نمونهٔ تمرین

پیام PaymentSettled شامل eventId، orderId، paymentId، schemaVersion، occurredAt و مبلغ/currency لازم است. consumer در transaction eventId را deduplicate و inventory reservation را finalize می‌کند. retry exponential محدود برای خطای موقت؛ poison/schema-invalid به DLQ و alert با owner. ordering بر orderId/aggregateId است، نه timestamp عمومی. replay و reconciliation مسیر بازگشت‌اند.

## منابع

- فارسی: [EventDrivenFarsi](https://github.com/gloonch/eventdrivenfarsi)، [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)
- انگلیسی: [Azure Architecture Styles: Event-driven](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven)، [AWS Event-Driven Architecture](https://aws.amazon.com/event-driven-architecture/)، [AWS transactional outbox pattern](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html)

</div>

