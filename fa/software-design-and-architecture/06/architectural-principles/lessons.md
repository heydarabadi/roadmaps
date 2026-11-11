<div dir="rtl" align="right">

# درس کامل: اصول معماری


> **زبان:** [نسخهٔ انگلیسی](../../../../en/software-design-and-architecture/06/architectural-principles/lessons.md)

## معماری چه چیزی را تعیین می‌کند؟

معماری نرم‌افزار تصمیم‌های ساختاری دربارهٔ مرزها، dependency، state، ارتباط و deployment است که بر ویژگی‌های کیفی و هزینهٔ تغییر اثر پایدار دارند. «همه‌چیز معماری است» کمکی نمی‌کند؛ تصمیم مهم آن است که اگر اشتباه باشد عوض‌کردنش پرهزینه می‌شود یا روی چند تیم/جزء اثر می‌گذارد.

از نیاز عملکردی شروع نکن و مستقیم microservice انتخاب نکن. ابتدا فشارهای غیرعملکردی را روشن کن: latency، availability، امنیت، audit، توان تیم، هزینهٔ اجرا، زمان تحویل و احتمال تغییر. این فشارها ممکن است با هم تعارض داشته باشند؛ معماری انتخاب میان گزینه‌ها و trade-offهاست.

## ۱. Component principles

Component مؤلفه‌ای است که مسئولیت و contract مشخص دارد. Package، assembly یا folder به‌تنهایی component معماری نیست؛ مرز باید جلوی دسترسی بی‌رویه را بگیرد و مالکیت/تغییر را منسجم کند.

برای یک component مناسب:

1. یک capability یا بخش دامنه‌ای منسجم را مالک کن.
2. داده و invariantهایش را مشخص کن.
3. API عمومی را کوچک و پایدار نگه دار.
4. dependencyهای مجاز را تعریف و cycleها را ممنوع کن.
5. تست، نسخه‌بندی و ownership را به مرز وصل کن.

اصول کلاسیک component می‌پرسند چه چیزهایی باهم release یا reuse می‌شوند و dependency به کدام جهت پایداری می‌کند. یک قاعدهٔ کاربردی: چیزهایی که باهم تغییر می‌کنند نزدیک باشند؛ چیزهایی که جدا تغییر می‌کنند با contract کنترل‌شده همکاری کنند. مرز را از کد و تاریخچهٔ تغییر کشف کن، نه از سلیقهٔ پوشه‌بندی.

### تجربهٔ مستند Shopify

Shopify توضیح داده که کدبیس Rails بزرگش را به componentهای دامنه‌ای‌تر نزدیک کرد، از جمله با package boundary tooling. هدف، فهم بخش‌های مرتبط، تست محدودتر و مالکیت روشن بود؛ آن‌ها هم‌زمان از استخراج همه‌چیز به سرویس‌های شبکه‌ای پرهیز کردند چون distributed system هزینه دارد. این تجربه نشان می‌دهد component می‌تواند درون یک monolith باشد.

