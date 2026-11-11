# Read-only Task 1 review package

## Implementer report

# Task 1 implementation report

Status: complete within Task 1 scope. No Git repository was initialized and no commits were made.

## Files written

- `D:\Learn\Roadmap\Backend Performace\README.md` — Persian learner entry point, right-to-left wrapper, source/date/scope notes, prerequisites, ordered navigation, study/exercise/quiz instructions, a complete roadmap traceability table, glossary/index links, and foundational source links.
- `D:\Learn\Roadmap\.superpowers\sdd\2026-11-10-backend-performance-learning-pack\task-1-report.md` — this report, as explicitly requested by the task brief.

No chapter directory or topic page was edited by this task.

## Content and coverage

The README keeps the requested `Backend Performace` spelling. Its main prose is Persian; technical identifiers stay in English, code spans, or explicit LTR spans. The page uses a right-aligned RTL wrapper with blank lines so the Markdown remains readable.

The ordered route links the exact ten chapter paths in the approved design spec. Each of the 44 approved topic paths appears in a dedicated traceability row. The table covers every source theme supplied by the parent and corroborated in the current roadmap's embedded checklist: caching layers/patterns/invalidation; API payload/compression/pagination/processing; asynchronous jobs/brokers; database pooling/settings/indexes/ORM strategies/pagination/projection/denormalization/joins/maintenance/slow logs/replication/sharding/profiling; scaling/load balancing; streaming/profiling/algorithms/critical paths/language choices/decomposition/timeouts-retries/batching; monitoring/toolchain/async logs; dependency/auth/rate/security reviews; regular testing/benchmarks; locality/keep-alive/CDN/prefetch. Closely related checklist bullets are grouped without dropping themes. Additional teaching coverage, such as multi-level caching, stampede prevention, instrumentation, and load-test varieties, is explicitly identified as an educational expansion of an existing theme.

The entry point links both the user-supplied roadmap and original official PDF URL. It records `2026-11-10`, describes research as curated rather than literally exhaustive, keeps the pack on Backend Performance, and links System Design as related further reading. The glossary links recurring concepts back to their owning topics. Exercise/quiz guidance emphasizes explaining decisions and comparing observations under recorded conditions.

## Research performed

The Firecrawl scrape endpoint was initially discovered and called once, but it returned `Unknown tool`. The parent subsequently instructed that Firecrawl must not be retried because its account had already reported insufficient credits. No further Firecrawl call was made. Research continued through the web tool and direct public HTTP reads.

- `https://roadmap.sh/backend-performance-best-practices` — opened with the web tool; live HTML retrieved read-only with PowerShell to inspect the embedded checklist strings. This corroborated the source checklist themes, including ORM tuning, connection pool tuning, SOA/Microservices, compiled language examples, monitoring tool examples, and network items.
- `https://roadmap.sh/pdfs/best-practices/backend-performance.pdf` — web open returned 404; independent direct HTTP HEAD also returned 404. The source URL remains in the README with an accurate availability note.
- `https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching` — verified official HTTP caching guide.
- `https://www.postgresql.org/docs/current/using-explain.html` — verified official EXPLAIN guide and its role in observing query plans.
- `https://opentelemetry.io/docs/concepts/signals/` — verified official signals index.
- `https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/` — verified redirect to AWS Builder Center, title, operational subject, and original publication date `2019-12-05`.

The full PDF itself could not be fetched in this task. The task's parent supplied its extracted theme inventory; coverage was compared to that inventory, the approved design spec, and the available live checklist. The README does not claim successful retrieval of the PDF.

## Manual checks

