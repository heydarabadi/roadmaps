<div dir="rtl" align="right">

# واژه‌نامهٔ Redis

> English edition: [Redis Glossary](../../en/redis/GLOSSARY.md)

این واژه‌نامه زبان مشترک درس‌هاست. نام اصلی انگلیسی کنار توضیح فارسی آمده تا هنگام خواندن خطا، لاگ یا مستندات بتوانی اصطلاح را تشخیص بدهی.

| اصطلاح | معنی در این دوره |
|---|---|
| Key | نامی که یک مقدار یا ساختار را در Redis پیدا می‌کند. |
| Value | دادهٔ وابسته به یک key؛ می‌تواند string، hash، list یا نوع دیگر باشد. |
| Data type / data structure | شکل و عملیات مجاز روی value؛ مثل Set یا Sorted Set. |
| Keyspace | کل مجموعهٔ keyهای Redis در یک database منطقی. |
| TTL | زمان باقی‌مانده تا انقضای key یا field. |
| Expiration | سیاست حذف یک key/field پس از زمان تعیین‌شده. |
| Atomic operation | یک فرمانی که Redis آن را کامل می‌کند پیش از اجرای فرمان بعدی؛ نتیجهٔ میانی از کلاینت دیگری دیده نمی‌شود. |
| Round trip | رفت‌وبرگشت یک درخواست و پاسخ بین برنامه و Redis. |
| Pipeline | فرستادن چند فرمان در یک batch برای کم‌کردن round trip؛ به‌تنهایی transaction نیست. |
| Transaction | گروهی از فرمان‌ها که Redis پشت‌سرهم و بدون interleaving اجرا می‌کند؛ rollback مشابه SQL ندارد. |
| Optimistic locking | راهبردی که تغییر هم‌زمان را با WATCH تشخیص می‌دهد و در conflict کار را abort می‌کند. |
| Cache-aside | برنامه اول cache را می‌خواند، در miss از منبع اصلی می‌خواند و cache را پر می‌کند. |
| Cache miss | داده در cache نبود و برنامه باید از منبع دیگری آن را بگیرد یا محاسبه کند. |
| Cache stampede | تعداد زیادی miss هم‌زمان باعث می‌شود همهٔ درخواست‌ها منبع اصلی را تحت فشار بگذارند. |
| Invalidation | بی‌اعتبار یا حذف‌کردن cache وقتی دادهٔ اصلی تغییر می‌کند. |
| Persistence | ذخیره‌کردن دادهٔ Redis روی دیسک برای بارگذاری پس از restart. |
| RDB | snapshot نقطه‌ای از dataset Redis در فایل. |
| AOF | log فرمان‌های تغییردهنده که برای بازسازی state replay می‌شود. |
| RPO | بیشترین میزان/بازهٔ داده‌ای که کسب‌وکار تحمل از دست‌رفتنش را دارد. |
| RTO | زمان هدف برای بازگرداندن سرویس پس از خرابی. |
| Replication | کپی‌شدن تغییرهای primary به replica؛ در Redis معمولاً ناهمگام است. |
| Replication lag | فاصلهٔ زمانی یا تعداد تغییرهایی که replica از primary عقب است. |
| Failover | انتقال نقش primary به replica دیگر پس از خرابی یا اقدام مدیریتی. |
| Sentinel | سامانهٔ مانیتورینگ و failover برای Redis بدون sharding. |
| Redis Cluster | پخش keyها در shardها و توزیع slotها برای scale افقی و دسترس‌پذیری. |
| Hash slot | یکی از 16,384 جایگاه منطقی که keyها در Redis Cluster به آن نگاشت می‌شوند. |
| Hash tag | قسمت داخل آکولاد key که برای هم‌slot کردن چند key مرتبط به کار می‌رود. |
| ACL | فهرست کنترل دسترسی برای user، command و pattern کلیدها. |
| TLS | رمزنگاری و احراز هویت کانال شبکه؛ جایگزین ACL نیست. |
| maxmemory | حدی برای حافظه‌ای که Redis برای dataset مجاز می‌داند. |
| Eviction | حذف keyها هنگام فشار حافظه براساس سیاست انتخاب‌شده. |
| LRU / LFU | تقریب کم‌استفاده‌ترین بر اساس زمان / کم‌مصرف‌ترین بر اساس دفعات. |
| Latency | مدت پاسخ؛ در سرویس واقعی باید percentileهایی مانند p95/p99 سنجیده شوند. |
| Throughput | تعداد عملیات انجام‌شده در یک واحد زمان. |
| Slow log | فهرست فرمان‌هایی که زمان اجرای server-side آن‌ها از آستانه بیشتر بوده است. |
| Pub/Sub | انتشار پیام زنده به subscriberهای متصل؛ پیام آفلاین ذخیره و replay نمی‌شود. |
| Stream | log رویدادهای دارای شناسه که می‌تواند replay و consumer group داشته باشد. |
| Consumer group | گروه workerهای Stream که کار را تقسیم می‌کنند و وضعیت پیام‌های pending دارند. |
| PEL | Pending Entries List؛ فهرست پیام‌های تحویل‌شده ولی هنوز تأییدنشده در گروه Stream. |
| Acknowledgement / ACK | تأیید مصرف موفق پیام؛ در Stream با XACK. |
| Idempotency | اجرای دوبارهٔ همان درخواست، اثر نامطلوب تکراری نسازد. |
| Probabilistic data structure | ساختاری حافظه‌کم با جواب احتمالی/تقریبی و خطای قابل‌اندازه‌گیری. |
| Cardinality | تعداد عضوهای متمایز در یک مجموعه. |
| Vector embedding | نمایش عددی داده برای جست‌وجوی شباهت؛ شباهت عددی به‌تنهایی relevance را تضمین نمی‌کند. |
| Edition / managed service | نسخه یا سرویس ارائه‌شده با مجموعهٔ قابلیت و مسئولیت عملیاتی متفاوت. |

</div>