مطالعه: [Deconstructing the Monolith](https://shopify.engineering/deconstructing-monolith-designing-software-maximizes-developer-productivity) و [Enforcing Modularity with Packwerk](https://shopify.engineering/enforcing-modularity-rails-apps-packwerk).

## ۲. Policy در برابر Detail

Policy تصمیمی است که رفتار کسب‌وکار را تعیین می‌کند؛ detail راه فنی اجراست. قانون اینکه پس از چند روز بازپرداخت مجاز است policy است؛ استفاده از PostgreSQL، ASP.NET یا یک payment SDK detail است.

وابستگی source باید از detail به سمت policy برود: domain یا application قرارداد را تعریف کند؛ adapter دیتابیس و SDK آن را پیاده کنند. Runtime call ممکن است از policy به adapter برسد، اما کد policy نباید type و API بیرونی را مستقیماً بشناسد.

~~~text
Payment use case -> PaymentAuthorizer port <- Vendor adapter -> provider SDK
~~~

پنهان‌کردن همهٔ technologyها هدف نیست. اگر ORM قابلیت لازم دارد یا mapping هزینه می‌سازد، از آن استفاده کن؛ اما بدان کجا portability و testability را قربانی می‌کنی. مرز وقتی ارزشمند است که policy مستقل تغییر یا آزمون شود.

## ۳. Coupling و Cohesion

**Cohesion** میزان ارتباط بخش‌های داخل component با یک مسئولیت مشترک است. **Coupling** میزان دانشی است که یک component دربارهٔ دیگری دارد و تغییر یک جزء چه مقدار را به تغییر وابسته می‌کند. هدف صفرکردن dependency نیست؛ سامانه بدون collaboration چیزی انجام نمی‌دهد. هدف محدودکردن dependency ناموجه و پرهزینه است.

نشانه‌های coupling:

- تغییر schema یک ماژول، callerهای متعدد را می‌شکند؛
- component از private field یا table داخلی دیگری می‌خواند؛
- دو سرویس برای تکمیل یک request پیوسته به هم call می‌کنند؛
- ترتیب چند event به شکل پنهان برای درست‌کارکردن لازم است.

نشانه‌های انسجام:

- operationها حول یک capability و زبان مشترک‌اند؛
- تغییرهای هم‌زمان در همان مرز رخ می‌دهند؛
- component می‌تواند با contract روشن تست شود.

### سنجش عملی

به جای عبارت «coupling زیاد است» یک تغییر واقعی را دنبال کن: «اگر روش محاسبهٔ ارسال عوض شود، کدام فایل، تیم، آزمون، سرویس و deploy تغییر می‌کند؟» ثبت کن چند مرز نقض می‌شود، کدام تغییر ناخواسته به دیگران سرایت می‌کند، و چه هزینه‌ای برای refactor لازم است.

جداسازی بیش‌ازحد coupling را از call محلی به mapping، API و network منتقل می‌کند؛ ممکن است دشوارتر شود. Component boundary درون‌فرایندی اغلب ارزان‌تر از مرز سرویس است و فرصت تغییر آینده را حفظ می‌کند.

## ۴. Boundaries

مرز مشخص می‌کند چه کسی مالک state است، چه قراردادهایی قابل‌استفاده‌اند و dependency از کجا عبور می‌کند. مرز می‌تواند:

- منطقی داخل package یا process؛
- سطح API بین سرویس‌ها؛
- شبکه یا trust boundary امنیتی؛
- ownership تیمی؛
- یا مرز محصول و bounded context باشد.

برای تصمیم مرز:

1. actor و قواعدی که باهم تغییر می‌کنند را پیدا کن.
2. دادهٔ منبع حقیقت و مسئولیت invariant را مشخص کن.
3. collaboration بین طرفین را بشمار و latency/failure را لحاظ کن.
4. قرارداد و روش مشاهدهٔ نتیجه را طراحی کن.
5. تا وقتی مرز درون‌فرایندی کافی است، network boundary را تحمیل نکن.

مرز زیاد هم خطر دارد: split کردن یک transaction به چند سرویس eventual consistency، retry، reconciliation و عملیات می‌خواهد. مرز کم هم مالکیت مبهم و تغییرهای هم‌زمان ایجاد می‌کند.

## ۵. Policy vs detail را در آزمون ببین

Domain test باید بتواند بدون provider و database اجرا شود. Adapter test قرارداد I/O را بررسی می‌کند. Integration test واقعی اتصال را می‌سنجد. اگر یک test برای رد قانون بازپرداخت نیاز به بالا آوردن cloud کامل دارد، policy با detail گره خورده است؛ اگر adapter را فقط با mock تست کرده‌ای، قرارداد provider هنوز نامعلوم است.

## ۶. تجربهٔ معماری موردی: Prime Video

تیم Video Quality Analysis برای یک ابزار پایش صوت/تصویر گزارش داد که طرح توزیع‌شدهٔ serverless برای workload آن هزینه و محدودیت هماهنگی ایجاد می‌کرد و ادغام مراحل در یک process، هزینهٔ همان سرویس را کاهش داد. این مطالعهٔ موردی دربارهٔ سرویس پایش مشخص است، نه کل Prime Video و نه حکم علیه microservices. درس معماری، سنجش واقعی فاصلهٔ اجزا، حجم پیام، orchestration و هزینهٔ هر transition است.

منبع اصلی: [Prime Video Tech: Scaling up the audio/video monitoring service](https://www.primevideotech.com/video-streaming/scaling-up-the-prime-video-audio-video-monitoring-service-and-reducing-costs-by-90).

## ۷. کوییز با پاسخ

۱. آیا folder مرز component است؟
   - پاسخ: نه، مگر دسترسی و dependency را واقعاً محدود و contract/ownership روشن کند.
۲. Policy و detail را با مثال جدا کن.
   - پاسخ: قانون مجاز بودن refund policy است؛ SQL یا SDK جزئیات اجراست.
۳. coupling را چطور از حالت سلیقه‌ای بیرون می‌آوری؟
   - پاسخ: یک سناریوی تغییر را دنبال می‌کنم و انتشار، فایل‌ها، APIها و آزمون‌های متأثر را ثبت می‌کنم.
۴. آیا صفر coupling هدف است؟
   - پاسخ: نه؛ collaboration لازم است. هدف کنترل dependency و کاهش دانش ناموجه است.
۵. چه وقت component را به سرویس تقسیم می‌کنی؟
   - پاسخ: مالکیت/deploy/scale/security مستقل و سودشان از network, consistency و عملیات بیشتر باشد.
۶. چرا مقالهٔ Prime Video نسخهٔ همه نیست؟
   - پاسخ: workload، هزینه و محدودیت همان ابزار متفاوت است؛ گزارش فقط دربارهٔ سرویس پایش آن تیم است.

## ۸. تمرین

یک سامانهٔ موجود انتخاب کن و boundary map بکش. مالک هر داده، policyهای کلیدی، APIهای عمومی، dependency cycleها و تغییرهای پرتکرار را نشان بده. برای یک boundary نامزد، هزینهٔ نگهداری درون‌فرایندی و بین‌فرایندی را مقایسه کن.

## منابع اختیاری

- [Shopify؛ modularizing the monolith](https://shopify.engineering/shopify-monolith)
- [Shopify؛ Packwerk](https://shopify.engineering/enforcing-modularity-rails-apps-packwerk)
- [Microsoft Azure Architecture Center؛ Architecture styles](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/)



## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../references.md#chapter-06)
</div>
