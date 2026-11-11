<div dir="rtl" align="right">

# طراحی دامنه‌محور (DDD)

## هدف یادگیری

واژگان یکنواخت، bounded context، subdomain و الگوهای تاکتیکی را بشناسی و بفهمی DDD بیشتر روش فهم و مدل‌کردن پیچیدگی است تا الزام چند کلاس مشخص.

## ایدهٔ مرکزی

Domain-Driven Design روی دامنه‌های پیچیده تمرکز می‌کند و مدل نرم‌افزار را با زبان متخصصان کسب‌وکار پیوند می‌دهد. متخصصان دامنه و مهندسان با گفت‌وگو، نمونه‌ها و بازبینی مدل به زبان مشترک می‌رسند. اگر مسئله ساده است، رویکرد سبک‌تری ممکن است بهتر باشد.

## طراحی راهبردی

- **Subdomain:** بخش کسب‌وکار با مسئله و ارزش خودش؛ ممکن است core، supporting یا generic باشد.
- **Bounded context:** محدوده‌ای که در آن یک مدل و زبان معنای دقیق دارد. «مشتری» در فروش، پشتیبانی و صورتحساب ممکن است موجودیت‌ها و قواعد متفاوت داشته باشد.
- **Context map:** رابطه و وابستگی بین contextها، مانند Customer/Supplier، Conformist یا Anti-Corruption Layer.
- **Event storming:** کارگاه کشف جریان با رخدادهای دامنه، command، actor، policy و سؤال‌های باز.

## الگوهای تاکتیکی

Entity هویت پایدار دارد؛ Value Object با مقدارش برابر است و تغییرناپذیری معمولاً مناسب آن است. Aggregate مرز invariant تراکنش را تعیین می‌کند و فقط از root تغییر می‌یابد. Domain Service رفتاری را جای می‌دهد که به یک entity طبیعی تعلق ندارد. Repository جمع‌آوری و ذخیرهٔ Aggregate را پشت قرارداد پنهان می‌کند؛ نباید به facade عمومی همهٔ جداول تبدیل شود.

## از کشف دامنه تا مدل قابل‌اجرا

### گام اول: واژه‌ها و جریان را بیرون بکش

با متخصص کسب‌وکار یک فرایند واقعی را بررسی کن. به جای شروع با جدول‌ها بپرس: چه کسی آغازگر است؟ چه تصمیمی گرفته می‌شود؟ چه چیزی می‌تواند رد شود؟ چه رخدادی بعد از موفقیت اتفاق می‌افتد؟ اصطلاح‌های دوپهلو مثل «فعال»، «تکمیل‌شده» یا «مشتری» را برای هر context تعریف کن.

### گام دوم: subdomain را از bounded context جدا کن

Subdomain بخش کسب‌وکار است؛ bounded context مرز مدل و زبان نرم‌افزار. ممکن است subdomain «پرداخت» درون یک سامانه با چند context مثل authorization، settlement و refund مدل شود. مرز context را بر پایهٔ اختلاف قواعد، مالکیت تغییر و نیاز ارتباطی بساز، نه تعداد entityها.

### گام سوم: invariant را پیدا کن

Invariant قاعده‌ای است که باید هنگام commit برقرار باشد؛ برای نمونه، یک PaymentAttempt با provider reference مشخص فقط یک بار به captured می‌رسد. Aggregate باید عملیات را طوری دروازه‌بانی کند که client نتواند با دستکاری fieldها invariant را بشکند. اگر aggregate شامل هزاران رکورد و چند تیم است، احتمالاً مرزش بیش از حد بزرگ است.

### گام چهارم: رابطهٔ contextها را انتخاب کن

اگر مدل بیرونی را نمی‌توانی کنترل کنی، Anti-Corruption Layer آن را به زبان داخلی ترجمه می‌کند. اگر تیمی API پایدار عرضه می‌کند و تو مصرف‌کننده‌ای، قرارداد مصرف و نسخه را شفاف کن. اگر دو context به event مشترک وصل‌اند، event را به زبان و مالک مشخص تعریف کن؛ ارسال یک جدول database به‌عنوان event مرز مدل را حفظ نمی‌کند.

### گام پنجم: مدل را در code و گفتگو بازبینی کن

