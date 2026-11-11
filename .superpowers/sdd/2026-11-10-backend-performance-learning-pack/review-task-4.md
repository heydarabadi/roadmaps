# Read-only Task 4 review package

## Implementer report

# Task 4 report — Chapter 03: Asynchronism

Status: completed within assigned chapter scope. No Git repository was initialized and no commit was created.

## Files created

- `Backend Performace/03-asynchronism/README.md` — chapter purpose, prerequisites, two-topic sequence, request/reply boundary, shared report-export scenario, queue growth model, related chapters, and review checklist.
- `Backend Performace/03-asynchronism/01-background-jobs/README.md` — independently readable Persian lesson on heavy-work offloading; durable acceptance; API/result latency; status and job ownership; atomic intake/idempotency; leases and stale workers; transactional outbox boundary; backlog, age, deadlines, backpressure, retry and dependency capacity; worked example; calculation/failure exercise; Meta production evidence; operational signals/checklist; seven quiz questions with explained answers; Persian and English sources; relative navigation.
- `Backend Performace/03-asynchronism/02-message-brokers/README.md` — independently readable Persian lesson on service communication through brokers; work queue, pub/sub and logs; confirms versus acks; delivery guarantees and their scope; durability; atomic local effects/deduplication; external effects; bounded intake, prefetch, retries/DLQ, ordering and schema contracts; worked example; duplicate-delivery/prefetch exercise; Slack production evidence; operational signals/checklist; seven quiz questions with explained answers; Persian and English sources; relative navigation.

## Coverage and evidence

Both Asynchronism roadmap bullets are separate lessons. The first is about removing eligible heavy work from the request critical path; a broker is explicitly optional. The second is about message-mediated communication and its failure boundaries. All numeric examples are explicitly educational, and neither case study is used as a universal performance promise.

Sources checked with the built-in web tool on 2026-11-10:

| Source | Use and verification result |
| --- | --- |
| https://engineering.fb.com/2020/08/17/production-engineering/async/ | Loaded first-party engineering account; verified fairness/scheduling limitations, delay tolerance, quotas and intake rate limits. Used for background-jobs evidence. |
| https://slack.engineering/scaling-slacks-job-queue/ | Loaded first-party account with 2017 publication and 2020 update; verified Redis backlog/memory issue, Kafka-before-Redis design, relay rate limits and historical leader-only acknowledgement trade-off. Used for broker evidence. |
| https://www.rabbitmq.com/docs/reliability | Loaded official docs; checked duplicate delivery, publisher recovery, idempotency and mandatory routing behavior. |
| https://www.rabbitmq.com/docs/confirms | Loaded official docs; checked independence of publisher confirms and consumer acks and failure/redelivery boundary. |
| https://www.rabbitmq.com/docs/consumer-prefetch | Loaded official docs; checked per-consumer scope, unacked limit and zero/unlimited semantics. |
| https://www.rabbitmq.com/docs/queues | Loaded official docs; checked ordering caveats, queue durability and alternative stream structure. |
| https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html | Loaded official docs; checked dual-write problem and duplicate-event caveat. |
| https://docs.aws.amazon.com/wellarchitected/2023-04-10/framework/rel_mitigate_interaction_failure_fail_fast.html | Loaded official guidance; checked bounded queues and stale backlog issue. |
| https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/202 | Loaded; checked accepted-versus-completed semantics. Linked at chapter level. |
| https://alixsabet.com/fa/posts/2025/02/rabbitmq/ | Loaded directly relevant Persian practical explanation with PDF background processing and broker routing. Supplemental, not production evidence. |
| https://sakoocloud.ir/databases/rabbitmq/ | Loaded Persian managed-service page. Clearly labeled commercial introduction rather than authoritative delivery/performance proof. |

The suggested DNTips design article was discovered through search, but `https://www.dntips.ir/news/details/16695` redirected to a URL the built-in tool could not fetch (500/non-retryable). It was not included in the chapter; the checked Persian practical article above supplies a closer accessible learning reference. Firecrawl was not called or retried.

## Checks performed

Manual content and quiz review, aided by a read-only file/link inventory: all three expected files exist; UTF-8 Persian text is readable; RTL containers close correctly; code examples are outside RTL containers; two topic answer keys have seven matching explained answers each; the numerical examples were recalculated; all in-chapter relative links and root/previous-chapter links resolve. No software tests or external services were run.

At inspection time the following six unique related-topic targets were not yet present because the other chapters are authored separately. Relative paths match the approved design and must be checked again at pack integration:

- `04-databases/README.md`
- `05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md`
- `06-code-optimization/04-critical-paths/README.md`
- `06-code-optimization/07-timeouts-and-retries/README.md`
- `07-monitoring-and-logging/01-metrics-logs-and-traces/README.md`
- `08-security/03-throttling-and-rate-limiting/README.md`

No root index or other chapter was edited. The report is the only authorized file written outside chapter 03. The chapter was inspected as Markdown source; no separate Markdown renderer or live RabbitMQ experiment was used. Exercises are explicitly paper/model exercises with stated expected observations.

## Concerns for integration

- Recheck the six sibling paths when the full pack exists.
- RabbitMQ source pages currently show version 4.4. The lesson avoids a version-pinned client implementation and labels its RabbitMQ/AMQP 0-9-1 scope; later refreshes should recheck behavior against the user's installed broker/client version.
- Persian resources are supplemental tutorials/service introductions. Production claims come only from first-party Meta/Slack sources, and delivery-behavior claims from official documentation.

Report path: `D:\Learn\Roadmap\.superpowers\sdd\2026-11-10-backend-performance-learning-pack\task-4-report.md`.


