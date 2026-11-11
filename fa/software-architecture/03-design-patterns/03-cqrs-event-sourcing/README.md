<div dir="rtl" align="right">

# CQRS، Event Sourcing و سازگاری نهایی

## ایدهٔ مرکزی

CQRS مدل تغییر داده را از مدل خواندن جدا می‌کند؛ Event Sourcing تاریخچهٔ تغییر را به شکل رویدادهای پایدار نگه می‌دارد؛ eventual consistency یعنی ممکن است چند نما یا سرویس برای مدت کوتاه دادهٔ یکسان نبینند. این مفاهیم مکمل یکدیگرند، اما الزاماً باید با هم به‌کار نروند.

## تفاوت سه ایده

- **CQS:** یک عملیات یا state را می‌خواند یا تغییر می‌دهد.
- **CQRS:** مدل‌ها یا مسیرهای write و read را جدا می‌کند. ممکن است در یک برنامه و یک پایگاه داده باشد؛ لزوماً microservice نیست.
- **Event Sourcing:** رویدادهای دامنه منبع حقیقت‌اند و state جاری از بازپخش آن‌ها ساخته می‌شود. نیازمند versioning، snapshot، کنترل حریم خصوصی و بازسازی است.
- **Eventual consistency:** مصرف‌کننده پس از انتشار تغییر، در زمان محدود به نمای تازه می‌رسد؛ این تأخیر باید برای کاربر و عملیات قابل‌قبول باشد.

## چرخهٔ write و read را قدم‌به‌قدم طراحی کن

۱. **Command را تعریف کن:** مانند PlaceOrder؛ چه چیزی درخواست شده و چه هویت/داده‌ای برای تصمیم لازم است؟  
۲. **Invariant را در مرجع write بررسی کن:** موجودی، مالک سفارش و قواعد قیمت در نقطهٔ commit enforce می‌شوند.  
۳. **نتیجهٔ commit را نگه دار:** اگر event لازم است، آن را با تغییر اصلی اتمی ثبت کن؛ outbox مانع گم‌شدن پیام میان commit و publish می‌شود.  
۴. **مصرف‌کننده را idempotent بساز:** شناسهٔ پیام/نسخه را ثبت کن تا تحویل مجدد اثر دوباره نگذارد.  
۵. **Projection را به‌روز کن:** read model فقط دادهٔ لازم query را ذخیره کند؛ projection باید قابل rebuild و سنجش lag باشد.  
۶. **تجربهٔ کاربر را تعریف کن:** تا قبل از تازه‌شدن view چه وضعیت و timestampی نشان داده می‌شود؟ کاربر retry می‌کند یا صفحه را refresh؟

Event در Event Sourcing واقعیت تغییرناپذیر دامنه است؛ event در پیام‌رسانی عمومی ممکن است تنها خبر برای یک مصرف‌کننده باشد. مدل event باید نام گذشته‌نگر روشن داشته باشد، مانند OrderPlaced، نه فرمان مبهم ProcessOrder. به‌روزرسانی schema رویدادهای ذخیره‌شده را باید با upcaster، versioned reader یا راه مهاجرت سازگار مدیریت کرد.

### Saga کجا وارد می‌شود؟

اگر عملیات یک تراکنش سادهٔ چندپایگاهه نیست، workflow چندمرحله‌ای می‌تواند Saga باشد. در orchestration یک coordinator مرحلهٔ بعد را تعیین می‌کند؛ در choreography هر سرویس به event واکنش نشان می‌دهد. مرحلهٔ پرداخت موفق و رزرو موجودی ناموفق را نمی‌توان با rollback دیتابیس واحد حل کرد؛ ممکن است void یا refund یک عملیات compensation باشد. compensation همیشه اثر واقعی جهان بیرون را حذف نمی‌کند و باید audit شود.

## مثال: سفارش و گزارش فروش

