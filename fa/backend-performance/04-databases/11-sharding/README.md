<div dir="rtl" align="right">

# Sharding — تقسیم مالکیت داده میان نودها

**زبان:** فارسی · [English version](../../../../en/backend-performance/04-databases/11-sharding/README.md)


**هدف یادگیری:** Shard key را از الگوی دسترسی انتخاب کنید، hotspot و cross-shard query را تشخیص دهید و هزینه جابه‌جایی داده را پیش از اجرای تصمیم بنویسید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ مثال مفهومی و اجرا‌نشده است.

## مدل ذهنی

Sharding داده را میان چند دیتابیس/گروه نود تقسیم می‌کند؛ هر شارد مالک زیرمجموعه‌ای از داده است. Replica کپی همان زیرمجموعه است. Partitioning جدول در یک موتور الزاماً چند سرور مستقل نمی‌سازد؛ مثلاً partition بومی PostgreSQL را به‌تنهایی معادل سامانه توزیع‌شده فرض نکنید. [مستند Table partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html) محدوده این قابلیت را مشخص می‌کند.

| راه تقسیم | مزیت | خطر |
| --- | --- | --- |
| Range مانند بازه زمان | locality و range scan | داغ‌شدن بازه جدید |
| Hash کلید | توزیع مناسب‌تر در بسیاری از بارها | range query و tenant بسیار داغ |
| Directory/lookup | انتقال tenant انعطاف‌پذیر | وابستگی حیاتی به نقشه routing |

کلید خوب باید در queryهای پرتکرار حضور داشته باشد، مالکیت را واضح کند و توزیع بار مناسب بدهد. Cardinality زیاد الزاماً یکنواختی بار نیست؛ یک tenant از میان میلیون‌ها tenant می‌تواند بیشتر ترافیک را بسازد. کم‌شدن تعداد ردیف هر شارد، مشکل یک کلید بسیار داغ را خودکار رفع نمی‌کند.

## کاربرد و مصالحه

وقتی ظرفیت ذخیره/نوشتن یا محدودیت عملیاتی یک نود پس از اصلاح query و استفاده مناسب از scale-up/replica کافی نیست، Sharding نامزد است. برای سرویس کوچک یا queryهای سراسری فراوان، پیچیدگی routing، join، transaction، schema migration و عملیات می‌تواند سود را ببلعد. گزارش سراسری ممکن است به fan-out و merge یا سامانه تحلیلی جدا نیاز داشته باشد. چند شارد یعنی چند مجموعه نیازمند backup، پایش و تغییر schema.

## مثال حل‌شده

فروشگاه چندمستاجری آموزشی اکثر سفارش‌ها را با tenant می‌خواند. Directory مالک tenant را مشخص می‌کند؛ سفارش و اقلامش روی یک شارد نگه داشته می‌شوند تا تراکنش محلی بماند.

<div dir="ltr" align="left">

```text
route = directory.lookup(tenant_id)  # returns shard_id + epoch
database = connect_to(route.shard_id)
assert database.accepts(tenant_id, route.epoch)
database.execute(
  "SELECT id, total FROM orders WHERE tenant_id = ? AND id = ?",
  [tenant_id, order_id]
)
```

</div>

epoch کمک می‌کند write با نقشه قدیمی در انتقال مالکیت رد شود؛ خودش الگوریتم migration کامل نیست. انتقال شامل کپی اولیه، گرفتن تغییرهای هم‌زمان، تطبیق، cutover با جلوگیری از دو نویسنده و راه برگشت است. `hash(key) % N` با تغییر N بسیاری از کلیدها را جابه‌جا می‌کند؛ بدون migration و نسخه‌بندی نقشه صرفاً N را عوض نکنید. برای شناسه سراسری، کلید مرکب/UUID یا سیاست مشخص دیگری لازم است.

## تمرین و مشاهده مورد انتظار

