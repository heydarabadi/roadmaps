<div dir="rtl" align="right">

# ۶.۷ — Timeout، Deadline و Retry

**زبان:** فارسی · [English version](../../../../en/backend-performance/06-code-optimization/07-timeouts-and-retries/README.md)


Timeout حد انتظار یک عملیات است؛ Deadline آخرین زمان مجاز برای تمام کار یک درخواست است. Retry یک تلاش تازه برای عملیاتی با شکست احتمالی موقت است. این ابزارها با آزاد کردن منابع و تحمل خطا کمک می‌کنند، ولی تکرار بی‌حد می‌تواند سرویس در حال اشباع را از پا درآورد.

**هدف یادگیری:** تقسیم بودجهٔ سرتاسری، محدود کردن تعداد/زمان تلاش، استفاده از backoff و jitter، و تکرار side effect فقط با قرارداد idempotency. پیش‌نیاز: HTTP، خطای شبکه و فراخوانی سرویس. بررسی منابع: **۲۰۲۶-۱۱-۱۰**.

## پیش‌نیازهای همین درس

Timeout بیشترین مدتی است که یک عملیات اجازه دارد منتظر بماند. Deadline زمان نهایی مشترک برای صف، تلاش‌ها، مکث‌ها و ساخت پاسخ است. خطای موقت ممکن است با تلاش دوباره برطرف شود؛ خطای اعتبارسنجی معمولاً نه. Idempotency یعنی تکرار همان عملیات با همان شناسه، اثر کسب‌وکاری تازه‌ای نسازد. Jitter بخش تصادفی به تأخیر Retry می‌افزاید تا کلاینت‌ها هم‌زمان دوباره تلاش نکنند.

## مدل ذهنی و سیاست

| مفهوم | چه چیزی را محدود می‌کند؟ | نکته |
| --- | --- | --- |
| Connection timeout | انتظار ایجاد اتصال | پوشش DNS/TLS به کتابخانه وابسته است |
| Per-attempt timeout | طول یک تلاش | از بودجهٔ باقی‌مانده بیشتر نیست |
| Overall deadline | مجموع صف، تلاش، backoff و پاسخ | در همهٔ لایه‌ها منتقل می‌شود |
| Retry budget | تعداد/نسبت تلاش اضافی | هنگام overload بار را مهار می‌کند |
| Backoff + Jitter | فاصله و هم‌زمانی تلاش‌ها | تلاش فوریِ هماهنگ را پخش می‌کند |

[AWS Builders’ Library](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/) تجربهٔ Amazon را دربارهٔ خطای موقت، انتخاب timeout با latency پایین‌دست، محدود کردن Retry و پراکندن تلاش‌ها شرح می‌دهد. مقدار بسیار کم، false timeout و ترافیک اضافه می‌سازد؛ مقدار بسیار زیاد منابع را مشغول نگه می‌دارد. عدد ثابت جهانی وجود ندارد.