- Read the beginning, learning route, full table, glossary, and source notes as a learner; checked Persian prose, source caveat, scope, and navigation flow.
- Inspected extracted destination paths against the design spec folder tree: 10 unique chapter links and 44 unique topic links. There are 44 traceability rows, with chapter topic counts `4 + 4 + 2 + 12 + 2 + 8 + 3 + 4 + 1 + 4 = 44`.
- Confirmed the glossary link has the explicit `glossary` anchor and the page closes the RTL wrapper.
- Confirmed API pagination and database pagination point to distinct approved pages; similarly application profiling and database profiling, and cache CDN coverage and network CDN delivery point to the relevant owning topics.
- Reviewed all source hyperlinks and confirmed four foundational external references through web retrieval. The original PDF's 404 is disclosed rather than silently replaced.

No software tests, test files, builds, commits, or Git initialization were created or run. Read-only path extraction/counting was used only to aid the manual documentation inspection.

## Concerns and integration notes

1. The official original PDF URL currently returns 404. Its link is retained for provenance; a restored official download could replace the temporary availability note during a later refresh.
2. At this task boundary chapter/topic pages are owned by later tasks. The paths match the approved structure, but final filesystem existence of all destinations must be checked after the other documentation tasks finish.
3. Browser rendering was not claimed or performed. Markdown source and RTL markup were inspected directly; final rendering depends on the learner's Markdown viewer.


