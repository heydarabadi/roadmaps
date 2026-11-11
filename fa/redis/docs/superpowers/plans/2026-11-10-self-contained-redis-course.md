# دورهٔ خودبسندهٔ Redis — Implementation Plan

> **For agentic workers:** Native implementation in this session. Keep changes focused and preserve the existing chapter/topic paths.

**Goal:** تبدیل ۳۵ README موضوعی به درس‌نامهٔ فارسی خودبسنده با مثال مرحله‌به‌مرحله، تمرین، پاسخ‌نامه و سه پروژهٔ پایانی.

**Architecture:** پوشه‌بندی موجود حفظ می‌شود. هر درس در README موضوع خودش می‌ماند؛ مقدمهٔ فصل‌ها، راهنمای شروع، واژه‌نامه، quick reference و پروژه‌های جامع در فایل‌های جدا در همین پوشه قرار می‌گیرند. مستندات رسمی فقط برای ارجاع نسخه‌ای و مطالعهٔ بیشتر استفاده می‌شود.

**Tech Stack:** Markdown با UTF-8، Docker، Redis Open Source 8.x و redis-cli.

**Spec:** D:\Learn\Roadmap\redis\docs\course-design.md

## Global Constraints

- آموزش اصلی فارسی و برای شروع از صفر است.
- مثال‌های اجرایی با Docker و redis-cli هستند؛ قابلیت وابسته به نسخه صریحاً برچسب می‌خورد.
- فرمان‌های مخرب یا تغییردهنده فقط برای محیط آزمایشی معرفی می‌شوند.
- هر کیس شرکت‌محور باید منبع و برچسب گزارش منتشرشده داشته باشد؛ بقیه مثال‌ها سناریوی آموزشی‌اند.
- هیچ اجرای Redis زنده یا production به‌عنوان انجام‌شده ادعا نمی‌شود.
- پوشه‌بندی و پیوندهای موضوعی فعلی حفظ می‌شوند.

## Review Focus

- **نسخه و feature availability:** یک ویژگی جدید در Redis 8.x ممکن است در نصب قدیمی نباشد؛ درس باید نسخه/feature را مشخص کند.
- **اجرای امن:** فرمان حذف یا config نباید روی سرویس واقعی کپی و اجرا شود؛ تمرین‌ها باید محیط لَب را روشن کنند.
- **تضمین‌ها:** Redis transaction، Pub/Sub، replication و cache نباید با ضمانت SQL یا message broker durable اشتباه گرفته شوند.
- **آموزش قابل اجرا:** فرمانی که به state قبلی وابسته است باید setup، خروجی مورد انتظار و cleanup داشته باشد.
- **منابع و ادعاها:** منابع فارسی عمومی و کیس‌های فروشنده باید به‌درستی برچسب بخورند؛ لینک جست‌وجو مقالهٔ خوانده‌شده نیست.

---

### Task 1: ساخت مسیر یادگیری، لَب محلی و مرجع مشترک

**Files:**
- Modify: D:\Learn\Roadmap\redis\README.md
- Modify: D:\Learn\Roadmap\redis\01-foundations\README.md
- Create: D:\Learn\Roadmap\redis\00-start-here\README.md
- Create: D:\Learn\Roadmap\redis\GLOSSARY.md
- Create: D:\Learn\Roadmap\redis\QUICK-REFERENCE.md

- [x] درس صفر را با پیش‌نیازها، نحوهٔ خواندن دوره، راه‌اندازی امن Docker، اتصال، بررسی نسخه، توقف و پاک‌سازی لَب بنویس.
- [x] برای هر فرمان نمونه خروجی و توضیح فارسی بگذار؛ cleanup فقط container همین لَب را هدف بگیرد.
- [x] واژه‌نامهٔ اصطلاحات و quick reference دستورها را بنویس و لینک آن‌ها را از README اصلی وصل کن.
- [x] مسیر ۰ تا production را با برچسب هسته/تکمیلی و معیار عبور هر فصل توضیح بده.

### Task 2: کامل‌کردن مبانی و شروع کار

**Files:**
- Modify: 01-foundations/redis-overview/README.md
- Modify: 01-foundations/use-cases/README.md
- Modify: 01-foundations/choose-datastore/README.md
- Modify: 02-getting-started/install-run/README.md
- Modify: 02-getting-started/cli-keys-ttl/README.md

- [x] هر درس را با پیش‌نیاز، مدل ذهنی، مفهوم قدم‌به‌قدم، مثال walkthrough، failure mode، تمرین و پاسخ‌نامه تکمیل کن.
- [x] تفاوت atomic command، persistence، key schema، TTL، KEYS و SCAN را با مثال توضیح بده.
- [x] مثال‌های محلی را از هر production claim جدا و منابع قابل‌دسترسی را حفظ کن.

### Task 3: تعمیق ساختارهای دادهٔ اصلی

**Files:**
- Modify: 03-core-data-structures/strings-bitmaps/README.md
- Modify: 03-core-data-structures/lists-queues/README.md
- Modify: 03-core-data-structures/sets/README.md
- Modify: 03-core-data-structures/hashes/README.md
- Modify: 03-core-data-structures/sorted-sets/README.md