روی کاغذ ۱۰ tenant با سهم بارهای `50,10,8,7,6,5,4,4,3,3` درصد را در سه شارد قرار دهید. بار هر شارد را جمع بزنید؛ سپس tenant اول را تنها روی شارد جدا بگذارید. انتظار: تعادل بهتر می‌شود، ولی همان شارد هنوز ۵۰٪ کل ترافیک دارد. برای تقسیم داخلی آن tenant، اثر روی تراکنش و query را بنویسید. در گام بعد query «مجموع فروش همه tenantها» را تحلیل کنید؛ مسیر مستقیم یک‌شاردی ندارد.

**حل تمرین نمونه:** مجموع سهم‌ها ۱۰۰٪ است. یک چینش سه‌شاردی ممکن `۵۰+۳=۵۳`، `۱۰+۸+۷=۲۵` و `۶+۵+۴+۴+۳=۲۲` درصد است؛ tenant بزرگ با یک tenant کوچک روی شارد اول قرار دارد. یک چینش چهارشاردی که آن را جدا می‌کند `۵۰`، سپس `۱۰+۷=۱۷`، `۸+۶+۳=۱۷` و `۵+۴+۴+۳=۱۶` درصد است. tenantهای دیگر نیز دوباره توزیع شده‌اند، نه اینکه صرفاً یک شارد اضافه شده باشد. tenant داغ هنوز ۵۰٪ بار کل را دارد؛ جداسازی، همسایهٔ پرسر‌وصدا را حذف می‌کند اما کار همان tenant را تقسیم نمی‌کند. تقسیم داخلی شاید کمک کند ولی تراکنش و query را پیچیده می‌کند. گزارش فروش سراسری باید روی شاردها fan-out شود و نتیجه‌ها را ادغام کند.

## شاهد عمومی