## Snapshot: Backend Performace/03-asynchronism/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # فصل ۳ — پردازش غیرهمگام | Asynchronism
   4: 
   5: کاربر برای هر کاری که سرور انجام می‌دهد لازم نیست منتظر بماند. ساخت گزارش، تبدیل تصویر یا ارسال اعلان را می‌توان بعد از پذیرش درخواست انجام داد؛ به شرطی که پذیرش، ماندگاری کار، نتیجه نهایی و خطا قرارداد روشنی داشته باشند. این فصل دو تصمیم جدا را آموزش می‌دهد: **چه کاری را از مسیر پاسخ خارج کنیم؟** و **سرویس‌ها آن کار یا رویداد را چگونه با پیام منتقل کنند؟**
   6: 
   7: **تاریخ بررسی منابع: <span dir="ltr">2026-11-10</span>.** دامنه فصل از بخش Asynchronism در [نقشه‌راه Backend Performance](https://roadmap.sh/backend-performance-best-practices) گرفته شده است. مثال‌های عددی آموزشی‌اند و نتیجه اندازه‌گیری سامانه واقعی نیستند.
   8: 
   9: ## پیش‌نیاز و ترتیب مطالعه
  10: 
  11: با چرخه درخواست/پاسخ HTTP، مفهوم تراکنش پایگاه داده و تفاوت زمان پاسخ با نرخ انجام کار آشنا باشید. ابتدا [کارهای پس‌زمینه](01-background-jobs/README.md) را بخوانید تا مرز پذیرش و تکمیل کار را مشخص کنید؛ سپس [واسطه‌های پیام](02-message-brokers/README.md) را بخوانید تا تحویل، تأیید و تکرار پیام را طراحی کنید.
  12: 
  13: | موضوع | مسئله اصلی | خروجی قابل بررسی |
  14: | --- | --- | --- |
  15: | [۳.۱ کارهای پس‌زمینه — Background Jobs](01-background-jobs/README.md) | انتقال کار سنگین از مسیر حساس به تأخیر | قرارداد وضعیت، بودجه تأخیر و برنامه بازیابی کار |
  16: | [۳.۲ واسطه‌های پیام — Message Brokers](02-message-brokers/README.md) | ارتباط غیرهمگام تولیدکننده و مصرف‌کننده | قرارداد پیام، ضمانت تحویل و کنترل فشار |
  17: 
  18: `async/await` در یک درخواست، لزوماً کار را به صف پایدار نمی‌سپارد. همچنین یک جدول Job به همراه Worker می‌تواند کار پس‌زمینه بسازد، بدون آنکه یک Broker مستقل لازم باشد. انتخاب Broker مسئله ارتباط و عملیات سامانه را نیز وارد تصمیم می‌کند.
  19: 
  20: ## مرز درخواست/پاسخ و سناریوی مشترک
  21: 
  22: فرض کنید ساخت گزارش فروش ۴ ثانیه طول می‌کشد. کاربر ابتدا درخواست می‌دهد، شناسه کار می‌گیرد و سپس وضعیت آن را می‌خواند. پاسخ `202 Accepted` یعنی درخواست برای پردازش پذیرفته شده؛ نتیجه موفق را تضمین نمی‌کند. این تمایز در [راهنمای HTTP 202 در MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/202) توضیح داده شده است.
  23: 
  24: </div>
  25: 
  26: ```mermaid
  27: flowchart LR
  28:     U[Client] --> A[API: validate and persist job]
  29:     A --> R[202 + job status URL]
  30:     A --> Q[Bounded durable queue]
  31:     Q --> W[Worker]
  32:     W --> S[Result and job status]
  33:     U --> P[GET job status]
  34:     P --> S
  35: ```
  36: 
  37: <div dir="rtl" align="right">
  38: 
  39: پاسخ اولیه سریع‌تر می‌شود، اما زمان رسیدن به فایل همچنان شامل انتظار صف و اجراست. اگر ورودی ۳۰ کار در ثانیه و ظرفیت واقعی Workerها ۲۰ کار در ثانیه باشد، در هر ثانیه حدود ۱۰ کار به Backlog اضافه می‌شود. صف زمان می‌خرد؛ ظرفیت پردازش ایجاد نمی‌کند. پس تعداد کارهای منتظر، سن قدیمی‌ترین کار، نرخ تکمیل و زمان انتها‌به‌انتهای نتیجه را کنار زمان پاسخ API ثبت کنید.
  40: 
  41: در این سناریو، درس اول تعیین می‌کند چه چیزی باید پیش از پاسخ ذخیره شود و کاربر چگونه شکست را می‌بیند. درس دوم نشان می‌دهد قطع اتصال بعد از Publish یا بعد از انجام کار چرا ممکن است به تحویل تکراری برسد. حتی اگر پاسخ `API` سریع باشد، رشد مداوم سن صف نشان‌دهنده نقض وعده محصول است.
  42: 
  43: ## ارتباط با فصل‌های دیگر
  44: 
  45: - [حذف کار غیرضروری سرور](../02-api-response/04-avoid-unnecessary-server-work/README.md): پیش از جابه‌جا کردن کار، بررسی کنید اصلاً لازم است یا نه.
  46: - [مسیرهای بحرانی](../06-code-optimization/04-critical-paths/README.md): کدام مرحله واقعاً برای پاسخ همین درخواست لازم است؟
  47: - [Timeout و Retry](../06-code-optimization/07-timeouts-and-retries/README.md): محدودیت زمانی هر تلاش، مهلت کل کار و بودجه تکرار را هماهنگ کنید.
  48: - [مقیاس‌دهی افقی و عمودی](../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md): افزایش Worker فقط وقتی مفید است که پایگاه داده یا سرویس پایین‌دستی ظرفیت داشته باشد.
  49: - [متریک، لاگ و Trace](../07-monitoring-and-logging/01-metrics-logs-and-traces/README.md): شناسه کار را از درخواست تا نتیجه دنبال کنید.
  50: - [کنترل نرخ](../08-security/03-throttling-and-rate-limiting/README.md): محدودیت پذیرش، ابزار جلوگیری از انباشت کار خارج از بودجه است.
  51: 
  52: ## چک‌لیست مرور فصل
  53: 
  54: - [ ] می‌توانم تفاوت پاسخ اولیه، شروع اجرا و تکمیل موفق کار را توضیح بدهم.
  55: - [ ] برای هر نوع کار، مهلت، ظرفیت پذیرش و وضعیت نهایی مشخص کرده‌ام.
  56: - [ ] Backlog و Queue Age را می‌سنجم و فقط به CPU یا زمان پاسخ API نگاه نمی‌کنم.
  57: - [ ] می‌دانم ذخیره Job، Publish و Ack چه مرزهای خرابی متفاوتی دارند.
  58: - [ ] برای تکرار پیام، اجرای هم‌زمان، خطای دائمی و قطع Worker پاسخ عملی دارم.
  59: - [ ] می‌توانم با شواهد توضیح بدهم Broker مستقل لازم است یا یک Job Store ساده کافی است.
  60: 
  61: **مسیر مطالعه:** [فصل قبل: پاسخ API](../02-api-response/README.md) · [فهرست بسته](../README.md) · [فصل بعد: پایگاه داده](../04-databases/README.md)
  62: 
  63: </div>

## Snapshot: Backend Performace/03-asynchronism/01-background-jobs/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # ۳.۱ — کارهای پس‌زمینه | Background Jobs
   4: 
   5: کار پس‌زمینه، وظیفه‌ای است که اجرای آن از عمر درخواست اولیه جدا می‌شود و با یک قرارداد مشخص، بعداً به نتیجه یا شکست نهایی می‌رسد. **Offloading** برای کم‌کردن انتظار درخواست مناسب است؛ مقدار کل کار را خودبه‌خود کاهش نمی‌دهد.
   6: 
   7: **تاریخ بررسی منابع: <span dir="ltr">2026-11-10</span>.** اعداد و سامانه گزارش‌گیری این صفحه مثال آموزشی‌اند. روایت Meta در بخش شواهد، تجربه عمومی مستند است.
   8: 
   9: ## خروجی‌های یادگیری
  10: 
  11: پس از این درس می‌توانید:
  12: 
  13: - کار ضروری برای پاسخ را از کار قابل تعویق جدا کنید.
  14: - تفاوت زمان پذیرش و زمان رسیدن به نتیجه را اندازه بگیرید.
  15: - یک Job با وضعیت، مهلت، تلاش مجدد و اجرای امن در برابر تکرار طراحی کنید.
  16: - رشد صف را از اختلاف نرخ ورود و تکمیل توضیح بدهید و پذیرش را محدود کنید.
  17: - درباره Job Store ساده، Worker جدا و Broker مستقل تصمیم بگیرید.
  18: 
  19: ## مدل ذهنی: کوتاه شدن مسیر حساس به تأخیر
  20: 
  21: فرض کنید درخواست ساخت خروجی شامل اعتبارسنجی، ثبت درخواست، خواندن داده، ساخت فایل و اعلان است. اگر محصول اجازه دهد فایل بعداً آماده شود، مسیر حساس به تأخیرِ پاسخ اولیه فقط تا ثبت پایدار درخواست ادامه دارد. احراز هویت و کنترل دسترسیِ لازم برای پذیرش را نمی‌توان به امید اجرای Worker حذف کرد.
  22: 
  23: | مدل | زمان پاسخ اولیه | زمان دستیابی به نتیجه | مسئولیت جدید |
  24: | --- | --- | --- | --- |
  25: | اجرای همگام | اعتبارسنجی + خواندن داده + ساخت فایل | تقریباً همان پایان درخواست | مدیریت Timeout درخواست |
  26: | Job غیرهمگام | اعتبارسنجی + ثبت پایدار Job | پذیرش + انتظار صف + اجرا + انتشار نتیجه | وضعیت، بازیابی، تکرار و اطلاع‌رسانی |
  27: 
  28: این سه مفهوم متفاوت‌اند: اجرای غیرمسدودکننده `I/O` در همان درخواست، اجرای چند کار به صورت موازی، و سپردن کار به Job مستقل. یک تابع `async` که پیش از پاسخ منتظر آن می‌مانید، هنوز در مسیر پاسخ است. Thread یا Task جدا در حافظه نیز با توقف Process ممکن است گم شود؛ برای کار مهم، پذیرش باید به یک سابقه پایدار و قابل بازیابی وصل باشد.
  29: 
  30: چرخه معمول کار چنین است: `queued → running → succeeded`؛ خطای موقت می‌تواند کار را به `retry_wait` ببرد و سپس دوباره صف کند. خطای دائمی یا پایان بودجه، وضعیت `failed` می‌سازد؛ کار منقضی نیز `expired` می‌شود. این وضعیت‌ها قرارداد آموزشی پیشنهادی‌اند، نام اجباری یک ابزار نیستند.
  31: 
  32: ## مثال حل‌شده: ساخت گزارش با قرارداد روشن
  33: 
  34: در فرض آموزشی، اعتبارسنجی ۲۰، ثبت Job در پایگاه داده ۱۰، تولید گزارش ۴۰۰۰ و انتشار نتیجه ۳۰ میلی‌ثانیه طول می‌کشد. سربار شبکه و رقابت منابع را فعلاً کنار می‌گذاریم. نسخه همگام حدود ۴۰۶۰ میلی‌ثانیه زمان می‌خواهد؛ نسخه Job پس از حدود ۳۰ میلی‌ثانیه پذیرش را اعلام می‌کند، اما نتیجه با صف خالی حدود ۴۰۶۰ میلی‌ثانیه پس از آغاز درخواست آماده می‌شود. اگر انتظار صف ۲ ثانیه باشد، زمان نتیجه حدود ۶۰۶۰ میلی‌ثانیه است. این محاسبه کاهش زمان پاسخ اولیه را از بهبود زمان نتیجه جدا می‌کند.
  35: 
  36: پاسخ و پیام را کوچک نگه دارید؛ به جای چسباندن همه داده مشتری به Job، شناسه و مشخصات نسخه داده را ذخیره کنید. انتخاب Snapshot یا «داده زمان اجرا» باید در قرارداد گزارش روشن باشد، زیرا تغییر داده در فاصله پذیرش تا اجرا روی نتیجه اثر می‌گذارد.
  37: 
  38: </div>
  39: 
  40: ```http
  41: POST /exports
  42: Idempotency-Key: export-request-42
  43: Content-Type: application/json
  44: 
  45: {"report":"monthly-sales","month":"2026-10"}
  46: 
  47: HTTP/1.1 202 Accepted
  48: Location: /jobs/job-42
  49: Content-Type: application/json
  50: 
  51: {"job_id":"job-42","state":"queued","status_url":"/jobs/job-42"}
  52: ```
  53: 
  54: ```text
  55: accept(request, user, idempotency_key):
  56:     authenticate_and_validate(request, user)
  57:     transaction:
  58:         return_existing_job_if_same_key_and_same_payload(user, idempotency_key)
  59:         reject_key_reuse_with_different_payload()
  60:         reserve_bounded_intake_slot_or_reject()
  61:         insert_job(job_id, owner_id, state="queued", deadline, payload_version)
  62:         commit
  63:     return 202, job_status_url
  64: 
  65: worker():
  66:     job = atomically_claim_due_job_with_expiring_lease()
  67:     if now > job.deadline: mark_expired(); return
  68:     result = generate_report_with_attempt_timeout(job)
  69:     write_result_to_deterministic_key(job.id, result)
  70:     mark_success_if_current_lease_owner(job.id, result.key)
  71: ```
  72: 
  73: <div dir="rtl" align="right">
  74: 
  75: این شبه‌کد، Job Store پایگاه داده را مستقیماً منبع کار Worker فرض می‌کند؛ Broker شرط آن نیست. کلید پذیرش باید با کاربر/مستأجر Scope شود و یکتایی آن را خود پایگاه داده اعمال کند. کنترل ظرفیت نیز باید در برابر پذیرش هم‌زمان اتمیک باشد؛ شمارش ساده قبل از درج کافی نیست. Endpoint وضعیت باید مالکیت کار را کنترل کند و `failed` را پشت یک وضعیت مبهمِ «در حال پردازش» پنهان نکند.
  76: 
  77: Lease باعث می‌شود پس از مرگ Worker کار قابل بازیابی باشد. اگر زمان اجرا از Lease بیشتر شود، Worker باید آن را تمدید کند؛ به‌روزرسانی نهایی به مالکیت و نسخه Lease وابسته است تا Worker قدیمی وضعیت Worker جدید را بازنویسی نکند. برای اثر بیرونی مثل ارسال ایمیل، نام فایل ثابت به تنهایی کافی نیست: از کلید Idempotency ارائه‌دهنده، سابقه اتمیک ارسال یا فرایند تطبیق نتیجه نامعلوم استفاده کنید.
  78: 
  79: اگر علاوه بر ثبت Job بخواهید به Broker نیز Publish کنید، دو Write مستقل، شکاف خرابی دارند: ممکن است ثبت موفق و ارسال ناموفق شود. در **Transactional Outbox**، Job و رکورد قصد ارسال را در یک تراکنش ذخیره و بعداً ارسال می‌کنید؛ Relay ممکن است دوباره ارسال کند، پس مصرف‌کننده همچنان باید تکرار را تحمل کند. [راهنمای رسمی AWS برای Transactional Outbox](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html) این مرز را توضیح می‌دهد.
  80: 
  81: ## ظرفیت، سن صف و Backpressure
  82: 
  83: اگر هر Worker یک Job چهارثانیه‌ای را اجرا کند، ظرفیت نظری ۴ Worker برابر یک Job در ثانیه است. این عدد با فرض نبود رقابت روی CPU، دیسک و پایگاه داده به دست آمده؛ ظرفیت واقعی باید سنجیده شود. برای نرخ ورود `λ` و نرخ تکمیل `μ`، در بازه‌ای که صف خالی نیست رشد تقریبی Backlog برابر `λ − μ` است.
  84: 
  85: وقتی ورود برای ۳۰ ثانیه، ۳ کار در ثانیه و تکمیل یک کار در ثانیه باشد، حدود ۶۰ کار اضافه باقی می‌ماند. پس از توقف کامل ورودی، تخلیه آن حدود ۶۰ ثانیه طول می‌کشد. اگر ورود به ۰٫۵ کاهش یابد، ظرفیت خالص تخلیه ۰٫۵ است و تقریباً ۱۲۰ ثانیه لازم می‌شود. این تقریب، تغییر اندازه کارها و زمان اتمام Jobهای در حال اجرا را ساده می‌کند.
  86: 
  87: **Queue Age** یعنی سن کار منتظر؛ سن قدیمی‌ترین کار معطل را جدا از زمان اجرای Job بسنجید. دو صف هم‌طول ممکن است زمان انتظار متفاوت داشته باشند. محدودیت تعداد و بایتِ کارهای پذیرفته‌شده، سهمیه هر مستأجر، مهلت کار و سقف هم‌زمانی Worker با هم Backpressure می‌سازند. در پذیرش بیش از بودجه، پاسخ متناسب با قرارداد مثل `429` برای سهمیه یا `503` برای ناتوانی موقت بدهید؛ پذیرشِ ظاهری و فراموش‌کردن کار، جایگزین نیست. [AWS: Fail fast and limit queues](https://docs.aws.amazon.com/wellarchitected/2023-04-10/framework/rel_mitigate_interaction_failure_fail_fast.html) هشدار می‌دهد Backlog طولانی می‌تواند به اجرای درخواست‌های کهنه برسد.
  88: 
  89: ## چه وقت مناسب است؟ هزینه تصمیم چیست؟
  90: 
  91: ساخت خروجی، تبدیل رسانه، ایندکس‌گذاری و اعلان‌هایی که تأخیرشان پذیرفتنی است گزینه‌های خوبی‌اند. نتیجه‌ای که همین صفحه برای ادامه کار لازم دارد یا کنترل موجودی‌ای که پیش از قبول سفارش باید قطعی شود، بدون تغییر قرارداد محصول قابل تعویق نیست. خروجیِ «بعداً» نیاز به UX وضعیت و شکست دارد. اجرای Worker روی همان ماشین API ممکن است CPU مشترک را اشباع کند؛ جدا شدن زمان اجرا به معنی جدا شدن منابع نیست.
  92: 
  93: Retry برای خطای موقت با Backoff، Jitter، سقف تعداد تلاش و مهلت کل مفید است. ورودی نامعتبر با Retry درست نمی‌شود. تکرارِ بی‌وقفه یک Job خراب یا افزایش Worker هنگام کندی پایگاه داده می‌تواند حادثه را تشدید کند. جزئیات بودجه زمانی در [درس Timeout و Retry](../../06-code-optimization/07-timeouts-and-retries/README.md) آمده است.
  94: 
  95: ## تمرین کوچک و مشاهده مورد انتظار
  96: 
  97: این تمرین محاسباتی است و نصب سرویس نمی‌خواهد. در یک جدول، ۱۲ Job چهارثانیه‌ای را هم‌زمان در زمان صفر وارد کنید. یک Worker و صف FIFO فرض کنید. برای هر Job، زمان شروع، انتظار و پایان را بنویسید. سپس همین جدول را برای ۳ Worker بازسازی کنید و بعد فرض کنید پایگاه داده ظرفیت اجرای هم‌زمان بیشتر از ۲ Job را ندارد.
  98: 
  99: **انتظار:** با یک Worker، پایان Job دوازدهم ۴۸ ثانیه و انتظار آن ۴۴ ثانیه است. با ۳ Worker مستقل و بدون گلوگاه، آخرین دسته در ثانیه ۱۲ شروع و در ۱۶ تمام می‌شود. فرض محدودیت پایگاه داده نشان می‌دهد عدد ۱۶ دیگر تضمین‌شده نیست؛ صف و رقابت باید در همان وابستگی نیز مدل شوند. پاسخ اولیه ۳۰ میلی‌ثانیه‌ای هیچ‌یک از این زمان‌های نتیجه را حذف نمی‌کند.
 100: 
 101: برای بررسی خرابی، Worker را در مدل درست بعد از نوشتن فایل و قبل از ثبت `succeeded` متوقف کنید. با منقضی شدن Lease، کار دوباره اجرا می‌شود. مشاهده مطلوب یک نتیجه منطقی با همان کلید است؛ اگر اعلان تکراری ایجاد می‌شود، طراحی اثر بیرونی هنوز کامل نیست.
 102: 
 103: ## شواهد واقعی: Meta Async، سال ۲۰۲۰
 104: 
 105: Meta در [روایت مهندسی Async](https://engineering.fb.com/2020/08/17/production-engineering/async/) توضیح می‌دهد صف مشترک و زمان‌بندی ساده باعث می‌شد یک Use Case بزرگ یا متوقف‌شده روی دیگران اثر بگذارد؛ افزودن Worker به تنهایی مسئله را حل نمی‌کرد. طراحی تکامل‌یافته از تحمل تأخیر، اولویت و صف‌های جدا برای Use Caseها استفاده می‌کرد. تیم همچنین سهمیه منابع و محدودیت نرخ پذیرش را برای کاهش اثر خطا و پیک ورودی افزود.
 106: 
 107: **برداشت آموزشی:** ظرفیت، عدالت میان کارها و مهلت، بخشی از طراحی Job هستند. این گزارش شاهد عمومی برای اهمیت زمان‌بندی و کنترل پذیرش است؛ اعداد مثال گزارش‌گیری این صفحه از Meta نیامده‌اند و معماری آن الزام سامانه کوچک نیست.
 108: 
 109: ## خطاهای رایج و سیگنال عملیاتی
 110: 
 111: | خطا | چه چیزی دیده می‌شود؟ | اقدام بررسی |
 112: | --- | --- | --- |
 113: | پاسخ قبل از ذخیره پایدار کار | شناسه پذیرفته‌شده بدون Job پس از Restart | بررسی مرز Commit و پاسخ |
 114: | صف نامحدود | رشد Age، فضای ذخیره و زمان نتیجه | محدودیت پذیرش، اولویت و برنامه تخلیه |
 115: | کار طولانی بدون تمدید Lease | اجرای هم‌زمان یک Job | تمدید، Fencing و Idempotency |
 116: | Retry خطای دائمی | تلاش زیاد با نرخ موفقیت ثابت یا صفر | طبقه‌بندی خطا و توقف در بودجه |
 117: | پایش فقط API | `p95` پاسخ خوب، نتیجه‌ها ساعت‌ها عقب | زمان انتها‌به‌انتها و قدیمی‌ترین Job |
 118: | مخلوط کردن کار فوری و حجیم | گرسنگی کار کوچک | صف/سهمیه جدا و بودجه منابع |
 119: 
 120: ## چک‌لیست عملیاتی
 121: 
 122: - [ ] مرز پذیرش پایدار، وضعیت‌های قابل مشاهده و سیاست نگهداری نتیجه مشخص است.
 123: - [ ] Deadline کل کار، Timeout هر تلاش و سقف Retry مستقل و هماهنگ‌اند.
 124: - [ ] توقف Process قبل/بعد از اثر جانبی، Lease و تکرار کار مرور شده‌اند.
 125: - [ ] Job ID و Trace ID در API، Scheduler و Worker قابل جست‌وجو هستند.
 126: - [ ] نرخ ورود/تکمیل، تعداد منتظر/در حال اجرا، Queue Age و خطای نهایی دیده می‌شوند.
 127: - [ ] سقف ظرفیت پذیرش، سهمیه مستأجر و روش بازگرداندن فشار به کلاینت معلوم است.
 128: - [ ] افزایش Worker ظرفیت وابستگی را رد نمی‌کند؛ روش Drain هنگام استقرار وجود دارد.
 129: - [ ] شکست نهایی، انقضا، پاک‌سازی نتیجه و مالک رسیدگی عملیاتی تعریف شده‌اند.
 130: 
 131: ## آزمون کوتاه
 132: 
 133: ۱. تفاوت `async/await` داخل درخواست و یک Job پایدار چیست؟
 134: 
 135: ۲. در مثال ۳۰ میلی‌ثانیه پذیرش و ۴۰۳۰ میلی‌ثانیه کار بعدی، انتظار صف دوثانیه‌ای چه اثری روی پاسخ اولیه و نتیجه دارد؟
 136: 
 137: ۳. با نرخ ورود ۵ و تکمیل ۳ کار در ثانیه، در ۲۰ ثانیه چه مقدار Backlog اضافه می‌شود؟
 138: 
 139: ۴. چرا «ابتدا بررسی کن Job با این کلید وجود ندارد، سپس درج کن» برای Idempotency کافی نیست؟
 140: 
 141: ۵. اگر Worker بعد از ارسال اعلان و قبل از ثبت موفقیت بمیرد، چرا Retry خطر دارد؟
 142: 
 143: ۶. چرا افزایش Worker هنگام کندی پایگاه داده همیشه مشکل را حل نمی‌کند؟
 144: 
 145: ۷. یک خطای اعتبارسنجی دائمی در Job را چطور مدیریت می‌کنید؟
 146: 
 147: <details>
 148: <summary>پاسخ‌نامه توضیحی</summary>
 149: 
 150: ۱. اولی معمولاً عمر همان درخواست را دارد و فقط انتظار I/O را غیرمسدودکننده می‌کند. Job سابقه مستقل، وضعیت و بازیابی پس از توقف Process می‌خواهد؛ کلید تفاوت، جدایی چرخه عمر و دوام است.
 151: 
 152: ۲. با فرض ثابت بودن پذیرش، پاسخ اولیه همچنان حدود ۳۰ میلی‌ثانیه است، ولی نتیجه از حدود ۴۰۶۰ به ۶۰۶۰ میلی‌ثانیه می‌رسد. انتظار حذف نشده و به صف منتقل شده است.
 153: 
 154: ۳. حدود ۴۰ کار: اختلاف نرخ ۲ ضرب در ۲۰. فرض، صف غیرخالی و ثابت بودن نرخ‌ها و ظرفیت است.
 155: 
 156: ۴. دو درخواست هم‌زمان می‌توانند هر دو نبودن رکورد را ببینند. قید یکتایی اتمیک، Scope کلید و بررسی تطابق Payload لازم‌اند؛ کلید تکراری با محتوای متفاوت باید رد شود.
 157: 
 158: ۵. اثر بیرونی ممکن است انجام شده باشد اما ثبت محلی آن معلوم نباشد. اجرای دوباره می‌تواند اعلان دوم بفرستد؛ کلید تکرارپذیری در مقصد یا تطبیق وضعیت و سیاست اثر جانبی لازم است.
 159: 
 160: ۶. Worker بیشتر ممکن است اتصال، Lock و I/O بیشتری روی گلوگاه مصرف کند. سقف هم‌زمانی باید با ظرفیت وابستگی هماهنگ و اثر تغییر اندازه‌گیری شود.
 161: 
 162: ۷. بدون Retry خودکار، شکست نهایی با علت امن ثبت می‌شود و کاربر/عملیات راه اصلاح داده یا ارسال مجدد کنترل‌شده دارد. تکرار همان ورودی درمان خطای دائمی نیست.
 163: 
 164: </details>
 165: 
 166: ## منابع منتخب
 167: 
 168: - **فارسی، مکمل آموزشی:** [کار با RabbitMQ — علی ثابت](https://alixsabet.com/fa/posts/2025/02/rabbitmq/)؛ توضیح قابل‌فهم سناریوی ساخت PDF در پس‌زمینه و واژگان تولیدکننده/مصرف‌کننده. آموزش است، شاهد Production نیست؛ این درس Job را مستقل از الزام به RabbitMQ توضیح می‌دهد.
 169: - **انگلیسی، تجربه عملی:** [Meta Async](https://engineering.fb.com/2020/08/17/production-engineering/async/)؛ مطالعه بخش‌های زمان‌بندی، تحمل تأخیر و سهمیه.
 170: - **انگلیسی، مرجع رسمی:** [AWS Transactional Outbox](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html)؛ بررسی شکاف نوشتن پایگاه داده و انتشار پیام.
 171: - **انگلیسی، راهنمای عملیاتی:** [AWS Fail fast and limit queues](https://docs.aws.amazon.com/wellarchitected/2023-04-10/framework/rel_mitigate_interaction_failure_fail_fast.html)؛ هزینه Backlog و کارهای کهنه.
 172: 
 173: **ناوبری:** [فهرست فصل](../README.md) · [فهرست بسته](../../README.md) · [موضوع بعد: Message Brokers](../02-message-brokers/README.md) · [مرتبط: مقیاس‌دهی](../../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md) · [مرتبط: مسیر بحرانی](../../06-code-optimization/04-critical-paths/README.md)
 174: 
 175: </div>

## Snapshot: Backend Performace/03-asynchronism/02-message-brokers/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # ۳.۲ — واسطه‌های پیام | Message Brokers
   4: 
   5: Message Broker واسطه‌ای برای دریافت، مسیریابی و تحویل پیام میان تولیدکننده و مصرف‌کننده است. پیام می‌تواند دستور انجام کار یا خبر وقوع یک رویداد باشد. Broker امکان جدایی زمانی و کنترل جریان را فراهم می‌کند؛ ضمانت نتیجه نهایی و قواعد کسب‌وکار همچنان به برنامه وابسته‌اند.
   6: 
   7: **تاریخ بررسی منابع: <span dir="ltr">2026-11-10</span>.** مفاهیم عمومی مستقل از فروشنده‌اند؛ جزئیات `Exchange`، `Ack` و `Prefetch` در این صفحه با RabbitMQ و AMQP 0-9-1 مثال زده می‌شوند. این رفتارها را بدون بررسی به همه Brokerها و پروتکل‌ها تعمیم ندهید.
   8: 
   9: ## خروجی‌های یادگیری
  10: 
  11: - تفاوت Work Queue، انتشار برای چند مشترک و Log قابل بازخوانی را توضیح می‌دهید.
  12: - مرز Publish، تأیید Broker، تحویل و اتمام پردازش را از هم جدا می‌کنید.
  13: - پیام تکراری، ترتیب، Idempotency و Retry را با مثال خرابی تحلیل می‌کنید.
  14: - Backpressure را هم در پذیرش تولیدکننده و هم در مصرف Worker اعمال می‌کنید.
  15: - درباره هزینه عملیاتی Broker در برابر فراخوانی مستقیم یا Job Store تصمیم می‌گیرید.
  16: 
  17: ## مدل ذهنی: مرزها و الگوها
  18: 
  19: در ارتباط مستقیم، گیرنده معمولاً باید هنگام درخواست در دسترس باشد. Broker می‌تواند پیام را طبق سیاست نگهداری حفظ کند تا مصرف‌کننده بعداً پردازش کند؛ این جدایی، نیاز به قرارداد داده و مشاهده‌پذیری را بیشتر می‌کند. اگر تولیدکننده بلافاصله منتظر پاسخ نهایی مصرف‌کننده شود، مسیر حساس به تأخیر هنوز به آن پردازش وابسته است؛ صرف عبور از Broker آن را کوتاه نمی‌کند.
  20: 
  21: | الگو | تقسیم کار | مناسب برای | هزینه/محدودیت |
  22: | --- | --- | --- | --- |
  23: | Work Queue | چند Worker روی یک صف؛ هر تحویل به یک مصرف‌کننده | تقسیم اجرای کارهای مستقل | تکرار پس از خرابی و ترتیب تکمیل |
  24: | Pub/Sub با صف‌های مجزا | هر سرویس صف/اشتراک خودش را دارد | اطلاع‌رسانی به اعلان و تحلیل هم‌زمان | ظرفیت، خطا و تأخیر جدا برای هر مشترک |
  25: | Log با Offset و Retention | خواننده موقعیت خواندن را نگه می‌دارد | بازخوانی و جریان رویداد | مدیریت Lag، نگهداری و قرارداد ترتیب |
  26: 
  27: یک صف مشترک برای دو سرویس مستقل، معمولاً پیام را بین آن‌ها تقسیم می‌کند؛ هر دو الزاماً همه رویدادها را نمی‌بینند. برای دو واکنش مستقل، صف/اشتراک جدا بسازید. RabbitMQ علاوه بر Queue، ساختار Stream نیز دارد؛ انتخاب نام محصول به تنهایی مدل مصرف و بازخوانی را مشخص نمی‌کند. [مستند رسمی Queues](https://www.rabbitmq.com/docs/queues) تفاوت ساختارها و اثر اولویت و Requeue بر ترتیب را معرفی می‌کند.
  28: 
  29: </div>
  30: 
  31: ```mermaid
  32: flowchart LR
  33:     P[Producer] --> X[Exchange: order events]
  34:     X --> N[Notification queue]
  35:     X --> A[Analytics queue]
  36:     N --> W1[Notification worker 1]
  37:     N --> W2[Notification worker 2]
  38:     A --> W3[Analytics worker]
  39: ```
  40: 
  41: <div dir="rtl" align="right">
  42: 
  43: در RabbitMQ این مسیر با Binding و Routing Key تعریف می‌شود. نبود Binding صحیح می‌تواند پیام را بی‌مقصد کند. برای جریان حساس به رسیدن پیام به حداقل یک صف، رفتار `mandatory` و پیام برگشتی را بررسی کنید؛ دریافت Publisher Confirm را با درست بودن مقصد اشتباه نگیرید. [راهنمای Reliability در RabbitMQ](https://www.rabbitmq.com/docs/reliability) جزئیات این حالت را شرح می‌دهد.
  44: 
  45: ## تحویل، تأیید و ضمانت‌ها
  46: 
  47: سه نقطه را جدا ثبت کنید: پذیرش پیام نزد Broker، تحویل به مصرف‌کننده، و ثبت اثر موفق مصرف‌کننده. **Publisher Confirm** درباره تعامل تولیدکننده با Broker است؛ **Consumer Ack** درباره تعامل Broker با مصرف‌کننده. اولی نشان نمی‌دهد کار نهایی موفق شده است. در تأیید دستی، Ack را پس از نقطه موفقیت تعریف‌شده بفرستید؛ Ack زودهنگام و سپس مرگ Worker می‌تواند به حذف کاری برسد که کامل نشده است. این جدایی در [مستند رسمی Confirms و Acknowledgements](https://www.rabbitmq.com/docs/confirms) آمده است.
  48: 
  49: | ضمانت | معنی در مرز تعریف‌شده | پیامد برای برنامه |
  50: | --- | --- | --- |
  51: | At-most-once | پیام ممکن است نرسد، اما تحویل مجدد در همان قرارداد انجام نمی‌شود | برای داده قابل‌ازدست‌رفتن قابل بررسی است |
  52: | At-least-once | با فرض رعایت دوام، بازیابی و سیاست نگهداری، تحویل مجدد برای پیام تأییدنشده ممکن است | اثر تکراری را باید کنترل کرد |
  53: | Exactly-once در یک محدوده | یک ابزار ممکن است در محدوده مشخص خود تکرار را مهار کند | اثر بیرونی خارج از آن محدوده را جدا تحلیل کنید |
  54: 
  55: عبارت Exactly-once به تنهایی تضمین «یک ایمیل، یک برداشت وجه و یک نوشتن در هر سیستم» نیست. اگر Worker اثر را Commit کند و پیش از Ack قطع شود، Broker از اتمام اثر خبر ندارد. همین شکاف، نیاز به Idempotency را توضیح می‌دهد.
  56: 
  57: Queue پایدار، Persistent بودن پیام، Replication و سیاست Confirm اجزای متفاوت دوام‌اند. فقط `durable=true` را به معنی ماندگاری همه پیام‌ها در تمام خرابی‌ها نگیرید؛ نوع Queue، پیام، تأیید، نگهداری و رفتار Failover را با [راهنمای Queues](https://www.rabbitmq.com/docs/queues) و قرارداد نسخه انتخابی مرور کنید.
  58: 
  59: ## مثال حل‌شده: رویداد تأیید سفارش
  60: 
  61: مثال آموزشی زیر رویدادی است که پس از ثبت سفارش منتشر می‌شود. شناسه رویداد برای همه تلاش‌های انتشار همان رویداد ثابت می‌ماند. `correlation_id` برای ردیابی است و جای شناسه تکرارپذیری را نمی‌گیرد. شماره نسخه Schema به مصرف‌کننده کمک می‌کند پیام ناشناخته را آگاهانه رد یا قرنطینه کند.
  62: 
  63: </div>
  64: 
  65: ```json
  66: {
  67:   "event_id": "evt-204",
  68:   "type": "order.confirmed",
  69:   "schema_version": 1,
  70:   "occurred_at": "2026-11-10T08:00:00Z",
  71:   "correlation_id": "request-91",
  72:   "order_id": "order-204",
  73:   "order_version": 3
  74: }
  75: ```
  76: 
  77: ```text
  78: consume(event):
  79:     validate_supported_schema(event)
  80:     transaction:
  81:         inserted = insert_processed_id_if_absent(
  82:             consumer="analytics-v1", event_id=event.event_id)
  83:         if inserted:
  84:             apply_local_analytics_update(event)
  85:         commit
  86:     ack_delivery()
  87: ```
  88: 
  89: <div dir="rtl" align="right">
  90: 
  91: جدول شناسه‌های پردازش‌شده باید قید یکتا روی زوج مصرف‌کننده و رویداد داشته باشد و ثبت آن همراه با اثر محلی در یک تراکنش باشد. در غیر این صورت، «شناسه ثبت شد ولی اثر انجام نشد» یا اثر دوباره رخ می‌دهد. نگهداری شناسه‌ها باید با افق Replay و تأخیر محتمل هماهنگ شود؛ حذف زودهنگام، راه تکرار اثر را باز می‌کند. برای ایمیل یا API بیرونی، این تراکنش محلی اثر مقصد را اتمیک نمی‌کند؛ کلید Idempotency مقصد یا فرایند بازیابی نتیجه نامعلوم لازم است.
  92: 
  93: اکنون خطا را مرحله‌ای ببینید:
  94: 
  95: ۱. تولیدکننده Publish می‌کند، Broker می‌پذیرد، ولی Confirm در شبکه گم می‌شود. تولیدکننده نمی‌داند پیام رسیده یا نه و ممکن است با همان `event_id` دوباره بفرستد.
  96: 
  97: ۲. مصرف‌کننده Commit می‌کند و پیش از Ack می‌میرد. پیام دوباره تحویل می‌شود؛ درج یکتا در اجرای دوم انجام نمی‌شود، اثر تکرار نمی‌شود و سپس Ack فرستاده می‌شود.
  98: 
  99: ۳. اگر Ack پیش از Commit فرستاده شده بود، مرگ Worker می‌توانست اثر را از بین ببرد. پس ترتیب مرزها، قرارداد واقعی را می‌سازد.
 100: 
 101: [RabbitMQ Reliability Guide](https://www.rabbitmq.com/docs/reliability) احتمال تکرار در بازیابی و نیاز به مصرف‌کننده Idempotent را صریح توضیح می‌دهد. این مثال فقط اثر محلیِ تراکنشی را پوشش می‌دهد. برای شکاف ثبت سفارش و انتشار رویداد، [توضیح Outbox در درس کارهای پس‌زمینه](../01-background-jobs/README.md) را ببینید.
 102: 
 103: ## Backpressure، Retry و ترتیب
 104: 
 105: **Prefetch** تعداد پیام‌های تحویل‌داده‌شده ولی Ackنشده را محدود می‌کند. برای یک مصرف‌کننده RabbitMQ با سقف ۱۰، پس از ۱۰ پیام Ackنشده تحویل تازه منتظر آزاد شدن ظرفیت می‌ماند؛ مقدار صفر یعنی بی‌حد. این سقف را با هم‌زمانی اجرای واقعی اشتباه نگیرید: Worker با یک Thread ممکن است ۱۰ پیام در حافظه داشته باشد ولی یکی را اجرا کند. [مستند Consumer Prefetch](https://www.rabbitmq.com/docs/consumer-prefetch) Scope هر مصرف‌کننده را توضیح می‌دهد؛ تنظیمات Channel و نسخه را بررسی کنید.
 106: 
 107: Prefetch فقط فشار تحویل به مصرف‌کننده را محدود می‌کند؛ جلوی ورود نامحدود به Broker را نمی‌گیرد. سقف پیام/بایت، محدودیت نرخ Publish، ظرفیت Outbox و سیاست رد یا توقف پذیرش را در ورودی نیز مشخص کنید. در حالت پرشدن، رفتار Drop، Reject یا Dead-letter باید مطابق اهمیت پیام باشد و قابل مشاهده بماند. افزایش فضای دیسک تنها افق زمانی اشباع را عقب می‌برد، مگر ظرفیت تکمیل نیز به ورودی برسد.
 108: 
 109: برای خطای موقت، تلاش مجددِ با تأخیر، Backoff، Jitter و سقف بودجه تعریف کنید. Requeue فوریِ پیام خراب می‌تواند حلقه داغ بسازد و CPU و شبکه را مصرف کند. خطای Schema یا داده دائمی به محل قرنطینه مانند **Dead-letter Queue (DLQ)** می‌رود، اگر چنین مسیری پیکربندی شده باشد. DLQ موفقیت نیست: مالک، هشدار، علت و روش بازفرستادن کنترل‌شده لازم دارد. انتقال به DLQ و دوام آن نیز باید مطابق ابزار و نوع Queue بررسی شود.
 110: 
 111: ترتیب ورود به صف با ترتیب تکمیل اثرها یکی نیست. دو Worker می‌توانند نسخه ۴ سفارش را پیش از نسخه ۳ تمام کنند؛ Requeue و Priority نیز ترتیب مشاهده را تغییر می‌دهند. اگر ترتیب هر سفارش مهم است، از کلید سفارش برای تقسیم‌بندی/سری‌سازی و از `order_version` برای تشخیص پیام کهنه استفاده کنید. این کار موازی‌سازی یک کلید داغ را محدود می‌کند. تضمین ترتیب سراسری معمولاً هزینه بیشتری از ترتیب برای هر موجودیت دارد.
 112: 
 113: ## چه وقت Broker مناسب است؟
 114: 
 115: وقتی تولیدکننده و مصرف‌کننده باید مستقل در زمان اجرا یا استقرار باشند، چند واکنش مستقل به یک رویداد دارید، یا نوسان کوتاه‌مدت ورودی را می‌خواهید جذب کنید، Broker ارزش دارد. هزینه‌اش نگهداری سرویس، ظرفیت و ذخیره‌سازی، قرارداد Schema، خطای تحویل، امنیت و عیب‌یابی چندمرحله‌ای است. برای یک وظیفه ساده در همان برنامه، Job Store پایدار ممکن است کافی باشد. برای پاسخی که همین لحظه لازم است، درخواست مستقیم با Timeout روشن ممکن است ساده‌تر باشد. انتخاب را بر اساس نیاز و اندازه‌گیری انجام دهید.
 116: 
 117: ## تمرین کوچک و مشاهده مورد انتظار
 118: 
 119: یک آزمایش کاغذی با پیام `evt-204` انجام دهید. جدول سه ستون «سابقه processed»، «عدد شمارش سفارش» و «Ack ارسال شد» بسازید. ابتدا همه را خالی/صفر بگیرید. مصرف‌کننده را درست پس از Commit مثال و پیش از Ack قطع کنید؛ سپس همان پیام را دوباره تحویل بدهید.
 120: 
 121: **انتظار:** پس از تلاش اول، یک شناسه ثبت و شمارش یک شده است، ولی Ack ندارید. در تلاش دوم، قید یکتا اجازه اثر دوباره نمی‌دهد؛ شمارش یک می‌ماند و Ack ارسال می‌شود. اگر ثبت شناسه و شمارش را در دو تراکنش جدا قرار دهید، نقطه قطع میان آن‌ها را پیدا کنید و نشان دهید چه داده‌ای گم یا دوباره محاسبه می‌شود.
 122: 
 123: اکنون با فرض یک مصرف‌کننده و Prefetch برابر ۲، پنج پیام بفرستید و Ack را نگه دارید. باید حداکثر دو پیام در حال تحویل/Ackنشده و سه پیام آماده باقی بماند؛ پس از Ack یکی، یک پیام دیگر تحویل می‌شود. این مشاهده مربوط به مدل Push و تأیید دستی این مثال است. تعداد پیام آماده پایین، بدون بررسی پیام‌های Ackنشده و Age، دلیل سلامت نیست.
 124: 
 125: ## شواهد واقعی: صف کار Slack
 126: 
 127: Slack در [Scaling Slack’s Job Queue](https://slack.engineering/scaling-slacks-job-queue/) با انتشار اولیه ۲۰۱۷ و به‌روزرسانی ۲۰۲۰ توضیح می‌دهد وقتی نرخ Enqueue از Dequeue بیشتر می‌شد، حافظه Redis می‌توانست تمام شود و پذیرش کار مختل شود. تیم Kafka را پیش از Redis اضافه کرد و سرعت Relay را کنترل کرد تا فشار اجرای کار از پذیرش جدا شود. روایت همچنین انتخاب تاریخی تأیید Leader را توضیح می‌دهد که برای تأخیر کمتر، ریسک از دست رفتن بعضی کارها هنگام خرابی پیش از Replication را می‌پذیرفت.
 128: 
 129: **برداشت آموزشی:** نام Broker به تنهایی دوام را تعیین نمی‌کند؛ سیاست Ack، ذخیره‌سازی و ظرفیت هر مرحله باید با معنای کسب‌وکار هماهنگ باشد. این انتخاب تاریخی Slack توصیه‌ای برای سفارش مالی نیست. مثال `evt-204` و تمرین این صفحه داده Production Slack نیستند.
 130: 
 131: ## خطاهای رایج، سیگنال‌ها و بازبینی
 132: 
 133: | خطا | سیگنال | بررسی عملی |
 134: | --- | --- | --- |
 135: | Binding اشتباه | پیام برگشتی/بدون مقصد، فاصله Publish و مصرف | قرارداد مسیریابی و هشدار Return |
 136: | Confirm را موفقیت کسب‌وکار دانستن | تولیدکننده موفق، نتیجه غایب | وضعیت نتیجه و Ack مصرف‌کننده |
 137: | Prefetch یا هم‌زمانی نامحدود | RAM و Ackنشده‌ها زیاد، Consumer کند | سقف تحویل و سقف اجرا |
 138: | حلقه Requeue | نرخ تحویل بالا، تکمیل پایین | Retry با تأخیر و قرنطینه |
 139: | Schema ناسازگار | DLQ یا Reject پس از استقرار | سازگاری نسخه و انتشار تدریجی |
 140: | صف مشترک برای دو سرویس مستقل | هر سرویس تنها بخشی از پیام‌ها را دارد | اشتراک جدا برای هر مسئولیت |
 141: 
 142: ## چک‌لیست عملیاتی
 143: 
 144: - [ ] معنای هر پیام، Schema، مالک و سیاست سازگاری تعریف شده است.
 145: - [ ] سیاست Publish ناموفق/نامعلوم، Confirm و پیام بی‌مقصد مستند است.
 146: - [ ] Ack پس از اثر موردنظر است و تکرار/اجرای هم‌زمان اثر را خراب نمی‌کند.
 147: - [ ] دوام پیام، نوع Queue، Replication و محدودیت Retention با نیاز هماهنگ‌اند.
 148: - [ ] نرخ Publish/تحویل/تکمیل، Ready، Unacked، Age/Lag و فضای دیسک دیده می‌شوند.
 149: - [ ] ظرفیت پذیرش، Prefetch و هم‌زمانی Worker هر سه محدودند.
 150: - [ ] Retry بودجه دارد؛ DLQ مالک، هشدار و روش Replay امن دارد.
 151: - [ ] قطع شبکه و مرگ Worker در دو طرف Commit و Ack تحلیل شده‌اند.
 152: - [ ] ترتیب موردنیاز در سطح موجودیت روشن است و با افزایش Consumer نقض نمی‌شود.
 153: - [ ] دسترسی Publish/Consume حداقلی است؛ اطلاعات حساس فقط به اندازه نیاز در پیام قرار می‌گیرد.
 154: 
 155: ## آزمون کوتاه
 156: 
 157: ۱. اگر اعلان و تحلیل هر دو باید تمام رویدادها را بگیرند، یک صف با دو Consumer کافی است؟
 158: 
 159: ۲. Publisher Confirm دقیقاً چه چیزی را به ما نمی‌گوید؟
 160: 
 161: ۳. Commit موفق و قطع پیش از Ack چگونه به پیام تکراری می‌رسد و مثال چگونه اثر آن را مهار می‌کند؟
 162: 
 163: ۴. آیا Prefetch برابر ۱۰ یعنی ۱۰ کار هم‌زمان اجرا می‌شوند؟ آیا جلوی رشد صف Broker را می‌گیرد؟
 164: 
 165: ۵. چرا `durable=true` به تنهایی یک ضمانت کامل دوام پیام نیست؟
 166: 
 167: ۶. با دو Worker، آیا FIFO بودن صف تضمین می‌کند نسخه ۳ پیش از نسخه ۴ تمام شود؟
 168: 
 169: ۷. یک پیام با نسخه Schema پشتیبانی‌نشده را بارها فوری Requeue کنیم یا سیاست دیگری لازم است؟
 170: 
 171: <details>
 172: <summary>پاسخ‌نامه توضیحی</summary>
 173: 
 174: ۱. خیر. Consumerهای یک Work Queue برای تقسیم کار رقابت می‌کنند. برای دریافت مستقل تمام رویدادها، هر مسئولیت صف/اشتراک خودش را می‌خواهد.
 175: 
 176: ۲. موفقیت پردازش مصرف‌کننده یا نتیجه نهایی کسب‌وکار را نمی‌گوید. Confirm مرز تولیدکننده و Broker را پوشش می‌دهد و از Consumer Ack جداست.
 177: 
 178: ۳. Broker Ack دریافت نکرده و ممکن است پیام را بازتحویل دهد. قید یکتا همراه با اثر محلی در یک تراکنش، اجرای اثر دوم را متوقف می‌کند؛ سپس تحویل تکراری Ack می‌شود.
 179: 
 180: ۴. خیر به هر دو. Prefetch سقف پیام Ackنشده در Scope مربوط است؛ هم‌زمانی اجرا را Worker تعیین می‌کند و ظرفیت ورودی Broker به محدودیت جدا نیاز دارد.
 181: 
 182: ۵. دوام Queue، دوام خود پیام، Replication، تأیید انتشار و سیاست نگهداری متفاوت‌اند. باید مجموعه تنظیمات و سناریوی خرابی بررسی شود، نه فقط یک پرچم.
 183: 
 184: ۶. خیر. زمان اجرای دو Worker می‌تواند متفاوت باشد و ترتیب تکمیل عوض شود. ترتیب هر سفارش به سری‌سازی/تقسیم‌بندی و بررسی نسخه نیاز دارد.
 185: 
 186: ۷. خطای ناسازگاری غالباً با همان باینری و پیام درمان نمی‌شود. قرنطینه با علت، هشدار، اصلاح قرارداد و Replay کنترل‌شده مناسب‌تر است؛ Requeue فوری حلقه پرهزینه می‌سازد.
 187: 
 188: </details>
 189: 
 190: ## منابع منتخب
 191: 
 192: - **فارسی، آموزش عملی:** [کار با RabbitMQ — علی ثابت](https://alixsabet.com/fa/posts/2025/02/rabbitmq/)؛ واژگان و جریان Producer، Exchange و Consumer. برای ضمانت‌های عملیاتی به مرجع رسمی رجوع کنید.
 193: - **فارسی، معرفی خدمات و کاربردها:** [RabbitMQ مدیریت‌شده — سکو کلود](https://sakoocloud.ir/databases/rabbitmq/)؛ آشنایی با کاربرد صف پیام در یک سرویس مدیریت‌شده. این صفحه معرفی تجاری است، معیار اثبات کارایی یا الزام انتخاب ارائه‌دهنده نیست.
 194: - **انگلیسی، مرجع رسمی:** [RabbitMQ Reliability](https://www.rabbitmq.com/docs/reliability)؛ بازتحویل، بازیابی، Idempotency و مسیریابی.
 195: - **انگلیسی، مرجع رسمی:** [Confirms و Consumer Acknowledgements](https://www.rabbitmq.com/docs/confirms)؛ مرز تأییدها و رفتار شکست.
 196: - **انگلیسی، مرجع رسمی:** [Consumer Prefetch](https://www.rabbitmq.com/docs/consumer-prefetch) و [Queues](https://www.rabbitmq.com/docs/queues)؛ محدودیت تحویل، نوع و دوام صف و ترتیب.
 197: - **انگلیسی، تجربه عملی:** [Scaling Slack’s Job Queue](https://slack.engineering/scaling-slacks-job-queue/)؛ تصمیم‌های ظرفیت، کنترل جریان و ضمانت تحویل در سامانه واقعی.
 198: 
 199: **ناوبری:** [موضوع قبل: کارهای پس‌زمینه](../01-background-jobs/README.md) · [فهرست فصل](../README.md) · [فهرست بسته](../../README.md) · [مرتبط: Timeout و Retry](../../06-code-optimization/07-timeouts-and-retries/README.md) · [مرتبط: پایش](../../07-monitoring-and-logging/01-metrics-logs-and-traces/README.md) · [فصل بعد: پایگاه داده](../../04-databases/README.md)
 200: 
 201: </div>
