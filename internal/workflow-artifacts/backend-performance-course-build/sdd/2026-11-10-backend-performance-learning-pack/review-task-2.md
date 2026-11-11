# Read-only Task 2 review package

## Implementer report

# Task 2 report — Chapter 01: Caching

Status: implemented. Research date: 2026-11-10. No Git repository was initialized and no commits were made. No software tests or example/lab executions were performed; this task is educational Markdown authoring with manual inspection.

## Implemented files

1. `Backend Performace/01-caching/README.md` — chapter purpose, prerequisites, ordered route, all four topic links, a shared catalog scenario, relationships to API/network/monitoring/testing chapters, and chapter review checklist.
2. `Backend Performace/01-caching/01-cache-layers/README.md` — HTTP/private/shared semantics; browser/client application/server/CDN distinctions; cache keys and Vary; max-age/s-maxage/private/no-cache/no-store; a bilingual public HTTP response example; revalidation exercise; Cloudflare ETag operational evidence; failure signals, checklist and six explained quiz answers.
3. `Backend Performace/01-caching/02-cache-patterns/README.md` — ownership of cache-aside/read-through/write-through, independent read/write axes, failure contracts, source-then-invalidate pseudo-flow, stale-fill race, bounded fallback, exercise, directly supported Meta memcache history, checklist and six explained quiz answers.
4. `Backend Performace/01-caching/03-multi-level-caching/README.md` — per-process L1/shared L2, conditional hit ratios, lifetime preservation across promotions, invalidation/reconnect/fill races, Redis Pub/Sub delivery semantics, a two-replica exercise, Redis client-side tracking operational evidence, checklist and six explained quiz answers.
5. `Backend Performace/01-caching/04-invalidation-and-freshness/README.md` — freshness/expiry/eviction/invalidation distinctions, dependency invalidation, bounded stale windows, coalescing/jitter/cold starts, soft/hard deadline example, lease ownership and late-fill caveats, Netflix interval-aware TTL evidence, checklist and seven explained quiz answers.

All files are Persian-first UTF-8 Markdown. Prose is enclosed in an RTL/right-aligned wrapper; code and diagrams have nested LTR/left-aligned wrappers. Persian numbered questions/answers and steps have blank paragraph separation for Markdown readability. Examples are language-neutral HTTP, pseudocode, diagrams and arithmetic, and are explicitly labeled educational/unexecuted.

## Manual and structural checks

- Confirmed exactly five README files at the five required paths.
- Inspected chapter/topic headings against every element of the topic-page contract: outcomes/definition, model, trade-offs, worked example, exercise and expected observation, evidence or explicit gap, failures/signals, checklist, quiz, explained key, resources and navigation.
- Checked quiz key pairing: layers 6/6, patterns 6/6, multi-level 6/6, freshness 7/7. Answers are supported in the corresponding text.
- Checked example arithmetic: L1 800/1000 and L2 150/200 produce overall hit 95%; L1 600/1000 and L2 320/400 produce 92%, with 80 source reads. Checked that local singleflight across five replicas can still yield five loaders.
- Checked freshness timelines: HTTP max-age 30 versus shared s-maxage 120; promotion at t=55 preserves only five remaining seconds of a t=60 deadline; soft=30/hard=45 rejects the old example entry at t=46.
- Checked balanced HTML divs and even fenced-block markers in every file.
- Checked all relative Markdown links by resolving them from each file. Every chapter-internal link and the parent index link resolved. Some cross-chapter targets were absent during concurrent authoring; their paths match the design spec exactly and are listed below for the final global check.
- No unrelated chapter/root-index files were edited.

## Verified public sources and evidence boundaries

The web reader returned readable content for RFC 9111, RFC 5861, MDN HTTP caching, Cloudflare ETag documentation, Microsoft Cache-aside, AWS ElastiCache caching strategies, AWS caching best practices, the Amazon caching challenges/strategies article, Redis client-side caching, Redis Pub/Sub, Redis EXPIRE, SET, eviction and distributed-lock documentation, Meta's 2013 memcache story, Netflix's 2026 interval-aware Druid story, and the Persian DevNA/Net Paradis/nsin links used in the chapter.

Important URLs used:

- https://www.rfc-editor.org/rfc/rfc9111.html
- https://www.rfc-editor.org/rfc/rfc5861.html
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching
- https://developers.cloudflare.com/cache/reference/etag-headers/
- https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside
- https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Strategies.html
- https://aws.amazon.com/builders-library/caching-challenges-and-strategies/ (currently redirects to AWS Builder Center)
- https://redis.io/docs/latest/develop/clients/client-side-caching/
- https://redis.io/docs/latest/develop/pubsub/
- https://redis.io/docs/latest/commands/expire/
- https://redis.io/docs/latest/commands/set/
- https://redis.io/docs/latest/develop/reference/eviction/
- https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/
- https://engineering.fb.com/2013/04/15/core-infra/scaling-memcache-at-facebook/
- https://netflixtechblog.com/stop-answering-the-same-question-twice-interval-aware-caching-for-druid-at-netflix-scale-22fadc9b840e
- https://devna.ir/articles/redis-caching-guide
- https://netparadis.com/redis-data-types-caching-strategy/
- https://nsin.ir/blog/how-cdn-caching-works/

Cloudflare and Redis evidence is explicitly characterized as authoritative product/operational documentation, without an invented customer benchmark. Meta is used only for the history and workload described directly in its public engineering post. Netflix is described as an experimental cache layer, matching its article, and its five-second trade-off is not generalized to payments or authorization. No company performance metrics have been invented or copied into educational examples.

## Issues and concerns for integration

1. The USENIX page/PDF linked by Meta returned HTTP 403. The chapter states this limitation and makes no detailed claims from the unread paper.
2. The legacy Redis distributed-lock URL redirects to the current `/develop/clients/patterns/distributed-locks/`; the chapter uses the verified current URL.
3. A Persian L1/L2 article was discoverable in search but its direct page could not be read reliably. It was not used. The multi-level guide explicitly states the narrow Persian coverage gap and uses the verified Net Paradis Redis/TTL page as prerequisite reading rather than claiming it covers the whole coherence protocol.
4. At the local-link check, the following design-spec targets were still absent outside this task's ownership:
   - `02-api-response/04-avoid-unnecessary-server-work/README.md`
   - `03-asynchronism/01-background-jobs/README.md`
   - `05-load-balancing-and-scaling/02-load-balancing/README.md`
   - `06-code-optimization/07-timeouts-and-retries/README.md`
   - `07-monitoring-and-logging/01-metrics-logs-and-traces/README.md`
   - `09-performance-testing/01-load-testing-and-regression-benchmarks/README.md`
   - `10-network/01-region-and-network-latency/README.md`
   - `10-network/03-cdn-for-static-and-frequent-content/README.md`
   The parent agent has been notified to include these in final global link validation after other chapters land. No chapter-internal links were unresolved.
5. No rendered browser/PDF appearance was claimed. RTL/LTR structure and paragraph/fence balance were inspected as Markdown; actual viewer support can vary.

No implementation blocker remains within Chapter 01's scope.


