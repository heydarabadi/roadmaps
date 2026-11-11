<div dir="rtl" align="right">

# پایگاه دادهٔ رابطه‌ای و SQL

پایگاه رابطه‌ای برای داده‌های دارای رابطه و invariantهای تراکنشی مناسب است. schema، constraint، transaction و query plan بخشی از طراحی معماری‌اند. SQL schema ثابت الزاماً مانع تغییر نیست؛ migration versioned می‌تواند تکامل کنترل‌شده بدهد.

در فروشگاه، سفارش و اقلامش با کلید خارجی و constraint مدل می‌شوند. transaction مبلغ و وضعیت را اتمی تغییر می‌دهد. index با الگوی query انتخاب می‌شود و هزینهٔ write/storage دارد؛ index «همه‌چیز را سریع» نمی‌کند. برای تغییر ستون با deployهای مستقل، الگوی expand/contract به کار ببر: ابتدا ساختار سازگار اضافه کن، داده را منتقل کن، مصرف‌کننده را تغییر بده و بعد ساختار قدیمی را حذف کن.

ACID و isolation level را از راه مستندات موتور و آزمون واقعی بشناس؛ یک query طولانی، قفل، deadlock یا N+1 می‌تواند عملکرد را مختل کند. backup، point-in-time recovery، replication lag و طرح migration نیز معماری‌اند.

## درس گام‌به‌گام: مدل‌کردن سفارش رابطه‌ای

ابتدا invariantها را مشخص کن، بعد جدول بساز. هر سفارش چند قلم دارد:

۱. orders کلید اصلی دارد و order_items با foreign key به آن وصل است.
۲. قیمت خرید در order item به‌صورت snapshot ذخیره می‌شود؛ join به قیمت فعلی محصول نباید مبلغ گذشته را تغییر دهد.
۳. CHECK، unique و foreign key قواعد را نزدیک منبع حقیقت enforce می‌کنند؛ اعتبارسنجی برنامه برای پیام مناسب لازم است، اما رقابت دو درخواست را به‌تنهایی مهار نمی‌کند.
۴. ایجاد سفارش و اقلامش یک transaction است. اگر موجودی در همان DB و invariant مشترک است، قفل و isolation را بسنج؛ اگر سرویس جداست، saga لازم می‌شود.

## transaction و هم‌زمانی

BEGIN تا COMMIT یا ROLLBACK بخشی از کار را اتمی می‌کند. isolation level تعیین می‌کند transactionهای هم‌زمان چه تغییری از هم ببینند. Read Committed ممکن است در دو query یک transaction snapshot متفاوت بدهد؛ Serializable ممکن است یکی را abort کند تا نتیجه شبیه اجرای ترتیبی شود. جزئیات میان موتورهای دیتابیس فرق دارد؛ مستندات همان موتور را بخوان.

دو درخواست آخرین واحد کالا را هم‌زمان می‌خوانند. «بخوان، در برنامه کم کن، بنویس» ممکن است هر دو را موفق کند. از update شرطی اتمی، قفل ردیف، optimistic concurrency با version یا isolation قوی‌تر استفاده کن؛ invariant و خطای رقابت را صریح کن.

Deadlock اغلب از قفل‌گرفتن به ترتیب متفاوت می‌آید. transaction را کوتاه نگه دار، ترتیب دسترسی را ثابت کن، timeout داشته باش و retry محدود را فقط برای کاری انجام بده که تکرارش امن است. تماس شبکه‌ای طولانی را داخل transaction باز نگه ندار.

## index، query plan و pagination

از query واقعی شروع کن: فیلتر، join، ترتیب و تعداد ردیف لازم. ترتیب ستون‌های index به workload وابسته است و index اضافه، write و storage را گران می‌کند. EXPLAIN را ببین و scan، sort، join و تعداد row تخمینی را با latency بسنج. برای N+1، تعداد query در trace را مشاهده و سپس join یا batch fetch را انتخاب کن. offset بزرگ گران می‌شود؛ cursor با ترتیب پایدار و کلید یکتا مناسب‌تر است.

## migration سازگار

هنگام حضور هم‌زمان نسخهٔ قدیم و جدید، ستون را یکباره rename نکن: ساختار تازه را اضافه کن؛ backfill قابل‌تکرار انجام بده؛ نسخهٔ برنامه را به خواندن ساختار تازه منتقل کن؛ مقدارها را مقایسه کن؛ و پس از حذف مصرف‌کنندهٔ قدیمی، ستون قبلی را حذف کن. هر مرحله rollback یا forward-fix و پایش داشته باشد.

## backup و بازیابی

Replication دسترس‌پذیری را بالا می‌برد؛ backup امکان بازگشت از حذف یا خرابی را می‌دهد. RPO حد دادهٔ قابل‌از‌دست‌رفتن و RTO زمان بازگشت خدمت است. restore را تمرین کن؛ snapshotی که هرگز بازیابی نشده، هنوز برنامهٔ بازیابی اثبات‌شده نیست.

## آزمون

۱. چرا constraint در database مفید است؟ **پاسخ:** invariant را نزدیک منبع حقیقت enforce می‌کند، حتی اگر چند مسیر نوشتن وجود داشته باشد.
۲. index چه هزینه‌ای دارد؟ **پاسخ:** فضای ذخیره و کار بیشتر روی write و نگهداری.
۳. expand/contract چه مشکلی را کاهش می‌دهد؟ **پاسخ:** ناسازگاری نسخهٔ قدیم و جدید هنگام deploy تدریجی.
۴. replication همیشه backup است؟ **پاسخ:** خیر؛ حذف اشتباه هم ممکن است replicate شود و backup باید restoreپذیر باشد.

## تمرین

برای سفارش‌ها دو query پرتکرار بنویس، index احتمالی و trade-off آن را مشخص کن و migration سازگار با نسخهٔ قبلی طراحی کن.

## پاسخ نمونهٔ تمرین

Queryهای نمونه: سفارش‌های یک مشتری به ترتیب زمان و سفارش با شناسه؛ index ترکیبی customer_id/created_at برای اولی و primary key برای دومی باید با EXPLAIN سنجیده شود. migration سازگار: ستون جدید اضافه، backfill دسته‌ای، dual-read/مقایسه یا dual-write کنترل‌شده، تغییر reader، مشاهدهٔ نسخهٔ قدیمی و حذف دیرهنگام ستون قبلی. هزینهٔ index و lock را اندازه بگیر.

## منابع

- فارسی: [مبانی معماری فارسی: کار با داده](https://www.alirostami.com/software-architecture/)، [مطالب دیتابیس در DNTips](https://www.dntips.ir/)
- انگلیسی: [PostgreSQL Documentation](https://www.postgresql.org/docs/)، [Microsoft: Data access and persistence](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/)

</div>

