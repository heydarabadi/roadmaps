# کتابچهٔ عملی و قالب‌های آماده

**زبان:** فارسی · [English](../en/10-playbook-and-templates/README.md)

این فایل، مطالب فصل‌ها را به کاری تبدیل می‌کند که می‌توانی کنار یک PR واقعی انجام دهی. قالب‌ها را با policy و زبان تیم خودت تطبیق بده.

## قالب شرح PR

<pre dir="ltr"><code>## What
What user-visible or system behavior changes?

## Why
Which issue or requirement does this solve?

## How to verify
- Tests run:
- Manual verification:
- Screenshots or benchmark:

## Risks and rollout
- Data, API, security, performance, compatibility:
- Rollout / feature flag:
- Rollback or recovery:

## Reviewer focus
- Please check:
- Open questions:
</code></pre>

### چطور این قالب را پر کنی؟

- بخش What را از نتیجهٔ تغییر بنویس، نه فهرست فایل‌ها.
- بخش Why را به issue یا تصمیم محصول وصل کن؛ «درخواست مدیر» rationale نیست.
- فقط تست‌هایی را بنویس که واقعاً اجرا کرده‌ای و revision درست را پوشش می‌دهند.
- risk را پنهان نکن؛ اگر چیزی آزموده نشده، محدودیت را دقیق بگو.
- reviewer focus را به یک یا دو سؤال مرتبط با دامنه محدود کن.
- screenshot را از دادهٔ ساختگی یا بی‌خطر بساز.

## چک‌لیست نویسنده پیش از review

### هدف و دامنه

- [ ] یک هدف اصلی و معیار پذیرش روشن دارم.
- [ ] تغییرهای نامرتبط جدا شده‌اند.
- [ ] API، schema، config، dependency و rollout را مشخص کرده‌ام.
- [ ] تصمیم یا trade-off غیرقابل‌دیدن در کد را توضیح داده‌ام.

### کیفیت تغییر

- [ ] استاندارد و معماری مخزن را رعایت کرده‌ام.
- [ ] تست شکست/حالت مرزی مناسب را اضافه کرده‌ام.
- [ ] تست‌های مرتبط روی آخرین تغییر اجرا شده‌اند.
- [ ] مستندات و runbook متأثر به‌روزند.
- [ ] log، secret، debug code و فایل تصادفی باقی نمانده است.
- [ ] ریسک security، performance، data و compatibility را بررسی کرده‌ام.

### درخواست review

- [ ] عنوان و شرح چیزی را می‌گویند که واقعاً تغییر کرده است.
- [ ] تست و محدودیت را دقیق گزارش کرده‌ام.
- [ ] سؤال‌های حل‌نشده را نوشته‌ام.
- [ ] بازبین/متخصص مناسب را انتخاب کرده‌ام.
- [ ] برای review زمان گذاشته‌ام و آمادهٔ پاسخ‌گویی‌ام.

## روش دوگذری بازبین

### گذر اول: فهم

1. شرح PR و issue را بخوان.
2. جمله‌ای بنویس که رفتار مورد انتظار را خلاصه کند.
3. فایل‌ها را دسته‌بندی کن: منطق، تست، config، migration، docs، dependency.
4. تغییر خارج از scope یا وابستگی پنهان را علامت بزن.
5. riskها را از نظر احتمال، شدت، blast radius و rollback رتبه‌بندی کن.

### گذر دوم: اعتبارسنجی

1. happy path و invariant اصلی را دنبال کن.
2. حالت خطا، مرز، retry، concurrency و data compatibility را بررسی کن.
3. تست‌های جدید را بخوان و بپرس آیا regression را می‌شکنند.
4. برای تغییر امنیتی، منبع تا sink و authorization را دنبال کن.
5. برای تغییر حساس، CI، اجرای محلی یا نظر متخصص را متناسب استفاده کن.
6. commentها را از blocker به suggestion مرتب کن.
7. در پایان خلاصهٔ وضعیت و محدودیت بررسی را بنویس.

اگر بازبینی از روی UI ابزار انجام می‌شود، پیش و پس از تغییر revision را بررسی کن و مطمئن شو کامنت به خط/نسخهٔ درستی متصل است.

## الگوی comment

<pre dir="ltr"><code>[severity]: [observed behavior] can cause [impact].
Could we [specific request or question]?
Evidence: [test, invariant, requirement, or reproduction].</code></pre>

### نمونه

<pre dir="ltr"><code>blocker: This query scopes only by order_id, so a signed-in user may read another tenant’s order.
Could we include the current tenant in the query and add a negative test for user A requesting user B’s order?
Evidence: the request identity is available from the authenticated context.</code></pre>

در متن فارسی هم همین چهار جزء را حفظ کن: شدت، رفتار، پیامد و درخواست. اگر evidence فرضی است، آن را به‌عنوان سؤال مطرح کن.

## چک‌لیست بازبین بر اساس نوع تغییر

| تغییر | پرسش‌های لازم |
|---|---|
| API | قرارداد، client قدیمی، null/default، خطا، pagination، versioning |
| Database | دادهٔ قدیمی، migration دو مرحله‌ای، index/lock، rollback/forward-fix |
| Auth | هویت از کجا می‌آید؟ مجوز به resource وصل است؟ negative test هست؟ |
| Dependency | چرا لازم است؟ منبع و license؟ lockfile و install script؟ |
| Performance | مسیر پرترافیک؟ حجم داده؟ complexity؟ query count؟ p95/p99؟ |
| Queue/background job | retry، duplicate، ordering، idempotency، dead-letter |
| Logging/monitoring | دادهٔ حساس حذف شده؟ metric قابل اقدام و owner دارد؟ |
| UI | حالت loading/error/empty، keyboard/accessibility، متن و screenshot |

## چک‌لیست بعد از review

- [ ] نویسنده به هر blocker یا سؤال پاسخ داده است.
- [ ] منطق اصلاح‌شده را در آخرین diff دیده‌ام.
- [ ] تست جدید واقعاً assertion مفید دارد.
- [ ] approval و status check مربوط به revision فعلی‌اند.
- [ ] policy تیم برای resolve و re-request رعایت شده.
- [ ] تغییر پراثر rollout، metric و rollback دارد.
- [ ] محدودیت‌هایی که بررسی نکردم را اعلام کرده‌ام.

## وضعیت‌ها و معنای پیشنهادی

| وضعیت | نویسنده چه می‌کند؟ | بازبین چه می‌کند؟ |
|---|---|---|
| سؤال باز | زمینه و شاهد را می‌آورد | ابهام را به سؤال مشخص تبدیل می‌کند |
| Blocker | اصلاح یا استدلال/تصعید | رفتار اصلاح‌شده را دوباره بررسی می‌کند |
| Suggestion | تصمیم می‌گیرد یا issue می‌سازد | مشخص می‌کند merge را متوقف نمی‌کند |
| Approval | revision را می‌فرستد | دامنهٔ بررسی را خلاصه می‌کند |
| CI شکست | علت را تشخیص و رفع می‌کند | مطمئن می‌شود نتیجه مربوط به آخرین revision است |

## منابع تکمیلی

- [GitHub: Helping others review your changes](https://docs.github.com/en/pull-requests/concepts/helping-others-review-your-changes)
- [GitHub: Resolving reviews](https://docs.github.com/en/pull-requests/concepts/resolving-reviews)
- [Google: CL descriptions](https://google.github.io/eng-practices/review/developer/cl-descriptions.html)
- [بازبینی کد؛ راهنمای فارسی](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