## Snapshot: Backend Performace/01-caching/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # فصل ۰۱ — کش و استفاده دوباره از نتیجه
   4: 
   5: کش یعنی نگهداری نسخه‌ای قابل بازسازی از یک پاسخ، داده یا محاسبه برای استفاده دوباره. پرسش اصلی این فصل «کجا Redis نصب کنیم؟» نیست؛ باید بدانیم کدام کار تکراری را حذف می‌کنیم، تا چه مدت نتیجه قابل قبول است و وقتی نسخه‌ها با هم اختلاف دارند چه رفتاری مجاز است. نتیجه برای کاربر می‌تواند انتظار کمتر باشد؛ نتیجه برای سامانه می‌تواند کاهش کار پایگاه داده و شبکه باشد، به شرط آنکه هزینه نگهداری کش و miss را هم بسنجیم.
   6: 
   7: این فصل چهار زیرموضوع Caching در [نقشه راه Backend Performance](https://roadmap.sh/backend-performance-best-practices) را پوشش می‌دهد. **تاریخ بررسی منابع: ۲۰۲۶-۱۱-۱۰**. مثال‌ها آموزشی و مستقل از زبان هستند؛ عددهای آن‌ها اندازه‌گیری یک شرکت یا هدف عمومی ظرفیت نیستند.
   8: 
   9: ## پیش‌نیاز و مسیر مطالعه
  10: 
  11: با درخواست/پاسخ HTTP، تفاوت خواندن و نوشتن در پایگاه داده، تأخیر، صدک، و مفهوم چند نمونه از یک سرویس آشنا باشید. شناخت ابتدایی key/value کافی است؛ اجرای Redis یا داشتن حساب ابری پیش‌نیاز نیست.
  12: 
  13: | ترتیب | درس | پرسشی که باید پاسخ دهید |
  14: | --- | --- | --- |
  15: | ۱ | [لایه‌های کش: HTTP، کلاینت، سرور و CDN](01-cache-layers/README.md) | کدام لایه می‌تواند کدام بخش از کار درخواست را حذف کند؟ |
  16: | ۲ | [الگوهای Cache-aside، Read-through و Write-through](02-cache-patterns/README.md) | چه کسی داده را وارد کش می‌کند و چه کسی مسئول هماهنگی با منبع است؟ |
  17: | ۳ | [کش چندسطحی](03-multi-level-caching/README.md) | چگونه کش محلی و مشترک را کنار هم بگذاریم، بدون فراموش کردن نسخه‌ها؟ |
  18: | ۴ | [ابطال، تازگی، TTL و جلوگیری از Stampede](04-invalidation-and-freshness/README.md) | چه مدت کهنگی مجاز است و هنگام انقضا چه اتفاقی می‌افتد؟ |
  19: 
  20: در هر درس ابتدا مدل و مثال را بخوانید، تمرین را با کاغذ یا ابزار دلخواه انجام دهید، سپس بدون دیدن پاسخ‌نامه به آزمون جواب دهید. تمرین‌ها آزمایش پیشنهادی‌اند؛ اجرای آن‌ها در محیط شما ادعا نشده است.
  21: 
  22: ## سناریوی پیوسته فصل
  23: 
  24: یک کاتالوگ آموزشی سه نوع داده دارد: تصویر نسخه‌دار کالا، توضیح عمومی کالا، و قیمت نهایی سفارش. تصویر با URL دارای هش محتوا در مرورگر و CDN قابل استفاده دوباره است. توضیح عمومی می‌تواند کش پاسخ و کش داده با بودجه کهنگی مشخص داشته باشد. قیمت نهایی به اعتبارسنجی منبع و قواعد تراکنش نیاز دارد؛ نسخه نمایشی کش‌شده به‌تنهایی مجوز ثبت سفارش نیست.
  25: 
  26: ۱. در درس اول مسیر درخواست را رسم کنید و مالک هر کش را بنویسید.
  27: 
  28: ۲. در درس دوم برای توضیح کالا Cache-aside انتخاب کنید و مسیر commit و ابطال را مشخص کنید.
  29: 
  30: ۳. در درس سوم فقط اگر هزینه مراجعه به کش مشترک مسئله شد، L1 محلی اضافه کنید و شکست ارتباط ابطال را شبیه‌سازی کنید.
  31: 
  32: ۴. در درس چهارم هم‌زمانی انقضای یک کالای محبوب و به‌روزرسانی قیمت را تحلیل کنید.
  33: 
  34: این انتخاب‌ها نسخه نهایی معماری نیستند؛ باید با ترافیک، تازگی و ظرفیت منبع خود ارزیابی شوند. تجربه عملیاتی [Amazon درباره چالش‌های کش](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) برای دیدن خطر وابستگی ظرفیت سرویس به کش گرم مفید است.
  35: 
  36: ## ارتباط با فصل‌های دیگر
  37: 
  38: - [پاسخ API](../02-api-response/README.md): کش پاسخ با کوچک‌کردن payload فرق دارد؛ یک پاسخ بزرگ در hit هم بایت و هزینه انتقال دارد.
  39: - [حذف کار غیرضروری سرور](../02-api-response/04-avoid-unnecessary-server-work/README.md): پاسخ شرطی و reuse فقط بخشی از حذف کار تکراری‌اند.
  40: - [CDN و محتوای پرتکرار](../10-network/03-cdn-for-static-and-frequent-content/README.md): انتخاب محل تحویل و قواعد CDN را پس از شناخت لایه‌ها بخوانید.
  41: - [ناحیه و تأخیر شبکه](../10-network/01-region-and-network-latency/README.md): کش نزدیک‌تر همیشه نسخه تازه‌تر نیست؛ فاصله و تازگی دو مسئله جدا هستند.
  42: - [پایش](../07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) و [آزمون عملکرد](../09-performance-testing/01-load-testing-and-regression-benchmarks/README.md): hit ratio، سن داده و رفتار سرد/گرم را همراه تأخیر انتهابه‌انتها بررسی کنید.
  43: 
  44: ## چک‌لیست مرور فصل
  45: 
  46: - [ ] می‌توانم تفاوت کش private مرورگر، shared HTTP و کش داده سرور را با مثال توضیح دهم.
  47: - [ ] می‌دانم `no-cache`، `no-store` و `private` یک معنی ندارند.
  48: - [ ] مسئول loader و مسیر write برای هر الگوی کش مشخص است.
  49: - [ ] کلید کش تمام ابعاد مؤثر بر نتیجه و جداسازی tenant را در نظر می‌گیرد.
  50: - [ ] برای هر سطح hit/miss جدا و برای منبع تعداد درخواست واقعی دارم.
  51: - [ ] بودجه کهنگی، مسیر commit/ابطال، و رفتار هنگام قطع پیام مشخص است.
  52: - [ ] انقضا، eviction، refresh و ابطال دستی را از هم تفکیک می‌کنم.
  53: - [ ] برای hot key، cold start، خرابی کش و هجوم هم‌زمان برنامه محدود و قابل مشاهده دارم.
  54: 
  55: [بازگشت به فهرست مجموعه](../README.md) · [شروع درس اول](01-cache-layers/README.md)
  56: 
  57: </div>

## Snapshot: Backend Performace/01-caching/01-cache-layers/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # ۰۱.۱ — لایه‌های کش: HTTP، کلاینت، سرور و CDN
   4: 
   5: **تاریخ بررسی منابع: ۲۰۲۶-۱۱-۱۰** · پیش‌نیاز: مسیر یک درخواست HTTP و مفهوم پایگاه داده · زمان پیشنهادی: یک نشست مطالعه و تمرین.
   6: 
   7: ## هدف یادگیری و تعریف
   8: 
   9: پس از این درس می‌توانید محل نگهداری نتیجه را در مسیر درخواست مشخص کنید، تفاوت کش پاسخ و کش داده را توضیح دهید و برای پاسخ عمومی و شخصی سیاست متفاوت بنویسید. **لایه کش** محل نگهداری و استفاده دوباره از نتیجه است؛ **HTTP caching** قرارداد استفاده دوباره از پاسخ HTTP است و می‌تواند در چند محل اجرا شود. بنابراین HTTP، مرورگر و CDN سه فناوری مستقل و هم‌عرض نیستند: مرورگر و CDN می‌توانند مجری همان قرارداد باشند.
  10: 
  11: ## مدل ذهنی: هر hit چه کاری را حذف می‌کند؟
  12: 
  13: | لایه | چه چیزی نگه می‌دارد؟ | در hit چه مسیری حذف می‌شود؟ | محدودیت مهم |
  14: | --- | --- | --- | --- |
  15: | مرورگر؛ private HTTP cache | پاسخ مناسب همان کاربر | درخواست شبکه برای پاسخ هنوز تازه | کنترل پاک‌سازی همه مرورگرها در اختیار سرور نیست |
  16: | کش برنامه کلاینت | داده یا نتیجه در حافظه برنامه، مثلاً فهرست آخرین جست‌وجو | فراخوانی API | قواعد آن الزاماً قواعد HTTP نیست؛ خروج کاربر باید مدیریت شود |
  17: | CDN یا reverse proxy؛ shared cache | پاسخ مشترک بین درخواست‌های مجاز | مراجعه تا origin | کلید و سیاست اشتراک باید جلوی نشت داده را بگیرد |
  18: | کش پاسخ در سرور | پاسخ ساخته‌شده endpoint | بخشی از routing، query و serialization بسته به محل آن | ابعاد هویت، زبان و query باید درست جدا شوند |
  19: | کش داده در سرور؛ محلی یا مشترک | موجودیت، query result یا محاسبه | دسترسی یا محاسبه پرهزینه | سرور همچنان باید درخواست و پاسخ را پردازش کند |
  20: 
  21: تقسیم private و shared و نقش هدرها در [RFC 9111، بخش‌های ۱ و ۴](https://www.rfc-editor.org/rfc/rfc9111.html#section-1) تعریف شده است. کش داده معمولی زیر کنترل این RFC نیست؛ گذاشتن `Cache-Control` در پاسخ، Redis داخلی شما را منقضی نمی‌کند.
  22: 
  23: <div dir="ltr" align="left">
  24: 
  25: ```mermaid
  26: flowchart LR
  27:     B[Browser HTTP cache] -->|miss or revalidate| E[CDN shared cache]
  28:     E -->|miss or revalidate| A[Origin application]
  29:     A --> C[Server data cache]
  30:     C -->|miss| D[Database]
  31: ```
  32: 
  33: </div>
  34: 
  35: گام اول تعیین «یکسان بودن» درخواست‌هاست: آیا URL، query، زبان، encoding یا هویت نتیجه را عوض می‌کند؟ گام دوم انتخاب داده قابل اشتراک است. گام سوم تعیین تازگی و اعتبارسنجی است. `Vary` به کش HTTP می‌گوید برای انتخاب نسخه ذخیره‌شده، کدام هدر درخواست را نیز مقایسه کند؛ این هدر جای کنترل دسترسی را نمی‌گیرد. برای تفاوت زبان در مثال، `Vary: Accept-Language` لازم است؛ برای محتوای فشرده بسته به تولیدکننده پاسخ باید `Accept-Encoding` نیز در نظر گرفته شود. [مبنای فنی: RFC 9111، بخش ۴.۱](https://www.rfc-editor.org/rfc/rfc9111.html#section-4.1).
  36: 
  37: | دستور پاسخ | معنی کاربردی |
  38: | --- | --- |
  39: | `max-age=60` | تازگی را با سن پاسخ و مدت اعلام‌شده می‌سنجیم، نه زمان نصب کش |
  40: | `s-maxage=300` | مدت تازگی مختص shared cache؛ برای آن بر `max-age` اولویت دارد |
  41: | `private` | پاسخ در shared cache ذخیره نشود؛ مجوز خصوصی‌سازی کلید نیست |
  42: | `no-cache` | استفاده دوباره به اعتبارسنجی موفق نیاز دارد؛ ذخیره‌سازی را منع نمی‌کند |
  43: | `no-store` | کش نباید این تبادل را ذخیره کند؛ فرمان purge نسخه‌های قبلی نیست |
  44: 
  45: تعریف دقیق دستورها در [RFC 9111، بخش ۵.۲.۲](https://www.rfc-editor.org/rfc/rfc9111.html#section-5.2.2) آمده است. صرف وجود `Set-Cookie` راهبرد عمومی جلوگیری از کش نیست؛ سیاست صریح و تنظیم محصول را بررسی کنید.
  46: 
  47: ## چه زمانی مفید است و چه هزینه‌ای دارد؟
  48: 
  49: فایل نسخه‌دار عمومی، توضیح کالا و پاسخ جست‌وجوی تکراری نامزدهای معقول‌اند. پیش از انتخاب، ببینید هزینه اصلی شبکه است یا query/محاسبه؛ کش داده شاید query را حذف کند اما مسیر دور شبکه باقی می‌ماند. پاسخ شخصی می‌تواند سیاست private مناسب خود داشته باشد، ولی اطلاعات بسیار حساس ممکن است به `no-store` نیاز داشته باشد. این انتخاب تابع نیاز محصول است؛ «همه GETها را cache کن» سیاست مناسبی نیست.
  50: 
  51: تعداد زیاد ابعاد کلید، نسخه‌ها را پراکنده و hit را کم می‌کند. حذف ابعاد مؤثر برای افزایش hit، پاسخ غلط ایجاد می‌کند. کش نزدیک‌تر معمولاً بخش بیشتری از مسیر را حذف می‌کند، ولی ابطال همه نسخه‌های آن دشوارتر می‌شود. موضوع انتخاب PoP و هزینه شبکه در [درس CDN](../../10-network/03-cdn-for-static-and-frequent-content/README.md) ادامه دارد.
  52: 
  53: ## مثال حل‌شده: یک پاسخ عمومی دوزبانه
  54: 
  55: **سناریوی آموزشی؛ اجرا یا اندازه‌گیری نشده است.** `/catalog/42` بدون هویت کاربر، توضیح عمومی را بر اساس زبان برمی‌گرداند. برای سادگی سن پاسخ اولیه صفر است و خطا یا override اختصاصی CDN نداریم.
  56: 
  57: <div dir="ltr" align="left">
  58: 
  59: ```http
  60: GET /catalog/42 HTTP/1.1
  61: Host: example.test
  62: Accept-Language: fa
  63: 
  64: HTTP/1.1 200 OK
  65: Content-Type: application/json
  66: Cache-Control: public, max-age=30, s-maxage=120
  67: Vary: Accept-Language
  68: ETag: "catalog-42-fa-v7"
  69: 
  70: {"id":42,"title":"Example product"}
  71: ```
  72: 
  73: </div>
  74: 
  75: در ثانیه ۲۰ مرورگر می‌تواند پاسخ تازه را دوباره مصرف کند. در ثانیه ۴۰ پاسخ مرورگر دیگر تازه نیست اما CDN، با احتساب سن پاسخ، ممکن است پاسخ تازه خود را ارائه کند؛ درخواست تا origin نمی‌رود. در سن ۱۳۰، نسخه CDN نیز نیاز به اعتبارسنجی یا دریافت پاسخ جدید دارد. اگر validator هنوز مطابق باشد، پاسخ شرطی می‌تواند `304 Not Modified` باشد و بدنه دوباره فرستاده نشود؛ 304 همچنان یک رفت‌وبرگشت و احتمالاً مقداری کار سرور دارد. آموزش [MDN HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching#validation) این جریان شرطی را نشان می‌دهد.
  76: 
  77: برای `/me` همین سیاست عمومی را کپی نکنید. در این سناریو تصمیم محصول این است که اطلاعات حساب ذخیره نشود، پس پاسخ آن `Cache-Control: no-store` دارد. جداکردن نتیجه کاربران در کش داخلی نیز مسئولیت برنامه است.
  78: 
  79: ## تمرین کوچک و مشاهده مورد انتظار
  80: 
  81: ۱. با کاغذ، برای درخواست زبان `fa` در سن‌های ۲۰، ۴۰ و ۱۳۰ مسیر را روی نمودار علامت بزنید؛ سپس درخواست `en` در ثانیه ۲۰ را اضافه کنید.
  82: 
  83: ۲. در صورت داشتن endpoint آزمایشی تحت کنترل خود، همین هدرها را تنظیم کنید و در Network مرورگر با گزینه Disable cache خاموش، URL ثابت را دوباره باز کنید. ستون‌های transferred، status و `Age` در صورت وجود را ثبت کنید.
  84: 
  85: ۳. تنها `no-cache` را جایگزین سیاست عمومی کنید؛ با وجود validator ثابت، انتظار درخواست شرطی دارید، نه تضمین دانلود مجدد بدنه.
  86: 
  87: **انتظار:** نسخه انگلیسی نباید به خاطر hit فارسی، فارسی برگردد. درخواست مجدد ممکن است از حافظه/دیسک، از لبه، یا با 304 پاسخ بگیرد؛ این‌ها را یک نوع hit ننویسید. مرورگر reload، تنظیمات CDN و هدرهای واقعی رفتار را تغییر می‌دهند. `curl` معمولی کش مرورگر نیست؛ دو اجرای آن به‌تنهایی رفتار private cache را نشان نمی‌دهد.
  88: 
  89: ## شاهد عمومی و مرز نتیجه‌گیری
  90: 
  91: > **مستند عملیاتی محصول، نه benchmark یک مشتری:** [مستند رسمی Cloudflare درباره ETag](https://developers.cloudflare.com/cache/reference/etag-headers/) نشان می‌دهد یک CDN واقعی چگونه validatorهای origin و مرورگر را مدیریت می‌کند و میان ETag قوی و ضعیف فرق می‌گذارد. این شاهد استفاده از قرارداد HTTP در چند لایه است. از آن، عدد کاهش تأخیر برای سامانه فرضی ما یا یکسان بودن رفتار همه CDNها نتیجه نمی‌گیریم.
  92: 
  93: ## خطاهای رایج و نشانه‌های عملیاتی
  94: 
  95: | شکست | نشانه | بررسی عملی |
  96: | --- | --- | --- |
  97: | اشتراک پاسخ شخصی | کاربر دیگری نام/سبد فرد اول را می‌بیند | سیاست private/no-store، bypass و کلید را با دو هویت بررسی کنید |
  98: | کلید فاقد زبان یا query مؤثر | پاسخ درست با پارامتر نامرتبط عوض می‌شود | ماتریس URL/query/زبان را با بدنه پاسخ مقایسه کنید |
  99: | `no-cache` با `no-store` اشتباه گرفته شده | انتظار عدم ذخیره بوده ولی پاسخ نگه داشته می‌شود | هدر خروجی واقعی تمام proxyها را ببینید |
 100: | hit داده ولی TTFB همچنان بالا | DB آرام شده و تأخیر مسیر باقی است | trace تا origin و هزینه serialize/شبکه را جدا کنید |
 101: | purge فقط در CDN | بعضی کاربران همچنان نسخه قبلی دارند | عمر مرورگر و نسخه URL را بررسی کنید |
 102: 
 103: ## چک‌لیست عملیاتی
 104: 
 105: - [ ] برای هر endpoint مشخص است عمومی، خصوصی یا غیرقابل ذخیره است.
 106: - [ ] کلید و `Vary` تمام تفاوت‌های مؤثر را پوشش می‌دهند؛ کنترل دسترسی مستقل برقرار است.
 107: - [ ] هدرهایی که به کاربر می‌رسند با هدرهای تولیدشده origin مقایسه شده‌اند.
 108: - [ ] hit/miss/bypass/revalidation در هر لایه جدا ثبت می‌شود.
 109: - [ ] هم TTFB و بایت انتقالی، هم نرخ درخواست origin و query سنجیده می‌شوند.
 110: - [ ] پاسخ 304 به معنی «سرور هیچ کاری نکرده» تلقی نمی‌شود.
 111: - [ ] تغییر محتوا و خروج کاربر با نسخه‌های ذخیره‌شده بررسی شده‌اند.
 112: 
 113: ## آزمون
 114: 
 115: ۱. آیا «HTTP cache» حتماً یک سرور جدا کنار Redis است؟
 116: 
 117: ۲. تفاوت `no-cache` و `no-store` چیست؟
 118: 
 119: ۳. چرا افزودن Redis لزوماً تأخیر کاربر دور از origin را حذف نمی‌کند؟
 120: 
 121: ۴. در مثال با سن پاسخ ۴۰ ثانیه، کدام مدت برای shared cache ملاک است؟
 122: 
 123: ۵. اگر زبان در header نتیجه را عوض کند، کش HTTP چگونه نسخه‌ها را جدا می‌کند؟
 124: 
 125: ۶. آیا 304 ثابت می‌کند درخواست به origin نرسیده است؟
 126: 
 127: ### پاسخ تشریحی
 128: 
 129: ۱. خیر؛ قرارداد ذخیره و reuse پاسخ HTTP است و مرورگر، proxy یا CDN می‌تواند آن را اجرا کند. Redis می‌تواند مستقل و برای داده داخلی باشد.
 130: 
 131: ۲. اولی پیش از reuse اعتبارسنجی می‌خواهد و دومی ذخیره این تبادل را منع می‌کند؛ هیچ‌یک به‌تنهایی فرمان پاک‌سازی همه نسخه‌های قبلی نیست.
 132: 
 133: ۳. hit کش داده می‌تواند query را حذف کند، ولی درخواست همچنان شبکه تا برنامه و پردازش پاسخ را طی می‌کند.
 134: 
 135: ۴. `s-maxage=120`؛ برای مرورگر `max-age=30` برقرار است. سن پاسخ باید در محاسبه لحاظ شود.
 136: 
 137: ۵. در مثال `Vary: Accept-Language`؛ بدون جداسازی ابعاد مؤثر، انتخاب نسخه غلط ممکن است. این کار جای مجوزدهی را نمی‌گیرد.
 138: 
 139: ۶. خیر؛ revalidation می‌تواند به origin برسد. 304 از ارسال دوباره بدنه جلوگیری می‌کند و الزاماً تعداد تمام رفت‌وبرگشت‌ها را کم نمی‌کند.
 140: 
 141: ## منابع پیشنهادی
 142: 
 143: - انگلیسی، معیار اصلی: [RFC 9111 — HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111.html)، برای private/shared، عمر پاسخ و دستورهای Cache-Control.
 144: - انگلیسی، آموزشی: [MDN HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching)، برای مدل مرورگر، شرطی‌سازی و تفاوت reload.
 145: - انگلیسی، شاهد محصول: [Cloudflare ETag headers](https://developers.cloudflare.com/cache/reference/etag-headers/)، برای محدودیت‌های یک پیاده‌سازی واقعی CDN.
 146: - فارسی، مطالعه تکمیلی: [راهنمای کش CDN در nsin](https://nsin.ir/blog/how-cdn-caching-works/)، برای واژگان cache key، TTL و purge. پیشنهادهای عددی یا قواعد اختصاصی سرویس را قانون HTTP فرض نکنید؛ در اختلاف، RFC و مستند محصول خود را ملاک بگیرید.
 147: 
 148: [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [درس بعد: الگوهای کش](../02-cache-patterns/README.md) · [مرتبط: کوچک‌کردن پاسخ](../../02-api-response/01-payload-size/README.md)
 149: 
 150: </div>

## Snapshot: Backend Performace/01-caching/02-cache-patterns/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # ۰۱.۲ — الگوهای Cache-aside، Read-through و Write-through
   4: 
   5: **تاریخ بررسی منابع: ۲۰۲۶-۱۱-۱۰** · پیش‌نیاز: key/value، منبع اصلی داده و commit · موضوع قبلی پیشنهادی: [لایه‌های کش](../01-cache-layers/README.md).
   6: 
   7: ## هدف یادگیری و تعریف
   8: 
   9: پس از مطالعه می‌توانید مسئول cache miss را تعیین کنید، مسیر write را از read جدا طراحی کنید و توضیح دهید چرا «دو مقدار نوشته شد» به معنی تراکنش اتمیک میان پایگاه داده و کش نیست. الگوی کش قرارداد بین **برنامه، کش و منبع اصلی** است؛ نام یک ابزار، این قرارداد را تعیین نمی‌کند.
  10: 
  11: در این درس Cache-aside یعنی برنامه خودش cache lookup، بارگذاری از منبع و cache population را هماهنگ می‌کند. Read-through یعنی برنامه یک abstraction دارای loader را صدا می‌زند و آن لایه miss را از منبع تأمین می‌کند. Write-through یعنی write از مسیر واسط مشخص عبور می‌کند و پیش از موفقیت مطابق قرارداد، در منبع پایدار و کش اعمال می‌شود. نام‌گذاری پیاده‌سازی‌ها متفاوت است؛ قرارداد خطا و ترتیب را در مستند همان محصول بخوانید. [معرفی رسمی این خانواده الگوها: Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside).
  12: 
  13: ## مدل ذهنی و مقایسه
  14: 
  15: | الگو | مسئول miss در read | مسیر نوشتن در این درس | هزینه و خطر اصلی |
  16: | --- | --- | --- | --- |
  17: | Cache-aside | کد برنامه | commit منبع، سپس ابطال ورودی وابسته | کد تکراری، miss کندتر و پنجره ناسازگاری |
  18: | Read-through | loader در لایه کش/کتابخانه | مستقل تعیین می‌شود؛ می‌تواند با write-through همراه باشد | وابستگی به قرارداد loader، مدیریت خطا و ابطال بیرون از آن |
  19: | Write-through | الگوی read را تعیین نمی‌کند | واسط نوشتن، منبع و کش را پیش از تأیید هماهنگ می‌کند | افزایش کار مسیر write و مسئله شکست جزئی |
  20: 
  21: Read-through و Write-through دو محور متفاوت‌اند: اولی read را توصیف می‌کند و دومی write را. یک wrapper ساده می‌تواند Read-through فراهم کند؛ Redis معمولی خودبه‌خود از SQL شما خبر ندارد. همچنین Write-through با Write-behind فرق دارد: در Write-behind نوشتن منبع به بعد موکول می‌شود و دوام/بازپخش مسئله اصلی است؛ پیاده‌سازی آن خارج از این درس است. [مستند AWS ElastiCache درباره lazy loading و write-through](https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Strategies.html) برای دیدن هزینه miss و نوشتن داده‌ای که شاید هرگز خوانده نشود مناسب است.
  22: 
  23: <div dir="ltr" align="left">
  24: 
  25: ```mermaid
  26: sequenceDiagram
  27:     participant A as Application
  28:     participant C as Cache
  29:     participant D as Source database
  30:     A->>C: GET product:42
  31:     alt cache hit
  32:         C-->>A: cached value
  33:     else cache miss
  34:         A->>D: READ product 42
  35:         D-->>A: committed value
  36:         A->>C: SET value with expiry
  37:     end
  38: ```
  39: 
  40: </div>
  41: 
  42: نمودار متعلق به Cache-aside است. برای Read-through، بخش lookup و loader داخل abstraction قرار می‌گیرد؛ این جابه‌جایی مسئولیت، هزینه I/O منبع در miss را حذف نمی‌کند.
  43: 
  44: ## چه زمانی انتخاب کنیم؟
  45: 
  46: Cache-aside برای نتیجه‌های پرتکرار که همه داده‌های منبع لازم نیست در حافظه جا شوند، نقطه شروع ساده‌ای است. اگر هر درخواست یک کلید جدید دارد، هزینه cache lookup و fill به miss افزوده می‌شود و سود کمی می‌گیرید. Read-through وقتی مفید است که قرارداد مشترک loader و خطا را در چند مصرف‌کننده یکدست می‌کند؛ loader نباید پنهانی queryهای بدون حد یا retry بی‌نهایت اجرا کند.
  47: 
  48: Write-through برای مسیرهایی قابل بررسی است که تمام writerها از واسط عبور می‌کنند و هزینه نوشتن بیشتر پذیرفته می‌شود. یک SQL job، migration یا سرویس دیگر که مستقیم منبع را تغییر می‌دهد، فرض آن را می‌شکند. حتی در Write-through، eviction و restart می‌تواند کش را خالی کند؛ برای read هنوز مسیر miss لازم است. برای مجوز دسترسی، موجودی قطعی یا محاسبات مالی، شرط درست‌بودن را با تراکنش/منبع معتبر بررسی کنید؛ hit کش به‌تنهایی تضمین تجاری نیست.
  49: 
  50: ## مثال حل‌شده: توضیح عمومی کالا با Cache-aside
  51: 
  52: **فرض آموزشی:** توضیح کالا می‌تواند برای مدتی محدود قدیمی باشد و منبع اصلی پایگاه داده است. تمام اعداد پیکربندی نمونه‌اند. کلید شامل tenant و نسخه ساختار است؛ ابعاد دیگری مانند زبان، در صورت مؤثر بودن بر داده، باید اضافه شوند.
  53: 
  54: <div dir="ltr" align="left">
  55: 
  56: ```text
  57: function readProduct(tenantId, productId):
  58:     authorizeRead(tenantId, productId)
  59:     key = "product:v2:" + tenantId + ":" + productId
  60:     cached = cache.tryGet(key, cacheTimeBudget)
  61:     if cached.found:
  62:         return cached.value
  63: 
  64:     # A cache error is distinct from an ordinary miss in metrics.
  65:     value = source.readCommitted(tenantId, productId, sourceTimeBudget)
  66:     cache.trySet(key, value, ttlSeconds=60)  # bounded best effort
  67:     return value
  68: 
  69: function updateProduct(tenantId, productId, change):
  70:     authorizeWrite(tenantId, productId)
  71:     source.commitChange(tenantId, productId, change)
  72:     cache.tryDelete("product:v2:" + tenantId + ":" + productId)
  73: ```
  74: 
  75: </div>
  76: 
  77: در read اول اگر کش خالی باشد، منبع خوانده می‌شود و نتیجه ۶۰ ثانیه نگه داشته می‌شود. read دوم پیش از انقضا می‌تواند hit باشد. بعد از commit نویسنده، حذف ورودی باعث می‌شود read بعدی دوباره منبع را ببیند. **این شبه‌کد عمداً یک پایه آموزشی با تضمین محدود است:** شکست delete باید ثبت و جبران شود؛ برای پاک‌شدن قابل اتکا می‌توان رخداد ابطال را همراه commit در outbox ثبت کرد و worker قابل retry داشت. نقش [کار پس‌زمینه](../../03-asynchronism/01-background-jobs/README.md) را آنجا مطالعه کنید.
  78: 
  79: ترتیب commit سپس delete، خطر پرشدن کش با داده هنوز commit‌نشده در فاصله حذف و commit را کم می‌کند، اما همه raceها را حل نمی‌کند. مثال مستقل: خواننده A نسخه ۷ را از منبع می‌گیرد، نویسنده B نسخه ۸ را commit و کلید را حذف می‌کند، سپس A نسخه ۷ را وارد کش می‌کند. در نتیجه تا ابطال بعدی یا expiry می‌توان داده قدیمی دید. برای تضمین قوی‌تر، بررسی نسخه/نسل، کنترل نوشتن fill و بازبینی مسیر خواندن لازم است؛ جزئیات در [ابطال و تازگی](../04-invalidation-and-freshness/README.md).
  80: 
  81: خطای کش با miss یکسان نیست: اگر تمام درخواست‌ها در خرابی کش مستقیم به منبع بروند، ممکن است ظرفیت منبع کافی نباشد. این مثال باید با سقف هم‌زمانی منبع، deadline و رفتار کاهش خدمت تکمیل شود؛ انتخاب سیاست بر اساس حساسیت داده است.
  82: 
  83: ## تمرین کوچک و مشاهده مورد انتظار
  84: 
  85: یک جدول دستی با ستون‌های `source version`، `cache version` و «چه کسی پاسخ می‌دهد» بسازید:
  86: 
  87: ۱. منبع نسخه ۷ و کش خالی است؛ دو read متوالی انجام دهید.
  88: 
  89: ۲. نسخه ۸ را در منبع commit کنید ولی delete را به‌صورت عمدی ناموفق فرض کنید.
  90: 
  91: ۳. یک read پیش از expiry و یک read پس از expiry انجام دهید.
  92: 
  93: ۴. همین readها را به abstraction فرضی `getOrLoad(key, loader)` منتقل کنید و بنویسید کدام مسئولیت از caller حذف شد.
  94: 
  95: ۵. برای Write-through فرض کنید commit موفق ولی cache write ناموفق شده است. قرارداد پاسخ API و retry را بنویسید.
  96: 
  97: **انتظار:** در مرحله اول یک بار خواندن منبع کافی است، در مرحله دوم کهنگی ظاهر می‌شود و در مرحله سوم expiry فرصت بارگذاری مجدد می‌دهد. جابه‌جایی به Read-through ناسازگاری write را خودبه‌خود برطرف نمی‌کند. در مرحله پنجم نمی‌توانید بگویید «هیچ اتفاقی نیفتاد»؛ منبع تغییر کرده است. retry بدون idempotency ممکن است اثر تجاری را تکرار کند. این تمرین محاسبه مسیر است، نه benchmark سرعت Redis.
  98: 
  99: ## تجربه عمومی مستند
 100: 
 101: > [گزارش مهندسی Meta در ۱۵ آوریل ۲۰۱۳](https://engineering.fb.com/2013/04/15/core-infra/scaling-memcache-at-facebook/) توضیح می‌دهد Facebook در سال ۲۰۰۵، در واکنش به رشد queryها و افزایش زمان بارگذاری صفحه، استفاده از memcached را آغاز کرد. همان گزارش به چالش‌های محبوبیت نامتوازن داده و fan-out اشاره می‌کند. این شاهد نقش عملی کش کنار منبع است؛ از متن کوتاه آن، نوع دقیق قرارداد Write-through یا تضمین اتمیک‌بودن نتیجه نمی‌گیریم. مقاله فنی پیوندشده در USENIX هنگام این بررسی با 403 قابل خواندن نبود؛ ادعاهای جزئی آن در این درس نقل نشده‌اند.
 102: 
 103: برداشت آموزشی ما این است که انتخاب الگو باید با تکرار read و هزینه منبع مرتبط باشد، نه فقط نام دیتابیس یا اندازه شرکت.
 104: 
 105: ## شکست‌ها، سیگنال‌ها و چک‌لیست
 106: 
 107: | شکست | سیگنال قابل مشاهده | اقدام بررسی |
 108: | --- | --- | --- |
 109: | همه missها چند query اجرا می‌کنند | افزایش query به ازای درخواست و p95/p99 miss | loader را جدا trace کنید |
 110: | حذف ناموفق پس از commit | اختلاف نسخه منبع/کش و خطای invalidation | ثبت رخداد، retry محدود و TTL پشتیبان |
 111: | کلید بدون tenant یا schema version | اختلاط پاسخ یا خطای deserialize | طراحی namespace و سناریوی دو tenant |
 112: | نویسنده بیرون از واسط | تغییر منبع بدون تغییر کش | فهرست همه writerها و مسیر انتشار تغییر |
 113: | اشتباه missing با خرابی موقت | ذخیره «یافت نشد» هنگام timeout منبع | negative cache فقط برای نبود معتبر با TTL مشخص |
 114: 
 115: - [ ] منبع حقیقت و مسئول lookup/load/write برای هر الگو نوشته شده‌اند.
 116: - [ ] miss، cache error، loader error و write error شمارنده جدا دارند.
 117: - [ ] زمان انتظار کش و منبع محدود است؛ ظرفیت fallback بررسی شده است.
 118: - [ ] cache fill دارای TTL و سقف اندازه است؛ نبود TTL تصمیم آگاهانه است.
 119: - [ ] همه writerها و کلیدهای وابسته، شامل فهرست/جست‌وجو، شناخته شده‌اند.
 120: - [ ] شکست جزئی write و پاسخ تکراری با idempotency سازگار است.
 121: - [ ] مسیر ابطال ناموفق و خواننده هم‌زمان در تمرین بررسی شده‌اند.
 122: 
 123: ## آزمون
 124: 
 125: ۱. تفاوت تعیین‌کننده Cache-aside و Read-through چیست؟
 126: 
 127: ۲. آیا انتخاب Read-through مشخص می‌کند write چگونه انجام شود؟
 128: 
 129: ۳. چرا Write-through لزوماً به معنی تراکنش اتمیک SQL و کش نیست؟
 130: 
 131: ۴. کدام داده از Cache-aside سود کمی می‌گیرد: کلیدهای پرتکرار یا نتیجه منحصربه‌فرد هر درخواست؟ چرا؟
 132: 
 133: ۵. آیا commit سپس delete همه raceها را از بین می‌برد؟ یک ترتیب نقض‌کننده بنویسید.
 134: 
 135: ۶. در خطای کش چرا «همه درخواست‌ها مستقیم به منبع بروند» تصمیم کافی نیست؟
 136: 
 137: ### پاسخ تشریحی
 138: 
 139: ۱. مالک منطق miss است: caller در Cache-aside و abstraction/loader در Read-through. تعداد I/O واقعی باید همچنان سنجیده شود.
 140: 
 141: ۲. خیر؛ read و write دو قرارداد مستقل‌اند و می‌توانند ترکیب شوند. باید رفتار نوشتن و ابطال را جدا تعریف کرد.
 142: 
 143: ۳. منبع و کش ممکن است دو سامانه مستقل با شکست جزئی باشند؛ موفقیت یکی و شکست دیگری بدون هماهنگی اضافه ممکن است.
 144: 
 145: ۴. نتیجه یکتای هر درخواست؛ reuse کم است و lookup/fill سربار اضافه می‌کند.
 146: 
 147: ۵. خیر؛ A نسخه ۷ را می‌خواند، B نسخه ۸ را commit و delete می‌کند، سپس A نسخه ۷ را fill می‌کند. کنترل نسخه و طراحی هم‌زمانی لازم است.
 148: 
 149: ۶. چون بار miss ناگهانی ممکن است ظرفیت منبع را رد کند؛ سقف هم‌زمانی، deadline و رفتار خطا/کاهش خدمت باید مشخص باشند.
 150: 
 151: ## منابع پیشنهادی
 152: 
 153: - انگلیسی، معماری رسمی: [Microsoft Cache-aside pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside)، برای مسئولیت برنامه، تازگی و محدودیت سازگاری.
 154: - انگلیسی، راهنمای محصول: [AWS ElastiCache caching strategies](https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Strategies.html)، برای lazy loading، write-through و هزینه‌های آن‌ها؛ جزئیات محصول را از اصل الگو جدا کنید.
 155: - انگلیسی، تجربه مهندسی: [Scaling memcache at Facebook](https://engineering.fb.com/2013/04/15/core-infra/scaling-memcache-at-facebook/)، برای زمینه استفاده و الگوی بار.
 156: - فارسی، آموزش مکمل: [DevNA: راهنمای cache-aside، TTL و سیاست حذف](https://devna.ir/articles/redis-caching-guide)، برای مرور واژگان و نمونه برنامه؛ اعداد آزمایش آن مرجع ظرفیت سامانه شما نیستند.
 157: 
 158: [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [درس قبل: لایه‌ها](../01-cache-layers/README.md) · [درس بعد: کش چندسطحی](../03-multi-level-caching/README.md) · [مرتبط: مهلت و retry](../../06-code-optimization/07-timeouts-and-retries/README.md)
 159: 
 160: </div>

## Snapshot: Backend Performace/01-caching/03-multi-level-caching/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # ۰۱.۳ — کش چندسطحی و هماهنگی نسخه‌ها
   4: 
   5: **تاریخ بررسی منابع: ۲۰۲۶-۱۱-۱۰** · پیش‌نیاز: [الگوهای کش](../02-cache-patterns/README.md)، چند نمونه برنامه و تفاوت حافظه محلی و شبکه.
   6: 
   7: ## هدف یادگیری و تعریف
   8: 
   9: پس از این درس می‌توانید مسیر `L1 → L2 → source` را طراحی کنید، hit هر سطح را با مخرج درست حساب کنید و نشان دهید چرا پاک‌کردن کش مشترک، حافظه همه فرایندها را پاک نمی‌کند. **کش چندسطحی** یعنی چند محل reuse پشت سر هم با سرعت، اندازه و دامنه اشتراک متفاوت. در این درس L1 حافظه محلی برنامه و L2 کش مشترک روی شبکه است؛ این نام‌ها به کش سخت‌افزاری CPU اشاره ندارند.
  10: 
  11: لایه‌های HTTP و CDN در [درس لایه‌ها](../01-cache-layers/README.md) معرفی شدند. اینجا تمرکز بر حافظه محلی چند replica برنامه و کش داده مشترک است، نه انتخاب محل CDN.
  12: 
  13: ## مدل ذهنی و مراحل read
  14: 
  15: <div dir="ltr" align="left">
  16: 
  17: ```mermaid
  18: flowchart LR
  19:     A[Request on replica A] --> L1A[L1 in process A]
  20:     B[Request on replica B] --> L1B[L1 in process B]
  21:     L1A -->|miss| L2[Shared L2]
  22:     L1B -->|miss| L2
  23:     L2 -->|miss| D[Source database]
  24: ```
  25: 
  26: </div>
  27: 
  28: ۱. برنامه پس از کنترل دسترسی، ورودی L1 را همراه نسخه و deadline تازگی بررسی می‌کند.
  29: 
  30: ۲. در miss به L2 می‌رود؛ در hit داده را با **عمر باقی‌مانده** به L1 منتقل می‌کند.
  31: 
  32: ۳. اگر L2 نیز miss باشد، مسیر بارگذاری منبع با بودجه زمان و سقف هم‌زمانی اجرا می‌شود؛ نتیجه در لایه‌های مناسب قرار می‌گیرد.
  33: 
  34: ۴. با تغییر منبع، باید هم L2 و هم همه نسخه‌های L1 مرتبط ابطال یا به‌روز شوند؛ ترتیب commit و fillهای درحال اجرا نیز اهمیت دارد.
  35: 
  36: داشتن L1 می‌تواند تماس شبکه در hit را حذف کند. در مقابل، هر replica نسخه و مصرف حافظه خود را دارد؛ افزایش تعداد replicaها باعث تکثیر همان داده می‌شود. تجربه عملیاتی [Amazon درباره local و external cache](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) به ناسازگاری میان سرورها و cold start محلی اشاره می‌کند؛ این هزینه‌ها را قبل از اضافه‌کردن سطح دوم بسنجید.
  37: 
  38: ## trade-off و انتخاب دامنه
  39: 
  40: | انتخاب | مزیت محتمل | هزینه/شرط |
  41: | --- | --- | --- |
  42: | تنها L2 مشترک | یک محل مشترک برای reuse بین replicaها | هر read هنوز تماس شبکه دارد |
  43: | L1 کوچک + L2 | کاهش تماس‌های تکراری به L2 برای داده داغ | مصرف حافظه تکراری، ابطال و نسخه‌های محلی |
  44: | L1 کوتاه‌عمر بدون پیام | پیاده‌سازی ساده‌تر برای داده تحمل‌پذیر | پذیرفتن پنجره کهنگی؛ به معنی coherence قوی نیست |
  45: | L1 با پیام ابطال | واکنش سریع‌تر به تغییر در حالت سالم | تأخیر/گم‌شدن پیام و race با fill باید مدیریت شود |
  46: 
  47: برای هر request با نتیجه یکتا، L1 فقط هزینه نگهداری اضافه می‌کند. برای داده بسیار حساس به تغییر، حذف سطح محلی ممکن است از افزودن پروتکل هماهنگی بهتر باشد. افزایش hit را همراه سن داده و p95/p99 بسنجید؛ hit بیشتر با پاسخ کهنه موفقیت محصول نیست.
  48: 
  49: ## مثال حل‌شده: hit مشروط و عمر واقعی
  50: 
  51: **مدل آموزشی، نه نتیجه شرکت:** در ۱۰۰۰ درخواست، L1 برای ۸۰۰ مورد hit دارد. از ۲۰۰ درخواست باقی‌مانده، L2 برای ۱۵۰ مورد hit دارد. پس ۵۰ read به منبع می‌رسد.
  52: 
  53: <div dir="ltr" align="left">
  54: 
  55: ```text
  56: L1 hit ratio                  = 800 / 1000 = 0.80
  57: L2 conditional hit ratio      = 150 / 200  = 0.75
  58: Overall cache hit ratio       = (800 + 150) / 1000 = 0.95
  59: Source request fraction       = (1 - 0.80) * (1 - 0.75) = 0.05
  60: ```
  61: 
  62: </div>
  63: 
  64: نمی‌توان ۸۰٪ و ۷۵٪ را جمع کرد؛ مخرج آن‌ها متفاوت است. این مدل به read عادی بدون retry، refresh اضافی، coalescing یا خطا مربوط است. در سامانه واقعی تعداد queryها را مستقیم هم بشمارید؛ نرخ cache miss همیشه برابر نرخ query نیست.
  65: 
  66: حالا ورودی در زمان ۰ از منبع گرفته شده و `validUntil=60` دارد. replica B در ثانیه ۵۵ از L2 می‌خواند. اگر برای L1 دوباره TTL کامل ۶۰ ثانیه بگذارد، داده می‌تواند تا ثانیه ۱۱۵ در حافظه محلی باقی بماند، در حالی که بودجه مدل ۶۰ بود. قاعده نمونه درست این است:
  67: 
  68: <div dir="ltr" align="left">
  69: 
  70: ```text
  71: remaining = entry.validUntil - now
  72: if remaining <= 0:
  73:     doNotPromoteToL1()
  74: else:
  75:     localTtl = min(configuredL1Ttl, remaining)
  76:     putL1(entry.value, entry.version, localTtl)
  77: ```
  78: 
  79: </div>
  80: 
  81: برای پیاده‌سازی واقعی، زمان‌های absolute میان ماشین‌ها به همگامی ساعت و حاشیه اطمینان نیاز دارند؛ یا عمر باقی‌مانده را با احتساب زمان انتقال منتشر کنید. expiry کش، سن نسخه پایگاه داده را به‌تنهایی ثابت نمی‌کند: ممکن است منبع خواندن replica عقب‌مانده باشد. قاعده بالا فقط جلوی تمدید ناخواسته عمر در زنجیره این مثال را می‌گیرد.
  82: 
  83: ## ابطال بین replicaها و قطع ارتباط
  84: 
  85: پس از تغییر منبع، حذف L2 برای A و B پیام خودکار نیست. می‌توان رخداد `product:42 changed to version 8` منتشر کرد و همه L1ها را پاک کرد. در Redis Pub/Sub تحویل **at-most-once** است؛ مشترکی که هنگام پیام قطع بوده، آن را بعداً بازپخش نمی‌گیرد. بنابراین صرف استفاده از Pub/Sub تضمین دریافت همه ابطال‌ها نیست. [مستند رسمی semantics](https://redis.io/docs/latest/develop/pubsub/#delivery-semantics).
  86: 
  87: برای طرحی که کهنگی محدود می‌خواهد، TTL پشتیبان، پاک‌کردن L1 هنگام reconnect و تشخیص شکاف ارتباط را تعریف کنید. برای تحویل قابل بازپخش، باید سامانه رخداد دارای نگهداری، cursor و جبران را طراحی کنید؛ فقط تغییر نام broker کافی نیست. حتی با پیام سالم، fill قدیمی ممکن است بعد از رسیدن ابطال تمام شود. نسخه/نسل محلی و کنترل انتشار fill باید مانع بازگشت نسخه قدیمی شود، یا باید این پنجره را صریحاً بپذیرید.
  88: 
  89: ## تمرین کوچک و مشاهده مورد انتظار
  90: 
  91: بدون ابزار هم می‌توانید دو جدول `L1-A` و `L1-B` و یک جدول `L2` بسازید:
  92: 
  93: ۱. همه را با نسخه ۷ پر کنید؛ A و B هر کدام read دارند.
  94: 
  95: ۲. منبع را نسخه ۸ کنید، L2 را پاک کنید و تنها L1-A را پاک کنید.
  96: 
  97: ۳. یک read به A و یک read به B بفرستید. بعد عمر L1-B را تمام کنید و دوباره بخوانید.
  98: 
  99: ۴. حالت پیام ابطال را اضافه کنید ولی B را هنگام ارسال قطع فرض کنید؛ پس از reconnect ابتدا L1 آن را پاک کنید.
 100: 
 101: ۵. نمونه محاسبه hit را با L1 برابر ۶۰۰ از ۱۰۰۰ و L2 برابر ۳۲۰ از ۴۰۰ تکرار کنید.
 102: 
 103: **انتظار:** در مرحله دوم B هنوز می‌تواند نسخه ۷ بدهد؛ load balancer ممکن است کاربر را بین نسخه‌ها جابه‌جا کند. reconnect همراه flush، امکان reuse نسخه محلی نامطمئن را می‌گیرد ولی بار warm-up ایجاد می‌کند. در مرحله پنجم overall hit برابر ۹۲٪ و read منبع ۸۰ است. این تمرین به‌تنهایی اثبات coherence خطی‌پذیر نیست.
 104: 
 105: ## شاهد عمومی: کش محلی با کمک سرور Redis
 106: 
 107: > **مستند عملیاتی رسمی، بدون ادعای benchmark:** [Redis client-side caching](https://redis.io/docs/latest/develop/clients/client-side-caching/) طرحی واقعی از حافظه کلاینت کنار سرور Redis را توضیح می‌دهد: سرور کلیدهای خوانده‌شده را track می‌کند و با تغییرشان invalidation می‌فرستد؛ کلاینت ورودی نامعتبر را کنار می‌گذارد. همان مستند به رفتار پاک‌سازی کش در قطع connection و لزوم پشتیبانی کتابخانه اشاره می‌کند. این «کلاینت» می‌تواند کتابخانه داخل backend باشد، نه مرورگر کاربر. این شاهد سازوکار L1 نزدیک مصرف‌کننده است؛ جای ابطال SQL به Redis یا تضمین همه حالت‌های هم‌زمانی برنامه شما را نمی‌گیرد.
 108: 
 109: قبل از فعال‌کردن این قابلیت، نسخه Redis، پروتکل، کتابخانه و رفتار connection pool خود را با مستند همان نسخه بررسی کنید؛ پشتیبانی یک فرمان به‌تنهایی معادل پشتیبانی کامل client-side caching نیست.
 110: 
 111: ## شکست‌ها و سیگنال‌های عملیاتی
 112: 
 113: | شکست | نشانه | چه چیزی بررسی شود؟ |
 114: | --- | --- | --- |
 115: | بازگشت داده قدیمی در یک replica | اختلاف نسخه در پاسخ‌های متوالی | نسخه پاسخ به همراه شناسه replica، بدون ثبت اطلاعات حساس |
 116: | L1 بدون سقف اندازه | رشد heap، فشار GC یا OOM | اندازه/تعداد ورودی، محدودیت حافظه و eviction محلی |
 117: | rollout هم‌زمان همه replicaها | جهش miss و ترافیک L2/منبع | rollout تدریجی، ظرفیت cold start و coalescing |
 118: | تمدید عمر در promotion | سن داده بیشتر از بودجه محصول | metadata عمر اولیه و باقی‌مانده |
 119: | گم‌شدن ابطال | اختلاف پایدار پس از reconnect | شکاف پیام، flush و مسیر جبران |
 120: 
 121: ## چک‌لیست عملیاتی
 122: 
 123: - [ ] دلیل قابل اندازه‌گیری برای اضافه‌کردن L1 وجود دارد.
 124: - [ ] L1 و L2 هرکدام سقف اندازه، سیاست eviction و TTL دارند.
 125: - [ ] hit ratioها با مخرج جدا و نرخ واقعی دسترسی منبع گزارش می‌شوند.
 126: - [ ] نسخه و عمر با عبور بین سطح‌ها بی‌دلیل تمدید نمی‌شوند.
 127: - [ ] همه replicaها و writerها در طرح ابطال دیده شده‌اند.
 128: - [ ] قطع ارتباط، reconnect و fill قدیمی هم‌زمان با ابطال بررسی شده‌اند.
 129: - [ ] cold start و از دست رفتن L2 به burst نامحدود منبع تبدیل نمی‌شود.
 130: - [ ] نمونه‌برداری سن/نسخه داده کنار تأخیر انجام می‌شود.
 131: 
 132: ## آزمون
 133: 
 134: ۱. L1 و L2 در این درس به چه محل‌هایی اشاره دارند؟
 135: 
 136: ۲. چرا حذف کلید L2، کلید L1-B را الزاماً حذف نمی‌کند؟
 137: 
 138: ۳. اگر L1 hit برابر ۶۰٪ و L2 hit مشروط برابر ۸۰٪ باشد، چند درصد درخواست‌ها به منبع می‌رسند؟
 139: 
 140: ۴. چرا انتقال ورودی در ثانیه ۵۵ با TTL تازه ۶۰ می‌تواند غلط باشد؟
 141: 
 142: ۵. آیا Pub/Sub عادی Redis پیام قطع‌شده را بعد از reconnect بازپخش می‌کند؟
 143: 
 144: ۶. آیا TTL کوتاه‌تر L1 تضمین می‌کند هیچ پاسخ کهنه‌ای تولید نشود؟
 145: 
 146: ### پاسخ تشریحی
 147: 
 148: ۱. حافظه محلی هر فرایند و کش مشترک روی شبکه؛ این‌ها در این متن نام کش CPU نیستند.
 149: 
 150: ۲. حافظه فرایند B جداست؛ بدون پیام، expiration یا قرارداد دیگر از حذف L2 خبردار نمی‌شود.
 151: 
 152: ۳. `0.40 × 0.20 = 0.08` یا ۸٪؛ overall hit برابر ۹۲٪ است. L2 فقط درخواست‌های عبورکرده از L1 را می‌بیند.
 153: 
 154: ۴. چون ۵ ثانیه از عمر تعیین‌شده باقی مانده است؛ TTL جدید می‌تواند عمر داده را تا ۱۱۵ تمدید کند. باید از باقی‌مانده و سقف L1 استفاده شود.
 155: 
 156: ۵. خیر؛ at-most-once است. برای نسخه‌های نامطمئن باید flush، TTL یا طرح قابل بازپخش/جبران داشت.
 157: 
 158: ۶. خیر؛ فقط پنجره reuse را تحت فرض‌های مشخص کم می‌کند. منبع عقب‌مانده، fill قدیمی یا تأخیر ابطال همچنان مسئله‌اند.
 159: 
 160: ## منابع پیشنهادی
 161: 
 162: - انگلیسی، مستند اصلی: [Redis client-side caching](https://redis.io/docs/latest/develop/clients/client-side-caching/)، برای tracking، ابطال، قطع ارتباط و سازگاری کلاینت.
 163: - انگلیسی، قرارداد تحویل: [Redis Pub/Sub](https://redis.io/docs/latest/develop/pubsub/)، برای دیدن محدودیت at-most-once.
 164: - انگلیسی، تجربه عملیاتی: [Amazon caching challenges](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/)، بخش local و external caches برای فهم چندنسخه‌ای و cold start.
 165: - فارسی، پیش‌نیاز مرتبط: [نت پارادیس: Redis، الگوهای کش و انقضا](https://netparadis.com/redis-data-types-caching-strategy/)، برای مرور کش مشترک و TTL با مثال Node.js. این منبع آموزش کامل پروتکل L1/L2 نیست؛ در منابع فارسی قابل خواندن این بررسی، مرجع مستقلی با پوشش تمام حالت‌های قطع ارتباط و fill هم‌زمان پیدا نشد. توضیح فارسی همین درس و مستند رسمی Redis مرجع این بخش‌اند.
 166: 
 167: [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [درس قبل: الگوها](../02-cache-patterns/README.md) · [درس بعد: ابطال و تازگی](../04-invalidation-and-freshness/README.md) · [مرتبط: load balancing](../../05-load-balancing-and-scaling/02-load-balancing/README.md)
 168: 
 169: </div>

## Snapshot: Backend Performace/01-caching/04-invalidation-and-freshness/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # ۰۱.۴ — ابطال، تازگی، TTL و جلوگیری از Cache Stampede
   4: 
   5: **تاریخ بررسی منابع: ۲۰۲۶-۱۱-۱۰** · پیش‌نیاز: [Cache-aside](../02-cache-patterns/README.md)، [کش چندسطحی](../03-multi-level-caching/README.md)، deadline و هم‌زمانی.
   6: 
   7: ## هدف یادگیری و تعریف
   8: 
   9: پس از این درس می‌توانید بودجه کهنگی را از زمان نگهداری فیزیکی جدا کنید، TTL و ابطال رخدادمحور را ترکیب کنید و هجوم readهای هم‌زمان پس از انقضا را محدود کنید. **Freshness** یعنی نتیجه در محدوده قرارداد تازگی محصول باشد؛ **invalidation** اعلام بی‌اعتباری نسخه؛ **TTL** مدت نگهداری/اعتبار تعیین‌شده در قرارداد کش است. معنی TTL در یک کش key/value با تازگی پاسخ HTTP کاملاً یکسان نیست و باید در طراحی روشن شود.
  10: 
  11: ## مدل ذهنی: سه ساعت و چهار رویداد
  12: 
  13: برای یک ورودی، `sourceVersion` یا زمان تغییر منبع، `fetchedAt` و deadline استفاده از نسخه را از هم جدا کنید. اگر اکنون از یک read replica عقب‌مانده داده گرفته‌اید، `fetchedAt=now` ثابت نمی‌کند داده تازه‌ترین commit است. همچنین «هنوز در حافظه وجود دارد» معادل «اجازه مصرف دارد» نیست.
  14: 
  15: | رویداد | چه تغییری می‌کند؟ | معنای درست |
  16: | --- | --- | --- |
  17: | expiration | عمر تعیین‌شده تمام می‌شود | read بعدی ممکن است miss یا نیازمند refresh باشد |
  18: | eviction | حافظه تحت سیاست ظرفیت آزاد می‌شود | می‌تواند پیش از TTL رخ دهد |
  19: | invalidation | نسخه مشخص یا مجموعه وابسته نامعتبر می‌شود | معمولاً پس از تغییر منبع یا انتشار محتوا |
  20: | refresh | داده دوباره از منبع تهیه/اعتبارسنجی می‌شود | موفقیت، خطا و هزینه آن باید دیده شود |
  21: 
  22: Redis TTL را از طریق فرمان‌هایی مانند [EXPIRE](https://redis.io/docs/latest/commands/expire/) فراهم می‌کند؛ سیاست حافظه و [eviction](https://redis.io/docs/latest/develop/reference/eviction/) موضوع جداست. TTL طولانی تضمین نمی‌کند ورودی تا آن زمان در حافظه بماند. در Redis می‌توان با `SET ... EX ...` مقدار و انقضا را در یک فرمان تعیین کرد؛ دو فرمان جدا، فاصله شکست دارند. بازنویسی عادی با `SET` هم می‌تواند TTL قبلی را از بین ببرد؛ گزینه‌ها را از [مستند SET](https://redis.io/docs/latest/commands/set/) بررسی کنید.
  23: 
  24: ## انتخاب سیاست تازگی و ابطال
  25: 
  26: ۱. **از محصول بپرسید:** آیا توضیح کالا می‌تواند چند ثانیه قدیمی باشد؟ آیا مجوز لغوشده یا قیمت قطعی چنین فرصتی دارد؟ برای هر دسته قرارداد جدا بنویسید.
  27: 
  28: ۲. **کلیدهای وابسته را پیدا کنید:** تغییر کالا ممکن است کلید کالا، فهرست دسته و نتیجه جست‌وجو را تحت تأثیر قرار دهد. delete یک کلید همه آن‌ها را اصلاح نمی‌کند.
  29: 
  30: ۳. **مسیر تغییر را تعریف کنید:** commit منبع، ثبت قابل اتکای رخداد تغییر در صورت نیاز، و سپس ابطال/refresh. رخداد پیش از commit می‌تواند موجب fill از نسخه قبلی شود.
  31: 
  32: ۴. **برای شکست برنامه داشته باشید:** TTL پشتیبان، retry محدود، ثبت lag ابطال و جلوگیری از fill قدیمی. outbox می‌تواند رخداد را با commit هماهنگ کند، ولی مصرف‌کننده و retry آن نیز باید طراحی شوند.
  33: 
  34: | سیاست | مناسب‌تر برای | هزینه/محدودیت |
  35: | --- | --- | --- |
  36: | فقط TTL | داده با کهنگی قابل تحمل و writerهای ساده | تا انقضا امکان دیدن نسخه قدیمی هست |
  37: | ابطال پس از write + TTL | داده پرتغییر با نیاز به واکنش سریع‌تر | پیام/حذف می‌تواند شکست بخورد؛ وابستگی کلیدها مهم است |
  38: | کلید/URL نسخه‌دار | asset یا snapshot تغییرناپذیر | مصرف‌کننده باید نسخه جدید را پیدا کند؛ نسخه قدیمی باید جمع شود |
  39: | soft expiry و refresh پس‌زمینه | نمایش داده‌ای که stale محدود را می‌پذیرد | stale باید سقف مشخص داشته باشد؛ برای هر داده‌ای مجاز نیست |
  40: | خواندن معتبر در مسیر حساس | تصمیمی که کهنگی برایش پذیرفتنی نیست | هزینه منبع و تراکنش بیشتر؛ کش نمایشی جدا بررسی می‌شود |
  41: 
  42: این انتخاب‌ها trade-off هستند. TTL صفر یا بسیار کوتاه ممکن است تقریباً تمام بار را به منبع برگرداند؛ TTL بلند می‌تواند hit خوب و تجربه غلط تولید کند.
  43: 
  44: ## Stampede چیست و چگونه محدود می‌شود؟
  45: 
  46: اگر ورودی یک کلید محبوب منقضی شود و چندین درخواست هم‌زمان همگی loader را اجرا کنند، کش به‌جای حذف کار تکراری آن را تکثیر کرده است. به این وضعیت Cache Stampede می‌گوییم. انقضای هم‌زمان کلیدهای فراوان یا restart همه replicaها نیز می‌تواند موج miss ایجاد کند.
  47: 
  48: - **Request coalescing / singleflight:** درخواست‌های هم‌زمان یک کلید، یک بارگذاری درحال اجرا را شریک می‌شوند. این کار با lock سراسری روی همه کلیدها فرق دارد و انتظار followers باید deadline داشته باشد.
  49: - **TTL jitter:** زمان انقضای کلیدهای مختلف را پخش کنید. اگر بودجه تازگی حداکثر ۳۰ ثانیه است، نمونه `random(24,30)` آن را رد نمی‌کند؛ افزودن jitter مثبت تا ۴۰ ثانیه قرارداد را عوض می‌کند. jitter به‌تنهایی stampede یک hot key را متوقف نمی‌کند.
  50: - **Soft expiry:** داده تا `freshUntil` تازه است؛ تا `staleUntil` فقط در صورت مجاز بودن stale، پاسخ قبلی ارائه و یک refresh آغاز می‌شود. بعد از سقف، منتظر refresh محدود می‌مانیم یا خطای کنترل‌شده می‌دهیم.
  51: - **حد ظرفیت منبع:** concurrency limit و deadline برای بارگذاری، حتی اگر کش قطع باشد. refresh پس‌زمینه هم مصرف‌کننده همین ظرفیت است.
  52: 
  53: تجربه عملیاتی [Amazon درباره request coalescing و رفتار کش سرد](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) پشتوانه خوبی برای این انتخاب‌هاست. coalescing محلی در ده replica می‌تواند تا ده بارگذاری هم‌زمان ایجاد کند؛ اگر این مقدار زیاد است، هماهنگی بین replicaها یا روش دیگری لازم است.
  54: 
  55: ## مثال حل‌شده: soft و hard deadline برای یک توضیح عمومی
  56: 
  57: **سناریوی آموزشی، نه تنظیم توصیه‌شده برای همه سرویس‌ها:** شرح عمومی کالا از منبع معتبر در `t=0` گرفته می‌شود. محصول ۳۰ ثانیه reuse تازه و حداکثر ۱۵ ثانیه stale اضافه هنگام refresh را می‌پذیرد. این قرارداد را برای قیمت نهایی یا مجوز دسترسی استفاده نکرده‌ایم.
  58: 
  59: <div dir="ltr" align="left">
  60: 
  61: ```text
  62: entry = { value, sourceVersion, freshUntil: 30, staleUntil: 45 }
  63: 
  64: function getDescription(key, requestDeadline):
  65:     entry = cache.getEnvelope(key)
  66:     if entry.exists and now < entry.freshUntil:
  67:         return entry.value
  68:     if entry.exists and now < entry.staleUntil:
  69:         startRefreshOncePerKey(key)  # bounded, shared inside this process
  70:         return entry.value         # allowed stale, counted separately
  71:     return awaitLoadOncePerKey(key, requestDeadline)
  72:     # If load fails or deadline expires: return a defined error/degraded result.
  73: ```
  74: 
  75: </div>
  76: 
  77: در `t=32` بیست read هم‌زمان داخل **یک فرایند** می‌توانند نسخه قبلی را فوری بگیرند و یک refresh داشته باشند. اگر refresh در `t=34` موفق شود، envelope جدید از داده معتبر ساخته می‌شود. اگر refreshها شکست بخورند، در `t=46` دیگر اجازه ارائه همان نسخه به استناد این قرارداد نداریم؛ باید انتظار محدود یا خطای تعریف‌شده داشته باشیم. `staleUntil` با هر خطای refresh تمدید نمی‌شود. برای آنکه داده stale قابل ارائه باشد، مقدار باید تا hard deadline در storage باقی بماند؛ حذف فیزیکی در soft expiry این امکان را از بین می‌برد.
  78: 
  79: در HTTP، مفهوم نزدیک با `Cache-Control: max-age=30, stale-while-revalidate=15` بیان می‌شود؛ پشتیبانی و سایر دستورهای پاسخ باید بررسی شوند. هدر HTTP به‌خودی‌خود منطق `startRefreshOncePerKey` کش داخلی را نمی‌سازد. تعریف این extension و `stale-if-error` در [RFC 5861](https://www.rfc-editor.org/rfc/rfc5861.html) است؛ دو پنجره مستقل را با «اجازه stale برای همیشه» اشتباه نگیرید.
  80: 
  81: ## race و lease: چرا یک قفل کافی نیست؟
  82: 
  83: خواننده A نسخه ۷ را می‌خواند، نویسنده B نسخه ۸ را commit و کش را باطل می‌کند، سپس A نسخه ۷ را fill می‌کند. TTL اثر را محدود می‌کند اما نقض را حذف نمی‌کند. یکی از راه‌های طراحی، نسل/نسخه قابل مقایسه همراه داده و کنترل اتمیک مجوز fill است. بررسی نسخه و سپس نوشتن در دو عمل مستقل دوباره race دارد؛ حذف کلید هم می‌تواند اطلاعات نسخه لازم برای رد fill قدیمی را حذف کند. این بخش نیازمند قرارداد مشخص writer و storage است، نه صرف افزودن فیلد `version` به JSON.
  84: 
  85: برای coalescing بین replicaها ممکن است lease محدود به زمان بگیرید. `SET lock:key token NX PX ...` یک primitive است، نه اثبات کامل هماهنگی: مالک باید token یکتا داشته باشد، آزادسازی باید به‌صورت اتمیک فقط با token همان مالک انجام شود، و loader قدیمی پس از پایان lease نباید بتواند روی داده جدید overwrite کند. توقف طولانی process و failover را هم در نظر بگیرید. [مستند Redis درباره distributed locks](https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/) فرض‌ها و مرزها را شرح می‌دهد؛ برای کاهش بار کش از کتابخانه/طرح بررسی‌شده استفاده کنید و قفل را جای تضمین صحت تراکنش تجاری نگذارید.
  86: 
  87: ## تمرین کوچک و مشاهده مورد انتظار
  88: 
  89: ۱. روی خط زمان `0, 29, 32, 44, 46` بنویسید پاسخ تازه، stale مجاز یا نیازمند بارگذاری است. فرض کنید refresh همواره شکست می‌خورد.
  90: 
  91: ۲. بیست read در `t=32` یک فرایند را یک بار با coalescing و یک بار بدون آن تحلیل کنید.
  92: 
  93: ۳. همین بیست درخواست را میان پنج replica بدون هماهنگی مشترک پخش کنید.
  94: 
  95: ۴. برای ۱۰۰ کلید که همگی در `t=0` پر شده‌اند، TTL ثابت ۳۰ را با TTL انتخاب‌شده از ۲۴ تا ۳۰ مقایسه کنید. درباره **یک** کلید بسیار محبوب جدا نتیجه بگیرید.
  96: 
  97: **انتظار:** در ۲۹ تازه، در ۳۲ و ۴۴ stale مجاز و در ۴۶ خارج از پنجره است. در یک فرایند با coalescing یک refresh کافی است؛ بدون آن تا ۲۰ loader ممکن است اجرا شود. در پنج replica، coalescing محلی تا پنج refresh را مجاز می‌گذارد. jitter موج انقضای کلیدهای مختلف را پخش می‌کند ولی بار هم‌زمان یک hot key را تجمیع نمی‌کند. این‌ها شمارش مسیر در مدل‌اند، نه اندازه‌گیری تولید.
  98: 
  99: ## تجربه عمومی مستند: TTL متناسب با زمان داده در Netflix
 100: 
 101: > [Netflix TechBlog، ۶ آوریل ۲۰۲۶](https://netflixtechblog.com/stop-answering-the-same-question-twice-interval-aware-caching-for-druid-at-netflix-scale-22fadc9b840e) یک لایه **آزمایشی** interval-aware برای queryهای Druid داشبوردها را شرح می‌دهد. تیم برای تازه‌ترین داده، کهنگی محدود پنج‌ثانیه‌ای را آگاهانه پذیرفته و برای بازه‌های قدیمی‌تر TTL بلندتر در نظر گرفته است؛ late-arriving events در این انتخاب نقش دارند. شاهد مربوط به داشبوردهای همان محیط است، نه قاعده‌ای برای پرداخت یا مجوز دسترسی. نتیجه آموزشی: TTL باید با معنای زمان و تحمل مصرف‌کننده هماهنگ باشد؛ عددهای آن گزارش را بدون بررسی به سامانه دیگر منتقل نکنید.
 102: 
 103: ## failure mode و سیگنال عملیاتی
 104: 
 105: | شکست | نشانه | اقدام بررسی |
 106: | --- | --- | --- |
 107: | موج انقضا | جهش miss، loader concurrency و p99 | پراکندگی expiry، coalescing و محدودیت منبع |
 108: | stale بی‌پایان | سن داده رشد می‌کند ولی hit بالا می‌ماند | hard deadline، شمارنده stale و آخرین refresh موفق |
 109: | ابطال عقب‌افتاده | lag رخداد و اختلاف version | مسیر commit/انتشار/مصرف و retry |
 110: | cache error به‌عنوان not-found | نبود جعلی داده پس از timeout | تمایز خطا، miss و نبود قطعی |
 111: | eviction قبل از TTL | افزایش miss در فشار حافظه | اندازه working set و سیاست eviction |
 112: | lease منقضی و fill دیررس | برگشت نسخه قدیمی پس از refresh جدید | token، کنترل نسل و رد write قدیمی |
 113: 
 114: ## چک‌لیست عملیاتی
 115: 
 116: - [ ] بودجه تازگی هر نوع داده و اجازه stale جدا و صریح است.
 117: - [ ] سن داده، source version و زمان آخرین refresh موفق قابل مشاهده‌اند.
 118: - [ ] TTL، soft deadline و نگهداری فیزیکی با هم سازگارند.
 119: - [ ] کلیدهای مستقیم و مشتق‌شده در ابطال دیده شده‌اند.
 120: - [ ] خطای delete/انتشار رخداد بعد از commit مسیر جبران دارد.
 121: - [ ] بارگذاری هم‌زمان یک کلید و انقضای جمعی کلیدها جدا بررسی شده‌اند.
 122: - [ ] jitter از حداکثر کهنگی مجاز فراتر نمی‌رود.
 123: - [ ] coalescing، deadline، سقف concurrency و رفتار پس از hard expiry مشخص‌اند.
 124: - [ ] خرابی کش، قطع پیام و loader دیررس با مدل شکست طراحی شده‌اند.
 125: 
 126: ## آزمون
 127: 
 128: ۱. تفاوت expiration و eviction چیست؟
 129: 
 130: ۲. چرا `fetchedAt=now` ثابت نمی‌کند داده تازه‌ترین commit منبع است؟
 131: 
 132: ۳. آیا TTL برابر ۳۰ با jitter مثبت ۱۵ همچنان سقف ۳۰ ثانیه را حفظ می‌کند؟
 133: 
 134: ۴. در مثال، اگر refresh هر بار شکست بخورد آیا در `t=46` همان نسخه مجاز است؟
 135: 
 136: ۵. singleflight محلی در پنج replica الزاماً چند loader مشترک بین همه ایجاد می‌کند؟
 137: 
 138: ۶. چرا آزادسازی lock با `DEL` بدون بررسی token خطر دارد؟
 139: 
 140: ۷. افزودن `version` به مقدار بدون کنترل اتمیک fill چه مشکلی را حل نمی‌کند؟
 141: 
 142: ### پاسخ تشریحی
 143: 
 144: ۱. expiration از عمر ورودی می‌آید و eviction از سیاست حافظه/ظرفیت؛ دومی می‌تواند زودتر رخ دهد. تضمین حضور تا پایان TTL نداریم.
 145: 
 146: ۲. شاید منبع خواندن عقب‌مانده باشد؛ زمان fetch، سن یا نسخه واقعی منبع را به‌تنهایی اثبات نمی‌کند.
 147: 
 148: ۳. خیر؛ زمان استفاده ممکن است تا ۴۵ برسد. برای سقف ۳۰، دامنه jitter باید درون همان سقف بماند یا قرارداد محصول صریحاً تغییر کند.
 149: 
 150: ۴. خیر؛ hard deadline برابر ۴۵ است. تمدید خودکار در هر شکست، stale را نامحدود می‌کند و خلاف قرارداد مثال است.
 151: 
 152: ۵. الزاماً یکی نیست؛ تا یک loader در هر replica، یعنی پنج تا، ممکن است داشته باشیم. هماهنگی بین replicaها قرارداد دیگری لازم دارد.
 153: 
 154: ۶. ممکن است lease قبلی تمام شده و مالک جدید lock را گرفته باشد؛ مالک قدیمی با DEL قفل دیگری را حذف می‌کند. بررسی مالکیت و حذف باید اتمیک باشند.
 155: 
 156: ۷. race میان بررسی نسخه و نوشتن باقی می‌ماند؛ fill قدیمی می‌تواند بعد از ابطال/نسخه جدید برگردد. باید مجوز انتشار نتیجه و رفتار writerها واقعاً هماهنگ شوند.
 157: 
 158: ## منابع پیشنهادی
 159: 
 160: - انگلیسی، مستند رسمی: [Redis EXPIRE](https://redis.io/docs/latest/commands/expire/)، [SET](https://redis.io/docs/latest/commands/set/) و [Key eviction](https://redis.io/docs/latest/develop/reference/eviction/)، برای معنای دقیق انقضا و ظرفیت.
 161: - انگلیسی، قرارداد HTTP: [RFC 5861](https://www.rfc-editor.org/rfc/rfc5861.html)، برای stale-while-revalidate و stale-if-error؛ این RFC از نوع Informational است و پشتیبانی محصول باید جدا بررسی شود.
 162: - انگلیسی، طراحی هماهنگی: [Redis distributed locks](https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/)، برای token، lease و فرض‌های ایمنی.
 163: - انگلیسی، شواهد مهندسی: [Amazon caching challenges](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/) و [Netflix interval-aware caching](https://netflixtechblog.com/stop-answering-the-same-question-twice-interval-aware-caching-for-druid-at-netflix-scale-22fadc9b840e)، برای cold cache، coalescing و انتخاب تازگی وابسته به داده.
 164: - فارسی، مرور آموزشی: [نت پارادیس: TTL، ابطال و Cache Stampede](https://netparadis.com/redis-data-types-caching-strategy/)، برای آشنایی واژگان و مثال؛ کد نمونه را جای طرح کامل هماهنگی توزیع‌شده نگذارید.
 165: 
 166: [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [درس قبل: کش چندسطحی](../03-multi-level-caching/README.md) · [مرتبط: کار پس‌زمینه](../../03-asynchronism/01-background-jobs/README.md) · [مرتبط: پایش](../../07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) · [مرتبط: آزمون عملکرد](../../09-performance-testing/01-load-testing-and-regression-benchmarks/README.md)
 167: 
 168: </div>
