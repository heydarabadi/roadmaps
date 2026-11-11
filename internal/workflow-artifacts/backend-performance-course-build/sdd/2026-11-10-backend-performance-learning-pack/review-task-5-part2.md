===== Backend Performace\04-databases\04-efficient-database-pagination\README.md =====
   1: <div dir="rtl" align="right">
   2: 
   3: # صفحه‌بندی کارآمد در دیتابیس
   4: 
   5: **هدف یادگیری:** هزینه OFFSET را از اندازه صفحه جدا کنید، Keyset با ترتیب قطعی بنویسید و تغییر هم‌زمان داده را تحلیل کنید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ نمونه PostgreSQL آموزشی و اجرا‌نشده است.
   6: 
   7: ## مدل ذهنی
   8: 
   9: OFFSET می‌گوید چند ردیف نتیجه کنار گذاشته شود؛ موتور همچنان باید مسیر رسیدن به آن نقطه را طی کند. LIMIT تنها اندازه خروجی را محدود می‌کند. Keyset از آخرین کلید مرتب‌سازی صفحه قبل شروع می‌کند؛ با ایندکس سازگار، کار پیمایش ردیف‌های دورریخته‌شده کمتر می‌شود. ترتیب باید قطعی باشد؛ timestamp به‌تنهایی در صورت تساوی کافی نیست. [مستند LIMIT/OFFSET PostgreSQL](https://www.postgresql.org/docs/current/queries-limit.html) هزینه offset بزرگ و ضرورت ترتیب قابل پیش‌بینی را توضیح می‌دهد.
  10: 
  11: | روش | مزیت | محدودیت |
  12: | --- | --- | --- |
  13: | OFFSET | پرش مستقیم به شماره صفحه | کار بیشتر در عمق، جابه‌جایی با درج/حذف |
  14: | Keyset | ادامه پیمایش از کلید | پرش دلخواه دشوار، وابستگی به sort |
  15: | Snapshot ثابت | گزارش با مجموعه ثابت | نگهداری snapshot/نسخه و هزینه عملیاتی |
  16: 
  17: Keyset تضمین snapshot نیست: تغییر مقدار sort ممکن است باعث تکرار یا جاافتادن شود. برای export دقیق، قرارداد snapshot یا high-water mark متناسب با نیاز تعریف کنید.
  18: 
  19: ## کاربرد و مصالحه
  20: 
  21: برای feed و پیمایش متوالی بزرگ مناسب است. صفحه‌های کوچک کم‌عمق با نیاز پرش به شماره مشخص ممکن است OFFSET را توجیه کنند. COUNT دقیق را جدا قیمت‌گذاری کنید؛ شمارش همه ردیف‌ها می‌تواند از گرفتن صفحه گران‌تر باشد. NULL، sort ترکیبی صعودی/نزولی و چند tenant شرط seek را پیچیده می‌کنند؛ مثال پایین ستون‌های NOT NULL و جهت یکسان دارد.
  22: 
  23: ## مثال حل‌شده
  24: 
  25: طرح فرضی: `orders(id bigint primary key, customer_id bigint not null, created_at timestamp not null)`. صفحه اول همان query بدون شرط cursor است؛ صفحه بعد از آخرین `(created_at,id)` استفاده می‌کند.
  26: 
  27: <div dir="ltr" align="left">
  28: 
  29: ```sql
  30: CREATE INDEX orders_page_idx
  31: ON orders(customer_id, created_at DESC, id DESC);
  32: 
  33: SELECT id, created_at
  34: FROM orders
  35: WHERE customer_id = 42
  36:   AND (created_at, id) < (TIMESTAMP '2026-10-01 12:00:00', 9001)
  37: ORDER BY created_at DESC, id DESC
  38: LIMIT 21;
  39: ```
  40: 
  41: </div>
  42: 
  43: اندازه نمایشی ۲۰ است؛ ردیف ۲۱ فقط برای تشخیص ادامه مصرف می‌شود. Cursor بعدی از ردیف بیستم ساخته می‌شود، نه بیست‌ویکم. فیلتر مشتری در هر صفحه تکرار می‌شود و به Cursor برای مجوز اعتماد نمی‌کنیم. مقادیر واقعی bind می‌شوند. اینجا مکانیک SQL بررسی می‌شود؛ شکل Cursor، خطای ورودی و قرارداد API در [درس صفحه‌بندی API](../../02-api-response/03-efficient-pagination/README.md) است.
  44: 
  45: ## تمرین و مشاهده مورد انتظار
  46: 
  47: در جدول آزمایشی ۱۰۰ هزار ردیف با timestampهای مساوی بسازید. `LIMIT 20 OFFSET 80000` و seek متناظر را با `EXPLAIN (ANALYZE, BUFFERS)` مقایسه کنید. سپس میان دو صفحه یک ردیف جدید قبل از مرز درج کنید. انتظار: OFFSET می‌تواند دوباره ردیف انتهای صفحه قبلی را نشان دهد؛ Keyset با کلیدهای ثابت از مرز ادامه می‌دهد، ولی رکورد جدید قبل از مرز را در ادامه نمی‌بیند. bufferها و rows پلن را مقایسه کنید؛ شتاب عددی ثابت انتظار نداشته باشید.
  48: 
  49: ## شاهد عمومی
  50: 
  51: [مستند توسعه GitLab برای Keyset pagination](https://docs.gitlab.com/development/database/keyset_pagination/) استفاده از ترتیب، کلید متمایز و Cursor را در یک محصول واقعی مستند می‌کند. این راهنمای مهندسی شاهد کاربرد است، نه benchmark مستقل برای مثال ما؛ محدودیت sort و index باید در workload خود سنجیده شود.
  52: 
  53: ## شکست‌ها، سیگنال‌ها و چک‌لیست
  54: 
  55: latency صعودی با شماره صفحه، rows scanned بسیار بیشتر از rows returned و sort روی دیسک نشانه‌های قابل بررسی‌اند. حذف tie-breaker، جهت نادرست comparator، تغییر فیلتر بین صفحات و cursor بر پایه فیلد mutable از خطاهای رایج‌اند.
  56: 
  57: - [ ] sort قطعی، جهت comparator و رفتار NULL مشخص است.
  58: - [ ] index با tenant/filter و order سازگار بررسی شده است.
  59: - [ ] اندازه صفحه سقف دارد و COUNT هزینه مستقل دارد.
  60: - [ ] درج، حذف و تغییر sort میان صفحات تحلیل شده است.
  61: - [ ] Cursor به فیلتر مرتبط است و مجوز هر درخواست دوباره بررسی می‌شود.
  62: - [ ] صفحه عمیق، مرز تساوی و پایان مجموعه بررسی می‌شوند.
  63: 
  64: ## خودآزمایی
  65: 
  66: ۱. چرا LIMIT کوچک، OFFSET بزرگ را لزوماً ارزان نمی‌کند؟
  67: 
  68: ۲. در ترتیب نزولی مثال، شرط صفحه بعد `<` است یا `>`؟
  69: 
  70: ۳. اگر چند ردیف timestamp یکسان داشته باشند، چه لازم است؟
  71: 
  72: ۴. آیا Keyset همه داده‌ها را در یک snapshot می‌بیند؟
  73: 
  74: ۵. چرا Cursor از ردیف بیستم ساخته می‌شود؟
  75: 
  76: ### پاسخ‌نامه با دلیل
  77: 
  78: ۱. موتور باید ردیف‌های پیش از offset را محاسبه/عبور کند؛ خروجی کوچک برابر کار کم نیست.
  79: 
  80: ۲. `<`؛ بعدی در ترتیب نزولی کلید کوچک‌تر دارد، با فرض جهت یکسان هر دو ستون.
  81: 
  82: ۳. کلید یکتای تکمیلی مانند id؛ وگرنه مرز صفحه مبهم می‌شود.
  83: 
  84: ۴. خیر؛ snapshot و تغییر ستون مرتب‌سازی مسئله جدا هستند.
  85: 
  86: ۵. آن ردیف آخرین ردیف تحویل‌شده است؛ استفاده از ردیف اضافی باعث جاافتادنش می‌شود.
  87: 
  88: ## منابع
  89: 
  90: - انگلیسی: [PostgreSQL LIMIT/OFFSET](https://www.postgresql.org/docs/current/queries-limit.html)؛ مبنای هزینه و ترتیب.
  91: - انگلیسی: [GitLab Keyset pagination](https://docs.gitlab.com/development/database/keyset_pagination/)؛ پیاده‌سازی و محدودیت‌های کاربردی.
  92: - فارسی: [صفحه‌بندی Oracle؛ کلید ادامه و تصویر ثابت](https://www.brserp.com/knowledge/erp-oracle-pagination-offset-seek-stable-order-snapshot-guide)؛ برای فهم ترتیب یکتا و محدودیت Keyset در داده متغیر. متن نمایه‌شده در جستجوی عمومی بررسی شد؛ بازکردن مستقیم در ابزار پژوهش محدود بود. نحو و رفتار Oracle را با PostgreSQL یکسان فرض نکنید.
  93: 
  94: [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: ORM](../03-orm-fetch-strategies/README.md) · [بعدی: Projection](../05-select-only-needed-columns/README.md) · [ایندکس](../02-indexes/README.md)
  95: 
  96: </div>

===== Backend Performace\04-databases\05-select-only-needed-columns\README.md =====
   1: <div dir="rtl" align="right">
   2: 
   3: # انتخاب فقط ستون‌های لازم — Projection
   4: 
   5: **هدف یادگیری:** هزینه پهنای ردیف را از تعداد ردیف جدا کنید، query متناسب با خروجی بنویسید و شرایط Index-only scan را بشناسید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ SQLها برای PostgreSQL و اجرا‌نشده‌اند.
   6: 
   7: ## مدل ذهنی
   8: 
   9: WHERE تعداد ردیف را محدود می‌کند و SELECT فهرست ستون‌های خروجی را. `SELECT *` ممکن است متن، JSON یا باینری بزرگی بگیرد که مصرف‌کننده لازم ندارد. حتی اگر مسیر خواندن صفحه دیسک همان باشد، انتقال از DB به برنامه، decoding، ساخت شیء و serialization می‌تواند کمتر شود. کوچک‌شدن خروجی الزاماً تعداد heap pageهای خوانده‌شده را کم نمی‌کند.
  10: 
  11: | لایه | اثر بالقوه Projection | روش مشاهده |
  12: | --- | --- | --- |
  13: | موتور | ردیف میانی باریک‌تر، امکان پوشش index | width، plan، buffers |
  14: | شبکه DB→App | بایت کمتر | bytes received در driver/شبکه |
  15: | برنامه | allocation و mapping کمتر | حافظه، CPU و زمان mapping |
  16: | قرارداد | ستون حساس/جدید ناخواسته وارد نمی‌شود | بررسی schema پاسخ |
  17: 
  18: در PostgreSQL، Covering index تنها شرط Index-only scan نیست؛ visibility map تعیین می‌کند آیا مراجعه به heap برای دیدپذیری لازم است. [مستند Index-only scans](https://www.postgresql.org/docs/current/indexes-index-only-scans.html) این محدودیت را شرح می‌دهد.
  19: 
  20: ## کاربرد و مصالحه
  21: 
  22: برای فهرست‌ها و read DTO مناسب است. در مسیر ویرایش، ستون‌های لازم برای concurrency مانند version یا کلیدهای mapping را حذف نکنید. deferred column که بعداً lazy خوانده شود می‌تواند N+1 بسازد. index با INCLUDE برای همه فیلدها نیز هزینه فضا و write دارد؛ ستون بزرگ را صرفاً برای پوشش query وارد index نکنید.
  23: 
  24: ## مثال حل‌شده
  25: 
  26: طرح فرضی `documents(id bigint primary key, tenant_id bigint, title text, body text, version bigint)` است. صفحه فهرست، بدنه سند را لازم ندارد:
  27: 
  28: <div dir="ltr" align="left">
  29: 
  30: ```sql
  31: -- List endpoint:
  32: SELECT id, title, version
  33: FROM documents
  34: WHERE tenant_id = 7
  35: ORDER BY id DESC
  36: LIMIT 20;
  37: 
  38: -- Detail endpoint, after authorization:
  39: SELECT id, title, body, version
  40: FROM documents
  41: WHERE tenant_id = 7 AND id = 81;
  42: ```
  43: 
  44: </div>
  45: 
  46: جداسازی list/detail باعث می‌شود body فقط با نیاز واقعی دریافت شود. `tenant_id` در هر دو شرط باقی می‌ماند. version برای ویرایش احتمالی در پاسخ لازم است. مثال نسخه‌ای از طراحی است؛ اجازه دسترسی را صرف وجود شرط query کامل فرض نکنید.
  47: 
  48: ## تمرین و مشاهده مورد انتظار
  49: 
  50: ۲۰ سند آزمایشی با body بزرگ بسازید. یک بار `SELECT *` و یک بار query فهرست بالا را با خروجی یکسان نمایشی اجرا کنید؛ بایت دریافتی و allocation را بسنجید. سپس پس از Projection، در حلقه به body دسترسی بدهید و query count را ثبت کنید. انتظار: projection بایت کمتری منتقل کند؛ دسترسی lazy بعدی ممکن است مزیت را با queryهای اضافی از بین ببرد. پلن یا bufferها ممکن است یکسان بمانند.
  51: 
  52: ## شاهد عمومی و حد شواهد
  53: 
  54: [مستند رسمی PostgreSQL درباره Covering index](https://www.postgresql.org/docs/current/indexes-index-only-scans.html) شاهد عملیاتی ارتباط ستون‌های انتخاب‌شده، visibility و heap fetch است. گزارش شرکت مستقلی که صرفاً حذف ستون را با تمام عوامل کنترل‌شده اندازه گرفته باشد در منابع این درس ارائه نشده؛ عدد body و مثال سند فرضی‌اند.
  55: 
  56: ## شکست‌ها، سیگنال‌ها و چک‌لیست
  57: 
  58: SQL سریع ولی CPU mapping یا network bytes زیاد، می‌تواند نشانه دریافت اضافی باشد. حذف کلیدها رابطه‌ها را می‌شکند؛ حذف version حفاظت optimistic concurrency را مختل می‌کند. Index-only scan با heap fetch بالا الزاماً مسئله Projection نیست و به نگهداری نیز مرتبط است.
  59: 
  60: - [ ] فهرست ستون‌ها از نیاز مصرف‌کننده استخراج شده است.
  61: - [ ] کلیدها، tenant و version مورد نیاز mapping/ویرایش حفظ شده‌اند.
  62: - [ ] بایت، allocation و query count کنار زمان DB سنجیده می‌شوند.
  63: - [ ] دسترسی بعدی به ستون deferred، SQL پنهان نمی‌سازد.
  64: - [ ] Covering index با فضا، write و visibility map ارزیابی می‌شود.
  65: - [ ] افزودن ستون جدید به جدول، پاسخ عمومی را ناخواسته تغییر نمی‌دهد.
  66: 
  67: ## خودآزمایی
  68: 
  69: ۱. تفاوت کاهش ردیف و کاهش ستون چیست؟
  70: 
  71: ۲. آیا حذف body همیشه I/O دیسک را به همان نسبت کم می‌کند؟
  72: 
  73: ۳. چرا version در پاسخ فهرست ممکن است لازم باشد؟
  74: 
  75: ۴. شرط Index-only scan فقط وجود همه ستون‌ها در index است؟
  76: 
  77: ۵. حذف ستون با ORM چه زمانی N+1 می‌سازد؟
  78: 
  79: ### پاسخ‌نامه با دلیل
  80: 
  81: ۱. WHERE ردیف‌ها را و SELECT ستون‌ها/پهنای نتیجه را محدود می‌کند؛ دو محور مستقل‌اند.
  82: 
  83: ۲. خیر؛ موتور ممکن است همان صفحه‌ها را بخواند، ولی انتقال و ساخت شیء همچنان کمتر شود.
  84: 
  85: ۳. برای قرارداد ویرایش با optimistic concurrency؛ حذفش می‌تواند معنای عملیات را عوض کند.
  86: 
  87: ۴. خیر؛ در PostgreSQL دیدپذیری ردیف و visibility map روی مراجعه به heap اثر دارد.
  88: 
  89: ۵. وقتی کد بعداً هر ستون deferred را جدا می‌خواند؛ query count باید پس از serialization سنجیده شود.
  90: 
  91: ## منابع
  92: 
  93: - انگلیسی: [Index-only scans and covering indexes](https://www.postgresql.org/docs/current/indexes-index-only-scans.html)؛ شرایط فنی و هزینه ستون‌های INCLUDE.
  94: - فارسی: [امنیت و بهینه‌سازی دیتابیس، بخش اصول پایه بهینه‌سازی کوئری](https://shahin.page/persian/article-fa/database-security-and-optimization-access-control-and-indexing-fa)؛ مقدمه انتخاب ستون‌های لازم به‌جای SELECT *. جزئیات visibility map را از مرجع رسمی انگلیسی بخوانید.
  95: 
  96: [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Pagination](../04-efficient-database-pagination/README.md) · [بعدی: Denormalization](../06-denormalization-for-read-heavy-workloads/README.md) · [نگهداری](../08-database-maintenance/README.md)
  97: 
  98: </div>

===== Backend Performace\04-databases\06-denormalization-for-read-heavy-workloads\README.md =====
   1: <div dir="rtl" align="right">
   2: 
   3: # Denormalization برای بار خواندن زیاد
   4: 
   5: **هدف یادگیری:** یک Read model مشتق‌شده طراحی کنید، بودجه کهنگی را بنویسید و هزینه حفظ سازگاری را با هزینه محاسبه هر خواندن مقایسه کنید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ مثال PostgreSQL آموزشی و اجرا‌نشده است.
   6: 
   7: ## مدل ذهنی
   8: 
   9: Normalization تکرار داده را کم و قواعد به‌روزرسانی را متمرکز می‌کند. Denormalization بخشی از نتیجه join/aggregate یا داده تکراری را ذخیره می‌کند تا خواندن کم‌کارتر شود. داده مشتق‌شده باید منبع حقیقت، مالک به‌روزرسانی و راه بازسازی داشته باشد. جدول خلاصه، counter و Materialized view شکل‌های متفاوت این تصمیم‌اند؛ cache نیز ممکن است نقش مشابهی داشته باشد ولی قرارداد ماندگاری و مالکیت را باید جدا نوشت.
  10: 
  11: | روش نگهداری | تازگی | هزینه |
  12: | --- | --- | --- |
  13: | به‌روزرسانی در تراکنش write | همگام با commit محلی | write و رقابت بیشتر |
  14: | رویداد/CDC و projector | با تأخیر | replay، ترتیب و idempotency |
  15: | refresh دوره‌ای | کهنگی تا نوبت بعد | محاسبه دسته‌ای و زمان refresh |
  16: 
  17: صرف زیادبودن نسبت read/write کافی نیست؛ query پرتکرار باید واقعاً هزینه‌بر و نتیجه قابل نگهداری باشد. برای قیمت نهایی یا موجودی قطعی، خلاصه کهنه به‌تنهایی مجوز عملیات نیست.
  18: 
  19: ## کاربرد و مصالحه
  20: 
  21: برای داشبورد، فهرست و گزارش پرتکرار با بودجه تازگی مشخص مناسب است. برای write زیاد، مدل با تغییر پیوسته یا تراکنش‌هایی که به صحت لحظه‌ای نیاز دارند، پیچیدگی ممکن است سود را ببلعد. فضای بیشتر، write amplification و اصلاح داده ناسازگار بخشی از هزینه‌اند. ابتدا query، index و projection را بسنجید.
  22: 
  23: ## مثال حل‌شده
  24: 
  25: فرض: `orders(id, customer_id, total, status)` منبع حقیقت است. داشبورد فقط مجموع سفارش‌های پرداخت‌شده هر مشتری را می‌خواهد و تأخیر چند دقیقه‌ای را می‌پذیرد.
  26: 
  27: <div dir="ltr" align="left">
  28: 
  29: ```sql
  30: CREATE MATERIALIZED VIEW customer_sales AS
  31: SELECT customer_id, COUNT(*) AS order_count, SUM(total) AS amount
  32: FROM orders
  33: WHERE status = 'paid'
  34: GROUP BY customer_id;
  35: 
  36: SELECT order_count, amount FROM customer_sales WHERE customer_id = 42;
  37: -- Scheduled in the lab, outside a request:
  38: REFRESH MATERIALIZED VIEW customer_sales;
  39: ```
  40: 
  41: </div>
  42: 
  43: در PostgreSQL، نتیجه ذخیره می‌شود و خودکار با هر write تازه نمی‌شود. زمان موفق آخرین refresh را کنار داشبورد ثبت کنید. REFRESH معمولی می‌تواند خوانندگان را منتظر بگذارد؛ حالت CONCURRENTLY پیش‌نیازهایی از جمله unique index مناسب و view پرشده دارد و همچنان هزینه محاسبه دارد. [مستند Materialized views](https://www.postgresql.org/docs/current/rules-materializedviews.html) برای مدل و مثال گزارش بخوانید؛ شرایط دقیق command را در نسخه خود بررسی کنید.
  44: 
  45: ## تمرین و مشاهده مورد انتظار
  46: 
  47: یک سفارش paid اضافه کنید؛ query مستقیم روی orders و view را پیش از refresh مقایسه کنید. سپس refresh کنید و دوباره بخوانید. انتظار: view تا refresh قدیمی است و پس از موفقیت با مجموعه خوانده‌شده هنگام refresh همگرا می‌شود. سناریوی projector رویدادی را روی کاغذ با یک event تکراری و یک event جابه‌جا طراحی کنید: نگهداری `event_id` و version چه خطایی را می‌گیرد؟
  48: 
  49: ## شاهد عمومی و حد شواهد
  50: 
  51: [مستند رسمی PostgreSQL](https://www.postgresql.org/docs/current/rules-materializedviews.html) نمونه گزارش فروش ذخیره‌شده و تفاوت تازگی/سرعت را نشان می‌دهد. این مثال مرجع آموزشی است، نه گزارش تولیدی شرکت؛ در این درس مطالعه موردی مستقیم با اندازه‌گیری مستقل برای Read model بالا نداریم.
  52: 
  53: ## شکست‌ها، سیگنال‌ها و چک‌لیست
  54: 
  55: جمع دوباره رویداد تکراری، جاافتادن refund/delete، update ناقص بین دو سیستم و refresh ناموفقِ بی‌هشدار از خطاهای رایج‌اند. age داده، lag projector، اختلاف reconciliation و هزینه refresh را ثبت کنید؛ latency خواندن به‌تنهایی صحت را نشان نمی‌دهد.
  56: 
  57: - [ ] منبع حقیقت و مالک Read model مشخص است.
  58: - [ ] بودجه تازگی، timestamp/version و رفتار داده خیلی کهنه تعریف شده است.
  59: - [ ] update، delete و refund در مدل مشتق‌شده پوشش دارند.
  60: - [ ] replay و deduplication برای مسیر رویدادی طراحی شده‌اند.
  61: - [ ] rebuild و reconciliation با منبع حقیقت وجود دارد.
  62: - [ ] هزینه write، فضا، قفل و refresh کنار read latency سنجیده می‌شود.
  63: 
  64: ## خودآزمایی
  65: 
  66: ۱. Denormalization چه کاری را از خواندن به زمان دیگری منتقل می‌کند؟
  67: 
  68: ۲. آیا Materialized view با هر INSERT خودکار تازه می‌شود؟
  69: 
  70: ۳. چرا event تکراری برای counter خطرناک است؟
  71: 
  72: ۴. موجودی نمایش‌داده‌شده از Read model مجوز فروش قطعی است؟
  73: 
  74: ۵. چه شاخصی کنار سرعت خواندن ضروری است؟
  75: 
  76: ### پاسخ‌نامه با دلیل
  77: 
  78: ۱. join/aggregate یا ساخت نمای خروجی را به write، projector یا refresh منتقل می‌کند؛ هزینه حذف نمی‌شود.
  79: 
  80: ۲. در مثال PostgreSQL خیر؛ refresh صریح لازم است.
  81: 
  82: ۳. جمع دوباره رقم را خراب می‌کند؛ idempotency/deduplication یا محاسبه نسخه‌دار لازم است.
  83: 
  84: ۴. خیر؛ عملیات باید با قواعد تراکنشی منبع و بودجه سازگاری اعتبارسنجی شود.
  85: 
  86: ۵. سن داده و اختلاف با منبع؛ پاسخ سریع قدیمی ممکن است برای قرارداد نامعتبر باشد.
  87: 
  88: ## منابع
  89: 
  90: - انگلیسی: [PostgreSQL Materialized views](https://www.postgresql.org/docs/current/rules-materializedviews.html)؛ مدل ذخیره نتیجه و مثال گزارش.
  91: - انگلیسی تکمیلی: [REFRESH MATERIALIZED VIEW](https://www.postgresql.org/docs/current/sql-refreshmaterializedview.html)؛ پیش‌نیاز unique index، view پرشده و تفاوت قفل در CONCURRENTLY.
  92: - فارسی: [نرمال‌سازی و فرم‌های نرمال، بخش تعادل تئوری و کارایی](https://pro-nee.net/collections/normalization-and-normal-forms/)؛ مقدمه افزونگی آگاهانه و anomalyها. منبع فارسی تخصصی برای replay/reconciliation این مدل در این بررسی پیدا نشد؛ تمرین همین صفحه آن فاصله را روشن می‌کند.
  93: 
  94: [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Projection](../05-select-only-needed-columns/README.md) · [بعدی: Join](../07-join-optimization/README.md) · [کارهای پس‌زمینه](../../03-asynchronism/01-background-jobs/README.md)
  95: 
  96: </div>