- [x] برای هر نوع جدول دستور/ورودی/خروجی/کاربرد و توضیح هزینه/محدودیت بنویس.
- [x] یک مثال از صفر، یک query کاربردی و یک edge case را walkthrough کن.
- [x] تفاوت انتخاب نوع داده را به شکل مسئله‌محور و همراه rubric تمرین بده.

### Task 4: آموزش قابلیت‌های پیشرفته

**Files:**
- Modify: همهٔ READMEهای 04-advanced-features

- [x] HyperLogLog، Geo، transaction و optimistic locking را با دقت/اتمیک بودن و limitها آموزش بده.
- [x] Streams را با setup کامل، consumer group، PEL، ack، claim، retry، retention و idempotency شرح بده؛ قابلیت‌های NACK/IDMP را با نسخه برچسب بزن.
- [x] Pub/Sub را در برابر Streams مقایسه کن و مثال online/offline بساز.
- [x] pipeline، Lua و Functions را از نظر round trip، atomicity و هزینه جدا کن.

### Task 5: دوام، بازیابی، دسترس‌پذیری و scale

**Files:**
- Modify: همهٔ READMEهای 05-persistence-recovery
- Modify: همهٔ READMEهای 06-high-availability-scaling

- [x] RPO/RTO را با مثال فارسی تعریف کن؛ RDB، AOF، fsync و restore را در مسیر آزمایشی نشان بده.
- [x] replication lag و ناهمگامی، Sentinel quorum/client discovery، Cluster slots/hash tags/MOVED/ASK را درس بده.
- [x] برای هر معماری نمودار متنی، سناریوی خرابی، اثر روی write/read و runbook خلاصه ارائه کن.
- [x] اعداد و ادعاهای کیس‌های واقعی را به منبع لینک کن و به‌عنوان گزارش منتشرشده برچسب بزن.

### Task 6: امنیت، کارایی و عملیات تولید

**Files:**
- Modify: همهٔ READMEهای 07-security
- Modify: همهٔ READMEهای 08-operations-performance
- Modify: 09-production-enterprise/upgrade-dr/README.md
- Modify: 09-production-enterprise/enterprise/README.md
- Modify: 09-production-enterprise/active-active-flash/README.md

- [x] ACL و TLS را با least privilege و لَب امن توضیح بده.
- [x] maxmemory، eviction، memory overhead، latency، pipeline و benchmark را با شاخص‌های قابل فهم تشریح کن.
- [x] INFO، SLOWLOG، MONITOR و Redis Insight/RedisCommander را از نظر کاربرد و سربار مقایسه کن.
- [x] config، upgrade، failover و disaster recovery را با معیار rollback و چک‌لیست توضیح بده.
- [x] Enterprise، Active-Active، compliance و tiering را از OSS جدا و وابستگی محصول را مشخص کن.

### Task 7: نوع‌های جدید و تکمیلی Redis 8.x

**Files:**
- Modify: همهٔ READMEهای 10-modern-data-types

- [x] JSON، Time Series، probabilistic types، Vector Sets و Arrays را همراه انتخاب نوع و حدها آموزش بده.
- [x] قابلیت‌های Redis 8.8 مانند Array، INCREX، NACK و featureهای جدید را با تاریخ/نسخهٔ منبع علامت بزن.
- [x] برای دادهٔ تقریبی، precision و false-positive را واضح کن؛ برای vector search کیفیت retrieval را تضمین‌شده معرفی نکن.

### Task 8: سه پروژهٔ پایانی و پیونددهی

**Files:**
- Create: projects/01-product-cache/README.md
- Create: projects/02-order-stream/README.md
- Create: projects/03-production-readiness/README.md
- Modify: README.md
- Modify: MANIFEST.md

- [x] هر پروژه را به requirements، prerequisite، گام‌ها، expected state، راه‌حل نمونه، failure injection امن و rubric تقسیم کن.
- [x] پیوند فصل‌ها، topicها، واژه‌نامه، quick reference و پروژه‌ها را از فهرست اصلی برقرار کن.
- [x] نشان بده کدام مفاهیم پروژه را پیش‌نیاز می‌سازند.

### Task 9: ممیزی محتوای نهایی

**Files:**
- Review: همهٔ فایل‌های D:\Learn\Roadmap\redis

- [x] تعداد و پوشش ۳۵ موضوع را با roadmap PDF مقایسه کن.
- [x] مسیر هر تمرین را از setup تا خروجی/cleanup بازخوانی کن.
- [x] quiz و answer، پیوند داخلی، لینک منبع، RTL متن فارسی و fenced code را در فایل‌ها بررسی کن.
- [x] مرز «منبع خارجی مکمل» و «پیش‌نیاز اجباری» را در README اصلی روشن کن.


## بازبینی پایانی — ۲۰۲۶-۱۱-۱۱

- ۳۵ درس موضوعی و ۱۰ راهنمای فصل بازنویسی شد؛ ۳ پروژهٔ پایانی و فهرست کامل دوره اضافه شدند.
- READMEهای فارسی با قالب راست‌چین درس‌نامه همسان شدند.
- بازبینی محلی: ۵۶ فایل Markdown، ۰ پیوند داخلی خراب؛ هر ۳۵ درس هدف یادگیری، مثال/کارگاه، تمرین/آزمون، پاسخ‌نامه و منابع فارسی/انگلیسی دارد.
- دستورهای Redis روی سرویس واقعی اجرا نشدند؛ خروجی‌ها نمونهٔ آموزشی‌اند.