نوشتن سفارش به مدل تراکنشی نیاز دارد تا موجودی و قواعد سفارش درست اعمال شوند. گزارش‌گیری گسترده به شکل جست‌وجوی denormalized سریع‌تر است؛ یک handler رویداد، نمای گزارش را به‌روزرسانی می‌کند. این نما چند ثانیه عقب می‌ماند، پس صفحهٔ مدیریتی باید زمان تازگی را نشان دهد. اگر گزارش را برای تصمیم قطعی پرداخت استفاده کنیم، تأخیر ناسازگار خطرناک می‌شود.

~~~text
Command -> validate -> write model + outbox -> event
                                           -> projection -> read model
~~~

## الگوهای عملی لازم

- **Transactional outbox:** ذخیرهٔ داده و پیام خروجی در تراکنش محلی مشترک؛ relay پیام را منتشر می‌کند.
- **Idempotent consumer:** پردازش تکراری یک پیام نتیجهٔ تکراری یا خراب نسازد.
- **Projection rebuild:** read model را از رویدادها یا منبع معتبر دوباره بساز.
- **Saga:** کار چندسرویسی را با مراحل و عملیات جبرانی مدیریت کن؛ rollback توزیع‌شده فرض نکن.

## مصالحه

| به‌کارگیری | سود | هزینه |
| --- | --- | --- |
| CQRS محدود | پاسخ خواندن را با الگوی دسترسی بهینه می‌کند | دو مدل و فرایند هماهنگ‌سازی |
| Event Sourcing | تاریخچه، replay و بررسی تغییرها | schema evolution، حریم خصوصی و پرس‌وجوی دشوار |
| eventual consistency | وابستگی هم‌زمان را کم می‌کند | تأخیر، پیام تکراری و تجربهٔ کاربر پیچیده‌تر |

## آزمون

۱. CQRS چه چیزی را جدا می‌کند؟  
**پاسخ:** مدل یا مسیر command و query را؛ نه لزوماً پایگاه داده، سرویس یا تیم را.

۲. چه زمانی Event Sourcing توجیه دارد؟  
**پاسخ:** زمانی که تاریخچه و بازسازی state ارزش دامنه‌ای روشن دارند و تیم می‌تواند versioning و replay را اداره کند.

۳. چرا outbox به‌تنهایی تحویل exactly-once نمی‌دهد؟  
**پاسخ:** بین relay و broker یا consumer ممکن است retry/تکرار رخ دهد؛ باید idempotency و deduplication نیز داشت.

۴. چه چیزی eventual consistency را برای کاربر قابل‌فهم می‌کند؟  
**پاسخ:** نمایش وضعیت در انتظار، تازگی داده، امکان refresh یا پیگیری و تعریف زمان همگرایی.

## تمرین

در جریان ثبت سفارش، نقطهٔ commit، پیام outbox، مصرف‌کنندهٔ فاکتور و رفتار پیام تکراری را مشخص کن. برای هر کدام یک سنجه و راه بازیابی بنویس.

## پاسخ نمونهٔ تمرین

Commit سفارش و outbox در یک transaction محلی است؛ metric: خطای commit و سن oldest outbox. Relay publish می‌کند؛ metric: publish lag و retry؛ بازیابی از checkpoint/lease و publish مجدد است. Consumer فاکتور event ID را در همان transaction با invoice status ثبت می‌کند؛ duplicate بی‌اثر می‌شود. اگر consumer fail کند، retry محدود و سپس DLQ با owner/replay policy. کل زنجیر correlation ID را حفظ می‌کند.

## منابع

- فارسی: [آموزش فارسی Event-Driven](https://github.com/gloonch/eventdrivenfarsi)، [راهنمای فارسی DDD](https://github.com/hheydarian/Understanding-Domain-Driven-Design)
- انگلیسی: [Martin Fowler: CQRS](https://martinfowler.com/bliki/CQRS.html)، [AWS Cloud Design Patterns](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/introduction.html)، [Microsoft: CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs)

</div>
