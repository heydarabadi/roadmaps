# واژه‌نامهٔ MongoDB

> **نسخهٔ انگلیسی:** [English edition](en/glossary.md).

| واژه | توضیح ساده |
|---|---|
| Acknowledgement | پاسخ server که اجرای write را طبق write concern تأیید می‌کند. |
| Aggregation | پردازش جریان سندها با pipeline از stageهای پیاپی. |
| Analyzer | تبدیل متن به token برای index و search. |
| Atomicity | تغییر یا مجموعهٔ تغییرهای اتمیک؛ در MongoDB پایهٔ write تک‌سندی است. |
| Atlas | سرویس مدیریت‌شدهٔ ابری MongoDB. |
| BSON | نمایش دودویی سندها با typeهای بیشتر از JSON. |
| BSON Type | نوع ذخیره‌شدهٔ مقدار، مثل Date یا Decimal128. |
| Collection | مجموعهٔ منطقی documentهای مرتبط. |
| Compound Index | index چندفیلدی با ترتیب معنادار. |
| Connection Pool | اتصال‌های قابل‌استفادهٔ مجدد که driver نگه می‌دارد. |
| Consistency | میزان هم‌خوانی داده بین خواندن‌ها و replicaها. |
| Cursor | پیمایش نتایج query به شکل batch و مرحله‌ای. |
| Database | فضای سازمان‌دهی collectionها. |
| Denormalization | کپی کنترل‌شدهٔ داده برای ساده‌کردن یا سریع‌کردن read. |
| Document | واحد رکوردی MongoDB با field، value، سند توکار و array. |
| Driver | کتابخانهٔ رسمی اتصال برنامهٔ یک زبان به MongoDB. |
| Election | انتخاب primary جدید در replica set. |
| Embedding | قراردادن دادهٔ مرتبط در سند والد. |
| Execution Plan | راهی که query planner برای اجرای query انتخاب می‌کند. |
| Explain | گزارش plan و آمار اجرای query. |
| Field | نام و مقدار داخل document؛ معادل تقریبی property. |
| Filter | شرط انتخاب سندها در read/update/delete. |
| Idempotency | اجرای دوبارهٔ یک درخواست بدون تکرار اثر نهایی. |
| Index | ساختار کمکی برای جست‌وجوی سریع‌تر؛ با هزینهٔ فضا و write. |
| Journaling | ثبت امن‌تر تغییرها برای recovery، وابسته به تنظیمات deployment. |
| Keyset Pagination | صفحه‌بندی بر اساس آخرین کلید sort، به جای offset بزرگ. |
| Majority | اکثریت اعضا طبق topology؛ مفهوم کاربردی در concern و commit. |
| Mapping | تعریف نوع fieldها برای search index. |
| mongod | فرایند server MongoDB. |
| mongosh | shell تعاملی اجرای command و script. |
| mongos | router درخواست‌ها در sharded cluster. |
| Multikey Index | index روی field آرایه‌ای. |
| Oplog | ثبت تغییرهای replication برای replica set. |
| Projection | محدودکردن یا شکل‌دهی fieldهای خروجی. |
| Query Planner | بخش server که plan اجرای query را انتخاب می‌کند. |
| Read Concern | سطح سازگاری/قابلیت مشاهدهٔ read. |
| Read Preference | انتخاب primary یا secondary برای read. |
| Reference | نگهداری شناسهٔ سند مرتبط در سند دیگر. |
| Replica Set | گروه mongodها برای replication و failover. |
| RPO | حداکثر بازه یا مقدار دادهٔ قابل‌قبول برای از دست‌رفتن. |
| RTO | زمان هدف برای بازیابی سرویس. |
| Schema | قواعد ساختار، type و رابطهٔ داده. |
| Schema Validation | کنترل server-side شکل سند هنگام write. |
| Shard | عضو ذخیره‌ساز یک sharded cluster. |
| Shard Key | fieldهایی که توزیع و routing شارد را تعیین می‌کنند. |
| Snapshot | دید سازگار از داده در زمان مشخص. |
| Stage | یک گام transformation در aggregation pipeline. |
| TTL Index | index برای پاکسازی پس از مدت/زمان تعریف‌شده. |
| Transaction | مرز commit/abort برای چند operation مرتبط. |
| Write Concern | سطح تأیید مورد انتظار از write. |
| Write Throughput | تعداد writeهای قابل‌انجام در واحد زمان. |