اسم کلاس‌ها به‌تنهایی DDD نمی‌سازد. یک use case واقعی را با domain expert مرور کن و ببین مدل چه تصمیمی را enforce می‌کند. اگر قاعده فقط در مستند است و runtime اجازهٔ نقضش می‌دهد، مدل هنوز محافظت کافی ندارد.

## مثال: «سفارش» در سه زمینه

در فروش، سفارش درخواست خرید و قیمت‌گذاری است؛ در انبار، مجموعه‌ای از اقلام قابل‌برداشت؛ در امور مالی، تعهدی برای ثبت سند. یک جدول global CustomerOrder با ده‌ها فیلد ممکن است همهٔ این زبان‌ها را در هم ادغام کند. به‌جای آن، مالکیت داده و ترجمهٔ قرارداد میان contextها را مشخص کن؛ فقط داده‌های لازم را از مرز عبور بده.

## تصمیم‌ها و دام‌ها

| تصمیم | مناسب است وقتی | خطر دارد وقتی |
| --- | --- | --- |
| Aggregate کوچک | invariant محدود و concurrency بالا است | consistency rule واقعی را بیرون مرز رها کند |
| Anti-Corruption Layer | مدل legacy یا vendor با دامنهٔ جدید متفاوت است | همهٔ انتقال داده را بی‌دلیل پیچیده کند |
| سرویس جدا بر پایهٔ context | مالکیت مستقل و چرخهٔ تغییر متفاوت داریم | تیم فقط براساس جدول‌ها سرویس بشکند |

- domain model را معادل class model ندان.
- bounded context مساوی microservice نیست؛ می‌تواند ابتدا module باشد.
- Aggregate بزرگ می‌تواند قفل و contention بسازد.
- model را با متخصصان بررسی کن؛ نام‌گذاری از جلسهٔ کدنویسی تنها بیرون نمی‌آید.

## آزمون

۱. Bounded context چه مرزی را مشخص می‌کند؟  
**پاسخ:** مرزی که درون آن مدل و واژگان معنای واحد دارند؛ ارتباط با مدل دیگر باید از قرارداد روشن عبور کند.

۲. Entity و Value Object چه تفاوتی دارند؟  
**پاسخ:** Entity هویت مستقل و تداوم دارد؛ Value Object بر مقدار ویژگی‌هایش متکی است و معمولاً جایگزین می‌شود نه ویرایش.

۳. چرا context همیشه یک سرویس نیست؟  
**پاسخ:** مرز معنایی و مالکیت مدل لزوماً همان مرز deployment نیست؛ پیچیدگی توزیع را می‌توان تا زمان نیاز عقب انداخت.

۴. Aggregate Root چه نقشی دارد؟  
**پاسخ:** درگاه تغییر Aggregate و نگهبان invariantهای آن است.

## تمرین

برای سفارش، پرداخت، ارسال و فاکتور چهار context احتمالی تعریف کن. معنی «وضعیت سفارش» در هرکدام، مالک داده و رویداد یا قرارداد اتصال را بنویس.

## پاسخ نمونهٔ تمرین

Order context مالک lifecycle تجاری سفارش است؛ Payment context وضعیت تلاش/برداشت را با معنای Pending/Authorized/Refunded تعریف می‌کند؛ Shipping context fulfillment و tracking را مالک است؛ Invoice context سند مالی صادرشده و اصلاح آن را اداره می‌کند. واژهٔ «status» را میان contextها مستقیم share نکن. اتصال می‌تواند OrderPlaced، PaymentSettled و ShipmentDispatched با شناسهٔ پایدار باشد؛ هر context زبان و data store خود را نگه می‌دارد.

## منابع

- فارسی: [راهنمای جامع فارسی DDD](https://github.com/hheydarian/Understanding-Domain-Driven-Design)، [DDD به زبان ساده در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-1406.pdf)
- انگلیسی: [Martin Fowler: Bounded Context](https://martinfowler.com/bliki/BoundedContext.html)، [AWS Well-Architected: Domain-driven design](https://docs.aws.amazon.com/wellarchitected/latest/framework/rel_domain_driven_design.html)، [Microsoft: DDD microservice design](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/)

</div>