[گزارش مهندسی Discord در ۲۰۲۳](https://discord.com/blog/how-discord-stores-trillions-of-messages) توضیح می‌دهد partition پیام بر اساس channel و bucket زمانی چگونه زیر ترافیک نامتوازن داغ شد. تیم از سرویس داده، request coalescing و routing برای کاهش فشار استفاده کرد و مهاجرت موتور را نیز انجام داد. این تجربه نشان می‌دهد توزیع داده جای کنترل هم‌زمانی کلید داغ را نمی‌گیرد؛ انتخاب Cassandra/ScyllaDB و نتیجه آن قابل تعمیم مستقیم به SQL فروشگاه نیست.

## شکست‌ها، سیگنال‌ها و چک‌لیست

میانگین سالم کلاستر می‌تواند یک شارد اشباع را پنهان کند. بار، حجم و tail latency را per-shard ببینید. نقشه قدیمی، write دوگانه ناقص، حذف tenant از شرط، ID تکراری و migration متوقف می‌توانند خطای صحت بسازند. درخواست بین شاردها deadline و بودجه fan-out می‌خواهد.

- [ ] گلوگاه یک نود و گزینه‌های ساده‌تر با اندازه‌گیری رد/پذیرفته شده‌اند.
- [ ] Shard key از query و توزیع واقعی بار انتخاب شده است.
- [ ] تراکنش محلی و بین‌شاردی، join و گزارش سراسری طراحی شده‌اند.
- [ ] routing نسخه‌دار و مالکیت write هنگام cutover روشن است.
- [ ] انتقال، تطبیق، rollback و schema migration تمرین دارند.
- [ ] skew، hotspot و سلامت هر شارد جدا پایش می‌شوند.

## پیش‌نیازها، انتخاب کلید و حل توزیع بار

Shard داده را میان مالک‌های مستقل تقسیم می‌کند؛ shard key باید routing درخواست‌های پرتکرار را ممکن و توزیع داده/بار را قابل تحمل کند. Cardinality تعداد مقدارهای متمایز است و به‌تنهایی تعادل درخواست را نشان نمی‌دهد. Directory نگاشت tenant به shard و epoch نسخه مالکیت است تا مسیر قدیمی هنگام جابه‌جایی تشخیص داده شود.

### حل تمرین با جمع سهم‌ها

سهم tenantها ۵۰،۱۰،۸،۷،۶،۵،۴،۴،۳،۳ درصد و جمعاً ۱۰۰ است. اگر tenant اول تنها روی یک shard باشد، آن shard هنوز ۵۰٪ بار دارد. باقی‌مانده را می‌توان ۱۰+۷=۱۷، ۸+۶+۳=۱۷ و ۵+۴+۴+۳=۱۶ میان سه shard پخش کرد؛ سهم‌ها ۵۰/۱۷/۱۷/۱۶ می‌شوند. tenant داغ به زیرکلید یا سهمیه نیاز دارد، ولی تراکنش و query آن را پیچیده می‌کند. گزارش سراسری نیز باید از چند shard fan-out و merge کند.

اگر تعداد tenant زیاد ولی یک shard p99 یا queue بالایی دارد، per-shard بار و tenantهای پرترافیک را ببینید. در migration، مالکیت و epoch فعلی را بررسی؛ کپی اولیه، تغییرهای هم‌زمان، reconciliation، کنترل write و cutover را ترتیب دهید. تغییر N در hash modulo را انتقال گسترده کلیدها فرض کنید، نه تغییر تنظیم بی‌هزینه. Replica شاید read را پخش کند، اما مالکیت write را تقسیم نمی‌کند.

## جمع‌بندی

Sharding ظرفیت را با واگذاری مالکیت داده تقسیم می‌کند و routing، migration و query سراسری را دشوارتر می‌سازد. میانگین کلاستر hotspot را پنهان می‌کند.

## خودآزمایی

۱. چرا افزودن Replica مشکل ظرفیت write اصلی را لزوماً حل نمی‌کند؟

۲. آیا تعداد tenant زیاد توزیع یکنواخت را تضمین می‌کند؟

۳. چرا tenant در queryهای پرتکرار، Shard key قابل بررسی است؟

۴. تغییر مستقیم N در `hash % N` چه خطری دارد؟

۵. حین جابه‌جایی، چرا کنترل مالکیت write مهم است؟

### پاسخ‌نامه با دلیل

۱. Replica همان تغییرها را کپی می‌کند؛ Sharding مالکیت write را بین زیرمجموعه‌ها تقسیم می‌کند.

۲. خیر؛ توزیع درخواست/داده می‌تواند بسیار نامتوازن باشد و یک کلید داغ باقی بماند.

۳. routing بسیاری از درخواست‌ها به یک شارد ممکن می‌شود؛ البته tenant بزرگ همچنان نیازمند تحلیل است.

۴. محل تعداد زیادی کلید عوض می‌شود؛ داده و نقشه ناسازگار می‌شوند مگر migration طراحی شود.

۵. دو نویسنده یا routing قدیمی می‌تواند داده متناقض بسازد؛ cutover باید مرز مالکیت روشنی داشته باشد.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- انگلیسی: [Discord: How Discord Stores Trillions of Messages](https://discord.com/blog/how-discord-stores-trillions-of-messages)؛ شاهد اول‌شخص Hot partition و کنترل درخواست.
- انگلیسی: [PostgreSQL Table partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)؛ برای تفکیک partition محلی از معماری شارد.
- فارسی: [مروری بر مفاهیم مقدماتی NoSQL](https://dntips.ir/www.dntips.ir-posts-1472.html)؛ بخش Sharding برای واژگان مقدماتی، با توجه به قدیمی‌بودن و تعمیم‌های محدود آن. این لینک دستور ساخت کلاستر امروزی نیست.

- English, official: [Azure architecture: sharding pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/sharding) covers shard-key decisions, routing, and cross-shard limitations.
- English, official: [Citus data modeling](https://docs.citusdata.com/en/stable/sharding/data_modeling.html) explains distribution-column choices and co-location in a PostgreSQL extension.
- English, official: [PostgreSQL table partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html) clarifies local partitioning behavior; it is not a general multi-server sharding guide.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Replication](../10-replication/README.md) · [بعدی: Profiling](../12-database-profiling/README.md) · [Scaling](../../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md) · [Stampede](../../01-caching/04-invalidation-and-freshness/README.md)

</div>


