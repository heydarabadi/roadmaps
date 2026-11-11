<div dir="rtl" align="right">

# IBM BPM و خودکارسازی فرایند

IBM BPM و پلتفرم‌های جانشین آن برای مدل‌سازی، اجرای workflow و هماهنگی کار انسانی/سیستمی به‌کار رفته‌اند. فرایند سازمانی ممکن است چند روز زنده بماند و منتظر approval، رویداد بیرونی یا timeout باشد؛ پس state، version، audit، escalation و compensation مهم‌اند.

workflow engine را برای منطق process استفاده کن و قواعد دامنه را به سرویس‌های مالک capability واگذار کن. نسخه‌بندی process هنگام اجرای instanceهای قدیمی، migration state، دسترس‌پذیری task و retry activity باید از قبل طرح شود. اگر فقط یک sequence کوتاه و ثابت داریم، abstraction ساده‌تر ممکن است.

## workflow engine در برابر orchestration داخل کد

Engine زمانی ارزش دارد که process طولانی، durable، قابل‌مشاهده و شامل کار انسانی، timer و retry باشد. مزیتش persistence و مدل‌کردن state است؛ هزینه‌اش runtime، نسخه‌بندی process، مهارت و integration است. یک flow کوتاه و synchronous ممکن است application service ساده‌تری بخواهد.

## طراحی activity امن برای retry

Activityی که engine پس از crash دوباره اجرا می‌کند باید idempotent یا دارای اثر قابل‌استعلام باشد. قبل از invoke شناسهٔ کسب‌وکار و correlation ID بده؛ timeout نتیجهٔ نامعلوم می‌سازد؛ وضعیت بیرونی را بخوان یا با idempotency key همان عمل را تکرار کن. Retry روی side effect غیرقابل‌تکرار ممکن است خرید/پرداخت دوگانه بسازد.

## state، version و human task

دادهٔ لازم برای ادامهٔ process، نسخهٔ definition، timer و تاریخچهٔ transition باید durable باشد. human task شامل actor یا گروه، مجوز، deadline، reminder، escalation و audit است. نسخهٔ جدید process را با instanceهای جاری سازگار کن; migration script، continue-old-version یا explicit mapping لازم می‌شود.

## Compensation و بازیابی

Saga/workflow ممکن است مرحله‌ای را جبران کند، مثلاً reservation را آزاد کند; جبران تضمین rollback اتمی نیست، ممکن است نیاز به اپراتور یا reconciliation داشته باشد. بنویس کدام failure retry می‌شود، کدام به compensation می‌رود، کدام به manual review و کدام process را متوقف می‌کند.

## آزمون

۱. workflow طولانی چه چیزی باید پایدار کند؟ **پاسخ:** state مرحله‌ها، ورودی‌ها، زمان‌بندی و تاریخچهٔ اجرا.
۲. چرا business rule را در workflow script انباشته نمی‌کنیم؟ **پاسخ:** مالکیت و آزمون منطق دامنه دشوار می‌شود.
۳. compensation چه نقشی دارد؟ **پاسخ:** اثر مرحلهٔ موفق قبلی را با عملیات معکوس/جبرانی مدیریت می‌کند.
۴. process versioning چه ریسکی دارد؟ **پاسخ:** instance قدیمی با تعریف جدید ناسازگار شود.

## تمرین

فرایند تأیید خرید را با manager approval، بودجه، timeout و لغو مدل کن. state پایدار و رفتار در شکست هر activity را مشخص کن.

## پاسخ نمونهٔ تمرین

Stateها: Submitted، PendingBudget، PendingManager، Approved، Rejected، Cancelled. بودجه check با نسخهٔ policy؛ manager task actor, deadline, escalation و audit دارد. Activityها idempotent/قابل‌استعلام‌اند. timeout approval escalates یا policy-defined auto-reject؛ cancel پیش از commit آزاد می‌کند؛ پس از side effect compensation workflow اجرا می‌شود. state و version definition durable است.

## منابع

- فارسی: [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)، [مهندسی فرایند در نقشهٔ Software Architect](https://roadmap.sh/software-architect)
- انگلیسی: [IBM Business Automation Workflow](https://www.ibm.com/products/business-automation-workflow)، [IBM Documentation](https://www.ibm.com/docs/)

</div>

