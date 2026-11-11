===== Backend Performace\04-databases\10-replication\README.md =====
   1: <div dir="rtl" align="right">
   2: 
   3: # Replication — کپی داده با قرارداد سازگاری
   4: 
   5: **هدف یادگیری:** Read replica را از Backup و Shard جدا کنید، lag و read-after-write را در طراحی وارد کنید و هزینه synchronous replication را توضیح دهید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ بخش SQL نمونه PostgreSQL و اجرا‌نشده است.
   6: 
   7: ## مدل ذهنی
   8: 
   9: Replication کپی داده/تغییرات را روی نود دیگری نگه می‌دارد. در معماری single-primary، write به Primary می‌رود و بعضی readها به Replica. ظرفیت خواندن ممکن است بیشتر شود؛ ظرفیت write اولیه لزوماً بیشتر نمی‌شود، چون تغییر باید تولید و به کپی‌ها اعمال شود. Replication هم‌زمان یا ناهم‌زمان است؛ physical و logical نیز مدل‌های متفاوت با قابلیت‌های متفاوت‌اند.
  10: 
  11: | انتخاب | سود | هزینه/ریسک |
  12: | --- | --- | --- |
  13: | Async replica | read جدا و commit مستقل از انتظار کپی | lag و احتمال از دست‌رفتن write تأییدشده در failover |
  14: | Sync replica | تضمین قوی‌تر طبق سطح تأیید | latency شبکه و وابستگی availability به quorum/config |
  15: | Read روی Primary | مشاهده تازه‌تر پس از commit | مصرف ظرفیت اصلی |
  16: 
  17: در PostgreSQL، سطح تأیید synchronous commit اهمیت دارد: دریافت/flush روی standby با replay و قابل‌دیدن‌شدن برای query یکی نیست. `remote_apply` برای انتظار اعمال رفتار قوی‌تری دارد. [راهنمای standby و replication](https://www.postgresql.org/docs/current/warm-standby.html) مرجع این تفاوت‌هاست.
  18: 
  19: ## کاربرد و مصالحه
  20: 
  21: برای گزارش یا کاتالوگ با بودجه کهنگی مشخص، replica می‌تواند مناسب باشد. برای بلافاصله دیدن سفارش ثبت‌شده، خواندن Primary، انتظار تا موقعیت مشخص replication یا routing مبتنی بر session از گزینه‌های طراحی است. «همیشه چند ثانیه صبر کن» تضمین نیست؛ lag تحت اختلال تغییر می‌کند. Replica نیز هزینه CPU، دیسک، شبکه، پایش و failover دارد.
  22: 
  23: ## مثال حل‌شده
  24: 
  25: سناریوی فرضی: سفارش روی Primary در `t=0` commit می‌شود و Replica در `t=2s` آن را replay می‌کند. خواندن فهرست از Replica در `t=0.2s` می‌تواند سفارش را نبیند. مسیر پیشنهادی برای قرارداد read-after-write:
  26: 
  27: <div dir="ltr" align="left">
  28: 
  29: ```text
  30: write_result = primary.commit_order(command)
  31: return write_result.order
  32: 
  33: on subsequent order detail read:
  34:     if consistency requires read_after_write:
  35:         read primary
  36:     else:
  37:         read eligible replica within freshness budget
  38: ```
  39: 
  40: ```sql
  41: -- On a PostgreSQL standby; privileges/version matter:
  42: SELECT pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn();
  43: ```
  44: 
  45: </div>
  46: 
  47: موقعیت دریافت و replay برای تشخیص فاصله مراحل مفید است؛ مقدار NULL/متوقف نیازمند تفسیر وضعیت recovery است. اختلاف LSN اندازه بایت است، نه تضمین مدت کهنگی. lag را با وضعیت اتصال، نرخ write و زمان/موقعیت اعمال تفسیر کنید. [توابع recovery](https://www.postgresql.org/docs/current/functions-admin.html) رفتار توابع را مشخص می‌کند.
  48: 
  49: ## تمرین و مشاهده مورد انتظار
  50: 
  51: روی کاغذ timeline با commit در ثانیه صفر، قطع شبکه تا ثانیه ۱۰ و دو read در ثانیه ۱ و ۵ رسم کنید. برای «نمایش سفارش خود کاربر» و «آمار دیروز» مسیر read را جدا انتخاب کنید. انتظار: نیاز اول بدون Primary یا انتظار مبتنی بر پیشرفت تضمین نمی‌شود؛ نیاز دوم می‌تواند با بودجه کهنگی پذیرفته شود. سپس failure هنگام failover را تحلیل کنید: کدام write در async ممکن است به Replica نرسیده باشد؟
  52: 
  53: ## شاهد عمومی و حد شواهد
  54: 
  55: [مستند رسمی Hot standby](https://www.postgresql.org/docs/current/hot-standby.html) تعارض queryهای خواندن طولانی با replay را شرح می‌دهد؛ بسته به تنظیم، query ممکن است لغو شود یا replay عقب بیفتد. این شاهد عملیاتی معتبر است؛ سناریوی زمان‌های بالا فرضی است و نتیجه تولیدی یک شرکت نیست. فعال‌کردن feedback نیز هزینه احتمالی نگهداری نسخه‌ها در Primary دارد.
  56: 
  57: ## شکست‌ها، سیگنال‌ها و چک‌لیست
  58: 
  59: Replica جای Backup نیست: delete اشتباه نیز تکثیر می‌شود. Failover بدون fencing می‌تواند دو Primary فعال بسازد. lag پنهان، WAL نگه‌داشته‌شده در slot و query لغوشده standby را پایش کنید. [آمار replication](https://www.postgresql.org/docs/current/monitoring-stats.html) را با بازه و نسخه واقعی تفسیر کنید؛ NULL در lag الزاماً صفر نیست.
  60: 
  61: - [ ] readها بر اساس تازگی و read-after-write طبقه‌بندی شده‌اند.
  62: - [ ] mode تأیید commit و رفتار هنگام نبود standby مشخص است.
  63: - [ ] lag، replay progress، conflict و WAL retention پایش می‌شود.
  64: - [ ] eligibility، fallback و جلوگیری از بار ناگهانی روی Primary طراحی شده است.
  65: - [ ] failover، fencing، reconnect و RPO/RTO تمرین می‌شوند.
  66: - [ ] Backup جدا و بازیابی آزموده‌شده وجود دارد.
  67: 
  68: ## خودآزمایی
  69: 
  70: ۱. Replica چه تفاوتی با Shard دارد؟
  71: 
  72: ۲. چرا commit موفق async تضمین مشاهده فوری در Replica نیست؟
  73: 
  74: ۳. آیا هر synchronous commit یعنی read فوراً داده را روی standby می‌بیند؟
  75: 
  76: ۴. چرا replica جای Backup را نمی‌گیرد؟
  77: 
  78: ۵. query طولانی روی hot standby چه اثری می‌تواند داشته باشد؟
  79: 
  80: ### پاسخ‌نامه با دلیل
  81: 
  82: ۱. Replica کپی همان داده است؛ Shard مالک بخش متفاوتی از مجموعه داده است.
  83: 
  84: ۲. انتقال و replay جدا و با تأخیرند؛ commit اصلی منتظر آن‌ها نمی‌ماند.
  85: 
  86: ۳. خیر؛ سطح تأیید دریافت/flush با replay تفاوت دارد و تنظیم تعیین‌کننده است.
  87: 
  88: ۴. خطای منطقی مانند حذف اشتباه تکثیر می‌شود؛ بازیابی به نقطه سالم مسیر دیگری می‌خواهد.
  89: 
  90: ۵. با replay تعارض می‌کند؛ ممکن است query لغو یا اعمال عقب بیفتد، طبق تنظیم.
  91: 
  92: ## منابع
  93: 
  94: - انگلیسی: [Warm standby/replication](https://www.postgresql.org/docs/current/warm-standby.html)، [Hot standby](https://www.postgresql.org/docs/current/hot-standby.html)؛ modeها و تعارض‌ها.
  95: - انگلیسی: [Recovery functions](https://www.postgresql.org/docs/current/functions-admin.html)؛ موقعیت WAL و معنای توابع.
  96: - فارسی: [مروری بر مفاهیم مقدماتی NoSQL](https://dntips.ir/www.dntips.ir-posts-1472.html)؛ بخش تکثیر و تفاوت با تقسیم داده، منبع مقدماتی قدیمی است. تعمیم‌های آن درباره همه NoSQLها مبنای این درس نیست و تنظیم PostgreSQL را پوشش نمی‌دهد.
  97: 
  98: [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Slow logs](../09-slow-query-logging/README.md) · [بعدی: Sharding](../11-sharding/README.md) · [تازگی کش](../../01-caching/04-invalidation-and-freshness/README.md)
  99: 
 100: </div>

===== Backend Performace\04-databases\11-sharding\README.md =====
   1: <div dir="rtl" align="right">
   2: 
   3: # Sharding — تقسیم مالکیت داده میان نودها
   4: 
   5: **هدف یادگیری:** Shard key را از الگوی دسترسی انتخاب کنید، hotspot و cross-shard query را تشخیص دهید و هزینه جابه‌جایی داده را پیش از اجرای تصمیم بنویسید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ مثال مفهومی و اجرا‌نشده است.
   6: 
   7: ## مدل ذهنی
   8: 
   9: Sharding داده را میان چند دیتابیس/گروه نود تقسیم می‌کند؛ هر شارد مالک زیرمجموعه‌ای از داده است. Replica کپی همان زیرمجموعه است. Partitioning جدول در یک موتور الزاماً چند سرور مستقل نمی‌سازد؛ مثلاً partition بومی PostgreSQL را به‌تنهایی معادل سامانه توزیع‌شده فرض نکنید. [مستند Table partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html) محدوده این قابلیت را مشخص می‌کند.
  10: 
  11: | راه تقسیم | مزیت | خطر |
  12: | --- | --- | --- |
  13: | Range مانند بازه زمان | locality و range scan | داغ‌شدن بازه جدید |
  14: | Hash کلید | توزیع مناسب‌تر در بسیاری از بارها | range query و tenant بسیار داغ |
  15: | Directory/lookup | انتقال tenant انعطاف‌پذیر | وابستگی حیاتی به نقشه routing |
  16: 
  17: کلید خوب باید در queryهای پرتکرار حضور داشته باشد، مالکیت را واضح کند و توزیع بار مناسب بدهد. Cardinality زیاد الزاماً یکنواختی بار نیست؛ یک tenant از میان میلیون‌ها tenant می‌تواند بیشتر ترافیک را بسازد. کم‌شدن تعداد ردیف هر شارد، مشکل یک کلید بسیار داغ را خودکار رفع نمی‌کند.
  18: 
  19: ## کاربرد و مصالحه
  20: 
  21: وقتی ظرفیت ذخیره/نوشتن یا محدودیت عملیاتی یک نود پس از اصلاح query و استفاده مناسب از scale-up/replica کافی نیست، Sharding نامزد است. برای سرویس کوچک یا queryهای سراسری فراوان، پیچیدگی routing، join، transaction، schema migration و عملیات می‌تواند سود را ببلعد. گزارش سراسری ممکن است به fan-out و merge یا سامانه تحلیلی جدا نیاز داشته باشد. چند شارد یعنی چند مجموعه نیازمند backup، پایش و تغییر schema.
  22: 
  23: ## مثال حل‌شده
  24: 
  25: فروشگاه چندمستاجری آموزشی اکثر سفارش‌ها را با tenant می‌خواند. Directory مالک tenant را مشخص می‌کند؛ سفارش و اقلامش روی یک شارد نگه داشته می‌شوند تا تراکنش محلی بماند.
  26: 
  27: <div dir="ltr" align="left">
  28: 
  29: ```text
  30: route = directory.lookup(tenant_id)  # returns shard_id + epoch
  31: database = connect_to(route.shard_id)
  32: assert database.accepts(tenant_id, route.epoch)
  33: database.execute(
  34:   "SELECT id, total FROM orders WHERE tenant_id = ? AND id = ?",
  35:   [tenant_id, order_id]
  36: )
  37: ```
  38: 
  39: </div>
  40: 
  41: epoch کمک می‌کند write با نقشه قدیمی در انتقال مالکیت رد شود؛ خودش الگوریتم migration کامل نیست. انتقال شامل کپی اولیه، گرفتن تغییرهای هم‌زمان، تطبیق، cutover با جلوگیری از دو نویسنده و راه برگشت است. `hash(key) % N` با تغییر N بسیاری از کلیدها را جابه‌جا می‌کند؛ بدون migration و نسخه‌بندی نقشه صرفاً N را عوض نکنید. برای شناسه سراسری، کلید مرکب/UUID یا سیاست مشخص دیگری لازم است.
  42: 
  43: ## تمرین و مشاهده مورد انتظار
  44: 
  45: روی کاغذ ۱۰ tenant با سهم بارهای `50,10,8,7,6,5,4,4,3,3` درصد را در سه شارد قرار دهید. بار هر شارد را جمع بزنید؛ سپس tenant اول را تنها روی شارد جدا بگذارید. انتظار: تعادل بهتر می‌شود، ولی همان شارد هنوز ۵۰٪ کل ترافیک دارد. برای تقسیم داخلی آن tenant، اثر روی تراکنش و query را بنویسید. در گام بعد query «مجموع فروش همه tenantها» را تحلیل کنید؛ مسیر مستقیم یک‌شاردی ندارد.
  46: 
  47: ## شاهد عمومی
  48: 
  49: [گزارش مهندسی Discord در ۲۰۲۳](https://discord.com/blog/how-discord-stores-trillions-of-messages) توضیح می‌دهد partition پیام بر اساس channel و bucket زمانی چگونه زیر ترافیک نامتوازن داغ شد. تیم از سرویس داده، request coalescing و routing برای کاهش فشار استفاده کرد و مهاجرت موتور را نیز انجام داد. این تجربه نشان می‌دهد توزیع داده جای کنترل هم‌زمانی کلید داغ را نمی‌گیرد؛ انتخاب Cassandra/ScyllaDB و نتیجه آن قابل تعمیم مستقیم به SQL فروشگاه نیست.
  50: 
  51: ## شکست‌ها، سیگنال‌ها و چک‌لیست
  52: 
  53: میانگین سالم کلاستر می‌تواند یک شارد اشباع را پنهان کند. بار، حجم و tail latency را per-shard ببینید. نقشه قدیمی، write دوگانه ناقص، حذف tenant از شرط، ID تکراری و migration متوقف می‌توانند خطای صحت بسازند. درخواست بین شاردها deadline و بودجه fan-out می‌خواهد.
  54: 
  55: - [ ] گلوگاه یک نود و گزینه‌های ساده‌تر با اندازه‌گیری رد/پذیرفته شده‌اند.
  56: - [ ] Shard key از query و توزیع واقعی بار انتخاب شده است.
  57: - [ ] تراکنش محلی و بین‌شاردی، join و گزارش سراسری طراحی شده‌اند.
  58: - [ ] routing نسخه‌دار و مالکیت write هنگام cutover روشن است.
  59: - [ ] انتقال، تطبیق، rollback و schema migration تمرین دارند.
  60: - [ ] skew، hotspot و سلامت هر شارد جدا پایش می‌شوند.
  61: 
  62: ## خودآزمایی
  63: 
  64: ۱. چرا افزودن Replica مشکل ظرفیت write اصلی را لزوماً حل نمی‌کند؟
  65: 
  66: ۲. آیا تعداد tenant زیاد توزیع یکنواخت را تضمین می‌کند؟
  67: 
  68: ۳. چرا tenant در queryهای پرتکرار، Shard key قابل بررسی است؟
  69: 
  70: ۴. تغییر مستقیم N در `hash % N` چه خطری دارد؟
  71: 
  72: ۵. حین جابه‌جایی، چرا کنترل مالکیت write مهم است؟
  73: 
  74: ### پاسخ‌نامه با دلیل
  75: 
  76: ۱. Replica همان تغییرها را کپی می‌کند؛ Sharding مالکیت write را بین زیرمجموعه‌ها تقسیم می‌کند.
  77: 
  78: ۲. خیر؛ توزیع درخواست/داده می‌تواند بسیار نامتوازن باشد و یک کلید داغ باقی بماند.
  79: 
  80: ۳. routing بسیاری از درخواست‌ها به یک شارد ممکن می‌شود؛ البته tenant بزرگ همچنان نیازمند تحلیل است.
  81: 
  82: ۴. محل تعداد زیادی کلید عوض می‌شود؛ داده و نقشه ناسازگار می‌شوند مگر migration طراحی شود.
  83: 
  84: ۵. دو نویسنده یا routing قدیمی می‌تواند داده متناقض بسازد؛ cutover باید مرز مالکیت روشنی داشته باشد.
  85: 
  86: ## منابع
  87: 
  88: - انگلیسی: [Discord: How Discord Stores Trillions of Messages](https://discord.com/blog/how-discord-stores-trillions-of-messages)؛ شاهد اول‌شخص Hot partition و کنترل درخواست.
  89: - انگلیسی: [PostgreSQL Table partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)؛ برای تفکیک partition محلی از معماری شارد.
  90: - فارسی: [مروری بر مفاهیم مقدماتی NoSQL](https://dntips.ir/www.dntips.ir-posts-1472.html)؛ بخش Sharding برای واژگان مقدماتی، با توجه به قدیمی‌بودن و تعمیم‌های محدود آن. این لینک دستور ساخت کلاستر امروزی نیست.
  91: 
  92: [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Replication](../10-replication/README.md) · [بعدی: Profiling](../12-database-profiling/README.md) · [Scaling](../../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md) · [Stampede](../../01-caching/04-invalidation-and-freshness/README.md)
  93: 
  94: </div>

===== Backend Performace\04-databases\12-database-profiling\README.md =====
   1: <div dir="rtl" align="right">
   2: 
   3: # Profiling دیتابیس — از هزینه کل تا گره پرهزینه پلن
   4: 
   5: **هدف یادگیری:** query پرهزینه را بر اساس بازه و هزینه مجموع پیدا کنید، EXPLAIN را تفسیر کنید و بهینه‌سازی را با مشاهده قابل مقایسه تأیید کنید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ دستورهای نمونه PostgreSQL ۱۸ هستند و اجرا نشده‌اند.
   6: 
   7: ## مدل ذهنی و ترتیب کار
   8: 
   9: Profiling یعنی اندازه‌گیری برای نسبت‌دادن هزینه به مسیر مشخص. ابتدا latency درخواست را به Pool، اجرای SQL، شبکه و پردازش برنامه تقسیم کنید. سپس خانواده query را بر اساس تعداد، زمان مجموع و مصرف I/O رتبه‌بندی کنید. بعد یک اجرای نماینده را با plan، انتظار قفل و داده/پارامتر واقعی تحلیل کنید. اصلاح بدون خط پایه قابل انتساب نیست.
  10: 
  11: | ابزار PostgreSQL | کاربرد | محدودیت |
  12: | --- | --- | --- |
  13: | pg_stat_activity و wait events | اجرای جاری و انتظار | عکس لحظه‌ای، نه سابقه کامل |
  14: | pg_stat_statements | آمار خانواده statement | تجمیع، reset و بازه؛ بدون p99 واقعی |
  15: | EXPLAIN | پلن تخمینی | اجرای واقعی را اندازه نمی‌گیرد |
  16: | EXPLAIN ANALYZE + BUFFERS | ردیف/زمان واقعی و buffer | query را اجرا و سربار اضافه می‌کند |
  17: | ابزار سیستم/trace | CPU، دیسک، شبکه و هم‌بستگی | نسبت‌دادن نیازمند context است |
  18: 
  19: [مرور رسمی پایش دیتابیس](https://www.postgresql.org/docs/current/monitoring.html) ابزارهای داخلی و سیستم را مکمل هم می‌داند. buffer hit به معنی رایگان‌بودن query نیست؛ CPU، lock و mapping همچنان هزینه دارند.
  20: 
  21: ## کاربرد و مصالحه
  22: 
  23: پیش از index یا تغییر schema، query پرتکرار را بر هزینه مجموع بسنجید. نمونه کند استثنایی نیز با SLO و تجربه کاربر اهمیت دارد؛ فقط یک ranking کافی نیست. Pg_stat_statements باید در `shared_preload_libraries` آماده شود و راه‌اندازی اولیه آن restart می‌خواهد؛ فعال‌سازی extension و مجوزها نیز لازم است. تنظیم موجود preload را با یک رشته جدید جایگزین نکنید. [مرجع ماژول](https://www.postgresql.org/docs/current/pgstatstatements.html) جزئیات normalization، محدودیت‌ها و سربار planning را شرح می‌دهد.
  24: 
  25: ## مثال حل‌شده
  26: 
  27: در محیطی که extension از قبل نصب و آماده است، query زیر رتبه‌بندی تجمعی از آخرین reset را نشان می‌دهد. برای پنجره آزمایش، دو snapshot از counters و calls بگیرید و اختلاف را حساب کنید؛ آمار مشترک production را برای آزمایش شخصی reset نکنید. تغییر reset یا حذف entry میان دو snapshot مقایسه را نامعتبر می‌کند.
  28: 
  29: <div dir="ltr" align="left">
  30: 
  31: ```sql
  32: SELECT queryid, calls, total_exec_time, mean_exec_time,
  33:        rows, shared_blks_hit, shared_blks_read
  34: FROM pg_stat_statements
  35: ORDER BY total_exec_time DESC
  36: LIMIT 10;
  37: 
  38: EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
  39: SELECT id, total
  40: FROM orders
  41: WHERE customer_id = 42
  42: ORDER BY created_at DESC, id DESC
  43: LIMIT 20;
  44: ```
  45: 
  46: </div>
  47: 
  48: جدول فرضی orders ستون‌های id، total، customer_id و created_at دارد. پارامتر ۴۲ باید نماینده توزیع واقعی باشد. در پلن، estimate/actual rows، loops، sort و bufferها را ببینید؛ cost واحد مدل planner است، میلی‌ثانیه نیست. در گره دارای loops، actual time/rows معمولاً به‌ازای هر اجرا گزارش می‌شوند. زمان والد شامل کار زیرشاخه است؛ زمان گره‌ها را ساده با هم جمع نزنید. [Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html) مرجع خواندن این اعداد است.
  49: 
  50: ## تمرین و مشاهده مورد انتظار
  51: 
  52: دو خانواده فرضی بسازید: A با ۱۰ هزار بار اجرای ۲ms و B با ۱۰ بار اجرای ۲۰۰ms. هزینه مجموع را حساب کنید، سپس یک index یا Projection را فقط روی A در محیط آزمایشی مقایسه کنید. انتظار: A با ۲۰s بالاتر از B با ۲s است؛ mean بالاتر B به‌تنهایی اولویت ظرفیت را تعیین نمی‌کند. پیش/پس را در پنجره مشابه، با تعداد فراخوانی، داده و حالت cache ثبت کنید. اجرای سرد و گرم را برچسب بزنید و برای کسب «آزمایش سرد» cache تولید را پاک نکنید.
  53: 
  54: ## شاهد عمومی و حد شواهد
  55: 
  56: [نمونه رسمی pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) رتبه‌بندی زمان مجموع و buffer را روی workload آزمایشی نشان می‌دهد؛ گزارش production شرکت نیست. [نوشته فارسی PostGIS](https://asnegar.ir/blog/postgis-optimization/) نیز نمونه عمومی استفاده از EXPLAIN برای تشخیص و تغییر query است؛ اندازه‌گیری آن مستقل بازتولید نشده و مثال orders از آن استخراج نشده است.
  57: 
  58: ## شکست‌ها، سیگنال‌ها و چک‌لیست
  59: 
  60: پارامتر نامعمول، statistics reset، تغییر ترافیک یا اجرای benchmark فقط با cache گرم می‌تواند مقایسه را منحرف کند. آمار تجمیعی percentile نیست؛ mean را p95 ننامید. EXPLAIN ANALYZE روی write واقعاً write را اجرا می‌کند؛ ROLLBACK همه اثرهای خارجی trigger/sequence را خنثی نمی‌کند. این درس صرفاً SELECT آزمایشی دارد. query text و plan را نیز با سیاست داده حساس نگهداری کنید.
  61: 
  62: - [ ] بازه، reset، تعداد calls و ترافیک مقایسه مشخص‌اند.
  63: - [ ] زمان Pool، SQL، شبکه و mapping از هم تفکیک شده‌اند.
  64: - [ ] ranking هم هزینه مجموع و هم اثر روی SLO را در نظر می‌گیرد.
  65: - [ ] estimate/actual، loops، buffers و spill بررسی شده‌اند.
  66: - [ ] فقط یک تغییر با خروجی و داده نماینده سنجیده می‌شود.
  67: - [ ] سربار instrumentation، مجوز و دسترسی به SQL/plan کنترل شده‌اند.
  68: - [ ] نتیجه با latency انتهابه‌انتها و هزینه write تأیید می‌شود.
  69: 
  70: ## خودآزمایی
  71: 
  72: ۱. cost در EXPLAIN میلی‌ثانیه است؟
  73: 
  74: ۲. آیا mean_exec_time همان p99 است؟
  75: 
  76: ۳. چرا queryهای سریع پرتکرار در رتبه‌بندی مهم‌اند؟
  77: 
  78: ۴. EXPLAIN با EXPLAIN ANALYZE چه تفاوتی دارد؟
  79: 
  80: ۵. چرا جمع زمان همه گره‌های plan درست نیست؟
  81: 
  82: ۶. اگر total_exec_time پیش/پس کم شد ولی calls نیز نصف شد، چه نتیجه‌ای می‌گیرید؟
  83: 
  84: ### پاسخ‌نامه با دلیل
  85: 
  86: ۱. خیر؛ واحد تخمینی مدل هزینه planner است و نباید با ساعت مقایسه مستقیم شود.
  87: 
  88: ۲. خیر؛ میانگین است. percentile به توزیع اجراها یا histogram/trace مناسب نیاز دارد.
  89: 
  90: ۳. تعداد زیاد می‌تواند هزینه مجموع، ظرفیت CPU و رفت‌وبرگشت را غالب کند.
  91: 
  92: ۴. اولی تخمین پلن است؛ دومی واقعاً اجرا و اندازه‌گیری می‌کند و سربار/اثر دارد.
  93: 
  94: ۵. زمان والد شامل کار فرزند است؛ جمع ساده دوباره‌شماری می‌کند و loops نیز باید تفسیر شود.
  95: 
  96: ۶. بهبود ثابت نشده؛ حجم و ترکیب بار تغییر کرده‌اند. نرخ/هزینه هر call و پنجره قابل مقایسه لازم است.
  97: 
  98: ## منابع
  99: 
 100: - انگلیسی: [Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)؛ خواندن plan و caveatهای اندازه‌گیری.
 101: - انگلیسی: [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) و [Monitoring](https://www.postgresql.org/docs/current/monitoring.html)؛ تجمیع و مشاهده فعالیت.
 102: - فارسی: [تشخیص و بهینه‌سازی PostGIS با EXPLAIN](https://asnegar.ir/blog/postgis-optimization/)؛ مثال مرتبط با حدود شواهد بیان‌شده، نه مرجع تمام جزئیات PostgreSQL.
 103: 
 104: [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Sharding](../11-sharding/README.md) · [شروع دوباره از Pooling](../01-connection-pooling/README.md) · [Slow logs](../09-slow-query-logging/README.md) · [Application profiling](../../06-code-optimization/02-application-profiling/README.md) · [آزمون عملکرد](../../09-performance-testing/README.md)
 105: 
 106: </div>