[gRPC Deadlines](https://grpc.io/docs/guides/deadlines/) توضیح می‌دهد Deadline چگونه انتظار کلاینت را محدود می‌کند و انتقال آن به پایین‌دست به زبان/تنظیم وابسته است. لغو دریافت‌شده باید کار برنامه را هم متوقف کند؛ بازگشت خطا به کلاینت به‌خودی‌خود اثبات توقف همهٔ Queryها و side effectها نیست. برای محاسبهٔ زمان محلی از ساعت monotonic استفاده کنید؛ انتقال زمان باقی‌مانده باید طبق پروتکل/کتابخانه باشد تا اختلاف ساعت خام مشکل نسازد.

## مثال حل‌شده: بودجهٔ ۶۰۰ ms

**فرض آموزشی:** از ورود تا پاسخ ۶۰۰ ms بودجه داریم. احراز مجوز ۵۰ ms مصرف کرده و ۵۰ ms برای Encode/ارسال ذخیره می‌کنیم؛ برای وابستگی و انتظار آن حداکثر ۵۰۰ ms می‌ماند.

| بخش | سقف فرضی | مجموع مصرف در حالت بد |
| --- | ---: | ---: |
| تلاش اول | ۲۰۰ ms | ۲۰۰ ms |
| backoff با jitter | حداکثر ۱۰۰ ms | ۳۰۰ ms |
| تلاش دوم | ۱۵۰ ms | ۴۵۰ ms |
| حاشیهٔ بررسی/هماهنگی | ۵۰ ms | ۵۰۰ ms |

«دو تلاش» شامل تلاش اول است، نه دو Retry پس از آن. پیش از خواب و پیش از تلاش دوم، زمان باقی‌مانده را دوباره بررسی کنید؛ اگر صف قبلی بودجه را مصرف کرده است، سقف‌ها باید کوتاه شوند یا تلاش لغو شود. حاشیه‌های بالا صرفاً مدل‌اند؛ Scheduler تضمین زمانی سخت نمی‌دهد.

<div dir="ltr" align="left">

```text
for attempt in 1..max_attempts:
    remaining = deadline - monotonic_now() - response_reserve
    if remaining < minimum_useful_attempt: stop
    timeout = min(attempt_limit[attempt], remaining)
    result = call(timeout, cancellation, idempotency_key)
    if success: return result
    if not retryable(result) or not safe_to_repeat: stop
    if attempt == max_attempts: stop
    cap = min(max_backoff, base * 2^(attempt - 1))
    delay = random_uniform(0, cap)  # full jitter
    if delay + minimum_useful_attempt > remaining_now(): stop
    sleep_cancellable(delay)
```

</div>

تعداد تلاش و delay باید overflow و مقدارهای نامعتبر را هم کنترل کنند. این شبه‌کد تعریف عمومی سیاست است؛ از Retry داخلی Driver/SDK مطلع باشید تا دوبار روی هم اجرا نشوند. اگر در پنج لایه هرکدام سه تلاش باشد، بدترین تعداد فراخوانی پایین‌ترین لایه برای یک درخواست می‌تواند `3^5 = 243` شود؛ یک لایهٔ مسئول Retry و بودجهٔ مشترک انتخاب کنید.

## تکرار امن و نتیجهٔ نامعلوم

Timeout می‌تواند پس از اعمال عملیات رخ دهد. برای پرداخت، «پاسخی نگرفتم» به معنی «پرداخت انجام نشد» نیست. Idempotency باید با کلید پایدارِ همان عملیات، ثبت پایدار نتیجه و کنترل رقابت طراحی شود؛ key جدید در هر تلاش dedup را از بین می‌برد. همان کلید با payload متفاوت باید رد یا طبق قرارداد صریح رسیدگی شود. مدت نگه‌داری کلید باید پنجرهٔ تکرار واقعی را پوشش دهد. برای عمل نامعلوم، lookup وضعیت/آشتی‌دادن نتیجه ممکن است از تکرار کور بهتر باشد.

خطای validation/مجوز را خودکار تکرار نکنید. بعضی overloadها یا خطاهای موقت فقط طبق قرارداد سرویس قابل‌تکرارند؛ `Retry-After` و محدودیت نرخ را در بودجهٔ کل در نظر بگیرید. Jitter مجوز Retry نامحدود نیست. خواندن نیز اگر باعث محاسبهٔ گران یا side effect پنهان شود رایگان نیست.

## تمرین و انتظار

ده کلاینت فرضی در یک لحظه شکست می‌خورند. یک بار همه بعد از دقیقاً ۱۰۰ ms تلاش کنند؛ بار دیگر delayهای تصادفی بین صفر و ۱۰۰ ms را روی خط زمان رسم کنید. **راه‌حل:** در حالت ثابت، هر ده Retry در همان لحظه به مقصد می‌رسند؛ با Jitter، هرکدام زمانی در بازهٔ صفر تا ۱۰۰ ms انتخاب می‌کند، پس قله پخش می‌شود اما همچنان تا ده تلاش رخ می‌دهد. سپس در بودجهٔ مثال ۱۲۰ ms تأخیر صف اضافه کنید: از <span dir="ltr">500 ms</span> بودجهٔ وابستگی فقط <span dir="ltr">380 ms</span> می‌ماند، درحالی‌که <span dir="ltr">200 + 100 + 150 = 450 ms</span> نیاز است. بنابراین باید تلاش دوم کوتاه شود یا حذف شود؛ Deadline نهایی از نو آغاز نمی‌شود.

## شاهد واقعی

در همان مقالهٔ **۲۰۱۹** [AWS](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)، timeout کوتاهی که ایجاد اتصال امن تازه را هم شامل می‌شد، پس از deployment مشکل ایجاد می‌کرد؛ آماده کردن اتصال‌ها پیش از دریافت ترافیک راهکار گزارش‌شده بود. درس آن بررسی دقیق پوشش timeout است؛ عدد مقاله تنظیم پیشنهادی عمومی نیست. مثال ۶۰۰ ms این درس مستقل و فرضی است.

## شکست‌ها و علائم

| شکست | علامت | بازبینی |
| --- | --- | --- |
| Retry چندلایه | calls/request و خطا باهم رشد می‌کنند | retry owner و budget مشترک |
| timeout خیلی کم | false timeout و تکرار زیاد | توزیع latency، شبکه و پوشش اتصال |
| Deadline فقط در لبه | کار پس از پاسخ خطا ادامه دارد | propagation و توقف کار پایین‌دست |
| تکرار write با key تازه | side effect تکراری | کلید ثابت و نتیجهٔ پایدار |
| backoff بدون jitter | موج‌های منظم بار | delay تصادفی محدود و cancellation |

### چک‌لیست عملیاتی

- [ ] بودجه شامل صف، اتصال، درخواست، backoff و تحویل پاسخ است.
- [ ] معنای «حداکثر تلاش» و خطاهای retryable مشخص است.
- [ ] Retryهای SDK/Proxy/Driver شمارش شده‌اند.
- [ ] Deadline و cancellation تا کار واقعی منتقل می‌شوند.
- [ ] idempotency، رقابت، payload و عمر کلید روشن‌اند.
- [ ] attempts/request، timeout، success-after-retry و بار پایین‌دست پایش می‌شوند.

## آزمون

1. تفاوت Deadline سرتاسری با timeout هر تلاش چیست؟
2. چرا timeout پرداخت، شکست قطعی آن را ثابت نمی‌کند؟
3. پنج لایه با سه تلاش، در بدترین حالت چند فراخوانی پایین‌دست می‌سازند؟
4. Jitter چه چیزی را کم می‌کند و چه چیزی را کم نمی‌کند؟
5. چرا کلید idempotency نباید در هر Retry عوض شود؟
6. اگر فقط ۴۰ ms بودجه مانده و حداقل تلاش مفید ۷۰ ms است، چه باید کرد؟

### پاسخ تشریحی

1. Deadline کل مسیر و همهٔ تلاش‌ها/انتظارها را محدود می‌کند؛ timeout یک تلاش فقط همان بخش را محدود می‌کند.
2. ممکن است سرور عملیات را انجام داده و پاسخ گم یا دیر شده باشد؛ نتیجه نامعلوم است و باید قابل‌استعلام/تکرار امن باشد.
3. ۲۴۳؛ ضریب تلاش‌ها در لایه‌ها ضرب می‌شود و اختلال را تشدید می‌کند.
4. هم‌زمانی و قلهٔ تلاش‌ها را پخش می‌کند؛ تعداد تلاش‌ها یا هزینهٔ واقعی هر تلاش را خودبه‌خود کم نمی‌کند.
5. سیستم باید تکرار همان عملیات را تشخیص دهد؛ key تازه مثل عملیات تازه دیده می‌شود.
6. تلاش تازه شروع نکنید؛ بودجه کافی نیست. خطای کنترل‌شده یا رفتار جایگزینِ مجاز قرارداد لازم است.

## جمع‌بندی

یک Deadline سرتاسری را به پایین‌دست منتقل و با زمان باقی‌مانده timeout هر تلاش را تعیین کنید. Retry را فقط برای خطای مجاز و عملیات امن، با سقف تلاش/زمان و jitter انجام دهید. در Timeout نوشتن، نتیجه ممکن است نامعلوم باشد؛ همان کلید idempotency و راه استعلام نتیجه را حفظ کنید.

## منابع تکمیلی اختیاری

برای فهم این درس یا حل تمرین، بازکردن پیوندهای زیر لازم نیست؛ آن‌ها برای مطالعهٔ بیشتر و بررسی قراردادهای رسمی هستند.

- [فارسی: الگوی Retry Timeout — Go فارسی](https://book.gofarsi.ir/chapter-9/concurrency-patterns/go-concurrency-pattern-retry-timeout/): نمونهٔ وابسته به Go و context برای timeout/لغو؛ سیاست تولید نیازمند بودجه و idempotency این درس است.
- [English: AWS Timeouts, retries and backoff with jitter](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/): تجربهٔ عملی خطا، انتخاب حد انتظار و جلوگیری از تشدید بار.
- [English: AWS retry with backoff pattern](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/retry-backoff.html): idempotency، خطای موقت و هزینهٔ Backoff؛ مثال‌ها وابسته به الگوی فراخوانی‌اند.
- [English: Microsoft HTTP resilience in .NET](https://learn.microsoft.com/en-us/dotnet/core/resilience/http-resilience): نمونهٔ زنجیرهٔ Rate Limit، Timeout کلی/تلاش و Retry برای HttpClient؛ مقادیر پیش‌فرض فقط برای همان پشته‌اند.
- [English: AWS Well-Architected guidance on limiting retries](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/rel_mitigate_interaction_failure_limit_retries.html): Jitter، سقف تلاش و انتخاب یک لایهٔ مسئول Retry برای مهار amplification؛ دستورالعمل AWS را با قرارداد سرویس خود تطبیق دهید.
- [English: gRPC Deadlines](https://grpc.io/docs/guides/deadlines/): رفتار Deadline، propagation و مسئولیت توقف کار؛ تنظیم به زبان وابسته است.

**ناوبری:** [فصل ۶](../README.md) · [فهرست اصلی](../../README.md) · [قبلی: تجزیهٔ سرویس](../06-service-decomposition/README.md) · [بعدی: Batching](../08-batching-and-round-trips/README.md)

**مرتبط:** [Connection reuse](../../10-network/02-connection-reuse/README.md) · [Message brokers](../../03-asynchronism/02-message-brokers/README.md) · [Throttling](../../08-security/03-throttling-and-rate-limiting/README.md)

</div>
