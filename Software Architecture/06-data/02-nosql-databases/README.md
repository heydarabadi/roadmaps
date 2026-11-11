<div dir="rtl" align="right">

# NoSQL و انتخاب ذخیره‌ساز

NoSQL نام چند خانوادهٔ متفاوت است، نه یک مدل واحد: key-value برای lookup ساده و سریع، document برای دادهٔ تو‌در‌تو و تغییرپذیر، wide-column برای حجم و الگوی partition مشخص، و graph برای رابطه‌های پیمایشی. انتخاب را با access pattern، partition key، consistency، query و هزینهٔ اداره انجام بده.

NoSQL می‌تواند schema داشته باشد؛ اغلب schema در code و قرارداد مصرف‌کننده قرار می‌گیرد. «بدون schema» به معنی بی‌نیازی از مهاجرت و versioning نیست. مدل‌سازی بر اساس query گاهی denormalization می‌خواهد؛ هر projection باید منبع حقیقت و روش بازسازی داشته باشد.

در سبد خرید شاید document با خواندن یک‌بارهٔ اقلام مناسب باشد؛ دفتر مالی و عملیات چندموجودیتی با invariantهای مهم شاید پایگاه رابطه‌ای را ترجیح دهد. CAP را کلیشه‌ای به «NoSQL دو ویژگی از سه» تقلیل نده؛ رفتار هر محصول در partition و consistency level را بررسی کن.

## درس گام‌به‌گام: از query به مدل NoSQL

برای صفحهٔ محصول، ابتدا پرسش‌های واقعی را فهرست کن: دریافت محصول با ID، نمایش دسته‌بندی، جست‌وجو، مرتب‌سازی قیمت و نمایش کالای مشابه. هیچ خانوادهٔ NoSQL همهٔ queryها را خودکار پوشش نمی‌دهد.

۱. **ثبت workload:** نرخ خواندن و نوشتن، اندازهٔ رکورد، الگوی فیلتر و نیاز تازگی را اندازه بگیر.
۲. **انتخاب مدل:** document برای خواندن aggregate تو‌در‌تو، key-value برای دسترسی مستقیم با کلید، wide-column برای queryهای partition شده، و graph برای traversal رابطه‌ها.
۳. **انتخاب partition key:** پخش بار و query متداول را بسنج؛ hot key می‌تواند یک partition را به bottleneck تبدیل کند.
۴. **Denormalization:** تکرار مشخصهٔ محصول در projection فهرست خواندن را آسان می‌کند، اما تغییر قیمت و نام باید نسخه‌های مشتق‌شده را به‌روز کند.
۵. **منبع حقیقت:** مالک رکورد اصلی، event یا log تغییر و راه بازسازی projection را ثبت کن.
۶. **شکست:** رفتار partition، replica lag، timeout، conflict و restore را بررسی کن.

## انتخاب consistency بر مبنای عملیات

در کاتالوگ عمومی شاید نمایش چند ثانیه دادهٔ قدیمی پذیرفتنی باشد. برداشت آخرین موجودی یا ثبت پرداخت تحمل duplicate و oversell کمتری دارد. برای هر operation بگو پس از write چه تضمینی لازم است، concurrent update چه رفتاری دارد و هنگام partition چه تصمیمی می‌گیری.

CAP هنگام partition میان consistency و availability محدودیت نشان می‌دهد؛ latency، replication lag و مدل consistency هر محصول هم مهم‌اند. گزارهٔ «NoSQL فقط دو مورد از سه» برای تصمیم طراحی کافی نیست.

## خانواده‌ها و موارد رد

- **Key-value:** session یا cache با lookup کلیدی؛ query فیلد دلخواه معمولاً محدود است.
- **Document:** پروفایل و محتوای تو‌در‌تو؛ join و invariant میان چند document نیازمند طراحی جداست.
- **Wide-column:** write throughput بالا با queryهای ازپیش‌طراحی‌شده بر مبنای partition.
- **Graph:** مسیرهای رابطه‌ای چندمرحله‌ای؛ برای CRUD ساده الزاماً انتخاب اقتصادی نیست.

گزینه‌های ردشده را هم مستند کن: آیا دیتابیس رابطه‌ای query لازم را ساده‌تر می‌کند؟ آیا سرویس مدیریت‌شده پیچیدگی عملیات را کم می‌کند؟ آیا تیم می‌تواند partition، compaction، backup و upgrade را اداره کند؟

## مثال حل‌شده: basket در برابر ledger

Basket تغییرپذیر، کوتاه‌عمر و معمولاً با کلید کاربر خوانده می‌شود؛ document store یا key-value ممکن است مناسب باشد، اگر تراکنش و بازیابی تعریف شود. دفتر مالی به ممیزی، دقت مبلغ و حفظ سابقه نیاز دارد؛ relational با constraint و transaction غالباً طبیعی‌تر است. اگر هر دو را به‌کار می‌بری، منبع حقیقت و همگام‌سازی روشن باشد.

## آزمون

۱. چه چیزی مبنای انتخاب NoSQL است؟ **پاسخ:** access pattern، بار، consistency، partition، query و توان عملیاتی.
۲. denormalization چه هزینه‌ای دارد؟ **پاسخ:** تکرار داده، مسیر update و امکان ناسازگاری.
۳. document database یعنی schema نداریم؟ **پاسخ:** خیر؛ قرارداد داده باید جایی تعریف و version شود.
۴. چه چیزی را برای CAP بررسی می‌کنی؟ **پاسخ:** رفتار عملیات مشخص در زمان partition، نه برچسب کلی پایگاه داده.

## تمرین

برای کاتالوگ، رابطهٔ اجتماعی فروشنده‌ها و ثبت پرداخت، خانوادهٔ ذخیره‌ساز را مقایسه کن و دلیل رد گزینه‌ها را بنویس.

## پاسخ نمونهٔ تمرین

Catalog با document یا relational بسته به query و relation؛ graph برای پیمایش شبکهٔ فروشنده‌ها؛ payment ledger معمولاً relational با constraint و transaction. اگر پرداخت حجیم و access pattern ثابت است wide-column می‌تواند بررسی شود اما گزارش/اتمیّت پیچیده‌تر می‌شود. گزینه را بر اساس workload و consistency انتخاب کن، نه برچسب NoSQL.

## منابع

- فارسی: [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)، [داده‌های NoSQL در DNTips](https://www.dntips.ir/)
- انگلیسی: [AWS Database Types](https://aws.amazon.com/products/databases/)، [Google Cloud: Choosing a database](https://cloud.google.com/products/databases)

</div>