## Snapshot: Backend Performace/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # مسیر یادگیری کارایی بک‌اند — Backend Performance
   4: 
   5: این بسته برای توسعه‌دهنده‌ای نوشته شده که می‌خواهد علت کندی یک سرویس را پیدا کند، تغییر مناسب را انتخاب کند و اثر آن را با اندازه‌گیری بسنجد. مبنای محدوده، [نقشه‌راه Backend Performance ارسالی کاربر](https://roadmap.sh/backend-performance-best-practices) و [PDF چک‌لیست همان نقشه‌راه](https://roadmap.sh/pdfs/best-practices/backend-performance.pdf) است. ده فصل و ۴۴ موضوع این راهنما، چک‌لیست را به مسیر مطالعه، تمرین و مرور تبدیل می‌کنند؛ عبارت انگلیسی پوشه عمداً با املای درخواستی `Backend Performace` حفظ شده است.
   6: 
   7: **تاریخ پژوهش و بررسی منابع: <span dir="ltr">2026-11-10</span>.** این پژوهش گزینش‌شده است: توضیح‌های مستقل فارسی و منابع مرتبط را گرد می‌آورد و ادعا نمی‌کند همه مطالب اینترنت را پوشش داده است. منابع رسمی و تجربه‌های منتشرشده تیم‌های مهندسی بر توصیه‌های بدون شاهد اولویت دارند. در هر موضوع باید بتوان تجربه مستند، مثال آموزشی و محدودیت شواهد را از هم تشخیص داد.
   8: 
   9: **یادداشت دسترسی منبع:** در بررسی این نسخه، صفحه زنده نقشه‌راه و چک‌لیست تعبیه‌شده در آن در دسترس بودند، اما پیوند PDF بالا پاسخ <span dir="ltr">HTTP 404</span> داد. پیوند اصلی برای ردیابی منشأ حفظ شده است؛ تا بازیابی PDF، از صفحه زنده و جدول پوشش زیر استفاده کنید. جدول، ساختار آموزشی مصوب را نگه می‌دارد و نقل‌قول یا بازنشر کامل منبع نیست.
  10: 
  11: تمرکز بسته **Backend Performance** است. [نقشه‌راه System Design](https://roadmap.sh/system-design) مطالعه تکمیلی مرتبط برای تصمیم‌های معماری است؛ موضوعات جداگانه آن به محدوده این بسته اضافه نشده‌اند. مثال‌ها تا حد امکان مستقل از زبان، چارچوب و فروشنده‌اند؛ نام یک ابزار در متن به معنای الزام به استفاده از آن نیست.
  12: 
  13: ## پیش‌نیاز و نقطه شروع
  14: 
  15: آشنایی مقدماتی با درخواست و پاسخ `HTTP`، یک `API`، پایگاه داده رابطه‌ای و `SQL`، اجرای یک برنامه و خواندن لاگ کافی است. برای شروع لازم نیست متخصص یک سرویس ابری یا ابزار پایش خاص باشید. اگر اصطلاحی ناآشناست، ابتدا [واژه‌نامه و نمایه مفاهیم](#glossary) را ببینید و سپس به موضوع پیوندشده برگردید.
  16: 
  17: مسیر اصلی مطالعه شماره فصل‌ها را دنبال می‌کند. پیش از نخستین تمرین، یک مرور کوتاه بر [اندازه‌گیری و سیگنال‌ها](07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) و [خط مبنا و آزمون کارایی](09-performance-testing/01-load-testing-and-regression-benchmarks/README.md) داشته باشید تا برای تمرین‌های بعدی روش ثبت نتیجه داشته باشید. این مرور، جای مطالعه کامل آن دو فصل در ترتیب اصلی را نمی‌گیرد.
  18: 
  19: ## مسیر مطالعه و فهرست ده فصل
  20: 
  21: | گام | فصل | موضوع‌ها | پرسشی که هنگام مطالعه دنبال می‌کنید |
  22: | --- | --- | --- | --- |
  23: | ۱ | [کش — Caching](01-caching/README.md) | ۴ | چه چیزی را کجا نگه داریم و چطور تازگی آن را مدیریت کنیم؟ |
  24: | ۲ | [پاسخ API — API Response](02-api-response/README.md) | ۴ | چه داده و چه مقدار کار برای این پاسخ لازم است؟ |
  25: | ۳ | [پردازش غیرهمگام — Asynchronism](03-asynchronism/README.md) | ۲ | کدام کار را می‌توان با قرارداد روشن به پس‌زمینه سپرد؟ |
  26: | ۴ | [پایگاه داده — Databases](04-databases/README.md) | ۱۲ | هزینه اتصال، واکشی و اجرای پرس‌وجو کجاست؟ |
  27: | ۵ | [توزیع بار و مقیاس‌دهی — Load Balancing & Scaling](05-load-balancing-and-scaling/README.md) | ۲ | ظرفیت را با کدام محدودیت و هزینه افزایش می‌دهیم؟ |
  28: | ۶ | [بهینه‌سازی کد — Code Optimization](06-code-optimization/README.md) | ۸ | کدام بخش از اجرای برنامه روی نتیجه اندازه‌گیری‌شده اثر دارد؟ |
  29: | ۷ | [پایش و ثبت رویداد — Monitoring & Logging](07-monitoring-and-logging/README.md) | ۳ | برای فهم رفتار سرویس چه شواهدی جمع می‌کنیم؟ |
  30: | ۸ | [امنیت — Security](08-security/README.md) | ۴ | کنترل دسترسی و کنترل مصرف منابع چطور طراحی و بازبینی می‌شوند؟ |
  31: | ۹ | [آزمون کارایی — Performance Testing](09-performance-testing/README.md) | ۱ | چگونه رفتار تحت بار و تغییر نسبت به خط مبنا را بررسی کنیم؟ |
  32: | ۱۰ | [شبکه — Network](10-network/README.md) | ۴ | فاصله، اتصال و تحویل محتوا چه سهمی در زمان پاسخ دارند؟ |
  33: 
  34: در هر فصل، ابتدا فهرست فصل و سناریوی مشترک آن را بخوانید و سپس موضوع‌ها را به ترتیب شماره مطالعه کنید. پس از تمام‌کردن یک فصل، چک‌لیست مرور آن را با زبان خودتان توضیح دهید. هرجا یک تصمیم در چند لایه تکرار می‌شود، پیوند موضوع مرتبط را دنبال کنید؛ مثلاً صفحه‌بندی قرارداد `API` و صفحه‌بندی پرس‌وجوی پایگاه داده دو زاویه از یک جریان‌اند.
  35: 
  36: ## روش استفاده از درس‌ها، تمرین‌ها و آزمون‌ها
  37: 
  38: ۱. ابتدا خروجی یادگیری و مدل ذهنی موضوع را بخوانید؛ سپس یک کاربرد مناسب و یک وضعیت نامناسب برای آن بنویسید.
  39: 
  40: ۲. مثال حل‌شده را دنبال کنید و فرض‌های آن را یادداشت کنید. داده‌ها و اعداد مثال آموزشی را به‌عنوان نتیجه یک سامانه واقعی نقل نکنید؛ برای تجربه واقعی به بخش شواهد و منبع همان موضوع مراجعه کنید.
  41: 
  42: ۳. تمرین کوچک را در محیط یادگیری انجام دهید. نوع بار، اندازه داده، تنظیمات، نتیجه قبل و بعد و هزینه جانبی تغییر را ثبت کنید. اگر مشاهده با انتظار درس فرق داشت، فرض‌ها و روش اندازه‌گیری را بازبینی کنید.
  43: 
  44: ۴. به پرسش‌های آزمون هر موضوع، پیش از بازکردن پاسخ‌نامه، جواب بدهید. آزمون‌های موضوعی ۵ تا ۸ پرسش دارند؛ دلیل پاسخ مهم‌تر از حفظ گزینه درست است. پاسخ‌نامه توضیحی را بخوانید و برای پاسخ اشتباه، به بخش مرتبط درس برگردید.
  45: 
  46: ۵. در مرور نهایی، نتیجه را در یک جمله تصمیم‌پذیر بنویسید: «با این بار و این محدودیت، این تغییر را انتخاب می‌کنم، چون این مشاهده را دارم؛ هزینه و شرط بازنگری آن این است.» برای همه سرویس‌ها یک عدد ثابت به‌عنوان هدف کارایی در نظر نگیرید.
  47: 
  48: ## جدول ردیابی چک‌لیست به پوشه‌ها
  49: 
  50: عنوان انگلیسی ستون اول با بخش‌های نقشه‌راه تطبیق دارد. ستون دوم مضمون چک‌لیست را به فارسی خلاصه می‌کند و ستون سوم مقصد دقیق مطالعه است. موارد مرتبطی مانند تنظیمات مختلف `Connection Pool` یا روش‌های واکشی `ORM` در یک موضوع جمع شده‌اند. موضوع‌های تکمیلی آموزشی، از جمله کش چندلایه، پیشگیری از هجوم به کش، و تمایز انواع آزمون بار، در ردیف مربوط مشخص شده‌اند؛ این‌ها به معنی افزودن فصل‌های خارج از Backend Performance نیستند.
  51: 
  52: | بخش نقشه‌راه | مضمون چک‌لیست و دامنه پوشش | مقصد مطالعه |
  53: | --- | --- | --- |
  54: | Caching | استفاده از کش `HTTP`، سمت سرور، سمت کلاینت و `CDN`؛ تفکیک محل کش از سیاست آن | [۱.۱ لایه‌های کش](01-caching/01-cache-layers/README.md) |
  55: | Caching | انتخاب `Cache-aside`، `Read-through` و `Write-through` بر اساس نیاز برنامه | [۱.۲ الگوهای کش](01-caching/02-cache-patterns/README.md) |
  56: | Caching | ترکیب لایه‌های کش و هزینه هماهنگی آن‌ها؛ بسط آموزشی مبحث لایه‌ها | [۱.۳ کش چندلایه](01-caching/03-multi-level-caching/README.md) |
  57: | Caching | ابطال کش، سازگاری و جلوگیری از محتوای کهنه؛ تکمیل با `Freshness`، `TTL` و پیشگیری از `Stampede` | [۱.۴ ابطال و تازگی](01-caching/04-invalidation-and-freshness/README.md) |
  58: | Optimize API Response | محدودیت معقول اندازه بدنه درخواست و پاسخ؛ تعریف قرارداد اندازه داده | [۲.۱ اندازه Payload](02-api-response/01-payload-size/README.md) |
  59: | Optimize API Response | فشرده‌سازی پاسخ و سنجش هزینه پردازش در برابر حجم انتقال | [۲.۲ فشرده‌سازی پاسخ](02-api-response/02-response-compression/README.md) |
  60: | Optimize API Response | صفحه‌بندی کارآمد مجموعه‌های بزرگ از منظر قرارداد `API` | [۲.۳ صفحه‌بندی API](02-api-response/03-efficient-pagination/README.md) |
  61: | Optimize API Response | حذف پردازش غیرضروری و محاسبه پرهزینه روی سرور | [۲.۴ کار غیرضروری سرور](02-api-response/04-avoid-unnecessary-server-work/README.md) |
  62: | Asynchronism | سپردن کارهای سنگین به کار پس‌زمینه یا صف | [۳.۱ کارهای پس‌زمینه](03-asynchronism/01-background-jobs/README.md) |
  63: | Asynchronism | استفاده از `Message Broker` برای ارتباط غیرهمگام سرویس‌ها | [۳.۲ واسطه‌های پیام](03-asynchronism/02-message-brokers/README.md) |
  64: | Databases | استفاده مجدد از اتصال و تنظیم `Max connections`، زمان بیکاری و پارامترهای استفاده مجدد؛ جلوگیری از اتمام اتصال‌ها | [۴.۱ Connection Pooling](04-databases/01-connection-pooling/README.md) |
  65: | Databases | ساخت و انتخاب ایندکس متناسب با الگوی پرس‌وجو | [۴.۲ ایندکس‌ها](04-databases/02-indexes/README.md) |
  66: | Databases | بازبینی و تنظیم پرس‌وجوهای `ORM`؛ `Lazy loading`، `Eager loading` و واکشی دسته‌ای | [۴.۳ راهبردهای واکشی ORM](04-databases/03-orm-fetch-strategies/README.md) |
  67: | Databases | صفحه‌بندی کارآمد از منظر اجرای پرس‌وجو و ترتیب داده‌ها | [۴.۴ صفحه‌بندی پایگاه داده](04-databases/04-efficient-database-pagination/README.md) |
  68: | Databases | پرهیز از `SELECT *` و واکشی فقط ستون‌های لازم | [۴.۵ انتخاب ستون‌های لازم](04-databases/05-select-only-needed-columns/README.md) |
  69: | Databases | بررسی غیرنرمال‌سازی برای بارهای خواندن‌محور و کاهش نیاز به اتصال جدول‌ها | [۴.۶ Denormalization](04-databases/06-denormalization-for-read-heavy-workloads/README.md) |
  70: | Databases | بهینه‌سازی `JOIN` و حذف اتصال غیرضروری جدول‌ها | [۴.۷ بهینه‌سازی JOIN](04-databases/07-join-optimization/README.md) |
  71: | Databases | پاک‌سازی داده بلااستفاده، نگهداری دوره‌ای، `Vacuum`، نگهداری ایندکس و بازبینی پرس‌وجو | [۴.۸ نگهداری پایگاه داده](04-databases/08-database-maintenance/README.md) |
  72: | Databases | فعال‌سازی و پایش لاگ پرس‌وجوهای کند | [۴.۹ Slow-query Logging](04-databases/09-slow-query-logging/README.md) |
  73: | Databases | تکثیر داده برای افزونگی و ظرفیت خواندن؛ بررسی محدودیت‌های آن | [۴.۱۰ Replication](04-databases/10-replication/README.md) |
  74: | Databases | توزیع داده با `Sharding` در صورت نیاز و بررسی هزینه آن | [۴.۱۱ Sharding](04-databases/11-sharding/README.md) |
  75: | Databases | استفاده از ابزارهای پروفایلینگ و طرح اجرای خود پایگاه داده | [۴.۱۲ پروفایلینگ پایگاه داده](04-databases/12-database-profiling/README.md) |
  76: | Load Balancing & Scaling | انتخاب مقیاس‌دهی افقی یا عمودی متناسب با محدودیت | [۵.۱ مقیاس‌دهی افقی و عمودی](05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md) |
  77: | Load Balancing & Scaling | توزیع ترافیک میان سرورها با `Load Balancing` | [۵.۲ توزیع بار](05-load-balancing-and-scaling/02-load-balancing/README.md) |
  78: | Code Optimization | پردازش جریانی درخواست‌ها و پاسخ‌های بزرگ | [۶.۱ Streaming](06-code-optimization/01-streaming-large-bodies/README.md) |
  79: | Code Optimization | پروفایلینگ کد برای پیدا کردن گلوگاه برنامه | [۶.۲ پروفایلینگ برنامه](06-code-optimization/02-application-profiling/README.md) |
  80: | Code Optimization | بهبود الگوریتم‌ها و ساختمان داده‌ها | [۶.۳ الگوریتم و ساختمان داده](06-code-optimization/03-algorithms-and-data-structures/README.md) |
  81: | Code Optimization | شناسایی و بهبود مسیرهای بحرانی و Endpointهای پرتکرار | [۶.۴ مسیرهای بحرانی](06-code-optimization/04-critical-paths/README.md) |
  82: | Code Optimization | بررسی زبان‌های کامپایل‌شونده مانند `Go` و `Rust` برای بخش حساس به کارایی؛ سنجش انتخاب زبان و Runtime | [۶.۵ انتخاب زبان و Runtime](06-code-optimization/05-language-and-runtime-choices/README.md) |
  83: | Code Optimization | بررسی `SOA` و `Microservices` و تفکیک سرویس فقط در صورت نیاز | [۶.۶ تفکیک سرویس‌ها](06-code-optimization/06-service-decomposition/README.md) |
  84: | Code Optimization | Timeout مناسب اتصال و Retry کارآمد برای خطای شبکه | [۶.۷ Timeout و Retry](06-code-optimization/07-timeouts-and-retries/README.md) |
  85: | Code Optimization | دسته‌بندی درخواست‌های مشابه، کاهش سربار و تعداد رفت‌وبرگشت‌ها | [۶.۸ Batching و Round trips](06-code-optimization/08-batching-and-round-trips/README.md) |
  86: | Monitoring and Logging | پایش جامع، ثبت رویداد، دنبال‌کردن معیارهای کارایی و عیب‌یابی؛ تکمیل با `Traces` و Instrumentation | [۷.۱ Metrics، Logs و Traces](07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) |
  87: | Monitoring and Logging | آشنایی با زنجیره ابزار؛ نمونه‌های نقشه‌راه: `Prometheus`، `Grafana` و `ELK Stack` | [۷.۲ ابزارهای پایش](07-monitoring-and-logging/02-monitoring-toolchain/README.md) |
  88: | Monitoring and Logging | ثبت رویداد غیرهمگام و کنترل سربار لاگ | [۷.۳ لاگ غیرهمگام](07-monitoring-and-logging/03-asynchronous-logging/README.md) |
  89: | Security | به‌روز نگه‌داشتن و بررسی وابستگی‌ها و بسته‌های مورد استفاده | [۸.۱ بهداشت وابستگی‌ها](08-security/01-dependency-hygiene/README.md) |
  90: | Security | احراز هویت و مجوزدهی مناسب برای جلوگیری از دسترسی غیرمجاز | [۸.۲ Authentication و Authorization](08-security/02-authentication-and-authorization/README.md) |
  91: | Security | `Throttling` و `Rate limiting` درخواست‌ها | [۸.۳ کنترل نرخ درخواست](08-security/03-throttling-and-rate-limiting/README.md) |
  92: | Security | ممیزی دوره‌ای، بازبینی و به‌روزرسانی تدابیر امنیتی | [۸.۴ بازبینی و به‌روزرسانی امنیت](08-security/04-security-review-and-updates/README.md) |
  93: | Performance Testing | آزمون و Benchmark منظم، شناسایی افت کارایی، پیگیری بهبود و تنظیم تصمیم‌ها؛ تکمیل با خط مبنا و تمایز `Load`، `Stress`، `Spike` و `Soak` | [۹.۱ آزمون بار و رگرسیون کارایی](09-performance-testing/01-load-testing-and-regression-benchmarks/README.md) |
  94: | Network | کاهش تأخیر با بررسی محل میزبانی نسبت به کاربران و منطقه سرویس | [۱۰.۱ منطقه و تأخیر شبکه](10-network/01-region-and-network-latency/README.md) |
  95: | Network | استفاده مجدد از اتصال و `HTTP keep-alive` برای کاهش سربار اتصال | [۱۰.۲ استفاده مجدد از اتصال](10-network/02-connection-reuse/README.md) |
  96: | Network | استفاده از `CDN` برای محتوای ثابت و پرتکرار | [۱۰.۳ تحویل محتوا با CDN](10-network/03-cdn-for-static-and-frequent-content/README.md) |
  97: | Network | `Prefetch` یا `Preload` منابع، داده یا وابستگی‌های لازم برای درخواست بعدی | [۱۰.۴ Prefetch و Preload](10-network/04-prefetch-and-preload/README.md) |
  98: 
  99: <a id="glossary"></a>
 100: 
 101: ## واژه‌نامه و نمایه مفاهیم
 102: 
 103: این تعریف‌های کوتاه برای پیدا کردن درس مرتبط‌اند؛ جزئیات، محدودیت‌ها و مثال‌ها در صفحه موضوع آمده‌اند.
 104: 
 105: | اصطلاح | معنی کاربردی در این بسته | ادامه مطالعه |
 106: | --- | --- | --- |
 107: | Latency / زمان پاسخ | مدت انتظار برای پایان عملیات؛ هنگام ثبت نتیجه مشخص کنید اندازه‌گیری از کدام نقطه آغاز و تمام می‌شود | [منطقه و تأخیر](10-network/01-region-and-network-latency/README.md) |
 108: | Throughput / نرخ انجام کار | تعداد عملیات تکمیل‌شده در واحد زمان؛ همراه با نوع عملیات و شرایط بار گزارش می‌شود | [آزمون بار](09-performance-testing/01-load-testing-and-regression-benchmarks/README.md) |
 109: | Percentile / صدک | جایگاه یک مقدار در توزیع مشاهده‌ها؛ مانند `p95` برای بررسی بخش کندتر پاسخ‌ها | [معیارهای کارایی](07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) |
 110: | Baseline / خط مبنا | نتیجه مرجع با شرایط ثبت‌شده برای مقایسه اجرای بعدی | [Benchmark و رگرسیون](09-performance-testing/01-load-testing-and-regression-benchmarks/README.md) |
 111: | Bottleneck / گلوگاه | محدودیتی که در بار مورد بررسی جلوی بهبود بیشتر را می‌گیرد | [پروفایلینگ برنامه](06-code-optimization/02-application-profiling/README.md) |
 112: | Cache hit / miss | پیدا شدن یا نشدن داده مورد نظر در کش | [لایه‌های کش](01-caching/01-cache-layers/README.md) |
 113: | Freshness / TTL | تازگی داده کش‌شده و بازه زمانی اعتبار آن طبق سیاست کش | [تازگی و ابطال](01-caching/04-invalidation-and-freshness/README.md) |
 114: | Cache stampede | هجوم هم‌زمان درخواست‌ها برای ساخت دوباره مقدار کش | [پیشگیری از هجوم به کش](01-caching/04-invalidation-and-freshness/README.md) |
 115: | Pagination / Cursor | تقسیم نتایج به صفحه‌ها و نشانگر ادامه دریافت در قرارداد مربوط | [قرارداد API](02-api-response/03-efficient-pagination/README.md) و [اجرای پایگاه داده](04-databases/04-efficient-database-pagination/README.md) |
 116: | Connection pool | مجموعه اتصال‌هایی که برنامه مدیریت و دوباره استفاده می‌کند | [Pool پایگاه داده](04-databases/01-connection-pooling/README.md) |
 117: | Query plan | برنامه‌ای که پایگاه داده برای اجرای پرس‌وجو انتخاب می‌کند | [پروفایلینگ پایگاه داده](04-databases/12-database-profiling/README.md) |
 118: | Replication / Sharding | تکثیر داده میان نمونه‌ها / تقسیم داده میان بخش‌ها | [تکثیر](04-databases/10-replication/README.md) و [تقسیم داده](04-databases/11-sharding/README.md) |
 119: | Critical path | زنجیره عملیات وابسته‌ای که پایان پاسخ به تکمیل آن وابسته است | [مسیر بحرانی](06-code-optimization/04-critical-paths/README.md) |
 120: | Timeout / Retry | حد انتظار عملیات / تلاش دوباره پس از شکست؛ سیاست آن‌ها باید با هزینه و معنای عملیات سازگار باشد | [مهلت و تلاش مجدد](06-code-optimization/07-timeouts-and-retries/README.md) |
 121: | Metrics / Logs / Traces | اندازه‌گیری‌های تجمیع‌پذیر / رویدادهای ثبت‌شده / دنبال‌کردن مسیر اجرای درخواست | [سیگنال‌ها و Instrumentation](07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) |
 122: | Rate limit / Throttling | قواعد محدودکردن یا تنظیم نرخ پذیرش درخواست‌ها | [کنترل نرخ](08-security/03-throttling-and-rate-limiting/README.md) |
 123: | CDN / Keep-alive | شبکه تحویل محتوا / حفظ و استفاده مجدد از اتصال `HTTP` | [CDN](10-network/03-cdn-for-static-and-frequent-content/README.md) و [اتصال](10-network/02-connection-reuse/README.md) |
 124: 
 125: ## منابع پایه و شیوه ارجاع
 126: 
 127: محدوده و مضامین جدول از [نقشه‌راه Backend Performance](https://roadmap.sh/backend-performance-best-practices) گرفته شده‌اند. برای مرور اولیه مفاهیم پرتکرار این منابع بررسی شده‌اند؛ منابع فارسی، منابع اختصاصی هر موضوع و تجربه‌های واقعی در همان درس معرفی می‌شوند:
 128: 
 129: - [راهنمای HTTP Caching در MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching): مرور کش خصوصی و مشترک، تازگی و اعتبارسنجی پاسخ؛ مکمل فصل کش.
 130: - [راهنمای EXPLAIN در PostgreSQL](https://www.postgresql.org/docs/current/using-explain.html): دیدن طرح اجرای پرس‌وجو و خواندن خروجی آن؛ جزئیات به نسخه پایگاه داده وابسته‌اند.
 131: - [سیگنال‌های OpenTelemetry](https://opentelemetry.io/docs/concepts/signals/): تعریف سیگنال‌هایی مانند معیار، لاگ و ردگیری برای مشاهده رفتار سامانه.
 132: - [Timeouts, retries, and backoff with jitter از AWS](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/): تجربه مستند درباره مهلت انتظار، تلاش مجدد و کنترل فشار ناشی از آن؛ مقاله اصلی با تاریخ انتشار <span dir="ltr">2019-12-05</span> و مقصد فعلی در `AWS Builder Center` بررسی شد.
 133: 
 134: هنگام مطالعه یک منبع بیرونی، تاریخ، نسخه ابزار، فرض‌های بار و محدوده نتیجه را همراه آن بخوانید. یک تجربه منتشرشده شاهدی برای همان زمینه است؛ برای تصمیم درباره برنامه خودتان، تمرین و اندازه‌گیری لازم است. اگر منبعی حذف یا جابه‌جا شد، عنوان، پیوند اصلی و تاریخ بررسی این نسخه نقطه شروع به‌روزرسانی خواهند بود.
 135: 
 136: </div>
