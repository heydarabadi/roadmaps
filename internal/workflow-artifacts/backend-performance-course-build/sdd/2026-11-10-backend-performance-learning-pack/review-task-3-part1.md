# Read-only Task 3 review supplement

## Implementer report

# Task 3 report — Chapter 02: API Response

Status: complete within the assigned chapter scope. Research verification date: 2026-11-10.

## Files created

- `D:\Learn\Roadmap\Backend Performace\02-api-response\README.md`
- `D:\Learn\Roadmap\Backend Performace\02-api-response\01-payload-size\README.md`
- `D:\Learn\Roadmap\Backend Performace\02-api-response\02-response-compression\README.md`
- `D:\Learn\Roadmap\Backend Performace\02-api-response\03-efficient-pagination\README.md`
- `D:\Learn\Roadmap\Backend Performace\02-api-response\04-avoid-unnecessary-server-work\README.md`

Only Chapter 02 content and this requested report were written. No Git repository was initialized and no commits were created. No subagents were dispatched.

## Coverage and authoring decisions

The chapter index contains prerequisites, outcomes, ordered navigation to all four topics, a shared hypothetical order-list scenario, a chapter review checklist, related-chapter links, and curated sources.

All four topic pages contain learning outcomes, a self-contained Persian explanation, trade-offs and poor-fit cases, language-neutral worked examples, a small exercise with expected observations, an explicitly labeled real-world operational evidence section, failure modes and signals, an operational checklist, six quiz questions with explained answers, Persian/English reading links, research date, and parent/chapter/related-topic navigation. Persian prose is wrapped in RTL/right-aligned HTML; copyable code/HTTP/PowerShell examples are wrapped in LTR/left-aligned HTML.

Specific coverage:

- Payload: summary/detail contracts, field selection, item and byte budgets, oversized single items, expand limits, serialized versus wire bytes, quota versus user-experience budget, private attachment handling, compatibility, and why HTTP 413 describes request content rather than a generic oversized response.
- Compression: negotiation using Accept-Encoding/Content-Encoding/Vary, Content-Type, byte accounting, CPU and tail-latency costs, layer ownership, proxy/CDN recompression, sensitive dynamic responses, buffering/streaming implications, and a curl.exe exercise preserving raw transfer bytes.
- Pagination: public API contract versus database Query execution; page/offset/cursor trade-offs; bounded sizes; deterministic ordering/tie-breaker; token opacity, validation, scope and independent authorization; short/empty pages with continuation; mutation/snapshot limits; counts; and why API pagination does not prove an efficient database query.
- Unnecessary work: early projection and query planning, avoiding unused dependencies, request-scope reuse, preserving business/security obligations, conditional GET, cheap versus late ETag generation, revision dependencies, concurrent data changes, and counters/traces that distinguish real skipped work from merely hidden output.

Pagination deliberately cross-links the database pagination guide rather than repeating SQL, index and execution-plan lessons. Payload, compression, caching and processing optimization are linked but each page explains its own layer.

## Sources researched and used

The Firecrawl connector initially returned `requires a non-empty string link_id argument`. The parent confirmed that the connected account was out of credits and directed use of the built-in web tools. Subsequent research used web search/open/find. No Firecrawl credit purchase or account change was attempted.

Primary/authoritative sources read or inspected for the included claims:

- [MDN Compression in HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression): encoding negotiation, Vary and already compressed formats.
- [MDN Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding) and [Content-Length](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Length): representation and size semantics.
- [MDN HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching), [ETag](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/ETag) and [If-None-Match](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/If-None-Match): validators, 304, private/no-cache policy, weak comparison and proper conditional response handling.
- [MDN 413](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/413): request-content limit semantics.
- [Google API design guide](https://docs.cloud.google.com/apis/design) and [AIP-158](https://google.aip.dev/158): bounded collection contracts, token semantics, authorization and compatibility.
- [Google Drive fields parameter](https://developers.google.com/workspace/drive/api/guides/fields-parameter): production API field selection and limited default field sets.
- [AWS HTTP API quotas](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-quotas.html): scoped example of a hard infrastructure payload quota; not generalized to other API types/streaming.
- [Cloudflare Content compression](https://developers.cloudflare.com/speed/optimization/content/compression/): independent origin/client legs and recompression in a real service.
- [Django REST framework pagination](https://www.django-rest-framework.org/api-guide/pagination/): page/offset/cursor variants and suitable ordering.
- [GitHub pagination](https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api): Link-based continuation in a real API.
- [WordPress pagination](https://developer.wordpress.org/rest-api/using-the-rest-api/pagination/): a real API's page-size cap.
- [WordPress Global Parameters](https://developer.wordpress.org/rest-api/using-the-rest-api/global-parameters/): `_fields` avoids unnecessary internal computation/queries while generating a response.
- [GitHub REST best practices](https://docs.github.com/en/rest/using-the-rest-api/best-practices-for-using-the-rest-api): conditional GET, stable/specific requests and the authorization condition for GitHub's primary-rate-limit exception.
- [Microsoft performance-efficiency guidance](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure): measured reduction of unnecessary work.
- [Microsoft response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0): compression cost and dynamic HTTPS response considerations.

Persian sources checked for direct relevance:

- [Net Paradis REST design, pagination, filtering and versioning](https://netparadis.com/rest-design-pagination-filtering-versioning/): used as a supplemental Persian reference for payload fields, pagination and request specificity.
- [mehdiMj Nginx compression/static-cache lesson](https://mehdimj.ir/blog/2026/10/08/nginx-night-16-static-cache-compression/): a concise Persian header/MIME/compression exercise, with its static-file scope clearly stated.

No article was reproduced wholesale. All numeric teaching budgets and timing calculations are explicitly hypothetical, not published company benchmarks. Real-world sections use permitted authoritative operational documentation and disclose that a directly comparable incident/percentage improvement is not established. The server-work page explicitly notes the lack of a comparably direct Persian article about early internal field projection, rather than presenting an unrelated reference as proof.

## Inspection results

One-line check summary: 5/5 assigned README files present; 21/21 within-chapter relative-link occurrences resolve; 4 quizzes each contain 6 questions and 6 explained answers; code fences and RTL/LTR div boundaries balance; all four requested subjects meet the topic-page contract.

Manual content review included the arithmetic in the payload/compression examples, the offset-versus-cursor exercise result (`6,5,4` versus `5,4,3`), the caveat that cursor does not guarantee a snapshot, the request meaning of HTTP 413, absence of a response body in 304, authorization before conditional early return, the risk of hashing a fully built body too late to save CPU, and consistency of quiz answers with the lesson text.

PowerShell read-only document inspection enumerated files, resolved relative links and counted code fences/div boundaries and question/answer entries. This is documentation inspection, not software test execution. No lab/benchmark commands were run against a live service; exercises are learner instructions. No software tests were added or run. A browser rendering pass was not performed, so final renderer-specific RTL/layout behavior remains an integration review item.

## Integration concerns

At the latest check, 18 cross-chapter link occurrences point to 9 not-yet-present spec-defined pages. The chapter-internal links and existing root/cache links resolve. These pending targets are owned by other tasks; no out-of-scope files were created to fill them:

- `03-asynchronism/01-background-jobs/README.md`
- `04-databases/03-orm-fetch-strategies/README.md`
- `04-databases/04-efficient-database-pagination/README.md`
- `04-databases/05-select-only-needed-columns/README.md`
- `06-code-optimization/01-streaming-large-bodies/README.md`
- `06-code-optimization/04-critical-paths/README.md`
- `08-security/03-throttling-and-rate-limiting/README.md`
- `10-network/01-region-and-network-latency/README.md`
- `10-network/03-cdn-for-static-and-frequent-content/README.md`

The parent should rerun the pack-wide local-link check once the remaining chapters exist. External resources and vendor quotas can change after the recorded research date; the material points to owning documentation and scopes product-specific behavior explicitly.


## Snapshot: Backend Performace/02-api-response/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # فصل ۰۲: پاسخ API — دادهٔ لازم، با کار و انتقال متناسب
   4: 
   5: وقتی کاربر فهرست سفارش‌ها را باز می‌کند، سریع بودن Query به‌تنهایی کافی نیست. ساختن هزاران شیء، محاسبهٔ فیلدهای بلااستفاده، تبدیل آن‌ها به JSON، انتقال چند مگابایت و Parse کردن در گوشی هم هزینه دارند. این فصل چهار تصمیم را به هم وصل می‌کند: چه داده‌ای، چه تعداد، با چه Encoding و پس از چه مقدار پردازش برگردد.
   6: 
   7: این فصل بخشی از [بستهٔ Backend Performance](../README.md) و متناظر با بخش API Response در [نقشهٔ راه مبنا](https://roadmap.sh/backend-performance-best-practices) است. تاریخ بررسی منابع: **۲۰۲۶-۱۱-۱۰**. مثال‌های عددی این فصل آموزشی‌اند؛ هدف عملکرد عمومی برای همهٔ سرویس‌ها نیستند.
   8: 
   9: ## پیش‌نیاز و نتیجهٔ یادگیری
  10: 
  11: با Request/Response در HTTP، JSON، Header، Status Code و یک Endpoint فهرستی آشنا باشید. دانستن مفهوم Query و Index کافی است؛ زبان یا Cloud خاصی لازم نیست. پس از مطالعه می‌توانید برای یک Endpoint بودجهٔ اندازه تعیین کنید، مذاکرهٔ Compression را بررسی کنید، قرارداد Pagination بسازید و کار اضافی را پیش از اجرا حذف کنید.
  12: 
  13: ## ترتیب پیشنهادی مطالعه
  14: 
  15: | ترتیب | درس | سؤال اصلی | خروجی عملی |
  16: | --- | --- | --- | --- |
  17: | ۱ | [اندازه و محدودیت Payload](01-payload-size/README.md) | آیا این داده اصلاً باید در این پاسخ باشد؟ | قرارداد فیلدها، سقف آیتم/بایت و رفتار عبور از حد |
  18: | ۲ | [فشرده‌سازی پاسخ](02-response-compression/README.md) | بایت‌های لازم چگونه ارزان‌تر منتقل شوند؟ | Header درست، نسبت فشرده‌سازی و هزینهٔ CPU |
  19: | ۳ | [صفحه‌بندی کارآمد API](03-efficient-pagination/README.md) | کلاینت چگونه مجموعه را مرحله‌ای طی کند؟ | اندازهٔ صفحه، ترتیب، Token و پایان پیمایش |
  20: | ۴ | [حذف پردازش غیرضروری](04-avoid-unnecessary-server-work/README.md) | کدام محاسبه را می‌توان انجام نداد؟ | برنامهٔ اجرای مبتنی بر فیلدها و Revalidation ارزان |
  21: 
  22: اندازه و Pagination به هم وابسته‌اند: محدودیت ۵۰ رکورد، برای رکوردی که یک فایل بزرگ درون خود دارد محدودیت بایتی ایجاد نمی‌کند. Compression هم جایگزین این دو نیست؛ کلاینت در نهایت باید دادهٔ بازشده را در حافظه نگه دارد. قرارداد پاسخ را ابتدا روشن کنید و سپس اثر هر لایه را اندازه بگیرید.
  23: 
  24: ## سناریوی مشترک فصل
  25: 
  26: **سناریوی فرضی:** فهرست سفارش‌های فروشگاه در هر بازدید همهٔ تاریخچه، اقلام، عکس‌های درون JSON و امتیاز محاسبه‌شدهٔ مشتری را می‌فرستد؛ رابط فقط شناسه، تاریخ، وضعیت و مبلغ را نشان می‌دهد.
  27: 
  28: 1. یک نمایش خلاصه تعریف کنید؛ جزئیات و فایل‌ها مسیر جدا داشته باشند. اندازهٔ بازشده و منتقل‌شده را جدا ثبت کنید.
  29: 2. تعداد خروجی را محدود کنید و لینک ادامه بدهید؛ ترتیب و رفتار تغییر داده بین صفحات را بنویسید.
  30: 3. JSON کافی‌بزرگ را در لایهٔ مسئول با Encoding مورد قبول کلاینت فشرده کنید؛ نتیجه را از دید مصرف‌کننده ببینید.
  31: 4. محاسبهٔ امتیاز و واکشی اقلام را فقط در درخواست جزئیات انجام دهید. اگر نمایش خلاصه تغییری نکرده، اعتبار آن را پیش از ساخت کامل بررسی کنید.
  32: 
  33: موفقیت این سناریو فقط «JSON کوچک‌تر» نیست. تعداد Query/فراخوانی وابسته، CPU هر درخواست، حافظه، زمان تا نخستین بایت و زمان کل پاسخ، p95/p99 و خطاهای کلاینت را نیز مقایسه کنید. درصد بهبود بدون خط مبنا و شرایط یکسان معنای عملی کمی دارد.
  34: 
  35: ## مرز این فصل و فصل‌های مرتبط
  36: 
  37: | موضوع مرتبط | مسئولیت این فصل | مطالعهٔ تکمیلی |
  38: | --- | --- | --- |
  39: | Pagination در پایگاه داده | قرارداد عمومی صفحه، Token و رفتار کلاینت | [اجرای Query، Offset/Keyset و Index](../04-databases/04-efficient-database-pagination/README.md) |
  40: | انتخاب ستون | نیاز بیرونی به فیلدها و نمایش خلاصه | [Projection در پایگاه داده](../04-databases/05-select-only-needed-columns/README.md) |
  41: | HTTP caching | تشخیص ارزان «نمایش تغییر نکرده» | [لایه‌های Cache](../01-caching/01-cache-layers/README.md) و [تازگی و ابطال](../01-caching/04-invalidation-and-freshness/README.md) |
  42: | فایل بزرگ | محدودیت پاسخ تعاملی و مسیر Export جدا | [Streaming](../06-code-optimization/01-streaming-large-bodies/README.md) و [کار پس‌زمینه](../03-asynchronism/01-background-jobs/README.md) |
  43: | تحویل شبکه | Encoding و اندازهٔ بدنهٔ پاسخ | [تأخیر و Region](../10-network/01-region-and-network-latency/README.md) و [CDN](../10-network/03-cdn-for-static-and-frequent-content/README.md) |
  44: 
  45: ## چک‌لیست مرور فصل
  46: 
  47: - [ ] مصرف‌کننده و فیلدهای لازم مشخص‌اند؛ پاسخ فهرست با جزئیات تفاوت دارد.
  48: - [ ] سقف تعداد، اندازهٔ بایتی، عمق Expand و رفتار خطا مستندند.
  49: - [ ] اندازهٔ JSON بازشده و بدنهٔ منتقل‌شده جدا اندازه‌گیری می‌شوند.
  50: - [ ] Encoding، `Vary` و رفتار Reverse Proxy/CDN از دید کلاینت بررسی شده‌اند.
  51: - [ ] Pagination از صفحهٔ نخست تا پایان، روی مجموعهٔ خالی و دادهٔ در حال تغییر تعریف دارد.
  52: - [ ] فیلد انتخاب‌نشده باعث اجرای Query یا محاسبهٔ گران نمی‌شود.
  53: - [ ] حذف کار اضافی مجوزدهی، صحت داده و تعهدات ثبت رویداد را حذف نمی‌کند.
  54: - [ ] برای هر تغییر، خط مبنا، مشاهدهٔ مورد انتظار و راه برگشت وجود دارد.
  55: 
  56: ## منابع راهنما
  57: 
  58: - [فارسی: طراحی REST، صفحه‌بندی و انتخاب فیلد — نت پارادیس](https://netparadis.com/rest-design-pagination-filtering-versioning/): برای پیوند تصمیم‌های قرارداد API؛ توصیه‌ها را با نیاز واقعی تطبیق دهید.
  59: - [Google API Design Guide](https://docs.cloud.google.com/apis/design): چارچوب طراحی قرارداد؛ جزئیات Pagination در درس سوم به AIP-158 ارجاع دارد.
  60: - [Microsoft Well-Architected: Optimize code and infrastructure](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure): کاهش مصرف غیرضروری بر اساس اندازه‌گیری، با توجه به هزینهٔ زیرساخت.
  61: 
  62: **ادامه:** [درس ۱ — اندازهٔ Payload](01-payload-size/README.md) · [فهرست اصلی](../README.md)
  63: 
  64: </div>

## Snapshot: Backend Performace/02-api-response/01-payload-size/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # اندازه و محدودیت Payload
   4: 
   5: Payload بدنهٔ پیام است؛ در این درس تمرکز بر دادهٔ پاسخ API است. «پاسخ کم‌حجم» یعنی حجم داده با نیاز مصرف‌کننده تناسب داشته باشد. «محدودیت» یعنی قرارداد جلوی رشد بی‌مهار تعداد آیتم، اندازهٔ فیلد یا Expand تو‌در‌تو را بگیرد. سقف زیرساخت با بودجهٔ مناسب تجربهٔ کاربر برابر نیست.
   6: 
   7: **پس از این درس می‌توانید:** اندازهٔ بازشده و منتقل‌شده را جدا تفسیر کنید؛ نمایش خلاصه بسازید؛ سقف آیتم و بایت را کنار هم تعریف کنید؛ و برای پاسخ بزرگ راه خروج قابل‌فهم طراحی کنید. پیش‌نیاز: JSON و HTTP. تاریخ بررسی منابع: **۲۰۲۶-۱۱-۱۰**.
   8: 
   9: ## مدل ذهنی: هزینه از قبل از شبکه شروع می‌شود
  10: 
  11: | مرحله | هزینه‌ای که با دادهٔ اضافی رشد می‌کند | پرسش بازبینی |
  12: | --- | --- | --- |
  13: | واکشی | خواندن ستون/رابطه، انتقال از DB | آیا مصرف‌کننده این فیلد را لازم دارد؟ |
  14: | ساخت پاسخ | Allocation، محاسبه، Serialization | آیا نمایش فهرست مستقل از نمایش جزئیات است؟ |
  15: | انتقال | بایت روی شبکه و زمان دریافت | آیا اندازهٔ واقعی انتقال ثبت شده است؟ |
  16: | مصرف | Decompression، Parse، حافظه و Render | آیا گوشی ضعیف می‌تواند پاسخ را مصرف کند؟ |
  17: 
  18: Compression مرحلهٔ انتقال را کوچک می‌کند، اما تعداد رکوردها و ساختار JSON پس از بازشدن همان است. انتخاب فیلد باید تا حد امکان پیش از واکشی/محاسبه اعمال شود؛ حذف فیلد در آخر Serializer فقط بخشی از هزینه را کم می‌کند. نمونهٔ رسمی Google Drive پارامتر `fields` را برای درخواست زیرمجموعهٔ داده مستند کرده است؛ این قابلیت قراردادی است و در هر API خودبه‌خود وجود ندارد. [منبع: Drive fields](https://developers.google.com/workspace/drive/api/guides/fields-parameter)
  19: 
  20: مسیر تصمیم‌گیری پیشنهادی:
  21: 
  22: 1. برای هر مصرف‌کننده فیلدهای واقعاً مورد نیاز را بنویسید؛ مثلاً «کارت سفارش» به تاریخچهٔ همهٔ اقلام نیاز ندارد.
  23: 2. پاسخ خلاصه را پیش‌فرض کنید و جزئیات/رابطهٔ بزرگ را با درخواست صریح در دسترس بگذارید. فیلدهایی که برای ادامهٔ صفحه لازم‌اند، مانند Token، را فراموش نکنید.
  24: 3. تعداد آیتم، طول فیلدهای آزاد، تعداد و عمق Expand و بایت بدنهٔ بازشده را محدود کنید. سقف عددی را با دادهٔ واقعی و نیاز محصول انتخاب کنید.
  25: 4. اندازهٔ بازشده، اندازهٔ منتقل‌شده و حافظهٔ اوج را جدا بسنجید؛ `Content-Length` ممکن است در پاسخ فشرده اندازهٔ فشرده را نشان دهد یا اصلاً موجود نباشد.
  26: 5. عبور از حد را در قرارداد تعریف کنید: صفحهٔ کوچک‌تر با لینک ادامه، درخواست اصلاح پارامتر، یا Export جدا. بدنهٔ JSON را وسط یک شیء قطع نکنید.
  27: 
  28: ### بودجهٔ آموزشی و سقف سخت
  29: 
  30: | نوع حد | نمونهٔ فرضی | رفتار طراحی‌شده |
  31: | --- | --- | --- |
  32: | بودجهٔ پایش | p95 بدنهٔ بازشدهٔ فهرست زیر ۱۰۰ KiB | هشدار و بررسی تغییر Schema؛ الزاماً خطا نیست |
  33: | سقف تعداد | `page_size <= 50` | Clamp یا خطای پارامتر، طبق قرارداد مستند |
  34: | سقف بایت | حداکثر ۲۵۶ KiB برای هر صفحهٔ این API | کمتر از سقف آیتم برگردان؛ Token ادامه بده |
  35: | فیلد منفرد بسیار بزرگ | توضیح ۲ MiB در یک آیتم | خلاصهٔ مستند و مسیر جزئیات/فایل جدا |
  36: 
  37: این عددها **پیشنهاد عمومی یا نتیجهٔ آزمایش تولید نیستند**. اگر محدودیت بایتی یک آیتم را هم جا ندهد، کم کردن تعداد صفحه کافی نیست؛ باید نمایش آن آیتم یا مسیر تحویل تغییر کند. کلاینت نیز نباید «کمتر از `page_size`» را پایان قطعی بداند؛ قرارداد Token تعیین‌کننده است.
  38: 
  39: ## مثال حل‌شده: کارت سفارش
  40: 
  41: **سناریوی فرضی:** Endpoint قبلی ۱۰۰ سفارش، همراه با تاریخچه و فایل درون JSON برمی‌گرداند. رابط فقط خلاصه را نمایش می‌دهد. قرارداد جدید چنین است:
  42: 
  43: <div dir="ltr" align="left">
  44: 
  45: ```http
  46: GET /v1/orders?page_size=2&fields=id,status,total HTTP/1.1
  47: Host: api.example.test
  48: Accept: application/json
  49: ```
  50: 
  51: ```json
  52: {
  53:   "items": [
  54:     {"id": "o-102", "status": "paid", "total": 480000},
  55:     {"id": "o-101", "status": "pending", "total": 120000}
  56:   ],
  57:   "next_page_token": "opaque-token-1"
  58: }
  59: ```
  60: 
  61: </div>
  62: 
  63: در قرارداد این مثال، `fields` فقط فیلدهای داخل `items` را کنترل می‌کند؛ Metadata ادامه همیشه باقی می‌ماند. مجوز مشاهدهٔ فیلدها مستقل از این پارامتر بررسی می‌شود. درخواست فیلد ناشناخته خطای مستند پارامتر دارد. یک URL جزئیاتِ تحت مجوز، جای انتقال خودکار فایل را می‌گیرد؛ این URL نباید دسترسی دائمی عمومی به فایل خصوصی ایجاد کند.
  64: 
  65: فرض کنید در خط مبنای آموزشی ۱۰۰ آیتم × ۲۰ KiB برابر حدود ۲۰۰۰ KiB دادهٔ آیتم است. نمایش خلاصهٔ ۵۰ آیتم × ۰٫۵ KiB حدود ۲۵ KiB می‌شود؛ Envelope و Header جدا هستند. این حساب نشان می‌دهد کاهش تعداد و کاهش اندازهٔ هر آیتم دو اهرم مستقل‌اند؛ نسبت واقعی را با JSON سریال‌شده بسنجید، نه با اندازهٔ شیء در حافظه.
  66: 
  67: ## تمرین کوتاه و مشاهدهٔ مورد انتظار
  68: 
  69: یک نمونهٔ محلی JSON از ۲۰ سفارش بسازید که هرکدام یک توضیح بلند و تاریخچه دارند. بدون نیاز به سرور، دو فایل تولید کنید: «همهٔ فیلدها» و «فقط `id,status,total`». در PowerShell اندازهٔ UTF-8 ذخیره‌شده را بخوانید:
  70: 
  71: <div dir="ltr" align="left">
  72: 
  73: ```powershell
  74: Get-Item -LiteralPath .\orders-full.json, .\orders-summary.json |
  75:     Select-Object Name, Length
  76: ```
  77: 
  78: </div>
  79: 
  80: سپس یک آیتم با توضیح بسیار بزرگ اضافه کنید و دوباره اندازه‌ها را مقایسه کنید. **انتظار:** تعداد آیتم ثابت است ولی اندازهٔ کامل زیاد می‌شود؛ نمایش خلاصه نباید با رشد تاریخچه افزایش مشابه داشته باشد. تفاوت بایت با تعداد کاراکتر را، به‌ویژه برای متن فارسی UTF-8، یادداشت کنید. این تمرین اندازه را نشان می‌دهد؛ ادعای کاهش latency یا CPU نیازمند اندازه‌گیری سرور است.
  81: 
  82: ## شاهد واقعی و حدود آن
  83: 
  84: **شاهد عملیاتی رسمی:** مستندات Google Drive برای `files.list` یک مجموعهٔ فیلد پیش‌فرض محدود معرفی می‌کند و امکان درخواست فیلدهای مشخص را توضیح می‌دهد. این نمونهٔ قابل‌استنادِ API واقعی است؛ این صفحه درصد بهبود سرویس ما را ثابت نمی‌کند. [Drive fields parameter](https://developers.google.com/workspace/drive/api/guides/fields-parameter)
  85: 
  86: **حد زیرساخت واقعی:** جدول HTTP API در Amazon API Gateway در تاریخ بررسی، Payload را ۱۰ MB و غیرقابل‌افزایش نشان می‌دهد. این عدد مربوط به همین نوع API است؛ آن را به همهٔ Gatewayها، APIهای Streaming یا وضعیت‌های پاسخ تعمیم ندهید. [جدول رسمی HTTP API quotas](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-quotas.html)
  87: 
  88: `413 Content Too Large` به بزرگ بودن **محتوای درخواست** اشاره می‌کند؛ آن را کد عمومی «پاسخ سرور بزرگ شد» فرض نکنید. برای خروجی بزرگ، پیش از ارسال Header قرارداد صفحه/Export را اجرا کنید. [MDN: 413](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/413)
  89: 
  90: ## هزینه‌ها، تناسب و شکست‌های رایج
  91: 
  92: نمایش ثابت خلاصه ساده‌تر و Cache آن قابل‌پیش‌بینی‌تر است. انتخاب آزاد فیلد به کلاینت‌های متفاوت انعطاف می‌دهد، اما ترکیب‌های Cache، مستندسازی و بررسی مجوز را بیشتر می‌کند. برای API کوچک با پاسخ چندصدبایتی، زبان پیچیدهٔ Projection ممکن است بیش از صرفه‌جویی هزینه داشته باشد. برای Export کامل، مسیر فایل/Streaming را بررسی کنید؛ محدودیت پاسخ تعاملی را بی‌حد نکنید.
  93: 
  94: | شکست | علامت عملیاتی | اقدام |
  95: | --- | --- | --- |
  96: | محدود کردن تعداد بدون محدود کردن فیلد بزرگ | p99 اندازه با تعداد یکسان جهش دارد | بیشترین اندازهٔ آیتم و Expand را جدا کنترل کن |
  97: | حذف فیلد فقط پس از Queryهای گران | بایت کم شده ولی DB/CPU ثابت است | Projection و برنامهٔ واکشی را زودتر اعمال کن |
  98: | ارسال بی‌صدای خروجی ناقص | کاربر بخشی از سفارش‌ها را گم می‌کند | Metadata ادامه و معنای خلاصه را مستند کن |
  99: | حذف ناگهانی فیلد موجود | خطای کلاینت قدیمی | نسخه/تغییر سازگار و دورهٔ مهاجرت طراحی کن |
 100: | ثبت بدنهٔ بزرگ در Log | هزینه و تأخیر Log یا افشای داده | اندازه و نوع نمایش را ثبت کن؛ بدنه لازم نیست |
 101: 
 102: ### چک‌لیست عملیاتی
 103: 
 104: - [ ] برای Endpoint و مصرف‌کنندهٔ اصلی، فیلدهای ضروری ثبت شده‌اند.
 105: - [ ] سقف آیتم، بایت، طول فیلد و Expand باهم مشخص‌اند.
 106: - [ ] رفتار عبور از حد و تک‌آیتم بسیار بزرگ روشن است.
 107: - [ ] اندازهٔ بازشده/منتقل‌شده و p95/p99 به تفکیک Route ثبت می‌شود.
 108: - [ ] فیلد حساس با انتخاب کاربر یا Serializer خودکار افشا نمی‌شود.
 109: - [ ] سناریوی مجموعهٔ خالی، متن فارسی بلند و کلاینت قدیمی مرور شده است.
 110: 
 111: ## آزمون — ابتدا بدون پاسخ‌ها حل کنید
 112: 
 113: 1. چرا سقف ۵۰ آیتم به‌تنهایی سقف بایت تضمین نمی‌کند؟
 114: 2. پاسخ ۲ MiB پس از gzip به ۱۰۰ KiB رسیده است؛ آیا حافظهٔ Parse کلاینت هم حتماً ۹۵٪ کم شده؟
 115: 3. اگر `fields=id` فقط در انتهای Serializer اعمال شود، کدام هزینه ممکن است باقی بماند؟
 116: 4. آیا `413` پاسخ استانداردی برای «JSON خروجی من بزرگ است» است؟
 117: 5. صفحه به علت سقف بایت ۱۸ آیتم از سقف ۵۰ دارد و Token ادامه هم موجود است؛ کلاینت باید متوقف شود؟
 118: 6. اضافه کردن Projection آزاد چه هزینه‌ای در مقایسه با نمایش ثابت خلاصه دارد؟
 119: 
 120: ### پاسخ تشریحی
 121: 
 122: 1. اندازهٔ آیتم‌ها یکسان نیست؛ یک فیلد بلند یا فایل درون‌خطی می‌تواند بودجه را بشکند. تعداد و بایت هر دو لازم‌اند.
 123: 2. خیر؛ داده پس از بازشدن تقریباً همان JSON قبلی است. حافظهٔ Parse به نمایش بازشده و Runtime نیز وابسته است.
 124: 3. واکشی رابطه‌ها، انتقال DB و محاسبهٔ فیلدها؛ برنامهٔ اجرای مبتنی بر فیلد باید زودتر تصمیم بگیرد.
 125: 4. خیر؛ معنای آن محتوای درخواست بزرگ‌تر از حد پذیرفته‌شده است. راهکار خروجی باید در قرارداد API تعریف شود.
 126: 5. خیر؛ Token ادامه می‌گوید نتیجهٔ بیشتری قابل درخواست است. تعداد کمتر از سقف، به‌خودی‌خود علامت پایان نیست.
 127: 6. ترکیب‌های بیشتری برای مجوز، Cache و نگه‌داری قرارداد ایجاد می‌کند؛ فقط با نیاز واقعی این پیچیدگی را بپذیرید.
 128: 
 129: ## مطالعهٔ بیشتر
 130: 
 131: - [فارسی: بخش انتخاب فیلد در طراحی REST — نت پارادیس](https://netparadis.com/rest-design-pagination-filtering-versioning/): مقدمهٔ مرتبط با `fields` و `include`؛ منبع مکمل است، نه مرجع رفتار همهٔ APIها.
 132: - [English: Google Drive fields](https://developers.google.com/workspace/drive/api/guides/fields-parameter): نمونهٔ دقیق قرارداد انتخاب فیلد و خطای انتخاب نامعتبر.
 133: - [English: MDN Content-Length](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Length): برای تفسیر طول بدنه؛ Header جای اندازه‌گیری همهٔ مراحل را نمی‌گیرد.
 134: - [English: AWS HTTP API quotas](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-quotas.html): نمونهٔ سقف سخت زیرساخت، قابل‌بررسی هنگام انتخاب مسیر تحویل.
 135: 
 136: **ناوبری:** [فصل API Response](../README.md) · [فهرست اصلی](../../README.md) · [بعدی: Compression](../02-response-compression/README.md)
 137: 
 138: **مرتبط:** [Pagination API](../03-efficient-pagination/README.md) · [انتخاب ستون DB](../../04-databases/05-select-only-needed-columns/README.md) · [Streaming](../../06-code-optimization/01-streaming-large-bodies/README.md)
 139: 
 140: </div>

## Snapshot: Backend Performace/02-api-response/02-response-compression/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # فشرده‌سازی پاسخ — Response Compression
   4: 
   5: Compression نمایش بایتی همان محتوا را برای انتقال کوچک‌تر می‌کند؛ JSON را از نظر معنایی خلاصه نمی‌کند. سرور و کلاینت باید دربارهٔ Encoding توافق کنند. کاهش بایت هزینهٔ شبکه را کم می‌کند، اما فشرده‌سازی و بازکردن آن CPU می‌خواهد؛ تصمیم خوب نتیجهٔ مقایسهٔ این هزینه‌هاست.
   6: 
   7: **پس از این درس می‌توانید:** نقش سه Header اصلی را توضیح دهید؛ اندازهٔ انتقال را با بدنهٔ بازشده اشتباه نگیرید؛ لایهٔ مسئول فشرده‌سازی را تعیین کنید؛ و سود شبکه را همراه با CPU، تأخیر و ریسک محتوای حساس بسنجید. پیش‌نیاز: HTTP Header و [اندازهٔ Payload](../01-payload-size/README.md). تاریخ بررسی منابع: **۲۰۲۶-۱۱-۱۰**.
   8: 
   9: ## مذاکرهٔ Encoding چگونه کار می‌کند؟
  10: 
  11: | جزء | نقش | نمونه |
  12: | --- | --- | --- |
  13: | `Accept-Encoding` در درخواست | الگوریتم‌های قابل‌قبول برای کلاینت | `gzip, br` |
  14: | `Content-Encoding` در پاسخ | Encoding واقعاً اعمال‌شده به بدنه | `gzip` |
  15: | `Vary: Accept-Encoding` در پاسخ | اطلاع به Cache دربارهٔ وابستگی نمایش به Header درخواست | نسخهٔ فشرده و خام اشتباه به هم تحویل نشوند |
  16: | `Content-Type` | نوع محتوای بازشده | همچنان `application/json` |
  17: 
  18: کلاینت پشتیبانی‌اش را اعلام می‌کند؛ سرور Encoding قابل‌قبول و پشتیبانی‌شده را انتخاب می‌کند و بدنه را با آن می‌فرستد. وقتی انتخاب نمایش به `Accept-Encoding` وابسته است، `Vary` باید این وابستگی را بیان کند. gzip معمولاً برای متن/JSON مفید است؛ فشرده کردن دوبارهٔ JPEG یا ZIP معمولاً سود کمی دارد. [MDN: Compression in HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression)
  19: 
  20: نباید تنها با افزودن `Content-Encoding: gzip` بدنهٔ JSON خام ارسال کنید؛ Header باید بایت‌های واقعی را توصیف کند. برعکس، بدنهٔ gzip بدون Header درست برای مصرف‌کننده قابل تفسیر نیست. `Content-Length`، اگر موجود است، طول پیامِ کدگذاری‌شده را بیان می‌کند؛ آن را پس از تغییر Encoding از مقدار قبلی کپی نکنید. [MDN: Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding)
  21: 
  22: ### انتخاب محل و سطح فشرده‌سازی
  23: 
  24: 1. مسیر تحویل را بنویسید: Application ← Reverse Proxy ← CDN ← Client. رفتار پاسخ را در هر Hop ببینید، نه فقط تنظیم برنامه را.
  25: 2. یک مالک روشن برای Policy تعیین کنید. اگر چند لایه تبدیل می‌کنند، مسئولیت Header، Validator و Decompression/Recompression باید معلوم باشد.
  26: 3. MIME Type، حداقل اندازه و الگوریتم‌های مجاز را مشخص کنید. آستانهٔ مناسب به داده، CPU و شرایط شبکهٔ شما وابسته است.
  27: 4. برای پاسخ پویای پرترافیک، سطح فشرده‌سازی را با p95/p99 و CPU انتخاب کنید. کمترین بایت الزاماً کمترین latency نیست.
  28: 5. دارایی ثابت را در صورت امکان از پیش فشرده و توزیع کنید؛ برای پاسخ جریانی، هزینهٔ Buffer و Flush را نیز بسنجید.
  29: 
  30: Compression برای پاسخ متنی متوسط/بزرگ روی لینک محدود مناسب است. برای پاسخ بسیار کوچک، فایل از پیش فشرده، یا سرویس CPU-bound ممکن است سود ناچیز یا منفی باشد. اگر دادهٔ غیرضروری می‌فرستید، ابتدا [Payload](../01-payload-size/README.md) را اصلاح کنید؛ کلاینت دادهٔ اضافی را پس از بازکردن همچنان Parse می‌کند.
  31: 
  32: ## مثال حل‌شدهٔ HTTP و حساب سرانگشتی
  33: 
  34: <div dir="ltr" align="left">
  35: 
  36: ```http
  37: GET /v1/orders?page_size=50 HTTP/1.1
  38: Host: api.example.test
  39: Accept: application/json
  40: Accept-Encoding: gzip
  41: ```
  42: 
  43: ```http
  44: HTTP/1.1 200 OK
  45: Content-Type: application/json
  46: Content-Encoding: gzip
  47: Vary: Accept-Encoding
  48: 
  49: [gzip-encoded bytes of the JSON representation]
  50: ```
  51: 
  52: </div>
  53: 
  54: سطر آخر نمایش آموزشیِ جای بدنهٔ باینری است؛ نباید آن متن را به‌عنوان بدنهٔ واقعی سرور پیاده کنید. در نمونهٔ فوق عمداً `Content-Length` عددی ننوشته‌ایم، چون طول باید از بایت واقعی خروجی محاسبه شود.
  55: 
  56: **سناریوی فرضی:** JSON برابر ۲۰۰ KiB است؛ نتیجهٔ اندازه‌گیری محلی gzip برابر ۴۰ KiB شده است. نسبت خروجی به ورودی ۰٫۲ و صرفه‌جویی بایت ۸۰٪ است. روی لینک فرضی ۱ MiB/s، بخش خالص انتقال از حدود ۱۹۵ به ۳۹ میلی‌ثانیه می‌رسد؛ RTT، صف، TLS و پردازش در این حساب نیستند. اگر فشرده‌سازی ۵ میلی‌ثانیه هزینه داشته باشد احتمال سود هست؛ اگر زیر بار ۲۰۰ میلی‌ثانیه صف CPU اضافه کند، این انتخاب ممکن است بدتر باشد. این اعداد گزارش تولید نیستند.
  57: 
  58: ## تمرین کوتاه: پاسخ واقعی را از سمت کلاینت ببینید
  59: 
  60: روی Endpoint محلی یا محیط آزمایشیِ خودتان که پاسخ JSON به‌اندازهٔ کافی بزرگ دارد، دو درخواست به یک URL و با مجوز یکسان بفرستید. `localhost:8080` در این تمرین فرضی است و باید با سرویس آزمایشی خود جایگزین شود. در Windows از `curl.exe` استفاده کنید:
  61: 
  62: <div dir="ltr" align="left">
  63: 
  64: ```powershell
  65: curl.exe -sS -H "Accept-Encoding: identity" -D identity-headers.txt -o identity-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
  66: curl.exe -sS -H "Accept-Encoding: gzip" -D gzip-headers.txt -o gzip-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
  67: Get-Item -LiteralPath .\identity-body.bin, .\gzip-body.bin |
  68:     Select-Object Name, Length
  69: ```
  70: 
  71: </div>
  72: 
  73: در این دو فرمان `--compressed` استفاده نشده تا ابزار بدنه را خودکار باز نکند؛ فایل دوم در صورت پذیرفته‌شدن gzip، بایت فشرده دارد. **انتظار:** در مسیر واجد شرایط، Header دوم `Content-Encoding: gzip` و اندازهٔ منتقل‌شده کوچک‌تر است؛ پاسخ اول نباید ادعای gzip کند. اگر تفاوت نیست، MIME Type، آستانه، Encoding پشتیبانی‌شده و رفتار Proxy را بررسی کنید. چند بار با دادهٔ ثابت و حالت Cache مشخص مقایسه کنید؛ یک اندازه‌گیری زمان اثبات بهبود نیست. برای بررسی صحت JSON بازشده می‌توانید درخواست جداگانه با `--compressed` بفرستید.
  74: 
  75: ## شاهد واقعی و حدود آن
  76: 
  77: **مستند عملیاتی Cloudflare:** فشرده‌سازی مسیر Origin تا شبکهٔ Cloudflare و مسیر آن تا بازدیدکننده جداست. این Reverse Proxy می‌تواند بین نمایش خام و فشرده تبدیل کند، و برخی تغییرهای محتوا نیازمند بازکردن و فشرده‌سازی دوباره هستند. نتیجهٔ عملی برای عیب‌یابی: Header و اندازهٔ مشاهده‌شده در Origin الزاماً همان خروجی نهایی کلاینت نیست. [Cloudflare: Content compression](https://developers.cloudflare.com/speed/optimization/content/compression/)
  78: 
  79: این شاهد از رفتار یک سرویس واقعی می‌آید؛ آزمایش مقایسه‌ایِ برنامهٔ ما یا تضمین درصد صرفه‌جویی نیست. تنظیمات و محدودیت‌های CDN را هنگام اجرا دوباره بررسی کنید؛ از یک آستانهٔ اختصاصی محصول، «عدد استاندارد HTTP» نسازید.
  80: 
  81: ## شکست‌ها، ریسک‌ها و علائم
  82: 
  83: | شکست | نشانه | اقدام |
  84: | --- | --- | --- |
  85: | سطح بسیار سنگین روی پاسخ پویا | بایت کمتر، CPU و p99 بیشتر | سطوح سبک‌تر و مالک لایه را مقایسه کن |
  86: | Header نادرست یا تبدیل دوبارهٔ ناسازگار | خطای Decode/JSON در کلاینت | بایت واقعی و Header هر Hop را کنار هم بررسی کن |
  87: | `Vary` ناقص | مشکل فقط برای بخشی از کلاینت‌های پشت Cache | سیاست نمایش و کلید Cache را اصلاح کن |
  88: | اعتماد به اندازهٔ بازشدهٔ DevTools به‌جای انتقال | گزارش صرفه‌جویی اشتباه | Transfer size و decoded size را جدا ثبت کن |
  89: | Buffer کردن کل پاسخ جریانی | افزایش حافظه و زمان اولین بایت | اندازهٔ Buffer و رفتار Flush را بررسی کن |
  90: 
  91: **محتوای حساس:** ترکیب دادهٔ راز و ورودی قابل‌کنترل مهاجم در یک پاسخ فشردهٔ پویا می‌تواند از تغییر طول پاسخ اطلاعات نشت دهد؛ HTTPS این مسئله را به‌تنهایی برطرف نمی‌کند. مستندات ASP.NET Core دربارهٔ ریسک Compression روی پاسخ‌های پویا و امن هشدار می‌دهد. این به معنای ناامن بودن همهٔ JSONهای فشرده نیست؛ Endpoint حساس و مدل تهدید را بررسی کنید. [Microsoft: Response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0)
  92: 
  93: ### چک‌لیست عملیاتی
  94: 
  95: - [ ] MIME Type، آستانه، Encoding و مالک Policy روشن‌اند.
  96: - [ ] درخواست بدون Compression و با هر Encoding پشتیبانی‌شده درست پاسخ می‌گیرد.
  97: - [ ] `Content-Encoding`، `Vary` و طول بدنه با بایت واقعی سازگارند.
  98: - [ ] اندازهٔ بازشده، نسبت فشرده‌سازی، CPU، TTFB و p95/p99 ثبت شده‌اند.
  99: - [ ] رفتار نهایی پس از Proxy/CDN و اثر Cache بررسی شده است.
 100: - [ ] پاسخ‌های حساس و دادهٔ از پیش فشرده جدا بررسی شده‌اند.
 101: - [ ] برای Streaming، حافظهٔ Buffer و تأخیر Flush تحت مشاهده‌اند.
 102: 
 103: ## آزمون
 104: 
 105: 1. تفاوت `Accept-Encoding` و `Content-Encoding` چیست؟
 106: 2. چرا در انتخاب Encoding بر اساس درخواست، `Vary: Accept-Encoding` لازم است؟
 107: 3. آیا باید `Content-Type` پاسخ JSON فشرده را به `application/gzip` تغییر داد؟
 108: 4. خروجی از ۲۰۰ به ۴۰ KiB رسیده ولی p99 بدتر شده است؛ دو بررسی بعدی چیست؟
 109: 5. آیا فقط دیدن `Content-Encoding` در Origin برای اثبات خروجی نهایی کافی است؟
 110: 6. چرا «همهٔ پاسخ‌های HTTPS را با سنگین‌ترین سطح فشرده کن» تصمیم قابل دفاعی نیست؟
 111: 
 112: ### پاسخ تشریحی
 113: 
 114: 1. اولی قابلیت/ترجیح کلاینت را بیان می‌کند؛ دومی Encoding واقعاً اعمال‌شده به بدنهٔ پاسخ را اعلام می‌کند.
 115: 2. Cache باید نمایش‌های وابسته به قابلیت کلاینت را تشخیص دهد؛ وگرنه ممکن است نمایش نامناسب تحویل دهد.
 116: 3. خیر؛ نوع محتوای بازشده همچنان JSON است. `Content-Encoding` تبدیل انتقالی آن را توصیف می‌کند.
 117: 4. CPU و زمان صف/فشرده‌سازی را اندازه بگیرید و Buffer/TTFB را ببینید؛ بایت کمتر برای latency کل کافی نیست.
 118: 5. خیر؛ Proxy/CDN ممکن است تبدیل یا Recompression کند. از دید مصرف‌کننده هم Header و بایت را بررسی کنید.
 119: 6. هزینهٔ CPU، اندازه و نوع محتوا، Buffering و ریسک محتوای حساس متفاوت است؛ سطح و دامنه باید با اندازه‌گیری انتخاب شوند.
 120: 
 121: ## مطالعهٔ بیشتر
 122: 
 123: - [فارسی: انجین‌اکس؛ فشرده‌سازی و Cache فایل ثابت](https://mehdimj.ir/blog/2026/10/08/nginx-night-16-static-cache-compression/): تمرین کوتاه MIME، `gzip_vary` و مشاهدهٔ Header؛ دامنهٔ مثال فایل ثابت است.
 124: - [English: MDN Compression in HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression): مدل مذاکرهٔ محتوا و تفاوت الگوریتم‌ها.
 125: - [English: MDN Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding): مرجع تفسیر بدنه و نوع محتوا.
 126: - [English: Microsoft response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0): Trade-off، ملاحظات HTTPS و یک نمونهٔ پیاده‌سازی؛ وابستگی به .NET برای فهم این درس لازم نیست.
 127: - [English: Cloudflare Content compression](https://developers.cloudflare.com/speed/optimization/content/compression/): تحویل چندمرحله‌ای و تبدیل‌های Proxy.
 128: 
 129: **ناوبری:** [فصل API Response](../README.md) · [فهرست اصلی](../../README.md) · [قبلی: Payload](../01-payload-size/README.md) · [بعدی: Pagination](../03-efficient-pagination/README.md)
 130: 
 131: **مرتبط:** [Streaming](../../06-code-optimization/01-streaming-large-bodies/README.md) · [CDN](../../10-network/03-cdn-for-static-and-frequent-content/README.md) · [تأخیر شبکه](../../10-network/01-region-and-network-latency/README.md)
 132: 
 133: </div>


