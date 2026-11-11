<div dir="rtl" align="right">

# ESB، BPM و BPEL

ESB در معماری سازمانی برای انتقال و گاهی تبدیل پیام میان سامانه‌ها به‌کار رفته است. اگر routing، mapping و منطق کسب‌وکار بیش از اندازه در bus جمع شود، ESB به گلوگاه و نقطهٔ تغییر مرکزی بدل می‌شود. integration platform جایگزین تعیین مالک داده و قرارداد سرویس نیست.

BPM فرایند کسب‌وکار را مدل، اجرا و پایش می‌کند؛ BPEL زبان اجرایی orchestration فرایندهای سرویس‌محور است. وقتی فرایند طولانی، قابل‌پیکربندی و در معرض کار انسانی است، workflow engine می‌تواند وضعیت مرحله‌ها و زمان‌بندی را از منطق پراکنده جدا کند. برای چند فراخوانی ساده، engine بزرگ ممکن است بار اضافه باشد.

## مثال

صدور بیمه‌نامه شامل بررسی متقاضی، ارزیابی ریسک، پرداخت و تأیید انسانی است. workflow state هر مرحله و timeout را نگه می‌دارد؛ activityهای business از طریق قرارداد اجرا می‌شوند. اگر پرداخت موفق و مرحلهٔ بعد شکست بخورد، فرایند باید retry یا compensation داشته باشد.

## درس گام‌به‌گام: workflow بازپرداخت

۱. درخواست بازپرداخت ثبت می‌شود و شناسهٔ process پایدار می‌گیرد.
۲. workflow state فرایند را نگه می‌دارد و eligibility را از مالک دامنه می‌پرسد.
۳. اگر بررسی انسانی لازم باشد، task با actor، deadline، مجوز و audit ساخته می‌شود؛ فرایند ممکن است ساعت‌ها یا روزها suspend بماند.
۴. پس از تأیید، activity provider را صدا می‌زند. timeout نتیجه را مبهم می‌کند؛ status را استعلام یا idempotency key استفاده کن.
۵. اگر مرحلهٔ بعد شکست بخورد، compensation مانند cancel/rescind تعریف می‌شود؛ جبران لزوماً اثر را کاملاً پاک نمی‌کند.
۶. نتیجهٔ نهایی event می‌شود؛ retry، cancel، timeout و مداخلهٔ operator قابل‌مشاهده‌اند.

## چه چیزی را در BPMN نشان دهیم؟

Pool یا participant مالکیت را جدا می‌کند؛ lane نقش یا سیستم را؛ task فعالیت را؛ gateway مسیر شرطی یا هم‌زمانی را؛ event شروع، پیام، timer یا پایان را. نمودار باید برای کسب‌وکار خوانا بماند و بی‌جهت به یک engine اجرایی گره نخورد.

## متمرکزسازی ESB چه زمانی مشکل می‌شود؟

Bus برای protocol adaptation، routing و mediation مفید است. اما business decision مرکزی، database مشترک و منطق تغییر در bus، تیم‌ها را به release مرکزی وابسته می‌کند. مالک داده، schema، policy خطا و مسئول adapter را مشخص کن. orchestration مرکزی visibility می‌دهد ولی coupling می‌سازد؛ choreography استقلال می‌دهد ولی فهم جریان end-to-end را سخت می‌کند.

## نسخه‌بندی فرایند

فرایند درحال‌اجرا ممکن است با definition قدیمی ادامه دهد یا به نسخهٔ جدید منتقل شود؛ engine تعیین‌کننده است. migration instance، backward compatibility و rollback را پیش از تغییر تعریف کن. timer و retry دائمی instance را بی‌نهایت زنده می‌کند؛ timeout کلی و مسیر مداخله لازم است.

## آزمون

۱. ESB چه زمانی خطرناک می‌شود؟ **پاسخ:** وقتی همهٔ policy و منطق دامنه را متمرکز و تیم‌ها را وابسته کند.
۲. BPMN چه چیزی را روشن می‌کند؟ **پاسخ:** جریان، actor، gateway تصمیم و فعالیت فرایند به زبان قابل‌گفت‌وگو.
۳. workflow طولانی چه چیزی می‌خواهد؟ **پاسخ:** persistence، timeout، retry، versioning و compensation.
۴. BPEL برای هر سیستم تازه لازم است؟ **پاسخ:** خیر؛ تنها در زمینه‌ای که اکوسیستم و قراردادهایش آن را توجیه می‌کنند.

## تمرین

فرایند بازپرداختی با تأیید دستی را ترسیم کن و نقطه‌های retry، timeout، cancel و compensation را علامت بزن.

## پاسخ نمونهٔ تمرین

Workflow در PendingApproval می‌رود؛ timer reminder/escalation دارد؛ approval مجاز به WaitingPayment می‌برد؛ رد یا cancel پیش از پرداخت به Cancelled؛ provider timeout وضعیت Unknown را نگه می‌دارد و query/retry idempotent می‌کند؛ پرداخت موفق به Refunding/Refunded می‌رسد. اگر رزرو موجودی قبلاً گرفته شده، cancellation آن را release می‌کند. Compensation جدا از rollback اتمی است.

## منابع

- فارسی: [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)، [نقشهٔ Software Architect](https://roadmap.sh/pdfs/roadmaps/software-architect.pdf)
- انگلیسی: [Camunda BPMN reference](https://docs.camunda.org/manual/latest/reference/bpmn20/)، [OASIS BPEL standard](https://docs.oasis-open.org/wsbpel/2.0/OS/wsbpel-v2.0-OS.html)، [Azure Integration Services](https://learn.microsoft.com/en-us/azure/integration-services/)

</div>
